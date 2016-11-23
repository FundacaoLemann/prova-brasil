START TRANSACTION;
-- Atualiza médias
UPDATE aggregation_tmp AS a 
SET 
    a.average = (SELECT 
            IF(a.grade_id = 5,
                    IF(a.discipline_id = 1,
                        r.media_5EF_LP,
                        r.media_5EF_MT),
                    IF(a.discipline_id = 1,
                        r.media_9EF_LP,
                        r.media_9EF_MT)) AS media
        FROM
            resultados_municipios AS r
        WHERE
            r.dependence_id = a.dependence_id
                AND r.localization_id = a.localization_id
                AND r.ibge_id = a.ID_MUNICIPIO
        )
WHERE
    a.needs_to_be_from_sheet=1;

-- Atualiza level_quantitative e level_qualitative apos a atualizacao das medias
UPDATE aggregation_tmp AS a SET 
    level_quantitative=(SELECT l.level_quantitative FROM level AS l WHERE l.discipline_id=a.discipline_id AND l.grade_id=a.grade_id AND l.min <= a.average AND l.max > a.average),
    level_qualitative=(SELECT l.level_qualitative FROM level AS l WHERE l.discipline_id=a.discipline_id AND l.grade_id=a.grade_id AND l.min <= a.average AND l.max > a.average)
WHERE a.ID_ESCOLA_ALUNO=0 AND a.ID_MUNICIPIO<>0 AND a.state_id<>0;
COMMIT;