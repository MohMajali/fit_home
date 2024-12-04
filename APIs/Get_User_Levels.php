<?php

require_once '../Connect.php';

header('Content-Type: application/json; charset=utf-8');

$response = array();

$userId = $_GET['user_id'];
$active = 1;

$stmt = $con->prepare("SELECT id, category_id FROM user_categories WHERE user_id = ?");
$stmt->bind_param("i", $userId);


$stmt->execute();

$stmt->store_result();

$levels = array();

if ($stmt->num_rows > 0) {

    $stmt->bind_result($id, $category_id);
    $stmt->fetch();

    $stmt2 = $con->prepare("SELECT id, name FROM levels WHERE category_id = ? AND active = ? ORDER BY id DESC");
    $stmt2->bind_param("ii", $category_id, $active);
    $stmt2->execute();

    $result2 = $stmt2->get_result();

    while ($row2 = $result2->fetch_array(MYSQLI_ASSOC)) {

        $levelId = $row2['id'];

        $data = [
            'id' => $row2['id'],
            'level_name' => $row2['name'],
            'plans' => [],
        ];

        $stmt3 = $con->prepare("SELECT id, name, image, description FROM plans WHERE level_id = ? AND active = ?");
        $stmt3->bind_param("ii", $levelId, $active);
        $stmt3->execute();

        $result3 = $stmt3->get_result();

        while ($row3 = $result3->fetch_array(MYSQLI_ASSOC)) {

            $planId = $row3['id'];

            $stmt4 = $con->prepare("SELECT id, is_done FROM user_plans WHERE plan_id = ?");
            $stmt4->bind_param("i", $planId);
            $stmt4->execute();

            $result4 = $stmt4->get_result();

            while ($row4 = $result4->fetch_array(MYSQLI_ASSOC)) {

                $userPlanId = $row4['id'];

                $data['plans'][] = [
                    'id' => $row3['id'],
                    'user_plan_id' => $row4['id'],
                    'name' => $row3['name'],
                    'image' => 'http://10.0.2.2/fit_home/Admin_Dashboard/' . $row3['image'],
                    'description' => $row3['description'],
                    'is_done' => boolval($row4['is_done']),
                ];
            }

        }
        $levels[] = $data;
    }
}

$response = $levels;

$stmt->close();

echo json_encode($response);
