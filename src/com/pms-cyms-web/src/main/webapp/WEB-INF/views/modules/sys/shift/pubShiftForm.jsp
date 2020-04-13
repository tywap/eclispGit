<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>班次管理</title>
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
			$("#btnSubmit").bind("click",function(){
				if(validate()){
					$.ajax({
						type: "post",
						dataType: "json",  
					    url: "${ctx}/bc/pubShift/add",
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
				}
			});
		});
		
		function validate(){
			var nameValue=$("#shiftName").val();
			var startValue=$("#beginTime").val();
			/* var endValue=$("#endTime").val(); */
			if(nameValue == ""){
				$.jBox.info("请填写班次名称！");
				return false;
			}
			if(startValue == ""){
				$.jBox.info("请填写开始时间！");
				return false;
			}
			/* if(endValue == ""){
				$.jBox.info("请填写结束时间！");
				return false;
			} */
			return true;
		}
	</script>
</head>
<body>
	<%-- <ul class="nav nav-tabs">
		<li><a href="${ctx}/bc/pubShift/">班次列表</a></li>
		<li class="active"><a href="${ctx}/bc/pubShift/form?id=${pubShift.id}">班次<shiro:hasPermission name="bc:pubShift:edit">${not empty pubShift.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="bc:pubShift:edit">查看</shiro:lacksPermission></a></li>
	</ul> --%><br/>
	<form:form id="inputForm" modelAttribute="pubShift" method="post" class="form-horizontal" onsubmit="return validate()">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group">
			<label class="control-label">班次名称：</label>
			<div class="controls">
				<form:input path="shiftName" id="shiftName" htmlEscape="false" maxlength="10" class="input-xlarge "/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">班次开始时间：</label>
			<div class="controls">
				<form:input path="beginTime" id="beginTime" htmlEscape="false" maxlength="10" class="input-xlarge "/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<%-- <div class="control-group">
			<label class="control-label">班次交班时间：</label>
			<div class="controls">
				<form:input path="endTime" id="endTime" htmlEscape="false" maxlength="10" class="input-xlarge "/>
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
			<input id="btnSubmit" class="btn btn-primary" type="button" value="保 存"/>
			<!-- <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/> -->
		</div>
	</form:form>
</body>
</html>