<?php

include "../Connect.php";
$isActive = $_GET['isActive'];
$center_id = $_GET['center_id'];

$stmt = $con->prepare("UPDATE nutrition_centers SET active = ? WHERE id = ? ");

$stmt->bind_param("ii", $isActive, $center_id);

if ($stmt->execute()) {

    if ($isActive == 0) {

        echo "<script language='JavaScript'>
        alert ('Center Has Been Deleted Successfully !');
        </script>";

        echo "<script language='JavaScript'>
        document.location='./Nutrition_Centers.php';
        </script>";

    } else {
        echo "<script language='JavaScript'>
alert ('Category Has Been Restored Successfully !');
</script>";

        echo "<script language='JavaScript'>
document.location='./Nutrition_Centers.php';
</script>";
    }

}
