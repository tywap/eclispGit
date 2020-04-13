<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>当日估清</title>
<meta name="decorator" content="default" />
<%@include file="/WEB-INF/views/include/treetable.jsp" %>
<script type="text/javascript">
	$(document).ready(function() {
		//解绑事件
		var eventName = "dayRepetory";
		top.$.unsubscribe(eventName);
		//注册事件，弹出页面需要刷新本页面，或者弹出页面回传数据用
		top.$.subscribe(eventName, function(e, data) {
			if (data.testData = "hello") {
				window.location.reload();
			}
		});
		//加载分店
        loadSelect("foodStoreId","${ctx}/sys/userutils/getOfficeListByType",{typesJson:"['3','4','5']"},'${selectStoreId}','id','name'); 
        var datas = '${dishesTypeList}';
		if (datas !='') {
			var tpl = $("#treeTableTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
			var data1 = ${dishesTypeList}, rootId = "0";
			addRow("#treeTableList", tpl, data1, rootId, true);
			$("#treeTable").treeTable({expandLevel:5});
		}
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

        $("#submit").bind("click", function() {
			var storeId=  $("#foodStoreId option:selected").val();
			if (storeId =='') {
				layer.confirm('请先选择分店！');
				return false;
			}
		});
        
      	//设置估清
		$("#btnAdd").bind("click", function() {
			var storeId='${selectStoreId}';
			if (storeId =='') {
				layer.confirm('请先选择分店！');
				return false;
			}
			top.$.jBox.open("iframe:${ctx}/accounting/dayFoodRepertory/setTheChing?storeId="+storeId, "设置估清", 800, 500, {
				buttons : {},
				loaded : function(h) {
					$(".jbox-content", top.document).css("overflow-y", "hidden");
				}
			});
		});
		
	});
	
	//查询
	function searchChange(storeId){
		if(storeId==''){
			storeId="pmscy";
		}
		self.location.href="${ctx}/accounting/dayFoodRepertory/list?foodStoreId="+storeId;
	}
	
</script>
</head>
<body>
<form action="${ctx}/accounting/dayFoodRepertory/list" id="rentalsForm"
		class="breadcrumb form-search" method="post">
		<ul class="ul-form">
		<li><label>分店：</label>
				<select id="foodStoreId" name="foodStoreId" class="select-medium6" style="width: 120px;" onchange="searchChange(this.options[this.options.selectedIndex].value)">
				</select>
			</li>
			<li><label>状态：</label> <select class="select-medium6"
				name="status" id="status" style="width: 120px;">
				<option value="">全部</option>
				<option value="0"<c:if test="${param.status=='0'}">selected</c:if>>可售</option>
				<option value="1"<c:if test="${param.status=='1'}">selected</c:if>>估清</option>
			</select></li>
			<li><label><input name="isWeigh" id="isWeigh" type="checkbox" <c:if test="${param.isWeigh==no}">checkboxed</c:if>/>称重</label>
						<label><input name="isDiscount" id="isDiscount" type="checkbox" />允许折扣</label>
						<label><input name="isCoupon" id="isCoupon" type="checkbox"/>允许优惠卷</label>
						<label><input name="passFood" id="passFood" type="checkbox"/>传菜</label></li>
			<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label>商品名称：</label> <input type="text"
				class="input-medium8" name="code" id="code"
				placeholder="输入菜品名称、快捷码、菜品编号快速查询"  value="${param.code }" style="width: 250px;"></li>

			<li>
				<button id="submit" class="btn btn-primary" >查询</button>
			</li>
		</ul>
	</form>	<sys:message content="${message}" />
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
<%-- 		<tr>
		<td colspan="2"></td>
		<td colspan="2"><a href="${ctx}/accounting/dayFoodRepertory/list?foodStoreId=${selectStoreId}">全部</a></td>
		</tr>
 --%>		</tbody>
		<script type="text/template" id="treeTableTpl">
		<tr id="{{row.id}}" pId="{{row.parentId}}">
			<td colspan="2">{{row.code}}</td>
			<td colspan="2"><a href="${ctx}/accounting/dayFoodRepertory/list?foodType={{row.id}}&types={{row.parentId}}&foodStoreId=${selectStoreId}">{{row.name}}</a></td>
		</tr>
	    </script>
	</table>

	<table id="contentTable"
		class="table table-striped table-bordered table-condensed"
		style="width: 81%; float: left";>
		<thead>
			<tr>
			    <th>序号</th>
			    <th>做法类型</th>
				<th>编号</th>
				<th>菜品名称</th>
				<th>快捷码</th>
				<th>单位</th>
				<th>单价</th>
				<th>已售</th>
				<th>估清</th>
				<th>是否称重</th>
				<th>是否允许折扣</th>
				<th>是否优惠券</th>
				<th>是否传菜</th>
			</tr>
		</thead>
		<tbody align="center">
			<c:forEach items="${ctFoodList}" var="scmFee" varStatus="stauts">
			    <td>${stauts.count}</td> 
				<td>${scmFee.packageTypeName}</td> 
				<td>${scmFee.code}</td>
				<td>${scmFee.name}</td>
				<td>${scmFee.pinyin}</td>
				<td>${scmFee.foodUnitName}</td>
				<td>${scmFee.price}</td>
				<td>${scmFee.soldOut }</td> 
				<c:if test="${scmFee.surplus <= 0}">
				<td><font color="red">估清</font></td>
				</c:if>
				<c:if test="${scmFee.surplus > 0}">
				<td><font color="red">${scmFee.surplus }</font></td> 
				</c:if>
				<c:if test="${scmFee.stock == '0'}">
				<td><font color="red"></font></td> 
				</c:if>
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
				<c:if test="${scmFee.status == '1'}">
				<td>是</td>
				</c:if>
				<c:if test="${scmFee.status == '0'}">
				<td>否</td>
				</c:if>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<div class="fixed-btn">
		<input type="button" id="btnAdd" class="btn btn-primary" value="设置估清" />
	</div>
</body>
</html>