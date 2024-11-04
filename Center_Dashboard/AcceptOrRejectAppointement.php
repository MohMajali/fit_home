<?php

include "../Connect.php";

$appointement_id = $_GET['appointement_id'];
$status = $_GET['status'];

$stmt = $con->prepare("UPDATE appointmentes SET status = ? WHERE id = ? ");

$stmt->bind_param("si", $status, $appointement_id);

if ($stmt->execute()) {

    if ($status == 'Accepted') {

        echo "<script language='JavaScript'>
        alert ('Appointement Has Been Accepted Successfully !');
        </script>";

        echo "<script language='JavaScript'>
        document.location='./Appointements.php';
        </script>";

    } else {
        echo "<script language='JavaScript'>
alert ('Appointement Has Been Rejected Successfully !');
</script>";

        echo "<script language='JavaScript'>
document.location='./Appointements.php';
</script>";
    }

}
