<?php
/**
 * This file is part of the QEdu project.
 *
 * @link https://github.com/Meritts/qedu
 * @copyright Copyright (c) 2014 Meritt Informação Educacional (http://www.meritt.com.br)
 * @license Proprietary
 */

require("vendor/autoload.php");
date_default_timezone_set('America/Sao_Paulo');
set_time_limit(0);
/** @var ProgressBar\Manager $progress */
$progress = null;
if (isCLI()) {
    $_POST = array();
    $key = null;
    foreach($_SERVER['argv'] as $arg) {
        if(strpos($arg, '--') === 0) {
            $key = substr($arg, 2);
        } elseif ($key) {
            $_POST[$key] = $arg;
            $key = null;
        }
    }
    if(empty($_POST)) {
        echo "php index.php --start-row <start_row> --end-row <end_row> --start-col <start_col> --end-col <end_col> --from <filename> --to <filename>\n";
        exit(1);
    }
}
else {
    if(isset($_FILES['from']) && is_uploaded_file($_FILES['from']['tmp_name'])) {
        if(move_uploaded_file($_FILES['from']['tmp_name'], 'uploads/'.$_FILES['from']['name'])){
            $_POST['from'] = 'uploads/'.$_FILES['from']['name'];
            $_POST['to'] = 'php://output';
        }
    }
    else {
        ?>
<form action="/" method="POST" enctype="multipart/form-data">
    <div style="width:100%; height: 50px; clear:both;">
        <div style="width: 49%; height: 50px; float:left;">
            Arquivo de entrada:
        </div>
        <div style="width: 49%; height: 50px; float:left;">
            <input type="file" name="from" />
        </div>
    </div>
    <div style="width:100%; height: 50px; clear:both;">
        <div style="width: 49%; height: 50px; float:left;">
            Linha Inicial:
        </div>
        <div style="width: 49%; height: 50px; float:left;">
            <input type="text" name="start-row" />
        </div>
    </div>
    <div style="width:100%; height: 50px; clear:both;">
        <div style="width: 49%; height: 50px; float:left;">
            Coluna Inicial:
        </div>
        <div style="width: 49%; height: 50px; float:left;">
            <input type="text" name="start-col" />
        </div>
    </div>
    <div style="width:100%; height: 50px; clear:both;">
        <div style="width: 49%; height: 50px; float:left;">
            Linha Final:
        </div>
        <div style="width: 49%; height: 50px; float:left;">
            <input type="text" name="end-row" />
        </div>
    </div>
    <div style="width:100%; height: 50px; clear:both;">
        <div style="width: 49%; height: 50px; float:left;">
            Coluna Final:
        </div>
        <div style="width: 49%; height: 50px; float:left;">
            <input type="text" name="end-col" />
        </div>
    </div>
    <div style="width:100%; height: 50px; clear:both;">
        <input type="submit" value="Enviar" />
    </div>
</form>
        <?php
        exit(0);
    }
}
/**
 * @param PHPExcel_Worksheet $sheet
 * @param int $start_row
 * @param int $start_col
 * @param int $end_row
 * @param int $end_col
 */
function adaptMergedCells(PHPExcel_Worksheet $sheet, $start_row, $start_col, $end_row, $end_col) {
    $mergedCells = $sheet->getMergeCells();
    for($row = $start_row; $row<=$end_row; ++$row) {
        for($column = $start_col; $column <= $end_col; ++$column) {
            $cell = $sheet->getCellByColumnAndRow($column, $row);
            $content = $cell->getValue();
            if (empty($content)) {
                continue;
            }
            foreach($mergedCells as $mergedCell) {
                if($cell->isInRange($mergedCell)) {
                    $otherCells = PHPExcel_Cell::extractAllCellReferencesInRange($mergedCell);
                    foreach($otherCells as $cellCode){
                        $otherCell = $sheet->getCell($cellCode);
                        $otherCell->setValue($content);
                    }
                    break;
                }
            }
        }
    }
}

/**
 * @param PHPExcel_Worksheet $sheet
 * @param int $start_row
 * @param int $start_col
 * @param int $end_row
 * @param int $end_col
 */
function unmergeAllRows(PHPExcel_Worksheet $sheet, $start_row, $start_col, $end_row, $end_col) {
    $mergedCells = $sheet->getMergeCells();
    foreach($mergedCells as $mergedCell) {
        $unmerge = false;
        for($row = $start_row; $row<=$end_row; ++$row) {
            for($column = $start_col; $column <= $end_col; ++$column) {
                $cell = $sheet->getCellByColumnAndRow($column, $row);
                if($cell->isInRange($mergedCell)) {
                    $unmerge = true;
                    break;
                }
            }
            if($unmerge) {
                break;
            }
        }
        if($unmerge) {
            $sheet->unmergeCells($mergedCell);
        }
    }
}

/**
 * @param PHPExcel_Worksheet $sheet
 * @param int $start_row
 * @param int $start_col
 * @param int $end_row
 * @param int $end_col
 */
