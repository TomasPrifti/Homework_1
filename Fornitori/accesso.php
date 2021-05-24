<?php

if($_POST["type"] == "login") {
    login();
} else if($_POST["type"] == "register") {
    register();
} else if($_POST["type"] == "logout") {
    logout();
} else if($_POST["type"] == "update") {
    update();
} else if($_POST["type"] == "delete") {
    delete();
}

exit;

function login() {
    $conn = mysqli_connect("localhost", "root", null, "progetto_ristoranti") or die("(Error during connection with database)");
    
    $username = mysqli_real_escape_string($conn, $_POST["username"]);
    $password = mysqli_real_escape_string($conn, $_POST["password"]);

    $query = "SELECT * FROM fornitore WHERE username = '$username';";
    $row = mysqli_fetch_object(mysqli_query($conn, $query));
    mysqli_close($conn);
    
    if($row == null) {
        echo json_encode("error_login_username");
        exit;
    }
    if(!password_verify($password, $row->password)) {
        echo json_encode("error_login_password");
        exit;
    }
    session_start();
    $_SESSION["for_username_session"] = $username;
    echo json_encode("login");
    exit;
}

function register() {
    $conn = mysqli_connect("localhost", "root", null, "progetto_ristoranti") or die("(Error during connection with database)");
    
    $username = mysqli_real_escape_string($conn, $_POST["username"]);
    $password = password_hash(mysqli_real_escape_string($conn, $_POST["password"]), PASSWORD_BCRYPT);
    $email = mysqli_real_escape_string($conn, $_POST["email"]);
    $name = mysqli_real_escape_string($conn, $_POST["name"]);
    $address = mysqli_real_escape_string($conn, $_POST["address"]);

    $query = "SELECT * FROM fornitore WHERE username = '$username';";
    $row = mysqli_fetch_object(mysqli_query($conn, $query));
    if($row != null) {
        mysqli_close($conn);
        echo json_encode("error_register_username");
        exit;
    }

    $query = "INSERT INTO fornitore (username, password, email";
    if($name != null) {
        $query .= ", nome";
    }
    if($address != null) {
        $query .= ", indirizzo";
    }
    $query .= ") VALUES ('$username', '$password', '$email'";
    if($name != null) {
        $query .= ", '$name'";
    }
    if($address != null) {
        $query .= ", '$address'";
    }
    $query .= ");";
    mysqli_query($conn, $query);
    mysqli_close($conn);
    session_start();
    $_SESSION["for_username_session"] = $username;
    echo json_encode("register");
    exit;
}

function logout() {
    session_start();
    session_destroy();
    echo json_encode("logout");
    exit;
}

function update() {
    $conn = mysqli_connect("localhost", "root", null, "progetto_ristoranti") or die("(Error during connection with database)");
    session_start();

    $name = mysqli_real_escape_string($conn, $_POST["name"]);
    $address = mysqli_real_escape_string($conn, $_POST["address"]);

    $query = "UPDATE fornitore SET nome = '$name', indirizzo = '$address' WHERE username = '".$_SESSION["for_username_session"]."';";
    mysqli_query($conn, $query);
    mysqli_close($conn);
    echo json_encode("update");
    exit;
}

function delete() {
    $conn = mysqli_connect("localhost", "root", null, "progetto_ristoranti") or die("(Error during connection with database)");
    session_start();
    $query = "DELETE FROM fornitore WHERE username = '".$_SESSION["for_username_session"]."';";
    mysqli_query($conn, $query);
    mysqli_close($conn);
    session_destroy();
    echo json_encode("delete");
    exit;
}

?>