<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>系统参数</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }
	</script>
</head>
<body>
	<ul class="nav nav-tabs" style="margin-bottom:0;">
		<li class="active"><a href="${ctx}/sys/sysBusiConfig/${type}/list">${typeName}列表</a></li>
		<shiro:hasPermission name="sys:sysBusiConfig:edit"><li><a href="${ctx}/sys/sysBusiConfig/${type}/form">${typeName}添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="sysBusiConfig" action="${ctx}/sys/sysBusiConfig/${type}/list" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li><label>参数名称：</label>
				<form:input path="name" htmlEscape="false" maxlength="100" class="input-medium6"/>
			</li>
			<li class="btns"><button id="btnSubmit" class="btn btn-primary">查询</button></li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>名称</th>
				<th>更新时间</th>
				<th>备注信息</th>
				<shiro:hasPermission name="sys:sysBusiConfig:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="sysBusiConfig">
			<tr>
				<td style="text-align:center;"><a href="${ctx}/sys/sysBusiConfig/${type}/form?id=${sysBusiConfig.id}">
					${sysBusiConfig.name}
				</a></td>
				<td>
					<fmt:formatDate value="${sysBusiConfig.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
					${sysBusiConfig.remarks}
				</td>
				<shiro:hasPermission name="sys:sysBusiConfig:edit"><td>
    				<a href="${ctx}/sys/sysBusiConfig/${type}/form?id=${sysBusiConfig.id}">修改</a>
					<a href="${ctx}/sys/sysBusiConfig/${type}/delete?id=${sysBusiConfig.id}" onclick="return confirmx('确认要删除该${typeName}吗？', this.href)">删除</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>