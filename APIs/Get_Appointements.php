<?php

require_once '../Connect.php';

header('Content-Type: application/json; charset=utf-8');

$response = array();

$userId = $_GET['user_id'];
$active = 1;

$stmt = $con->prepare("SELECT id, center_id, appointment_date, status FROM appointmentes WHERE user_id = ?");
$stmt->bind_param("i", $userId);
$stmt->execute();

$result = $stmt->get_result();

$appointements = array();

while ($row = $result->fetch_array(MYSQLI_ASSOC)) {

    $data = [];

    $centerId = $row['center_id'];

    $stmt2 = $con->prepare("SELECT name, image FROM nutrition_centers WHERE id = ? AND active = ?");
    $stmt2->bind_param("ii", $centerId, $active);
    $stmt2->execute();

    $result2 = $stmt2->get_result();

    while ($row2 = $result2->fetch_array(MYSQLI_ASSOC)) {

        $data = [
            'id' => $row['id'],
            'center_id' => $row['center_id'],
            'center_name' => $row2['name'],
            'appointment_date' => $row['appointment_date'],
            'status' => $row['status'],
            'image' => 'http://10.0.2.2/fit_home/Center_Dashboard/' . $row2['image'],
        ];

    }

    $appointements[] = $data;

}

$response = $appointements;

$stmt->close();

echo json_encode($response);
