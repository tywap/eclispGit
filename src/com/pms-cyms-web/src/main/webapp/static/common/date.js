// 对Date的扩展，将 Date 转化为指定格式的String
// 月(M)、日(d)、小时(h)、分(m)、秒(s)、季度(q) 可以用 1-2 个占位符， 
// 年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字) 
// 例子： 
// (new Date()).Format("yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423 
// (new Date()).Format("yyyy-M-d h:m:s.S")      ==> 2006-7-2 8:9:4.18 
Date.prototype.Format = function (fmt) { //author: meizz 
    var o = {
        "M+": this.getMonth() + 1, //月份 
        "d+": this.getDate(), //日 
        "h+": this.getHours(), //小时 
        "m+": this.getMinutes(), //分 
        "s+": this.getSeconds(), //秒 
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
        "S": this.getMilliseconds() //毫秒 
    };
    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
    if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}
//判断时间日期 
function DateVerify(){
	var startDate = $('#startDate').val();
	var endDate = $('#endDate').val();
	var mydate = new Date();
	var currentDate = mydate.getFullYear()+ "-"+(mydate.getMonth()+1)+"-"+mydate.getDate();
	//console.debug(startDate, endDate, currentDate);
	if (startDate == "") {
		return $.jBox.alert('请输入开始时间！');
	}
	if (endDate == "") {
		return $.jBox.alert('请输入结束时间！');	
	}	
	var startJoint = startDate.replace(/-/g,'/');
	var endJoint = endDate.replace(/-/g,'/');
	var currentDateJoint = currentDate.replace(/-/g,'/');
	var changeStart =  new Date(startJoint);
	var changeEnd = new Date(endJoint);
	var changeCurrentDate = new Date(currentDateJoint);
	var startTime = changeStart.getTime();
	var endTime = changeEnd.getTime();
	var countTime = endTime-startTime;
	var oDate = new Date(countTime);
	var oMonth = oDate.getMonth()+1;
	var oDay = oDate.getDate();
	oTime = oDay+'-'+oMonth+'-'+oDate;
	//console.log(oDate,oMonth+'月',oDay+'天',oTime);
	var CurrentDateTime = changeCurrentDate.getTime();
	//console.log(startTime,endTime,countTime,CurrentDateTime);
	console.log(oMonth);
	 if (startTime <= endTime) {
		 if(oMonth > 1){
			return $.jBox.alert('开始时间和结束时间不能超过31天!');
		}else{
			return true;
		}	
	}else{
		return $.jBox.alert("开始时间必须小于或者等于结束时间！");
	}	
}
//判断时间日期