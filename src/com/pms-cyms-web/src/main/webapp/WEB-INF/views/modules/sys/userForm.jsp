<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>用户管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		/* $(document).ready(function() {
			$("#no").focus();
			$("#inputForm").validate({
				rules: {
					loginName: {remote: "${ctx}/sys/user/checkLoginName?oldLoginName=" + encodeURIComponent('${user.mobile}')}
				},
				messages: {
					loginName: {remote: "用户登录名已存在"}
					/*confirmNewPassword: {equalTo: "输入与上面相同的密码"}*/
				/* },  */
				/*  submitHandler: function(form){
                    var tel = $('#mobile').val();
                    var flag = $('#loginFlag').val();
                    if(flag == '1' && tel == ''){
                    	$.jBox.alert("允许登录的用户，手机号码必填");
                        return;
                    }
                    if(flag == '1' && tel != ''){
                        $('#loginName').val(tel);
                    }
                    if(flag == '0'){
                        $('#loginName').val('');
                    }
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
		}); */
		
		$(document).ready(function() {
		    var tpl = $("#treeTableTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
			var data1 = ${list}, rootId = "${roleId}";
			addRow("#treeTableList", tpl, data1, rootId, true);
		})
		
		
		function addRow(list, tpl, data1, pid, root){
			for (var i=0; i<data1.length; i++){
				var row = data1[i];
					if ((${fns:jsGetVal('row.parentId')}) == pid){
						$(list).append(Mustache.render(tpl, {row:row,
							graphBtn:function(){
								var roleId=${selectId};
						        if(row.id ==roleId){
						            return true;  
						        }  
						        return false;  
						    }
						
						}));
						addRow(list, tpl, data1, row.id);
					}
			}
		}
		
		//保存
		  function save(){
              var no = $('#no').val();
              var name = $('#name').val();
              if(no == null || no == ''){
            	  $.jBox.alert("请输入工号");
                    return;
              }
              if(name == null || name == ''){
            	  $.jBox.alert("请输入姓名");
                  return;
              }
              var form = new FormData(document.getElementById("inputForm"));
			$.ajax({
				type : "post",
				url : "${ctx}/sys/user/save",
				async : false,
				data : form,
				processData : false,
				contentType : false,
				success : function(result) {
					if (result.retCode == "000000") {
						top.$.publish("${param.eventName}", {
							testData : "hello"
						});
						window.parent.jBox.close();
					} else if (result.retCode == "111111") {
						$.jBox.alert(result.retMsg);
					} else {
						$.jBox.alert(result.retMsg);
						$('#mobile').val('');
					}
				},
				error : function(result, status) {
					$.jBox.alert("系统错误");
				}
			});
		}
	</script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="user" action="" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<div class="row">
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs">归属组织：</label>
					<div class="controls">
							<form:select id="companyId" path="companyId" class="input-medium">
								<form:options items="${officeList}" itemValue="id" itemLabel="name" htmlEscape="false"/>
							</form:select>
					</div>
				</div>
			</div>
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs" onclick="DD()">所属岗位：</label>
					<div class="controls">
						<select id="treeTableList" name="roleId" class="input-medium">
							<c:forEach items="${list}" var="role">
								 <c:if test="${role.name != '系统管理员' }">
									 <option value="${role.id }" <c:if test="${user.roleId == role.id }"> selected ="selected"</c:if>>${role.name }</option>
								 </c:if> 
							</c:forEach>
						</select>
					</div>
				</div>
			</div>
			<%-- <div class="span">
				<div class="control-group">
					<label class="control-label-xs">在职状态：</label>
					<div class="controls">
						<form:select path="loginFlag" id="loginFlag">
							<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
						
					</div>
				</div>
			</div> --%>
			</div>
			<div class="row">
			<div class="span">
			<div class="control-group">
				<label class="control-label-xs"><span class="help-inline"><font color="red">*</font> </span>工号：</label>
				<div class="controls">
					<form:input path="no" htmlEscape="false" maxlength="50" class="required"/>
				</div>
			</div>
			</div>
			<div class="span">
				<div class="control-group">
				
					<label class="control-label-xs"><span class="help-inline"><font color="red">*</font> </span>姓名：</label>
					<div class="controls">
						<form:input path="name" htmlEscape="false" maxlength="50" class="required"/>
					</div>
				</div>
			</div>
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs">手机：</label>
					<div class="controls">
						<%-- <input id="oldLoginName" name="oldLoginName" type="hidden" value="${user.loginName}"> --%>
						<!-- <input id="loginName" name="loginName" type="hidden"> -->
						<form:input path="mobile" htmlEscape="false" maxlength="100"/>
					</div>
				</div>
			</div>
			<div class="row">
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs">登录账号：</label>
					<div class="controls">
						<input id="oldLoginName" name="oldLoginName" type="hidden" value="${user.loginName}">
						<!-- <input id="loginName" name="loginName" type="hidden"> -->
						<form:input path="loginName" htmlEscape="false" maxlength="100"/>
					</div>
				</div>
			</div>
			
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs">是否业务员：</label>
					<div class="controls">
						<form:select path="isSalesman" id="isSalesman">
							<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
					</div>
				</div>
			</div>
			</div>
			<div class="span">
			<div class="control-group">
				<label class="control-label-xs">备注：</label>
				<div class="controls">
					<form:textarea path="remarks" htmlEscape="false" rows="3" maxlength="100" style="width:586px;"/>
				</div>
			</div>
			</div>
			</div>
			<c:if test="${not empty user.id}">
				<div class="control-group">
					<label class="control-label-xs">创建时间：</label>
					<div class="controls">
						<label class="lbl"><fmt:formatDate value="${user.createDate}" type="both" dateStyle="full"/></label>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label-xs">最后登陆：</label>
					<div class="controls">
						<label class="lbl">IP: ${user.loginIp}&nbsp;&nbsp;&nbsp;&nbsp;时间：<fmt:formatDate value="${user.loginDate}" type="both" dateStyle="full"/></label>
					</div>
				</div>
			</c:if>
			<div class="fixed-btn-right">
				<shiro:hasPermission name="sys:user:edit"><input id="btnSubmit" onclick="save()" type="button" class="btn btn-primary"  value="保 存"/></shiro:hasPermission>
			</div>
	</form:form>
</body>
</html>