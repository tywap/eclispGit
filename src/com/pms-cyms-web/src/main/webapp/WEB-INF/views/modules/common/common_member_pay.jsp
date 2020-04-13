<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>储值卡支付</title>
	<meta name="decorator" content="default"/>
	<script src="${ctxStatic}/common/date.js" type="text/javascript"> </script>
	<script type="text/javascript">
		var eventName = '${param.eventName}';
		$(document).ready(function() {
			//提交
			$("#submitBtn").click(function(){
				submitBtn();
			});
		});
		
		//查询
		function queryBtn(){
			resetForm();
			var storeId = '${param.storeId}';
			var quickField = $("#quickField").val();
			if(quickField==""){
				layer.alert("请输入查询条件");
				return;
			}
			var dateNow=new Date().Format("yyyy-MM-dd");
			var params = {storeId:storeId,queryValue:quickField};
			loadAjax("${ctx}/member/member/getMemberList",params,function(result){
				if(result.retCode=="000000"){
					var list = result.ret.list;
					var html = "";
					if(list.length==0){
						html="<tr><td colspan='7'  style='text-align:center;'>无数据</td></tr>";
					}
					for(var i=0;i<list.length;i++){
						var obj = list[i];
						var htmlTemp = 
							"<tr>"+
								"<input type='hidden' name='obj' value='"+JSON.stringify(obj)+"'>"+
								"<td style='text-align:center;'><input type='radio' name='itemCheckBoxBtn'/></td>"+
								"<td>"+obj.memberName+"</td>"+
								"<td>"+obj.accountNo+"</td>"+
								"<td>"+obj.cardTypeName+"</td>"+
								"<td>"+obj.accMoney+"</td>"+
								"<td>"+obj.accScore+"</td>"+
								"<td>"+obj.phone+"</td>"+
								"<td style='display:none'>"+obj.id+"</td>"+
							"</tr>";
						html += htmlTemp;
					}
					$("#tableBody").empty();
					$("#tableBody").append(html);
					
					//表格单选
					$('tr').click(function(){
						tableSelected(this);
						var checkFlag = $(this).find("input[name='itemCheckBoxBtn']").is(":checked");
						var objStr = $(this).find("input[name='obj']").val();
						var obj = JSON.parse(objStr);
						if(checkFlag){
							$("input[name='itemCheckBoxBtn']").removeAttr("checked");
							$(this).find("input[name='itemCheckBoxBtn']").attr("checked","checked");
							$("#memberId").val(obj.id);
							$("#memberName").val(obj.memberName);
							$("#voucher").val((obj.cardTypeName==undefined?'':obj.cardTypeName)+"/"+obj.memberName+'/'+obj.phone);
							$("#phone").val((obj.phone==undefined?'':obj.phone));
							
							var accMoney = (obj.accMoney==undefined)?'0':obj.accMoney;
							var giftMoney = (obj.giftMoney==undefined)?'0':obj.giftMoney;
							$("#accMoney").val(accMoney);
							$("#giftMoney").val(giftMoney);
						}else{
							resetForm();
						}
					});
				}else{
					layer.alert(result.retMsg);
				}
			});
		}
		
		//清空表单
		function resetForm(){
			$("#memberName").val('');
			$("#phone").val('');
			$("#accMoney").val('');
			$("#giftMoney").val('');
		}
		
		//提交		
		function submitBtn(){
			var storeId = '${param.storeId}';
			var memberId = $("#memberId").val();
			var accMoney = $("#accMoney").val();
			var giftMoney = $("#giftMoney").val();
			var voucher = $("#voucher").val()
			if(accMoney==""||giftMoney==""){
				layer.alert("请选协议单位！");
				return;
			}
			var amount = $("#amount").val();
			if(amount==""){
				layer.alert("请输入本次支付金额！");
				return;
			}else{
				var amountFloat = parseFloat(amount);
				/**if(amountFloat<=0){
					layer.alert("挂账金额需大于0！");
					return;
				}**/
			}
			if(parseFloat(amount)>parseFloat(accMoney)+parseFloat(giftMoney)){
				layer.alert("余额不足！");
				return;
			}
			layer.prompt({title: '输入储值密码，并确认', formType: 1}, function(payPassword, index){
				layer.close(index);
				var params = {storeId:storeId,memberId:memberId,payPassword:payPassword};
				loadAjax("${ctx}/pay/validMemberPayPassword",params,function(result){
					if(result.retCode=="000000"){
						top.$.publish(eventName,{index:'${param.index}',amount:amount,voucher:voucher,extend:memberId,rate:'1'});
						window.parent.jBox.close();
		    	    }else{
		    			layer.alert(result.retMsg);
		    	    }
				});
			});
		}
	</script>
	<style>
	.selectedTr{background-color: #DEF5E3}
	</style>
</head>
<body>
	<form:form id="inputForm" action=" " method="post" class="form-horizontal">
		<div class="row">
			<div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>查询条件：</label>
		            <div class="controls">
		                <input type="text" id="quickField" style="width:180px;" placeholder="卡号、身份证号、手机号"/>
		                <input type="button" class="btn btn-primary" onclick="queryBtn()" value="查询" />
		            </div>
		        </div>
		    </div>
		</div>    
		<div class="row">
			<table id="contentTable" class="table table-striped table-bordered table-condensed" style="width:100%;">
				<thead>
					<tr>
						<th></th>
						<th>姓名</th>
						<th>会员卡号</th>
						<th>会员类别</th>
						<th>当前余额</th>
						<th>当前积分</th>
						<th>联系电话</th>
					</tr>
				</thead>
				<tbody id="tableBody">
				</tbody>
			</table>
		</div>
		<div class="row">
			<div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs">姓名：</label>
		            <div class="controls">
		                <input type="text" id="memberName" readonly="readonly"/>
		                <input type="hidden" id="memberId"/>
		                <input type="hidden" id="voucher"/>
		            </div>
		        </div>
		    </div>
		    <div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs">电话：</label>
		            <div class="controls">
		                <input type="text" id="phone" readonly="readonly"/>
		            </div>
		        </div>
		    </div>
		    <div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs">储值余额：</label>
		            <div class="controls">
		                <input type="text" id="accMoney" readonly="readonly"/>
		            </div>
		        </div>
		    </div>
		    <div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs">赠送余额：</label>
		            <div class="controls">
		                <input type="text" id="giftMoney" readonly="readonly"/>
		            </div>
		        </div>
		    </div>
		    <div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>支付金额：</label>
		            <div class="controls">
		                <input type="text" id="amount"  readonly="readonly" value="${param.amount}"/>
<!-- 		                <button type="button" id="searchBtn" class="btn btn-primary" style="padding:4px 16px;margin-left:-3px;"><i class="fa fa-search"></i></button> -->
		            </div>
		        </div>
		    </div>
		</div>	
		<div class="fixed-btn-right" style="padding:8px 5px;">
	        <input id="submitBtn" class="btn btn-primary" type="button" value="确定" />
	    </div>
	</form:form>
</body>