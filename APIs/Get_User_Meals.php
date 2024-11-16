<?php

require_once '../Connect.php';

header('Content-Type: application/json; charset=utf-8');

$response = array();

$userId = $_GET['user_id'];
$active = 1;

$stmt = $con->prepare("SELECT meal_id FROM user_meals_plans WHERE user_id = ?");
$stmt->bind_param("i", $userId);
$stmt->execute();

$result = $stmt->get_result();

$meals = array();

while ($row = $result->fetch_array(MYSQLI_ASSOC)) {

    $data = [];

    $mealId = $row['meal_id'];

    $stmt2 = $con->prepare("SELECT nutrition_center_id, name, image, description, category_name FROM meals WHERE id = ? AND active = ?");
    $stmt2->bind_param("ii", $mealId, $active);
    $stmt2->execute();

    $result2 = $stmt2->get_result();

    while ($row2 = $result2->fetch_array(MYSQLI_ASSOC)) {

        $centerId = $row2['nutrition_center_id'];

        $stmt3 = $con->prepare("SELECT  name FROM nutrition_centers WHERE id = ? AND active = ?");
        $stmt3->bind_param("ii", $centerId, $active);
        $stmt3->execute();

        $result3 = $stmt3->get_result();

        while ($row3 = $result3->fetch_array(MYSQLI_ASSOC)) {

            $data = [
                'id' => $row['meal_id'],
                'nutrition_center_id' => $row2['nutrition_center_id'],
                'center_name' => $row3['name'],
                'name' => $row2['name'],
                'name' => $row2['name'],
                'image' => $row2['image'],
                'description' => $row2['description'],
                'category_name' => $row2['category_name'],
            ];
        }
    }

    $meals[] = $data;

}

$response['error'] = false;
$response['meals'] = $meals;

$stmt->close();

echo json_encode($response);
