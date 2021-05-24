/* Foodish */
/* https://foodish-api.herokuapp.com/images/somefoodish/ */

/* Spoonacular */
/* https://spoonacular.com/food-api/ */
//type = "products", "informations"


/* Main Code */
const MAX_LATERAL_BLOCK = 5;
let NUM_IMAGE = 0;
const data = ["pasta", "ice", "flour", "sugar", "oil", "salt", "orange"];
const word = data[Math.round(Math.random() * (data.length - 1))];
let priceProduct;

const section = document.querySelector("section");
const form = document.querySelector("form");
createLateralBlocks();
form.addEventListener("submit", searchBlock);
document.querySelector("#modal").addEventListener("click", closeModal);
document.querySelector("#modal_block").addEventListener("click", doNothing);
document.querySelector("#modal_block_preference").addEventListener("click", doNothing);
document.querySelector("#input_images").addEventListener("click", newImages);
const lateralImageList = document.querySelectorAll(".lateral_image");
newImages();
searchOnWeb1("products", word);
if (document.querySelector("#logout")) {
    document.querySelector("#logout").addEventListener("click", logout);
}
if (document.querySelector("#preference")) {
    document.querySelector("#preference").addEventListener("click", openModal);
}
if (document.querySelector("#modal_preference")) {
    document.querySelector("#modal_preference").addEventListener("click", addPreference);
}


/* Start Function Declarations */

/* API Functions */

function searchOnWeb1(type, str) {
    fetch("api1.php/search?type=" + type + "&query=" + str).then(onResponse, onError).then(onJson1);
}
function searchOnWeb2() {
    fetch("api2.php").then(onResponse, onError).then(onJson2);
}
function onResponse(response) {
    return response.json();
}
function onError(error) {
    console.log("Errore: " + error);
}
function onJson1(json) {
    document.querySelector("#all_blocks").innerHTML = "";
    createBlocks(json);
}
function onJson2(json) {
    lateralImageList[NUM_IMAGE++].src = json.image;
    /* Soluzione all'errore */
    /* if (NUM_IMAGE == MAX_LATERAL_BLOCK * 2) {
        NUM_IMAGE = 0;
    } */
}

/* Generic Functions */

function searchBlock(event) {
    event.preventDefault();
    const str = event.currentTarget.querySelector("#input_content").value.toLowerCase();
    searchOnWeb1("products", str);
}

function openModal(event) {
    if (event.currentTarget.id != "preference") {
        const id = event.currentTarget.parentNode.dataset.id;
        fetch("api1.php/search?type=informations&id=" + id).then(onResponse, onError).then(onJsonModal);
    } else {
        document.querySelector("#modal").classList.remove("hidden");
        document.querySelector("#modal").classList.add("flex");
        document.body.classList.add("no_scroll");
        document.querySelector("#modal_block_preference").classList.remove("hidden");
        document.querySelector("#modal_block_preference").classList.add("flex");
        document.querySelector("#modal_block").classList.remove("flex");
        document.querySelector("#modal_block").classList.add("hidden");
        showPreference();
    }
}

function onJsonModal(json) {
    document.querySelector("#modal_image").src = json.image;
    document.querySelector("#modal_name").textContent = json.name[0].toUpperCase() + json.name.substring(1).toLowerCase();
    document.querySelector("#modal_text").innerHTML = jsonDescription(json);
    document.querySelector("#modal").classList.remove("hidden");
    document.querySelector("#modal").classList.add("flex");
    document.body.classList.add("no_scroll");
    document.querySelector("#modal_block_preference").classList.remove("flex");
    document.querySelector("#modal_block_preference").classList.add("hidden");
    document.querySelector("#modal_block").classList.remove("hidden");
    document.querySelector("#modal_block").classList.add("flex");
}

function jsonDescription(json) {
    const jsonData = json.nutrition.nutrients;
    let str;
    priceProduct = json.estimatedCost.value;

    str = "COST: " + json.estimatedCost.value + " " + json.estimatedCost.unit + "<br>NUTRIENTS:<br>";
    for (const obj of jsonData) {
        str += " - " + obj.name.toUpperCase() + ": " + obj.amount + " " + obj.unit + ";<br>";
    }
    return str;
}

