<?php

require_once '../Connect.php';
header('Content-Type: application/json; charset=utf-8');

$response = array();

$active = 1;

$stmt = $con->prepare("SELECT id, weight_range, tall_range FROM categories WHERE active = ? ");
$stmt->bind_param("i", $active);
$stmt->execute();

$categories = array();

$result = $stmt->get_result();

while ($row = $result->fetch_array(MYSQLI_ASSOC)) {

    $categories[] = [
        'id' => $row['id'],
        'weight_range' => $row['weight_range'],
        'tall_range' => $row['tall_range'],
    ];
}

$response['error'] = false;
$response['categories'] = $categories;
$stmt->close();

echo json_encode($response);
