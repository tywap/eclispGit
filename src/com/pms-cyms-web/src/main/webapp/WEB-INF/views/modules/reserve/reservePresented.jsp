<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>预订赠送</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
    var foodIdList='';
    	$(document).ready(function(){
    		$("#submitBtn").bind("click", function() {
    			var remarks= $("#remarks").val();
    			var cause= $("#cause").val();
    			var params={foodId:'${foodId}',foodName:'${foodName}',remarks:remarks,cause:cause,tableNo:'${tableNo}'};
    			loadAjax("${ctx}/reserve/ordPresent", params, function(result) {
    				if (result.retCode == "000000") {
    					layer.confirm('赠送成功', {
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
				<div class="control-group" >
					<label class="control-label-xs" style="width: 103px;">已选：
					<span >${foodSize }</span>	
					</label>				
				</div>
			</div>
			
			<div class="span" >
			   <div class="control-group" >
					<label class="control-label-xs" style="width: 260px;">小计金额：
						<span>¥ ${subtotalAmount }</span>
						</label>
				</div>
			</div>
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs">原因：</label>
					<div class="controls">
						<select name="cause" id="cause" class="select-medium6" style="width: 200px;">
						<option >等候太久</option>
						<option >生日赠送</option>
						<option >美食标签本赠送</option>
						<option >其它</option>
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