<?php

require_once '../Connect.php';
header('Content-Type: application/json; charset=utf-8');

$response = array();

$active = 1;

$stmt = $con->prepare("SELECT id, name, email, phone, description, image FROM nutrition_centers WHERE active = ? ");
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
        'image' => 'http://10.0.2.2/fit_home/Center_Dashboard/' . $row['image'],
        'description' => is_null($row['description']) ? '' : $row['description'],
    ];
}

$response = $centers;
$stmt->close();

echo json_encode($response);
