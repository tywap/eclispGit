<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>配置菜品价格</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
		});
		function save() {
		   var check_val = [];
 		   var check_id = [];
 		   var cks = $("[name='number']");
 		   if (cks.length == 0) {
 			  layer.alert("请先选择菜品！");
 			 return;
			}
 		   for(var i=0;i<cks.length;i++){
 				check_id.push(cks[i].id);
 	 			check_val.push(cks[i].value);
 			}
 		    var params="foodIdList="+check_id+"&priceList="+check_val;
 		  	window.parent.jBox.close();
			loadAjax("${ctx}/setting/ctFoodPrinter/configuringPrice", params, function(result) {
				if (result.retCode == "000000") {
					top.$.publish("ctFoodPrinter",{testData:"hello"});
					layer.alert("配置成功！");
				} else {
					layer.alert(result.retMsg);
				}
			});
		};
		
		 //移除菜品
		function remove(obj) {
			var tr = this.getRowObj(obj);
			if (tr != null) {
				tr.parentNode.removeChild(tr);
			} else {
				$.jBox.info("移除失败！");
			}
		}

		function getRowObj(obj) {
			var i = 0;
			while (obj.tagName.toLowerCase() != "tr") {
				obj = obj.parentNode;
				if (obj.tagName.toLowerCase() == "table")
					return null;
			}
			return obj;
		}

	</script>
	<style type="text/css">
		input::-webkit-outer-spin-button,
		input::-webkit-inner-spin-button {
		    -webkit-appearance: none;
		}
		input[type="number"] {
		    -moz-appearance: textfield;
		}
	</style>
</head>
<body>
	<div class="tab-content">
			<div id="div_container">
		<div id="my_div" class="fakeContainer first_div"
			style="overflow: auto; margin-top: 10px; margin-left: 5px;" >

			<table id="contentTable"
		class="table table-striped table-bordered table-condensed"
		style="width: 81%; float: left";>
				<thead>
					<tr>
						<th>菜品名称</th>
						<th>价格</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody id="ctFoodList">
					<c:forEach items="${ctFoodStoreList}" var="re" varStatus="s">
						<tr>
							<td>${re.foodName }</td>
							<td align="center"><input type="number" name="number" value=${re.price }  id=${re.id }></td>
							<td><a class='delete' onclick='remove(this)'>移除</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
		<div class="fixed-btn-right">
			<input id="submitBtn" class="btn btn-primary" type="button"
				value="保 存" onclick="save()" />
		</div>
	</div>
</body>
</html>