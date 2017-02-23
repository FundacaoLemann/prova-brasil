START TRANSACTION;

CREATE TABLE IF NOT EXISTS `resultados_municipios_tmp` (
	`estado` TINYTEXT NULL,
	`municipio` TINYTEXT NULL,
	`ibge_id` INT(11) NULL DEFAULT NULL,
	`dependencia_adm` TINYTEXT NULL,
	`dependence_id` INT(2) NULL DEFAULT NULL,
	`localizacao` TINYTEXT NULL,
	`localization_id` INT(2) NULL DEFAULT NULL,
	`MEDIA_5EF_LP` DOUBLE NULL DEFAULT NULL,
	`MEDIA_5EF_MT` DOUBLE NULL DEFAULT NULL,
	`MEDIA_9EF_LP` DOUBLE NULL DEFAULT NULL,
	`MEDIA_9EF_MT` DOUBLE NULL DEFAULT NULL,
	`ate_nivel_1_LP5` DOUBLE NULL DEFAULT NULL,
	`nivel_2_LP5` DOUBLE NULL DEFAULT NULL,
	`nivel_3_LP5` DOUBLE NULL DEFAULT NULL,
	`nivel_4_LP5` DOUBLE NULL DEFAULT NULL,
	`nivel_5_LP5` DOUBLE NULL DEFAULT NULL,
	`nivel_6_LP5` DOUBLE NULL DEFAULT NULL,
	`nivel_7_LP5` DOUBLE NULL DEFAULT NULL,
	`nivel_8_LP5` DOUBLE NULL DEFAULT NULL,
	`nivel_9_LP5` DOUBLE NULL DEFAULT NULL,
	`nivel_0_MT5` DOUBLE NULL DEFAULT NULL,
	`nivel_1_MT5` DOUBLE NULL DEFAULT NULL,
	`nivel_2_MT5` DOUBLE NULL DEFAULT NULL,
	`nivel_3_MT5` DOUBLE NULL DEFAULT NULL,
	`nivel_4_MT5` DOUBLE NULL DEFAULT NULL,
	`nivel_5_MT5` DOUBLE NULL DEFAULT NULL,
	`nivel_6_MT5` DOUBLE NULL DEFAULT NULL,
	`nivel_7_MT5` DOUBLE NULL DEFAULT NULL,
	`nivel_8_MT5` DOUBLE NULL DEFAULT NULL,
	`nivel_9_MT5` DOUBLE NULL DEFAULT NULL,
	`nivel_10_MT5` DOUBLE NULL DEFAULT NULL,
	`nivel_0_LP9` DOUBLE NULL DEFAULT NULL,
	`nivel_1_LP9` DOUBLE NULL DEFAULT NULL,
	`nivel_2_LP9` DOUBLE NULL DEFAULT NULL,
	`nivel_3_LP9` DOUBLE NULL DEFAULT NULL,
	`nivel_4_LP9` DOUBLE NULL DEFAULT NULL,
	`nivel_5_LP9` DOUBLE NULL DEFAULT NULL,
	`nivel_6_LP9` DOUBLE NULL DEFAULT NULL,
	`nivel_7_LP9` DOUBLE NULL DEFAULT NULL,
	`nivel_8_LP9` DOUBLE NULL DEFAULT NULL,
	`nivel_0_MT9` DOUBLE NULL DEFAULT NULL,
	`nivel_1_MT9` DOUBLE NULL DEFAULT NULL,
	`nivel_2_MT9` DOUBLE NULL DEFAULT NULL,
	`nivel_3_MT9` DOUBLE NULL DEFAULT NULL,
	`nivel_4_MT9` DOUBLE NULL DEFAULT NULL,
	`nivel_5_MT9` DOUBLE NULL DEFAULT NULL,
	`nivel_6_MT9` DOUBLE NULL DEFAULT NULL,
	`nivel_7_MT9` DOUBLE NULL DEFAULT NULL,
	`nivel_8_MT9` DOUBLE NULL DEFAULT NULL,
	`nivel_9_MT9` DOUBLE NULL DEFAULT NULL,
	UNIQUE INDEX `dependence_id` (`dependence_id`, `localization_id`, `ibge_id`) USING BTREE
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;

INSERT INTO resultados_municipios_tmp SELECT 
	t.estado AS `estado`,
	t.municipio AS `municipio`,
	NULL AS `ibge_id`,
	t.dependencia_adm AS `dependencia_adm`,
	NULL AS `dependence_id`,
	t.localizacao AS `localizacao`,
	NULL AS `localization_id`,
	t.MEDIA_5EF_LP AS `MEDIA_5EF_LP`,
	t.MEDIA_5EF_MT AS `MEDIA_5EF_MT`,
	t.MEDIA_9EF_LP AS `MEDIA_9EF_LP`,
	t.MEDIA_9EF_MT AS `media_9ef_MT`,
	t.ate_nivel_1_LP5 AS `ate_nivel_1_LP5`,
	t.nivel_2_LP5 AS `nivel_2_LP5`,
	t.nivel_3_LP5 AS `nivel_3_LP5`,
	t.nivel_4_LP5 AS `nivel_4_LP5`,
	t.nivel_5_LP5 AS `nivel_5_LP5`,
	t.nivel_6_LP5 AS `nivel_6_LP5`,
	t.nivel_7_LP5 AS `nivel_7_LP5`,
	t.nivel_8_LP5 AS `nivel_8_LP5`,
	t.nivel_9_LP5 AS `nivel_9_LP5`,
	t.nivel_0_MT5 AS `nivel_0_MT5`,
	t.nivel_1_MT5 AS `nivel_1_MT5`,
	t.nivel_2_MT5 AS `nivel_2_MT5`,
	t.nivel_3_MT5 AS `nivel_3_MT5`,
	t.nivel_4_MT5 AS `nivel_4_MT5`,
	t.nivel_5_MT5 AS `nivel_5_MT5`,
	t.nivel_6_MT5 AS `nivel_6_MT5`,
	t.nivel_7_MT5 AS `nivel_7_MT5`,
	t.nivel_8_MT5 AS `nivel_8_MT5`,
	t.nivel_9_MT5 AS `nivel_9_MT5`,
	t.nivel_10_MT5 AS `nivel_10_MT5`,
	t.nivel_0_LP9 AS `nivel_0_LP9`,
	t.nivel_1_LP9 AS `nivel_1_LP9`,
	t.nivel_2_LP9 AS `nivel_2_LP9`,
	t.nivel_3_LP9 AS `nivel_3_LP9`,
	t.nivel_4_LP9 AS `nivel_4_LP9`,
	t.nivel_5_LP9 AS `nivel_5_LP9`,
	t.nivel_6_LP9 AS `nivel_6_LP9`,
	t.nivel_7_LP9 AS `nivel_7_LP9`,
	t.nivel_8_LP9 AS `nivel_8_LP9`,
	t.nivel_0_MT9 AS `nivel_0_MT9`,
	t.nivel_1_MT9 AS `nivel_1_MT9`,
	t.nivel_2_MT9 AS `nivel_2_MT9`,
	t.nivel_3_MT9 AS `nivel_3_MT9`,
	t.nivel_4_MT9 AS `nivel_4_MT9`,
	t.nivel_5_MT9 AS `nivel_5_MT9`,
	t.nivel_6_MT9 AS `nivel_6_MT9`,
	t.nivel_7_MT9 AS `nivel_7_MT9`,
	t.nivel_8_MT9 AS `nivel_8_MT9`,
	t.nivel_9_MT9 AS `nivel_9_MT9`
FROM resultados_municipios AS t;

DROP TABLE resultados_municipios;
RENAME TABLE resultados_municipios_tmp TO resultados_municipios;

UPDATE resultados_municipios SET estado='Tocantins' WHERE estado='Tocantis';

UPDATE resultados_municipios SET municipio='SAO DOMINGOS DE POMBAL' WHERE estado='Paraíba' AND municipio='SAO DOMINGOS';

UPDATE resultados_municipios SET municipio='BELEM DE SAO FRANCISCO' WHERE estado='Pernambuco' AND municipio='BELEM DO SAO FRANCISCO';

UPDATE resultados_municipios SET municipio='LAGOA DO ITAENGA' WHERE estado='Pernambuco' AND municipio='LAGOA DE ITAENGA';

UPDATE resultados_municipios SET municipio='PARATI' WHERE estado='Rio de Janeiro' AND municipio='PARATY';

UPDATE resultados_municipios SET municipio='TRAJANO DE MORAIS' WHERE estado='Rio de Janeiro' AND municipio='TRAJANO DE MORAES';

UPDATE resultados_municipios SET municipio='EMBU' WHERE estado='São Paulo' AND municipio='EMBU DAS ARTES';

UPDATE resultados_municipios SET municipio='SAO VALERIO DA NATIVIDADE' WHERE estado='Tocantins' AND municipio='SAO VALERIO';

UPDATE resultados_municipios SET municipio='COUTO DE MAGALHAES' WHERE estado='Tocantins' AND municipio='COUTO MAGALHAES';

UPDATE resultados_municipios AS r INNER JOIN waitress_entities.state AS s 
ON s.name = r.estado
 LEFT JOIN waitress_entities.city AS c ON c.name_standard=REPLACE(REPLACE(r.municipio,'D ', 'D'), 'SANT ANA', 'SANTANA') AND c.state_id=s.id
 SET r.ibge_id=c.ibge_id;
 
UPDATE resultados_municipios AS r INNER JOIN waitress_entities.state AS s 
ON s.name = r.estado
 LEFT JOIN waitress_entities.city AS c ON c.name_standard=REPLACE(r.municipio,'-D',' D') AND c.state_id=s.id
 SET r.ibge_id=c.ibge_id
 WHERE r.ibge_id IS NULL;
 
 UPDATE resultados_municipios AS r INNER JOIN waitress_entities.state AS s 
ON s.name = r.estado
 LEFT JOIN waitress_entities.city AS c ON c.name_standard=REPLACE(REPLACE(r.municipio,'D ', 'D'),'-D',' D') AND c.state_id=s.id
 SET r.ibge_id=c.ibge_id
 WHERE r.ibge_id IS NULL;
 
UPDATE resultados_municipios AS r INNER JOIN waitress_entities.state AS s 
ON s.name = r.estado
 LEFT JOIN waitress_entities.city AS c ON c.name=r.municipio AND c.state_id=s.id
 SET r.ibge_id=c.ibge_id
 WHERE r.ibge_id IS NULL;
 
 
-- SELECT DISTINCT municipio, estado FROM resultados_municipios WHERE ibge_id IS NULL;

UPDATE resultados_municipios SET dependence_id=(SELECT id FROM waitress_entities.dependence WHERE name=dependencia_adm);
UPDATE resultados_municipios SET dependence_id=0 WHERE dependencia_adm='Total - Federal, Estadual e Municipal';


UPDATE resultados_municipios SET localization_id=(SELECT id FROM waitress_entities.localization WHERE name=localizacao);
COMMIT;