<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>已点菜品</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	var judg=${judge}
	$(document).ready(function() {
		if(judg==1){
			$("#btnSubmit").hide();
		}else{
			$("#btnSubmit").show();
		}
		//提前点餐
		$("#btnSubmit").bind("click",function() {
			 top.$.jBox.open(
	            	"iframe:${ctx}/reserve/reserveAheadOrderFood?storeId=${storeId}&reserveId=${reserveId}&id=${id}",
	             	"预订单号："+'${reserveId}',
	             	1360,
	                650,
	                {
		                buttons: {},//"返回":"0"
		                //bottomText: '坐标长沙',
		                opacity:0,
	        			showClose: false,
	        			draggable: false,
	        			showType:"show",
		                loaded: function (h) {
		                	//$(".jbox-content", top.document).css("overflow-y", "hidden");
		                	$(".jbox-content").css("overflow-y", "hidden");
		                },
		                closed:function (){
		                	var roomIds = cookie("roomIds");
		                	if(roomIds!=null){
		                		reflashRoom(roomIds);	                		
		                	}
		                	var minusRoomIds = cookie("minusRoomIds");
		                	if(minusRoomIds!=null){
		                		reflashRoom(minusRoomIds);	                		
		                	}
		                	cookie("roomIds",null,{path:'/',expires:-1});
		                	cookie("minusRoomIds",null,{path:'/',expires:-1});
		                	cookie("ordIndex",null,{path:'/',expires:-1});
		                	cookie("tabIndex",null,{path:'/',expires:-1});
		                	window.location.reload();
		                }
	                }
				);
		});
	});
	
	//此处调用superTables.js里需要的函数
	window.onload=function(){ 
		new superTable("demoTable", {cssSkin : "sDefault",  
			headerRows :2,  //头部固定行数
			onStart : function () {  
			   this.start = new Date(); 
			},  
			onFinish : function () {  
			}  
		}); 

		var searchFormW = ($(".form-search").width() + 20)+"px";
		$("#div_container").css({"width":searchFormW+20});//这个宽度是容器宽度，不同容器宽度不同
		$(".fakeContainer").css("height",($(document).height()-100)+"px");//这个高度是整个table可视区域的高度，不同情况高度不同
		$("#demoTable").css({"width":searchFormW +"!important"});
		//.sData是调用superTables.js之后页面自己生成的  这块就是出现滚动条 达成锁定表头和列的效果				
		$(".sHeader").css("width",($(document).width())+"px");
		$(".sData").css("width",($(document).width())+"px");//这块的宽度是用$("#div_container")的宽度减去锁定的列的宽度
		$(".sData").css("height",($(document).height()-195)+"px");//这块的高度是用$("#div_container")的高度减去锁定的表头的高度
		
		//目前谷歌  ie8+  360浏览器均没问题  有些细小的东西要根据项目需求改
		//有兼容问题的话可以在下面判断浏览器的方法里写
		if(navigator.appName == "Microsoft Internet Explorer" && navigator.appVersion.match(/9./i)=="9.") 
		{//alert("IE 9.0");
			
		}else if (!!window.ActiveXObject || "ActiveXObject" in window){//alert("IE 10");
			
		}else{//其他浏览器
			//alert("其他浏览器");
		}
	}
	</script>
	<style type="text/css">
		.total{
    	font-weight:bold;
    	display:inline-block;
    	width: 150px;
    	overflow:hidden;
    	text-overflow:ellipsis;
    	white-space:normal;
    	vertical-align:top;
    	}
	
	</style>
</head>
<body>
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/reserve/ordReserveDetails?reserveId=${reserveId}&storeId=${storeId}&depositAmount=${depositAmount}&tableCount=${tableCount}&judge=${judge}">预订信息</a></li>
		<li class="active"><a href="${ctx}/reserve/reserveHaveDotFood?reserveId=${reserveId}&storeId=${storeId}&depositAmount=${depositAmount}&tableCount=${tableCount}&id=${id}&judge=${judge}">已点菜品</a></li>
	</ul><br/>
	<div id="div_container" >
		<div id="my_div" class="fakeContainer first_div"style="overflow: auto;">
			<table id="contentTable"
		class="table table-striped table-bordered table-condensed"float: left";>
				<thead>
					<tr>
						<th>序号</th>
						<th>菜品编号</th>
						<th>菜品名称</th>
						<th>单位</th>
						<th>份数</th>
						<th>单价</th>
						<th>折扣率</th>
						<th>折扣金额</th>
						<th>小计</th>
						<th>做法</th>
						<th>菜品类型</th>
						<th>备注</th>
					</tr>
				</thead>
				<tbody id="ctFoodList">
					<c:forEach items="${ordReserve}" var="reserve" varStatus="s">
						<tr>
							<td>${s.count}</td>
							<td>${reserve.code }</td>
							<td>${reserve.name }</td>
							<td>${reserve.foodUnitName }</td>
							<td>${reserve.count }</td>
							<td>${reserve.price }</td>
							<td>${reserve.rate }</td>
							<td>${reserve.rateAmount }</td>
							<td>${reserve.amount }</td>
							<td>${reserve.cookValues }${reserve.cookValuesTemp }</td>
							<td>${reserve.foodTypeName }</td>
							<td>${reserve.remarks }</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
	 <div style="margin-left: 10px;color: red;">
	     <label style="margin-right:20px">
	     <span id="totalCount" class="total" >菜品数量：${totalCount }</span>
	     <span id="totalConsume"  class="total">消费金额：${totalConsume }</span>
	     <span id="totalRateAmount"  class="total">折扣：${totalRateAmount }</span>
	     <span id="totalAmount" class="total">预计消费：${totalConsume }</span>
	     <span id="theTotalPayment" class="total">定金：${theTotalPayment }</span>
	     <span id="accountsDue" class="total">应收款：${accountsDue }</span>
	     </label>
	</div>
	<c:if test="${tableCount == '1' }">
	<div class="fixed-btn-right">
			<input id="btnSubmit" class="btn btn-primary" type="button" value="提前点餐" >&nbsp;
	</div>
	</c:if>
</body>
</html>