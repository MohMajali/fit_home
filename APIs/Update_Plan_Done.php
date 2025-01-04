<?php

require_once '../Connect.php';
header('Content-Type: application/json; charset=utf-8');

$response = array();

/*########## RESISTER #########*/
if (AllParametersAreNotNull(array('user_plan_id'))) {

    $user_plan_id = $_POST['user_plan_id'];
    $isDone = true;

    $stmt = $con->prepare("SELECT created_at FROM user_plans WHERE id = ?");
    $stmt->bind_param("i", $user_plan_id);

    $stmt->execute();

    $stmt->store_result();

    if ($stmt->num_rows > 0) {

        $stmt->bind_result($created_at);
        $stmt->fetch();

        $createdDate = new DateTime($created_at);

        // Get the current date
        $todayDate = new DateTime();

        // Calculate the difference
        $interval = $todayDate->diff($createdDate);

        if ($interval->m >= 1 || $interval->y >= 1) {

            $stmt = $con->prepare("UPDATE user_plans SET is_done = ? WHERE id = ?");
            $stmt->bind_param("ii", $isDone, $user_plan_id);

            if ($stmt->execute()) {

                $stmt->close();

                $response['error'] = false;
                $response['message'] = 'Plan Updated Successfully';

            }

        } else {

            $response['error'] = true;
            $response['message'] = 'Plan must be more 1 month';
        }

    }

} else {

    $response['error'] = true;
    $response['message'] = 'required parameters are not available';
}

echo json_encode($response);

function AllParametersAreNotNull($params)
{

    foreach ($params as $param) {
        if (!isset($_POST[$param])) {
            return false;
        }
    }
    return true;
}
