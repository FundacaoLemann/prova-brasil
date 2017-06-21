<?php
ini_set('memory_limit', '4G');
$file = "/Users/rb/matriculas.csv";
$handle = fopen($file, 'r');

while(($data = fgetcsv($handle, 0, ",")) !== false) {
    /* $data[0] = school id
       $data[1] = school IBGE id
       $data[2] = TP_ETAPA_ENSINO
       $data[3] = matriculas_count */

        $etapa_ensino = $data[2];
        $coluna = defineSerieColumn($etapa_ensino);
        $school_id = $data[0];
        $matriculas_count = $data[3];
        echo "UPDATE we_school_educacenso weseA JOIN we_school_educacenso weseB ON weseA.id = weseB.id SET weseA.{$coluna} = ({$matriculas_count} + weseB.{$coluna}) WHERE weseA.educacenso = 2016 AND weseA.school_id = {$school_id};" . PHP_EOL;
        }

function defineSerieColumn($id_serie) {
    switch ((int) $id_serie) {
        case 1:
            return "matriculas_creche";
        case 2:
            return "matriculas_pre_escolar";
        case 4:
            return "matriculas_2ano";
        case 5:
            return "matriculas_3ano";
        case 6:
            return "matriculas_4ano";
        case 7:
            return "matriculas_5ano";
        case 8:
            return "matriculas_6ano";
        case 9:
            return "matriculas_7ano";
        case 10:
            return "matriculas_8ano";
        case 11:
            return "matriculas_9ano";
        case 14:
            return "matriculas_1ano";
        case 15:
            return "matriculas_2ano";
        case 16:
            return "matriculas_3ano";
        case 17:
            return "matriculas_4ano";
        case 18:
            return "matriculas_5ano";
        case 19:
            return "matriculas_6ano";
        case 20:
            return "matriculas_7ano";
        case 21:
            return "matriculas_8ano";
        case 25:
            return "matriculas_em_1ano";
        case 26:
            return "matriculas_em_2ano";
        case 27:
            return "matriculas_em_3ano";
        case 28:
            return "matriculas_em_outros";
        case 29:
            return "matriculas_em_outros";
        case 30:
            return "matriculas_em_outros";
        case 31:
            return "matriculas_em_outros";
        case 32:
            return "matriculas_em_outros";
        case 33:
            return "matriculas_em_outros";
        case 34:
            return "matriculas_em_outros";
        case 35:
            return "matriculas_em_outros";
        case 36:
            return "matriculas_em_outros";
        case 37:
            return "matriculas_em_outros";
        case 38:
            return "matriculas_em_outros";
        case 41:
            return "matriculas_9ano";

        default:
            return;
        }
}