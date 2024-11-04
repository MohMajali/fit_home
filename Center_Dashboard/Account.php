<?php
session_start();

include "../Connect.php";

$C_ID = $_SESSION['C_Log'];

if (!$C_ID) {

    echo '<script language="JavaScript">
     document.location="../Center_Login.php";
    </script>';

} else {

    $sql1 = mysqli_query($con, "select * from nutrition_centers where id = '$C_ID'");
    $row1 = mysqli_fetch_array($sql1);

    $center_id = $row1['id'];
    $name = $row1['name'];
    $email = $row1['email'];
    $phone = $row1['phone'];
    $description = $row1['description'];

    if (isset($_POST['Submit'])) {

        $center_id = $_POST['center_id'];
        $name = $_POST['name'];
        $email = $_POST['email'];
        $phone = $_POST['phone'];
        $description = $_POST['description'];
        $password = $_POST['password'];
        $image = $_FILES["file"]["name"];

        if ($image) {

            $image = 'Center_Images/' . $image;

            if ($password) {

                $password = md5($password);

                $stmt = $con->prepare("UPDATE nutrition_centers SET image = ?, name = ?, email = ?, phone = ?, description = ?, password = ? WHERE id = ? ");
                $stmt->bind_param("ssssssi", $image, $name, $email, $phone, $description, $password, $center_id);

            } else {

                $stmt = $con->prepare("UPDATE nutrition_centers SET image = ?, name = ?, email = ?, phone = ?, description = ? WHERE id = ? ");
                $stmt->bind_param("sssssi", $image, $name, $email, $phone, $description, $center_id);
            }

            if ($stmt->execute()) {

                move_uploaded_file($_FILES["file"]["tmp_name"], "./Center_Images/" . $_FILES["file"]["name"]);

                echo "<script language='JavaScript'>
                alert ('Account Updated Successfully !');
           </script>";

                echo "<script language='JavaScript'>
          document.location='./Account.php';
             </script>";

            }

        } else {

            if ($password) {

                $password = md5($password);

                $stmt = $con->prepare("UPDATE nutrition_centers SET name = ?, email = ?, phone = ?, description = ?, password = ? WHERE id = ? ");
                $stmt->bind_param("sssssi", $name, $email, $phone, $description, $password, $center_id);

            } else {

                $stmt = $con->prepare("UPDATE nutrition_centers SET name = ?, email = ?, phone = ?, description = ? WHERE id = ? ");
                $stmt->bind_param("ssssi", $name, $email, $phone, $description, $center_id);

            }

            if ($stmt->execute()) {

                echo "<script language='JavaScript'>
              alert ('Account Updated Successfully !');
         </script>";

                echo "<script language='JavaScript'>
        document.location='./Account.php';
           </script>";

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

    <title>Account - FitAtHome</title>
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
        <h1>Account</h1>
        <nav>
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="index.php">Dashboard</a></li>
            <li class="breadcrumb-item">Account</li>
          </ol>
        </nav>
      </div>
      <!-- End Page Title -->
      <section class="section">
        <div class="row">
          <div class="col-lg-12">
            <div class="card">
              <div class="card-body">
                <h5 class="card-title"></h5>

                <!-- Horizontal Form -->
                <form method="POST" action="./Account.php" enctype="multipart/form-data">

                <input type="hidden" name="center_id" value="<?php echo $C_ID ?>">

                  <div class="row mb-3">
                    <label for="name" class="col-sm-2 col-form-label"
                      >Name</label
                    >
                    <div class="col-sm-10">
                      <input type="text" name="name" value="<?php echo $name ?>" class="form-control" id="name" />
                    </div>
                  </div>

                  <div class="row mb-3">
                    <label for="email" class="col-sm-2 col-form-label"
                      >Email</label
                    >
                    <div class="col-sm-10">
                      <input type="text" name="email" value="<?php echo $email ?>" class="form-control" id="email" />
                    </div>
                  </div>

                  <div class="row mb-3">
                    <label for="phone" class="col-sm-2 col-form-label"
                      >Phone</label
                    >
                    <div class="col-sm-10">
                      <input type="text" name="phone" value="<?php echo $phone ?>"
                      pattern="[0-9]{10}" title="Phone Number Must Be 10 Numbers"
                      class="form-control" id="phone" />
                    </div>
                  </div>

                  <div class="row mb-3">
                    <label for="password" class="col-sm-2 col-form-label"
                      >Password</label
                    >
                    <div class="col-sm-10">
                      <input type="password" name="password" class="form-control" id="password" />
                    </div>
                  </div>

                  <div class="row mb-3">
                    <label for="description" class="col-sm-2 col-form-label"
                      >Description</label
                    >
                    <div class="col-sm-10">
                       <textarea name="description" class="form-control" id=""><?php echo $description ?></textarea>
                    </div>
                  </div>

                  <div class="row mb-3">
                    <label for="file" class="col-sm-2 col-form-label"
                      >Image</label
                    >
                    <div class="col-sm-10">
                      <input type="file" name="file" class="form-control" id="file" />
                    </div>
                  </div>



                  <div class="text-end">
                    <button type="submit" name="Submit" class="btn btn-primary">
                      Submit
                    </button>
                    <button type="reset" class="btn btn-secondary">
                      Reset
                    </button>
                  </div>
                </form>
                <!-- End Horizontal Form -->
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
     document.querySelector('#sidebar-nav .nav-item:nth-child(2) .nav-link').classList.remove('collapsed')
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
