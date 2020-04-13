<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>支付明细</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#wBtn").click(function(){
				top.$.jBox.confirm("确认要导出钱箱明细吗？","系统提示",function(v,h,f){
					if(v=="ok"){
						$("#searchForm").attr("action","${ctx}/order/ordPaymentFund/ExportExcel");
						$("#searchForm").submit();
					}
				},{buttonsFocus:1});
				top.$('.jbox-body .jbox-icon').css('top','55px');				
			});
			
			$("#queryOrder").click(function(){
				$("#searchForm").attr("action","${ctx}/order/ordPaymentFund/list");
				$("#searchForm").submit();
			});
			
			//加载分店
	        loadSelect("companyCheckDiv","${ctx}/sys/userutils/getOfficeListByType",{typesJson:"['3','4','5']"},'${param.storeId}','id','name');
			
			if("${param.storeId}"!=""){
				getshiftListByStoreId("${param.storeId}");
			}
		});
		
		function getshiftListByStoreId(storeId){
			if(storeId==""||storeId==undefined){
				storeId = $("#companyCheckDiv").val();	
			}
			if(storeId==""){
				layer.alert("请选择分店");
				return;
			}
			loadSelect("shiftId","${ctx}/bc/pubShift/getshiftListByStoreId",{storeId:storeId},'${param.shiftId}','id','shiftName');
		}
		
		//此处调用superTables.js里需要的函数
		window.onload = function () {
		    new superTable("demoTable", {
		        cssSkin: "sDefault",
		        //fixedCols: 1, //固定几列
		        headerRows: 1,  //头部固定行数
		        onStart: function () {
		            this.start = new Date();
		        },
		        onFinish: function () {
		        }
		    });		 		 
		    $("#div_container").css("width", $(document).width());//这个宽度是容器宽度，不同容器宽度不同
		    $(".fakeContainer").css("height", $(document).height()-100);//这个高度是整个table可视区域的高度，不同情况高度不同
		    //.sData是调用superTables.js之后页面自己生成的  这块就是出现滚动条 达成锁定表头和列的效果
		    $(".sHeader").css("width", $(document).width()-17);
		    $(".sData").css("width", $(document).width()-17);//这块的宽度是用$("#div_container")的宽度减去锁定的列的宽度
		    $(".sData").css("height", $(document).height()-140);//这块的高度是用$("#div_container")的高度减去锁定的表头的高度		 
		    //目前谷歌  ie8+  360浏览器均没问题  有些细小的东西要根据项目需求改		 
		    //有兼容问题的话可以在下面判断浏览器的方法里写
		    if (navigator.appName == "Microsoft Internet Explorer" && navigator.appVersion.match(/9./i) == "9.") {//alert("IE 9.0");		 
		    } else if (!!window.ActiveXObject || "ActiveXObject" in window) {//alert("IE 10"); 
		    } else {//其他浏览器
		        //alert("其他浏览器");
		    }
		}
		//此处调用superTables.js里需要的函数
		/* window.onload=function(){ 
			new superTable("demoTable", {cssSkin : "sDefault",  
				headerRows :1,  //头部固定行数
				onStart : function () {  
				   this.start = new Date(); 
				},  
				onFinish : function () {  
				}  
			}); 
			
			var searchFormW = ($("#searchForm").width() + 20)+"px";
			$("#div_container").css({"width":searchFormW+20});//这个宽度是容器宽度，不同容器宽度不同
			$(".fakeContainer").css("height",($(document).height()-100)+"px");//这个高度是整个table可视区域的高度，不同情况高度不同
			$("#demoTable").css({"width":searchFormW +"!important"});
			//.sData是调用superTables.js之后页面自己生成的  这块就是出现滚动条 达成锁定表头和列的效果				
			$(".sHeader").css("width",($(document).width())+"px");
			$(".sData").css("width",($(document).width())+"px");//这块的宽度是用$("#div_container")的宽度减去锁定的列的宽度
			$(".sData").css("height",($(document).height()-135)+"px");//这块的高度是用$("#div_container")的高度减去锁定的表头的高度
			
			//目前谷歌  ie8+  360浏览器均没问题  有些细小的东西要根据项目需求改
	
			//有兼容问题的话可以在下面判断浏览器的方法里写
			if(navigator.appName == "Microsoft Internet Explorer" && navigator.appVersion.match(/9./i)=="9.") 
			{//alert("IE 9.0");
				
			}else if (!!window.ActiveXObject || "ActiveXObject" in window){//alert("IE 10");
				
			}else{//其他浏览器
				//alert("其他浏览器");
			}
		}			
		$(window).resize(function(){
			var searchFormW = ($("#searchForm").width() + 20)+"px";
			$("#div_container").css({"width":searchFormW+20});
			$(".sHeader").css("width",($(document).width())+"px");				
			$(".sData").css("width",($(document).width())+"px");//这块的宽度是用$("#div_container")的宽度减去锁定的列的宽度
			$(".sData").css("height",($(document).height()-135)+"px");
		}) */
		
		
		function getOrder(orderId,orderType){
			if(orderType==0){
				 top.$.jBox.open(
			            	"iframe:${ctx}/order/checkIn/ordTableIndexInit?orderId=" + orderId,
			             	"单号："+orderId,
			            	$(window).width()-5,
			                $(window).height()-7,
			                {
				                buttons: {},//"返回":"0"
				                //bottomText: '坐标长沙',
				              /*   opacity:0,
			        			showClose: false,
			        			draggable: false,
			        			showType:"show", */
				                loaded: function (h) {
				                	$(".jbox-content", top.document).css("overflow", "hidden");
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
				                }
			                }
						);
					}else if(orderType==2){
						top.$.jBox.open(
								"iframe:${ctx}/reserve/ordReserveDetails?&reserveId=" + orderId+"&judge="+1,
								"预订单："+orderId,
								1000, 
								$(top.document).height() - 180, {
									buttons : {},
									loaded : function(h) {
										$(".jbox-content",top.document).css("overflow-y","hidden");
									}
						});
					}
			}
	</script>
