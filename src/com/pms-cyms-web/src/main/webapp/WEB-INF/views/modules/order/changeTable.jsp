<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>转台</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
var orderId='${orderId}';
    	$(document).ready(function(){
    		var id="";
    		var value="";
    		var eventName = "changeTable";
			top.$.unsubscribe(eventName);
			//注册事件，弹出页面需要刷新本页面，或者弹出页面回传数据用
			top.$.subscribe(eventName, function(e, data) {
    	        id=data.testData[0];
    	        value=data.noData[0];
    	        $("#number1").val(id);
    	        $("#number").val(value);
			});
    		
    		$("#submitBtn").bind("click", function() {
    			var remarks=$("#remarks").val();
    			if (id == '') {
    				layer.alert("请先选择要换台的台号!");
    				return;
				}
    			var params={tableId:id,orderId:orderId,tableName:value,remarks:remarks};
    			loadAjax("${ctx}/order/checkIn/saveChangeTable", params, function(result) {
    				if (result.retCode == "000000") {
    					layer.confirm('转台成功', {
    						btn: ['确定']
    					}, function(){
    						top.$.publish("ordIndex",{eventName:"changeTable"});
    						window.parent.jBox.close();
    					}, function(){
    						window.parent.jBox.close();
    					});
    				} else {
    					layer.alert(result.retMsg);
    				}
    			});
    		});
        	
        	$("#cancel").bind("click", function() {
        		window.parent.jBox.close();
    		});
    		
    	});
    	
    	function selectTable() {
    		top.$.jBox.open("iframe:${ctx}/order/checkIn/selectTable?typeId=0&storeId=${storeId}", "台号选择", 1000, $(top.document).height() - 180, {
				buttons : {},
				loaded : function(h) {
					$(".jbox-content", top.document).css("overflow-y", "hidden");
				}
			});
		}
    	
    </script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="sysBusiConfig" action="${ctx}/setting/modusSetting/save" method="post" class="form-horizontal">
		<input name="id" id="id" value="${DishesBigType.id }" type="text" htmlescape="false" maxlength="64" style="display:none;">
		<div class="row" style=" margin-top: 20px;">
			<div class="span" >
				<div class="control-group" >
					<label class="control-label-xs" style="width: 125px;">台号名称：
						<span style="color:#E04445;">${tableNo }</span>
						</label>
				</div>
			</div>
			<div class="span">
				<div class="control-group" >
					<label class="control-label-xs" style="width: 180px;">消费金额：
						<span style="color:#E04445;">¥ ${consume }</span>
						</label>
				</div>
			</div>
			
			<div class="span" >
				<div class="control-group" >
					<label class="control-label-xs" style="width: 180px;">已付款：
						<span style="color:#E04445;">¥ ${proceeds }</span>
						</label>
				</div>
			</div>
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs">新台号名称：</label>
					<div class="controls">
					    <input id="number1"  type="hidden">
						<input name="number" id="number" onclick="selectTable()" type="text" style="width: 354px;" class="input-xlarge required" placeholder="单击选择台号">
					</div>
				</div>
			</div>
			<div class="row">
				<div class="span12">
					<div class="control-group">
						<label class="control-label-xs">备注信息：</label>
						<div class="controls">
							<textarea id="remarks" name="remarks" style="width: 354px;height: 80px;"></textarea>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="fixed-btn-right">
		<input type="button" id="cancel" class="btn btn-primary"
			style="background-color: #FF6347" value="取消" />&nbsp; 
		<input type="button" id="submitBtn" class="btn btn-primary" value="确 认" />&nbsp;&nbsp;&nbsp;&nbsp;
	</div>
	</form:form>
	
	
</body>
</html>