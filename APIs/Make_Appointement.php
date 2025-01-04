<?php

require_once '../Connect.php';
header('Content-Type: application/json; charset=utf-8');

use PHPMailer\PHPMailer\Exception;
use PHPMailer\PHPMailer\PHPMailer;

require './phpmailer/src/Exception.php';
require './phpmailer/src/PHPMailer.php';
require './phpmailer/src/SMTP.php';

$response = array();

/*########## RESISTER #########*/
if (AllParametersAreNotNull(array('user_id', 'center_id', 'appointment_date'))) {

    $user_id = $_POST['user_id'];
    $center_id = $_POST['center_id'];
    $user_email = $_POST['user_email'];
    $coach = $_POST['coach'];

    $appointment_date = substr($_POST['appointment_date'], 0, 19);
    $appointment_date = new DateTime($appointment_date);
    $appointment_date = $appointment_date->format('Y-m-d H:i:s');

    $stmt = $con->prepare("SELECT id FROM appointmentes WHERE user_id = ? AND center_id = ?");
    $stmt->bind_param("ii", $user_id, $center_id);
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

            try {

                $mail = new PHPMailer(true);

                $mail->isSMTP();
                $mail->Host = 'smtp.gmail.com';
                $mail->SMTPAuth = true;
                $mail->Username = 'fitathomeplatform@gmail.com';
                $mail->Password = 'tvvaqigwzghvrtce';
                $mail->SMTPSecure = 'ssl';
                $mail->Port = 465;

                $mail->setFrom("fitathomeplatform@gmail.com");

                $mail->addAddress($user_email);

                $mail->isHTML(true);

                $mail->Subject = "Appointment With {$coach}";
                $mail->Body = "You have appointment with {$coach}, At {$appointment_date}";

                $mail->send();

                $response['error'] = false;
                $response['message'] = 'Appointement registered successfully';

            } catch (Exception $e) {

                $response['error'] = false;
                $response['message'] = "Something went wrong";
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
