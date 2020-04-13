<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>结账</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		var eventName = '${param.eventName}';
		var pageName="checkOut";
		var hasCreditFlag = false;
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
			var type = '${param.type}';
			var storeId = '${param.storeId}';
			var isUnion = '${param.isUnion}';
			var orderId = '${param.orderId}';//房单
			//支付明细
			var obj = getPaymentFunds();
			var paymentFunds = obj.paymentFunds;
			var payTotalAmount = obj.payTotalAmount;
			var totalAmount = parseFloat($("#balanceAmountTotal").html());
			if(payTotalAmount!=totalAmount){
				layer.alert("支付金额和应收金额不一致！");
				return;
			}
			var params = {
				storeId:storeId,	
				isUnion:isUnion,
				orderId:orderId,
				paymentFundJson:JSON.stringify(paymentFunds)
			};
			loadAjax("${ctx}/order/checkOut/checkOutCommit",params,function(result){
				if(result.retCode=="000000"){
					layer.confirm('结账成功！是否打印结账单？', {
						btn: ['确定','取消'],
						cancel: function(index, layero){
							top.$.publish("ordIndex",{testData:"close"});
					    	top.$.publish("index",{roomList:"${param.tableId}"});
					    	window.parent.jBox.close();
					}
					}, function(){
					/* 	alert("a");
						top.$.publish("ordIndex",{testData:"hello"});
						top.$.publish("index",{roomList:"${param.tableId}"}); */
						window.open("${ctx}/print/printCheckOut?ordId=${param.orderId}");
						window.parent.jBox.close();
					}, function(){
						top.$.publish("ordIndex",{testData:"close"});
						top.$.publish("index",{roomList:"${param.tableId}"});
						window.parent.jBox.close();
					});
	    	    }else{
	    	    	layer.confirm(result.retMsg, {
					  btn: ['确定'] 
					}, function(index){
						top.$.publish(eventName,{testData:"hello"});
				    	window.location.reload();
					}, function(){
					});
	    	    }
			});
		}
	</script>
</head>
<body>
	<form:form id="inputForm" action=" " method="post" class="form-horizontal" onsubmit="return false">
		<div class="row" style="margin:0 10px 10px 10px;">
            <label style="vertical-align: top;">房号：</label>
            <span>${param.tableNo}</span>
		</div>
		<!-- 账单界面 -->
		<jsp:include page="../common/common_account.jsp"></jsp:include>
		<hr>
		<jsp:include page="../common/common_pay.jsp"></jsp:include>
		<jsp:include page="../common/common_pay_item.jsp"></jsp:include>
		<div class="fixed-btn-right">
			<input id="submitBtn" class="btn btn-primary" type="button" value="确认结账"/>
		</div>
	</form:form>
</body>
</html>
