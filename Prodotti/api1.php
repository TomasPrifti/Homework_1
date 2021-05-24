<?php

$api_key = "47acbd1bd0424de6b34f73a2162b0bd5";
$URLingredient = "https://spoonacular.com/cdn/ingredients_500x500/";

$newJson = array();

if($_GET["type"] == "products") {
    $url = "https://api.spoonacular.com/food/ingredients/search?apiKey=".$api_key."&query=".$_GET["query"];
    $json = callAPI($url);
    for ($i = 0; $i < count($json["results"]); $i++) {
        $newJson[] = array("id" => $json["results"][$i]["id"], "name" => $json["results"][$i]["name"], "image" => $URLingredient.$json["results"][$i]["image"]);
    }
} else if ($_GET["type"] == "informations") {
    $url = "https://api.spoonacular.com/food/ingredients/".$_GET["id"]."/information?amount=1&apiKey=".$api_key;
    $newJson = callAPI($url);
    $newJson["image"] = $URLingredient.$newJson["image"];
}

echo json_encode($newJson);

exit;

function callAPI($url) {
    $curl = curl_init();
    curl_setopt($curl, CURLOPT_URL, $url);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
    $result = curl_exec($curl);
    curl_close($curl);
    return json_decode($result, true);
}

?>