function closeModal() {
    document.body.classList.remove("no_scroll");
    document.querySelector("#modal").classList.remove("flex");
    document.querySelector("#modal").classList.add("hidden");
    document.querySelector("#modal_content span").textContent = "";
}

function doNothing(event) {
    event.stopPropagation();
}

function newImages() {
    NUM_IMAGE = 0; //Forse è meglio dentro la funzione
    for (let i = 0; i < MAX_LATERAL_BLOCK * 2; i++) {
        searchOnWeb2();
    }
}

function logout(event) {
    const form = new FormData();
    form.append("type", "logout");
    fetch("accesso.php", { method: "post", body: form }).then(onResponse, onError).then(onAccess);
}

function addPreference(event) {
    const form = new FormData();
    form.append("type", "addPreference");
    form.append("name", document.querySelector("#modal_name").textContent);
    form.append("price", priceProduct);
    fetch("accesso.php", { method: "post", body: form }).then(onResponse, onError).then(onAccess);
    document.querySelector("#modal_content span").textContent = "(Aggiunto ai Preferiti)";
}

function showPreference() {
    const form = new FormData();
    form.append("type", "showPreference");
    fetch("accesso.php", { method: "post", body: form }).then(onResponse, onError).then(onJsonShowPreference);
}

function removePreference(event) {
    const form = new FormData();
    form.append("type", "removePreference");
    form.append("name", event.currentTarget.parentNode.querySelector(".product_info h1").textContent);
    fetch("accesso.php", { method: "post", body: form }).then(onResponse, onError).then(onAccess);
}

function onAccess(json) {

    switch (json) {
        case "removePreference":
            showPreference();
            break;
        case "addPreference":
            break;
        case "logout":
            window.location.reload();
            break;
        default:
            console.log("Error: " + json);
            break;

    }
}

function onJsonShowPreference(json) {

    document.querySelector("#products").innerHTML = "";
    let product, product_info, h1, span, input;
    for (const obj of json) {
        product = document.createElement("div");
        product.classList.add("product");
        document.querySelector("#products").appendChild(product);

        product_info = document.createElement("div");
        product_info.classList.add("product_info");
        input = document.createElement("input");
        input.classList.add("product_button");
        input.type = "button";
        input.value = "Rimuovi";
        input.addEventListener("click", removePreference);
        product.appendChild(product_info);
        product.appendChild(input);

        h1 = document.createElement("h1");
        h1.textContent = obj.name;
        span = document.createElement("span");
        span.textContent = "Cost: " + obj.cost + " US Cents";
        product_info.appendChild(h1);
        product_info.appendChild(span);
    }
}

/* Main Function */

function createBlocks(json) {

    /* Il JSON contiene un array di elementi con il proprio 'id', 'name', 'image' */

    const all_blocks = document.querySelector("#all_blocks");

    if (json.length == 0) {
        const noElement = document.createElement("h1");
        noElement.id = "noElement";
        if (document.querySelector("#input_content").value == "") {
            noElement.textContent = "Ricerca non valida !";
        } else
            noElement.textContent = "Nessun Prodotto Disponibile !";
        all_blocks.appendChild(noElement);
        return;
    }

    /* Creation all main blocks */
    let block, name, img, imageURL;

    for (let i = 0; i < json.length; i++) {

        /* Creation Block */
        block = document.createElement("div");
        block.classList.add("block");
        block.dataset.id = json[i].id;
        all_blocks.appendChild(block);

        /* Creation Name */
        name = document.createElement("h1");
        name.classList.add("name");
        name.textContent = json[i].name[0].toUpperCase() + json[i].name.substring(1).toLowerCase();
        block.appendChild(name);

        /* Creation Image */
        imageURL = json[i].image;
        img = document.createElement("img");
        img.classList.add("image");
        img.src = imageURL;
        block.appendChild(img);
    }

    const imageList = document.querySelectorAll(".image");
    for (const image of imageList) {
        image.addEventListener("click", openModal);
    }
}

function createLateralBlocks() {
    const lateral_blockList = document.querySelectorAll(".lateral_block");
    let image;

    for (const lateral_block of lateral_blockList) {
        for (let i = 0; i < MAX_LATERAL_BLOCK; i++) {
            image = document.createElement("img");
            image.classList.add("lateral_image");
            lateral_block.appendChild(image);
        }
    }
}