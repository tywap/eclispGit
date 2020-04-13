<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>日志管理</title>
	<meta name="decorator" content="default"/>

</head>
<body>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead><tr><th>名称</th><th>内容</th></thead>
		<tbody>
		<c:forEach items="${detailMap}" var="log" varStatus="status">
			<tr>
				<td>${log.key}</td>
				<td>${log.value}</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
</body>
</html>