<?php

$options = getopt('f:c:i:', ['stateId:', 'stateColumn:', 'cityId:', 'cityColumn:', 'schoolId:', 'schoolColumn:']);

$file           = $options['f'];
$column         = $options['c'];
$collumIsFilled = $options['i'];
$stateId 		= $options['stateId'] ?? false;
$stateColumn    = $options['stateColumn'] ?? false;
$cityId 		= $options['cityId'] ?? false;
$cityColumn     = $options['cityColumn'] ?? false;
$schoolId 		= $options['schoolId'] ?? false;
$schoolColumn   = $options['schoolColumn'] ?? false;

$totalLines = -1;
$notFilled  = 0;
$questionTitle = '';

$alternatives = [];

$handle = fopen($file, "r");

while (($data = fgetcsv($handle, 0, ",")) !== false) {

	$totalLines++;

	// Jump header
	if ($totalLines === 0) {
		$questionTitle = $data[$column];

		continue;
	}

	if ($stateId && $stateColumn && $stateId !== $data[$stateColumn]) {
		continue;
	}

	if ($cityId && $cityColumn && $cityId !== $data[$cityColumn]) {
		continue;
	}

	if ($schoolId && $schoolColumn && $schoolId !== $data[$schoolColumn]) {
		continue;
	}

	if (is_not_masked($data)) {
		$alternatives[] = $data[$column];

		if ($data[$collumIsFilled] === '0') {
			$notFilled++;
		}
	}
}

$appliedQuestionnaire  = count($alternatives);
$answeredQuestionnaire = $appliedQuestionnaire - $notFilled;

$statsAlternatives = array_count_values($alternatives);

$filteredAlternatives = array_filter($statsAlternatives, function ($value) {

	$validOptions = range('A', 'Z');
	$validOptions[] = '*';
	$validOptions[] = '.';

	if (in_array($value, $validOptions)) {
		return true;
	}

	return false;
}, ARRAY_FILTER_USE_KEY);

$totalFilteredAlternatives = array_sum($filteredAlternatives);

ksort($filteredAlternatives);

echo PHP_EOL;
echo '------------------------------------------------------------------------' . PHP_EOL;
echo '------------------------------------------------------------------------' . PHP_EOL;

echo PHP_EOL;

echo $questionTitle . PHP_EOL;

echo PHP_EOL;

echo "Total de linhas: \t\t" . number_format($totalLines) . PHP_EOL;
echo PHP_EOL;
echo "Questionarios Aplicados: \t" . number_format($appliedQuestionnaire) . PHP_EOL;
echo "Questionarios Respondidos: \t" . number_format($answeredQuestionnaire) . PHP_EOL;

echo PHP_EOL;
echo '------------------------------------------------------------------------' . PHP_EOL;
echo '------------------------------------------------------------------------' . PHP_EOL;
echo PHP_EOL;

echo "Alternativas" . PHP_EOL;

foreach ($filteredAlternatives as $valueAlternative => $amountAlternative) {
	$percentage = ($amountAlternative*100)/$totalFilteredAlternatives;

	echo "{$valueAlternative}: \t" . number_format($amountAlternative) . "\t {$percentage}%" . PHP_EOL;
}

fclose($handle);

/**
 * Aux functions
 */


function is_not_masked($data) {
	return strpos($data[3], '6') !== 0;
}
