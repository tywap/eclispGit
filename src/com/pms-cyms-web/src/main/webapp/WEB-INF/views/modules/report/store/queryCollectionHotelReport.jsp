<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>收银汇总（门店）</title>
	<meta name="decorator" content="default"/>
	<script src="${ctxStatic}/jqprint/jquery.jqprint-0.3.js" type="text/javascript"></script>
	<script src="${ctxStatic}/report/tableForm.js" type="text/javascript"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#wBtn").click(function(){
				top.$.jBox.confirm("确认要导出订单数据吗？","系统提示",function(v,h,f){
					if(v=="ok"){
						$("#searchForm").attr("action","${ctx}/report/collectionHotel/ExportExcel");
						$("#searchForm").submit();
					}
				},{buttonsFocus:1});
				top.$('.jbox-body .jbox-icon').css('top','55px');				
			});
			
			$("#queryOrder").click(function(){
				$("#searchForm").attr("action","${ctx}/report/collectionHotel/queryCollectionHotelReport");
				$("#searchForm").submit();
			});
			/*  var strTime = $('#strTime').val();
			 var endTime = $('#endTime').val();
			 if(strTime == null || strTime == '')
			 {
				 $('#strTime').val('${strTime}') 
			 }
			 if(endTime == null || endTime == '')
			 {
				 $('#endTime').val('${endTime}') 
			 } */
			 
			var dataType = $('#selectA').val();
			var strTime =  $('#strTime').val();
			var endTime =  $('#endTime').val();
			 if(dataType == '1')
			 {
				 $('#ordDateDiv').hide();
				 $('#sysDateDiv').show();
				 if('${strTime}' != null && '${strTime}' != ''){
					 $('#strTime').val('${strTime}');
					 $('#endTime').val('${endTime}');
				 }else{
					 $('#strTime').val(strTime);
					 $('#endTime').val(endTime);
				 }
				
			 }
			 else{
				 $('#sysDateDiv').hide();
				 $('#ordDateDiv').show();
			 }
			
		});
		
		function changeDateCheck(){
			var dataType = $('#selectA').val();
			if(dataType == 1){
				 $('#ordDateDiv').hide();
				 $('#sysDateDiv').show();
			}else{
				 $('#sysDateDiv').hide();
				 $('#ordDateDiv').show();
			}
		}
		function Preview() {
			$("#my_div").jqprint({
				debug : false, //如果是true则可以显示iframe查看效果（iframe默认高和宽都很小，可以再源码中调大），默认是false
				importCSS : true, //true表示引进原来的页面的css，默认是true。（如果是true，先会找$("link[media=print]")，若没有会去找$("link")中的css文件）
				printContainer : true, //表示如果原来选择的对象必须被纳入打印（注意：设置为false可能会打破你的CSS规则）。
				operaSupport : true
			//表示如果插件也必须支持歌opera浏览器，在这种情况下，它提供了建立一个临时的打印选项卡。默认是true
			});
		}
		

		/* function generateDate(){
			$.ajax({
                url:"${ctx}/report/collectionHotel/generateDate",
                type: "post",
                dataType: "json",
                success: function (result) {
                	alert("aa");
           		}
        	});
		} */
		
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
			$(".sHeader").css("width",($(document).width())+"px");				
			$(".sData").css("width",($(document).width())+"px");//这块的宽度是用$("#div_container")的宽度减去锁定的列的宽度
			$(".sData").css("height",($(document).height()-175)+"px");
		})
	</script>
