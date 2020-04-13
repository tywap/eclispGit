<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>做法设置</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
	$(document).ready(function() {
		//解绑事件
		var eventName = "modusSetting";
		top.$.unsubscribe(eventName);
		//注册事件，弹出页面需要刷新本页面，或者弹出页面回传数据用
		top.$.subscribe(eventName, function(e, data) {
			if (data.testData = "hello") {
				window.location.reload();
			}
		});

		//做法类别新增
		$("#typetable a.add").bind("click", function() {
			top.$.jBox.open("iframe:${ctx}/setting/modusSetting/typeForm", "做法类别新增", 1000, $(top.document).height() - 180, {
				buttons : {},
				loaded : function(h) {
					$(".jbox-content", top.document).css("overflow-y", "hidden");
				}
			});
		});

		//做法新增
		$("#btnAdd").bind("click", function() {
			top.$.jBox.open("iframe:${ctx}/setting/modusSetting/form", "做法新增", 1000, $(top.document).height() - 180, {
				buttons : {},
				loaded : function(h) {
					$(".jbox-content", top.document).css("overflow-y", "hidden");
				}
			});
		});

		//做法修改
		$("#contentTable a.update").click(function(e) {
			var id = $(this).data("id");
			top.$.jBox.open("iframe:${ctx}/setting/modusSetting/form?&id=" + id, 
				"做法类别编辑", 
				1000, $(top.document).height() - 180, {
				buttons : {},
				loaded : function(h) {
					$(".jbox-content", top.document).css("overflow-y", "hidden");
				}
			});
		});

		//做法类别修改
		$("#typetable a.update").click(function(e) {
			var id = $(this).data("id");
			top.$.jBox.open("iframe:${ctx}/setting/modusSetting/typeForm?id=" + id, 
				"做法编辑", 
				1000, $(top.document).height() - 180, {
				buttons : {},
				loaded : function(h) {
					$(".jbox-content", top.document).css("overflow-y", "hidden");
				}
			});
		});

		//做法删除
		$("#contentTable a.delete").click(function(e) {
			var id = $(this).data("id");
			var name = $(this).data("name");
			var params = {
				id : id
			};
			loadAjax("${ctx}/setting/modusSetting/delete", params, function(result) {
				if (result.retCode == "000000") {
					layer.confirm("删除" + name + "做法成功！", {
						btn : [ '确定' ]
					}, function() {
						window.location.reload();
					});
				} else {
					layer.alert(result.retMsg);
					window.location.reload();
				}
			});
		});

		//做法类型删除
		$("#typetable a.delete").click(function(e) {
			var id = $(this).data("id");
			var name = $(this).data("name");
			var params = {
				id : id
			};
			loadAjax("${ctx}/setting/modusSetting/delete", params, function(result) {
				if (result.retCode == "000000") {
					layer.confirm("删除" + name + "做法类型以及子类做法成功！", {
						btn : [ '确定' ]
					}, function() {
						window.location.reload();
					});
				} else {
					layer.alert(result.retMsg);
					window.location.reload();
				}
			});
		});

	});
	
</script>
</head>
<body>
	<sys:message content="${message}" />
	<div style="margin-top:20px;">
		<table id="typetable"
			class="table table-striped table-bordered table-condensed"
			style="width: 30%; float: left; margin-right: 1%;">
			<thead>
				<tr align="center">
					<th colspan="4">做法类别</th>
				</tr>
			</thead>
			<tbody>
				<tr>
				<td align="center"><a href="${ctx}/setting/modusSetting/list">全部</a></td>
				<td></td>
				</tr>
				<c:forEach items="${modusList}" var="fee">
					<tr>
						<td align="center" ><a href="${ctx}/setting/modusSetting/list?parentId=${fee.id}">${fee.name}</a></td>
						<td><a class="update" data-id="${fee.id}"><i
								class="icon icon-edit"></i></a> <a class="delete" data-id="${fee.id}"
							data-name="${fee.name }"><i class="icon icon-remove"></i></a>
					</tr>
				</c:forEach>
				<tr style="text-align: center;">
					<td colspan="4" style="text-align: center;"><a class="add"><i
							class="icon icon-plus"></i></a></td>
				</tr>
			</tbody>
		</table>

		<table id="contentTable"
			class="table table-striped table-bordered table-condensed"
			style="width: 67%; float: left";>
			<thead>
				<tr>
				    <th>做法</th>
					<th>做法代码</th>
					<th>做法名称</th>
					<th>操作</th>
				</tr>
			</thead>
			<tbody align="center">
				<c:forEach items="${modusTypeList}" var="scmFee">
				    <td>${scmFee.parentName}</td>
					<td>${scmFee.paramKey}</td>
					<td>${scmFee.name}</td>
					<td><a class="update" data-id="${scmFee.id}">修改</a> <a
						class="delete" data-id="${scmFee.id}" data-name="${scmFee.name }">删除</a>
					</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
	<div class="fixed-btn">
		<input type="button" id="btnAdd" class="btn btn-primary" value="新增做法" />
	</div>
</body>
</html>