<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>支付方式编辑</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		var editFlag = '${param.editFlag}';
		$(document).ready(function() {
			//保存
			$("#submitBtn").click(function(){
				submitBtn();
			});
		});
		
		//保存
		function submitBtn(){
			if (!$("#inputForm").valid()){
		        return;
		    }
			var params = $('#inputForm').serialize()+"&editFlag="+editFlag;
			loadAjax("${ctx}/sys/sysBusiConfig/savePayWayConfig",params,function(result){
				if(result.retCode=="000000"){
		    		top.$.publish("${param.eventName}",{testData:"hello"});
			    	window.parent.jBox.close();
		    	}else{
		    		$.jBox.alert(result.retMsg);
		    	}
			});
		}
	</script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="sysBusiConfig" action="" method="post" class="form-horizontal">
		<input type="hidden" name="id" value="${param.id}" />
		<input type="hidden" name="type" value="${param.type}" />
	    <div class="row">
			<div class="span">	
				<div class="control-group">
					<label class="control-label-xs">支付方式：</label>
					<div class="controls">
						<form:input path="name" htmlEscape="false" maxlength="64" class="input-medium6 required"/>
					</div>
				</div>
			</div>
		</div>
		<div class="fixed-btn-right">
			<input id="submitBtn" class="btn btn-primary" type="button" value="保 存"/>
		</div>
	</form:form>
</body>
</html>