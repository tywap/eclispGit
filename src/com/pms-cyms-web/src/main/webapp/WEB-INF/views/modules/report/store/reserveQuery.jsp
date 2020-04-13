<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>订金余额</title>
<meta name="decorator" content="default"/>
</head>
<body>
	<form:form action="${ctx }/reserve/Reserve/query" method="POST"
		class="breadcrumb form-search" id="subForm">
		<ul class="ul-form">
			<li>
				<label>餐厅：</label> 
				<select name="hotelId" class="select2 select-medium6">
					<option selected="selected" value="">所有</option>
					<c:forEach items="${HOTELNAME }" var="h">
						<option value="${h.id}"
							<c:if test="${h.id == hotelId}">selected</c:if>>${h.name}</option>
					</c:forEach>
				</select>
			</li>
			<%-- <li>
				<label>订单状态：</label>
				<select name="orderS" class="select-medium6">
					<option value="" selected="selected">全部</option>
					<c:forEach items="${OS}" var="var" varStatus="vr">
                       	<option value="${var.code}" <c:if test="${var.code == param.status }">selected ="selected"</c:if>> ${var.name}</option>
                    </c:forEach>
				</select>
			</li> --%>
			<li>
			<li><select name="selectid" style="margin-right:0px;" class="select-medium6">
					<option value="1" <c:if test="${1==backselectid}">selected</c:if>>预定人</option>
					<option value="2" <c:if test="${2==backselectid}">selected</c:if>>单号</option>
			</select>
		    <input type="text" class="input-medium6" name="selectVal"
				value="${backselectVal }"></li>
			<li>
				<button type="button" id="sub" class="btn btn-primary">查询</button>
			</li>
		</ul>
	</form:form>
	<div id="div_container">
		<div id="my_div" class="fakeContainer first_div" >
			<table class="table table-bordered center" id="demoTable">
				<thead>
					<tr id="my_tr">
						<th>餐厅</th>
					<!-- 	<th>订单状态</th> -->
						<th>预定单号</th>
						<th>预定人</th>
						<th>联系电话</th>
						<th>订单金额(元)</th>
						<!-- <th>收款[小计](元)</th> -->
						<th>备注</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${DATA }" var="d" varStatus="vs">
						<tr>
							<td>${d.storename }</td>
							<%-- <td>${d.status }</td> --%>
							<%-- <td><a onclick="getOrder('${d.id}')">${d.id }</a></td> --%>
							<td><a onclick="toShow('${d.id }','${d.storeId }','${d.depositamount }','${d.quantity }')">${d.id }</a></td>
							<td>${d.name }</td>
							<td>${d.phone }</td>
							<td>${d.depositamount }</td>
							<%-- <td>
								<c:choose> 
							     	<c:when test="${our.pay_status }">
							     		${d.depositamount==1 }
							 		</c:when>      
							     	<c:otherwise>
							     		0
							 		</c:otherwise> 
								</c:choose>
							</td> --%>
							<td style="margin-top:1px;">${d.remarks }</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>		
			<lable class="table-nodata">
				<c:if test="${DATA.size()=='' }">
					没有数据
				</c:if>
			</lable>		
		</div>
	</div>
	<div class="fixed-btn">
		<button class="btn btn-primary" id="subExcel">导出Excel</button>
		<button onclick="print()" class="btn btn-success" type="button">打印</button>
		<label>合计：${totalList }条</label>
		<label>订金余额：<span>${MC.depcount }元</span></label>
		<label>收款小计：<span>${opdcount }</span></label> 
	</div>
	<script src="${ctxStatic}/jqprint/jquery.jqprint-0.3.js"
		type="text/javascript"></script>
	<script type="text/javascript">
			function print() {
				if(${DATA.size()==0}){
					$.jBox.info("没有可以打印的数据");
					return false;
				}
				$("#div_container").jqprint({
					debug : false, //如果是true则可以显示iframe查看效果（iframe默认高和宽都很小，可以再源码中调大），默认是false
					importCSS : true, //true表示引进原来的页面的css，默认是true。（如果是true，先会找$("link[media=print]")，若没有会去找$("link")中的css文件）
					printContainer : true, //表示如果原来选择的对象必须被纳入打印（注意：设置为false可能会打破你的CSS规则）。
					operaSupport : true
				//表示如果插件也必须支持歌opera浏览器，在这种情况下，它提供了建立一个临时的打印选项卡。默认是true
				});
			}
			
			$("#subExcel").click(function(){
				if(${DATA.size()==0}){
					$.jBox.info("没有可以导出的数据");
					return false;
				}
				jBox.confirm("是否导出Excel表格","导出提示", function (v) {
					if (v) {
					$("#subForm").attr("action","${ctx }/reserve/Reserve/ExportRepairExcel");
					$("#subForm").submit();
					}
		   		}, {showScrolling: false, buttons: {'是': true, '否': false}});
			});
			$("#sub").click(function(){
				$("#subForm").attr("action","${ctx }/reserve/Reserve/query");
				$("#subForm").submit();
			});
			
			
			//此处调用superTables.js里需要的函数
			window.onload=function(){ 
				new superTable("demoTable", {cssSkin : "sDefault",  
					headerRows :1,  //头部固定行数
					onStart : function () {  
					   this.start = new Date(); 
					},  
					onFinish : function () {  
					}  
				}); 
				
				var searchFormW = $(".form-search").width();
				$("#div_container").css({"width":searchFormW+20});//这个宽度是容器宽度，不同容器宽度不同
				$(".fakeContainer").css("height",($(document).height()-100)+"px");//这个高度是整个table可视区域的高度，不同情况高度不同
 				$("#demoTable").css({"width":searchFormW +"!important"});
				//.sData是调用superTables.js之后页面自己生成的  这块就是出现滚动条 达成锁定表头和列的效果				
				$(".sHeader").css("width",($(document).width())+"px");
				$(".sData").css("width",($(document).width())+"px");//这块的宽度是用$("#div_container")的宽度减去锁定的列的宽度
				$(".sData").css("height",($(document).height()-175)+"px");//这块的高度是用$("#div_container")的高度减去锁定的表头的高度
				
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
				var searchFormW = $(".form-search").width();
				$("#div_container").css({"width":searchFormW+20});
				$(".sHeader").css("width",($(document).width()-17)+"px");				
				$(".sData").css("width",($(document).width())+"px");//这块的宽度是用$("#div_container")的宽度减去锁定的列的宽度
				$(".sData").css("height",($(document).height()-175)+"px");
			});
			
			function toShow(reserveId,storeId,depositAmount,tableCount) {
				top.$.jBox.open(
					"iframe:${ctx}/reserve/ordReserveDetails?&reserveId=" + reserveId+"&storeId="+storeId+"&depositAmount="+depositAmount+"&tableCount="+tableCount+"&judge="+1,
					"预订单："+reserveId,
					1000, 
					$(top.document).height() - 180, {
						buttons : {},
						loaded : function(h) {
							$(".jbox-content",top.document).css("overflow-y","hidden");
						}
					});
			}
	</script>
</body>
</html>