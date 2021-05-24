<?php

$username = null;
$existUserRes = false;
$existUserFor = false;

session_start();
if (isset($_SESSION["res_username_session"])) {
    $username = $_SESSION["res_username_session"];
    $existUserRes = true;
} else if (isset($_SESSION["for_username_session"])) {
    $username = $_SESSION["for_username_session"];
    $existUserFor = true;
}

?>

<!DOCTYPE html>
<html>

<head>
    <title>Prodotti - Catena di Ristoranti</title>
    <link rel="stylesheet" href="../aspettoCondiviso.css">
    <link rel="stylesheet" href="../utenteCondiviso.css">
    <link rel="stylesheet" href="prodotti.css" />
    <link href="https://fonts.googleapis.com/css2?family=Dela+Gothic+One&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Economica&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Space+Mono&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Cherry+Swash&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Arbutus&display=swap" rel="stylesheet">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="script.js" defer></script>
</head>

<body>
    <header>
        <nav>
            <a href="../Home/home.html"><strong>HOME</strong></a>
            <a href="../Ristoranti/ristoranti.php"><strong>RISTORANTI</strong></a>
            <a href="../Fornitori/fornitori.php"><strong>FORNITORI</strong></a>
            <a href=""><strong>PRODOTTI</strong></a>
        </nav>
        <div id="menu">
            <div></div>
            <div></div>
            <div></div>
        </div>

        <div id="overlay">
            <!-- Overlay -->
        </div>
        <div id="id_1">
            <!-- Titolo provvisorio. Potrebbe subire modifiche -->
            <strong>Catena di</br>Ristoranti</strong>
        </div>
        <div id="id_2">
            <strong>PRODOTTI</strong>
            <?php
            if ($existUserRes || $existUserFor) {
                echo '<div id="login">';
                echo    '<span id="title_login">Benvenuto ' . $username . ' !</span>';
                echo    '<div>';
                if ($existUserRes) {
                    echo     '<input id="preference", type="button", value="Preferiti">';
                }
                echo        '<input id="logout", type="button", value="Logout">';
                echo    '</div>';
                echo '</div>';
            }
            ?>
        </div>

    </header>

    <section>

        <div class="lateral_block">
            <!-- <img src=""> -->
        </div>

        <div id="main_block">

            <h1 id="title_blocks">
                Tutti i Prodotti
            </h1>

            <div id="input_block">
                <input id="input_images" , type="button" , value="Nuove Immagini">
                <form>
                    <span>Cerca:</span>
                    <input id="input_content" , type="text">
                    <input id="input_button" , type="submit" , value="Cerca">
                </form>
            </div>

            <div id="all_blocks">
                <!-- 
                <div class="block">
                    <h1 class="name">

                    </h1>
                    <img class="image" src="">
                </div>
                 -->
            </div>

        </div>

        <div class="lateral_block">
            <!-- <img src=""> -->
        </div>

        <div id="modal" , class="hidden">

            <div id="modal_block" , class="flex">
                <img id="modal_image" src="">
                <div id="modal_content">
                    <h1 id="modal_name"></h1>
                    <div id="modal_text"></div>
                    <?php
                    if ($existUserRes) {
                        echo "<input id='modal_preference', type='button', value='Aggiungi ai Preferiti'>";
                        echo "<span></span>";
                    }
                    ?>
                </div>
            </div>

            <div id="modal_block_preference" , class="flex">
                <h1 id="modal_title">Prodotti Preferiti</h1>
                <div id="products">
                    <!-- 
                        <div class="product">
                            <div class="product_info">
                                <h1>Nome</h1>
                                <span>Costo</span>
                            </div>
                            <input class="product_button", type="button", value="Rimuovi">
                        </div>
                    -->
                </div>
            </div>

        </div>

    </section>

    <footer>
        <div>
            Seguici anche sui social !</br>
            <em>Powered by</br>Prifti Tomas O46002191</em>
        </div>
    </footer>
</body>

</html>