<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>营业日报</title>
    <meta name="decorator" content="default"/>   
    <style>
        [class*="span"]{margin-left: 0;}
        .table tr td label{text-align:right;display:block;}
        .table tfoot tr td label{color:#006DCC;font-weight:bold;}
    </style>
    <script src="${ctxStatic}/jqprint/jquery.jqprint-0.3.js" type="text/javascript"></script>
    <script type="text/javascript">
    $(document).ready(function() {
    	
    	//加载分店
        loadSelect("storeId","${ctx}/sys/userutils/getOfficeListByType",{typesJson:"['3','4','5']"},'${selectStoreId}','id','name'); 
		
    })
    
     //此处调用superTables.js里需要的函数
		window.onload=function(){ 
			new superTable("demoTable", {
				cssSkin : "sDefault",  
				headerRows :1,  //头部固定行数
				fixedCols :2,
				onStart : function () {  
				   this.start = new Date(); 
				},  
				onFinish : function () {  
				}  
			}); 
			

			var searchFormW = ($(".form-search").width() + 20)+"px";
			$("#div_container").css({"width":searchFormW+20});//这个宽度是容器宽度，不同容器宽度不同
			$(".fakeContainer").css("height",($(document).height()-110)+"px");//这个高度是整个table可视区域的高度，不同情况高度不同
				$("#demoTable").css({"width":searchFormW +"!important"});
			//.sData是调用superTables.js之后页面自己生成的  这块就是出现滚动条 达成锁定表头和列的效果				
			$(".sHeader").css("width",($(document).width()-20)+"px");
			$(".sData").css("width",($(document).width()-137)+"px");//这块的宽度是用$("#div_container")的宽度减去锁定的列的宽度
			$(".sData").css("height",($(document).height()-140)+"px");//这块的高度是用$("#div_container")的高度减去锁定的表头的高度
			
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
			console.log(searchFormW);
			$("#div_container").css({"width":searchFormW+20});
			$(".sHeader").css("width",($(document).width())+"px");				
			$(".sData").css("width",($(document).width())+"px");//这块的宽度是用$("#div_container")的宽度减去锁定的列的宽度
			$(".sData").css("height",($(document).height()-175)+"px");
		}) 
    </script>
    <style>
    	.breadcrumb{
    		margin-bottom: 0;
    	}
    </style>
