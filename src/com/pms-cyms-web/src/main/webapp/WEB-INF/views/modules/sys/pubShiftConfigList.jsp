<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>班次配置管理</title>
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
                    "iframe:${ctx}/sys/pubShiftConfig/form?eventName="+eventName,
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
          	  var id = $(this).data("id");
             	  top.$.jBox.open(
                    "iframe:${ctx}/sys/pubShiftConfig/updatePubShiftConfig?id="+id+"&eventName="+eventName,
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
		<li class="active"><a href="${ctx}/sys/pubShiftConfig/">班次配置列表</a></li>
		<%-- <shiro:hasPermission name="sys:pubShiftConfig:edit"><li><a href="${ctx}/sys/pubShiftConfig/form">班次配置添加</a></li></shiro:hasPermission> --%>
	</ul> 
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
			<tr>
				<th>状态</th>
				<th>班次名称</th>
				<th>上班时间</th>
				<!-- <th>下班时间</th> -->
				<th>操作</th>
			</tr>
			<c:forEach items="${page.list}" var="type">
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
						<shiro:hasPermission name="sys:pubShiftConfig:edit"><a class="update" data-id="${type.id}">编辑</a>&nbsp;&nbsp;&nbsp;
						<c:choose>  
						   <c:when test="${type.status == 1}">
						   		<a href="${ctx}/sys/pubShiftConfig/delete?id=${type.id}&status=0" onclick="return confirmx('确认要停用该班次吗？', this.href)">停用</a>
						   </c:when>  
						   <c:otherwise>  
						   		<a href="${ctx}/sys/pubShiftConfig/delete?id=${type.id}&status=1" onclick="return confirmx('确认要启用该班次吗？', this.href)">启用</a>
						   </c:otherwise>  
						</c:choose></shiro:hasPermission>
					</td>
				</tr>
			</c:forEach>
	</table>
	<div class="fixed-btn">
		<shiro:hasPermission name="sys:pubShiftConfig:edit"><button class="btn btn-primary" id="addBtn" >新增</button></shiro:hasPermission>
	</div>
	<div class="pagination">${page}</div>
</body>
</html>