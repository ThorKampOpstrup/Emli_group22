<?php
// Read the CSV file
$csvFile = 'pump1.csv';
$fileHandle = fopen($csvFile, 'r');

// Check if the file could be opened
if ($fileHandle === false) {
    die("Failed to open the CSV file.");
}

// Read the file and store the lines in an array
$lines = array();
$count=0;
while (($line = fgetcsv($fileHandle)) !== false) {
    $lines[] = $line;
    $count+=1;
}

// Close the file handle
fclose($fileHandle);

// Extract the last 10 lines
$last10Lines = array_slice($lines, -$count);

// Initialize arrays to store the data
$moistureData = array();
$xLabels = array();

// Process the last 10 lines of the CSV file
foreach ($last10Lines as $line) {
    // Extract the relevant values from each line
    $moisture = intval($line[1]);
    $xLabel = substr($line[0], -8); // Extract the last 8 characters as the X label

    // Add the data to the arrays
    $moistureData[] = $moisture;
    $xLabels[] = $xLabel;
}
?>


<!DOCTYPE html>
<html>
<head>
    <title>CSV Data Plot</title>
    <script src="chart.js"></script>
</head>
<body>
    <canvas id="chart"></canvas>
    <script>
        // Convert PHP arrays to JavaScript arrays
        var moistureData = <?php echo json_encode($moistureData); ?>;
        var xLabels = <?php echo json_encode($xLabels); ?>;

        // Create the chart using Chart.js
        var ctx = document.getElementById('chart').getContext('2d');
        var chart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: xLabels,
                datasets: [
                    {
                        label: 'Pump [high/low]',
                        data: moistureData,
                        backgroundColor: 'rgba(0, 123, 255, 0.5)',
                        borderColor: 'rgba(0, 123, 255, 1)',
                        borderWidth: 1
                    }
                ]
            },
            options: {
                responsive: true,
                scales: {
                    x: {
                        display: true,
                        title: {
                            display: true,
                            text: 'Time'
                        }
                    },
                    y: {
                        display: true,
                        title: {
                            display: true,
                            text: 'Value'
                        }
                    }
                }
            }
        });
    </script>
    <a href="pump1.csv" download="pump1.csv">Download CSV</a>
    <button onclick="window.location.href = 'index.html';">Go Back</button>
</body>
</html>
