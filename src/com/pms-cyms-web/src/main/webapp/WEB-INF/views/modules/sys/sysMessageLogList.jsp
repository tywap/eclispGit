<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>短信记录管理</title>
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
	<form:form id="searchForm" modelAttribute="sysMessageLog" action="${ctx}/sys/sysMessageLog/" method="post" class="breadcrumb form-search">
		<input id="pageIndex" name="pageIndex" type="hidden"/>
		<input id="startPage" name="startPage" type="hidden"/>
		<input id="endPage" name="endPage" type="hidden"/>
		<ul class="ul-form">
			<li>
				<label>发送时间：</label>
				<input name="startDate" value="${startDate}" type="text" readonly="readonly" maxlength="20" style="margin-right:3px;" class="input-medium6 Wdate "
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>-
				<input name="endDate" value="${endDate}" type="text" readonly="readonly" maxlength="20" class="input-medium6 Wdate "
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
			</li>
			<li>
				<label>短信类型：</label>
				<form:select path="messageType" class="select-medium6">
					<form:option value="" label="--请选择--"/>
					<form:options items="${fns:getDictList('messageType')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li>
				<label>手机号：</label>
				<form:input path="phone" htmlEscape="false" maxlength="11" class="input-medium6"/>
			</li>
			<li class="btns">
				<button id="btnSubmit" class="btn btn-primary">查询</button>
			</li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>手机号</th>
				<th>短信类型</th>
				<th>内容</th>
				<th>响应</th>
				<th>发送时间</th>
				<shiro:hasPermission name="message:sysMessageLog:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${sysMessageLogs}" var="sysMessageLog">
			<tr>
				<td>
					<c:choose>
						<c:when test="${fn:length(sysMessageLog.phone)>35}">
							<a title="${sysMessageLog.phone}">${fn:substring(sysMessageLog.phone, 0, 36)}...</a>						
						</c:when>
						<c:otherwise>
							<a title="${sysMessageLog.phone}">${sysMessageLog.phone}</a>
						</c:otherwise>
					</c:choose>
				</td>
				<td>
					${fns:getDictLabel(sysMessageLog.messageType, 'messageType', '')}
				</td>
				<td>
					${sysMessageLog.content}
				</td>
				<td>
					${sysMessageLog.replay}
				</td>
				<td>
					<fmt:formatDate value="${sysMessageLog.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<!-- 自定义分页控件 -->
	<jsp:include page="../common/common_page.jsp"></jsp:include>
</body>
</html>