<?php

require_once '../Connect.php';
header('Content-Type: application/json; charset=utf-8');

$response = array();

/*################## LOGIN #############*/

if (isset($_POST['email']) && isset($_POST['password'])) {

    $email = $_POST['email'];
    $password = $_POST['password'];

    $stmt = $con->prepare("SELECT id, name, email, phone, user_name FROM users WHERE email = ? AND password = ?");
    $stmt->bind_param("ss", $email, $password);

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
        $response['message'] = 'Login successfully';
        $response['user'] = $user;

    } else {
        $response['error'] = true;
        $response['message'] = 'Invalid email or password';
    }
} else {
    $response['error'] = true;
    $response['message'] = 'required parameters are not available';
}

echo json_encode($response);
