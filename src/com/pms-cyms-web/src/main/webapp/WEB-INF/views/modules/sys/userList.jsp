<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>用户管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		//事件名称保持唯一，这里直接用tabId
	    var eventName="${param.tabPageId}";
	  	//解绑事件
        top.$.unsubscribe(eventName);
        //注册事件，弹出页面需要刷新本页面，或者弹出页面回传数据用
        top.$.subscribe(eventName, function (e, data) {
            //data  可以通过这个对象来回传数据
            $("#searchForm").submit();
        });
		$(document).ready(function() {
			$("#btnExport").click(function(){
				top.$.jBox.confirm("确认要导出用户数据吗？","系统提示",function(v,h,f){
					if(v=="ok"){
						$("#searchForm").attr("action","${ctx}/sys/user/export");
						$("#searchForm").submit();
					}
				},{buttonsFocus:1});
				top.$('.jbox-body .jbox-icon').css('top','55px');
			});
			$("#btnImport").click(function(){
				$.jBox($("#importBox").html(), {title:"导入数据", buttons:{"关闭":true}, 
					bottomText:"导入文件不能超过5M，仅允许导入“xls”或“xlsx”格式文件！"});
			});
			var roleId =${roleId};
		});
		function page(n,s){
			if(n) $("#pageNo").val(n);
			if(s) $("#pageSize").val(s);
			$("#searchForm").attr("action","${ctx}/sys/user/list");
			$("#searchForm").submit();
	    	return false;
	    }
        //***************************新增********************************//
        function addUser(){
            top.$.jBox.open(
                "iframe:${ctx}/sys/user/form?eventName="+eventName,
                "新增员工资料",
                750,
                $(top.document).height()-280,
                {
                    buttons:{},
                    loaded:function(h){
                        $(".jbox-content", top.document).css("overflow-y","hidden");
                    }
                }
            );
        }
        
      //*********************************************//
		function editUser(id){
			top.$.jBox.open(
					"iframe:${ctx}/sys/user/form?id="+id+"&eventName="+eventName, 
					"修改员工资料",
					750, 
					$(top.document).height()-180,
					{
						buttons:{},
			            loaded:function(h){
			                $(".jbox-content", top.document).css("overflow-y","hidden");
			            }
		            }
				);
		}
      
      //****************删除员工信息***********************//
      function delUser(id){
          confirmx('确认要删除该用户吗？', "${ctx}/sys/user/delete?id="+id);
          //$("#searchForm").submit();
		}
      
      //****************删除员工信息***********************//
      function resetPwd(id){
    	  confirmx('确认要重置该用户密码吗？', "${ctx}/sys/user/resetPwd?id="+id);
    	 /*  $.jBox.confirm("确认要重置该用户密码吗！", "提示", function (v, h, f) {
  		    if (v == true){
  		    	alert(777);
  		    	$.ajax({
                      url:"${ctx}/sys/user/resetPwd?eventName="+eventName,
                      type: "post",
                      dataType: "json",
                      data: {
                          "id":id
                      },
                      success: function (result) {
                    	  alert(result);
                          if(result.retCode=="000000")
                          {
  		            	   $.jBox.info("密码重置成功");
  		            	   $("#searchForm").submit();
                          }
                          else
                          $.jBox.info("密码重置失败！");
                      }
                  });
  		    }
  		    return true;
  		}, { buttons: { '确定': true}}); */
      }
	</script>
</head>
<body>
	<div id="importBox" class="hide">
		<form id="importForm" action="${ctx}/sys/user/import" method="post" enctype="multipart/form-data"
			class="form-search" style="padding-left:20px;text-align:center;" onsubmit="loading('正在导入，请稍等...');"><br/>
			<input id="uploadFile" name="file" type="file" style="width:330px"/><br/><br/>　　
			<input id="btnImportSubmit" class="btn btn-primary" type="submit" value="   导    入   "/>
			<a href="${ctx}/sys/user/import/template">下载模板</a>
		</form>
	</div>
	<form:form id="searchForm" modelAttribute="user" action="${ctx}/sys/user/list" method="post" class="breadcrumb form-search ">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<sys:tableSort id="orderBy" name="orderBy" value="${page.orderBy}" callback="page();"/>
		<ul class="ul-form">
			<li><label>归属组织：</label>
				<form:select id="companyId" path="companyId" class="select-medium6 select2">
					<form:option value="" >全部</form:option><form:options items="${officeList}" itemValue="id" itemLabel="name" htmlEscape="false"/>
				</form:select>
			</li>
			<li><label>登录名：</label><form:input path="loginName" htmlEscape="false" maxlength="50" class="input-medium6"/></li>
			<li><label>归属岗位：</label>
				<form:select id="roleId" path="roleId" class="select-medium6">
					<form:option value="" >全部</form:option><form:options items="${roleList}" itemValue="id" itemLabel="name" htmlEscape="false"/>
				</form:select>
				</li>
			<li><label>姓&nbsp;&nbsp;&nbsp;名：</label><form:input path="name" htmlEscape="false" maxlength="50" class="input-medium6"/></li>
			<li class="btns">
				<button id="btnSubmit" class="btn btn-primary" onclick="return page();">查询</button>
				<!-- <button id="btnExport" class="btn btn-primary">导出</button>
				<button id="btnImport" class="btn btn-primary">导入</button> -->
			</li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead><tr><th>归属组织</th><th>归属岗位</th><th class="sort-column login_name">登录名</th><th class="sort-column name">姓名</th><th>在职状态</th><th>手机</th><th>操作</th></tr></thead>
		<tbody>
		<c:forEach items="${page.list}" var="user">
			<tr>
				<td>${user.company.name}</td>
				<td>${user.roleName}</td>
				<td>${user.loginName}</td>
				<td>${user.name}</td>
				<td>${fns:getDictLabel(user.loginFlag, 'yes_no', '无')}</td>
				<%--<td>${user.loginFlag}</td>--%>
				<td>${user.mobile}</td><%--
				<td>${user.roleNames}</td> --%>
				<c:if test="${user.roleId != roleId}">
					<td>
	    				<a onclick="editUser('${user.id}')" <shiro:lacksPermission name="sys:user:edit">disabled</shiro:lacksPermission>>修改</a>
						<a onclick="delUser('${user.id}')" <shiro:lacksPermission name="sys:user:delete">disabled</shiro:lacksPermission>>删除</a>
						<a onclick="resetPwd('${user.id}')" <shiro:lacksPermission name="sys:user:resetPwd">disabled</shiro:lacksPermission>>密码重置</a>
					</td>
				</c:if>
				<c:if test="${user.roleId == roleId}">
					<td></td>
				</c:if>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
	<div class="fixed-btn">
		<button class="btn btn-primary" id="addBtn" onclick="addUser()" <shiro:lacksPermission name="sys:user:edit">disabled</shiro:lacksPermission>>新增</button>
	</div>
</body>
</html>