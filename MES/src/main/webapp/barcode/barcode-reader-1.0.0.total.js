// IE 판별 결정
ie = (document.all) ? 1 : 0;
document.onkeydown = keyDown
    // if (!ie) document.captureEvent(Event.KEYDOWN);

barcodeReaderCallback = function(text) {}

previousTimeDate = new Date().getTime()
bufferText = ""

function keyDown(e) {
    var keyCode = ''
    if (ie) {
        var ieKey = window.event.keyCode;
        var ieRealKey = String.fromCharCode(ieKey);
        keyCode = ieRealKey
            // alert("누른 키 : " + ieRealKey + "\n코드 값 : " + ieKey);
    } else {
        var nsKey = e.which;
        var nsRealKey = String.fromCharCode(nsKey);
        keyCode = nsRealKey
            // alert("누른 키 : " + nsRealKey + "\n코드 값 : " + nsKey);
    }

    var term = new Date().getTime() - previousTimeDate
    if (term < 200) {
        if (keyCode == '\r' || keyCode == '\n') {
            if (bufferText.length >= 8) {
                console.log("barcode : [" + bufferText + "] load : [" + term + " ms]")
                barcodeReaderCallback(bufferText)
            }
            bufferText = ""
            previousTimeDate = new Date().getTime()
        }
        bufferText += keyCode
    } else {
        bufferText = keyCode
        previousTimeDate = new Date().getTime()
    }
}