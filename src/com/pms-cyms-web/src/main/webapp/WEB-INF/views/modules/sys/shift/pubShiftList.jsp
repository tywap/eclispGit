<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>班次管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//事件名称保持唯一，这里直接用tabId
            var eventName="${param.tabPageId}";
            //解绑事件
            top.$.unsubscribe(eventName);
            //注册事件，弹出页面需要刷新本页面，或者弹出页面回传数据用
            top.$.subscribe(eventName, function (e, data) {
                //data  可以通过这个对象来回传数据
                $("#searchForm").submit();
            });
            
			//新增
            $("#addBtn").click(function () {
                top.$.jBox.open(
                    "iframe:${ctx}/bc/pubShift/form?eventName="+eventName,
                    "班次新增",
                    1000,
                    $(top.document).height() - 180,
                    {
                        buttons: {},
                        loaded: function (h) {
                            $(".jbox-content", top.document).css("overflow-y", "hidden");
                        }
                    }
                );
            });
			
          //修改
          $("#contentTable a.update").click(function (e) {
        	  var uid = $(this).data("id");
           	  top.$.jBox.open(
                  "iframe:${ctx}/bc/pubShift/updatebc?uid="+uid+"&eventName="+eventName,
                  "班次编辑",
                  1000,
                  $(top.document).height() - 180,
                  {
                      buttons: {},
                      loaded: function (h) {
                          $(".jbox-content", top.document).css("overflow-y", "hidden");
                      }
                  }
              );
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
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/bc/pubShift/">班次列表</a></li>
		<%-- <shiro:hasPermission name="bc:pubShift:edit"><li><a href="${ctx}/bc/pubShift/form">班次添加</a></li></shiro:hasPermission> --%>
	</ul>
	<form:form id="searchForm" modelAttribute="pubShift" action="${ctx}/bc/pubShift/" method="post" class="breadcrumb form-search">
		<input id="tabPageId" name="tabPageId" type="hidden" value="${param.tabPageId}"/>   
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li class="btns"><!-- <input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/> --></li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
			<tr>
				<th>状态</th>
				<th>班次名称</th>
				<th>上班时间</th>
				<!-- <th>下班时间</th> -->
				<th>操作</th>
			</tr>
			<c:forEach items="${pubShiftList}" var="type">
				<tr style="text-align:center">
					<td>
						<c:choose>  
						   <c:when test="${type.status == 1}">
						   		启用
						   </c:when>  
						   <c:otherwise>  
						   		停用
						   </c:otherwise>  
						</c:choose>
					</td>
					<td>${type.shiftName}</td>
					<td>${type.beginTime}</td>
					<%-- <td>${type.endTime}</td> --%>
					<td>
						<a href="#" class="update" data-id="${type.id}">编辑</a>&nbsp;&nbsp;&nbsp;
						<c:choose>  
						   <c:when test="${type.status == 1}">
						   		<a href="${ctx}/bc/pubShift/upbc?bcid=${type.id}&status=0" onclick="return confirmx('确认要停用该班次吗？', this.href)">停用</a>
						   </c:when>  
						   <c:otherwise>  
						   		<a href="${ctx}/bc/pubShift/upbc?bcid=${type.id}&status=1" onclick="return confirmx('确认要启用该班次吗？', this.href)">启用</a>
						   </c:otherwise>  
						</c:choose>
					</td>
				</tr>
			</c:forEach>
	</table>
	<div class="fixed-btn">
		<button class="btn btn-primary" id="addBtn" >新增</button>
	</div>
	<sys:message content="${message}"/>
	<%-- <table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>更新时间</th>
				<th>备注信息</th>
				<shiro:hasPermission name="bc:pubShift:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="pubShift">
			<tr>
				<td><a href="${ctx}/bc/pubShift/form?id=${pubShift.id}">
					<fmt:formatDate value="${pubShift.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</a></td>
				<td>
					${pubShift.remarks}
				</td>
				<shiro:hasPermission name="bc:pubShift:edit"><td>
    				<a href="${ctx}/bc/pubShift/form?id=${pubShift.id}">修改</a>
					<a href="${ctx}/bc/pubShift/delete?id=${pubShift.id}" onclick="return confirmx('确认要删除该班次吗？', this.href)">删除</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table> --%>
	<div class="pagination">${page}</div>
</body>
</html>