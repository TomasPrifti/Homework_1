<?php

if($_POST["type"] == "logout") {
    logout();
} else if($_POST["type"] == "addPreference") {
    addPreference();
} else if($_POST["type"] == "showPreference") {
    showPreference();
} else if($_POST["type"] == "removePreference") {
    removePreference();
}

exit;

function logout() {
    session_start();
    session_destroy();
    echo json_encode("logout");
    exit;
}

function addPreference() {
    $conn = mysqli_connect("localhost", "root", null, "progetto_ristoranti") or die("(Error during connection with database)");
    session_start();

    $name = mysqli_real_escape_string($conn, $_POST["name"]);
    $price = mysqli_real_escape_string($conn, $_POST["price"]);

    $query = "SELECT id FROM ristorante WHERE username = '".$_SESSION["res_username_session"]."';";
    $id = mysqli_fetch_object(mysqli_query($conn, $query))->id;
    
    $query = "INSERT INTO preferiti(id, nome, costo) VALUES ('$id', '$name', '$price');";
    mysqli_query($conn, $query);
    mysqli_close($conn);
    echo json_encode("addPreference");
    exit;
}

function showPreference() {
    $conn = mysqli_connect("localhost", "root", null, "progetto_ristoranti") or die("(Error during connection with database)");
    session_start();

    $query = "SELECT id FROM ristorante WHERE username = '".$_SESSION["res_username_session"]."';";
    $id = mysqli_fetch_object(mysqli_query($conn, $query))->id;
    
    $query = "SELECT * FROM preferiti WHERE id = '$id';";
    $res = mysqli_query($conn, $query);

    $json = array();
    while($row = mysqli_fetch_object($res)) {
        $json[] = ["name" => $row->nome, "cost" => $row->costo];
    }

    mysqli_free_result($res);
    mysqli_close($conn);

    echo json_encode($json);
    exit;
}

function removePreference() {
    $conn = mysqli_connect("localhost", "root", null, "progetto_ristoranti") or die("(Error during connection with database)");
    session_start();

    $name = mysqli_real_escape_string($conn, $_POST["name"]);
    $query = "SELECT id FROM ristorante WHERE username = '".$_SESSION["res_username_session"]."';";
    $id = mysqli_fetch_object(mysqli_query($conn, $query))->id;

    $query = "DELETE FROM preferiti WHERE id = '$id' AND nome = '$name';";
    mysqli_query($conn, $query);
    mysqli_close($conn);

    echo json_encode("removePreference");
    exit;
}

?>