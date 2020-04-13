<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>交接班</title>
    <meta name="decorator" content="default"/>
    <style>
        [class*="span"]{margin-left: 0;}
        .table tr td label{text-align:right;display:block;}
        .table tfoot tr td label{color:#006DCC;font-weight:bold;}
    </style>
    <script type="text/javascript">
    	//提交
        function  save() {
    		var storeId = "${param.storeId}";
            //表单验证
            if (!$("#inputForm").valid()){
                $("#name").focus();
                return;
            }
            var shiftId = $('#shiftId').val();
            if(shiftId == '' || shiftId == null){
                $.jBox.alert("请选择班次");
                return;
            }
            var shiftClose = $('#payee').val();//交班人
            var name = $('#name').val();//接班人
            if(name == '' || name == null){
            	$.jBox.alert("接班人不允许为空！");
                return;
            }
            //表单
            var params = $('#inputForm').serialize();
            var payMethods=[];
            var transferWorks=[];//交班金额
            var total;//总金额
            //var remarks = $('#remarks').val();//描述
            
            $("input[name='transferWork']").each(function(index,item){
                transferWorks.push($(this).val());
            })
            $("input[name='payMethod']").each(function(index,item){
            	payMethods.push($(this).val());
            })
            params = params + "&transferWorks="+transferWorks+"&payMethods="+payMethods+"&total"+$('#total').val()+"&shiftId="+shiftId+"&storeId="+storeId;
            $.ajax({
                type: "post",
                dataType: "json",
                url: "${ctx}/order/ordCashbox/save",
                async:false,
                data:params,
                success: function (result) {
                    if(result.retCode=="000000"){
                    	layer.confirm(result.retMsg, {
  						  btn: ['确定'] 
  						}, function(index){
  							window.location.href = "${ctx}/logout";
  						}, function(){
  							return ;
  						});
                    }else{
                        $.jBox.alert(result.retMsg);
                    }
                },
                error: function (result, status) {
                    $.jBox.alert("系统错误");
                }
            });
        }
    </script>
</head>
<body>
<form id="inputForm" modelAttribute="ordSpareFund" method="post" class="form-horizontal">
	<input type="hidden" name="openCashboxTimeStr" value="${openCashboxTimeStr}"/>
    <div class="span" style="margin-right:20px;">
        <div class="control-group">
            <label class="control-label">当前班次：<span class="notice" style="font-size:18px;">${shiftName }</span></label>
        </div>
    </div>
    <div class="span">
        <div class="control-group">
            <label class="control-label">上班时间：<span>${beginTime }</span>至<>${endTime }</span></label>
        </div>
    </div>
	<div style="clear:both;"></div>
    <table class="table table-bordered" style="width:75%;float:left;margin-right:1%;">
        <thead>
            <tr>
                <th>付款方式</th>
                <th>备用金</th>
                <th>上班转入</th>
                <th>本班实收</th>
                <th>交接下班</th>
            </tr>
        </thead>
        <tbody id="moneyList">
            <c:forEach items="${cashboxList}" var="cashbox">
                <tr id="moneyList">
                    <td>${fns:getNameByParamKey(cashbox.payMethod,'payWay')}</td>
                    <td><input type="hidden" name="spareDown" readonly="readonly" id="spareDown" value="${cashbox.spareDown }"/><label>${cashbox.spareDown }</label></td>
                    <td><input type="hidden" name="preTransfer" readonly="readonly" id="preTransfer" value="${cashbox.preTransfer }"/><label>${cashbox.preTransfer }</label></td>
                    <td><input type="hidden" name="changeMoney" readonly="readonly" id="changeMoney" value="${cashbox.changeMoney }"/><label>${cashbox.changeMoney }</label></td>
                    <td style="color:red;"><input type="hidden" name=transferWork readonly="readonly" id="TransferWork" value="${cashbox.changeMoney.amount + cashbox.preTransfer.amount + cashbox.spareDown.amount}"/><label>${cashbox.changeMoney.amount + cashbox.preTransfer.amount + cashbox.spareDown.amount}</label></td>
                    <input type="hidden" name="payMethod" id="payMethod" value="${cashbox.payMethod}"/>
                </tr>
            </c:forEach> 
            
        </tbody>
        <tfoot style="color:#006DCC;font-weight:bold;">
            <tr>
                <td>合计</td>
                <td>
	                <input type="hidden" name="totalMoney" readonly="readonly" id="totalMoney" value="${cashboxTotalMoney.totalMoney}"/>
	                <label>${cashboxTotalMoney.totalMoney}</label>
                </td>
                <td>
	                <input type="hidden" name="preTransferTotal" readonly="readonly" id="preTransferTotal" value="${cashboxTotalMoney.preTransferTotal}"/>
	                <label>${cashboxTotalMoney.preTransferTotal}</label>
                </td>
                <td>
	                <input type="hidden" name="changeMoneyTotal" readonly="readonly" id="changeMoneyTotal" value="${cashboxTotalMoney.changeMoneyTotal}"/>
	                <label>${cashboxTotalMoney.changeMoneyTotal}</label>
                </td>
                <td>
	                <input type="hidden" name="total" readonly="readonly" id="total" value="${cashboxTotalMoney.changeMoneyTotal.amount + cashboxTotalMoney.preTransferTotal.amount +  cashboxTotalMoney.totalMoney.amount}"/>
	                <label>${cashboxTotalMoney.changeMoneyTotal.amount + cashboxTotalMoney.preTransferTotal.amount +  cashboxTotalMoney.totalMoney.amount}</label>
                </td>
           		
            </tr>
            
        </tfoot>
	              
	       
    </table>
    <table class="table table-bordered" style="width: 15%;" >
    	<tbody>
    		<tr>
            <td>备用金：${cashboxTotalMoney.totalMoney}</td>
            </tr>
            <tr>
            <td>上班转入：${cashboxTotalMoney.preTransferTotal}</td>
            </tr>
            <tr>
            <td>本班实收：${cashboxTotalMoney.changeMoneyTotal}</td>
            </tr>
            <c:forEach items="${paymentDetailList}" var="payment">
            	<tr>
            	<td>${payment.titleName}：${payment.amount}</td>
            </tr>
            </c:forEach>
    	</tbody>
    
    </table>
    <div style="clear:both;"></div>
     当前预授权： <span>${cashboxPreTotalMoney}</span>
    <div class="row" style="margin:8px 0;">	
    	<div class="span">
	        <div class="control-group">
	            <label class="control-label">交班人：</label>
	            <div class="controls">
	                <input type="text" name="payee" id="payee" readonly="readonly" value="${userName }" ></input>
	            </div>
	        </div>                                                                                                                                                                                                                    
	    </div>
	    <div class="span">
	        <div class="control-group">
	            <label class="control-label">接班班次：</label>
	            <div class="controls">
	                <select id="shiftId" name="shiftId" class="input-xlarge required"  disabled="disabled" >
	                    <c:forEach items="${shiftList}" var="shift">
	                        <option value="${shift.id}" >${shift.shiftName}</option>
	                    </c:forEach>
	                </select>
	            </div>
	        </div>
	    </div>
	    <div class="span" >
	        <div class="control-group">
	            <label class="control-label">接班人：</label>
	            <div class="controls">
	                <input type="text" name="name" id="name"   ></input>
	            </div>
	        </div>                                                                                                                                                                                                                    
	    </div>
	    <div class="span" >
	        <div class="control-group">
	            <label class="control-label">密码：</label>
	            <div class="controls">
	                <input  name="password" id="password" type="password" value="" ></input>
	            </div>
	        </div>
	    </div>
	</div>
    <div class="span">
        <div class="control-group">
            <label class="control-label">备注：</label>
            <div class="controls">
                <textarea name="remarks" id="remarks" rows="4" style="width:760px;" maxlength="255"></textarea>
            </div>
        </div>
    </div>
    <div class="fixed-btn">
       <shiro:hasPermission name="order:ordCashbox:edit"> <input id="submitBtn" class="btn btn-primary" type="button" value="保 存" onclick="save()" /></shiro:hasPermission>
    </div>

</form>
</body>
</html>