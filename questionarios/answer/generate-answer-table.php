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
waitress_entities.state.id as 'state_id',
waitress_entities.city.id as 'city_id',
{$data[4]},
{$data[6]},
'" . implode("','", $data) . "'
FROM 
waitress_entities.city,
waitress_entities.state
WHERE 
waitress_entities.city.ibge_id = {$data[2]} AND
waitress_entities.state.ibge_id = {$data[1]}
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
`state_id`      TEXT DEFAULT NULL,
`city_id`       TEXT DEFAULT NULL,
`dependence_id` TEXT DEFAULT NULL,
`is_filled`     TEXT DEFAULT NULL,
{$fieldFromCvs}
) ENGINE=InnoDB DEFAULT CHARSET=utf8;";

    return $createTableSql;
}
