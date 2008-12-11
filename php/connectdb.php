<?php

function getTime() {
    $a = explode (' ',microtime());
    return(double) $a[0] + $a[1];
}
//phpinfo ();

$Start = getTime();

// we connect to example.com and port 3307
$link = mysql_connect('192.168.20.45:3306', 'root', 'Maretec2004');
if (!$link) {
    die('Could not connect: ' . mysql_error());
}

$End = getTime();

echo "Connected successfully<br/>\n";
echo "Time taken = ".number_format(($End - $Start),2)." secs<br/>\n";

mysql_close($link);

?>
