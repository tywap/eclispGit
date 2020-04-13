<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客源分析</title>
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
		
		//初始化时间
		function changeDateCheck(){
			 var accountDate = $('#accountDate').val();
			 if(accountDate == null || accountDate == '')
			 {
				 $('#accountDate').val('${accountDate}') 
			 }
		}
		
		$.getStores = function (selecteds) {
			$("#appStore").css({'display':'inline-block'});
			$("#appStore").empty();
			var names="";
			for(var i=1;i<selecteds.length;i++){
				names+=selecteds[i].name+",";
			}
			$("#appStore").append(names);
			loadRoomType();
		}

		function loadRoomType(){
			$("#tableTbody").empty();
			$.ajax({
		        url:"${ctx}/price/htlPriceRule/loadRoomType",
		        type: "post",
		        dataType: "json",
		        data: {
		     	 "storeId":$("#storeId").val()
		        },
		        success: function (result) {
		        	var htm="";
		     	   for(var i=0;i<result.length;i++){
		     		   var roomType=result[i];
		     		   
		     		   htm+="<tr><td>"+roomType.roomTypeName+"</td>";
			     		<c:forEach items="${rentList}" var="rent">
							htm+="<td><input type='text' class='pricedetail' onafterpaste='checkText(this)' onkeyup='checkText(this)' rentId='${rent.id}' typeId='"+roomType.id+"' priceType='0'  /></td>";
							<c:if test="${rent.rent_type=='2'}">	
								htm+="<td><input type='text' class='pricedetail' onafterpaste='checkText(this)'  onkeyup='checkText(this)' rentId='${rent.id}' typeId='"+roomType.id+"' priceType='1'  /></td>";
							</c:if>	
			     		</c:forEach>
		     		   htm+="</tr>";
		     		}
		     	   $("#tableTbody").append(htm);
		   		}
			});
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
	<form:form id="searchForm" modelAttribute="dayOrder" action="${ctx}/report/sourceAnalyze/list" method="post" class="breadcrumb form-search ">
		<ul class="ul-form">
			<div class="row" style=" margin-left: -10px;">
				<div class="span">
					<div class="control-group">
						<div class="controls">
						<label>应用门店：</label>
							<sys:treeselect id="storeIdId" labelName="门店" value="" labelValue="" name="storeId"
					 		title="门店" url="/report/checkDetails/storeData" checked="true" notAllowSelectParent="true" cssClass="input-medium6" />
						</div>
					</div>
				</div>
				<div class="span">
					<div class="control-group">
						<div class="controls">
							<div id="appStore" class="appStore"></div>
						</div>
					</div>
				</div>
			</div>			
			<li>
				<label>账务日期：</label>
				<input id="accountDate" style="margin-right:3px;" name="accountDate" type="text" readonly="readonly" maxlength="20" class="Wdate input-medium6"
                    value="${param.accountDate }" pattern="yyyy-MM-dd"
                    onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true,minDate:'${reportMinQueryDate}'});"
                     />
             </li>
			<li><label>用餐时段：</label>
				<select id="shiftId" name="shiftId" class="select-medium6">
					<option value="" >全部</option>
					<option value="1" <c:if test="${1 == param.shiftId }">selected ="selected"</c:if>>早餐</option>
					<option value="2" <c:if test="${2 == param.shiftId }">selected ="selected"</c:if>>中餐</option>
					<option value="3" <c:if test="${3 == param.shiftId }">selected ="selected"</c:if>>晚餐</option>
				</select>
			</li>
			<li>
			<li class="btns">
				<button id="btnSubmit" class="btn btn-primary" >查询</button>
			</li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<div id="my_div" class="fakeContainer first_div" style="overflow:auto;">
		<table class="table table-bordered center" id="demoTable">
		<thead>
			<tr id="my_tr">
				<th rowspan="2" >分店</th>
				<th rowspan="2">客源</th>
				<th rowspan="2">开台次数</th>
				<th rowspan="2">用餐人数</th>
				<th rowspan="2">班次</th>
				<th rowspan="2">销售份数</th>
				<th rowspan="2">标准成本</th>
				<th colspan="5">折前营业额</th>
				<th colspan="5">折后营业额</th>
				<th colspan="3">优免金额</th>
				<th colspan="3">退菜信息</th>
			</tr>
			<tr>
			<th>销售额</th>
			<th>占比</th>
			<th>毛利率</th>
			<th>桌均</th>
			<th>人均</th>
			<th>销售额</th>
			<th>占比</th>
			<th>毛利率</th>
			<th>桌均</th>
			<th>人均</th>
			<th>优免额</th>
			<th>优免率</th>
			<th>占比</th>
			<th>数量</th>
			<th>金额</th>
			<th>退菜率</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${listSourceAnalyze}" var="ord" varStatus="ordStatus">
			<tr  orderId="${ord.id}" >
				<td>${ord.storeName}</td>
				<td>${ord.sourceName}</td>
				<td>${ord.orderCount }</td>
				<td>${ord.useCount }</td>
				<td>${ord.shiftId}</td>
				<td>${ord.foodCount}</td>
				<td>${ord.costAmount}</td>
				<td>${ord.originalAmount}</td>
				<td>${ord.originalProportion}</td>
				<td>${ord.originalrate}</td>
				<td>${ord.originalTableAvg}</td>
				<td>${ord.originalUseAvg }</td>
				<td>${ord.salesAmount}</td>
				<td>${ord.turnoverProportion}</td>
				<td>${ord.salesRate}</td>
				<td>${ord.rearTableAvg}</td>
				<td>${ord.rearUseAvg}</td>
				<td>${ord.optimalFreeGold}</td>
				<td>${ord.optimalRate}</td>
				<td>${ord.optimalProportion}</td>
				<td>${ord.canelCount}</td>
				<td>${ord.canelAmount}</td>
				<td>${ord.canelrate}</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
</div>
</body>
</html>