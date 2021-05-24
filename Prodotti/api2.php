<?php

$curl = curl_init();
curl_setopt($curl, CURLOPT_URL, "https://foodish-api.herokuapp.com/api");
curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
$result = curl_exec($curl);
curl_close($curl);
echo $result;
exit;

?>