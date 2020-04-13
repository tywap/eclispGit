<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>结账</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		var eventName = '${param.eventName}';
		$(document).ready(function() {
			//提交
			$("#submitBtn").bind("click",function(){
				submitBtn();
			});
			//关闭
			$("#closeBtn").click(function(){
				window.parent.jBox.close();
			});
		});
		
		//提交
		function submitBtn(){
			var isUnion = '${param.isUnion}';			
			var orderId = '${param.orderId}';
			var params = {isUnion:isUnion,orderId:orderId};
			loadAjax("${ctx}/order/checkOut/checkOutPXCommit",params,function(result){
				if(result.retCode=="000000"){
					layer.confirm('PX成功', {
						btn: ['确定'] 
					}, function(){
						top.$.publish(eventName,{testData:"hello"});
						top.$.publish("index",{roomList:"${param.tableId}"});
				    	window.parent.jBox.close();
					}, function(){
					});
	    	    }else{
	    			layer.alert(result.retMsg);
	    	    }
			});
		}
	</script>
</head>
<body>
	<form:form id="inputForm" action=" " method="post" class="form-horizontal">
		<div class="row" style="margin:0 10px 10px 10px;">
			<label>房号：</label>
			<span>${param.tableNo}</span>
		</div>
		<!-- 账单界面 -->
		<jsp:include page="../common/common_account.jsp"></jsp:include>
		<hr>
		<div class="row" style="margin-left:10px;">
			<div class="row">
				<font color="#E04445">PX后可以在【账务中心】-【PX管理】中进行结账</font>
			</div>
		</div>
		<div class="fixed-btn-right">
			<!-- <input id="closeBtn" class="btn btn-primary" type="button" value="取消"/>&nbsp; -->
			<input id="submitBtn" class="btn btn-primary" type="button" value="确认PX"/>
		</div>
	</form:form>
</body>
</html>
