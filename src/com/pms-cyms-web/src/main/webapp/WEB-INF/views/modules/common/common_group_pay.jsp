<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>挂账</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		var eventName = '${param.eventName}';
		$(document).ready(function() {
			//提交
			$("#submitBtn").click(function(){
				submitBtn();
			});
			//查询协议单位
			$("#queryBtn").click(function(){
				queryBtn();
			});
			//查询协议单位明细
			$("#searchBtn").click(function(){
				searchBtn();
			});
		});
		
		//查询协议单位
		function queryBtn(){
			resetForm();
			var storeId = '${param.storeId}';
			var quickField = $("#quickField").val();
			if(quickField==""){
				layer.alert("请输入查询条件");
				return;
			}
			var params = {storeId:storeId,queryValue:quickField};
			loadAjax("${ctx}/member/group/getGroupList",params,function(result){
				if(result.retCode=="000000"){
					var list = result.ret.list;
					var html = "";
					if(list.length==0){
						html="<tr><td colspan='8'  style='text-align:center;'>无数据</td></tr>";
					}
					for(var i=0;i<list.length;i++){
						var obj = list[i];
						var htmlTemp = 
							"<tr>"+
								"<input type='hidden' name='obj' value='"+JSON.stringify(obj)+"'>"+
								"<td style='text-align:center;'><input type='radio' name='itemCheckBoxBtn'/></td>"+
								"<td>"+obj.agreementCode+"</td>"+
								"<td>"+obj.name+"</td>"+
								"<td>"+obj.linkMan+"</td>"+
								"<td>"+obj.phone+"</td>"+
								"<td>"+obj.userName+"</td>"+
								"<td>"+(obj.userPhone==undefined?'':obj.userPhone)+"</td>"+
								"<td>"+obj.officeName+"</td>"+
								"<td style='display:none'>"+obj.groupType+"</td>"+
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
							$("#groupId").val(obj.id);
							$("#name").val(obj.name);
							$("#voucher").val((obj.groupTypeName==undefined?'':obj.groupTypeName)+"/"+obj.name);
							$("#linkMan").val((obj.linkMan==undefined?'':obj.linkMan));
							
							var overdraftMoney = (obj.overdraftMoney==undefined)?'1000':obj.overdraftMoney;//可透支总额
							var oweMoney = (obj.oweMoney==undefined)?'0':obj.oweMoney;//未结挂账
							var balanceMoney = (obj.balanceMoney==undefined)?'0':obj.balanceMoney;//预交余额
							$("#overDraftMoney").val(overdraftMoney);
							$("#balanceMoney").val(balanceMoney);
							$("#oweMoney").val(oweMoney);
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
			$("#name").val('');
			$("#linkMan").val('');
			$("#overDraftMoney").val('');
			$("#oweMoney").val('');
		}
		
		//提交		
		function submitBtn(){
			var groupId = $("#groupId").val();
			var overDraftMoney = $("#overDraftMoney").val();
			var balanceMoney = $("#balanceMoney").val();
			var oweMoney = $("#oweMoney").val();
			var voucher = $("#voucher").val()
			if(overDraftMoney==""||balanceMoney==""){
				layer.alert("请选协议单位！");
				return;
			}
			var accMoney = parseFloat(overDraftMoney) - parseFloat(oweMoney);
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
			if(parseFloat(amount)>parseFloat(accMoney)){
				layer.alert("当前协议单位，可透支额度不足！");
				return;
			}
			top.$.publish(eventName,{index:'${param.index}',amount:amount,voucher:voucher,extend:groupId,rate:'1'});
			window.parent.jBox.close();
		}
		
		//查询协议单位
		function searchBtn(){
			var groupId = $("#groupId").val();
			if(groupId==""){
				layer.confirm("请选择协议单位", {
				  btn: ['确定'] 
				}, function(index){
					layer.close(index);
				}, function(){
					return ;
				});
				return;
			}
            var overdraft= 0;
            top.$.jBox.open(
                "iframe:${ctx}/protocol/cmGroup/form?eventName="+eventName+"&id="+groupId+"&bj=1"+"&overdraft="+overdraft+"&pageName=cmGroupForm",
                "协议单位查看",
                1000,
                $(top.document).height() - 180,
                {
                    buttons: {},
                    loaded: function (h) {
                        $(".jbox-content", top.document).css("overflow-y", "hidden");
                    }
                }
            );
		}
	</script>
</head>
<body>
	<form:form id="inputForm" action=" " method="post" class="form-horizontal">
		<div class="row">
			<div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>协议单位：</label>
		            <div class="controls">
		                <input type="text" id="quickField" value="${sourceName}" style="width:355px;" placeholder="协议名称\联系电话\协议编号"/>
		                <input type="button" class="btn btn-primary" id="queryBtn" value="查询" />
		            </div>
		        </div>
		    </div>
		</div>    
		<div class="row">
			<table id="contentTable" class="table table-striped table-bordered table-condensed" style="width:100%;">
				<thead>
					<tr>
						<th></th>
						<th>编号</th>
						<th>协议单位名称</th>
						<th>联系人</th>
						<th>联系电话</th>
						<th>业务员</th>
						<th>业务员电话</th>
						<th>归属酒店</th>
					</tr>
				</thead>
				<tbody id="tableBody">
				</tbody>
			</table>
		</div>
		<div class="row">
			<div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs">单位：</label>
		            <div class="controls">
		                <input type="text" id="name" readonly="readonly"/>
		                <input type="hidden" id="groupId"/>
		                <input type="hidden" id="voucher"/>
		            </div>
		        </div>
		    </div>
		    <div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs">联系人：</label>
		            <div class="controls">
		                <input type="text" id="linkMan" readonly="readonly"/>
		            </div>
		        </div>
		    </div>
		    <div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs">允许透支：</label>
		            <div class="controls">
		                <input type="text" id="overDraftMoney" readonly="readonly"/>
		                <input type="hidden" id="balanceMoney"/>
		            </div>
		        </div>
		    </div>
		    <div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs">未结挂账：</label>
		            <div class="controls">
		                <input type="text" id="oweMoney" readonly="readonly"/>
		            </div>
		        </div>
		    </div>
		    <div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>支付：</label>
		            <div class="controls">
		                <input type="text" id="amount"  readonly="readonly" value="${param.oweAmount}"/>
<!-- 		                <button type="button" id="searchBtn" class="btn btn-primary" style="padding:4px 16px;margin-left:-3px;"><i class="fa fa-search"></i></button> -->
		            </div>
		        </div>
		    </div>
		</div>	
		<div class="fixed-btn-right" style="padding:8px 5px;">
	        <input id="submitBtn" class="btn btn-primary"  type="button" value="确定" />
	    </div>
	</form:form>
</body>

