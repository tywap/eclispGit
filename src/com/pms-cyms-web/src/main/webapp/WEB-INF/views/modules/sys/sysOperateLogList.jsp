<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>日志管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
	    	return false;
	    }
		
		function openDetail(type,id,remarks){
			top.$.jBox.open(
					"iframe:${ctx}/sys/operateLog/detail?logId="+id+"&type="+type+"&remarks="+remarks, 
					"查看日志详情",
					1000, 
					$(top.document).height()-180,
					{
						buttons:{},
			            loaded:function(h){
			                $(".jbox-content", top.document).css("overflow-y","hidden");
			            }
		            }
				);
		}
	</script>
</head>
<body>
	<form id="searchForm" modelAttribute="sysLog" action="${ctx}/sys/operateLog" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<div>
			<label>数据类型：</label>
			<select id="dataType" name="dataType" class="select-medium6">
					<option value="" >全部</option>
				<c:forEach items="${dataTypeList}" var="dataType">
					<option value="${dataType.id}" <c:if test="${dataType.id==sysLog.dataType}">selected="selected"</c:if> >${dataType.name}</option>
				</c:forEach>
			</select>
			<label>操作类型：</label>
			<select id="operateType" name="operateType" class="select-medium6">
					<option value="">全部</option>
				<c:forEach items="${operatTypeList}" var="operateType">
					<option value="${operateType.id}"  <c:if test="${operateType.id==sysLog.operateType}">selected="selected"</c:if> >${operateType.name}</option>
				</c:forEach>
			</select>
			<label>日期范围：&nbsp;</label>
			<input  id="searchStartDate" name="searchStartDate" type="text"  value="${sysLog.searchStartDate}" readonly="readonly" maxlength="20" class="input-medium6 Wdate "
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});"/>
			<label>&nbsp;--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
			<input  id="searchEndDate" name="searchEndDate" type="text"  value="${sysLog.searchEndDate}" readonly="readonly" maxlength="20" class="input-medium6 Wdate "
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});"/>
			&nbsp;&nbsp;&nbsp;<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>&nbsp;&nbsp;
		</div>
	</form>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead><tr><th>序号</th><th>业务功能</th><th>操作类型</th><th>操作内容</th><th>归属组织</th><th>操作人</th><th>操作时间</th><th>操作内容</th></thead>
		<tbody><%request.setAttribute("strEnter", "\n");request.setAttribute("strTab", "\t");%>
		<c:forEach items="${page.list}" var="sysOperateLog" varStatus="status">
			<tr>
				<td>${status.index + 1 }</td>
				<td>${dataViewMap[sysOperateLog.dataType]}</td>
				<td>${operateViewMap[sysOperateLog.operateType]}</td>
				<td>${sysOperateLog.extend}</td>
				<td><strong>${sysOperateLog.createBy.id}</strong></td>
				<td><strong>${sysOperateLog.createBy.name}</strong></td>
				<td><fmt:formatDate value="${sysOperateLog.createDate}" type="both"/></td>
				<td>
				<c:if test="${!empty sysOperateLog.remarks}">
					<a onclick="openDetail('${sysOperateLog.dataType}','${sysOperateLog.id}','${sysOperateLog.remarks}')">查看详情</a>
				</c:if>
				</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>