<?php

include "../Connect.php";

$isActive = $_GET['isActive'];
$meal_id = $_GET['meal_id'];
$user_id = $_GET['user_id'];

$stmt = $con->prepare("UPDATE meals SET active = ? WHERE id = ? ");

$stmt->bind_param("ii", $isActive, $meal_id);

if ($stmt->execute()) {

    if ($isActive == 0) {

        echo "<script language='JavaScript'>
        alert ('Meal Has Been Deleted Successfully !');
        </script>";

        echo "<script language='JavaScript'>
        document.location='./Meals.php?user_id={$user_id}';
        </script>";

    } else {
        echo "<script language='JavaScript'>
alert ('Meal Has Been Restored Successfully !');
</script>";

        echo "<script language='JavaScript'>
document.location='./Meals.php?user_id={$user_id}';
</script>";
    }

}
