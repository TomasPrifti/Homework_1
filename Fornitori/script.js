fetch("addFornitori.php").then(onResponse, onError).then(onJson);
let myJson;
const section = document.querySelector("section");
if (document.querySelector("#input_login")) {
    document.querySelector("#input_login").addEventListener("click", openModal);
}
if (document.querySelector("#profile")) {
    document.querySelector("#profile").addEventListener("click", openModal);
}
if (document.querySelector("#input_register")) {
    document.querySelector("#input_register").addEventListener("click", openModal);
}
if (document.querySelector("#logout")) {
    document.querySelector("#logout").addEventListener("click", logout);
}
if (document.querySelector("#logout_res")) {
    document.querySelector("#logout_res").addEventListener("click", logout);
}
if (document.querySelector("#delete_profile")) {
    document.querySelector("#delete_profile").addEventListener("click", checkDeleteProfile);
}
document.querySelector("#modal").addEventListener("click", closeModal);
document.querySelector("#modal_block").addEventListener("click", doNothing);
document.querySelector("#register_username").addEventListener("blur", checkRegisterUsername);
document.querySelector("#register_password").addEventListener("blur", checkRegisterPassword);
document.querySelector("#register_email").addEventListener("blur", checkRegisterEmail);
document.querySelector("#login_username").addEventListener("blur", checkLoginUsernamePassword);
document.querySelector("#login_password").addEventListener("blur", checkLoginUsernamePassword);
/* Finisce la fetch, viene richiamata la funzione continueExe() che continuerÃ  con la creazione della pagina */


/* Start Function Declarations */

function continueExe() {
    createBlocks();
}

function searchBlock(event) {
    const str = event.currentTarget.value.toLowerCase();
    const blockList = document.querySelectorAll(".block");
    for (const block of blockList) {
        const title = block.querySelector(".name").textContent.toLowerCase();

        if (str != "") {
            block.classList.add("hidden");
        } else {
            block.classList.remove("hidden");
        }
        let j = 0, i = 0;
        for (i = 0; i < str.length; i++) {
            if (str[i] == title[i]) {
                j++;
            }
        }
        if (i == j) {
            block.classList.remove("hidden");
        }

    }
}

function openModal(event) {
    document.querySelector("#modal").classList.remove("hidden");
    document.querySelector("#modal").classList.add("flex");
    document.body.classList.add("no_scroll");
    document.querySelector("#modal_error").classList.add("hidden");

    const modal_title = document.querySelector("#modal_title");
    const modal_button = document.querySelector("#modal_button");

    if (event.currentTarget.id == "input_login") {
        for (const err of document.querySelectorAll("#modal_content_login .error")) {
            err.textContent = "";
        }
        document.querySelector("#modal_content_login").classList.remove("hidden");
        document.querySelector("#modal_content_login").classList.add("flex");
        modal_title.textContent = "Accesso";
        modal_button.value = "Accedi";
        modal_button.addEventListener("click", login);
    } else if (event.currentTarget.id == "input_register") {
        for (const err of document.querySelectorAll("#modal_content_register .error")) {
            err.textContent = "";
        }
        document.querySelector("#modal_content_register").classList.remove("hidden");
        document.querySelector("#modal_content_register").classList.add("flex");
        modal_title.textContent = "Registrazione";
        modal_button.value = "Registrati";
        modal_button.addEventListener("click", register);
    } else if (event.currentTarget.id == "profile") {
        document.querySelector("#modal_content_profile").classList.remove("hidden");
        document.querySelector("#modal_content_profile").classList.add("flex");
        modal_title.textContent = "Profilo";
        modal_button.value = "Aggiorna profilo";
        modal_button.addEventListener("click", update);
    }
}

function checkDeleteProfile(event) {
    document.querySelector("#buttons span").textContent = "(Clicca di nuovo per eliminare il tuo profilo)";
    document.querySelector("#delete_profile").removeEventListener("click", checkDeleteProfile);
    document.querySelector("#delete_profile").addEventListener("click", deleteProfile);
}

function deleteProfile(event) {
    const form = new FormData();
    form.append("type", "delete");
    fetch("accesso.php", { method: "post", body: form }).then(onResponse, onError).then(onAccess);
}

