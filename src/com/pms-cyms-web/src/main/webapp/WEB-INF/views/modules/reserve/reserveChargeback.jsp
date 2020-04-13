<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>预定退单</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
    	$(document).ready(function(){
    		$("#submitBtn").bind("click", function() {
    			var remarks= $("#remarks").val();
    			var cause= $("#cause").val();
    			var tableNo ='${tableNo}';
    			var params={foodId:'${foodId}',foodName:'${foodName}',remarks:remarks,cause:cause,tableNo:tableNo};
    			loadAjax("${ctx}/reserve/reserveChargeback", params, function(result) {
    				if (result.retCode == "000000") {
    					layer.confirm('退单成功', {
    						btn: ['确定']
    					}, function(){
    						top.$.publish("ordIndex",{testData:"hello"});
    						window.parent.jBox.close();
    					}, function(){
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
    	
    	
    </script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="sysBusiConfig" action="${ctx}/setting/modusSetting/save" method="post" class="form-horizontal">
<input name="id" id="id" value="${DishesBigType.id }" type="text" htmlescape="false" maxlength="64" style="display:none;">
<div class="row" style=" margin-top: 20px;">
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs">菜品数量：</label>
					<div class="controls">
						<input name="number" id="number" value="${foodSize }" type="text" htmlescape="false" maxlength="64" class="input-xlarge required" readonly="readonly">
					</div>
				</div>
			</div>
			
			<div class="span">
			    <div class="control-group">
					<label class="control-label-xs">退菜原因：</label>
					<div class="controls">
					<select name="cause" id="cause" class="select-medium6">
						<option  >顾客取消</option>
						<option  >客人更换菜品</option>
						<option  >沽清</option>
						<option  >因服务员错误造成的退菜</option>
						<option  >菜品质量问题</option>
						<option  >上菜太慢</option>
						<option  >输机错误</option>
						</select>
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