function processMergedRows(PHPExcel_Worksheet $sheet, $start_row, $start_col, $end_row, $end_col) {
    adaptMergedCells($sheet, $start_row, $start_col, $end_row, $end_col);
    unmergeAllRows($sheet, $start_row, $start_col, $end_row, $end_col);
}

/**
 * @param array $headers
 * @param int $column
 * @param string $content
 * @return bool
 */
function canBePrefixed(array $headers, $column, $content) {
    return columnAlreadyExists($headers, $column) && !isAlreadyPrefixed($headers, $column, $content);
}

/**
 * @param array $headers
 * @param int $column
 * @return bool
 */
function columnAlreadyExists(array $headers, $column) {
    return array_key_exists($column, $headers);
}

/**
 * @param array $headers
 * @param int $column
 * @param string $content
 * @return bool
 */
function isAlreadyPrefixed(array $headers, $column, $content) {
    return strpos($headers[$column], $content) !== false;
}
/**
 * @param PHPExcel_Worksheet $sheet
 * @param int $start_row
 * @param int $start_col
 * @param int $end_row
 * @param int $end_col
 * @return array
 */
function getHeadersInSheet(PHPExcel_Worksheet $sheet, $start_row, $start_col, $end_row, $end_col) {
    $headers = array();
    for($row = $start_row; $row<=$end_row; ++$row) {
        for($column = $start_col; $column <= $end_col; ++$column) {
            $cell = $sheet->getCellByColumnAndRow($column, $row);
            $content =preg_replace('/\n+/', ' ', $cell->getValue());
            if (empty($content)) {
                continue;
            }
            if(canBePrefixed($headers, $column, $content)) {
                $headers[$column] = $headers[$column].' - '.$content;
            } elseif(columnAlreadyExists($headers, $column) === false) {
                $headers[$column] = $content;
            }
        }
    }
    return $headers;
}

/**
 * @param PHPExcel_Worksheet $sheet
 * @param int $start_row
 * @param int $end_row
 */
function removeExcedentRowsFromHeaders(PHPExcel_Worksheet $sheet, $start_row, $end_row) {
    $sheet->removeRow($start_row+1, $end_row-$start_row);
}
/**
 * @param PHPExcel_Worksheet $sheet
 * @param array $headers
 * @param int $start_row
 * @param int $end_row
 */
function fixHeadersInSheet(PHPExcel_Worksheet $sheet, array $headers, $start_row, $end_row){
    foreach($headers as $column=>$value){
        // Change row label
        $cell = $sheet->getCellByColumnAndRow($column, $start_row);
        $cell->setValue($headers[$column]);
    }
    removeExcedentRowsFromHeaders($sheet, $start_row, $end_row);
}

/**
 * @param PHPExcel $file
 * @param int $start_row
 * @param int $start_col
 * @param int $end_row
 * @param int $end_col
 * @return PHPExcel
 */
function processSheets(PHPExcel $file, $start_row, $start_col, $end_row, $end_col) {
    $nsheets = $file->getSheetCount();
    for($i=0; $i<$nsheets; ++$i) {
        $file->setActiveSheetIndex($i);
        $sheet = $file->getActiveSheet();
        processMergedRows($sheet, $start_row, $start_col, $end_row, $end_col);
        $headers = getHeadersInSheet($sheet, $start_row, $start_col, $end_row, $end_col);
        fixHeadersInSheet($sheet, $headers, $start_row, $end_row);
    }
    $file->setActiveSheetIndex(0); // Fix the first sheet as active
}

/**
 * @param string $filename
 * @return string
 */
function identifyMimetype($filename) {
    $finfo = finfo_open(FILEINFO_MIME_TYPE); // return mime type ala mimetype extension
    $mimetype = finfo_file($finfo, $_POST['from']);
    finfo_close($finfo);
    return $mimetype;
}

function isCLI(){
    return php_sapi_name() === 'cli';
}
/**
 * @var PHPExcel $file
 */
$file = PHPExcel_IOFactory::load($_POST['from']);
$start_row = $_POST['start-row'];
$end_row = $_POST['end-row'];
$start_col = PHPExcel_Cell::columnIndexFromString($_POST['start-col'])-1;
$end_col = PHPExcel_Cell::columnIndexFromString($_POST['end-col']);
processSheets($file, $start_row, $start_col, $end_row, $end_col);
$mode = PHPExcel_IOFactory::identify($_POST['from']);
$mimetype = identifyMimetype($_POST['from']);
if (!isCLI()) {
    header('Content-Type: '.$mimetype);
    header('Content-Disposition: attachment;filename="'.basename($_POST['from']).'"');
    header('Cache-Control: max-age=0');
}
$objWriter = PHPExcel_IOFactory::createWriter($file, $mode);
$objWriter->save($_POST['to']);
if(strpos('uploads/', $_POST['from'])) {
    unlink($_POST['from']);
}