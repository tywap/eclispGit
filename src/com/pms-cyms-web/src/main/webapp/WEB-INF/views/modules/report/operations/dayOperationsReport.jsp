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
    <script type="text/javascript">
    $(document).ready(function() {
    	$("#queryOrder").click(function(){
    		$("#searchForm").attr("action","${ctx}/report/ordCashbox/query");
    		$("#searchForm").submit();
    	});
    })
    //此处调用superTables.js里需要的函数
		window.onload = function () {
		    new superTable("demoTable", {
		        cssSkin: "sDefault",
		        fixedCols: 2, //固定几列
		        headerRows: 1,  //头部固定行数
		        onStart: function () {
		            this.start = new Date();
		        },
		        onFinish: function () {
		        }
		    });		 		 
		    $("#div_container").css("width", $(document).width());//这个宽度是容器宽度，不同容器宽度不同
		    $(".fakeContainer").css("height", $(document).height()-107);//这个高度是整个table可视区域的高度，不同情况高度不同
		    //.sData是调用superTables.js之后页面自己生成的  这块就是出现滚动条 达成锁定表头和列的效果
		    $(".sHeader").css("width", $(document).width()-17);
		    $(".sData").css("width", $(document).width()-138);//这块的宽度是用$("#div_container")的宽度减去锁定的列的宽度
		    $(".sData").css("height", $(document).height()-138);//这块的高度是用$("#div_container")的高度减去锁定的表头的高度		 
		    //目前谷歌  ie8+  360浏览器均没问题  有些细小的东西要根据项目需求改		 
		    //有兼容问题的话可以在下面判断浏览器的方法里写
		    if (navigator.appName == "Microsoft Internet Explorer" && navigator.appVersion.match(/9./i) == "9.") {//alert("IE 9.0");		 
		    } else if (!!window.ActiveXObject || "ActiveXObject" in window) {//alert("IE 10"); 
		    } else {//其他浏览器
		        //alert("其他浏览器");
		    }
		}
    
    </script>
    <style>
    	.breadcrumb{
    		margin-bottom: 0;
    	}
    </style>
