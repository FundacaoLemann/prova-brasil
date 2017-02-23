START TRANSACTION;
UPDATE aggregation_tmp AS a
SET
    needs_to_be_from_sheet=1
WHERE
    a.ID_ESCOLA_ALUNO = 0
        AND a.ID_MUNICIPIO <> 0
        AND ROUND(a.average, 2) <> (SELECT
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
    AND (SELECT
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
            AND r.ibge_id = a.ID_MUNICIPIO) IS NOT NULL;
COMMIT;