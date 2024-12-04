<?php
require '../Connect.php'; // Include your database connection

$levelId = $_GET['level_id'];
$response = [];

if (!empty($levelId)) {
    $plansSql = mysqli_query($con, "SELECT * FROM plans WHERE level_id = '$levelId' AND active = 1 ORDER BY id DESC");
    while ($row = mysqli_fetch_assoc($plansSql)) {
        $response[] = $row;
    }
}

echo json_encode($response);