</head>
<body>
<form:form id="searchForm" modelAttribute="order" action="${ctx}/report/dailyPaper/list" method="post" class="breadcrumb form-search ">
	<ul class="ul-form">
		<li>
			 	<label>分店：</label>
				<select id="storeId" name="storeId" class="select2 select-medium6" style="width: 110px;">
					<c:if test="${storeName == null}">
					<option>--请选择--</option>
					</c:if>
					<c:if test="${storeName.storeName != ''}">
					<option>${storeName.storeName }</option>
					</c:if>
				</select>
			</li> 
		<li>
				<label>日期</label>
				<input id="dateTime" style="margin-right:3px;" name="date" type="text" readonly="readonly" maxlength="20" class="Wdate input-medium6"
                    value="${accountDate}" pattern="yyyy-MM-dd"
                    onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true,minDate:'${reportMinQueryDate}'});"
                     />
             </li>
		<li class="btns">
			<button type="submit" id="queryOrder" class="btn btn-primary">查询</button>
		</li>
	</ul>
    </form:form>
   <div id="div_container">
		<div id="my_div" class="fakeContainer first_div" style="width: 60%;float:left">
			<table class="table table-bordered center" id="demoTable">
			<thead></thead>
				<tr id="my_tr">
                <th  colspan="2"></th>
                <th  colspan="2">当日</th>
                <th  colspan="2">本月累计</th>
            </tr>
            <tbody>
             <tr>
                <th rowspan="9">开台情况</th>
                <th>折前销售额</th>
                <th colspan="2">${tableCount.originalAmount }</th>
                <th colspan="2">${monthTableCount.originalAmount }</th>
            </tr>
              <tr>
                <th>折后销售额</th>
                <th colspan="2">${tableCount.salesAmount }</th>
                <th colspan="2">${monthTableCount.salesAmount }</th>
            </tr>
            <tr>
                <th>折扣金</th>
                <th colspan="2">${tableCount.optimalFreeGold }</th>
                <th colspan="2">${monthTableCount.optimalFreeGold }</th>
            </tr>
            <tr>
                <th>折扣率</th>
                <th colspan="2">${tableCount.optimalRate }</th>
                <th colspan="2">${monthTableCount.optimalRate }</th>
            </tr>
            <tr>
                <th>人数</th>
                <th colspan="2">${tableCount.useCount }</th>
                <th colspan="2">${monthTableCount.useCount }</th>
            </tr>
            <tr>
                <th>人均（折后）</th>
                <th colspan="2">${tableCount.rearUseAvg }</th>
                <th colspan="2">${monthTableCount.rearUseAvg }</th>
            </tr>
            <tr>
                <th>桌数</th>
                <th colspan="2">${tableCount.orderCount }</th>
                <th colspan="2">${monthTableCount.orderCount }</th>
            </tr>
            <tr>
                <th>桌均（折后）</th>
                <th colspan="2">${tableCount.rearTableAvg }</th>
                <th colspan="2">${monthTableCount.rearTableAvg }</th>
            </tr>
            <tr>
                <th>开台率</th>
                <th colspan="2">${tableCount.foundingRate }</th>
                <th colspan="2">${monthTableCount.foundingRate }</th>
            </tr>
          <tr>
          	<th rowspan="${fn:length(incomeList)+2}">收入</th>
          	<th>消费类别</th>
          	<th>折前</th>
          	<th>折后</th>
          	<th>折前</th>
          	<th>折后</th>
          </tr>
          <tr>
          	<th>小计</th>
       	    <th>${income.originalDayAmount }</th>
       	    <th>${income.salesDayAmount }</th>
       	    <th>${income.originalAmount }</th>
       	    <th>${income.salesAmount }</th>
          </tr>
          <c:forEach items="${incomeList }" var="foodType">
	          <tr>
	       	    <th>${foodType.foodTypeName }</th>
	       	    <th>${foodType.originalDayAmount }</th>
       	    	<th>${foodType.salesDayAmount }</th>
       	    	<th>${foodType.originalAmount }</th>
       	    	<th>${foodType.salesAmount }</th>
	       	  </tr>
          </c:forEach>
		</tr>
		<tr>
          	<th rowspan="4">预收账款</th>
          	<th>小计</th>
            <th ></th>
            <th ></th>
          	<th></th>
          	<th></th>
          </tr>
          <tr>
          	<th>会员储值</th>
            <th ></th>
            <th ></th>
          	<th></th>
          	<th></th>
          </tr>
          <tr>
          	<th>单位预交</th>
            <th ></th>
            <th ></th>
          	<th></th>
          	<th></th>
          </tr>
          <tr>
          	<th>预交定金</th>
            <th ></th>
            <th ></th>
          	<th></th>
          	<th></th>
          </tr>
          <tr>
          	<th rowspan="${fn:length(payList)+2}">收款</th>
          	<th>支付方式</th>
          	<th>收款金额</th>
          	<th>占比</th>
          	<th>收款金额</th>
          	<th>占比</th>
          </tr>
          <tr>
          	<th>小计</th>
       	    <th>${subtotalPay.dayAmount }</th>
       	    <th>${subtotalPay.dyaProportion }</th>
       	    <th>${subtotalPay.monthAmount }</th>
       	    <th>${subtotalPay.monthProportion }</th>
          </tr>
          <c:forEach items="${payList }" var="pay">
	          <tr>
	       	    <th>${pay.payMethodName }</th>
	       	    <th>${pay.dayAmount }</th>
       	    	<th>${pay.dayProportion }</th>
       	    	<th>${pay.amount }</th>
       	    	<th>${pay.monthProportion }</th>
	       	  </tr>
          </c:forEach>
		</tr>
       	 </tbody>
    </table>
   </table>
		<lable style="display:block;text-align:center;font-weight:bold;color:#b94a48;"> 
			<c:if test="${DATA.size()=='' }">
				没有数据
			</c:if> 
		</lable>
	</div>
	</div>
</body>
</html>