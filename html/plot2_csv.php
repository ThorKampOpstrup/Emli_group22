<!DOCTYPE html>
<html>
  
<body>
    <center>
	<button onclick="window.location.href = 'index.html';">Go Back</button>
        <h1>DISPLAY DATA PRESENT IN CSV</h1>
        <h3>Student data</h3>
	<a href="system_info.csv" download="system_info.csv">Download CSV</a>  

	<?php
	$csvFile = 'system_info.csv';

	// Check if the file exists
	if (!file_exists($csvFile)) {
    		die("CSV file not found.");
	}

	// Open the CSV file
	$fileHandle = fopen($csvFile, 'r');

	// Check if the file could be opened
	if ($fileHandle === false) {
    		die("Failed to open the CSV file.");
	}

	// Read and print the CSV file contents
	while (($data = fgetcsv($fileHandle)) !== false) {
    	// Print each row of the CSV
    		echo implode(', ', $data) . "<br>";
	}

	// Close the file handle
	fclose($fileHandle);
	?>
   <center>
<body>
<html>
