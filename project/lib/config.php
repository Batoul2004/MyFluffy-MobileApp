<?php
$servername = "fdb1030.awardspace.net";
$username = "Batoul";
$password = "password1";
$dbname = "4512944_profiles";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>
