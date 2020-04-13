/*
v2018/12/13
gaoyiping (iam@gaoyiping.com)
https://gitee.com/Naff

端口号:
	EYEU100   :14876

参数标准:
	
*/
$(function() {
	"use strict";
	window.VIPCard = {
		options: {
			host: "localhost"
		},
		read: function(types,port) {
			var domScript = document.createElement("script");
			domScript.src = "http://" + this.options.host + ":"+ port +"?Method=read&jsonpcallback=VIPCard.readResponse";
			document.body.appendChild(domScript);
		},
		
		readResponse: function(r) {
			readVIPCardRes(r);
		},

		write: function(types,port,data) {
			var domScript = document.createElement("script");
			domScript.src = "http://" + this.options.host + ":"+ port +"?Method=write&Data="+ data +"&jsonpcallback=VIPCard.writeResponse";
			document.body.appendChild(domScript);
		},
		
		writeResponse: function(r) {
			writeVIPCardRes(r);
		}
	}
});