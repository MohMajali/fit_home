<?php

include "../Connect.php";

$isActive = $_GET['isActive'];
$plan_id = $_GET['plan_id'];
$level_id = $_GET['level_id'];

$stmt = $con->prepare("UPDATE plans SET active = ? WHERE id = ? ");

$stmt->bind_param("ii", $isActive, $plan_id);

if ($stmt->execute()) {

    if ($isActive == 0) {

        echo "<script language='JavaScript'>
        alert ('Plan Has Been Deleted Successfully !');
        </script>";

        echo "<script language='JavaScript'>
        document.location='./Plans.php?level_id={$level_id}';
        </script>";

    } else {
        echo "<script language='JavaScript'>
alert ('Plan Has Been Restored Successfully !');
</script>";

        echo "<script language='JavaScript'>
document.location='./Plans.php?level_id={$level_id}';
</script>";
    }

}
