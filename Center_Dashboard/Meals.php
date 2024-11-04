<?php
session_start();

include "../Connect.php";

$C_ID = $_SESSION['C_Log'];
$user_id = $_GET['user_id'];

if (!$C_ID) {

    echo '<script language="JavaScript">
     document.location="../Center_Login.php";
    </script>';

} else {

    $sql1 = mysqli_query($con, "select * from nutrition_centers where id = '$C_ID'");
    $row1 = mysqli_fetch_array($sql1);

    $name = $row1['name'];
    $email = $row1['email'];

    $sql2 = mysqli_query($con, "select * from users where id = '$user_id'");
    $row1 = mysqli_fetch_array($sql2);

    $user_name = $row1['name'];

    if (isset($_POST['Submit'])) {

        $user_id = $_POST['user_id'];
        $nutrition_center_id = $_POST['nutrition_center_id'];
        $name = $_POST['name'];
        $description = $_POST['description'];
        $category_name = $_POST['category_name'];
        $image = $_FILES["file"]["name"];
        $image = 'Meals_Images/' . $image;

        $stmt = $con->prepare("INSERT INTO meals (nutrition_center_id, name, image, description, category_name) VALUES (?, ?, ?, ?, ?)");
        $stmt->bind_param("issss", $nutrition_center_id, $name, $image, $description, $category_name);

        if ($stmt->execute()) {

            $stmt = $con->prepare("SELECT id FROM meals WHERE nutrition_center_id = ? AND name = ? AND description = ? AND category_name = ?");
            $stmt->bind_param("isss", $nutrition_center_id, $name, $description, $category_name);
            $stmt->execute();
            $stmt->store_result();

            if ($stmt->num_rows > 0) {

                $stmt->bind_result($id);
                $stmt->fetch();

                $stmt = $con->prepare("INSERT INTO user_meals_plans (user_id, meal_id) VALUES (?, ?) ");
                $stmt->bind_param("ii", $user_id, $id);

                if ($stmt->execute()) {
                    move_uploaded_file($_FILES["file"]["tmp_name"], "./Meals_Images/" . $_FILES["file"]["name"]);

                    echo "<script language='JavaScript'>
                alert ('Meal Added To User !');
           </script>";

                    echo "<script language='JavaScript'>
          document.location='./Meals.php?user_id={$user_id}';
             </script>";

                }
            }
        }
    }
}

