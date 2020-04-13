<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>备用金明细查询</title>
	<meta name="decorator" content="default" />	
	
	<script src="${ctxStatic}/jqprint/jquery.jqprint-0.3.js" type="text/javascript"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#wBtn").click(function(){
				top.$.jBox.confirm("确认要导出订单数据吗？","系统提示",function(v,h,f){
					if(v=="ok"){
						$("#searchForm").attr("action","${ctx}/report/ordSpareFund/ExportExcel");
						$("#searchForm").submit();
						$("#searchForm").attr("action","${ctx}/report/ordSpareFund/queryOrdSpareFund");
					}
				},{buttonsFocus:1});
				top.$('.jbox-body .jbox-icon').css('top','55px');				
			});
			
			$("#queryOrder").click(function(){
				$("#searchForm").attr("action","${ctx}/report/ordSpareFund/queryOrdSpareFund");
				$("#searchForm").submit();
			});
			 var strTime = $('#strTime').val();
			 var endTime = $('#endTime').val();
			 var queryType = $('#queryType').val();
			 if(queryType == '1' && strTime == "")
			 {
				 $('#sysDateDiv').show();
				 $('#ordDateDiv').hide();
				 $('#strTime').val('${strTime}'); 
				 $('#endTime').val('${endTime}');
				
			 }
			 if(queryType == '2'){
				 $('#sysDateDiv').hide();
				 $('#ordDateDiv').show();
			 }
			//加载分店
			loadSelect("companyCheckDiv","${ctx}/sys/userutils/getOfficeListByType",{typesJson:"['3','4','5']"},'${param.storeId}','id','name');
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
			var queryType = $('#queryType').val();
			if(queryType == 1){
				$('#ordDateDiv').hide();
				$('#sysDateDiv').show();
				$('#strTime').val('${strTime}');
				$('#endTime').val('${endTime}');
				console.log($('#strTime').val(),$('#endTime').val())
			}else{
				$('#sysDateDiv').hide();
				$('#ordDateDiv').show();
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
		
	</script>
</head>
<body>
	<div id="importBox" class="hide">
	</div>
	<form:form id="searchForm" modelAttribute="order" action="${ctx}/report/ordPayment/queryOrderPayment" method="post" class="breadcrumb form-search ">
		<ul class="ul-form">
			<li>
		 		<label>分店：</label>
				<select id="companyCheckDiv" class="input-medium6" name="storeId" onchange="getshiftListByStoreId()">
			 	</select>
		 	</li>
			<li>
				<label></label>
				<select id="queryType" style="margin-right:0;" name="queryType"  class="select-medium6" onchange="changeDateCheck()">
						<option value="1" <c:if test="${1==param.queryType}">selected</c:if>>账务日期</option>
						<option value="2" <c:if test="${2==param.queryType}">selected</c:if>>操作时间</option>
				</select>
			</li> 
			<li id="ordDateDiv"  style="display: none;">
				<label></label>
				<input id="strSysDate" style="margin-right:3px;" name="strSysDate" type="text" readonly="readonly" maxlength="20" class="Wdate input-medium6"
                       value="${param.strSysDate }" pattern="yyyy-MM-dd HH:mm"
                       onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm',isShowClear:false,<shiro:lacksPermission name="report:all">minDate:'${reportMinQueryDate}'</shiro:lacksPermission>});" />-
                <input id=endSysDate name="endSysDate" type="text" readonly="readonly" maxlength="20" class="input-medium6 Wdate "
                value="${param.endSysDate }" pattern="yyyy-MM-dd HH:mm"
                onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm',isShowClear:false,<shiro:lacksPermission name="report:all">minDate:'${reportMinQueryDate}'</shiro:lacksPermission>});" />
               </li>
               <li id="sysDateDiv"><label></label>
				<input id="strTime" style="margin-right:3px;" name="strTime" type="text" readonly="readonly" maxlength="20" class="input-medium6 Wdate "
                       value="${param.strTime }" pattern="yyyy-MM-dd"
                       onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false,<shiro:lacksPermission name="report:all">minDate:'${reportMinQueryDate}'</shiro:lacksPermission>});" />-
                <input id="endTime" name="endTime" type="text" readonly="readonly" maxlength="20" class="input-medium6 Wdate "
                value="${param.endTime }" pattern="yyyy-MM-dd"
                onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false,<shiro:lacksPermission name="report:all">minDate:'${reportMinQueryDate}'</shiro:lacksPermission>});" />
              </li>                
			
			
			<li>
				<label>支付方式：</label>
				<select id="payMethod" style="margin-right:0;" name="payMethod" class="select-medium6">
					<option value="">全部</option>
					<c:forEach items="${fns:getSysBusiConfigList('payWay','')}" var="var" varStatus="vs">
                       	<option value="${var.paramKey}" <c:if test="${var.paramKey == param.payMethod }">selected ="selected"</c:if>> ${var.name}</option>
                    </c:forEach>
				</select>
			</li>
			<li>
				<label>变动方式：</label>
				<select id="operType" style="margin-right:0;" name="operType" class="select-medium6">
					<option value="">全部</option>
					<option value="上缴" <c:if test="${param.operType == '上缴' }">selected="selected"</c:if> >备用金上缴</option>
					<option value="下放" <c:if test="${param.operType == '下放' }">selected="selected"</c:if>>备用金下放</option>
				</select>
			</li>
			<li class="btns">
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
						<th>账务日期</th>
						<th>上缴日期</th>
						<th>班次</th>
						<th>操作员</th>
						<th>支付方式</th>
						<th>金额</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${ordSpareFundList}" var="order" >
						<tr style="cursor:pointer;">
							<td>${order.hotelName}</td>
							<td>${order.accountDate}</td>
							<td><fmt:formatDate value="${order.createDate}" pattern="yyyy-MM-dd HH:mm"/></td>
							<td>${order.shiftName}</td>
							<td>${order.userName}</td>
							<td>${order.payMethodName}</td>
							<td>${order.amount}</td>
							<td>${order.operType}</td>
						</tr>
					</c:forEach>

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