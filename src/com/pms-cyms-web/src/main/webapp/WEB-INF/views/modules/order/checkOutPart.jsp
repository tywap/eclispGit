<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>部分结账</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		var eventName = '${param.eventName}';
		var pageName="checkOutPart";
		var itemAuditStatus={"0":"未下单","1":"已下单","2":"已退单"};
		var itemSettleStatus={"0":"未结账","1":"已结账"};
		$(document).ready(function() {
			//提交
			$("#submitBtn").bind("click",function(){
				submitBtn();
			});
			//关闭
			$("#closeBtn").click(function(){
				window.parent.jBox.close();
			});
			getOrdConsumesByOrdId();
		});
		
		//查询消费
		function getOrdConsumesByOrdId(){
			var orderId = '${param.orderId}';
			var params = {orderId:orderId};
			loadAjax("${ctx}/order/ordTableConsumeItem/getConsumesByOrderId",params,function(result){
				if(result.retCode=="000000"){
					var totalCount = 0;
					var totalRateAmount = 0;
					var totalAmount = 0;
					var list = result.ret.list;
					var html = "";
					for(var i=0;i<list.length;i++){
						var obj = list[i];
						var checkBoxHtml = "";
						if(obj.status=='1' && obj.settleStatus=='0'){
							checkBoxHtml = "<td style='text-align:center;'><input type='checkbox' name='itemCheckBoxBtn'/></td>";//已下单且未结账的可以勾选
						}else{
							checkBoxHtml = "<td style='text-align:center;'></td>";
						}
						html += "<tr name='consumeItem'>"+
							"<input type='hidden' name='obj' value='"+JSON.stringify(obj)+"'>"+
							checkBoxHtml+
							"<td>"+itemAuditStatus[obj.status]+"</td>"+
							"<td>"+itemSettleStatus[obj.settleStatus]+"</td>"+
							"<td>"+obj.code+"</td>"+
							"<td>"+obj.name+"</td>"+
							"<td>"+obj.foodUnitName+"</td>"+
							"<td>"+obj.count+"</td>"+
							"<td>"+obj.price+"</td>"+
							"<td>"+obj.rate.toFixed(2)+"</td>"+
							"<td>"+obj.rateAmount.toFixed(2)+"</td>"+
							"<td>"+obj.amount.toFixed(2)+"</td>"+
							"<td>"+1+"</td>"+
							"<td>"+obj.foodTypeName+"</td>"+
							"<td>"+(obj.remarks==undefined?'':obj.remarks)+"</td>"+
						"</tr>";
						totalCount += obj.count;
						totalRateAmount += obj.rateAmount;
						totalAmount += obj.amount;
					}
					html += "<tr>"+
						"<td colspan='5'>合计</td>"+
						"<td>"+totalCount+"</td>"+
						"<td colspan='2'></td>"+
						"<td>"+totalRateAmount.toFixed(2)+"</td>"+
						"<td>"+totalAmount.toFixed(2)+"</td>"+
						"<td colspan='3' style='text-align:right;'>已勾选：<span id='totalAmount' class='money'>"+0+"</span></td>"+
					"</tr>";
					$("#tableBody1").html(html);
					$("#consumeAmountOfDetail").html(totalAmount.toFixed(2));
					//checkbox单选
					$("input[name='itemCheckBoxBtn']").click(function(){
						setTotalAmount();
						stopBubbling(event);
					});
					//表格单选
					$('#contentTable1 tr').click(function(){
						tableSelected(this);
						setTotalAmount();
					});
					//表格选择
					$("tr[name='consumeItem']").bind("click",function(){
					}).hover(function(){
						if(!this.tag){
							$(this).css("background", "#FF9900");
						}
					}, function(){
						if(!this.tag){
							$(this).css("background", "");
						}
					});
			    }else{
					layer.alert(result.retMsg);
			    }
			});
		}
		
		//金额动态变化
		function setTotalAmount(){
			var amount = 0;
			var cks = $("input[name='itemCheckBoxBtn']:checked");
			for(var i=0;i<cks.length;i++){
				var obj = cks[i];
				var jsonStr = $(obj).parent().parent().find("[name='obj']").val();
				var jsonObj = JSON.parse(jsonStr);
				var amountStr = jsonObj.amount;
				var amountInt = 0;
				if(amountStr!=null && amountStr!=""){
					amountInt = Math.round(amountStr*100);
				}
				amount += amountInt;
			}
			$("#totalAmount").empty();
			$("#totalAmount").append(amount/100);
			
			//设置支付控件-仍需支付金额
			if(typeof setNeedPayAmount === "function"){
				setNeedPayAmount(amount/100);
			}
		}
		
		//提交
		function submitBtn(){
			var storeId = '${param.storeId}';
			var isUnion = '${param.isUnion}';
			var orderId = '${param.orderId}';//房单
			
			//消费明细
			var arr = [];
			var cks = $("input[name='itemCheckBoxBtn']:checked");
			if(cks.length==0){
				layer.alert("至少勾选一条消费用以支付！");
				return;
			}
			for(var i=0;i<cks.length;i++){
				var obj = cks[i];
				var jsonStr = $(obj).parent().parent().find("[name='obj']").val();
				var jsonObj = JSON.parse(jsonStr);
				var orderId = jsonObj.orderId;
				var id = jsonObj.id;
				var amount = jsonObj.amount;
				var titleEnum = jsonObj.titleEnum;
				
				var temp = {id:id,amount:amount,titleEnum:titleEnum};
				arr.push(temp);
			}
			//支付明细
			var obj = getPaymentFunds();
			var paymentFunds = obj.paymentFunds;
			var payTotalAmount = obj.payTotalAmount;
			var totalAmount = parseFloat($("#totalAmount").html());
			if(payTotalAmount!=totalAmount){
				layer.alert("勾选的金额和支付金额不一致！");
				return;
			}
			
			var params = {
				storeId:storeId,
				isUnion:isUnion,
				orderId:orderId,
				paymentDetailJson:JSON.stringify(arr),
				paymentFundJson:JSON.stringify(paymentFunds)
			};
			loadAjax("${ctx}/order/checkOut/checkOutPartCommit",params,function(result){
				if(result.retCode=="000000"){
					layer.confirm('部分结账成功', {
						btn: ['确定'] 
					}, function(){
						top.$.publish(eventName,{testData:"hello"});
					    window.parent.jBox.close();
					}, function(){
					});
	    	    }else{
					layer.confirm(result.retMsg, {
						btn: ['确定'] 
					}, function(){
						top.$.publish(eventName,{testData:"hello"});
				    	window.parent.jBox.close();
					}, function(){
					});
	    	    }
			});
		}
	</script>