?>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />

    <title><?php echo $user_name ?> Meals - FitAtHome</title>
    <meta content="" name="description" />
    <meta content="" name="keywords" />

    <!-- Favicons -->
    <link href="../assets/img/Logo.png" rel="icon" />
    <link href="../assets/img/Logo.png" rel="apple-touch-icon" />

    <!-- Google Fonts -->
    <link href="https://fonts.gstatic.com" rel="preconnect" />
    <link
      href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Nunito:300,300i,400,400i,600,600i,700,700i|Poppins:300,300i,400,400i,500,500i,600,600i,700,700i"
      rel="stylesheet"
    />

    <!-- Vendor CSS Files -->
    <link
      href="../assets/vendor/bootstrap/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      href="../assets/vendor/bootstrap-icons/bootstrap-icons.css"
      rel="stylesheet"
    />
    <link href="../assets/vendor/boxicons/css/boxicons.min.css" rel="stylesheet" />
    <link href="../assets/vendor/quill/quill.snow.css" rel="stylesheet" />
    <link href="../assets/vendor/quill/quill.bubble.css" rel="stylesheet" />
    <link href="../assets/vendor/remixicon/remixicon.css" rel="stylesheet" />
    <link href="../assets/vendor/simple-datatables/style.css" rel="stylesheet" />

    <!-- Template Main CSS File -->
    <link href="../assets/css/style.css" rel="stylesheet" />
  </head>

  <body>
    <!-- ======= Header ======= -->
    <header id="header" class="header fixed-top d-flex align-items-center">
      <div class="d-flex align-items-center justify-content-between">
        <a href="index.php" class="logo d-flex align-items-center">
          <img src="../assets/img/Logo.png" alt="" />

        </a>
      </div>
      <!-- End Logo -->
      <!-- End Search Bar -->

      <nav class="header-nav ms-auto">
        <ul class="d-flex align-items-center">
          <li class="nav-item dropdown pe-3">
            <a
              class="nav-link nav-profile d-flex align-items-center pe-0"
              href="#"
              data-bs-toggle="dropdown"
            >
              <img
                src="https://www.computerhope.com/jargon/g/guest-user.png"
                alt="Profile"
                class="rounded-circle"
              />
              <span class="d-none d-md-block dropdown-toggle ps-2"><?php echo $name ?></span> </a
            >

          <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow profile">
            <li class="dropdown-header">
              <h6><?php echo $name ?></h6>
            </li>
            <li>
              <hr class="dropdown-divider">
            </li>

            <li>
              <a class="dropdown-item d-flex align-items-center" href="./Logout.php">
                <i class="bi bi-box-arrow-right"></i>
                <span>Sign Out</span>
              </a>
            </li>

          </ul>
          </li>
          <!-- End Profile Nav -->
        </ul>
      </nav>
      <!-- End Icons Navigation -->
    </header>
    <!-- End Header -->

    <!-- ======= Sidebar ======= -->
    <?php require './Aside-Nav/Aside.php'?>
    <!-- End Sidebar-->

    <main id="main" class="main">
      <div class="pagetitle">
        <h1><?php echo $user_name ?> Meals</h1>
        <nav>
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="index.php">Dashboard</a></li>
            <li class="breadcrumb-item"><?php echo $user_name ?> Meals</li>
          </ol>
        </nav>
      </div>
      <!-- End Page Title -->
      <section class="section">


      <div class="mb-3">
          <button
            type="button"
            class="btn btn-primary"
            data-bs-toggle="modal"
            data-bs-target="#verticalycentered"
          >
            Add New Meal
          </button>
        </div>

        <div class="modal fade" id="verticalycentered" tabindex="-1">
          <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title">Meal Information</h5>
                <button
                  type="button"
                  class="btn-close"
                  data-bs-dismiss="modal"
                  aria-label="Close"
                ></button>
              </div>
              <div class="modal-body">

                <form method="POST" action="./Meals.php?user_id=<?php echo $user_id ?>" enctype="multipart/form-data">

                <input type="hidden" value="<?php echo $user_id ?>" name="user_id">
                <input type="hidden" value="<?php echo $C_ID ?>" name="nutrition_center_id">


                <div class="row mb-3">
                    <label for="inputText" class="col-sm-4 col-form-label"
                      >Category Name</label
                    >
                    <div class="col-sm-8">
                       <select name="category_name" class="form-select" id="" required>
                        <option value="Breakfast">Breakfast</option>
                        <option value="Lunch">Lunch</option>
                        <option value="Dinnner">Dinnner</option>
                       </select>
                    </div>
                  </div>


                  <div class="row mb-3">
                    <label for="inputText" class="col-sm-4 col-form-label"
                      >Name</label
                    >
                    <div class="col-sm-8">
                      <input type="text" name="name" class="form-control" required/>
                    </div>
                  </div>

                  <div class="row mb-3">
                    <label for="inputText" class="col-sm-4 col-form-label"
                      >Description</label
                    >
                    <div class="col-sm-8">
                      <textarea name="description" class="form-control" id="" required></textarea>
                    </div>
                  </div>


                  <div class="row mb-3">
                    <label for="inputText" class="col-sm-4 col-form-label"
                      >Image</label
                    >
                    <div class="col-sm-8">
                      <input type="file" name="file" class="form-control" required/>
                    </div>
                  </div>

                  <div class="row mb-3">
                    <div class="text-end">
                      <button type="submit" name="Submit" class="btn btn-primary">
                        Submit
                      </button>
                    </div>
                  </div>
                </form>

              </div>
              <div class="modal-footer">
                <button
                  type="button"
                  class="btn btn-secondary"
                  data-bs-dismiss="modal"
                >
                  Close
                </button>
              </div>
            </div>
          </div>
        </div>



        <div class="row">
          <div class="col-lg-12">
            <div class="card">
              <div class="card-body">
                <!-- Table with stripped rows -->
                <table class="table datatable">
                  <thead>
                    <tr>
                      <th scope="col">ID</th>
                      <th scope="col">Image</th>
                      <th scope="col">Category Name</th>
                      <th scope="col">Name</th>
                      <th scope="col">Created At</th>
                      <th scope="col">Actions</th>
                    </tr>
                  </thead>
                  <tbody>


                  <?php
