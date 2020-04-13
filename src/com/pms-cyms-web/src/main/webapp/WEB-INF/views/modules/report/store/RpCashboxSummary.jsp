<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>钱箱余额表</title>
<meta name="decorator" content="default" />
</head>
<body>
	<form:form action="" method="POST"
		class="breadcrumb form-search" id="subForm">
		<ul class="ul-form">
			<li>
		 		<label>分店：</label>
				<select id="companyCheckDiv" class="input-medium6" name="storeId" onchange="getshiftListByStoreId()">
			 	</select>
		 	</li>
			<li>
				<label>账务日期：</label>
					<input id="accountDate" name="accountDate" type="text" readonly="readonly" maxlength="20" class="input-medium6 Wdate" style="margin-right:3px;"
	                       value="${accountDate }" pattern="yyyy-MM-dd"
	                       onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />
			</li>
			<li>
				<button type="button" id="sub" class="btn btn-primary">查询</button>
			</li>
		</ul>
	</form:form>
	<div id="div_container">
		<div id="my_div" class="fakeContainer first_div">
			<table class="table table-bordered center" id="demoTable">
				<thead>
					<tr id="my_tr">
						<th>门店</th>
						<c:forEach items="${querystoreId }" var="querystoreId">
							<c:set var="tag" value="0"></c:set>
							<%-- <c:forEach items="${querylist }" var="querylist">
								<c:if test="${querystoreId.paramKey==querylist.payClass }">
									<c:set var="tag" value="1"></c:set>
								</c:if>
							</c:forEach>
							<c:if test="${tag==1 }"> --%>
								<th>${querystoreId.name }</th>
							<%-- </c:if> --%>
						</c:forEach>
						<th>余额小计</th>
					</tr>
				</thead>
				<tbody>
					 <c:forEach items="${listhtlStore }" var="hotelname">
						<tr>
							<td>${ hotelname.storeName}</td>
							<c:set var="subtotal" value="0.00"></c:set>
							<c:forEach items="${querylist}" var="querylist">
								<c:set var="aa" value="0"></c:set>
								<c:forEach items="${querystoreId}" var="querystoreId">
									<c:set var="aa" value="1"></c:set>
									<c:if test="${querylist.storeId==hotelname.id }">
										<c:if test="${querystoreId.paramKey==querylist.payClass }">
											<c:set var="subtotal" value="${subtotal+querylist.money }"></c:set>
											<td>${querylist.money }</td>
										</c:if>
									</c:if>
								</c:forEach>
							</c:forEach>
							<%-- <c:if test="${subtotal!=0.00 }"> --%>
								<td>${subtotal }</td>
							<%-- </c:if> --%>
						</tr>
					</c:forEach>
					<tr>
						<td>小计</td>
						<c:set var="subtot" value="0.00"></c:set>
						<c:forEach items="${querystoreId }" var="querystoreId">
							<c:set var="subtotal" value="0.00"></c:set>
							<c:set var="subt" value="0"></c:set>
							<c:forEach items="${querylist }" var="querylist">
								<c:if test="${querystoreId.paramKey==querylist.payClass}">
									<c:set var="subt" value="1"></c:set>
									<c:set var="subtotal" value="${subtotal+querylist.money }"></c:set>
									<c:set var="subtot" value="${subtot+querylist.money }"></c:set>
								</c:if>
							</c:forEach>
							<td>${subtotal }</td>
							<%-- <c:if test="${subt==1 }">
								<td>${subtotal }</td>
							</c:if>
							<c:if test="${subt==0 }">
								<td>0.00</td>
							</c:if> --%>
						</c:forEach>
						<td>${subtot }</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	<div class="fixed-btn">
		<button class="btn btn-primary" id="subExcel">导出Excel</button> 
		<button onclick="print()" class="btn btn-success" type="button">打印</button>
	</div>
	<script src="${ctxStatic}/jqprint/jquery.jqprint-0.3.js" type="text/javascript"></script>
	<script type="text/javascript">
		$(document).ready(function(){
			$("#subExcel").click(function(){
				if(${DATA.size()==0}){
					$.jBox.info("没有可以导出的数据");
					return false;
				}
				jBox.confirm("是否导出Excel表格","导出提示", function (v) {
		  		      if (v) {
					$("#subForm").attr("action","${ctx }/Rpcashbox/Summary/ExportRepairExcel");
					$("#subForm").submit();
		  		    }
		   		}, {showScrolling: false, buttons: {'是': true, '否': false}});
			});
			
			$("#sub").click(function(){
				$("#subForm").attr("action","${ctx }/Rpcashbox/Summary/query");
				$("#subForm").submit();
			});
			
			//加载分店
	        loadSelect("companyCheckDiv","${ctx}/sys/userutils/getOfficeListByType",{typesJson:"['3','4','5']"},'${param.storeId}','id','name');
		});
		
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
			$(".sHeader").css("width",($(document).width())+"px");				
			$(".sData").css("width",($(document).width())+"px");//这块的宽度是用$("#div_container")的宽度减去锁定的列的宽度
			$(".sData").css("height",($(document).height()-175)+"px");
		})
	</script>
</body>
</html>