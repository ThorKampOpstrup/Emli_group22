<?php
// Start the session
session_start();

// Define the correct username and password
$correctUsername = 'emli22';
$correctPassword = 'safetyemli22';

// Check if the user is already logged in
if (isset($_SESSION['loggedIn']) && $_SESSION['loggedIn'] === true) {
    // Handle logout
    if (isset($_POST['logout']) && $_POST['logout'] === 'true') {
        // Destroy the session and redirect to the login form
        session_destroy();
        header('Location: login.php');
        exit;
    }
}

// Check if the form is submitted
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get the entered username and password from the form
    $enteredUsername = $_POST['username'] ?? '';
    $enteredPassword = $_POST['password'] ?? '';

    // Check if the entered username and password are correct
    if ($enteredUsername === $correctUsername && $enteredPassword === $correctPassword) {
        // Set the session variable to indicate that the user is logged in
        $_SESSION['loggedIn'] = true;

        // Redirect to the same page to display the logged-in content
        header('Location: ' . $_SERVER['PHP_SELF']);
        exit;
    } else {
        echo "Invalid username or password.";
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Fail2Ban Log Viewer</title>
</head>
<body>
    <?php if (!isset($_SESSION['loggedIn']) || $_SESSION['loggedIn'] !== true) { ?>
        <h1>Login</h1>
        <form method="POST" action="">
            <label for="username">Username:</label>
            <input type="text" name="username" id="username" required><br>

            <label for="password">Password:</label>
            <input type="password" name="password" id="password" required><br>

            <input type="submit" value="Submit">
        </form>
    <?php } else { ?>
        <h1>Fail2Ban Log Viewer</h1>

        <form method="POST" action="">
            <input type="hidden" name="logout" value="true">
            <input type="submit" value="Logout">
        </form>

        <?php
        $logFile = 'fail2ban.log'; // Replace with the path to your fail2ban.log file

        // Check if the log file exists
        if (file_exists($logFile)) {
            $content = file_get_contents($logFile);
            echo "<pre>" . htmlspecialchars($content) . "</pre>"; // Display the content with proper encoding
        } else {
            echo "The log file does not exist.";
        }
        ?>
    <?php } ?>
</body>
</html>
