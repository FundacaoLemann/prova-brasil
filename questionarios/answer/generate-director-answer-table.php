<?php

$options = getopt('t:f:s:');


$tableName  = $options['t'];
$file       = $options['f'];

$row = 0;
$output = '';

$handle = fopen($file, "r");

while (($data = fgetcsv($handle, 5000, ",")) !== false) {

    $row++;

    // CREATE TABLE
    if (is_header_line($row)) {
        $tableDefinition = create_table_definition($data, $tableName);
        $output .= $tableDefinition . PHP_EOL;
        continue;
    }

    // INSERT ROWS
    $answerInsertSql = "INSERT INTO `{$tableName}` SELECT
(SELECT
    waitress_entities.state.id as 'state_id' FROM waitress_entities.state
    WHERE waitress_entities.state.ibge_id = {$data[1]}
) as 'state_id',
waitress_entities.city.id as 'city_id',
{$data[4]},
{$data[6]},
'" . implode("','", $data) . "'
FROM
waitress_entities.city
WHERE
waitress_entities.city.ibge_id = {$data[2]}
;";

    $output .= $answerInsertSql . PHP_EOL;

    $row++;
}

$filename = sprintf('%s.sql', $tableName);

file_put_contents($filename, $output);

fclose($handle);

/**
 * Others functions
 */

function is_header_line ($row) {
    return $row === 1;
}

function create_table_definition($data, $tableName) {

    $fieldDefinitions = [];

    foreach ($data as $value) {
        $fieldDefinition[] = "`{$value}` TEXT DEFAULT NULL";
    }

    $fieldFromCvs = implode(",".PHP_EOL, $fieldDefinition);

    $createTableSql = "CREATE TABLE `{$tableName}` (
`state_id`      BIGINT(20) DEFAULT NULL,
`city_id`       BIGINT(20) DEFAULT NULL,
`dependence_id` BIGINT(20) DEFAULT NULL,
`is_filled`     BIGINT(20) DEFAULT NULL,
{$fieldFromCvs},
  KEY `key_state_id` (`state_id`),
  KEY `key_city_id` (`city_id`),
  KEY `key_dependence_id` (`dependence_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;";

    return $createTableSql;
}
