<?php

require_once '../Connect.php';
header('Content-Type: application/json; charset=utf-8');

$response = array();

/*########## RESISTER #########*/
if (AllParametersAreNotNull(array('name', 'email', 'phone', 'user_name', 'password', 'tall', 'weight'))) {

    $name = $_POST['name'];
    $email = $_POST['email'];
    $phone = $_POST['phone'];
    $user_name = $_POST['user_name'];
    $password = $_POST['password'];
    $tall = $_POST['tall'];
    $weight = $_POST['weight'];
    $subscription_type = $_POST['subscription_type'];
    $start_date = $_POST['start_date'];
    $end_date = '';
    $price = '';

    if ($subscription_type == 1) {

        $end_date = date('Y-m-d', strtotime($start_date . ' +90 days'));
        $subscription_type = "3 Months Open Contract (First Time Only) (For Free)";
        $price = 0;

    } else if ($subscription_type == 2) {

        $end_date = date('Y-m-d', strtotime($start_date . ' +180 days'));
        $subscription_type = "6 Months Contract (300 JOD)";
        $price = 300;

    } else if ($subscription_type == 3) {

        $end_date = date('Y-m-d', strtotime($start_date . ' +360 days'));
        $subscription_type = "12 Months COntract (600 JOD)";
        $price = 600;

    }

    $stmt = $con->prepare("SELECT id FROM users WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $stmt->store_result();

    if ($stmt->num_rows > 0) {

        $response['error'] = true;
        $response['message'] = 'User already registered';
        $stmt->close();

    } else {

        $stmt = $con->prepare("INSERT INTO users (name, email, phone ,user_name, password, tall, weight) VALUES (?, ?, ?, ?, ?, ?, ?)");
        $stmt->bind_param("sssssss", $name, $email, $phone, $user_name, $password, $tall, $weight);

        if ($stmt->execute()) {

            $stmt = $con->prepare("SELECT id FROM users WHERE email = ?");
            $stmt->bind_param("s", $email);
            $stmt->execute();
            $stmt->bind_result($id);
            $stmt->fetch();

            $stmt = $con->prepare("INSERT INTO user_subscription (user_id, subscription_type, start_date ,end_date, price) VALUES (?, ?, ?, ?, ?)");
            $stmt->bind_param("sssss", $id, $subscription_type, $start_date, $end_date, $price);

            if ($stmt->execute()) {

                $stmt->close();

                $response['error'] = false;
                $response['message'] = 'User registered successfully';

            }
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