<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>序列管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//预览序列
			$("#contentTable a.preview").click(function(e){
				var id = $(this).data("id");
	            $.ajax({
	                type: "post",
	                dataType: "json",
	                url: "${ctx}/sys/sequence/preview",
	                async:false,
	                data:{
	                	id:id
	                },
	                success: function (result) {
	                	if(result.retCode=="000000"){
	                		$.jBox.alert("序列="+result.ret.seq);
	                	}else{
	                		$.jBox.alert(result.retMsg);	                		
	                	}
	                },
	                error: function (result, status) {
	                    alert("系统错误");
	                }
	            });
			});
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
		<li class="active"><a href="${ctx}/sys/sequence/">序列列表</a></li>
		<shiro:hasPermission name="sys:sequence:edit"><li><a href="${ctx}/sys/sequence/form">序列添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="sequence" action="${ctx}/sys/sequence/" method="post" style="margin-bottom:0;" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li><label>表名：</label>
				<form:input path="tableName" htmlEscape="false" maxlength="32" class="input-medium6"/>
			</li>
			<li class="btns"><button id="btnSubmit" class="btn btn-primary">查询</button></li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>表名</th>
				<th>前缀类型</th>
				<th>前缀</th>
				<th>日期标志</th>
				<th>当前序号</th>
				<th>序号长度</th>
				<th>初始化序号个数</th>
				<th>更新时间</th>
				<th>备注信息</th>
				<shiro:hasPermission name="sys:sequence:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="sequence">
			<tr>
				<td><a href="${ctx}/sys/sequence/form?id=${sequence.id}">
					${sequence.tableName}
				</a></td>
				<td>
					${fns:getDictLabel(sequence.prefixType, 'prefixType', '')}
				</td>
				<td>
					${sequence.prefix}
				</td>
				<td>
					${fns:getDictLabel(sequence.dateFlag, 'yes_no', '')}
				</td>
				<td>
					${sequence.curId}
				</td>
				<td>
					${sequence.idLength}
				</td>
				<td>
					${sequence.blockSize}
				</td>
				<td>
					<fmt:formatDate value="${sequence.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
					${sequence.remarks}
				</td>
				<shiro:hasPermission name="sys:sequence:edit"><td>
    				<a href="${ctx}/sys/sequence/form?id=${sequence.id}">修改</a>
					<a href="${ctx}/sys/sequence/delete?id=${sequence.id}" onclick="return confirmx('确认要删除该序列吗？', this.href)">删除</a>
					<a class="preview" data-id="${sequence.id}">
						预览
					</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>