</head>
<body>
	<div id="importBox" class="hide">
	</div>
	<form:form id="searchForm" modelAttribute="order" action="${ctx}/order/ordPaymentFund/list" method="post" class="breadcrumb form-search ">
		<input type="hidden" name='status' value="1"/>
		 <ul class="ul-form">
		 	<li>
		 		<label>分店：</label>
				<select id="companyCheckDiv" class="input-medium6" name="storeId" onchange="getshiftListByStoreId()">
			 	</select>
		 	</li>
			<li>
				<label>当前班次：</label>
				<select id="shiftId" name="shiftId" class="select-medium6">
				</select>
			</li>
			<li>
				<label>操作人：</label>
				<select id="name" name="name" class="select-medium6">
					<option value="">全部</option>
					<c:forEach items="${nameList }" var="var" varStatus="vs">
						<option value="${var.name}" <c:if test="${var.name == param.name }">selected ="selected"</c:if>> ${var.name}</option>
					</c:forEach>
				</select>
			<%-- <input type="text" name="name" id="name" value="${param.name }" htmlEscape="false" maxlength="50" class="input-medium6"/> --%>
			</li>
			<li><label>类型：</label>
				<select id="titleName" name="titleName" class="select-medium6">
					<option value="">全部</option>
					<c:forEach items="${titleTypeList}" var="var" varStatus="vs">
                      	<option value="${var.titleName}" <c:if test="${var.titleName == param.titleName }">selected ="selected"</c:if>> ${var.titleName}</option>
	                </c:forEach>
				</select>
			</li>
			<li><label>支付方式：</label>
				<select id="payMethod" name="payMethod" class="select-medium6">
					<option value="">全部</option>
					<c:forEach items="${payMethodList}" var="var" varStatus="vs">
                      	<option value="${var.code}" <c:if test="${var.code == param.payMethod }">selected ="selected"</c:if>> ${var.message}</option>
	                </c:forEach>
				</select>
			</li>
			<li><label>凭证号：</label><input type="text" name="payVoucher" id="payVoucher" value="${param.payVoucher }" htmlEscape="false" maxlength="50" class="input-medium6"/></li>
			<li><button id="queryOrder" class="btn btn-primary" type="submit">查询</button></li>
			<li class="clearfix"></li>
		</ul> 
	</form:form>
	<sys:message content="${message}"/>
	<div id="div_container">
		<div id="my_div" class="fakeContainer first_div">
			<table id="demoTable" class="table table-bordered">
				<thead>
					<tr id="my_tr">
						<th>操作时间</th>
						<th>班次</th>
						<th>操作员</th>
						<th>类型</th>
						<th>支付方式</th>
						<th>金额</th>
						<th>系统单号</th>
						<th>系统备注</th>
						<th>凭证号</th>
					</tr>
				</thead>
				<tbody>
				<c:forEach items="${datalist}" var="order">
					<tr>
						<td><fmt:formatDate value="${order.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
						<td>${order.shiftName}</td>
						<td class="names">${order.name}</td>
						<td>${order.titleName}</td>
						<td>${order.label}</td>
						<td style="text-align:right;">${order.amount}</td>
						<td><a onclick="getOrder('${order.orderId}','${order.orderType }')">${order.orderId}</a></td>
						<td>${order.description}</td>
						<td>${order.payVoucher}</td>
						<td style="display:none">${order.orderType }</td>
					</tr>
				</c:forEach>
				</tbody>
			</table>
			<lable class="table-nodata"> 
				<c:choose>
					<c:when test="${fn:length(list)==0}">
						没有数据
					</c:when>
				</c:choose>
			</lable>
		</div>
	</div>
<div class="fixed-btn">
	<button class="btn btn-primary" id="wBtn" >导出Excel</button>
	<label>合计：${totalNum}条</label>
	<label>总金额：<span>${totalAmount}</span></label>
</div>

</body>
</html>