/*
v2018/12/13
gaoyiping (iam@gaoyiping.com)
https://gitee.com/Naff

端口号:
	AdelA90   :14901

参数标准:
	Adel:
		A90 (time format: YYYYMMDDhhmm, e.g.: 201803220905)
		9200T (time format: YYYYMMDDhhmm, e.g.: 201803220905)

*/
$(function() {
	"use strict";
	window.RoomCard = {
		options: {
			host: "localhost"
		},

		write: function(types,port, doorid, begintime, endtime) {
			if (types == "") {
				console.error("门锁类型为空");
				alert("门锁类型为空");
			} 
			if (port == ""){
				console.error("门锁端口为空");
				alert("门锁端口为空");
			}
			var domScript = document.createElement("script");
			domScript.src = "http://" + this.options.host + ":"+ port +"?Method=write&DoorID=" + doorid + "&BeginTime=" + begintime + "&EndTime=" + endtime + "&jsonpcallback=RoomCard.writeResponse";
			document.body.appendChild(domScript);
		},

		writeResponse: function(r) {
			writeCardRes(r);
		},
		
		copy: function(types,port, doorid, begintime, endtime) {
			if (types == "") {
				console.error("门锁类型为空");
				alert("门锁类型为空");
			} 
			if (port == ""){
				console.error("门锁端口为空");
				alert("门锁端口为空");
			}
			var domScript = document.createElement("script");
			domScript.src = "http://" + this.options.host + ":"+ port +"?Method=copy&DoorID=" + doorid + "&BeginTime=" + begintime + "&EndTime=" + endtime + "&jsonpcallback=RoomCard.copyResponse";
			document.body.appendChild(domScript);
		},

		copyResponse: function(r) {
			copyCardRes(r);
		},

		read: function(types,port) {
			if (types == "") {
				console.error("门锁类型为空");
				alert("门锁类型为空");
			} 
			if (port == ""){
				console.error("门锁端口为空");
				alert("门锁端口为空");
			}
			var domScript = document.createElement("script");
			domScript.src = "http://" + this.options.host + ":"+ port +"?Method=read&jsonpcallback=RoomCard.readResponse";
			document.body.appendChild(domScript);
		},
		
		readResponse: function(r) {
			readCardRes(r);
		},

		clean: function(types,port) {
			if (types == "") {
				console.error("门锁类型为空");
				alert("门锁类型为空");
			} 
			if (port == ""){
				console.error("门锁端口为空");
				alert("门锁端口为空");
			}
			var domScript = document.createElement("script");
			domScript.src = "http://" + this.options.host + ":"+ port +"?Method=clean&jsonpcallback=RoomCard.cleanResponse";
			document.body.appendChild(domScript);
		},

		cleanResponse: function(r) {
			cleanCardRes(r);
		}
	}
});