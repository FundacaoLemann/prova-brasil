<?php

$options = getopt('f:c:t:');

$file       = $options['f'];
$column     = $options['c'];
$target     = $options['t'];

$count = 0;
$countLessMasked = 0;
$countAllMasked = 0;
$totalLines = -1;

$invalidCount = 0;
$invalidOptions = [];

$validOptions = range('A', 'Z');

$handle = fopen($file, "r");


while (($data = fgetcsv($handle, 5000, ",")) !== false) {

	// Jump header
	$totalLines++;

	if ($totalLines === 0) {
		continue;
	}

	if ($data[$column] == $target) {
		$count++;
	}

	if ($data[$column] == $target && strpos($data[3], '6') !== 0) {
		$countLessMasked++;
	}

	if (strpos($data[3], '6') === 0) {
		$countAllMasked++;
	}

	if (false === in_array($data[$column], $validOptions)) {
		$invalidCount++;
		$invalidOptions[] = $data[$column];
	}
}

$amountQuestionnaireAnswered = $totalLines - $invalidCount;
$amountQuestionnaireLessMasked = $totalLines - $countAllMasked;

$percentage = ($count * 100) / $amountQuestionnaireAnswered;
$percentageLessMasked = ($countLessMasked * 100) / $amountQuestionnaireLessMasked;

$invalidOptionsCount = array_count_values($invalidOptions);

$amountQuestionnaireAnsweredLessMasked = $amountQuestionnaireAnswered - $countAllMasked;

echo "Target: {$target}" . PHP_EOL;
echo "Column: {$column}" . PHP_EOL;

echo "Questionarios Aplicados: {$totalLines}" . PHP_EOL;
echo "Questionarios Aplicados:(menos mascarados) {$amountQuestionnaireLessMasked}" . PHP_EOL;
echo "Questionarios Respondidos: {$amountQuestionnaireAnswered}" . PHP_EOL;
echo "Questionarios Respondidos:(menos mascarados) {$amountQuestionnaireAnsweredLessMasked}" . PHP_EOL;

echo "Masked: {$countAllMasked}" . PHP_EOL;

echo "Invalid answer: {$invalidCount}" . PHP_EOL;

echo "Option {$target} was found {$count} times" . PHP_EOL;
echo "Option {$target} (menos mascarados) was found {$countLessMasked} times" . PHP_EOL;

echo "Percentage: {$percentage}%" . PHP_EOL;
echo "Percentage: (menos mascarados) {$percentageLessMasked}%" . PHP_EOL;

var_dump($invalidOptionsCount);

fclose($handle);
