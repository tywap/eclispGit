<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>收银明细查询(第三方)</title>
	<meta name="decorator" content="default" />	
	
	<script src="${ctxStatic}/jqprint/jquery.jqprint-0.3.js" type="text/javascript"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#wBtn").click(function(){
				top.$.jBox.confirm("确认要导出订单数据吗？","系统提示",function(v,h,f){
					if(v=="ok"){
						$("#searchForm").attr("action","${ctx}/report/ordPayment/ExportExcel");
						$("#searchForm").submit();
					}
				},{buttonsFocus:1});
				top.$('.jbox-body .jbox-icon').css('top','55px');				
			});
			
			$("#queryOrder").click(function(){
				$("#searchForm").attr("action","${ctx}/report/ordPayment/queryOrderPayment");
				$("#searchForm").submit();
			});
			 var strTime = $('#strTime').val();
			
			 var endTime = $('#endTime').val();
			 var dataType = $('#dateType').val();
			 if(dataType == '1' && strTime == "")
			 {
				 $('#ordDateDiv').show();
				 $('#sysDateDiv').hide();
				 $('#strTime').val('${strTime}'); 
				 $('#endTime').val('${endTime}');
				
			 }
			 if(dataType == '2'){
				 $('#sysDateDiv').show();
				 $('#ordDateDiv').hide();
			 }
			
		});
		function Preview() {
			$("#my_div").jqprint({
				debug : false, //如果是true则可以显示iframe查看效果（iframe默认高和宽都很小，可以再源码中调大），默认是false
				importCSS : true, //true表示引进原来的页面的css，默认是true。（如果是true，先会找$("link[media=print]")，若没有会去找$("link")中的css文件）
				printContainer : true, //表示如果原来选择的对象必须被纳入打印（注意：设置为false可能会打破你的CSS规则）。
				operaSupport : true
			//表示如果插件也必须支持歌opera浏览器，在这种情况下，它提供了建立一个临时的打印选项卡。默认是true
			});
		}
		
		function changeDateCheck(){
			var dataType = $('#dateType').val();
			if(dataType == 1){
				$('#ordDateDiv').show();
				$('#sysDateDiv').hide();
				$('#strTime').val('${strTime}');
				$('#endTime').val('${endTime}');
				console.log($('#strTime').val(),$('#endTime').val())
			}else{
				$('#sysDateDiv').show();
				$('#ordDateDiv').hide();
				$('#strSysDate').val('');
				$('#endSysDate').val('');
				console.log($('#strSysDate').val(),$('#endSysDate').val());
			}
		}
		
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
			
			var searchFormW = ($(".form-search").width() + 20)+"px";
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
			var searchFormW = ($(".form-search").width() + 20)+"px";
			$("#div_container").css({"width":searchFormW+20});
			$(".sHeader").css("width",($(document).width()-17)+"px");				
			$(".sData").css("width",($(document).width())+"px");//这块的宽度是用$("#div_container")的宽度减去锁定的列的宽度
			$(".sData").css("height",($(document).height()-175)+"px");
		})
		
		function getOrder(orderId){
            top.$.jBox.open(
            	"iframe:${ctx}/order/checkIn/ordTableIndexInit?orderId=" + orderId,
             	"单号："+orderId,
            	$(window).width()-5,
                $(window).height()-7,
                {
	                buttons: {},//"返回":"0"
	                //bottomText: '坐标长沙',
	                /* opacity:0,
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
		}
	</script>
</head>
<body>
	<div id="importBox" class="hide">
	</div>
	<form:form id="searchForm" modelAttribute="order" action="${ctx}/report/ordPayment/queryOrderPayment" method="post" class="breadcrumb form-search ">
		<ul class="ul-form">
			 <li>
			 <label>酒店：</label>
				<select id="storeId" name="storeId" class="select2 select-medium6">
					<option value="">--请选择--</option>
					<c:forEach items="${hotelList}" var="var" varStatus="vs">
                      	<option value="${var.id}" <c:if test="${var.id == param.storeId }">selected ="selected"</c:if>> ${var.name}</option>
                    </c:forEach>
				</select>
			</li> 
			<li>
				<label></label>
				<select id="dateType" style="margin-right:0;" name="dateType"  class="select-medium6" onchange="changeDateCheck()">
						<option value="1" <c:if test="${1==param.dateType}">selected</c:if>>支付时间</option>
						<option value="2" <c:if test="${2==param.dateType}">selected</c:if>>账务日期</option>
				</select>
			</li> 
			<li id="ordDateDiv">
				<label></label>
				<input id="strTime" style="margin-right:3px;" name="strTime" type="text" readonly="readonly" maxlength="20" class="Wdate input-medium6"
                       value="${param.strTime }" pattern="yyyy-MM-dd HH:mm"
                       onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm',isShowClear:false});" />-
                <input id="endTime" name="endTime" type="text" readonly="readonly" maxlength="20" class="input-medium6 Wdate "
                value="${param.endTime }" pattern="yyyy-MM-dd HH:mm"
                onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm',isShowClear:false});" />
             </li>
             <li id="sysDateDiv" style="display: none;"><label></label>
				<input id="strSysDate" style="margin-right:3px;" name="strSysDate" type="text" readonly="readonly" maxlength="20" class="input-medium6 Wdate "
                       value="${param.strSysDate }" pattern="yyyy-MM-dd"
                       onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />-
                <input id="endSysDate" name="endSysDate" type="text" readonly="readonly" maxlength="20" class="input-medium6 Wdate "
                value="${param.endSysDate }" pattern="yyyy-MM-dd"
                onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />
              </li>                
			
			<li>
				<label>班次：</label>
				<select id="shiftId" name="shiftId" class="select-medium6">
					<option value="">全部</option>
					<c:forEach items="${shiftList}" var="var" varStatus="vs">
                      	<option value="${var.id}" <c:if test="${var.id == param.shiftId }">selected ="selected"</c:if>> ${var.shiftName}</option>
                    </c:forEach>
				</select>
			</li> 
			
			<li>
				<label>支付方式：</label>
				<c:if test="${flag != '1'}">
					<select id="payMethod" style="margin-right:0;" name="payMethod" class="select-medium6">
						<option value="">全部</option>
						<c:forEach items="${fns:getSysBusiConfigList('payWay','')}" var="var" varStatus="vs">
	                       	<option value="${var.paramKey}" <c:if test="${var.paramKey == param.payMethod }">selected ="selected"</c:if>> ${var.name}</option>
	                    </c:forEach>
					</select>
				</c:if>
				<c:if test="${flag == '1'}">
					<select id="payMethod" style="margin-right:0;" name="payMethod" class="select-medium6">
						<option value="">全部</option>
	                    <option value="3" <c:if test="${param.payMethod == 3 }">selected="selected"</c:if>>微信</option>
	                    <option value="4" <c:if test="${param.payMethod == 4 }">selected="selected"</c:if>>支付宝</option>
					</select>
				</c:if>
			</li>
			<li>
				<label></label>
				<select id="queryType" style="margin-right:0;" name="queryType" class="select-medium6">
					<option value="1" <c:if test="${param.queryType == 1 }">selected="selected"</c:if> >单号</option>
					<option value="2" <c:if test="${param.queryType == 2 }">selected="selected"</c:if>>房号</option>
					<option value="3" <c:if test="${param.queryType == 3 }">selected="selected"</c:if>>凭证号</option>
					<option value="4" <c:if test="${param.queryType == 4 }">selected="selected"</c:if>>操作员</option>
				</select>
			<li>
				<label></label>
				<input type="text" name="queryName" value="${param.queryName}" id="queryName" htmlEscape="false" maxlength="50" class=" input-medium6"/>
				<input name="flag" class="input-medium6" value=${flag } id="flag" type="hidden"/>
			</li>
			<li>
			    <label>操作类型：</label> 
			    <select id="titleNo" style="margin-right: 0;" name="titleNo" class="select-medium6">
					<option value="">全部</option>
					<option value="3001">会员充值</option>
					<option value="300101">会员充值</option>
					<option value="3005">会员升级费用</option>
					<option value="3002">会员发卡</option>
					<option value="3006">会员退卡</option>
					<option value="1006">借用押金</option>
					<option value="300101">充值金额</option>
					<option value="3000103">制卡费</option>
					<option value="4003">单位预交</option>
					<option value="3007">在线充值</option>
					<option value="3000102">开卡充值金额</option>
					<option value="1002">房单押金</option>
					<option value="5002">房单押金</option>
					<option value="5002">房单预授权</option>
					<option value="4004">挂账结算</option>
					<option value="2002">结账退房</option>
					<option value="1003">联单押金</option>
					<option value="5001">联单预授权</option>
					<option value="2001">部分结账</option>
					<option value="2003">非住客账</option>
					<option value="1001">预定订金</option>
			    </select>
			<li class="btns">
				<!-- <input id="queryOrder" class="btn btn-primary " type="submit" value="查询" /> -->
				<button type="button" id="queryOrder" class="btn btn-primary">查询</button>
			</li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<div id="div_container">
		<div id="my_div" class="fakeContainer first_div">
			<table id="demoTable" class="table table-bordered">
				<thead>
					<tr id="my_tr">
						<th>酒店</th>
						<th>入账时间</th>
						<th>账务日期</th>
						<th>单号</th>
						<th>房号</th>
						<th>类型</th>
						<th>支付方式</th>
						<th>收款金额</th>
						<th>班次</th>
						<th>操作员</th>
						<th>支付流水</th>
						<th>支付凭证</th>
						<th>备注</th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${totalCount != 0 }">
						<c:forEach items="${ordPaymentList}" var="order" >
							<tr style="cursor:pointer;">
								<td>${order.hotelName}</td>
								<td><fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm"/></td>
								<td>${order.accountDate}</td>
								<td><a onclick="getOrder('${order.orderId}')">${order.orderId}</a></td>
								<td title="${order.roomNo}">${fn:substring(order.roomNo, 0, 20)}   </td>
								<td>${order.titleName}</td>
								<td>${order.payMethodName}</td>
								<td>${order.amount}</td>
								<td>${order.shiftName}</td> 
								<td>${order.createName}</td>
								<td>${order.payId}</td>
								<td>${order.payVoucher}</td>
								<td>${order.remarks}</td>
							</tr>
						</c:forEach>
					</c:if>

				</tbody>
			</table>
			<lable class="table-nodata">
				<c:if test="${totalCount == 0}">
					没有数据
				</c:if>
			</lable>
			</div>
		</div>
		<div class="fixed-btn">
			<button class="btn btn-primary" id="wBtn"  >导出Excel</button>
			<button class="btn btn-primary" onclick ="Preview()" >打印预览</button>
			<label>合计：${totalCount}条</label>
			<label>金额：<span>${amountSum}元</span></label>
		</div>
		</body>
		</html>