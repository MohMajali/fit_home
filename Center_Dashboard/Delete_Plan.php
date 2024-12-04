<?php

include "../Connect.php";

$user_plan_id = $_GET['user_plan_id'];
$user_id = $_GET['user_id'];

$stmt = $con->prepare("DELETE FROM user_plans WHERE id = ?");

$stmt->bind_param("i", $user_plan_id);

if ($stmt->execute()) {

    echo "<script language='JavaScript'>
        alert ('Plan Has Been Deleted Successfully !');
        </script>";

    echo "<script language='JavaScript'>
        document.location='./Plans.php?user_id={$user_id}';
        </script>";

}
