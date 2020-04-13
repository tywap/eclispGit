<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>台号选择</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
	
	$(document).ready(function() {
		
	});
	function save() {
		obj = document.getElementsByName("weeks");
		check_val = [];
		check_no = [];
		check_ordId = [];
		for (var i = 0; i < obj.length; i++) {
			if (obj[i].checked){
				check_val.push(obj[i].id);
				check_no.push(obj[i].value);
				check_ordId.push(obj[i].dataset.id);
			}
		}
		if (check_val.length>1) {
			layer.alert("请勿选择多个台号！");
			return;
		}
		if (check_val != "") {
			top.$.publish("changeTable", {
				testData : check_val,noData : check_no,ordData : check_ordId
			});
				window.parent.jBox.close();
		}else {
			layer.alert("请选择需要转换的台号！");
		}
	}
	
	
	//此处调用superTables.js里需要的函数
	window.onload = function() {
		new superTable("demoTable", {
			cssSkin : "sDefault",
			headerRows : 2, //头部固定行数
			onStart : function() {
				this.start = new Date();
			},
			onFinish : function() {
			}
		});

		var searchFormW = ($(".form-search").width() + 20) + "px";
		$("#div_container").css({
			"width" : searchFormW + 20
		});//这个宽度是容器宽度，不同容器宽度不同
		$(".fakeContainer").css("height", ($(document).height() - 100) + "px");//这个高度是整个table可视区域的高度，不同情况高度不同
		$("#demoTable").css({
			"width" : searchFormW + "!important"
		});
		//.sData是调用superTables.js之后页面自己生成的  这块就是出现滚动条 达成锁定表头和列的效果				
		$(".sHeader").css("width", ($(document).width() - 17) + "px");
		$(".sData").css("width", ($(document).width() - 17) + "px");//这块的宽度是用$("#div_container")的宽度减去锁定的列的宽度
		$(".sData").css("height", ($(document).height() - 145) + "px");//这块的高度是用$("#div_container")的高度减去锁定的表头的高度

		//目前谷歌  ie8+  360浏览器均没问题  有些细小的东西要根据项目需求改

		//有兼容问题的话可以在下面判断浏览器的方法里写
		if (navigator.appName == "Microsoft Internet Explorer" && navigator.appVersion.match(/9./i) == "9.") {//alert("IE 9.0");

		} else if (!!window.ActiveXObject || "ActiveXObject" in window) {//alert("IE 10");

		} else {//其他浏览器
			//alert("其他浏览器");
		}
	}
	$(window).resize(function() {
		var searchFormW = ($(".form-search").width() + 20) + "px";
		$("#div_container").css({
			"width" : searchFormW + 20
		});
		$("#demoTable").css({
			"width" : searchFormW + "!important"
		});
		$(".sHeader").css("width", ($(document).width() - 17) + "px");
		$(".sData").css("width", ($(document).width() - 17) + "px");//这块的宽度是用$("#div_container")的宽度减去锁定的列的宽度
		$(".sData").css("height", ($(document).height() - 145) + "px");
	})
	
</script>
</head>
<body>
	<form action="${ctx}/order/checkIn/selectTable" id="rentalsForm"
		class="breadcrumb form-search" method="post">
		<input id="typeId"  value="${type}" type="hidden" name="typeId"/>
		<input id="storeId"  value="${storeId}" type="hidden" name="storeId"/>
		<ul class="ul-form">
			<li><label>经营区域：</label> 
			<select class="select-medium6" name="floor" id="floor">
				<option value="">--请选择--</option>
					<c:forEach items="${foorlList}" var="c">
						<option value="${c.id }"
							<c:if test="${c.id==param.floor}">selected</c:if>>${c.name }</option>
					</c:forEach>			
			</select></li>
			<li><label>台号名称：</label> <input type="text"
				class="input-medium8" name="name" id="name"
				placeholder="输入台号或台号名称"  value="${param.name }"></li>

			<li>
				<button id="submit" class="btn btn-primary" >查询</button>
			</li>
		</ul>
	</form>
	<div id="div_container">
		<div id="my_div" class="fakeContainer first_div"
			style="overflow: auto;">

			<table id="contentTable"
		class="table table-striped table-bordered table-condensed"
		style="width: 81%; float: left";>
				<thead>
					<tr>
						<th>选择</th>
						<th>经营场所</th>
						<th>经营区域</th>
						<th>台号</th>
						<th>台号名称</th>
						<th>用餐人数</th>
					</tr>
				</thead>
				<tbody id="ctFoodList">
					<c:forEach items="${ctTableList}" var="re" varStatus="s">
						<tr>
							<td><label class="labels"> 
							<input type="checkbox"
								class="weeks" id="${re.id}"  name="weeks" value="${re.no }" data-id="${re.orderId}">
							</label></td>
							<td>${re.storeId }</td>
							<td>${re.floor }</td>
							<td>${re.no }</td>
							<td>${re.name }</td>
							<c:if test="${re.status == 'cleanEmpty'}">
							<td></td>
							</c:if>
							<c:if test="${re.status == 'checkIn'}">
							<td>${re.useNum }</td>
							</c:if>
							
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
	<div class="fixed-btn-right">
			<input id="submitBtn" class="btn btn-primary" type="button"
				value="确  定" onclick="save()">&nbsp;
		</div>
	<script src="${ctxStatic}/jqprint/jquery.jqprint-0.3.js"
		type="text/javascript"></script>

</body>
</html>