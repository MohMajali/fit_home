<?php

require_once '../Connect.php';
header('Content-Type: application/json; charset=utf-8');

$response = array();

/*########## RESISTER #########*/
if (AllParametersAreNotNull(array('user_plan_id'))) {

    $user_plan_id = $_POST['user_plan_id'];
    $isDone = true;

    $stmt = $con->prepare("UPDATE user_plans SET is_done = ? WHERE id = ?");
    $stmt->bind_param("ii", $isDone, $user_plan_id);

    if ($stmt->execute()) {

        $stmt->close();

        $response['error'] = false;
        $response['message'] = 'Plan Updated Successfully';

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
