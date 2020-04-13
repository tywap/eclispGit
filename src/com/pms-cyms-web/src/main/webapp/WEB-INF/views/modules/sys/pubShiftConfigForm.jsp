<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>班次配置管理</title>
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
					    url: "${ctx}/sys/pubShiftConfig/save",
					    async:false,
					    data:$('#inputForm').serialize(),
					    success: function (result) {
					    	if(result.retCode=="000000"){
					    		top.$.publish("${param.eventName}",{});
						    	window.parent.jBox.close();
					    	}else{
					    		$.jBox.alert(result.retMsg);
					    	}
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
		<li><a href="${ctx}/sys/pubShiftConfig/">班次配置列表</a></li>
		<li class="active"><a href="${ctx}/sys/pubShiftConfig/form?id=${pubShiftConfig.id}">班次配置<shiro:hasPermission name="sys:pubShiftConfig:edit">${not empty pubShiftConfig.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="sys:pubShiftConfig:edit">查看</shiro:lacksPermission></a></li>
	</ul> --%>
	<form:form id="inputForm" modelAttribute="pubShiftConfig" method="post" class="form-horizontal" onsubmit="return validate()">
		<sys:message content="${message}"/>	
		<form:hidden path="id"/>
		<div class="row">
			<div class="span"  >
				<div class="control-group">
					<label class="control-label-xs"><span class="notice">*</span>班次名称：</label>
					<div class="controls">
						<form:input path="shiftName" id="shiftName" htmlEscape="false" maxlength="10" class="input-xlarge "/>
					</div>
				</div>
		    </div>
		    
		    <div class="span"  >
				<div class="control-group">
					<label class="control-label-xs"><span class="notice">*</span>开始时间：</label>
					<div class="controls">
						<form:input path="beginTime" id="beginTime" htmlEscape="false" maxlength="10" class="input-xlarge " onclick="WdatePicker({dateFmt:'HH:mm',isShowClear:false});"/>
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="span"  >
				<div class="control-group">
					<label class="control-label-xs">备注信息：</label>
					<div class="controls">
						<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="input-xxlarge "/>
					</div>
				</div>
			</div>
		</div>
		<div class="fixed-btn-right">
			<input id="btnSubmit" class="btn btn-primary" type="button" value="保 存"/>
		</div>
		
	</form:form>
</body>
</html>