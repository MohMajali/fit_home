<?php

include "../Connect.php";
$isActive = $_GET['isActive'];
$level_id = $_GET['level_id'];

$stmt = $con->prepare("UPDATE levels SET active = ? WHERE id = ? ");

$stmt->bind_param("ii", $isActive, $level_id);

if ($stmt->execute()) {

    if ($isActive == 0) {

        echo "<script language='JavaScript'>
        alert ('Level Has Been Deleted Successfully !');
        </script>";

        echo "<script language='JavaScript'>
        document.location='./Levels.php';
        </script>";

    } else {
        echo "<script language='JavaScript'>
alert ('Level Has Been Restored Successfully !');
</script>";

        echo "<script language='JavaScript'>
document.location='./Levels.php';
</script>";
    }

}
