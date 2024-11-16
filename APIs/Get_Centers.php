<?php

require_once '../Connect.php';
header('Content-Type: application/json; charset=utf-8');

$response = array();

$active = 1;

$stmt = $con->prepare("SELECT id, name, email, phone, description FROM nutrition_centers WHERE active = ? ");
$stmt->bind_param("i", $active);
$stmt->execute();

$centers = array();

$result = $stmt->get_result();

while ($row = $result->fetch_array(MYSQLI_ASSOC)) {

    $centers[] = [
        'id' => $row['id'],
        'name' => $row['name'],
        'email' => $row['email'],
        'phone' => $row['phone'],
        'description' => is_null($row['description']) ? '' : $row['description'],
    ];
}

$response['error'] = false;
$response['centers'] = $centers;
$stmt->close();

echo json_encode($response);
