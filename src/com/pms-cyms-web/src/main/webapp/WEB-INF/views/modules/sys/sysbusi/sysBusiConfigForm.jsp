<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>系统参数配置管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			

			getparent();
			
			
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
		
		function getparent()
		{
			if($("#paramKey").val()=="")
				{
				return;
				}
			if($("#storeId").val()=="")
				{
				return;
				}
			$.ajax({
	               url:"${ctx}/sys/sysBusiConfig/getParent",
	               type: "post",
	               dataType: "json",
	               data: {
	            	   type:$("#paramKey").val(),
	            	   storeId:$("#storeId").val(),
	               },
	               success: function (result) {
	            	   if(result==null || result.length==0)
	            		   return;
	            	$("#parentId").empty();
	            	$("#parentId").select2('val','');
	            	var htm="<option value=''>无</option>";
	            	
		        	for(var i=0;i<result.length;i++)
	        		{
	        			htm+="<option value='"+result[i].id+"'>"+result[i].name+"</option>";
	        		}
	        	$("#parentId").append(htm);
	        	if("${parentId}"!="")
	        		$("#parentId").select2('val','${parentId}');
		      	}
			});
		}
		
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/sys/sysBusiConfig/">系统参数配置列表</a></li>
		<li class="active"><a href="${ctx}/sys/sysBusiConfig/form?id=${sysBusiConfig.id}">系统参数配置<shiro:hasPermission name="sys:sysBusiConfig:edit">${not empty sysBusiConfig.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="sys:sysBusiConfig:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="sysBusiConfig" action="${ctx}/sys/sysBusiConfig/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="control-group">
			<label class="control-label">关键字：</label>
			<div class="controls">
				<form:input path="paramKey" id="paramKey" htmlEscape="false" maxlength="50" class="input-xlarge required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">数据值：</label>
			<div class="controls">
				<form:input path="paramValue" htmlEscape="false" maxlength="100" class="input-xlarge required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">参数名称：</label>
			<div class="controls">
				<form:input path="name" htmlEscape="false" maxlength="100" class="input-xlarge required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">类型：</label>
			<div class="controls">
				<form:input path="type" htmlEscape="false" maxlength="100" class="input-xlarge required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label" >分店编号：</label>
			<div class="controls">
				<form:input path="storeId" htmlEscape="false" id="storeId"  maxlength="64" class="input-xlarge required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">描述：</label>
			<div class="controls">
				<form:input path="description" htmlEscape="false" maxlength="100" class="input-xlarge required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">扩展字段：</label>
			<div class="controls">
				<form:input path="extend" htmlEscape="false" maxlength="200" class="input-xlarge "/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">排序（升序）：</label>
			<div class="controls">
				<form:input path="sort" htmlEscape="false" class="input-xlarge required"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">父级编号：</label>
			<div class="controls" >
				<form:select path="parentId" id="parentId"  class="input-medium">
				</form:select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">备注信息：</label>
			<div class="controls">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
			</div>
		</div>
		<div class="form-actions">
			<shiro:hasPermission name="sys:sysBusiConfig:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form:form>
</body>
</html>