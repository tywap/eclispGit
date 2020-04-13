<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>备用金下放</title>
    <meta name="decorator" content="default"/>
    <style>
        [class*="span"]{margin-left: 0;}
        .table tr td input, .table tr td select{width:94%;}
    </style>
    <script type="text/javascript">
        //*****************************************//
        //加载班次信息
        function loadShift(){
        	var storeId = $('#storeId').val();
            var shiftId = $('#shiftId').val();
            var params = {storeId:storeId,id:shiftId};
            $('#moneyList').html('');
            if(shiftId != null && shiftId != ''){
            	 $.ajax({
                     url:"${ctx}/order/orderSpareFund/queryShift",
                     type: "post",
                     dataType: "json",
                     async:false,
                     data: params,
                     success: function (result) {
                         if(result.retCode=="000000"){
                             var shiftModel = result.ret.shift;
                             var cashboxList = result.ret.cashboxList;
                             $('#totalBox').val(result.ret.totalMoney.amount);
                             if(shiftModel != null){
                                 $('#timeText').val(shiftModel.beginTime) ;
                             }
                             if(cashboxList != null){
                             	var html = '';
                             	var totalMoney = 0;
                             	for(var i=0;i<cashboxList.length;i++){
                             		totalMoney = cashboxList[i].changeMoney.amount + cashboxList[i].preTransfer.amount + cashboxList[i].spareDown.amount;
                             		html += "<tr >";
                             		html += "<td><label>"+cashboxList[i].label+"</label></td>";
                             		html += "<td><input name='amountMoney' type='text' id='amountMoney'  onchange='changeMoney(this,"+totalMoney.toFixed(2)+")'/></td>";
                             		html += "<td><label>"+totalMoney.toFixed(2)+"</label></td>";
                             		html += "<input type='hidden' name='boxId' id='boxId' value='"+cashboxList[i].id+"'/><input type='hidden' name='payWay' id='payWay' value='"+cashboxList[i].payMethod+"'/>";
                             		html += "</tr>";
                             	}
                             	$('#moneyList').append(html);
                             }
                         }else{
                             $.jBox.alert(result.retMsg);
                         }
                     },
                     error: function (result, status) {
                         $.jBox.alert("系统错误");
                     }
                 });
            }else{
            	$('#timeText').val('');
            }
           
        }
        //*****************************************//
        //input改变事件
        function  changeMoney(obj,balanceMoney) {
        	var operType = $("#operType").val();
        	if(operType == '4001' && Number($(obj).val()) > Number(balanceMoney)){
            	$.jBox.alert("上缴金额不允许大于钱箱余额！");
                $(obj).val(0);
        	}
            var num = 0;
            $("input[name='amountMoney']").each(function(index,item){
                if(Number($(this).val()) < 0){
                    $.jBox.alert("请输入正整数！");
                    $(this).val(0);
                }
                num += Number($(this).val());
            })
            $('#TotalAmount').val(num.toFixed(2));
        }
        //*****************************************//
        //提交
        function  save() {
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
            //表单
            var params = $('#inputForm').serialize();
            var boxIds=[];
            var moneys=[];
            var payWays=[];
            $("input[name='amountMoney']").each(function(index,item){
                if($(this).val() == ''){
                    moneys.push(0);
                }else{
                    moneys.push($(this).val());
                }
            })

            $("input[name='boxId']").each(function(index,item){
                boxIds.push($(this).val());
            })
            $("input[name='payWay']").each(function(index,item){
            	payWays.push($(this).val());
            })
            var tatolMoney =  $('#TotalAmount').val();
            if(tatolMoney == 0 || tatolMoney == ''){
            	 $.jBox.alert("没有上缴、下放备用金额");
            	 return;
            }
            params = params + "&moneys="+moneys+"&boxIds="+boxIds+"&payWays="+payWays;
            $.ajax({
                type: "post",
                dataType: "json",
                url: "${ctx}/order/orderSpareFund/save",
                async:false,
                data:params,
                success: function (result) {
                    if(result.retCode=="000000"){
                    	layer.confirm('操作成功！是否打印备用金上缴/下放单？', {
 							  btn: ['确定','取消'] 
 							}, function(){
 								window.open("${ctx}/print/printSpareFund?ordSpareFundIds="+result.retMsg);
 		                        loadShift();
 		                        $('#TotalAmount').val('');
 		                        $('#payee').val('');
 		                        $('#password').val('');
 		                        $('#remarks').val('');
 		                        window.parent.jBox.close();
 							}, function(){
 		                        loadShift();
 		                        $('#TotalAmount').val('');
 		                        $('#payee').val('');
 		                        $('#password').val('');
 		                        $('#remarks').val('');
 		                        window.parent.jBox.close();
 							});
                       
                    }else{
                        $.jBox.alert(result.retMsg);
                        var t1 = window.setTimeout(closeWindow,3000);
                    }
                },
                error: function (result, status) {
                    $.jBox.alert("系统错误");
                }
            });
        }
      //定时器 异步运行 
        function closeWindow(){ 
        	 window.parent.jBox.close();
        } 

    </script>
