<?php

require_once '../Connect.php';

header('Content-Type: application/json; charset=utf-8');


$response = array();

$userId = $_GET['user_id'];
$active = 1;

$stmt = $con->prepare("SELECT id, category_id FROM user_categories WHERE user_id = ?");
$stmt->bind_param("i", $userId);
$stmt->execute();

$result = $stmt->get_result();

$levels = array();


while ($row = $result->fetch_array(MYSQLI_ASSOC)) {

    $data = [];

    $categoryId = $row['category_id'];

    $stmt2 = $con->prepare("SELECT id, name FROM levels WHERE category_id = ? AND active = ?");
    $stmt2->bind_param("ii", $categoryId, $active);
    $stmt2->execute();

    $result2 = $stmt2->get_result();

    while ($row2 = $result2->fetch_array(MYSQLI_ASSOC)) {

        $levelId = $row['id'];

        $data = [
            'id' => $row['id'],
            'level_name' => $row2['name'],
            'plans' => [],
        ];

        $stmt3 = $con->prepare("SELECT id, name, image, description FROM plans WHERE level_id = ? AND active = ?");
        $stmt3->bind_param("ii", $levelId, $active);
        $stmt3->execute();

        $result3 = $stmt3->get_result();

        while ($row3 = $result3->fetch_array(MYSQLI_ASSOC)) {

            $planId = $row3['id'];
// print_r($planId);
// die;
            $stmt4 = $con->prepare("SELECT id, is_done FROM user_plans WHERE plan_id = ?");
            $stmt4->bind_param("i", $planId);
            $stmt4->execute();

            $result4 = $stmt4->get_result();

            while ($row4 = $result4->fetch_array(MYSQLI_ASSOC)) {

                $userPlanId = $row4['id'];

                $data['plans'][] = [
                    'id' => $row3['id'],
                    'name' => $row3['name'],
                    'image' => $row3['image'],
                    'description' => $row3['description'],
                    'is_done' => boolval($row4['is_done']),
                ];
            }
        }
    }

    $levels[] = $data;

}

$response['error'] = false;
$response['levels'] = $levels;

$stmt->close();

echo json_encode($response);
