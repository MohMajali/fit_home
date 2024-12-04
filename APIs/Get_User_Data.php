<?php

require_once '../Connect.php';
header('Content-Type: application/json; charset=utf-8');

$response = array();

/*################## LOGIN #############*/

if (isset($_GET['user_id'])) {

    $user_id = $_GET['user_id'];

    $stmt = $con->prepare("SELECT id, name, email, phone, user_name FROM users WHERE id = ?");
    $stmt->bind_param("i", $user_id);

    $stmt->execute();

    $stmt->store_result();

    if ($stmt->num_rows > 0) {

        $stmt->bind_result($id, $name, $email, $phone, $user_name);
        $stmt->fetch();

        $user = array(
            'id' => $id,
            'name' => $name,
            'email' => $email,
            'phone' => $phone,
            'user_name' => $user_name,
        );

        $response['error'] = false;
        $response['message'] = 'Data';
        $response['user'] = $user;

    } else {
        $response['error'] = true;
        $response['message'] = 'User Not Found';
    }
} else {
    $response['error'] = true;
    $response['message'] = 'required parameters are not available';
}

echo json_encode($response);
