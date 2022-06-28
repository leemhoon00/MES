# javascript-barcode-image

웹에서 Javascript를 이용하여 바코드를 그리고, 바코드를 출력할 수 있도록 지원합니다.

추가 방법:
```html
<script type="text/javascript" src="https://raw.githubusercontent.com/Piorosen/javascript-barcode-image/main/barcode-1.0.0.total.js"></script>
```

사용 방법

```js
@Param [elementById] : Div의 Id 정보
@Param [barcodeData] : 추가할 데이터 ex) 1234567890
@Param [ratio] : 바코드의 크기
function drawBarcode(elementById, barcodeData, ratio = 3)


@Param [elementById] : Div의 Id 정보
@Param [url] : 이미지 데이터를 전송할 URL 주소
@Description : 
> "method": "POST" <br>
> "timeout": 0 <br>
> "mimeType": "multipart/form-data" <br>
> "data": form <br>

function elementPrint(elementById, url)
```
