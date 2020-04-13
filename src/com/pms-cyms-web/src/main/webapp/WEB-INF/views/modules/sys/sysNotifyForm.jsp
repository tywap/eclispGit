<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>系统提醒管理</title>
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
				//表单校验
				if (!$("#inputForm").valid()){
			        return;
			    }
				//表单
				var params = $('#inputForm').serialize();
				loadAjax("${ctx}/sys/sysNotify/save",params,function(result){
					if(result.retCode=="000000"){
						top.$.publish("${param.eventName}",{testData:"hello"});
				    	window.parent.jBox.close();
		    	    }else{
		    			$.jBox.alert(result.retMsg);
		    	    }
				});
			});
			
			//关闭
			$("#closeBtn").bind("click",function(){
				window.parent.jBox.close();
			});
			
			init();
		});
		function init(){
			var rolesStr = '${sysNotify.roles}';
			if(rolesStr!=undefined && rolesStr!='' && rolesStr!=null){
				var roles = rolesStr.split(",");
				for(var i=0;i<roles.length;i++){
					$("input[name='roles'][value='"+roles[i]+"']").attr("checked","checked");
				}
			}
		}
	</script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="sysNotify" action="${ctx}/sys/sysNotify/save" method="post" class="form-horizontal">
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
							<label class="control-label-xs"><span class="notice">*</span>提醒类型：</label>
							<div class="controls">
								<form:select path="notifyType" class="select-medium4 required">
									<form:option value="">--请选择--</form:option>
									<form:option value="1">店内公告</form:option>
									<form:option value="2">住客提醒</form:option>
								</form:select>
								<font color="red">*公告只会显示给所有能登录系统的人员</font>
							</div>
						</div>
					</div>
				</div>	
				<div class="row">
					<div class="span12">
						<div class="control-group">
							<label class="control-label-xs"><span class="notice">*</span>通知岗位：</label>
							<div class="controls">
								<form:checkboxes id="roles" path="roles" items="${allRoles}" itemLabel="name" itemValue="id" htmlEscape="false" class="required"/>
							</div>
						</div>
					</div>
				</div>	
				<div class="row">
					<div class="span12">
						<div class="control-group">
							<label class="control-label-xs"><span class="notice">*</span>提醒时间：</label>
							<div class="controls">
								<input name="notifyDate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate required"
									value="<fmt:formatDate value="${sysNotify.notifyDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
									onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
							</div>
						</div>
					</div>
				</div>	
				<div class="row">	
					<div class="span12">
						<div class="control-group">
							<label class="control-label-xs"><span class="notice">*</span>内容：</label>
							<div class="controls">
								<form:textarea path="content" htmlEscape="false" rows="4" maxlength="4000" class="input-xxlarge required"/>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>	
		<div class="fixed-btn-right">
			<shiro:hasPermission name="member:cmGroup:edit">
				<input id="submitBtn" class="btn btn-primary" type="button" value="保 存"/>&nbsp;
			</shiro:hasPermission>
			<!-- <input id="closeBtn" class="btn btn-primary" type="button" value="关闭"/> -->
		</div>
	</form:form>
</body>
</html>