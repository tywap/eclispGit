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
	window.IdCard = {
		options: {
			host: "localhost"
		},
		read: function(types,port) {
			if (types == "") {
				console.error("身份证读卡器类型为空");
				alert("身份证读卡器类型为空");
			} 
			if (port == ""){
				console.error("身份证读卡器端口为空");
				alert("身份证读卡器端口为空");
			}
			var domScript = document.createElement("script");
			domScript.src = "http://" + this.options.host + ":"+ port +"?Method=read&jsonpcallback=IdCard.readResponse";
			document.body.appendChild(domScript);
		},
		
		readResponse:function(r) {
			readIdCardRes(r);
		}
	}
});