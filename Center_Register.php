<?php
session_start();

include "./Connect.php";

if (isset($_POST['Submit'])) {

    $name = $_POST['name'];
    $password = md5($_POST['password']);
    $email = $_POST['email'];
    $phone = $_POST['phone'];
    $image = $_FILES["file"]["name"];
    $image = 'Center_Images/' . $image;
    $price;

    $start_date = $_POST['start_date'];
    $subscription_type = $_POST['subscription_type'];

    if ($subscription_type == 1) {

        $end_date = date('d-m-Y', strtotime($start_date . ' +90 days'));
        $subscription_type = "3 Months Open Contract (First Time Only) (For Free)";
        $price = 0;

    } else if ($subscription_type == 2) {

        $end_date = date('d-m-Y', strtotime($start_date . ' +180 days'));
        $subscription_type = "6 Months Contract (300 JOD)";
        $price = 300;

    } else if ($subscription_type == 3) {

        $end_date = date('d-m-Y', strtotime($start_date . ' +360 days'));
        $subscription_type = "12 Months COntract (600 JOD)";
        $price = 600;

    }

    $query = mysqli_query($con, "SELECT * FROM nutrition_centers WHERE name ='$name' AND email = '$email'");

    if (mysqli_num_rows($query) > 0) {

        echo "<script language='JavaScript'>
      alert ('Center Already Exist !');
 </script>";

    } else {

        $stmt = $con->prepare("INSERT INTO nutrition_centers (name, email, phone, password, image) VALUES (?, ?, ?, ?, ?) ");

        $stmt->bind_param("sssss", $name, $email, $phone, $password, $image);

        if ($stmt->execute()) {

            $stmt = $con->prepare("SELECT id FROM nutrition_centers WHERE name = ?");
            $stmt->bind_param("s", $name);
            $stmt->execute();
            $stmt->store_result();

            if ($stmt->num_rows > 0) {

                $stmt->bind_result($id);
                $stmt->fetch();

                $stmt = $con->prepare("INSERT INTO nutrition_center_subscriptions (nutrition_center_id, subscription_type, start_date, end_date, price) VALUES (?, ?, ?, ?, ?)");

                $stmt->bind_param("issss", $id, $subscription_type, $start_date, $end_date, $price);

                if ($stmt->execute()) {

                    move_uploaded_file($_FILES["file"]["tmp_name"], "./Center_Dashboard/Center_Images/" . $_FILES["file"]["name"]);

                    echo "<script language='JavaScript'>
                alert ('Center Registered Successfully !');
           </script>";

                    echo "<script language='JavaScript'>
          document.location='./Center_Login.php';
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

    <title>Center Register Page</title>
    <meta content="" name="description" />
    <meta content="" name="keywords" />

    <!-- Favicons -->
    <link href="assets/img/Logo.png" rel="icon" />
    <link href="assets/img/Logo.png" rel="apple-touch-icon" />

    <!-- Google Fonts -->
    <link href="https://fonts.gstatic.com" rel="preconnect" />
    <link
      href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Nunito:300,300i,400,400i,600,600i,700,700i|Poppins:300,300i,400,400i,500,500i,600,600i,700,700i"
      rel="stylesheet"
    />

    <!-- Vendor CSS Files -->
    <link
      href="assets/vendor/bootstrap/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      href="assets/vendor/bootstrap-icons/bootstrap-icons.css"
      rel="stylesheet"
    />
    <link href="assets/vendor/boxicons/css/boxicons.min.css" rel="stylesheet" />
    <link href="assets/vendor/quill/quill.snow.css" rel="stylesheet" />
    <link href="assets/vendor/quill/quill.bubble.css" rel="stylesheet" />
    <link href="assets/vendor/remixicon/remixicon.css" rel="stylesheet" />
    <link href="assets/vendor/simple-datatables/style.css" rel="stylesheet" />

    <!-- Template Main CSS File -->
    <link href="assets/css/style.css" rel="stylesheet" />
  </head>

  <body>
    <main>
      <div class="container">
        <section
          class="section register min-vh-100 d-flex flex-column align-items-center justify-content-center py-4"
        >
          <div class="container">
            <div class="row justify-content-center">
              <div
                class="col-lg-12 col-md-12 d-flex flex-column align-items-center justify-content-center"
              >
                <div class="d-flex justify-content-center py-4">
                  <a
                    href="index.php"
                    class="logo d-flex align-items-center w-auto"
                  >
                    <img src="assets/img/Logo.png" alt="" width="50px"/>
                    <span class="d-none d-lg-block text-uppercase"
                      >FitAtHome</span
                    >
                  </a>
                </div>
                <!-- End Logo -->

                <div class="card mb-3">
                  <div class="card-body">
                    <div class="pt-4 pb-2">
                      <h5 class="card-title text-center pb-0 fs-4">
                        Create New Center Account
                      </h5>
                      <p class="text-center small">
                        Enter Information
                      </p>
                    </div>

                    <form class="row g-3 needs-validation" method="POST" action="./Center_Register.php" enctype="multipart/form-data" id="login-form">

                      <div class="col-6">
                        <label for="name" class="form-label">Name</label>
                        <div class="input-group has-validation">

                          <input
                            type="text"
                            name="name"
                            class="form-control"
                            id="name"
                            required
                          />

                        </div>
                      </div>

                      <div class="col-6">
                        <label for="name" class="form-label">Email</label>
                        <div class="input-group has-validation">

                          <input
                            type="email"
                            name="email"
                            class="form-control"
                            id="email"
                            required
                          />

                        </div>
                      </div>


                      <div class="col-6">
                        <label for="name" class="form-label">Phone</label>
                        <div class="input-group has-validation">

                          <input
                            type="text"
                            name="phone"
                            class="form-control"
                            id="phone"
                            pattern="[0-9]{10}" title="Phone Number Must Be 10 Numbers"
                            required
                          />

                        </div>
                      </div>



                      <div class="col-6">
                        <label for="yourPassword" class="form-label"
                          >Password</label
                        >
                        <input
                          type="password"
                          name="password"
                          class="form-control"
                          id="yourPassword"
                          required
                        />
                        <div class="invalid-feedback" id="password-Message">
                          Please enter your password!
                        </div>
                      </div>

                      <div class="col-12">
                        <label for="startDate" class="form-label"
                          >Contract Start Date</label
                        >
                        <input
                          type="date"
                          name="start_date"
                          min="<?php echo date('Y-m-d') ?>"
                          class="form-control"
                          id="startDate"
                          required
                        />
                      </div>

                      <div class="col-12">
                      <label for="subscription_type" class="form-label"
                          >Select Contract Type</label
                        >
                        <select name="subscription_type" class="form-select" id="subscription_type" required>
                            <option value="1">3 Months Open Contract (First Time Only) (For Free)</option>
                            <option value="2">6 Months Contract (300 JOD)</option>
                            <option value="3">12 Months COntract (600 JOD)</option>
                        </select>
                      </div>

                      <div class="col-12">
                        <label for="yourImage" class="form-label"
                          >Image</label
                        >
                        <input
                          type="file"
                          name="file"
                          class="form-control"
                          id="yourImage"
                          required
                        />

                      </div>




                      <div class="col-12">
                        <button class="btn btn-primary w-100" type="submit" name="Submit">
                          Signup
                        </button>
                      </div>
                      <div class="col-12">
                        <p class="small mb-0">
                          Already Have Account
                          <a href="./Center_Login.php">Login Now</a>
                        </p>
                      </div>
                    </form>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </section>
      </div>
    </main>
    <!-- End #main -->

    <a
      href="#"
      class="back-to-top d-flex align-items-center justify-content-center"
      ><i class="bi bi-arrow-up-short"></i
    ></a>

    <!-- Vendor JS Files -->
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="assets/vendor/apexcharts/apexcharts.min.js"></script>
    <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="assets/vendor/chart.js/chart.umd.js"></script>
    <script src="assets/vendor/echarts/echarts.min.js"></script>
    <script src="assets/vendor/quill/quill.min.js"></script>
    <script src="assets/vendor/simple-datatables/simple-datatables.js"></script>
    <script src="assets/vendor/tinymce/tinymce.min.js"></script>
    <script src="assets/vendor/php-email-form/validate.js"></script>

    <!-- Template Main JS File -->
    <script src="assets/js/main.js"></script>
  </body>
</html>
