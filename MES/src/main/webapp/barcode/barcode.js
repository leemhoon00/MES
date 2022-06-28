function uploadCanvasData(imageId) {
    var canvas = $(imageId).get(0);
    var dataUrl = canvas.toDataURL();
    var blob = dataURItoBlob(dataUrl);

    return blob
}

function dataURItoBlob(dataURI) {
    var byteString = atob(dataURI.split(',')[1]);
    var mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0]
    var ab = new ArrayBuffer(byteString.length);
    var ia = new Uint8Array(ab);
    for (var i = 0; i < byteString.length; i++) {
        ia[i] = byteString.charCodeAt(i);
    }

    var bb = new Blob([ab], { "type": mimeString });
    return bb;
}

function printCanvas(elementById) {
    var form = new FormData();
    const fileInput = document.querySelector(elementById)
    const blob = uploadCanvasData(elementById)
    console.log(blob)
    form.append("image", blob, "image")

    var settings = {
        "url": "http://127.0.0.1:5000/Printer",
        // "dataType": "jsonp",
        "method": "POST",
        "timeout": 0,
        "processData": false,
        "contentType": false,
        "mimeType": "multipart/form-data",
        "data": form,
    };

    $.ajax(settings);
}

function sendToImage(elementById, barcodeData) {
    const ratio = 3
    d = document.createElement("div")
    d.id = "capture_create_div_id"
    $(elementById).append(d)

    $("#capture_create_div_id").barcode(barcodeData, "ean13", {
        barWidth: ratio,
        barHeight: ratio * 50,
        fontSize: ratio * 10
    })
    html2canvas(document.querySelector("#capture_create_div_id")).then(canvas => {
        canvas.id = "capture_canvas_id"
        $(elementById).append(canvas)
        printCanvas("#capture_canvas_id")
        canvas.remove()
        d.remove()
    });
}