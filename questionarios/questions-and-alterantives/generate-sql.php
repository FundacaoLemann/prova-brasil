<?php

$options = getopt('s:f:e:q:');

$surveyId   = $options['s'];
$file       = $options['f'];
$editionId  = $options['e'];
$questionId = $options['q'];

$questionOrder = 1;
$output = '';
$alternativeLetters = range('A', 'Z');

$handle = fopen($file, "r");

while (($data = fgetcsv($handle, 1000, ",")) !== false) {

    foreach ($data as $key => $value) {

        if (empty($value)) {
            continue;
        }

        // Question
        if ($key == 0) {
            $questionText = $value;

            $questionId++;

            $questionSql = "INSERT INTO `question` (`id`, `edition_id`, `survey_id`, `text`, `order`) VALUES ({$questionId}, {$editionId}, {$surveyId}, '{$questionText}', {$questionOrder});";

            $questionOrder++;

            $output .= $questionSql . PHP_EOL;

            continue;
        }

        // Alternative
        $alternativeLetter = $alternativeLetters[--$key];
        $alternativeText = $value;

        $alternativeSql = "INSERT INTO `alternative` (`question_id`, `alternative`, `text`) VALUES({$questionId}, '{$alternativeLetter}', '{$alternativeText}');";

        $output .= $alternativeSql . PHP_EOL;
    }
}

$filename = sprintf('survey-%s.sql', $surveyId);

file_put_contents($filename, $output);

fclose($handle);
