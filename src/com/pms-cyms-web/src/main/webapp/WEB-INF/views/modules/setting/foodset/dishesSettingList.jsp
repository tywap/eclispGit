<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>菜品设置</title>
<meta name="decorator" content="default" />
<%@include file="/WEB-INF/views/include/treetable.jsp" %>
<script type="text/javascript">
	$(document).ready(function() {
		//解绑事件
		var eventName = "dishesSetting";
		top.$.unsubscribe(eventName);
		//注册事件，弹出页面需要刷新本页面，或者弹出页面回传数据用
		top.$.subscribe(eventName, function(e, data) {
			if (data.testData = "hello") {
				window.location.reload();
			}
		});
		
		var tpl = $("#treeTableTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
		var data1 = ${dishesTypeList}, rootId = "0";
		addRow("#treeTableList", tpl, data1, rootId, true);
		$("#treeTable").treeTable({expandLevel:5});
		
		function addRow(list, tpl, data1, pid, root){
			for (var i=0; i<data1.length; i++){
				var row = data1[i];
				if ((${fns:jsGetVal('row.parentId')}) == pid){
					$(list).append(Mustache.render(tpl, {row:row,pid: (root?0:pid)
					}));
					addRow(list, tpl, data1, row.id);
				}
			}
		}

		//做法新增
		$("#btnAdd").bind("click", function() {
			top.$.jBox.open("iframe:${ctx}/setting/ctFood/form", "菜品新增", 1000, $(top.document).height() - 180, {
				buttons : {},
				loaded : function(h) {
					$(".jbox-content", top.document).css("overflow-y", "hidden");
				}
			});
		});

		//做法修改
		$("#contentTable a.update").click(function(e) {
			var id = $(this).data("id");
			top.$.jBox.open("iframe:${ctx}/setting/ctFood/form?&id=" + id, 
				"菜品修改", 
				1000, $(top.document).height() - 180, {
				buttons : {},
				loaded : function(h) {
					$(".jbox-content", top.document).css("overflow-y", "hidden");
				}
			});
		});

	});
</script>
</head>
<body>
	<sys:message content="${message}" />
	<div style="margin-top: 20px;">
	<table id="treeTable"
		class="table table-striped table-bordered table-condensed"
		style="width: 18%; float: left; margin-right: 1%;">
		<thead>
			<tr align="center">
				<th colspan="2">编号</th>
				<th colspan="2">类别名称</th>
			</tr>
		</thead>
		<tbody id="treeTableList" align="center">
		<tr>
		<td colspan="2"></td>
		<td colspan="2"><a href="${ctx}/setting/ctFood/list">全部</a></td>
		</tr>
		</tbody>
		<script type="text/template" id="treeTableTpl">
		<tr id="{{row.id}}" pId="{{row.parentId}}">
			<td colspan="2">{{row.code}}</td>
			<td colspan="2"><a href="${ctx}/setting/ctFood/list?foodType={{row.id}}&types={{row.parentId}}">{{row.name}}</a></td>
		</tr>
	    </script>
	</table>

	<table id="contentTable"
		class="table table-striped table-bordered table-condensed"
		style="width: 81%; float: left";>
		<thead>
			<tr>
				<th>编号</th>
				<th>菜品名称</th>
				<th>快捷码</th>
				<th>单位</th>
				<th>单价</th>
				<th>出品档口</th>
				<th>是否称重</th>
				<th>是否允许折扣</th>
				<th>是否优惠券</th>
				<th>启用库存</th>
				<th>打印机</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody align="center">
			<c:forEach items="${ctFoodList}" var="scmFee">
				<td>${scmFee.code}</td>
				<td>${scmFee.name}</td>
				<td>${scmFee.pinyin}</td>
				<td>${scmFee.foodUnitName}</td>
				<td>${scmFee.price}</td>
				<td></td>
				<c:if test="${scmFee.isWeigh == '1'}">
				<td>是</td>
				</c:if>
				<c:if test="${scmFee.isWeigh == '0'}">
				<td>否</td>
				</c:if>
				<c:if test="${scmFee.isDiscount == '1'}">
				<td>是</td>
				</c:if>
				<c:if test="${scmFee.isDiscount == '0'}">
				<td>否</td>
				</c:if>
				<c:if test="${scmFee.isCoupon == '1'}">
				<td>是</td>
				</c:if>
				<c:if test="${scmFee.isCoupon == '0'}">
				<td>否</td>
				</c:if>
				<td></td>
				<td>${scmFee.name}</td>
				<td><a class="update" data-id="${scmFee.id}">修改</a> </td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	</div>
	<div class="fixed-btn">
		<input type="button" id="btnAdd" class="btn btn-primary" value="新增菜品" />
	</div>
</body>
</html>