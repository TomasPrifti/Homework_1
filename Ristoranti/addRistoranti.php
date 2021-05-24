<?php

$conn = mysqli_connect("localhost", "root", null, "progetto_ristoranti") or die("(Error during connection with database)");
$query = "SELECT * FROM ristorante";
$res = mysqli_query($conn, $query);

$json = array();
while($row = mysqli_fetch_object($res)) {
    if($row->nome == null) {
        continue;
    }
    $json[] = ["name" => $row->nome, "address" => $row->indirizzo, "description" => $row->descrizione, "image" => file_exists($row->immagine) ? $row->immagine : "Immagini/notFound.jpg" ];
}

mysqli_free_result($res);
mysqli_close($conn);

echo json_encode($json);
exit;

?>