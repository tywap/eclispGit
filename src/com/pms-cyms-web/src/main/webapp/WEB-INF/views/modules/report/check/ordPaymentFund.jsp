<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>挂房账账明细</title>
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
			changeDateCheck();
		});
		
		function startChange(){
			if($('#selectA').val()==""){
				$.jBox.info("请选择日期类型");
			}
		}
		
		function selectedThisTr(obj){
			$("tr").removeClass("selectedTr");
			$(obj).addClass("selectedTr");
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
		
		//根据分店获取下拉框数据
	/* 	function searchChange(obj){
			 var storeId = $("#storeId").val();
			 var params = {storeId:storeId}
			 loadAjax("${ctx}/report/checkDetails/getComboBox", params, function(result) {
					if (result.retCode == "000000") {
						var tableType=result.list;
						var floor=result.tmp;
						var op="<option value=''>全部</option>";
						$("#tableTypeName").empty();
						$("#tableTypeName").append(op);
						for(var i=0;i<tableType.length;i++){
						<c:if test="${param.tableTypeName == tableType[i].id }">selected ='selected'</c:if> 
						htm="<option value='"+tableType[i].id+"' >"+tableType[i].name+"</option>";
	                    	$("#tableTypeName").append(htm);
	                	}
						$("#floorName").empty();
						$("#floorName").append(op);
						for(var i=0;i<floor.length;i++){
							htm="<option value='"+floor[i].id+"'>"+floor[i].name+"</option>";
	                    	$("#floorName").append(htm);
	                	}
					} else {
						layer.alert(result.retMsg);
					}
				});
		} */
		
		function changeDateCheck(){
			 var strTime = $('#strTime').val();
			 var endTime = $('#endTime').val();
			 if(strTime == null || strTime == '')
			 {
				 $('#strTime').val('${accountDate}') 
			 }
			 if(endTime == null || endTime == '')
			 {
				 $('#endTime').val('${accountDate}') 
			 }
		}
		
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
		
		function getOrder(orderId){
            top.$.jBox.open(
            	"iframe:${ctx}/order/checkIn/ordTableIndexInit?orderId=" + orderId,
             	"单号："+orderId,
            	$(window).width()-5,
                $(window).height()-7,
                {
	                buttons: {},//"返回":"0"
	                //bottomText: '坐标长沙',
	              /*   opacity:0,
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
	<form:form id="searchForm" modelAttribute="dayOrder" action="${ctx}/order/ordPaymentFund/query" method="post" class="breadcrumb form-search ">
		<ul class="ul-form">
			<li>
				<label></label>
				<select id="dateType" style="margin-right:0; width: 100px;" name="dateType"  class="select-medium6" onchange="changeDateCheck()" >
						<option value="1" <c:if test="${1==param.dateType}">selected</c:if>>挂账日期</option>
						<option value="2" <c:if test="${2==param.dateType}">selected</c:if>>财务日期</option>
						<%-- <option value="3" <c:if test="${3==param.dateType}">selected</c:if>>结账时间</option> --%>
				</select>
			</li> 
			<li>
				<label></label>
				<input id="strTime" style="margin-right:3px;" name="strTime" type="text" readonly="readonly" maxlength="20" class="Wdate input-medium6"
                    value="${strTime }" pattern="yyyy-MM-dd"
                    onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true,minDate:'${reportMinQueryDate}'});"
                     />-
                <input id="endTime" name="endTime" type="text" readonly="readonly" maxlength="20" class="input-medium6 Wdate "
	                value="${endTime }" pattern="yyyy-MM-dd"
	                onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true,minDate:'${reportMinQueryDate}'});"
	                />
             </li>
			<li><label>挂账工号：</label>
				<input style="width: 130px;" type="text" name="name" value="${param.name }" id="name" htmlEscape="false" maxlength="80" class="input-medium6"/>
			</li>
			<li>
			<label>搜索：</label>
			<input style="width: 230px;" type="text" name="titleNo" value="${param.titleNo }" id="titleNo" htmlEscape="false" maxlength="80" class="input-medium6" placeholder="账单号/台号/房号"/>
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
				<th >序号</th>
				<th >挂房账时间</th>
				<th >账务日期</th>
				<th >账单号</th>
				<th >台号</th>
				<th >挂房账金额</th>
				<th >转账房单号</th>
				<th >转账房号</th>
				<th >住客姓名</th>
				<th >转账工号</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${list}" var="ord" varStatus="ordStatus">
			<tr onclick="selectedThisTr(this)" orderId="${ord.id}" orderStatus="${ord.status}">
			     <td>${ordStatus.index+1}</td>
			     <td><fmt:formatDate value="${ord.updateDate }" pattern="yyyy-MM-dd HH:mm:ss" /></td>
			     <td>${ord.accountDate }</td>
			     <td><a onclick="getOrder('${ord.orderId }')">${ord.orderId }</a></td>
			     <td>${ord.tableNo }</td>
			     <td>${ord.amount }</td>
			     <td>${ord.roomNumber }</td>
			     <td>${ord.roomNo }</td>
			     <td>${ord.usetName }</td>
			     <td>${ord.name }</td>
			</tr>
		</c:forEach>
			<tr>
				 <td></td>
			     <td>合计</td>
			     <td></td>
			     <td></td>
			     <td></td>
			     <td>${amount }</td>
			     <td></td>
			     <td></td>
			     <td></td>
			     <td></td>
			</tr>
		</tbody>
	</table>
</div>
</body>
</html>