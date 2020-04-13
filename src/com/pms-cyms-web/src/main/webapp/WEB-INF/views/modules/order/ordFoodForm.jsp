<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>菜品编辑</title>
<meta name="decorator" content="default" />
<style type="text/css">
	input::-webkit-outer-spin-button,
    input::-webkit-inner-spin-button {
        -webkit-appearance: none;
    }
    input[type="number"]{
        -moz-appearance: textfield;
        width: 120px;
    }
</style>
<script type="text/javascript">
    var foodIdList='';
    	$(document).ready(function(){
    		$("#submitBtn").bind("click", function() {
    			var remarks= $("#remarks").val();
    			var id= $("#id").val();
    			var price= $("#price").val();
    			var count= $("#count").val();
    			var foodName =$("#foodName").val();
    			var params={id:id,foodName:foodName,remarks:remarks,price:price,count:count};
    			loadAjax("${ctx}/order/checkIn/updateFood", params, function(result) {
    				if (result.retCode == "000000") {
    					layer.confirm('设置成功', {
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
	<form:form id="inputForm" modelAttribute="sysBusiConfig" action="${ctx}/order/checkIn/updateFood" method="post" class="form-horizontal">
		<input name="id" id="id" value="${ordTable.id }" type="text" htmlescape="false" maxlength="64" style="display:none;">
		   <div class="control-group" style="margin-left: 30px; margin-top: 10px;">
				菜品名称：<span name="foodName" id="foodName" class="input-xlarge required">${ordTable.foodName }</span>
			</div>
		<div class="row">
			<div class="span" >
			   <div class="control-group"; style="width: 260px;">
					<label class="control-label-xs"; style="width: 200px; margin-left: 25px;">菜品价格：
						<input name="price" id="price" value="${ordTable.price }" type="number" class="input-xlarge required" />
					</label>
				</div>
			</div>
			<div class="span">
				<div class="control-group"; style="width: 220px;">
					<label class="control-label-xs"; style="width: 200px;">菜品数量：
					<input name="count" id="count" value="${ordTable.count }" type="number" class="input-xlarge required" />
					</label>
				</div>
			</div>
			<div class="row">
				<div class="span12">
					<div class="control-group">
						<label class="control-label-xs">备注信息：</label>
						<div class="controls">
							<textarea id="remarks" name="remarks" style="width: 354px;height: 80px;">${ordTable.remarks }</textarea>
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