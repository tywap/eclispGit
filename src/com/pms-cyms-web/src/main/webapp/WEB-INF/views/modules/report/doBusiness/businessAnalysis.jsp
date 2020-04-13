<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>营业分析表</title>
	<meta name="decorator" content="default"/>
	<script src="${ctxStatic}/jqprint/jquery.jqprint-0.3.js" type="text/javascript"></script>
	<script type="text/javascript">
	var storeName=  $("#storeId option:selected").text();
		//事件名称保持唯一，这里直接用tabId
	    var eventName="${param.tabPageId}";
	  	//解绑事件
        top.$.unsubscribe(eventName);
        //注册事件，弹出页面需要刷新本页面，或者弹出页面回传数据用
        top.$.subscribe(eventName, function (e, data) {
            //data  可以通过这个对象来回传数据
            $("#searchForm").submit();
        });
		$(document).ready(function() {
			//加载分店
	        loadSelect("storeId","${ctx}/sys/userutils/getOfficeListByType",{typesJson:"['3','4','5']"},'${selectStoreId}','id','name'); 
			
			/* $("#btnSubmit").bind("click", function() {
				var storeId=  $("#storeId option:selected").val();
				if (storeId =='') {
					layer.confirm('请先选择分店！');
					return false;
				}
			}); */
			
			//checkbox单选
			$("input[name='weeks']").click(function(){
				stopBubbling(event);
			});
			
			changeDateCheck();

		});
		
		function startChange(){
			if($('#selectA').val()==""){
				$.jBox.info("请选择日期类型");
			}
		}
		
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
		
		function changeDateCheck(){
			 var strTime = $('#startDate').val();
			 var endTime = $('#endtDate').val();
			 if(strTime == null || strTime == '')
			 {
				 $('#strTime').val('${startDate}') 
			 }
			 if(endTime == null || endTime == '')
			 {
				 $('#endTime').val('${endtDate}') 
			 }
		}
	</script>
	<style type="text/css">
	.select-medium6{
	width: 80px;
	margin-left: 5px;
	};
	#roleId option{
	width: 80px;
	}
	select:{
	width: auto;
	padding: 0 2%;
	margin: 0;
	}
	option{
	text-align:center;
	}
	.selectedTr{background-color: #FF9900}
	</style>
</head>
<body>
	<form:form id="searchForm" modelAttribute="dayOrder" action="${ctx}/report/businessAnalysis/list" method="post" class="breadcrumb form-search ">
		<ul class="ul-form">
			<li>
			 	<label>分店：</label>
				<select id="storeId" name="storeId" class="select2 select-medium6" style="width: 110px;" onchange="searchChange(this)">
					<c:if test="${storeName == null}">
					<option>--请选择--</option>
					</c:if>
					<c:if test="${storeName.storeName != ''}">
					<option>${storeName.storeName }</option>
					</c:if>
				</select>
			</li> 
			<li>
				<label></label>
				<select id="dateType" style="margin-right:0; width: 100px;" name="dateType"  class="select-medium6"  >
						<option value="0" <c:if test="${0==param.dateType}">selected</c:if>>按日统计</option>
						<option value="1" <c:if test="${1==param.dateType}">selected</c:if>>按月统计</option>
				</select>
			</li> 
			<li>
				<label></label>
				<input id="startDate" style="margin-right:3px;" name="startDate" type="text" readonly="readonly" maxlength="20" class="Wdate input-medium6"
                    value="${startDate }" pattern="yyyy-MM-dd"
                    onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true,minDate:'${reportMinQueryDate}'});"
                     />-
                <input id="endDate" name="endDate" type="text" readonly="readonly" maxlength="20" class="input-medium6 Wdate "
	                value="${endDate }" pattern="yyyy-MM-dd"
	                onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true,minDate:'${reportMinQueryDate}'});"
	                />
             </li>
			<li class="btns">
				<button type="submit" id="btnSubmit" class="btn btn-primary" >查询</button>
			</li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<div id="my_div" class="fakeContainer first_div" style="overflow:auto;">
		<table class="table table-bordered center" id="demoTable">
		<thead>
			<tr id="my_tr">
				<th rowspan="2">分店</th>
				<th colspan="10" >开台情况</th>
				<th colspan="${fn:length(foodTypeList)}">消费（按小类）</th>
				<th colspan="4" >预收账款</th>
				<th colspan="${fn:length(payWayList)}">收款（按支付方式）</th>
			</tr>
			<tr>
			<th>日期</th>
			<th>折前销售额</th>
			<th>折后销售额</th>
			<th>折扣金</th>
			<th>折扣率</th>
			<th>用餐人数</th>
			<th>人均</th>
			<th>桌数</th>
			<th>桌均</th>
			<th>开台率</th>
			<c:forEach items="${foodTypeList}" var="foodType" >
				<th>${foodType.key}</th>
			</c:forEach>
			<th>小计</th>
			<th>会员储值</th>
			<th>单位预交</th>
			<th>预交订金</th>
			<c:forEach items="${payWayList}" var="payWay" >
				<th>${payWay.key}</th>
			</c:forEach>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${tableCountList}" var="table" varStatus="ordStatus">
				<tr>
				<td>${table.storeName}</td>
				<td>${table.accountDate}</td>
				<td>${table.originalAmount}</td>
				<td>${table.salesAmount}</td>
				<td>${table.optimalFreeGold}</td>
				<td>${table.optimalRate}</td>
				<td>${table.useCount}</td>
				<td>${table.rearUseAvg}</td>
				<td>${table.orderCount}</td>
				<td>${table.rearTableAvg}</td>
				<td>${table.foundingRate}</td>
				<c:forEach items="${foodTypeList}" var="foodTypes" >
					<c:forEach items="${table.foodTypePrice}" var="price" >
						<c:if test="${foodTypes.key == price.key}">
							<td>${price.value}</td>
						</c:if>
					</c:forEach> 
				</c:forEach>
				<%-- <c:forEach items="${table.foodTypePrice}" var="price" >
					<td>${price.value}</td>
				</c:forEach> --%>
				<td>1</td>
				<td>2</td>
				<td>3</td>
				<td>4</td>
				<c:forEach items="${payWayList}" var="payWays" >
					<c:forEach items="${table.payWayPrice}" var="pay" >
						<c:if test="${payWays.key == pay.key}">
							<td>${pay.value}</td>
						</c:if>
					</c:forEach>
				</c:forEach>
				<%-- <c:forEach items="${table.payWayPrice}" var="pay" >
					<td>${pay.value}</td>
				</c:forEach> --%>
			</tr>
		</c:forEach>
		</tbody>
	</table>
</div>
</body>
</html>