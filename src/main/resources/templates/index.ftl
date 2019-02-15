<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="UTF-8"/>
    <title>聚合支付</title>
    <script type="text/javascript" src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script type="text/javascript" src="/js/jquery.qrcode.min.js"></script>
</head>
<body>
<h1>Hello Spring Boot!!!</h1>
<p th:text="${greeting}"></p>
<p th:text="${sayHi}"></p>
<div class="code-img"></div>
<div class="pay-tag">
    <p>使用微信或支付宝扫码支付</p>
    <p class="code-bottom-text">无法扫描？<a class="web-alipay" href="javascript:;" style="cursor:pointer;color:blue">打开支付宝网页支付</a>
    </p>
</div>
<script>

    function createQrCode(cnt) {
        var obj = $('.code-img');
        obj.html('');
        obj.qrcode({
            render: "table", width: 200, height: 200, text: cnt,
            typeNumber: -1,
            correctLevel: 0,
            background: "#ffffff",
            foreground: "#000000"
        });
    }

    var prefix = "http://192.168.1.19:8086/aggregatePay/";
    $.post(prefix + "pay/gen", function (data, status) {
        console.log("orderId: " + data.oid + ",nStatus: " + status);
        $("#ip-oid").val(data.oid);
        //二维码内容越少 识别率越高
        var url = prefix + "pay?oid=" + data.oid;
        createQrCode(url);
    });

    $(function () {
        //网页支付宝
        $(".web-alipay").click(function () {
            var oid = $("#ip-oid").val();
            if (oid) {
                $.post("/pay/web", {oid: oid}, function (data, status) {
                    if (status == "success") {
                        //data = eval("("+data+")");
                        var form = data.form;
                        if (form == undefined) return;
                        $("html").append(form);
                    } else {
                        alert("打开网页支付宝支付异常，待会再试...");
                    }
                });
            } else {
                alert("订单号不存在，待会再试...");
            }
        });
    })
</script>
</body>
</html>