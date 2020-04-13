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
		padding: 8px;
		
		color: #666;
	}
	
	.stat-boxes2 .left {
		border-right: 1px solid #CCCCCC;
		box-shadow: 1px 0 0 0 #FFFFFF;
	}
	
	.stat-boxes2 .right {
		width: 115px;
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
	$(document).ready(function() {
		queryAccount();
	});
	//查询消费情况
	function queryAccount(){
		var isUnion = '${param.isUnion}'
		var orderId = '${param.orderId}';
		var params = {isUnion:isUnion,orderId:orderId};
		loadAjax("${ctx}/order/checkOut/getConsumePayTotal",params,function(result){
			if(result.retCode=="000000"){
				var obj = result.ret;
				//消费
				$("#consumeAmountTotal").html(obj.consumeAmountTotal);
				//已收退
				$("#payAmountTotal").html(obj.payAmountTotal);
				//预授权
				$("#preauthAmountTotal").append(obj.payPreauthTotal);
				//余额
				$("#balanceAmountTotal").html(obj.balanceAmountTotal);
				//设置支付控件-仍需支付金额
				if(typeof setNeedPayAmount === "function"){
					setNeedPayAmount(obj.balanceAmountTotal);
				}
    	    }else{
    			$.jBox.alert(result.retMsg);
    	    }
		});
	}
</script>
<div class="row">
	<ul class="stat-boxes2">
		<li>
			<div class="left"> <strong style="color: #AE3C0C;">总消费：</strong> </div>
			<div class="right"><strong><span id="consumeAmountTotal"></span></strong> </div>
		</li>
		<li>
			<input type="hidden" id="depositAmount"/>
			<div class="left"> <strong style="color: #1B55C0;">已收/退：</strong> </div>
			<div class="right"> <strong><span id="payAmountTotal"></span></strong> </div>
		</li>
		<li>
			<div class="left"> <strong style=" color: #97080E;">应收：</strong> </div>
			<div class="right"> <strong><span id="balanceAmountTotal"></span></strong> </div>
		</li>
	</ul>
</div>
<div class="row">
	<div style="color:#E04445;margin:0 10px;">另刷预授权：<span id="preauthAmountTotal"></span></div>
</div>