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

function loginProfileValue($existUserFor)
{
    if ($existUserFor) {
        return "Profilo";
    }
    return "Accedi";
}
function registerLogoutValue($existUserFor)
{
    if ($existUserFor) {
        return "Logout";
    }
    return "Registrati";
}
function loginProfileId($existUserFor)
{
    if ($existUserFor) {
        return "profile";
    }
    return "input_login";
}
function registerLogoutId($existUserFor)
{
    if ($existUserFor) {
        return "logout";
    }
    return "input_register";
}

?>

<html>

<head>
    <title>Fornitori - Catena di Ristoranti</title>
    <link rel="stylesheet" href="../aspettoCondiviso.css">
    <link rel="stylesheet" href="../utenteCondiviso.css">
    <link rel="stylesheet" href="fornitori.css" />
    <link href="https://fonts.googleapis.com/css2?family=Dela+Gothic+One&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Economica&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Space+Mono&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Cherry+Swash&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Port+Lligat+Sans&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Arbutus&display=swap" rel="stylesheet">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="script.js" defer></script>
</head>

<body>
    <header>
        <nav>
            <a href="../Home/home.html"><strong>HOME</strong></a>
            <a href="../Ristoranti/ristoranti.php"><strong>RISTORANTI</strong></a>
            <a href=""><strong>FORNITORI</strong></a>
            <a href="../Prodotti/prodotti.php"><strong>PRODOTTI</strong></a>
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
            <strong>FORNITORI</strong>
            <div id="login">
                <span id="title_login">
                    <?php
                    if (!$existUserFor && !$existUserRes)
                        echo "Sei un Fornitore ?";
                    else
                        echo "Benvenuto $username !";
                    ?>
                </span>
                <div>
                    <?php
                    if (!$existUserRes) {
                        echo '<input id='.loginProfileId($existUserFor).' , type="button" , value='.loginProfileValue($existUserFor).'>';
                        echo '<span>oppure</span>';
                        echo '<input id='.registerLogoutId($existUserFor).' , type="button" , value='.registerLogoutValue($existUserFor).'>';
                    } else {
                        echo '<input id="logout_res", type="button", value="Logout">';
                    }
                    ?>
                </div>
            </div>
        </div>

    </header>

    <section>

        <h1 id="title_blocks">Tutti i Fornitori</h1>
        <div id="input_block">Cerca:<input id="input_search" , type="text"></div>

        <!--
        <div class="block">
            <h1 class="name">Nome</h1>
            <span class="address">Indirizzo</span>
        </div>
     -->

        <div id="modal" , class="hidden">

            <div id="modal_block">

                <strong id="modal_title">
                    <!-- Title -->
                </strong>

                <div id="modal_content_login" , class="hidden">
                    <form id="form_login">
                        <div id="block_login_username" , class="fields">
                            <label>Username:<input id="login_username" , type="text"></label>
                            <span class="error"></span>
                        </div>
                        <div id="block_login_password" , class="fields">
                            <label>Password:<input id="login_password" , type="password"></label>
                            <span class="error"></span>
                        </div>
                    </form>
                </div>

                <div id="modal_content_register" , class="hidden">
                    <form id="form_register">
                        <div id="block_register_username" , class="fields">
                            <em>(Sono ammesse lettere e numeri - Massimo 15 caratteri)</em>
                            <label>Username:<input id="register_username" , type="text"></label>
                            <span class="error"></span>
                        </div>
                        <div id="block_register_password" , class="fields">
                            <em>
                                (Lunghezza minima 8 caratteri e massima 15 caratteri)<br>
                                (Presenza di almeno un carattere maiuscolo e minuscolo)<br>
                                (Presenza di almeno un numero)<br>
                                (Presenza di almeno un simbolo)
                            </em>
                            <label>Password:<input id="register_password" , type="password"></label>
                            <span class="error"></span>
                        </div>
                        <div id="block_register_email" , class="fields">
                            <em>(Esempio: nomefornitore@example.com)</em>
                            <label>E-mail:<input id="register_email" , type="text"></label>
                            <span class="error"></span>
                        </div>
                        <div>
                            <div><em>(Facoltativo) Nota: Se vuoto non verrà mostrato in elenco</em></div>
                            <label>Nome del Fornitore:<input id="register_name" , type="text"></label>
                        </div>
                        <div>
                            <div><em>(Facoltativo)</em></div>
                            <label>Indirizzo del Fornitore:<input id="register_address" , type="text"></label>
                        </div>
                    </form>
                </div>

                <?php
                if ($username != null && $existUserFor) {
                    $conn = mysqli_connect("localhost", "root", null, "progetto_ristoranti") or die("(Error during connection with database)");
                    $query = "SELECT * FROM fornitore WHERE username = '$username';";
                    $row = mysqli_fetch_object(mysqli_query($conn, $query));
                    mysqli_close($conn);
                }
                ?>

                <div id="modal_content_profile" , class="hidden">
                    <form id="form_profile" , class="fields">
                        <label>Nome del Fornitore:<input id="profile_name" , type="text" , value=<?php echo $row->nome ?>></label>
                        <label>Indirizzo del Fornitore:<input id="profile_address" , type="text" , value=<?php echo $row->indirizzo ?>></label>
                    </form>
                </div>

                <div id="buttons">
                    <div id="modal_error" , class="error hidden">Errore verifica i campi</div>
                    <input id="modal_button" , type="button">
                    <?php
                    if ($existUserFor) {
                        echo "<input id='delete_profile', type='button', value='Elimina profilo'>
                                <span></span>";
                    }
                    ?>
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