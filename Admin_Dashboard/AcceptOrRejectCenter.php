<?php

include "../Connect.php";

$status = $_GET['status'];
$center_id = $_GET['center_id'];

$stmt = $con->prepare("UPDATE nutrition_centers SET status = ? WHERE id = ? ");

$stmt->bind_param("si", $status, $center_id);

if ($stmt->execute()) {

    if ($status == 'Accepted') {

        echo "<script language='JavaScript'>
        alert ('Center Has Been Accepted !');
        </script>";

        echo "<script language='JavaScript'>
        document.location='./New_Requestes.php';
        </script>";

    } else {
        echo "<script language='JavaScript'>
alert ('Center Has Been Rejected !');
</script>";

        echo "<script language='JavaScript'>
document.location='./New_Requestes.php';
</script>";
    }

}
