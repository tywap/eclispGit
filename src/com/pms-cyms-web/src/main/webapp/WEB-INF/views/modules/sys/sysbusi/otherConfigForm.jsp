<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>系统参数管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
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
		});
		
	</script>
</head>
<body>
	
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/sys/sysBusiConfig/${type}/list">${typeName}列表</a></li>
		<li class="active"><a href="${ctx}/sys/sysBusiConfig/${type}/form?id=${sysBusiConfig.id}">${typeName}添加<shiro:hasPermission name="sys:sysBusiConfig:edit">${not empty sysBusiConfig.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="sys:sysBusiConfig:edit">查看</shiro:lacksPermission></a></li>
	</ul>
	<form:form id="inputForm" modelAttribute="sysBusiConfig" action="${ctx}/sys/sysBusiConfig/${type}/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group">
			<label class="control-label-xs"><span class="notice">*</span>名称：</label>
			<div class="controls">
				<form:input path="name" htmlEscape="false" maxlength="100" class="input-xlarge required"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label-xs">描述：</label>
			<div class="controls">
				<form:input path="description" htmlEscape="false" maxlength="100" class="input-xlarge"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label-xs">排序(升序)：</label>
			<div class="controls">
				<form:input path="sort" htmlEscape="false" class="input-xlarge"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label-xs">备注信息：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
			</div>
		</div>
		<div class="fixed-btn-right">
			<shiro:hasPermission name="sys:sysBusiConfig:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>