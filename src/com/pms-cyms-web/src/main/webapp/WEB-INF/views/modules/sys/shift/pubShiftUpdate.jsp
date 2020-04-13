<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>班次编辑</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			$("#inputForm").validate({
				submitHandler: function(form){
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});
			
			//提交
			$("#btnbutton").bind("click",function(){
				$.ajax({
					type: "post",
					dataType: "json",  
				    url: "${ctx}/bc/pubShift/saveShift",
				    async:false,
				    data:$('#inputForm').serialize(),
				    success: function (result) {
				    	top.$.publish("${param.eventName}",{testData:"hello"});
				    	window.parent.jBox.close();
				    },
				    error: function (result, status) {
				    	$.jBox.info("系统错误");
					}
				});
			});
		});
	</script>
</head>
<body>
	<br/>
	<form:form id="inputForm" modelAttribute="pubShift" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group">
			<label class="control-label">班次名称：</label>
			<div class="controls">
				<form:input path="shiftName" htmlEscape="false" maxlength="10" class="input-xlarge "/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">班次开始时间：</label>
			<div class="controls">
				<form:input path="beginTime" htmlEscape="false" maxlength="10" class="input-xlarge "/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<%-- <div class="control-group">
			<label class="control-label">班次交班时间：</label>
			<div class="controls">
				<form:input path="endTime" htmlEscape="false" maxlength="10" class="input-xlarge "/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div> --%>
		<div class="control-group">
			<label class="control-label">备注信息：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
			</div>
		</div>
		<div class="form-actions">
			<input id="btnbutton" class="btn btn-primary" type="button" value="保 存"/>
			<!-- <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/> -->
		</div>
	</form:form>
</body>
</html>