</head>
<body>
	<form:form id="inputForm" action=" " method="post" class="form-horizontal" style="margin-bottom:50px;">
		<div class="row" style="margin:0 10px 10px 10px;">
			<label>台号：</label>
			<span>${param.tableNo}</span>
		</div>
		<table id="contentTable1" class="table table-striped table-bordered table-condensed" style="">
			<caption align="left">消费明细</caption>
			<colgroup>
				<col width="5%"/>
				<col width="7%"/>
				<col width="7%"/>
				<col width="5%"/>
				<col width="15%"/>
				<col width="5%"/>
				<col width="5%"/>
				<col width="5%"/>
				<col width="5%"/>
				<col width="5%"/>
				<col width="5%"/>
				<col width="5%"/>
				<col width="13%"/>
				<col width="13%"/>
			</colgroup>
			<thead>
				<tr>
					<th>选择</th>
					<th>订单状态</th>
					<th>结账状态</th>
					<th>编号</th>
					<th>菜品</th>
					<th>单位</th>
					<th>数量</th>
					<th>单价</th>
					<th>折扣率</th>
					<th>折扣金额</th>
					<th>小计</th>
					<th>做法</th>
					<th>菜品类型</th>
					<th>备注</th>
				</tr>
			</thead>
			<tbody id="tableBody1">
			</tbody>
		</table>
		<!-- 支付 -->
		<jsp:include page="../common/common_pay.jsp"></jsp:include>
		
		<div class="fixed-btn-right">
			<!-- <input id="closeBtn" class="btn btn-primary" type="button" value="取消"/>&nbsp; -->
			<input id="submitBtn" class="btn btn-primary" type="button" value="确认结账"/>
		</div>
	</form:form>
</body>
</html>