</head>
<body>
<form:form id="searchForm" modelAttribute="order" action="${ctx}/report/ordCashbox/query" method="post" class="breadcrumb form-search ">
	<ul class="ul-form">
		<li> <label>班次：</label>
			<select id="shiftId" name="shiftId" class="select-medium6">
				<option value="">全部</option>
				<c:forEach items="${shiftList}" var="var" varStatus="vs">
                     	<option value="${var.id}" <c:if test="${var.id == shiftId }">selected ="selected"</c:if>> ${var.shiftName}</option>
                 </c:forEach>
			</select>
		</li>
		<li>  <label>员工：</label>
			<select id="createId" name="createId" class="select-medium6">
				<option value="">全部</option>
				<c:forEach items="${userList}" var="var" varStatus="vs">
                     	<option value="${var.userId}" <c:if test="${var.userId == param.createId }">selected ="selected"</c:if>> ${var.name}</option>
                 </c:forEach>
			</select>
		</li>
		<li class="btns">
			<button type="button" id="queryOrder" class="btn btn-primary">查询</button>
		</li>
	</ul>
    </form:form>
   <div id="div_container">
		<div id="my_div" class="fakeContainer first_div">
			<table class="table table-bordered center" id="demoTable">
				<thead>
					<tr id="my_tr">
                <th colspan="2">类型</th>
                <c:forEach items="${payWayList }" var="pay">
                	<c:if test="${pay.paramKey != 7 }">
                		<th>${pay.name }</th>
                	</c:if>
                </c:forEach>
                <th style="min-width:55px;">合计</th>
            </tr>
            </thead>
            <tbody>
             <tr>
                <th rowspan="3">钱箱周转</th>
                <th>备用金</th>
                <c:forEach items="${ordCashBoxTotal }" var="OrdCashBox">
                	<td>${OrdCashBox.spareDown }</td>
                </c:forEach>
                <th><fmt:formatNumber value="${spareDownTotal }" pattern="0.00" maxFractionDigits="2"/></th>
            </tr>
              <tr>
                <th>上班转入</th>
                <c:forEach items="${ordCashBoxTotal }" var="OrdCashBox">
                	<td>${OrdCashBox.preTransfer }</td>
                </c:forEach>
                <th><fmt:formatNumber value="${preTransferTotal }" pattern="0.00" maxFractionDigits="2"/></th>
            </tr>
            <tr>
                <th>本班上缴</th>
                <c:forEach items="${ordCashBoxTotal }" var="OrdCashBox">
                	<td>${OrdCashBox.spareUp }</td>
                </c:forEach>
                <th><fmt:formatNumber value="${spareUpTotal }" pattern="0.00" maxFractionDigits="2"/></th>
            </tr>
            <%-- <tr>
                <th>交接下班</th>
                <c:forEach items="${ordCashBoxTotal }" var="OrdCashBox">
                	<td>${OrdCashBox.changeMoney + OrdCashBox.spareUp + OrdCashBox.preTransfer + OrdCashBox.spareDown}</td>
                </c:forEach>
                <th>${changeMoneyTotal }</th>
          </tr> --%>
          <tr>
          	<th rowspan="13">实收</th>
          	<th>住客押金</th>
          	<c:forEach items="${payMentTotal }" var="gd">
                	<td>${gd.guestDeposit }</td>
             </c:forEach>
           	<th><fmt:formatNumber value="${totalMap.guestDeposit}" pattern="0.00" maxFractionDigits="2"/></th>
          </tr>
          <tr>
       	    <th>住客结账</th>
       	    <c:forEach items="${payMentTotal }" var="gc">
                	<td>${gc.guestCheckOut }</td>
             </c:forEach>
           	<th><fmt:formatNumber value="${totalMap.guestCheckOut }" pattern="0.00" maxFractionDigits="2"/></th>
       	  </tr>
       	  <tr>
       	    <th>预订订金</th>
       	     <c:forEach items="${payMentTotal }" var="od">
                	<td>${od.orderDeposit }</td>
             </c:forEach>
          
           	<th><fmt:formatNumber value="${totalMap.orderDeposit }" pattern="0.00" maxFractionDigits="2"/></th>
       	  </tr>
       	  <tr>
       	    <th>非住客账</th>
       	     <c:forEach items="${payMentTotal }" var="gco">
                	<td>${gco.unGuestCheckOut }</td>
             </c:forEach>
          
           	<th><fmt:formatNumber value="${totalMap.unGuestCheckOut }" pattern="0.00" maxFractionDigits="2"/></th>
       	  </tr>
       	  <tr>
       	    <th>会员发卡</th>
       	     <c:forEach items="${payMentTotal }" var="nc">
                	<td>${nc.numberCard }</td>
             </c:forEach>
          
           	<th><fmt:formatNumber value="${totalMap.numberCard }" pattern="0.00" maxFractionDigits="2"/></th>
       	  </tr>
       	  <tr>
       	    <th>会员充值</th>
       	    <c:forEach items="${payMentTotal }" var="nr">
                	<td>${nr.numberRecharge }</td>
             </c:forEach>
           
           	<th><fmt:formatNumber value="${totalMap.numberRecharge }" pattern="0.00" maxFractionDigits="2"/></th>
       	  </tr>
       	  <tr>
       	    <th>会员升级</th>
       	    <c:forEach items="${payMentTotal }" var="nu">
                	<td>${nu.numberUp }</td>
             </c:forEach>
           
           	<th><fmt:formatNumber value="${totalMap.numberUp }" pattern="0.00" maxFractionDigits="2"/></th>
       	  </tr>
       	  <tr>
       	    <th>会员退卡</th>
       	    <c:forEach items="${payMentTotal }" var="nb">
                	<td>${nb.numberBackCard }</td>
             </c:forEach>
           	<th><fmt:formatNumber value="${totalMap.numberBackCard }" pattern="0.00" maxFractionDigits="2"/></th>
       	  </tr>
       	  <tr>
       	    <th>单位预交</th>
       	    <c:forEach items="${payMentTotal }" var="au">
                	<td>${au.advanceUnit }</td>
             </c:forEach>
           	<th><fmt:formatNumber value="${totalMap.advanceUnit }" pattern="0.00" maxFractionDigits="2"/></th>
       	  </tr>
       	  <tr>
       	  	<th>挂账结算</th>
       	  	<c:forEach items="${payMentTotal }" var="sm">
                	<td>${sm.settleMent }</td>
             </c:forEach>
           	<th><fmt:formatNumber value="${totalMap.settleMent }" pattern="0.00" maxFractionDigits="2"/></th>
       	  </tr>
       	  <tr>
       	    <th>借用押金</th>
       	    <c:forEach items="${payMentTotal }" var="bd">
                	<td>${bd.borrowDeposit }</td>
             </c:forEach>
           	<th><fmt:formatNumber value="${totalMap.borrowDeposit }" pattern="0.00" maxFractionDigits="2"/></th>
       	  </tr>
       	  <tr>
			<th>小计</th>
			 <c:forEach items="${ordCashBoxTotal }" var="OrdCashBox">
              	<td><fmt:formatNumber value="${OrdCashBox.changeMoney + OrdCashBox.spareUp + OrdCashBox.preTransfer + OrdCashBox.spareDown}" pattern="0.00" maxFractionDigits="2"/></td>
              </c:forEach>
              <th><fmt:formatNumber value="${changeMoneyTotal }" pattern="0.00" maxFractionDigits="2"/></th>
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
    <div class="fixed-btn">
		<button class="btn btn-primary" id="subExcel">导出excel</button>
		<!-- <button onclick="print()" class="btn btn-success" type="button">打印</button> -->
	</div>
    <script type="text/javascript">
    
	    $("#subExcel").click(function(){
			if(${DATA.size()==0}){
				$.jBox.info("没有可以导出的数据");
				return false;
			}
			jBox.confirm("是否导出Excel表格","导出提示", function (v) {
	  		      if (v) {
				$("#searchForm").attr("action","${ctx }/report/ordCashbox/ExportExcel");
				$("#searchForm").submit();
			}
			}, {showScrolling: false, buttons: {'是': true, '否': false}});
		});
    </script>
</body>
</html>