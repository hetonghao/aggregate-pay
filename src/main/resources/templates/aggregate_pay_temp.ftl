<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="UTF-8">
    <title>收银台</title>
    <script type="text/javascript" src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
</head>
<body>
<#--微信支付调用参数-->
<input type="hidden" id="ip-appId" value="${appId!""}"/>
<input type="hidden" id="ip-timeStamp" value="${timeStamp!""}"/>
<input type="hidden" id="ip-nonceStr" value="${nonceStr!""}"/>
<input type="hidden" id="ip-package" value="${prepay_id!""}"/>
<input type="hidden" id="ip-paySign" value="${paySign!""}"/>
<#--支付宝是返回表单，所以直接展示到页面上-->
${form!""}

<script>
    $(function () {
        var ua = navigator.userAgent.toLowerCase();
        if (ua.indexOf('micromessenger') != -1) {
            var appId = $("#ip-appId").val();
            var timeStamp = $("#ip-timeStamp").val();
            var nonceStr = $("#ip-nonceStr").val();
            var package = $("#ip-package").val();
            var paySign = $("#ip-paySign").val();
            // alert("appId:"+appId+"timeStamp:"+timeStamp+"nonceStr:"+nonceStr+"package:"+package+"paySign:"+paySign);
            window.wechatPayData = {
                "appId": appId,
                "timeStamp": timeStamp,
                "nonceStr": nonceStr,
                "package": "prepay_id=" + package,
                "signType": "MD5",
                "paySign": paySign
            };
            wechatJSAPI();
        } else if (ua.indexOf('alipayclient') != -1) {
            var form = $("#ip-form").val();
            $("html").append(form);
        }
    })

    function onBridgeReady() {
        WeixinJSBridge.invoke(
                'getBrandWCPayRequest', {
                    "appId": window.wechatPayData.appId,     //公众号名称，由商户传入
                    "timeStamp": window.wechatPayData.timeStamp,         //时间戳，自1970年以来的秒数
                    "nonceStr": window.wechatPayData.nonceStr, //随机串
                    "package": window.wechatPayData['package'],
                    "signType": window.wechatPayData.signType,         //微信签名方式：
                    "paySign": window.wechatPayData.paySign //微信签名
                },
                function (res) {
                    if (res.err_msg == "get_brand_wcpay_request:ok") {
                        alert('支付成功！');
                    } else {
                        alert('支付失败！');
                    }
                });
    }

    function wechatJSAPI() {

        if (typeof WeixinJSBridge == "undefined") {
            if (document.addEventListener) {
                document.addEventListener('WeixinJSBridgeReady', onBridgeReady, false);
            } else if (document.attachEvent) {
                document.attachEvent('WeixinJSBridgeReady', onBridgeReady);
                document.attachEvent('onWeixinJSBridgeReady', onBridgeReady);
            }
        } else {
            onBridgeReady();
        }
    }

</script>
</body>
</html>