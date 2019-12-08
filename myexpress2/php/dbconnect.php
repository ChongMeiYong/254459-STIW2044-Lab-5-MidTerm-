<?php
$servername = "localhost";
$username 	= "alifmirz_mydriveradmin";
$password 	= "U39I0@JwOb~&";
$dbname 	= "alifmirz_mydriver";
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>