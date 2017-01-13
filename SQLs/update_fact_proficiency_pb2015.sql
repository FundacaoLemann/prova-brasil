/**
 Devido a nova regra de importação em para a prova brasil 2015, criamos esse step

 A regra diz que devemos considerar todas as escolas (através do id de localização)
 em apenas 3 casos:
 Brasil - 5o ano
 Estado - 5o ano 
 Cidade - 5o ano
*/

/**
 * Passo 1. Dupliquei a base com os dados de `dependence_id = 0` and `localization_id = 0`
 * para poder recuperar os dados de Brasil 5 ano que usam os filtros com os dados de escolas rurais.
 * Essa tabela foi duplicada em para outra chamada `fact_proficiency_before_update`.
 */

/**
 * Passo 2. Selecionei os registros urbanos (`localization_id=1`) que já estavam na base
 * original os dupliquei em outra tabela chamada `fact_proficiency_urban`.
 * Essa é a query.
 */
INSERT INTO fact_proficiency_urban
SELECT
pu.*
FROM fact_proficiency pu
JOIN dim_regional_aggregation dra ON dra.id = pu.dim_regional_aggregation_id
JOIN dim_politic_aggregation dpa ON dpa.id = pu.dim_politic_aggregation_id
WHERE
dpa.edition_id = 6
AND 
dpa.dependence_id IN (0,2,3)
AND
dpa.localization_id = 1
AND
dra.school_id = 0
ORDER BY
city_id, state_id
;

/**
 * Passo 3. Com os dados duplicados, utilizei a função getDimPoliticAggregation para atualizar os
 * registro que eram de areas urbanas `localization_id =1` para total `localiztion_id =0` modificando
 * o `dim_politic_aggregation_id`.
 */
UPDATE fact_proficiency_urban u
JOIN dim_politic_aggregation dpa ON dpa.id = u.dim_politic_aggregation_id
SET u.dim_politic_aggregation_id = 
getDimPoliticAggregation(6, dpa.dependence_id, 0, dpa.grade_id, dpa.discipline_id)
;

/**
 * Passo 4. Verifiquei os registro modificados com a query abaixo. Ela serve apenas como consulta para
 * verificar se os dados estão de fato batendo com as planilhas oficiais do INEP.
 */
SELECT
st.name estado,
ct.name cidade,
d.name dependencia,
l.name localizacao,
dpa.grade_id,
dc.name disciplina,
-- NEW
u.average AS 'NEW',
-- OLD
p.average AS 'OLD'
FROM fact_proficiency_urban u
JOIN fact_proficiency p ON p.dim_politic_aggregation_id = u.dim_politic_aggregation_id AND p.dim_regional_aggregation_id = u.dim_regional_aggregation_id
JOIN dim_regional_aggregation dra ON dra.id = p.dim_regional_aggregation_id
JOIN dim_politic_aggregation dpa ON dpa.id = p.dim_politic_aggregation_id
JOIN waitress_entities.state st ON st.id = dra.state_id
LEFT JOIN waitress_entities.city ct ON ct.id = dra.city_id
JOIN waitress_entities.dependence d ON d.id = dpa.dependence_id
JOIN waitress_entities.localization l ON l.id = dpa.localization_id
JOIN waitress_entities.discipline dc ON dc.id = dpa.discipline_id
WHERE
dra.state_id = 125 
-- AND 
-- dra.city_id = 0
-- AND
-- ct.ibge_id = '3525904'
AND
dpa.grade_id = 5
AND 
dpa.discipline_id = 2
ORDER BY 
dra.city_id, dra.state_id, dpa.dependence_id
;


/**
 * Passo 5. Com o `dim_politic_aggregation_id` atualizado, foi possivel realizar o join com a tabela 
 * original de proficiencia e realizar o update com os novos valores de `localization_id = 1`.
 */

UPDATE  fact_proficiency p
JOIN fact_proficiency_urban u ON p.dim_politic_aggregation_id = u.dim_politic_aggregation_id AND p.dim_regional_aggregation_id = u.dim_regional_aggregation_id
SET 
p.enrolled = u.enrolled,
p.presents = u.presents,
p.with_proficiency = u.with_proficiency,
p.with_proficiency_weight = u.with_proficiency_weight,
p.average = u.average,
p.level_quantitative = u.level_quantitative,
p.level_qualitative = u.level_qualitative,
p.level_optimal = u.level_optimal,
p.qualitative_0 = u.qualitative_0,
p.qualitative_1 = u.qualitative_1,
p.qualitative_2 = u.qualitative_2,
p.qualitative_3 = u.qualitative_3;

/**
 * Passo 6. Fiz a troca dos dados de Brasil 5 ano que estavam corretas, utilizando a `fact_proficiency_before_update`.
 */
UPDATE fact_proficiency p
JOIN fact_proficiency_before_update u ON p.dim_politic_aggregation_id = u.dim_politic_aggregation_id AND p.dim_regional_aggregation_id = u.dim_regional_aggregation_id
JOIN dim_regional_aggregation dra ON dra.id = p.dim_regional_aggregation_id
JOIN dim_politic_aggregation dpa ON dpa.id = p.dim_politic_aggregation_id
SET 
p.enrolled = u.enrolled,
p.presents = u.presents,
p.with_proficiency = u.with_proficiency,
p.with_proficiency_weight = u.with_proficiency_weight,
p.average = u.average,
p.level_quantitative = u.level_quantitative,
p.level_qualitative = u.level_qualitative,
p.level_optimal = u.level_optimal,
p.qualitative_0 = u.qualitative_0,
p.qualitative_1 = u.qualitative_1,
p.qualitative_2 = u.qualitative_2,
p.qualitative_3 = u.qualitative_3
WHERE
dpa.edition_id = 6
and
dra.state_id = 100 
AND
dpa.grade_id = 5
AND
dpa.dependence_id = 0
AND
dpa.localization_id = 0;