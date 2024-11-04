<?php
// database connection config
error_reporting(0);
$db_name = "fit_home";
$mysql_user = "root";
$mysql_pass = "";
$server_name = "localhost";

$con = new mysqli($server_name, $mysql_user, $mysql_pass, $db_name);

if ($con->connect_errno) {

    echo "Failed to connect to MySQL: " . $con->connect_error;
}

mysqli_set_charset($con, 'utf8');

date_default_timezone_set('Asia/Amman');