$sql1 = mysqli_query($con, "SELECT * from user_meals_plans WHERE user_id = '$user_id' ORDER BY id DESC");

while ($row1 = mysqli_fetch_array($sql1)) {

    $meal_id = $row1['meal_id'];

    $sql2 = mysqli_query($con, "SELECT * from meals WHERE id = '$meal_id'");
    $row2 = mysqli_fetch_array($sql2);

    $meal_name = $row2['name'];
    $image = $row2['image'];
    $category_name = $row2['category_name'];
    $nutrition_center_id = $row2['nutrition_center_id'];
    $active = $row2['active'];
    $created_at = $row2['created_at'];

    if ($nutrition_center_id == $C_ID) {

        ?>
                    <tr>
                      <th scope="row"><?php echo $meal_id ?></th>
                      <td scope="row"><img src="<?php echo $image ?>" alt="" height="50px" width="50px"></td>
                      <td scope="row"><?php echo $category_name ?></td>
                      <th scope="row"><?php echo $meal_name ?></th>
                      <th scope="row"><?php echo $created_at ?></th>
                      <th scope="row">

                      <?php if ($active == 1) {?>

<a href="./DeleteOrRestoreMeal.php?meal_id=<?php echo $meal_id ?>&isActive=<?php echo 0 ?>&user_id=<?php echo $user_id ?>" class="btn btn-danger">Delete</a>

<?php } else {?>

  <a href="./DeleteOrRestoreMeal.php?meal_id=<?php echo $meal_id ?>&isActive=<?php echo 1 ?>&user_id=<?php echo $user_id ?>" class="btn btn-primary">Restore</a>

<?php }?>
                      </th>
                    </tr>
<?php
}
}?>
                  </tbody>
                </table>
                <!-- End Table with stripped rows -->
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>
    <!-- End #main -->

    <!-- ======= Footer ======= -->
    <footer id="footer" class="footer">
      <div class="copyright">
        &copy; Copyright <strong><span>FitAtHome</span></strong
        >. All Rights Reserved
      </div>
    </footer>
    <!-- End Footer -->

    <a
      href="#"
      class="back-to-top d-flex align-items-center justify-content-center"
      ><i class="bi bi-arrow-up-short"></i
    ></a>

    <script>
    window.addEventListener('DOMContentLoaded', (event) => {
     document.querySelector('#sidebar-nav .nav-item:nth-child(3) .nav-link').classList.remove('collapsed')
   });
</script>

    <!-- Vendor JS Files -->
    <script src="../assets/vendor/apexcharts/apexcharts.min.js"></script>
    <script src="../assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="../assets/vendor/chart.js/chart.umd.js"></script>
    <script src="../assets/vendor/echarts/echarts.min.js"></script>
    <script src="../assets/vendor/quill/quill.min.js"></script>
    <script src="../assets/vendor/simple-datatables/simple-datatables.js"></script>
    <script src="../assets/vendor/tinymce/tinymce.min.js"></script>
    <script src="../assets/vendor/php-email-form/validate.js"></script>

    <!-- Template Main JS File -->
    <script src="../assets/js/main.js"></script>
  </body>
</html>
