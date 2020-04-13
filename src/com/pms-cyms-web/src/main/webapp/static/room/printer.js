/*
v2018/12/13
gaoyiping (iam@gaoyiping.com)
https://gitee.com/Naff

端口号:
	CVR100U   :14862

参数标准:
	
*/
$(function() {
	"use strict";
	window.Printer = {
		options: {
			host: "localhost"
		}, 
		read: function(ipPort,map,type) {
			/*if (types == "") {
				console.error("身份证读卡器类型为空");
				alert("身份证读卡器类型为空");
			} */
			if (map == ""){
				console.error("打印机端口为空");
				alert("打印机端口为空");
			}
			var domScript = document.createElement("script");
			domScript.src = encodeURI("http://" + ipPort +"?Method=read&printParams="+map+"&type="+type+"&jsonpcallback=Printer.readResponse");
			document.body.appendChild(domScript);
		},
		
		
		readResponse:function(r) {
			readIdCardRes(r);
		}
	}
});