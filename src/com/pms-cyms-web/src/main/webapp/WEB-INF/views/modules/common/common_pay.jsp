<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<script type="text/javascript">
	//事件名称保持唯一，这里直接用tabId
	var commonPayEventName="common_pay";
	$(document).ready(function() {
        //解绑事件
        top.$.unsubscribe(commonPayEventName);
        //注册事件，弹出页面需要刷新本页面，或者弹出页面回传数据用
        top.$.subscribe(commonPayEventName, function (e, data) {
            //data  可以通过这个对象来回传数据
        	setPaymentFunds(data);
        });
		addRowPay();
		$("input[name='index1']").parent().find("[name='voucher']").attr("readonly","readonly");
	});
	var getNeedPayAmount;
	//新增列
	function addRowPay(){
		var index = $('.payRows').length+1;
		//下拉框
		var selectModel = $("#selectModel").html();
		var selectModelHtml = "";
		var initAmount = 0;
		if(pageName=='checkOut'){
			<c:forEach var="var" items="${fns:getSysBusiConfigList('payWay','1')}" varStatus="vs">
				if('${var.paramKey}'!='7'&&'${var.paramKey}'!='9'&&'${var.paramKey}'!='10'&&'${var.paramKey}'!='11'){
					selectModelHtml += "<option value='${var.paramKey}'> ${var.name}</option>";
				}
			</c:forEach>
			//获取需付款金额
			getNeedPayAmount  = function(){
				var initAmount = $("#balanceAmountTotal").html();
				initAmount = (initAmount==undefined)?0:initAmount;
				return initAmount;
			}
		}else if(pageName=="checkOutPart"){
			<c:forEach var="var" items="${fns:getSysBusiConfigList('payWay','1')}" varStatus="vs">
				if('${var.paramKey}'!='7'&&'${var.paramKey}'!='8'&&'${var.paramKey}'!='9'&&'${var.paramKey}'!='10'&&'${var.paramKey}'!='11'){
					selectModelHtml += "<option value='${var.paramKey}'> ${var.name}</option>";
				}
			</c:forEach>
			//获取需付款金额
			getNeedPayAmount  = function(){
				var totalAmount = $("#totalAmount").html();
				totalAmount = (totalAmount==undefined)?0:totalAmount;
				return totalAmount;
			}
		}else if(pageName=='shopping'){
			<c:forEach var="var" items="${fns:getSysBusiConfigList('payWay','1')}" varStatus="vs">
				if('${var.paramKey}'!='7'&&'${var.paramKey}'!='9'&&'${var.paramKey}'!='10'&&'${var.paramKey}'!='11'){
					selectModelHtml += "<option value='${var.paramKey}'> ${var.name}</option>";
				}
			</c:forEach>
			//获取需付款金额
			getNeedPayAmount  = function(){
				var totalAmount = $("#totalAmount").html();
				totalAmount = (totalAmount==undefined)?0:totalAmount;
				return totalAmount;
			}
		}else if(pageName=='deposit'){
			<c:forEach var="var" items="${fns:getSysBusiConfigList('payWay','1')}" varStatus="vs">
				if('${var.paramKey}'!='6'&&'${var.paramKey}'!='8'&&'${var.paramKey}'!='9'&&'${var.paramKey}'!='10'&&'${var.paramKey}'!='11'){
					selectModelHtml += "<option value='${var.paramKey}'> ${var.name}</option>";
				}
			</c:forEach>
			$("#notPayTotalAmountDiv").hide();
		}else if(pageName=='borrow'){
			<c:forEach var="var" items="${fns:getSysBusiConfigList('payWay','1')}" varStatus="vs">
				if('${var.paramKey}'!='6'&&'${var.paramKey}'!='7'&&'${var.paramKey}'!='8'&&'${var.paramKey}'!='9'&&'${var.paramKey}'!='10'&&'${var.paramKey}'!='11'){
					selectModelHtml += "<option value='${var.paramKey}'> ${var.name}</option>";
				}
			</c:forEach>
			//获取需付款金额
			getNeedPayAmount  = function(){
				var totalAmount = $("#totalAmount").html();
				totalAmount = (totalAmount==undefined)?0:totalAmount;
				return totalAmount;
			}
		}else if(pageName=='return'){
			<c:forEach var="var" items="${fns:getSysBusiConfigList('payWay','1')}" varStatus="vs">
				if('${var.paramKey}'!='6'&&'${var.paramKey}'!='7'&&'${var.paramKey}'!='8'&&'${var.paramKey}'!='9'&&'${var.paramKey}'!='10'&&'${var.paramKey}'!='11'){
					selectModelHtml += "<option value='${var.paramKey}'> ${var.name}</option>";
				}
			</c:forEach>
			//获取需付款金额
			getNeedPayAmount  = function(){
				var totalAmount = $("#totalAmount").html();
				totalAmount = (totalAmount==undefined)?0:totalAmount;
				return -totalAmount;
			}
		}else if(pageName=='member'){
			<c:forEach var="var" items="${fns:getSysBusiConfigList('payWay','1')}" varStatus="vs">
				if('${var.paramKey}'!='6'&&'${var.paramKey}'!='7'&&'${var.paramKey}'!='9'&&'${var.paramKey}'!='10'&&'${var.paramKey}'!='11'){
					selectModelHtml += "<option value='${var.paramKey}'> ${var.name}</option>";
				}
			</c:forEach>
			$("#payTotalAmountDiv").hide();
			$("#notPayTotalAmountDiv").hide();
		}else if(pageName=='upgradeMember'){
			<c:forEach var="var" items="${fns:getSysBusiConfigList('payWay','1')}" varStatus="vs">
				if('${var.paramKey}'!='6'&&'${var.paramKey}'!='7'&&'${var.paramKey}'!='9'&&'${var.paramKey}'!='10'&&'${var.paramKey}'!='11'){
					selectModelHtml += "<option value='${var.paramKey}'> ${var.name}</option>";
				}
			</c:forEach>
			getNeedPayAmount  = function(){
				var jsonStr = $("#cardTypeChange").find("option:selected").attr("jsonStr");
				if(jsonStr!=undefined && jsonStr!=null){
					var obj = JSON.parse(jsonStr);
					var cardFee = obj.cardFee;
					<shiro:hasPermission name="member:cmMember:upgradeNoLimit">
						cardFee = 0;
					</shiro:hasPermission>
					return cardFee;
				}else{
					layer.alert("请选择会员卡类型");
				}
			}
			$("#payTotalAmountDiv").hide();
			$("#notPayTotalAmountDiv").hide();
		}else if(pageName=='orderPayPage'){
			<c:forEach var="var" items="${fns:getSysBusiConfigList('payWay','1')}" varStatus="vs">
				if('${var.paramKey}'!='6'&&'${var.paramKey}'!='7'&&'${var.paramKey}'!='8'&&'${var.paramKey}'!='9'&&'${var.paramKey}'!='10'&&'${var.paramKey}'!='11'){
					selectModelHtml += "<option value='${var.paramKey}'> ${var.name}</option>";
				}
			</c:forEach>
			$("#notPayTotalAmountDiv").hide();
		}else if(pageName=='reserveCheckInPage'){
			<c:forEach var="var" items="${fns:getSysBusiConfigList('payWay','1')}" varStatus="vs">
				if('${var.paramKey}'!='6'&&'${var.paramKey}'!='8'&&'${var.paramKey}'!='9'&&'${var.paramKey}'!='10'&&'${var.paramKey}'!='11'){
					selectModelHtml += "<option value='${var.paramKey}'> ${var.name}</option>";
				}
			</c:forEach>
			$("#notPayTotalAmountDiv").hide();
		}else if(pageName=='groupPay'){
			<c:forEach var="var" items="${fns:getSysBusiConfigList('payWay','1')}" varStatus="vs">
				if('${var.paramKey}'!='6'&&'${var.paramKey}'!='7'&&'${var.paramKey}'!='9'&&'${var.paramKey}'!='10'&&'${var.paramKey}'!='11'){
					selectModelHtml += "<option value='${var.paramKey}'> ${var.name}</option>";
				}
			</c:forEach>
			$("#notPayTotalAmountDiv").hide();
		}else if(pageName=='groupSettlement'){
			<c:forEach var="var" items="${fns:getSysBusiConfigList('payWay','1')}" varStatus="vs">
				if('${var.paramKey}'!='6'&&'${var.paramKey}'!='7'&&'${var.paramKey}'!='10'&&'${var.paramKey}'!='11'){
					selectModelHtml += "<option value='${var.paramKey}'> ${var.name}</option>";
				}
			</c:forEach>
			//获取需付款金额
			initAmount = $("#settlementMoney").val();
			getNeedPayAmount  = function(){
				return initAmount;
			}
		}else if(pageName=='checkInPage'){
			<c:forEach var="var" items="${fns:getSysBusiConfigList('payWay','1')}" varStatus="vs">
				if('${var.paramKey}'!='6'&&'${var.paramKey}'!='8'&&'${var.paramKey}'!='9'&&'${var.paramKey}'!='10'&&'${var.paramKey}'!='11'){
					selectModelHtml += "<option value='${var.paramKey}'> ${var.name}</option>";
				}
			</c:forEach>
			$("#notPayTotalAmountDiv").hide();
		}else{
			<c:forEach var="var" items="${fns:getSysBusiConfigList('payWay','1')}" varStatus="vs">
				selectModelHtml += "<option value='${var.paramKey}'> ${var.name}</option>";
			</c:forEach>
		}
		//删除按钮
		var delBtnHtml ="";
		var defaultAmountHtml = "";
		if(index == 1){
			if(pageName=='checkOut'||pageName=='checkOutPart'||pageName=='shopping'||pageName=='borrow'||pageName=='return'
					||pageName=='groupSettlement'){
				var balanceAmountTotal = getNeedPayAmount(); 
				defaultAmountHtml = "value='"+balanceAmountTotal+"' disabled";	
			}else if(pageName=="upgradeMember"){
				defaultAmountHtml = " disabled";
			}
		}else{
			delBtnHtml = "<input class='btn btn-primary' type='button' data-id='"+index+"' onclick='delRowBtn(this)' value='-' style='margin-left:21px;'/>";
		}
		//支付行
		var html = ""+
		"<div class='row payRows' id='rowPay"+index+"'>"+
			"<input type='hidden' name='index"+index+"' value='"+index+"'/>";
		html+="<input type='hidden' name='extend' />"+
			"<input type='hidden' name='rate' />"+
			"<div class='span' >"+
		        "<div class='control-group'>"+
		            "<label class='control-label' >支付方式：</label>"+
		            "<div class='controls'>"+
						"<select name='payWay' onblur='openPayWindow(this,"+index+");' class='select-medium4'>"+
							selectModelHtml+
						"</select>"+
					"</div>"+
		        "</div>"+
			"</div>"+
		   	"<div class='span' >"+
		        "<div class='control-group'>"+
		            "<label class='control-label' >金额：</label>"+
		            "<div class='controls'>"+
						"<input type='text' name='amount' "+defaultAmountHtml+" maxlength='8' onblur='openPayWindow2("+index+");validDigist(this);'/>"+
					"</div>"+
		        "</div>"+
		   "</div>"+
		   	"<div class='span' >"+
		        "<div class='control-group'>"+
		            "<label class='control-label' >支付凭证：</label>"+
		            "<div class='controls'>"+
						"<input name='voucher' maxlength='32' type='text' style='width:180px;'/>"+
					"</div>"+
		        "</div>"+
		   "</div>"+
		   "<input class='btn btn-primary' type='button' id='addPay' data-id='"+index+"' onclick='addRowPay()' value='+' style='margin-left:21px;'/>"+
		   delBtnHtml+
		"</div>";
		$("#payBody").append(html);
		//结账、协议单位结算初始金额
		if(pageName=='checkOut'||pageName=='groupSettlement'){
			setNeedPayAmount(initAmount);
		}
	}
	//初始化
	function setNeedPayAmount(amount){
		$("#notPayTotalAmount").empty();
		$("#notPayTotalAmount").append(amount);
		setDynPayAmount();
	}
	//计算支付金额、仍需支付金额
	function setDynPayAmount(){
		if(pageName=='checkOut'||pageName=='checkOutPart'||pageName=='shopping'||pageName=='borrow'||pageName=='return'
			||pageName=='groupSettlement'||pageName=='upgradeMember'){
			//动态计算支付合计、仍需支付金额
			var rows = $(".payRows");
			var payTotalAmount = 0;
			for(var i=0;i<rows.length;i++){
				if(i>0){
					var obj = rows[i];
					var amount = $(obj).find("input[name='amount']").val();
					if(amount!="" && amount!=0){
						var amountInt = Math.round(amount*100);
						if(isNaN(amountInt)){
							amountInt = 0;
						}
						payTotalAmount += amountInt;
					}					
				}
			}
			var balanceAmountTotal = getNeedPayAmount();
			var firstAmountInput = Math.round(balanceAmountTotal*100) - (payTotalAmount);
			$("input[name='index1']").parent().find("[name='amount']").val(firstAmountInput/100);
		}
		//动态计算支付合计、仍需支付金额
		var rows = $(".payRows");
		var payTotalAmount = 0;
		for(var i=0;i<rows.length;i++){
			var obj = rows[i];
			var amount = $(obj).find("input[name='amount']").val();
			if(amount!="" && amount!=0){
				var amountInt = Math.round(amount*100);
				if(isNaN(amountInt)){
					amountInt = 0;
				}
				payTotalAmount += amountInt;
			}	
		}
		if(isNaN(payTotalAmount)){
			//支付合计
			$("#payTotalAmount").empty();
			$("#payTotalAmount").append(0);
			//仍需支付
			$("#notPayTotalAmount").empty();
		}else{
			//支付合计
			$("#payTotalAmount").empty();
			$("#payTotalAmount").append(payTotalAmount/100);
			//仍需支付
			var needPayAmount = payTotalAmount;
			if(typeof getNeedPayAmount === "function"){
				needPayAmount = getNeedPayAmount();
			}
			if(needPayAmount!=""){
				var need = Math.round(needPayAmount*100)-payTotalAmount;
				$("#notPayTotalAmount").empty();
				$("#notPayTotalAmount").append(need/100);
			}else{
				$("#notPayTotalAmount").empty();
			}
		}
	}
	//删除列
	function delRowBtn(obj){
		var index=$(obj).data("id");
		$("#rowPay"+index).remove();
		setDynPayAmount();
	}
	//调用支付
	function openPayWindow(obj,index){
		if(!((pageName=='checkOut'||pageName=='checkOutPart'||pageName=='shopping'||pageName=='borrow'||pageName=='return'
				||pageName=='groupSettlement')||pageName=='upgradeMember' && index==1)){
			$("input[name='index"+index+"']").parent().find("[name='amount']").removeAttr("readonly");
			$("input[name='index"+index+"']").parent().find("[name='amount']").val("");
		}
		$("input[name='index"+index+"']").parent().find("[name='voucher']").removeAttr("readonly");
		$("input[name='index"+index+"']").parent().find("[name='voucher']").val("");
		var payWay=$(obj).val();
		if(payWay=="1"){
			//现金
			$("input[name='index"+index+"']").parent().find("[name='voucher']").attr("readonly","readonly");
		} else if(payWay=="2"){
			//银行卡
		} else if(payWay=="3"||payWay=="4"){
			//layer.alert("外设读取支付条码...");
		}else if(payWay=="5"){
			//储值卡支付
			openPayWindow2(index);
		}else if(payWay=="6"){
			//挂账支付
			openPayWindow2(index);
		}else if(payWay=="7"){
			//预授权
		}else if(payWay=="8"){
			//减免 
		}else if(payWay=="9"){
			//预交
		}else if(payWay=="12"){
			//微信-手工
		}else if(payWay=="13"){
			//支付宝-手工
		}else if(payWay=="17"){
			//挂房账
			openPayWindow2(index);
		}else{
			console.log("请确认支付方式！");
		}
	}
	//调用支付
	function openPayWindow2(index){
		var payWay = $("input[name='index"+index+"']").parent().find("[name='payWay']").val();
		var amount = $("input[name='index"+index+"']").parent().find("[name='amount']").val();
		if(payWay=="5"){
			$("input[name='index"+index+"']").parent().find("[name='voucher']").attr("readonly","readonly");
			if(amount==""){
				return;
			}
			//储值卡支付
			var amountFloat = parseFloat(amount);
			if(amountFloat>0){
				top.$.jBox.open(
		           "iframe:${ctx}/pay/memberPayInit?eventName="+commonPayEventName+
		           		"&storeId=${param.storeId}&orderId=${param.orderId}&tableNo=${param.tableNo}&index="+index+"&amount="+amount,
		           "储值卡支付",
		           1050,
		           560,
		           {
		               buttons: {},
		               loaded: function (h) {
		                   $(".jbox-content", top.document).css("overflow-y", "hidden");
		               }
		           }
		        );			
			}else{
				
			}
		}else if(payWay=="6"){
			$("input[name='index"+index+"']").parent().find("[name='voucher']").attr("readonly","readonly");
			if(amount==""){
				return;
			}
			//储值卡支付
			var amountFloat = parseFloat(amount);
			if(amountFloat>0){
				top.$.jBox.open(
	               "iframe:${ctx}/pay/groupPayInit?eventName="+commonPayEventName+"&storeId=${param.storeId}&orderId=${param.orderId}&tableNo=${param.tableNo}&index="+index+"&oweAmount="+amount,
	               "挂账",
	               1050,
	               560,
	               {
	                   buttons: {},
	                   loaded: function (h) {
	                       $(".jbox-content", top.document).css("overflow-y", "hidden");
	                   },
	                   closed:function (){
	                	   setDynPayAmount();
	                   }
	               }
	            );		
			}else{
				
			}
		}else if(payWay=="17"){
			$("input[name='index"+index+"']").parent().find("[name='voucher']").attr("readonly","readonly");
			if(amount==""){
				return;
			}
			//储值卡支付
			var amountFloat = parseFloat(amount);
			if(amountFloat>0){
				top.$.jBox.open(
	               "iframe:${ctx}/pay/roomPayInit?eventName="+commonPayEventName+"&storeId=${param.storeId}&orderId=${param.orderId}&tableNo=${param.tableNo}&index="+index+"&oweAmount="+amount,
	               "挂房账",
	               1050,
	               560,
	               {
	                   buttons: {},
	                   loaded: function (h) {
	                       $(".jbox-content", top.document).css("overflow-y", "hidden");
	                   },
	                   closed:function (){
	                	   setDynPayAmount();
	                   }
	               }
	            );		
			}else{
				
			}
		}
		setDynPayAmount();
	}
	//设置付款信息
	function setPaymentFunds(data){
		var index = data.index;
		var amount = data.amount;
		var voucher = data.voucher;
		var extend = data.extend;
		var rate = data.rate;
		$("input[name='index"+index+"']").parent().find("input[name='amount']").val(amount);
		$("input[name='index"+index+"']").parent().find("input[name='voucher']").val(voucher);
		$("input[name='index"+index+"']").parent().find("input[name='extend']").val(extend);
		$("input[name='index"+index+"']").parent().find("input[name='rate']").val(rate);
	}
	//获取付款信息
	function getPaymentFunds(){
		var arr = [];
		var rows = $(".payRows");
		if(rows.length==0){
			layer.alert("请填写支付信息！");
			return;
		}
		var totalAmountTemp = 0;
		var ids = [];
		for(var i=0;i<rows.length;i++){
			var obj = rows[i];
			var payWay =  $(obj).find("select[name='payWay']").val();
			var amount = $(obj).find("input[name='amount']").val();
			var voucher = $(obj).find("input[name='voucher']").val();
			var extend = $(obj).find("input[name='extend']").val();
			var rate = $(obj).find("input[name='rate']").val();
			var ignorePayWayFlag = $("#ignorePayWayFlag").is(":checked")?"1":"0";
			if(pageName=='shopping'||pageName=='member'||pageName=='upgradeMember'){
				ignorePayWayFlag = "1";
			}
			if(rate==''||rate==undefined){
				rate = "1";
			}
			if(ids.indexOf(payWay)>=0){
				layer.alert("支付类型重复！");
				return;
			}else{
				ids.push(payWay);
			}
			if(payWay=="1"||payWay=="2"){
				//现金或者刷卡
			}else if(payWay=="3"||payWay=="4"){
				if(amount==""||amount==0){
					layer.alert("请输入金额！");
					return;
				}
				if(parseFloat(amount)>0 && voucher==""){
					layer.alert("请输入支付条码！");
					return;					
				}
			}else if(payWay=="5"){
				if(amount==""||amount==0){
					layer.alert("请输入金额！");
					return;
				}
				if(parseFloat(amount)>0 && voucher=="" && extend==""){
					layer.alert("请输入支付凭证！");
					return;					
				}
			}else if(payWay=="6"){
				if(amount==""||amount==0){
					layer.alert("请输入金额！");
					return;
				}
				if(parseFloat(amount)>0 && voucher=="" && extend==""){
					layer.alert("请输入支付凭证！");
					return;					
				}
			}
			if(amount!="" && amount!=0){
				var amountFloat = parseFloat(amount);
				if(isNaN(amountFloat)){
					amountFloat = 0;
				}
				totalAmountTemp += Math.round(amountFloat*100);
				var temp ={payWay:payWay,amount:amount,voucher:voucher,extend:extend,ignorePayWayFlag:ignorePayWayFlag,rate:rate};
				arr.push(temp);
			}else{
				var temp ={payWay:payWay,amount:0,voucher:voucher,extend:extend,ignorePayWayFlag:ignorePayWayFlag,rate:rate};
				arr.push(temp);
			}
		}
		var obj = {paymentFunds:arr,payTotalAmount:totalAmountTemp/100};
		return obj;
	}
</script>
<div>
	<div class="row" style="background-color:#F1F1F1;padding:20px 30px 10px;border-radius:4px;">
		<div class="row" id="payBody"></div>
		<span id="payTotalAmountDiv">
			<font color="blue">支付合计：<span id="payTotalAmount">0</span></font>&nbsp;&nbsp;&nbsp;&nbsp;
		</span>
		<span id="notPayTotalAmountDiv">
			<font color="red">仍需支付：<span id="notPayTotalAmount">0</span></font>
		</span>
	</div>
</div>

