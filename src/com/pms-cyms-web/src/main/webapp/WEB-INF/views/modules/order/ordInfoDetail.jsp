<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<script type="text/javascript">
	<!--字典map-->
	var payWayMap = {};
	<c:forEach items="${fns:getSysBusiConfigList('payWay','')}" var="var">
		payWayMap["${var.paramKey}"]="${var.name}";
	</c:forEach>
	var itemStatus={"0":"未下单","1":"已下单","2":"已退单"};
	var itemSettleStatus={"0":"未结账","1":"已结账"};
	var foodStatus={"0":"否","1":"是","":"否"};
	var call_status={"1":"即起","2":"加急","3":"叫起","":""};
	var status='${chuancaiBtn}';
	$(document).ready(function(){
		//查询消费情况
		$("#queryType").change(function(){
			getOrdConsumesByOrdId();
		});
		
	});
	
	//查询消费
	function getOrdConsumesByOrdId(){
		var orderId = '${orderId}';
		var params = {orderId:orderId};
		loadAjax("${ctx}/order/ordTableConsumeItem/getConsumesByOrderId",params,function(result){
			if(result.retCode=="000000"){
				var totalCount = 0;
				var totalRateAmount = 0;
				var totalAmount = 0;
				var totalConsume = 0;
				var list = result.ret.list;
				var html = "";
				for(var i=0;i<list.length;i++){
					var obj = list[i];
					html += "<tr name='consumeItem' data-status='"+obj.status+"' ondblclick='updateFood("+JSON.stringify(obj)+")'>"+
						"<input type='hidden' name='obj' value='"+JSON.stringify(obj)+"'>"+
						"<td><input type='checkbox' checked name='itemCheckBoxBtn' class='weeks' id='"+obj.id+"' value='"+obj.status+"' data-id='"+obj.foodId+"'/></td>"+
						"<td>"+itemStatus[obj.status]+"</td>"+
						"<td>"+itemSettleStatus[obj.settleStatus]+"</td>"+
						"<td>"+call_status[obj.callStatus]+"</td>"+
						"<td>"+foodStatus[obj.promptFlag]+"</td>"+
						"<td>"+obj.code+"</td>"+
						"<td>"+obj.name+"</td>"+
						"<td>"+obj.foodUnitName+"</td>"+
						"<td>"+obj.count+"</td>"+
						"<td>"+obj.price+"</td>"+
						"<td>"+obj.rate+"</td>"+
						"<td>"+obj.rateAmount.toFixed(2)+"</td>"+
						"<td>"+obj.amount.toFixed(2)+"</td>"+
						"<td>"+obj.cookValues+obj.cookValuesTemp+"</td>"+
						"<td>"+obj.foodTypeName+"</td>"+
						"<td>"+(obj.remarks==undefined?'':obj.remarks)+"</td>"+
					"</tr>";
					totalConsume += (obj.count*obj.price);
					totalCount += obj.count;
					totalRateAmount += obj.rateAmount;
					totalAmount += obj.amount;
					if(obj.packageTypeName == "套餐"){
						var comboFood=obj.comboFood;
						for(var j=0;j<comboFood.length;j++){
							html += "<tr>"+
							"<td></td>"+
							"<td>"+itemStatus[obj.status]+"</td>"+
							"<td>"+itemSettleStatus[obj.settleStatus]+"</td>"+
							"<td>"+call_status[obj.callStatus]+"</td>"+
							"<td>"+foodStatus[obj.promptFlag]+"</td>"+
							"<td>"+comboFood[j].code+"</td>"+
							"<td>"+comboFood[j].name+"</td>"+
							"<td>"+comboFood[j].foodUnitName+"</td>"+
							"<td>"+comboFood[j].comboNumber+"</td>"+
							"<td></td>"+
							"<td></td>"+
							"<td></td>"+
							"<td></td>"+
							"<td></td>"+
							"<td>"+obj.packageTypeName+"</td>"+
							"<td></td>"+
							"</tr>";
						}
					}
				}
				html += "<tr>"+
					"<td colspan='8'>合计</td>"+
					"<td>"+totalCount+"</td>"+
					"<td colspan='2'></td>"+
					"<td>"+totalRateAmount.toFixed(2)+"</td>"+
					"<td>"+totalAmount.toFixed(2)+"</td>"+
					"<td colspan='3'></td>"+
				"</tr>";
				$("#tableBody1").html(html);
				$("#totalCount").html("菜品数量："+totalCount+"个");//菜品数量
				$("#totalConsume").html("消费金额：¥"+totalConsume.toFixed(2));//消费金额
				$("#totalRateAmount").html("折扣：¥"+totalRateAmount.toFixed(2));//折扣
				$("#totalAmount").html("总消费：¥"+totalAmount.toFixed(2));//总消费
				$("#accountsDue").html("应收款：¥"+totalAmount.toFixed(2));//应收款
				$("#consume").val(Number(totalAmount).toFixed(2));
				$("#count").val(list.length);
				Number(totalAmount).toFixed(2)
				//checkbox单选
				$("input[name='itemCheckBoxBtn']").click(function(){
					stopBubbling(event);
				});
				//表格单选
				$('#contentTable1 tr').click(function(){
					if(this.id=='trhead'){
						return;
					}
					tableSelected(this);
					
					if (status != "disabled") {
						var chuancai=document.getElementById("chuancaiBtn");
						var jiqi=document.getElementById("jiqiBtn");
						var jiaji=document.getElementById("jiajiBtn");
						var jiaoqi=document.getElementById("jiaoqiBtn");
						if(this.children[1].children[0].checked == false){
							chuancai.disabled="";
							jiqi.disabled="";
							jiaji.disabled="";
							jiaoqi.disabled="";
						}else{
							if(this.dataset.status != '0'){
								chuancai.disabled="disabled";
								jiqi.disabled="disabled";
								jiaji.disabled="disabled";
								jiaoqi.disabled="disabled";
							}else{
								chuancai.disabled="";
								jiqi.disabled="";
								jiaji.disabled="";
								jiaoqi.disabled="";
							}
						}
					}
					
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
				getPaymentFundsByOrderId();
		    }else{
				layer.alert(result.retMsg);
		    }
		});
	}
	
	//查询付款
	function getPaymentFundsByOrderId(){
		var orderId = '${orderId}';
		var params = {orderId:orderId};
		loadAjax("${ctx}/order/ordPaymentFund/getPaymentFundsByOrderId",params,function(result){
			if(result.retCode=="000000"){
				var totalAmount = 0;
				var list = result.ret.list;
				var html = "";
				for(var i=0;i<list.length;i++){
					var obj = list[i];
					if(obj.titleNo!='5001' && obj.titleNo!='5002' && obj.titleNo!='1006'){
						//踢出预授权
						html += "<tr>"+
							"<input type='hidden' name='obj' value='"+JSON.stringify(obj)+"'>"+
							"<td>"+(i+1)+"</td>"+
							"<td>"+obj.createDate+"</td>"+
							"<td>"+payWayMap[obj.payMethod]+"</td>"+
							"<td>"+obj.amount.amount+"</td>"+
							"<td>"+(obj.description==undefined?'':"备注："+obj.description+"</br>")+
								(obj.payVoucher==undefined||obj.payVoucher==''?'':"支付凭证："+obj.payVoucher+"</br>")+
								(((obj.payMethod=='3'||obj.payMethod=='4'||obj.payMethod=='10')&&(obj.payId!=undefined||obj.payId!=''))?"支付流水："+obj.payId+"":'')+"</td>"+
							"<td>"+obj.name+"</td>"+
						"</tr>";
						totalAmount += obj.amount.amount;
					}
				}
				$("#tableBody11").html(html);
				$("#theTotalPayment").html("总收款：¥"+Number(totalAmount).toFixed(2));
				$("#proceeds").val(Number(totalAmount).toFixed(2));
		    }else{
				layer.alert(result.retMsg);
		    }
		});
	}
	
</script>
<div>
	<form:form id="inputForm" action=" " method="post" class="form-horizontal">
		<div class="row" style="margin:0 10px;">
			<table id="contentTable1" class="table table-striped table-bordered table-condensed" style="">
				<caption style="text-align: left;"><strong>消费明细：</strong></caption>
				<colgroup>
					<col width="5%"/>
					<col width="7%"/>
					<col width="7%"/>
					<col width="8%"/>
					<col width="5%"/>
					<col width="4%"/>
					<col width="10%"/>
					<col width="3%"/>
					<col width="3%"/>
					<col width="3%"/>
					<col width="5%"/>
					<col width="5%"/>
					<col width="5%"/>
					<col width="10%"/>
					<col width="7%"/>
					<col width="10%"/>
				</colgroup>
				<thead>
					<tr id="trhead">
						<th style="cursor:pointer">全选 <input type="checkbox" class="weeksAll"></th>
						<th>状态</th>
						<th>结账状态</th>
						<th>即时状态</th>
						<th>催菜</th>
						<th>编号</th>
						<th>菜品</th>
						<th>单位</th>
						<th>数量</th>
						<th>单价</th>
						<th>折扣</th>
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
			<table id="contentTable2" class="table table-striped table-bordered table-condensed" style="margin-bottom:30px;">
				<caption  style="text-align: left;"><strong>收款明细：</strong></caption>
				<colgroup>
					<col width="5%"/>
					<col width="20%"/>
					<col width="10%"/>
					<col width="10%"/>
					<col width="35%"/>
					<col width="20%"/>
				</colgroup>
				<thead>
					<tr>
						<th>序号</th>
						<th>收款时间</th>
						<th>收款方式</th>
						<th>金额</th>
						<th>备注</th>
						<th>收款人</th>
					</tr>
				</thead>
				<tbody id="tableBody11">
				</tbody>
			</table>
		</div>
	</form:form>
</div>