</head>
<body>
	<div id="importBox" class="hide">
	</div>
	<form:form id="searchForm" modelAttribute="order" action="${ctx}/report/collectionHotel/queryCollectionHotelReport" method="post" class="breadcrumb form-search ">
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
				<select name="selectid" style="margin-right:3px;" id="selectA" class="select-medium6" onchange="changeDateCheck()">
					<option value="1" <c:if test="${1==param.selectid}">selected</c:if>>账务日期</option>
					<option value="2" <c:if test="${2==param.selectid}">selected</c:if>>支付日期</option>
				</select>
               <li id="sysDateDiv">
				<input id="strTime" style="margin-right:3px;" name="strTime" type="text" readonly="readonly" maxlength="20" class="input-medium6 Wdate "
                       value="${param.strTime }" pattern="yyyy-MM-dd"
                       onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />-
                <input id="endTime" name="endTime" type="text" readonly="readonly" maxlength="20" class="input-medium6 Wdate "
                value="${param.endTime }" pattern="yyyy-MM-dd"
                onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />
               </li>
               
               <li id="ordDateDiv">
					<input id="startdate" name="startdate" type="text" readonly="readonly" maxlength="20" class="input-medium6 Wdate " style="margin-right:3px;"
	                       value="${param.startdate }" pattern="yyyy-MM-dd HH:mm" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm',isShowClear:false});" />-
	                <input id="enddate" name="enddate" type="text" readonly="readonly" maxlength="20" class="input-medium6 Wdate "
	                value="${param.enddate }" pattern="yyyy-MM-dd HH:mm" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm',isShowClear:false});" />
             </li>
			<li class="btns">
				<button type="button" id="queryOrder" class="btn btn-primary">查询</button>
			</li>
			<!--  <li class="btns"><button id="aaa" class="btn btn-primary" type="button" value="生成数据" onclick="generateDate()" /></li>  -->
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<div id="div_container">
		<div id="my_div" class="fakeContainer first_div">
			<table id="demoTable" class="table table-bordered">	
				<thead>			
					<tr id="my_tr">
						<th rowspan="2" style="text-align: center">酒店</th>
						<th colspan="12" style="text-align: center">操作类型</th>
						<th style="text-align: center">赠送</th>
						<th colspan="${roeSpanNum+1 }" style="text-align: center">收银</th>
					</tr>
					<tr>
						<th style="text-align: center">住客押金</th>
						<th style="text-align: center">住客结账</th>
						<th style="text-align: center">非住客结账</th>
						<th style="text-align: center">预订订金</th>
						<th style="text-align: center">会员发卡</th>
						<th style="text-align: center">会员升级</th>
						<th style="text-align: center">会员充值</th>
						<th style="text-align: center">会员退卡</th>
						<th style="text-align: center">借物押金</th>
						<th style="text-align: center">单位预交</th>
						<th style="text-align: center">挂账结算</th>
						<th style="text-align: center">其它小计</th>
						<th style="text-align: center">充值赠送</th>
						<c:forEach items="${payWayList }" var="p">
							<c:if test="${!p.paramKey.equals('7')}">
								<th style="text-align: center">${p.name }</th>
							</c:if>
						</c:forEach>
						<!-- <th style="text-align: center">现金</th>
						<th style="text-align: center">银行卡</th>
						<th style="text-align: center">微信扫码</th>
						<th style="text-align: center">微信线上支付</th>
						<th style="text-align: center">支付宝扫码</th>
						<th style="text-align: center">支付宝线上支付</th>
						<th style="text-align: center">储值卡</th>
						<th style="text-align: center">预交款</th>
						<th style="text-align: center">挂账</th>
						<th style="text-align: center">减免</th>
						<th style="text-align: center">微信-手工</th>
						<th style="text-align: center">支付宝-手工</th> -->
						<th style="text-align: center">收银小计</th>
					</tr>
				</thead>
				<tbody id="contentTableTbody">
				<c:forEach items="${dataMapList}" var="collection" >
					<tr style="cursor:pointer;">
						<td>${collection.hotelName}</td>
						<td>${collection.guestDeposit }</td>
						<td>${collection.guestCheckOut }</td>
						<td>${collection.unGuestCheckOut }</td>
						<td>${collection.orderDeposit }</td>
						<td>${collection.numberCard }</td>
						<td>${collection.numberUp }</td>
						<td>${collection.numberRecharge }</td>
						<td>${collection.numberBackCard }</td>
						<td>${collection.borrowDeposit }</td>
						<td>${collection.advanceUnit }</td>
						<td>${collection.settleMent }</td>
						<td>${collection.guestDeposit + collection.guestCheckOut +  collection.unGuestCheckOut + collection.orderDeposit + collection.numberCard + collection.numberUp + collection.numberRecharge + collection.numberBackCard + collection.borrowDeposit + collection.advanceUnit + collection.settleMent }</td>
						<td>${collection.topUpGive }</td>
						<c:forEach items="${payWayList }" var="pay">
							<c:if test="${!pay.paramKey.equals('7')}">
								<td>${collection[pay.paramKey]}</td>							
							</c:if>
						</c:forEach>
						<td><fmt:formatNumber type="number" value="${collection.totalAmount}" pattern="0.00" maxFractionDigits="2"/></td>
					</tr>
				</c:forEach>
				<%-- <tr style="cursor:pointer;">
						<td>合计</td>
						<td>${countDate.dpositTotal }</td>
						<td>${countDate.roomSettleTotal }</td>
						<td>${countDate.notRoomFeeTotal }</td>
						<td>${countDate.preDepositTotal }</td>
						<td>${countDate.cardGrantTotal }</td>
						<td>${countDate.cardRaiseTotal }</td>
						<td>${countDate.personTopUpTotal }</td>
						<td>${countDate.cardRefundTotal }</td>
						<td>${countDate.borrowDepositTotal }</td>
						<td>${countDate.groupTopUpTotal }</td>
						<td>${countDate.groupSettleTotal }</td>
						<td>${countDate.operAllTotal }</td>
						<td>${countDate.topUpGiveTotal }</td>
						<td>${countDate.cashTotal }</td>
						<td>${countDate.unionpayTotal }</td>
						<td>${countDate.wechatTotal }</td>
						<td>${countDate.wechatOnlineTotal }</td>
						<td>${countDate.alipayTotal }</td>
						<td>${countDate.alipayOnlineTotal }</td>
						<td>${countDate.personPrePaidTotal }</td>
						<td>${countDate.groupPrePaidTotal }</td>
						<td>${countDate.ownMoneyTotal }</td>
						<td>${countDate.discountTotal }</td>
						<td>${countDate.paymethodAllTotal }</td>
					</tr> --%>				
				</tbody>
				</table>
				<lable class="table-nodata">
					<c:if test="${totalCount == 0}" >
						没有数据
					</c:if>
				</lable>
			</div>
		</div>
		<div class="fixed-btn">
			<button class="btn btn-primary" id="wBtn"  >导出Excel</button>
			<button class="btn btn-primary" onclick ="Preview()" >打印预览</button>
			<label>合计：${totalCount}条</label>
		</div>
		</body>
		</html>