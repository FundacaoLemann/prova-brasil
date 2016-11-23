START TRANSACTION;

INSERT INTO waitress_dw_prova_brasil.dim_regional_aggregation
SELECT
    NULL AS id,
    s.state_id,
    s.city_id,
    0 AS school_id,
    0 AS team_id,
    0 AS city_group_id
FROM aggregation_students AS s
LEFT JOIN waitress_dw_prova_brasil.dim_regional_aggregation AS dra on dra.school_id = 0 and dra.city_id = s.city_id and dra.state_id = s.state_id
WHERE dra.id IS NULL AND s.city_id<>0 AND s.city_id IS NOT NULL
GROUP BY s.city_id;

INSERT INTO waitress_dw_prova_brasil.dim_regional_aggregation
SELECT
    NULL AS id,
    s.state_id,
    s.city_id,
    s.school_id,
    0 AS team_id,
    0 AS city_group_id
FROM aggregation_students AS s
LEFT JOIN waitress_dw_prova_brasil.dim_regional_aggregation AS dra on dra.school_id = s.school_id and dra.city_id = s.city_id and dra.state_id = s.state_id
WHERE dra.id IS NULL AND s.school_id<>0 AND s.school_id IS NOT NULL
GROUP BY s.school_id;

COMMIT;