function logout(event) {
    const form = new FormData();
    form.append("type", "logout");
    fetch("accesso.php", { method: "post", body: form }).then(onResponse, onError).then(onAccess);
}

function update(event) {
    const form = formUpdate();
    if (form != null)
        fetch("accesso.php", { method: "post", body: form }).then(onResponse, onError).then(onAccess);
}

function login() {
    const form = formLogin();
    if (form != null)
        fetch("accesso.php", { method: "post", body: form }).then(onResponse, onError).then(onAccess);
}

function register() {
    const form = formRegister();
    if (form != null)
        fetch("accesso.php", { method: "post", body: form }).then(onResponse, onError).then(onAccess);
}

function onAccess(json) {

    switch (json) {
        case "error_login_username":
            /* Username non esiste */
            document.querySelector("#block_login_username .error").textContent = "Errore username non esiste";
            break;
        case "error_login_password":
            /* Password errata */
            document.querySelector("#block_login_password .error").textContent = "Errore password errata";
            document.querySelector("#login_password").value = "";
            break;
        case "error_register_username":
            /* Username non disponibile (GiÃ  in uso) */
            document.querySelector("#block_register_username .error").textContent = "Errore username non disponibile";
            break;
        case "login":
        case "register":
        case "logout":
        case "update":
        case "delete":
            window.location.reload();
            break;
        default:
            console.log("Error: " + json);
            break;

    }
}

function checkLoginUsernamePassword() {
    document.querySelector("#block_login_username .error").textContent = "";
    document.querySelector("#block_login_password .error").textContent = "";
}

function formLogin() {

    if (!checkLogin()) {
        return null;
    }
    const form = new FormData();
    const username = document.querySelector("#login_username").value;
    const password = document.querySelector("#login_password").value;

    form.append("type", "login");
    form.append("username", username);
    form.append("password", password);

    return form;
}

function checkLogin() {

    const login_username = document.querySelector("#login_username").value;
    const login_password = document.querySelector("#login_password").value;

    if (login_username == "" || login_password == "") {
        document.querySelector("#modal_error").classList.remove("hidden");
        return false;
    }

    const username_error = document.querySelector("#block_login_username .error").textContent;
    const password_error = document.querySelector("#block_login_password .error").textContent;

    if (username_error == "" && password_error == "") {
        return true;
    } else {
        document.querySelector("#modal_error").classList.remove("hidden");
        return false;
    }
}

function formRegister() {

    if (!checkRegister()) {
        return null;
    }
    const form = new FormData();
    const username = document.querySelector("#register_username").value;
    const password = document.querySelector("#register_password").value;
    const email = document.querySelector("#register_email").value;
    const name = document.querySelector("#register_name").value;
    const address = document.querySelector("#register_address").value;

    form.append("type", "register");
    form.append("username", username);
    form.append("password", password);
    form.append("email", email);
    form.append("name", name);
    form.append("address", address);

    return form;
}

function checkRegister() {

    const register_username = document.querySelector("#register_username").value;
    const register_password = document.querySelector("#register_password").value;
    const register_email = document.querySelector("#register_email").value;

    if (register_username == "" || register_password == "" || register_email == "") {
        document.querySelector("#modal_error").classList.remove("hidden");
        return false;
    }

    const username_error = document.querySelector("#block_register_username .error").textContent;
    const password_error = document.querySelector("#block_register_password .error").textContent;
    const email_error = document.querySelector("#block_register_email .error").textContent;

    if (username_error == "" && password_error == "" && email_error == "") {
        return true;
    } else {
        document.querySelector("#modal_error").classList.remove("hidden");
        return false;
    }

}

function formUpdate() {
    const form = new FormData();
    const name = document.querySelector("#profile_name").value;
    const address = document.querySelector("#profile_address").value;

    form.append("type", "update");
    form.append("name", name);
    form.append("address", address);

    return form;
}

function checkRegisterUsername(event) {
    if (!/^[a-zA-ZÃ -Ã¹0-9_]{1,15}$/.test(event.currentTarget.value)) {
        document.querySelector("#block_register_username .error").textContent = "Errore username non valido";
        if (event.currentTarget.value.length > 15) {
            const span = document.createElement("span");
            span.textContent = "(Troppi caratteri)";
            document.querySelector("#block_register_username .error").appendChild(span);
        }
    } else
        document.querySelector("#block_register_username .error").textContent = "";
}

