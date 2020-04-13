<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>状态</title>
    <meta name="decorator" content="default"/>
    <script type="text/javascript">
    var foodIdList='';
    	$(document).ready(function(){
    		$("#submitBtn").bind("click", function() {
    			var params={foodIdList:"${foodIdList}",type:"${type}"};
    			loadAjax("${ctx}/order/checkIn/foodStatusSub", params, function(result) {
    				if (result.retCode == "000000") {
    					top.$.publish("ordIndex",{testData:"hello"});
    					window.parent.jBox.close();
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
		<div
		style="  text-align: center; padding-top:20px;">
		<span style="font-size: 15px;">${status }</span>
	</div>
	
	<div class="fixed-btn-right" >
	    <input type="button" id="cancel" class="btn btn-primary" style="background-color:#FF6347 "  value="取消"/>&nbsp;
		<input type="button" id="submitBtn" class="btn btn-primary"  value="确 认" />&nbsp;&nbsp;&nbsp;&nbsp;
	</div>
</body>
</html>