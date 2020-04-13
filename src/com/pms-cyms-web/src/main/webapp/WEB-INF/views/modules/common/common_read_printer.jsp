<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<script src="${ctxStatic}/room/printer.js?V=5" type="text/javascript"></script>
<script type="text/javascript">
	$(document).ready(function (){
		
	});
	//传菜
	function readPrinter(ipPort,map,type){
		Printer.read(ipPort,JSON.stringify(map),type);
	}
	
	//读取回调
	function readIdCardRes(r){ 
		console.info(r);
		if(r.State=="0"){
			readIdCardResSuccess(r);
		}else if(r.State=="100"){
			layer.confirm(r.Message, {btn: ['确定'] }, function(index){layer.close(index);}, function(){return;});
		}else{
			layer.confirm(r.Message, {btn: ['确定'] }, function(index){layer.close(index);}, function(){return;});
		}
	}
</script>