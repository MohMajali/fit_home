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

    $existUserCategory = mysqli_query($con, "select id from user_categories where user_id='$user_id'");
    $existUserCategoryNumber = mysqli_num_rows($existUserCategory);

    $existCategoryId;

    if ($existUserCategoryNumber > 0) {

        $stmt = $con->prepare("SELECT category_id FROM user_categories WHERE user_id = ?");
        $stmt->bind_param("i", $user_id);

        $stmt->execute();

        $stmt->store_result();

        if ($stmt->num_rows > 0) {

            $stmt->bind_result($category_id);
            $stmt->fetch();

            $existCategoryId = $category_id;
        }
    }

    $center_id = $row1['id'];
    $name = $row1['name'];
    $email = $row1['email'];

    if (isset($_POST['Submit'])) {

        $user_id = $_POST['user_id'];
        $plan_id = $_POST['plan_id'];
        $category_id = $_POST['category_id'];

        $stmt = $con->prepare("INSERT INTO user_categories (category_id, user_id) VALUES (?, ?)");
        $stmt->bind_param("ii", $category_id, $user_id);

        if ($stmt->execute()) {

            $stmt = $con->prepare("INSERT INTO user_plans (plan_id, user_id) VALUES (?, ?)");
            $stmt->bind_param("ii", $plan_id, $user_id);

            if ($stmt->execute()) {

                echo "<script language='JavaScript'>
              alert ('Plan Added To User !');
         </script>";

                echo "<script language='JavaScript'>
        document.location='./Plans.php?user_id={$user_id}';
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

    <title>Plans - FitAtHome</title>
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
        <h1>Plans</h1>
        <nav>
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="index.php">Dashboard</a></li>
            <li class="breadcrumb-item">Plans</li>
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
            Add Plan
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

                <form method="POST" action="./Plans.php?user_id=<?php echo $user_id ?>" enctype="multipart/form-data">

                <input type="hidden" value="<?php echo $user_id ?>" name="user_id">
                <input type="hidden" value="<?php echo $existUserCategoryNumber ?>" name="existUserCategoryNumber" id="existUserCategoryNumber">



<?php if ($existUserCategoryNumber === 0) {?>

                <div class="row mb-3">
                    <label for="categories" class="col-sm-4 col-form-label"
                      >Categories</label
                    >
                    <div class="col-sm-8">
                       <select name="category_id" class="form-select" id="categories" required>

                       <option value="" selected disabled>Select Category</option>
                       <?php

    $categoriesSql = mysqli_query($con, "SELECT * from categories WHERE active = 1 ORDER BY id DESC");

    while ($categoryRow = mysqli_fetch_array($categoriesSql)) {

        $category_id = $categoryRow['id'];
        $category_name = $categoryRow['weight_range'] . ' ' . $categoryRow['tall_range'];

        ?>

                        <option value="<?php echo $category_id ?>"><?php echo $category_name ?></option>
<?php
}?>
                       </select>
                    </div>
                  </div>
                  <?php }?>







                  <?php if ($existUserCategoryNumber > 0) {?>

                <div class="row mb-3">
                    <label for="level" class="col-sm-4 col-form-label"
                      >Levels</label
                    >
                    <div class="col-sm-8">
                       <select name="levels_id" class="form-select" id="levels" required>


                       <option value="" selected disabled>Select Level</option>

                       <?php

    $levelsSql = mysqli_query($con, "SELECT * from levels WHERE active = 1 AND category_id = '$existCategoryId' ORDER BY id DESC");

    while ($levelRow = mysqli_fetch_array($levelsSql)) {

        $level_id = $levelRow['id'];
        $level_name = $levelRow['name'];

        ?>

                        <option value="<?php echo $level_id ?>"><?php echo $level_name ?></option>
<?php
}?>

                       </select>
                    </div>
                  </div>

                  <?php } else {?>

                    <div class="row mb-3">
                    <label for="level" class="col-sm-4 col-form-label"
                      >Levels</label
                    >
                    <div class="col-sm-8">
                       <select name="levels_id" class="form-select" id="levels" required>

                       <option value="" selected disabled>Select Level</option>

                       </select>
                    </div>
                  </div>

                  <?php }?>



                <div class="row mb-3">
                    <label for="plan" class="col-sm-4 col-form-label"
                      >Plans</label
                    >
                    <div class="col-sm-8">
                       <select name="plan_id" class="form-select" id="plans" required>

                       <option value="" selected disabled>Select Plan</option>
                       </select>
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
                      <th scope="col">User Name</th>
                      <th scope="col">Level</th>
                      <th scope="col">Plan</th>
                      <th scope="col">Done</th>
                      <th scope="col">Created At</th>
                      <th scope="col">Actions</th>
                    </tr>
                  </thead>
                  <tbody>


                  <?php

$sql1 = mysqli_query($con, "SELECT * from user_plans WHERE user_id = '$user_id' ORDER BY id DESC");

while ($row1 = mysqli_fetch_array($sql1)) {

    $user_plan_id = $row1['id'];
    $plan_id = $row1['plan_id'];
    $is_done = $row1['is_done'];
    $created_at = $row1['created_at'];

    $sql2 = mysqli_query($con, "SELECT * from plans WHERE id = '$plan_id' AND active = 1");
    $row2 = mysqli_fetch_array($sql2);

    $level_id = $row2['level_id'];
    $plan_name = $row2['name'];

    $sql3 = mysqli_query($con, "SELECT * from levels WHERE id = '$level_id' AND active = 1");
    $row3 = mysqli_fetch_array($sql3);

    $level_name = $row3['name'];

    $sql4 = mysqli_query($con, "SELECT * from users WHERE id = '$user_id'");
    $row4 = mysqli_fetch_array($sql4);

    $user_name = $row4['name'];

    ?>
                    <tr>
                      <th scope="row"><?php echo $plan_id ?></th>
                      <td scope="row"><?php echo $user_name ?></td>
                      <td scope="row"><?php echo $level_name ?></td>
                      <td scope="row"><?php echo $plan_name ?></td>
                      <th scope="row"><?php echo $is_done ?></th>
                      <th scope="row"><?php echo $created_at ?></th>
                      <th scope="row">

                      <a href="Delete_Plan.php?user_plan_id=<?php echo $user_plan_id ?>&user_id=<?php echo $user_id ?>" class="btn btn-danger">Delete</a>
                      </th>
                    </tr>
<?php
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





    <script>


        console.log()



        if(document.getElementById('existUserCategoryNumber').value == 0) {


          document.getElementById('categories').addEventListener('change', function(){
  
          const categoryId = this.value;
          const levelsDropdown = document.getElementById('levels');
          const plansDropdown = document.getElementById('plans');
  
  
          levelsDropdown.innerHTML = '<option value="">Select Level</option>';
          plansDropdown.innerHTML = '<option value="">Select Plan</option>';
  
  
  
          if(categoryId) {
  
              fetch(`./Get_Levels.php?category_id=${categoryId}`)
              .then(response => response.json())
              .then(data => {
  
                  data.forEach(level => {
                          const option = document.createElement('option');
                          option.value = level.id;
                          option.textContent = level.name;
                          levelsDropdown.appendChild(option);
                      });
              })
          }
  
          })

        }


        document.getElementById('levels').addEventListener('change', function () {
        const levelId = this.value;
        
        const plansDropdown = document.getElementById('plans');

        plansDropdown.innerHTML = '<option value="">Select Plan</option>';

        if (levelId) {
            fetch(`Get_Plans.php?level_id=${levelId}`)
                .then(response => response.json())
                .then(data => {
                    data.forEach(plan => {
                        const option = document.createElement('option');
                        option.value = plan.id;
                        option.textContent = plan.name;
                        plansDropdown.appendChild(option);
                    });
                });
        }
    });
    </script>
  </body>
</html>