</head>
<body>
	<form id="inputForm" modelAttribute="ordSpareFund" method="post" class="form-horizontal">
		<div class="row">
		    <div class="span">
		        <div class="control-group">
		            <label class="control-label">当前班次：</label>
		            <div class="controls">
		                <select id="shiftId" name="shiftId" onchange="loadShift()">
		                    <option value="">--请选择--</option>
		                    <c:forEach items="${shiftList}" var="shift">
		                        <option value="${shift.id}">${shift.shiftName}</option>
		                    </c:forEach>
		                </select>
		            </div>
		        </div>
		    </div>
		    <div class="span">
		        <div class="control-group">
		            <label class="control-label-xs">当前班次时间：</label>
		            <div class="controls">
		                <input type="text" name="timeText" id="timeText"/>
		            </div>
		        </div>
		    </div>
		    <input type="hidden" name="operType" id="operType" value="${operType}"/>
	    </div>
		<div class="row">
		    <table class="table table-bordered" style="width: 70%;clear:both;" >
		        <thead>
		            <tr>
		                <th>付款方式</th>
		                <th>金额</th>
		                <th>钱箱余额</th>
		            </tr>
		        </thead>
		        <tbody id="moneyList">
		            <%-- <c:forEach items="${cashboxList}" var="cashbox">
		                <tr id="moneyList">
		                    <td><label>${cashbox.label}</label></td>
		                    <td><input name="amountMoney" id="amountMoney"  onchange="changeMoney()"/></td>
		                    <td><label>${cashbox.spareDown}</label></td>
		                    <input type="hidden" name="boxId" id="boxId" value="${cashbox.id}"/>
		                </tr>
		            </c:forEach> --%>
		        </tbody>
		        <tfoot>
		            <tr>
		                <td>小计</td>
		                <td><input type="text" name="TotalAmount" id="TotalAmount" readonly="readonly"/></td>
		                <td><input type="text" name="totalBox" id="totalBox"  readonly="readonly"/></td>
		            </tr>
		        </tfoot>
		    </table>
	    </div>
	    <div class="row" style="margin:8px 0;">
		    <div class="span" >
		        <div class="control-group">
		            <label class="control-label">收款人：</label>
		            <div class="controls">
		                <input type="text" name="payee" id="payee" ></input>
		            </div>
		        </div>
		    </div>
		    <div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs">密码：</label>
		            <div class="controls">
		                <input type="password" name="password" id="password" type="password" value="" ></input>
		            </div>
		        </div>
		    </div>
	    </div>
	    <div class="row">
		    <div class="span">
		        <div class="control-group">
		            <label class="control-label">备注：</label>
		            <div class="controls">
		                <textarea name="remarks" id="remarks" rows="4" style="width:715px;" maxlength="255"></textarea>
		            </div>
		        </div>
		    </div>
		   <%-- <div class="span">
		        <div class="control-group">
		            <label class="control-label">凭证号：</label>
		            <div class="controls">
		                <input  name="voucherNo" id="voucherNo" ></input>
		            </div>
		        </div>
		    </div>--%>
	    </div>
	    <div class="fixed-btn">
	        <input id="submitBtn" class="btn btn-primary" type="button" value="保 存" onclick="save()" />
	    </div>
	</form>
</body>
</html>