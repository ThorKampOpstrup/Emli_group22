<!DOCTYPE html>
<html>
<head>
<title>EMLI</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-
scalable=0">
<meta name="apple-mobile-web-app-capable" content="yes">
</head>
<body>
<p style="font-family: "Lucida Grande", Verdana, Geneva; font-size: 12px;">
<b>EMLI Uptime test</b><br/>
<?php
$output = shell_exec("uptime");
echo ('The linux uptime is:<br/>'.$output);
?>
</p>
</body>
</html>

<!DOCTYPE html>
<html>
<body>
    <button onclick="window.location.href = 'index.html';">Go Back</button>
</body>
</html>
