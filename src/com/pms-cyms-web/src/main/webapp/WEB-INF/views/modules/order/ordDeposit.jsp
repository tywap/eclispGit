<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>押金管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		var eventName = '${param.eventName}';
		var pageName="deposit";
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
			var storeId = '${param.storeId}';
			var isUnion = '${param.isUnion}';
			var orderId = '${param.orderId}';//房单
			
			//支付明细
			var obj = getPaymentFunds();
			var paymentFunds = obj.paymentFunds;
			var payTotalAmount = obj.payTotalAmount;
			var totalAmount = parseFloat($("#depositAmount").val());
			if(payTotalAmount<0){
				if(Math.abs(payTotalAmount)>totalAmount){
					$.jBox.alert("押金不足！");
					return;
				}
				/**<shiro:lacksPermission name="order:room:addNegativeDeposit">
					layer.confirm("当前岗位不允许输入负数，请确认权限", {
					  btn: ['确定']
					}, function(index){
						layer.close(index);
					}, function(){
						return ;
					});
					return;
				</shiro:lacksPermission>**/
			}
			var params = {
				storeId:storeId,
				isUnion:isUnion,
				orderId:orderId,
				paymentFunds:JSON.stringify(paymentFunds)
			};
			loadAjax("${ctx}/order/ordDeposit/ordDepositCommit",params,function(result){
				if(result.retCode=="000000"){
					layer.confirm('押金调整成功！是否打印押金单？', {
						  btn: ['确定','取消'] 
					}, function(){
						window.open("${ctx}/print/printDeposit?"+result.retMsg);
						/* top.$.publish(eventName,{testData:"hello"});
				    	window.parent.jBox.close(); */
				    	layer.close(layer.index);
					}, function(){
						top.$.publish(eventName,{testData:"hello"});
				    	window.parent.jBox.close();
					});
	    	    }else{
	    	    	$.jBox.confirm(result.retMsg, "提示", function (v, h, f) {
					    if (v == true){
					    	top.$.publish(eventName,{testData:"hello"});
					    	window.location.reload();
					    }
					    return true;
					}, { buttons: { '确定': true}});
	    	    }
			});
		}
	</script>
</head>
<body>
	<form:form id="inputForm" action=" " method="post" class="form-horizontal" style="margin-bottom:50px;">
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
			<input id="submitBtn" class="btn btn-primary" type="button" value="确认"/>
		</div>
	</form:form>
</body>
</html>
