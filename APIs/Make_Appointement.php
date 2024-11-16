<?php

require_once '../Connect.php';
header('Content-Type: application/json; charset=utf-8');

$response = array();

/*########## RESISTER #########*/
if (AllParametersAreNotNull(array('user_id', 'center_id', 'appointment_date'))) {

    $user_id = $_POST['user_id'];
    $center_id = $_POST['center_id'];
    $appointment_date = date('Y-m-d', strtotime($_POST['appointment_date']));

    $stmt = $con->prepare("SELECT id FROM appointmentes WHERE user_id = ? AND center_id = ? AND appointment_date = ?");
    $stmt->bind_param("iis", $user_id, $center_id, $appointment_date);
    $stmt->execute();
    $stmt->store_result();

    if ($stmt->num_rows > 0) {

        $response['error'] = true;
        $response['message'] = 'Appointement already registered';
        $stmt->close();

    } else {

        $stmt = $con->prepare("INSERT INTO appointmentes (user_id, center_id, appointment_date) VALUES (?, ?, ?)");
        $stmt->bind_param("iis", $user_id, $center_id, $appointment_date);

        if ($stmt->execute()) {

            $stmt->close();

            $response['error'] = false;
            $response['message'] = 'Appointement registered successfully';

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
