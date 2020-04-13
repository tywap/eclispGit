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
			//查询
			$("#queryBtn").click(function(){
				queryBtn();
			});
			//查询明细
			$("#searchBtn").click(function(){
				searchBtn();
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
			var params = {storeId:storeId,queryValue:quickField};
			loadAjax("${ctx}/pay/getOrdRooms",params,function(result){
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
								"<td>"+obj.roomNo+"</td>"+
								"<td>"+obj.statusName+"</td>"+
								"<td>"+obj.id+"</td>"+
								"<td>"+obj.memberNames+"</td>"+
								"<td>"+obj.phones+"</td>"+
								"<td>"+(obj.certIds==undefined?'':obj.certIds)+"</td>"+
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
							$("#id").val(obj.id);
							$("#roomNo").val(obj.roomNo);
							$("#checkInDate").val(obj.checkInDate);
							$("#balanceAmountTotal").val(obj.balanceAmountTotal);
							$("#memberNames").val(obj.memberNames);
							$("#phones").val(obj.phones);
							$("#certIds").val(obj.certIds);
							$("#voucher").val(obj.id+"/房号:"+obj.roomNo+"/"+obj.memberNames);
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
			$("#id").val("");
			$("#roomNo").val("");
			$("#checkInDate").val("");
			$("#balanceAmountTotal").val("");
			$("#memberNames").val("");
			$("#phones").val("");
			$("#certIds").val("");
		}
		
		//提交		
		function submitBtn(){
			var id = $("#id").val();
			var balanceAmountTotal = $("#balanceAmountTotal").val();
			var voucher = $("#voucher").val();
			var amount = $("#amount").val();
			if(id==""||id==""){
				layer.alert("请选择明细！");
				return;
			}
// 			if(parseFloat(amount)>parseFloat(balanceAmountTotal)){
// 				layer.alert("余额不足！");
// 				return;
// 			}
			top.$.publish(eventName,{index:'${param.index}',amount:amount,voucher:voucher,extend:id,rate:'1'});
			window.parent.jBox.close();
		}
		
		//查询
		function searchBtn(){
			var groupId = $("#groupId").val();
			if(groupId==""){
				layer.confirm("请选择", {
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
                "查看",
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
		            <label class="control-label-xs"><span class="notice">*</span>查询条件：</label>
		            <div class="controls">
		                <input type="text" id="quickField" value="${sourceName}" style="width:355px;" placeholder="房号\房单号\联单号\住客\联络人"/>
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
						<th>房号</th>
						<th>房单状态</th>
						<th>单号</th>
						<th>住客信息/联络人</th>
						<th>联系电话</th>
						<th>证件号码</th>
					</tr>
				</thead>
				<tbody id="tableBody">
				</tbody>
			</table>
		</div>
		<div class="row">
			<div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs">房单号：</label>
		            <div class="controls">
		                <input type="text" id="id" readonly="readonly"/>
		                 <input type="hidden" id="voucher"/>
		            </div>
		        </div>
		    </div>
		    <div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs">房号：</label>
		            <div class="controls">
		                <input type="text" id="roomNo" readonly="readonly"/>
		            </div>
		        </div>
		    </div>
		    <div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs">入住时间：</label>
		            <div class="controls">
		                <input type="text" id="checkInDate" readonly="readonly"/>
		            </div>
		        </div>
		    </div>
		    <div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs">余额：</label>
		            <div class="controls">
		                <input type="text" id="balanceAmountTotal" readonly="readonly"/>
		            </div>
		        </div>
		    </div>
		</div>	
		<div class="row">
			<div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>住客：</label>
		            <div class="controls">
		                <input type="text" id="memberNames"  readonly="readonly"/>
		            </div>
		        </div>
		    </div>
		    <div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>联系电话：</label>
		            <div class="controls">
		                <input type="text" id="phones"  readonly="readonly"/>
		            </div>
		        </div>
		    </div>
		    <div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>证件号码：</label>
		            <div class="controls">
		                <input type="text" style="width:160px;" id="certIds"  readonly="readonly"/>
		            </div>
		        </div>
		    </div>
		</div>
		<div class="row">
			<div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>支付金额：</label>
		            <div class="controls">
		                <input type="text" id="amount"  readonly="readonly" value="${param.oweAmount}"/>
		            </div>
		        </div>
		    </div>
		</div>
		<div class="fixed-btn-right" style="padding:8px 5px;">
	        <input id="submitBtn" class="btn btn-primary"  type="button" value="确定" />
	    </div>
	</form:form>
</body>

