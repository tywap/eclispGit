<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>序列管理</title>
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
		});
	</script>
</head>
<body>

	<ul class="nav nav-tabs">
		<li><a href="${ctx}/sys/sequence/">序列列表</a></li>
		<li class="active"><a href="${ctx}/sys/sequence/form?id=${sequence.id}">序列<shiro:hasPermission name="sys:sequence:edit">${not empty sequence.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="sys:sequence:edit">查看</shiro:lacksPermission></a></li>
	</ul>
	<form:form id="inputForm" modelAttribute="sequence" action="${ctx}/sys/sequence/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group">
			<label class="control-label-xs"><span class="notice">*</span>表名：</label>
			<div class="controls">
				<form:input path="tableName" htmlEscape="false" maxlength="32" class="input-xlarge required"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label-xs"><span class="notice">*</span>前缀类型：</label>
			<div class="controls">
				<form:select path="prefixType" class="input-xlarge required">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('prefixType')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>				
			</div>
		</div>
		<div class="control-group">
			<label class="control-label-xs"><span class="notice">*</span>前缀：</label>
			<div class="controls">
				<form:input path="prefix" htmlEscape="false" maxlength="50" class="input-xlarge required"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label-xs"><span class="notice">*</span>日期标志：</label>
			<div class="controls">
				<form:select path="dateFlag" class="input-xlarge required">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label-xs"><span class="notice">*</span>当前序号：</label>
			<div class="controls">
				<form:input path="curId" htmlEscape="false" maxlength="100" class="input-xlarge required number"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label-xs"><span class="notice">*</span>序号长度：</label>
			<div class="controls">
				<form:input path="idLength" htmlEscape="false" maxlength="64" class="input-xlarge required number"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label-xs"><span class="notice">*</span>初始化序号个数：</label>
			<div class="controls">
				<form:input path="blockSize" htmlEscape="false" maxlength="64" class="input-xlarge required number"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label-xs"><span class="notice">*</span>备注信息：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
			</div>
		</div>
		<div class="fixed-btn-right">
			<shiro:hasPermission name="sys:sequence:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>