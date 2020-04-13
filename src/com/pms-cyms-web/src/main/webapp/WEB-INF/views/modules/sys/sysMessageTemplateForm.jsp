<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>短信模板管理</title>
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
			$("#submitBtn").bind("click",function(){
				if (!$("#inputForm").valid()){
			        return;
			    }
				//表单
				var params = $('#inputForm').serialize();
				$.ajax({
					type: "post",
					dataType: "json",  
				    url: "${ctx}/sys/sysMessageTemplate/save",
				    async:false,
				    data:params,
				    success: function (result) {
				    	if(result.retCode=="000000"){
				    		top.$.publish("${param.eventName}",{testData:"hello"});
					    	window.parent.jBox.close();
				    	}else{
				    		$.jBox.alert(result.retMsg);
				    	}
				    },
				    error: function (result, status) {
				    	alert("系统错误");
					}
				});
			});
			
			//关闭
			$("#closeBtn").bind("click",function(){
				window.parent.jBox.close();
			});
		});
	</script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="sysMessageTemplate" action="${ctx}/sys/sysMessageTemplate/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="panel panel-default">
			<div class="panel-heading">
				<h3 class="panel-title">基础信息</h3>
			</div>
			<div class="panel-body">
				<div class="row">
					<div class="span12">
						<div class="control-group">
							<label class="control-label-xs"><span class="notice">*</span>短信类型：</label>
							<div class="controls">
								<form:select path="type" class="select-medium4 required" disabled="true">
									<option value=''>--请选择--</option>
									<form:options items="${fns:getDictList('messageType')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
								</form:select>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="span12">
						<div class="control-group">
							<label class="control-label-xs"><span class="notice">*</span>状态：</label>
							<div class="controls">
								<form:select path="status" class="select-medium4 required">
									<form:options items="${fns:getDictList('status')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
								</form:select>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="span12">
						<div class="control-group">
							<label class="control-label-xs"><span class="notice">*</span>短信模板：</label>
							<div class="controls">
								<form:textarea path="content" htmlEscape="false" rows="4" maxlength="1000" class="input-xxlarge required"/>
								</br><font color="red">{}内的内容为需要替换的标签，请不要擅自修改</font>
							</div>
						</div>
					</div>	
				</div>
				<!-- <div class="row">
					<div class="span12">
						<div class="control-group">
							<label class="control-label-xs">备注信息：</label>
							<div class="controls">
								<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
							</div>
						</div>
					</div>	 -->
				</div>
			</div>
		</div>
		<div class="fixed-btn-right">
			<shiro:hasPermission name="sys:sysMessageTemplate:edit">
				<input id="submitBtn" class="btn btn-primary" type="button" value="保 存"/>&nbsp;
			</shiro:hasPermission>
			<!-- <input id="closeBtn" class="btn btn-primary" type="button" value="关闭"/> -->
		</div>
	</form:form>
</body>
</html>