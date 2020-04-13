<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<style>
	.stat-boxes2 {
	display: inline-block;
	list-style: none outside none;
	margin:0px 10px;
	text-align: center;
	}

	.stat-boxes2 li {
		display: inline-block;
		line-height: 18px;
		background: #fff;
		margin-right: 3px;
		border: 1px solid #CCCCCC;
	}
	.stat-boxes2 li:last-child{
		margin-right: 0px;
	}
	
	.stat-boxes2 li:hover {
		background: #f6f6f6;
	}
	
	.stat-boxes2 .left,
	.stat-boxes2 .right {
		text-shadow: 0 1px 0 #fff;
		float: left;
		padding: 5px;
		
		color: #666;
	}
	
	.stat-boxes2 .left {
		border-right: 1px solid #CCCCCC;
		box-shadow: 1px 0 0 0 #FFFFFF;
	}
	
	.stat-boxes2 .right {
		width: 95px;
		text-align: center;
		min-width: 70px;
		float: left
	}
	
	.stat-boxes2 .left strong,
	.stat-boxes2 .right strong {
		display: block;
		font-size: 18px;
		margin-bottom: 10px;
		margin-top: 10px;
	}
</style>
<script type="text/javascript">
	<!--字典map-->
	var payWayMap = {};
	<c:forEach items="${fns:getSysBusiConfigList('payWay','')}" var="var">
		payWayMap["${var.paramKey}"]="${var.name}";
	</c:forEach>
	$(document).ready(function() {
		queryPayItem();
	});
	//查询消费情况
	function queryPayItem(){
		var isUnion = '${param.isUnion}'
		var orderId = '${param.orderId}';
		var params = {isUnion:isUnion,orderId:orderId};
		loadAjax("${ctx}/order/ordPaymentFund/getPayRefundVoListByBusiId",params,function(result){
			if(result.retCode=="000000"){
				var list = result.ret.list;
				var trHtml = "";
				var html = "";
				for(var i=0;i<list.length;i++){
					var obj = list[i];
					var payWay = obj.payWay;
					if(payWay=="6"){
						hasCreditFlag = true;
					}
					var payWayName = payWayMap[obj.payWay];
					var amount = obj.amount;
					var canRefundAmount = obj.canRefundAmount;		
					html+="<label>"+payWayName+canRefundAmount+"</label>\\";
				}
				$("#payItem").empty();
				$("#payItem").append(html.substr(0, html.length-1));
    	    }else{
    			$.jBox.alert(result.retMsg);
    	    }
		});
	}
</script>
<div class="row" style="position: fixed;bottom: 50px;">
	<div>可退支付方式：<span id="payItem"></span>
	</div>
</div>
<div class="row" style="position: fixed;bottom: 15px;z-index:999;">
	<label><input type="checkbox" id="ignorePayWayFlag"/>允许不按收款方式结账</label>
</div>
