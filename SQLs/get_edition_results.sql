SELECT  
dra.id,
st.acronym UF,
st.name Estado,
c.name Cidade,
c.ibge_id,
d.name Dependência,
dis.name Matéria,
dpa.grade_id Ano,
IF(p.disclosure = 1, p.enrolled, NULL) Matrículados,
IF(p.disclosure = 1, p.presents, NULL) Presentes,
IF(p.disclosure = 1, ROUND(p.qualitative_3), NULL) qtde_avancado,
IF(p.disclosure = 1, ROUND(p.qualitative_2), NULL) qtde_proficiente,
IF(p.disclosure = 1, ROUND(p.qualitative_1), NULL) qtde_basico,
IF(p.disclosure = 1, ROUND(p.qualitative_0), NULL) qtde_insuficiente,
IF(p.disclosure = 1, ROUND(p.level_optimal), NULL) qtde_possui_proficiencia,
IF(p.disclosure <> 1, ROUND(p.qualitative_3), ((ROUND(p.qualitative_3)*100)/p.enrolled)) percent_avancado,
IF(p.disclosure <> 1, ROUND(p.qualitative_2), ((ROUND(p.qualitative_2)*100)/p.enrolled)) percent_proficiente,
IF(p.disclosure <> 1, ROUND(p.qualitative_1), ((ROUND(p.qualitative_1)*100)/p.enrolled)) percent_basico,
IF(p.disclosure <> 1, ROUND(p.qualitative_0), ((ROUND(p.qualitative_0)*100)/p.enrolled)) percent_insuficiente,
IF(p.disclosure <> 1, ROUND(p.level_optimal), ((ROUND(p.qualitative_3)*100)/p.enrolled) + ((ROUND(p.qualitative_2)*100)/p.enrolled)) percent_possui_proficiencia,
p.average Média,
CASE p.disclosure 
	WHEN 1 THEN 'resultado divulgado'
	WHEN 2 THEN 'não divulgado ter menos de 50% de taxa de participação'
	WHEN 3 THEN 'não divulgado por solicitação'
	WHEN 4 THEN 'dados parciais (sem número de presentes nem matriculados)'
END AS 'Divulgação'	
-- p.* ,
-- dra.*,
-- dpa.*
FROM fact_proficiency p
JOIN dim_politic_aggregation dpa  ON dpa.id = p.dim_politic_aggregation_id
JOIN dim_regional_aggregation dra ON dra.id = p.dim_regional_aggregation_id
JOIN waitress_entities.state st ON st.id = dra.state_id
JOIN waitress_entities.dependence d ON d.id = dpa.dependence_id
JOIN waitress_entities.discipline dis ON dis.id = dpa.discipline_id
JOIN waitress_entities.localization l ON l.id = dpa.localization_id
LEFT JOIN waitress_entities.city c ON c.id = dra.city_id
WHERE
dpa.edition_id = 6
-- AND
-- Nao tras cidades
-- dra.city_id = 0
AND
-- nao tras escolas
dra.school_id = 0
AND
-- nao tras grupos de cidades
dra.city_group_id = 0
AND
-- somente total, nao difere entre rural e urbana
dpa.localization_id = 0
AND
-- dependencias
-- 0 = total
-- 1 = federeal
-- 2 = estadual
-- 3 = municiapal
-- 4 = particular
-- 5 = publico
dpa.dependence_id NOT IN(1, 4)
ORDER BY c.id, st.id, c.name, d.id, dis.id, dpa.grade_id;