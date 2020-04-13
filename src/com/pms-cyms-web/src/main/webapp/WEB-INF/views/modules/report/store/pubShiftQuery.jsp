<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>交班记录</title>
	<meta name="decorator" content="default"/>
	<script src="${ctxStatic}/jqprint/jquery.jqprint-0.3.js" type="text/javascript"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#wBtn").click(function(){
				top.$.jBox.confirm("确认要导出交班记录信息吗？","系统提示",function(v,h,f){
					if(v=="ok"){
						$("#searchForm").attr("action","${ctx}/report/pubShift/ExportExcel");
						$("#searchForm").submit();
					}
				},{buttonsFocus:1});
				top.$('.jbox-body .jbox-icon').css('top','55px');				
			});
			$("#queryOrder").click(function(){
				$("#searchForm").attr("action","${ctx}/report/pubShift/query");
				$("#searchForm").submit();
			});
			
			 var shiftStrTime = $('#shiftStrTime').val();
			 var shiftEndTime = $('#shiftEndTime').val();
			 if( shiftStrTime == '' || shiftStrTime == null)
			 {
				 $('#shiftStrTime').val('${shiftStrTime}');
				 $('#shiftEndTime').val('${shiftEndTime}');
			 }
			 
			//加载分店
	        loadSelect("companyCheckDiv","${ctx}/sys/userutils/getOfficeListByType",{typesJson:"['3','4','5']"},'${param.storeId}','id','name');
		});
		
		//此处调用superTables.js里需要的函数
		window.onload=function(){ 
			new superTable("demoTable", {
				cssSkin : "sDefault",  
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
			$(".sHeader").css("width",($(document).width())+"px");				
			$(".sData").css("width",($(document).width())+"px");//这块的宽度是用$("#div_container")的宽度减去锁定的列的宽度
			$(".sData").css("height",($(document).height()-175)+"px");
		})
		
		//查看详情
	   function  showInfo(shiftId) {
	        top.$.jBox.open(
	            "iframe:${ctx}/order/ordPaymentFund/queryByShiftId?shiftId="+shiftId,
	            "班次收銀明细",
	            1000,
	            $(top.document).height() - 180,
	            {
	                buttons: {},
	                loaded: function (h) {
	                    $(".jbox-content", top.document).css("overflow-y", "hidden");
	                }
	            }
	        );
	    };
	    
	    function printByShiftId(id){
	    	window.open("${ctx}/print/printOrdCashBox?shiftId="+id);
	    }
	</script>
</head>
<body>
	<form:form id="searchForm" modelAttribute="order" action="${ctx}/report/pubShift/query" method="post" class="breadcrumb form-search ">
		<ul class="ul-form">
				<li>
			 		<label>分店：</label>
					<select id="companyCheckDiv" class="input-medium6" name="storeId" onchange="getshiftListByStoreId()">
				 	</select>
			 	</li>
               	<li >
	               	<label>交班时间：</label>
					<input id="shiftStrTime" name="shiftStrTime" type="text" readonly="readonly" maxlength="20" class="input-medium6 Wdate " style="margin-right:3px;"
	                       value="${param.shiftStrTime }" pattern="yyyy-MM-dd HH:mm"
	                       onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm',isShowClear:false,<shiro:lacksPermission name="report:all">minDate:'${reportMinQueryDate}'</shiro:lacksPermission>});" />-
	                <input id="shiftEndTime" name="shiftEndTime" type="text" readonly="readonly" maxlength="20" class="input-medium6 Wdate "
	                value="${param.shiftEndTime }" pattern="yyyy-MM-dd HH:mm"
	                onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm',isShowClear:false,<shiro:lacksPermission name="report:all">minDate:'${reportMinQueryDate}'</shiro:lacksPermission>});" />
	                </li>
				<li>
				<label>交班班次：</label>
				<select id="shiftId" name="shiftId" class="select-medium6">
					<option value="">全部</option>
					<c:forEach items="${shiftList}" var="var" varStatus="vs">
                      	<option value="${var.id}" <c:if test="${var.id == param.shiftId }">selected ="selected"</c:if>> ${var.shiftName}</option>
                    </c:forEach>
				</select>
			</li> 
			<li>
				<label>交班员工：</label>
				<select id="shiftCloseBy" name="shiftCloseBy" class="select-medium6">
					<option value="">全部</option>
					<c:forEach items="${closeNameList}" var="var" varStatus="vs">
                      	<option value="${var.shiftCloseBy}" <c:if test="${var.shiftCloseBy == param.shiftCloseBy }">selected ="selected"</c:if>> ${var.shiftCloseBy}</option>
	                </c:forEach>
				</select>
			</li>
			<li>
				<label>接班班次：</label>
				<select id="nextShiftId" name="nextShiftId" class="select-medium6">
					<option value="">全部</option>
					<c:forEach items="${shiftList}" var="var" varStatus="vs">
                      	<option value="${var.id}" <c:if test="${var.id == param.nextShiftId }">selected ="selected"</c:if>> ${var.shiftName}</option>
                    </c:forEach>
                </select>
				</li>
			<li>
			<li>
				<label>接班员工：</label>
				<select id="shiftReceiveBy" name="shiftReceiveBy" class="select-medium6">
					<option value="">全部</option>
					<c:forEach items="${receiveNameList}" var="var" varStatus="vs">
                       	<option value="${var.shiftReceiveBy}" <c:if test="${var.shiftReceiveBy == param.shiftReceiveBy }">selected ="selected"</c:if>> ${var.shiftReceiveBy}</option>
                    </c:forEach>
                </select>
				</li>
			<li>
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
						<th>班次交班时间</th>
						<th>交班班次</th>
						<th>交班人</th>
						<th>接班班次</th>
						<th>接班人</th>
						<th>备用金</th>
						<th>上班转入</th>
						<th>本班实收</th>
						<th>交接下班</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${dataList}" var="d" >
						<tr style="cursor:pointer;">
							<td><fmt:formatDate value="${d.shiftCloseDate}" pattern="yyyy-MM-dd HH:mm"/></td>
							<td>${d.shiftName}</td>
							<td>${d.shiftCloseBy}</td>
							<td>${d.nextShiftName}</td>
							<td>${d.shiftReceiveBy}</td>
							<td>${d.spareDown}</td>
							<td>${d.preTransfer}</td>
							<td>${d.changeMoney}</td>
							<td>${d.totalMoney}</td>
							<td><a  href="#" onclick="showInfo('${d.id}')">详情</a>
								<a  href="#" onclick="printByShiftId('${d.id}')">打印</a>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
	<div class="fixed-btn">
	<button class="btn btn-primary" id="wBtn" >导出Excel</button>
</div>
</body>
</html>