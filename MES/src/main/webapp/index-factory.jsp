<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="utf-8">
        <title>MES</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
        <script type="text/javascript" src="barcode-reader-1.0.0.total.js"></script>
        <script type="text/javascript">
            barcodeReaderCallback = function(data) {
                var code = data.substr(0, 2);
                // 55 : 명령어 
                if (data.length != 13) {
                    return;
                }

                // 맨 마지막은 Checksum 이므로 지움.
                // 맨 앞은 명령어 세트 이므로 지움.
                data = data.substr(2, data.length - 3);
                var uniqueId = parseInt(data);

                console.log(code);
                console.log(uniqueId);

                // 명령어
                if (code == "55") {
                    if (uniqueId == 1) {
                        document.location.href = "./barcode/input-barcode.jsp"
                    } // 종료 시간 입력 코드 작성
                    else if (uniqueId == 2) {
                        document.location.href = "./barcode/close-barcode.jsp"
                    }
                }
            }
        </script>
        <link href="index.css?ver05" rel="stylesheet">
        <!-- "http://ict.asuscomm.com:8080/MES/dailyWork/dailyWorksearch.jsp?page=1&wk=&date=22/05/03 - 22/05/03" -->
        <!-- http://ict.asuscomm.com:8080/MES/my_work/my_work.jsp -->
        <!-- ordername : 수주명 -->
        <%
     HttpSession sessions = request.getSession(false);
     if(sessions != null){
          sessions.invalidate();
     }
     %>

    </head>

    <body class="text-center">
        <form class="form-signin" action="mainpage.jsp" method="post">
            <div class="inputformdiv">
                <div class="form-floating">
                    <input type="text" class="form-control" name="id" placeholder="ID" disabled="disable">
                    <label for="floatingInput">ID</label>
                </div>
                <div class="form-floating">
                    <input type="password" class="form-control" name="pw" placeholder="Password" disabled="disable">
                    <label for="floatingPassword">Password</label>
                </div>
                <button class="btn btn-lg btn-primary" type="submit" disabled="disable">로그인</button>
            </div>
            <div style="display: flex; justify-content: center;">
                <img src="./barcode/resources/55_1_new_work.png" style="margin: 10px;"/>
                <img src="./barcode/resources/55_2_list_work.png" style="margin: 10px;"/>
            </div>
        </form>

    </body>

    </html>