function checkRegisterPassword(event) {
    let found = false;
    document.querySelector("#block_register_password .error").textContent = "";
    /* Check lunghezza */
    if (event.currentTarget.value.length > 15 || event.currentTarget.value.length < 8) {
        const span = document.createElement("span");
        span.textContent = "(Lunghezza non valida)";
        document.querySelector("#block_register_password .error").appendChild(span);
    }
    /* Check lettera maiuscola */
    found = false;
    for (const letter of ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]) {
        if (event.currentTarget.value.indexOf(letter) != -1) {
            found = true;
            break;
        }
    }
    if (found == false) {
        const span = document.createElement("span");
        span.textContent = "(Inserire almeno un carattere maiuscolo)";
        document.querySelector("#block_register_password .error").appendChild(span);
    }
    /* Check numero */
    found = false;
    for (const number of ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]) {
        if (event.currentTarget.value.indexOf(number) != -1) {
            found = true;
            break;
        }
    }
    if (found == false) {
        const span = document.createElement("span");
        span.textContent = "(Inserire almeno un numero)";
        document.querySelector("#block_register_password .error").appendChild(span);
    }
    /* Check simbolo */
    found = false;
    for (const symbol of ["!", "#", "$", "%", "&", "(", ")", "*", "+", ",", "-", "/", ":", ";", "<", "=", ">", "?", "@", "[", "]", "^", "Ã§", "Â£", "|", "_", "'", "Â§", "â¬"]) {
        if (event.currentTarget.value.indexOf(symbol) != -1) {
            found = true;
            break;
        }
    }
    if (found == false) {
        const span = document.createElement("span");
        span.textContent = "(Inserire almeno un simbolo)";
        document.querySelector("#block_register_password .error").appendChild(span);
    }
}

function checkRegisterEmail(event) {
    if (!/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(event.currentTarget.value)) {
        document.querySelector("#block_register_email .error").textContent = "Errore email non valida";
    } else
        document.querySelector("#block_register_email .error").textContent = "";
}

function closeModal() {
    document.body.classList.remove("no_scroll");
    document.querySelector("#modal").classList.remove("flex");
    document.querySelector("#modal").classList.add("hidden");
    if (document.querySelector("#modal_content_login").classList == "flex") {
        //document.querySelector("#modal_content_login").classList.remove("flex");
        document.querySelector("#modal_content_login").classList.add("hidden");
        document.querySelector("#modal_button").removeEventListener("click", login);
    }
    if (document.querySelector("#modal_content_register").classList == "flex") {
        //document.querySelector("#modal_content_register").classList.remove("flex");
        document.querySelector("#modal_content_register").classList.add("hidden");
        document.querySelector("#modal_button").removeEventListener("click", register);
    }
    if (document.querySelector("#modal_content_profile").classList == "flex") {
        //document.querySelector("#modal_content_profile").classList.remove("flex");
        document.querySelector("#modal_content_profile").classList.add("hidden");
        document.querySelector("#modal_button").removeEventListener("click", update);
        document.querySelector("#buttons span").textContent = "";
        document.querySelector("#delete_profile").removeEventListener("click", deleteProfile);
        document.querySelector("#delete_profile").addEventListener("click", checkDeleteProfile);
    }
}

function doNothing(event) {
    event.stopPropagation();
}

function onResponse(response) {
    return response.json();
}

function onError(error) {
    console.log("Error: " + error);
}

function onJson(json) {
    myJson = json;
    continueExe();
}

/* Main Function */

function createBlocks() {

    document.querySelector("#input_search").addEventListener("keyup", searchBlock);

    /* Creation all main blocks */
    let block, name, address;

    for (const obj of myJson) {

        /* Creation Block */
        block = document.createElement("div");
        block.classList.add("block");
        section.appendChild(block);

        /* Creation Name */
        name = document.createElement("h1");
        name.classList.add("name");
        name.textContent = obj.name;
        block.appendChild(name);

        /* Creation Address*/
        address = document.createElement("span");
        address.classList.add("address");
        address.textContent = "Indirizzo: " + obj.address;
        block.appendChild(address);
    }

}