<?php
require '../Connect.php'; // Include your database connection

$categoryId = $_GET['category_id'];
$response = [];

if (!empty($categoryId)) {


    $levelsSql = mysqli_query($con, "SELECT * FROM levels WHERE category_id = '$categoryId' AND active = 1 ORDER BY id DESC");
    while ($row = mysqli_fetch_assoc($levelsSql)) {
        $response[] = $row;
    }
}

echo json_encode($response);
