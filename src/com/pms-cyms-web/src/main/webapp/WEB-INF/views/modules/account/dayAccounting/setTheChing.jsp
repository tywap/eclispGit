<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>设置估清</title>
<meta name="decorator" content="default" />
<script type="text/javascript">

	$(document).ready(function() {
		//解绑事件
		var eventName = "setTheChing";
		top.$.unsubscribe(eventName);
		//注册事件，弹出页面需要刷新本页面，或者弹出页面回传数据用
		top.$.subscribe(eventName, function(e, data) {
			foodSelect(data);
		});	
		
		//菜品选择
		$("#addfood").bind("click", function() {
			top.$.jBox.open("iframe:${ctx}/setting/ctFood/select?status=1&foodStoreId=${storeId}", "菜品选择", 1000, $(top.document).height() - 180, {
				buttons : {},
				loaded : function(h) {
					$(".jbox-content", top.document).css("overflow-y", "hidden");
				}
			});
		});
		var ctFoodList=${ctFoodList};
		if (ctFoodList.length > 0) {
			 for (var i = 0; i < ctFoodList.length; i++) {
				 var len=$("#ctFoodList tr").length+parseInt(1);
					var setMealList="<tr>"+
					"<input type='hidden' value='"+ctFoodList[i].id+"' name='foodId'>"+
					"<td>"+len+"</td>"+
					"<td>"+ctFoodList[i].code+"</td>"+
					"<td>"+ctFoodList[i].name+"</td>"+
					"<td>"+ctFoodList[i].foodUnitName+"</td>"+
					"<td>"+ctFoodList[i].price.amount+"</td>"+
					"<td><div class='mui-numbox' data-numbox-step='1' data-numbox-min='1' data-numbox-max=''>"+
					"<input name='number' id='input' class='mui-numbox-input' type='number'  value='"+ctFoodList[i].stock+"' style='width: 120px;' >"+
					"</div></td>"+
					"<td><a class='delete' data-id="+ctFoodList[i].id+" onclick='remove(this);' >移除</a></td>"+
					"</tr>"
					 $("#ctFoodList").append(setMealList);
			 }
		}
	});
	function save() {
		var storeId=${storeId}
		var foodIds=[];//套餐菜品id
        var numbers=[];//套餐菜品数量
        $("input[name='foodId']").each(function(index,item){
            foodIds.push($(this).val());
        })
		$("input[name='number']").each(function(index,item){
        	if($(this).val() == ''){
        		numbers = null;
        	}else{
        		numbers.push($(this).val());
        	}
        })
        if(numbers == null  || numbers == ''){
			layer.alert('请填写菜品估清数量');
        	return;
		}
        var  params ="storeId="+storeId+"&foodIds="+foodIds+"&numbers="+numbers;
		loadAjax("${ctx}/accounting/dayFoodRepertory/saveTheChing", params, function(result) {
			if (result.retCode == "000000") {
				top.$.publish("dayRepetory", {
					testData : "hello"
				});
				window.parent.jBox.close();
			} else {
				layer.alert(result.retMsg);
			}
		});
        
        
	}
	
	 //加载选择的菜品
	 function foodSelect(data) {
			var onkeyup ="''";
			var list =[];
		        $("input[name='foodId']").each(function(){
		        	list.push($(this).val());
		        })
			 for (var i = 0; i < data.testData.length; i++) {
				 var params = {id:data.testData[i]}
				 loadAjax("${ctx}/setting/ctFood/foodSelect", params, function(result) {
						if (result.retCode == "000000") {
							var data=result.list;
							var boole=true;
								for (var i = 0; i < list.length; i++) {
									if (data[0].id == list[i]) {
										boole=false;
									}
							    }
								if (boole) {
									var len=$("#ctFoodList tr").length+parseInt(1);
									var setMealList="<tr>"+
									"<input type='hidden' value='"+data[0].id+"' name='foodId'>"+
									"<td>"+len+"</td>"+
									"<td>"+data[0].code+"</td>"+
									"<td>"+data[0].name+"</td>"+
									"<td>"+data[0].foodUnitName+"</td>"+
									"<td>"+data[0].price.amount+"</td>"+
									"<td><div class='mui-numbox' data-numbox-step='1' data-numbox-min='1' data-numbox-max=''>"+
									"<input name='number' id='input' class='mui-numbox-input' type='number'  value='100' style='width: 120px;' >"+
									"</div></td>"+
									"<td><a class='delete' data-id="+data[0].id+" onclick='remove(this);' >移除</a></td>"+
									"</tr>"
									 $("#ctFoodList").append(setMealList);
								}
						} else {
							layer.alert(result.retMsg);
						}
					});
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
	
	//移除菜品
	function remove(obj) {
		var tr = this.getRowObj(obj);
		if (tr != null) {
			var rows = tr.rowIndex;                           
			var count= $(obj).parents('tr').find('.mui-numbox-input').val();
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
        -webkit-appearance: none !important;
        margin: 0;
    }
</style>
</head>
<body>
	<div class="control-group" style="margin:10px 5px 5px 10px; "/>
		<div class="controls">请选择需要估清的菜品：</div>
	</div>
	<table id="contentTable"
		class="table table-striped table-bordered table-condensed"
		style="width: 81%; float: left; margin-left: 10px;">
		<thead>
			<tr>
				<th>序号</th>
				<th>产品编码</th>
				<th>菜品名称</th>
				<th>单位</th>
				<th>售价</th>
				<th>设置估清数量</th>
				<th>操作 &nbsp;&nbsp;<a style="cursor: pointer; outline: none;"
					id="addfood">+</a></th>
			</tr>
		</thead>
		<tbody align="center" id ="ctFoodList" name="ctFoodList">
		</tbody>
	</table>
	<div class="fixed-btn-right">
			<input id="submitBtn" class="btn btn-primary" type="button"
				value="确  定" onclick="save()">&nbsp;
		</div>
	<script src="${ctxStatic}/jqprint/jquery.jqprint-0.3.js"
		type="text/javascript"></script>

</body>
</html>