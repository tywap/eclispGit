<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>菜品选择</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
	
 	/* function validate() {
		var obj = document.getElementById("foodBigType"); //定位id
		var foodBigType=$("#foodBigType").val();
		var foodType=$("#foodType").val();
		var foodName=$("#foodName").val();
		var params = {
				foodBigType:foodBigType,
				foodType:foodType,
				foodName:foodName
			};
		alert(params);
		loadAjax("${ctx}/ctfood/special/select", params, null);
	}*/
	
	function selectweeks() {
		if ($("#weeksall").attr("checked") == "checked")
			$(".weeks").attr("checked", "checked");
		else
			$(".weeks").removeAttr("checked");
	}
	
	//提交		
	function confirm(){
		var str ="";
		$(".weeks:checked").each(function(){
			str+= $(this).val()+",";
		})
		str = str.substring(0,str.length-1);
		if(str==null||str==""){
			$.jBox.info("请选择需要添加的菜品！");
			return;
		}
		top.$.publish("checkIn",{
			str:str
		});
		parent.window.jBox.close(); 
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
	<form action="${ctx}/marcebter/ctfoodSpecial/select" id="rentalsForm"
		class="breadcrumb form-search" method="post">
		<ul class="ul-form">
			<li><label>菜品大类：</label> <select class="select-medium6"
				name="foodBigType" id="foodBigType">
				<option value="">全部</option>
					<c:forEach items="${bigTypeList}" var="c">
						<option value="${c.id }"
							<c:if test="${c.id==param.foodBigType}">selected</c:if>>${c.name }</option>
					</c:forEach>
			</select></li>
			<li><label>菜品小类：</label> <select class="select-medium6"
				name="foodType" id="foodType">
				<option value="">全部</option>
					<c:forEach items="${dishesTypeList}" var="c">
						<option value="${c.id }"
							<c:if test="${c.id==param.foodType}">selected</c:if>>${c.name }</option>
					</c:forEach>			</select></li>
			<li><input type="text"
				class="input-medium8" name="name" id="name"
				placeholder="输入菜品编码、名称查询"  value="${param.name }"></li>

			<li>
				<button id="btnSubmit" class="btn btn-primary" onclick="validate()">查询</button>
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
						<th>选择<input type="checkbox" value="" id="weeksall"
							onclick="selectweeks()"/></th>
						<th>菜品大类</th>
						<th>菜品小类</th>
						<th>产品编码</th>
						<th>菜品名称</th>
						<th>单位</th>
						<th>原价</th>
					</tr>
				</thead>
				<tbody id="ctFoodList">
					<c:forEach items="${maplist}" var="re" varStatus="s">
						<tr>
							<td><label class="labels"> <input type="checkbox"
								class="weeks" value="${re.id}" id="weeks_${re.id}"  name="weeks"></label></td>
							<td class="foodbi">${re.foodBigType }</td>
							<td class="foodty">${re.foodTypeName }</td>
							<td class="code">${re.code }</td>
							<td class="name">${re.name }</td>
							<td class="unit">${re.foodUnitName }</td>
							<td class="price">${re.price }</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
	<div class="fixed-btn-right">
			<input id="submitBtn" class="btn btn-primary" type="button"
				value="确  定" onclick="confirm()">&nbsp;
		</div>
	<script src="${ctxStatic}/jqprint/jquery.jqprint-0.3.js"
		type="text/javascript"></script>

</body>
</html>