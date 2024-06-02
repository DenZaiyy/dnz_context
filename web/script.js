window.addEventListener("message", (e) => {
    let data = e.data;

    if (data.type === "itemName") {
        copyText(data.name);
    }

    if (data.type === "itemHash") {
        copyText(data.hash);
    }

    if (data.type === "playerId") {
        copyText(data.playerID);
    }

    if (data.type === "itemPosition") {
        let str = `{ ${data.x}, ${data.y}, ${data.z}, ${data.heading} }`;
        copyText(str);
    }
});

function copyText(text) {
    let input = document.createElement("input");
    input.setAttribute("id", "copy-input");
    input.setAttribute("type", "text");
    input.value = text;
    document.body.appendChild(input);
    $("#copy-input").focus();
    $("#copy-input").select();
    document.execCommand("copy");
    document.body.removeChild(input);
}
