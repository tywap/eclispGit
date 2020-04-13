<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>订金</title>
<meta name="decorator" content="default" />
<script src="${ctxStatic}/common/jquery.webui-popover.min.js"
	type="text/javascript"></script>
<script src="${ctxStatic}/room/roomCard.js?V=1" type="text/javascript"></script>
<script src="${ctxStatic}/common/analysisIcCard.js"
	type="text/javascript"></script>
<link href="${ctxStatic}/common/jquery.webui-popover.min.css"
	rel="stylesheet">
<style>
[class*="span"] {
	margin-left: 0;
}
</style>
<script type="text/javascript">
	var eventName = "orderBranchReserveForm";
	var pageName = "reserveCheckInPage";
	  function save(){
		  	var ordReserveId=$("#ordReserveId").val();
		  	var depositAmount = $('#depositAmount').val();
			//支付明细
			var obj = getPaymentFunds();
			var paymentFunds = obj.paymentFunds;
			var payAmount = obj.payTotalAmount;
			if((parseInt(depositAmount) + parseInt(payAmount)) < 0){
				layer.alert("订金退款额度不允许超过原有订金额度！");
				return;
			}
		  	$.ajax({
            type: "post",
            dataType: "json",
            url: "${ctx}/reserve/saveDepositAmount",
            async:false,
            data:{
            	"ordReserveId":ordReserveId,
            	"paymentFundJson":JSON.stringify(paymentFunds)
            },
            success: function (result) {
          	  
                if(result.retCode=="000000"){
                  
                    top.$.publish("${param.eventName}",{testData:"hello"});
                    window.parent.jBox.close();
                }else if(result.retCode=="111111"){
                	 layer.alert(result.retMsg);
                	 top.$.publish("${param.eventName}",{testData:"hello"});
                    
                }else{
                    layer.alert(result.retMsg);
                }
            },
            error: function (result, status) {
                layer.alert("系统错误");
            }
        });
	  }
</script>
<style>
#clearCardBox {
	display: none;
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	background-color: rgba(0, 0, 0, .5);
	height: 100%;
}

#clearCardBox .box {
	position: absolute;
	top: 60px;
	left: 120px;
	width: 750px;
	background-color: #fff;
	height: 400px;
}

#clearCardBox .box .title {
	height: 40px;
	line-height: 40px;
	text-align: center;
	background-color: #31B080;
	color: #fff;
}

#clearCardBox .box .title h4, #clearCardBox .box .title .card-close {
	display: inline-block;
}

#clearCardBox .box .title .card-close {
	float: right;
	font-size: 40px;
	margin-top: -2px;
	cursor: pointer;
}

#clearCardBox .bg-active {
	background-color: #DEF5E3;
}

#clearCardBox tr .btns {
	text-align: center;
}
</style>
</head>
<body>
	<form id="inputForm" modelAttribute="ordReserve" method="post"
		class="form-horizontal">
		<div class="row">
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><span class="notice">*</span>订单号：</label>
					<div class="controls">
						<input type="text" id="ordReserveId" name="ordReserveId" maxlength="32"
							readonly="readonly" class="required digits"
							value="${ordUnionReserve.id}">
					</div>
				</div>
			</div>
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><span class="notice">*</span>联系人：</label>
					<div class="controls">
						<input type="text" id="name" name="name" 
							readonly="readonly" class="required"
							value="${ordUnionReserve.name}">
					</div>
				</div>
			</div>
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><span class="notice">*</span>联系方式：</label>
					<div class="controls">
						<input type="text" id="phone" name="phone" maxlength="32"
							readonly="readonly" class="required"
							value="${ordUnionReserve.phone}">
					</div>
				</div>
			</div>




		</div>
		<hr>
		<jsp:include page="../common/common_pay.jsp"></jsp:include>
		<div style=" margin-left: 30px; margin-top: 5px;">
		<span id="payTotalAmountDiv">
			<font color="red">已付订金：<span id="payTotalAmount">${reserveAmount }</span></font>
		</span>
		
		</div>
		<div class="fixed-btn-right">
			<input id="btnSubmit" class="btn btn-primary" type="button"
				onclick="save()" value="确 定" />&nbsp;
		</div>
	</form>
</body>
</html>