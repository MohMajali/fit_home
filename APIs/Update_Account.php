<?php

require_once '../Connect.php';
header('Content-Type: application/json; charset=utf-8');

$response = array();

/*########## RESISTER #########*/
if (AllParametersAreNotNull(array('user_id', 'name', 'email', 'phone', 'user_name'))) {

    $user_id = $_POST['user_id'];
    $name = $_POST['name'];
    $email = $_POST['email'];
    $phone = $_POST['phone'];
    $user_name = $_POST['user_name'];

    $stmt = $con->prepare("UPDATE users SET name = ?, email = ?, phone = ?, user_name = ? WHERE id = ?");
    $stmt->bind_param("ssssi", $name, $email, $phone, $user_name, $user_id);

    if ($stmt->execute()) {

        $stmt->close();

        $response['error'] = false;
        $response['message'] = 'Account Updated Successfully';

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
