<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@page import="com.jinchuan.pms.cyms.modules.setting.entity.CtTableType"%>
<html>
<head>
<title>桌型设置</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
	$(document).ready(
			function() {
				//事件名称保持唯一，这里直接用tabId
				var eventName = "ctTableTypeList";
				//解绑事件
				top.$.unsubscribe(eventName);
				//注册事件，弹出页面需要刷新本页面，或者弹出页面回传数据用
				top.$.subscribe(eventName, function(e, data) {
					//data  可以通过这个对象来回传数据
					$("#searchForm").submit();
				});

				//新增
				$("#addBtn").bind(
						"click",
						function() {
							top.$.jBox.open("iframe:${ctx}/setting/tableTyple/form?eventName="
													+ eventName, "新增台型设置",
											1000,
											$(top.document).height() - 180, {
												buttons : {},
												loaded : function(h) {
													$(".jbox-content",
															top.document).css(
															"overflow-y",
															"hidden");
												}
											});
						});

				//修改
				$("#contentTable a.update").click(
						function(e) {
							var id = $(this).data("id");
							top.$.jBox.open("iframe:${ctx}/setting/tableTyple/toEditCtTableTypeForm?eventName="
													+ eventName + "&id=" + id,
											"桌型编辑", 1000, $(top.document)
													.height() - 180, {
												buttons : {},
												loaded : function(h) {
													$(".jbox-content",
															top.document).css(
															"overflow-y",
															"hidden");
												}
											});
						});

			});

	function page(n, s) {
		$("#pageNo").val(n);
		$("#pageSize").val(s);
		$("#searchForm").submit();
		return false;
	}
	
	//删除
	function del(id){
 		jBox.confirm("确认要删除该桌型吗？","删除提示", function (v) {
         if (v) {
			$.ajax({
				type: "post",
				dataType: "json",  
			    url: "${ctx}/setting/tableTyple/delete?id="+id,
			    success: function (result) {
			    	if(result.retCode=="999999"){
			    		$.jBox.info(result.retMsg);
			    		return false;
			    	}
					if(result.retCode=="000000"){
						window.location.reload();
			    	}
					if(result.retCode=="111111"){
			    		$.jBox.info("该台型下已设置桌台，不允许删除!");
			    		return false;
			    	}
			    },
			    error: function (result, status) {
			    	alert("系统错误");
				}
			});
         }
   		}, {showScrolling: false, buttons: {'是': true, '否': false}});
	}
	
</script>
</head>
<body>
<form:form id="searchForm" method="post" class="breadcrumb form-search"></form:form>
	<table id="contentTable"
		class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>台型编号</th>
				<th>桌型名称</th>
				<th>否收取服务费</th>
				<th>服务费率</th>
				<th>操作</th>

			</tr>
		</thead>
		<tbody>
			<c:forEach items="${ctTableTypeList}" var="CtTableType"
				varStatus="status">
				<tr>
					<td>${CtTableType.code}</td>
					<td>${CtTableType.name}</td>

					<td><c:choose>
						<c:when test="${ CtTableType.isServiceRate eq '0'}">
							否
						</c:when>
						<c:otherwise>
							是
						</c:otherwise>
						</c:choose></td>
					<td>${CtTableType.serviceRate}%</td>
					<td>
					<shiro:hasPermission name="table:ctTableType:edit">
					<a class="update" data-id="${CtTableType.id}">修改</a> 
					<a class="delete" data-id="${CtTableType.id}" data-name="${cardType.name}" onclick="del('${CtTableType.id}')">删除</a>
					</shiro:hasPermission>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<shiro:hasPermission name="table:ctTableType:edit">
	<div class="fixed-btn"><input type="button" id="addBtn" class="btn btn-primary"  value="新增"/></div>
	</shiro:hasPermission>
</body>
</html>