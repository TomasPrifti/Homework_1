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

function loginProfileValue($existUserRes)
{
    if ($existUserRes) {
        return "Profilo";
    }
    return "Accedi";
}
function registerLogoutValue($existUserRes)
{
    if ($existUserRes) {
        return "Logout";
    }
    return "Registrati";
}
function loginProfileId($existUserRes)
{
    if ($existUserRes) {
        return "profile";
    }
    return "input_login";
}
function registerLogoutId($existUserRes)
{
    if ($existUserRes) {
        return "logout";
    }
    return "input_register";
}

?>

<html>

<head>
    <title>Ristoranti - Catena di Ristoranti</title>
    <link rel="stylesheet" href="../aspettoCondiviso.css">
    <link rel="stylesheet" href="../utenteCondiviso.css">
    <link rel="stylesheet" href="ristoranti.css" />
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
            <a href=""><strong>RISTORANTI</strong></a>
            <a href="../Fornitori/fornitori.php"><strong>FORNITORI</strong></a>
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
            <strong>RISTORANTI</strong>
            <div id="login">
                <span id="title_login">
                    <?php
                    if (!$existUserRes && !$existUserFor)
                        echo "Sei il proprietario di un Ristorante ?";
                    else
                        echo "Benvenuto $username !";
                    ?>
                </span>
                <div>
                    <?php
                    if (!$existUserFor) {
                        echo '<input id=' . loginProfileId($existUserRes) . ' , type="button" , value=' . loginProfileValue($existUserRes) . '>';
                        echo '<span>oppure</span>';
                        echo '<input id=' . registerLogoutId($existUserRes) . ' , type="button" , value=' . registerLogoutValue($existUserRes) . '>';
                    } else {
                        echo '<input id="logout_for", type="button", value="Logout">';
                    }
                    ?>
                </div>
            </div>
        </div>

    </header>

    <section>

        <!-- 
        <div id="preferences" class="pref">
            <h1 id="title_preferences">Ristoranti Preferiti</h1>
            <div id="choices">
                
                <div class="choice">
                    <div class="title_choice">
                        <h1>nome</h1>
                        <img>immagine</img>
                    </div>
                    <img class="image_choice">immagine</img>
                </div>

            </div>

        </div>

        <h1 id="title_blocks">Tutti i Ristoranti</h1>
        <div id="input_block">
            <span>Cerca:</span>
            <input type="text">
        </div>
        
        <div class="block">
            <div class="title">
                <h1 class="name">Titolo</h1>
                <img class="info"></img>
                <img class="preference">Img</img>
            </div>

            <div class="content">
                <div class="text">
                    <div>address</div>
                    <div>description</div>
                </div>
                <img></img>
            </div>
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
                            <em>(Esempio: nomeristorante@example.com)</em>
                            <label>E-mail:<input id="register_email" , type="text"></label>
                            <span class="error"></span>
                        </div>
                        <div>
                            <div><em>(Facoltativo) Nota: Se vuoto non verrà mostrato in elenco</em></div>
                            <label>Nome del Ristorante:<input id="register_name" , type="text"></label>
                        </div>
                        <div>
                            <div><em>(Facoltativo)</em></div>
                            <label>Indirizzo del Ristorante:<input id="register_address" , type="text"></label>
                        </div>
                    </form>
                </div>

                <?php
                if ($username != null && $existUserRes) {
                    $conn = mysqli_connect("localhost", "root", null, "progetto_ristoranti") or die("(Error during connection with database)");
                    $query = "SELECT * FROM ristorante WHERE username = '$username';";
                    $row = mysqli_fetch_object(mysqli_query($conn, $query));
                    mysqli_close($conn);
                }
                ?>

                <div id="modal_content_profile" , class="hidden">
                    <form id="form_profile" , class="fields">
                        <label>Nome del Ristorante:<input id="profile_name" , type="text" , value=<?php echo $row->nome ?>></label>
                        <label>Indirizzo del Ristorante:<input id="profile_address" , type="text" , value=<?php echo $row->indirizzo ?>></label>
                        <label id="description_label_profile">Descrizione del Ristorante:<textarea id="profile_description"><?php echo $row->descrizione ?></textarea></label>
                        <label>Immagine:<input id="profile_image" , type="file"></label>
                    </form>
                </div>

                <div id="buttons">
                    <div id="modal_error" , class="error hidden">Errore verifica i campi</div>
                    <input id="modal_button" , type="button">
                    <?php
                    if ($existUserRes) {
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