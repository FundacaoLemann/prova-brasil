<?php
ini_set('memory_limit', '4G');
$file = "/Users/rb/eja.csv";
$handle = fopen($file, 'r');

$info = array();

while(($data = fgetcsv($handle, 0, ",")) !== false) {
    /* $data[0] = school id
       $data[1] = school IBGE id
       $data[2] = matriculas_count
     */

    echo "UPDATE we_school_educacenso SET matriculas_eja = {$data[2]} WHERE school_id = {$data[0]};" . PHP_EOL;
}