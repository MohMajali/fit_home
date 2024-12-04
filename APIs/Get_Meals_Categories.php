<?php

require_once '../Connect.php';
header('Content-Type: application/json; charset=utf-8');

$response = array();

$active = 1;

$stmt = $con->prepare("SELECT category_name FROM meals WHERE active = ? GROUP BY category_name");
$stmt->bind_param("i", $active);
$stmt->execute();

$categories = array();

$result = $stmt->get_result();

while ($row = $result->fetch_array(MYSQLI_ASSOC)) {

    $categories[] = [
        'category_name' => $row['category_name'],
    ];
}

$response = $categories;
$stmt->close();

echo json_encode($response);
