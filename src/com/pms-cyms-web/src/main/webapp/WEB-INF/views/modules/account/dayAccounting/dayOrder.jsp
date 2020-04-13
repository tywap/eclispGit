<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>当日账单</title>
	<meta name="decorator" content="default"/>
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
			
			$("#btnSubmit").bind("click", function() {
				var storeId=  $("#storeId option:selected").val();
				if (storeId =='') {
					layer.confirm('请先选择分店！');
					return false;
				}
			});
			
			//checkbox单选
			$("input[name='weeks']").click(function(){
				stopBubbling(event);
			});

		});

		//查询
		function searchChange(storeId){
			if(storeId==''){
				storeId="pmscy";
			}
			self.location.href="${ctx}/accounting/dayOrder/list?storeId="+storeId;
		}
        
		function selectedThisTr(obj){
			$("tr").removeClass("selectedTr");
			$(obj).addClass("selectedTr");
		}
		
		//恢复
		function revocation(){
			if($(".selectedTr").length!=1){
				layer.alert("请选择一条房单进行恢复！");
				return;
			}
			var orderId=$(".selectedTr").attr("orderId");
			var orderStatus=$(".selectedTr").attr("orderStatus");
			var type='0';
			var url="";
			if(orderStatus=='px挂账'){
				url="${ctx}/accounting/dayOrder/recoverCheckIn";
			}else if(orderStatus=='已结账'){
				url="${ctx}/accounting/dayOrder/recover";
			}else{
				layer.alert("请选择PX或结账订单恢复！");
				return;
			}
			layer.confirm('确定恢复订单吗？', {btn: ['确定','取消'] }, 
				function(){
					$.ajax({
				        url:url,
				        type: "post",
				        dataType: "json",
				        data: {
				            "id":orderId,
				            "type":type
				        },
				        success: function (result) {
				       		if(result.flag=="1"){
				       			layer.alert('房单恢复成功！', function(index){
				       				$("#searchForm").submit();
				       			}); 
				       		}else
				       			layer.alert(result.msg);
				   		}
					});
				}, function(){
			});
		}    
		
		function getOrder(orderId){
            top.$.jBox.open(
            	"iframe:${ctx}/order/checkIn/ordTableIndexInit?orderId=" + orderId,
             	"单号："+orderId,
            	$(window).width()-5,
                $(window).height()-7,
                {
	                buttons: {},//"返回":"0"
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
	<form:form id="searchForm" modelAttribute="dayOrder" action="${ctx}/accounting/dayOrder/list" method="post" class="breadcrumb form-search ">
		<ul class="ul-form">
			<li><label>分店：</label>
				<select id="storeId" name="storeId" class="select-medium6" style="width: 90px;" onchange="searchChange(this.options[this.options.selectedIndex].value)">
				</select>
			</li>
			<li><label>状态：</label>
				<select id="status" name="status" class="select-medium6 ">
				    <option value="" >全部</option>
					<option value="checkIn" <c:if test="${'checkIn' == param.status }">selected ="selected"</c:if>>未结账</option>
					<option value="checkOut" <c:if test="${'checkOut' == param.status }">selected ="selected"</c:if>>已结账</option>
					<option value="px" <c:if test="${'px' == param.status }">selected ="selected"</c:if>>px账单</option>
				</select>
			</li>
			<li><label>台号类型：</label>
				<select id="tableId" name="tableId" class="select-medium6">
					<option value="" >全部</option>
					<c:forEach items="${ctTableTypeList}" var="var" varStatus="vs">
                       	<option value="${var.id}" <c:if test="${var.id == param.tableId }">selected ="selected"</c:if>> ${var.name}</option>
                    </c:forEach>
				</select>
				</li>
			<li><label>客源：</label>
				<select id="source" name="source" class="select-medium6">
					<option value="">全部</option>
					<c:forEach items="${sourceList}" var="var" varStatus="vs">
                      	<option value="${var.paramKey}" <c:if test="${var.paramKey == param.source }">selected ="selected"</c:if>> ${var.name}</option>
                    </c:forEach>
				</select>
			</li>
			<li><label>销售员：</label>
				<select id="userName" name="userName" class="select-medium6" style="width: 100px;">
				<option value="">全部</option>
				<c:forEach items="${salesmanList}" var="var" varStatus="vs">
                       	<option value="${var.id}" <c:if test="${var.id == param.userName }">selected ="selected"</c:if>> ${var.name}</option>
                    </c:forEach>
				</select>
				</li>
			<li><label>用餐类型：</label>
				<select id="useType" name="useType" class="select-medium6">
				<option value=""> 全部</option>
				<option value="st" <c:if test="${'st' == param.useType }">selected </c:if>>散台</option>
        	    <option value="yx" <c:if test="${'yx' == param.useType }">selected </c:if>>宴席</option>
        	    <option value="hy" <c:if test="${'hy' == param.useType }">selected </c:if>>会议</option>
				</select>
				</li>
			<li>
			<select id="seleectType" name="seleectType" style="margin-right:3px; width: 130px;"  class="select-medium6" >
				<option value="1" <c:if test="${1==param.seleectType}">selected</c:if>>单号:</option>
				<option value="2" <c:if test="${2==param.seleectType}">selected</c:if>>会员:</option>
				<option value="3" <c:if test="${3==param.seleectType}">selected</c:if>>协议单位:</option>
				<option value="4" <c:if test="${4==param.seleectType}">selected</c:if>>第三发单号</option>
				<option value="5" <c:if test="${5==param.seleectType}">selected</c:if>>联系人/联系方式:</option>
			</select>
			<input type="text" name="seleectName" value="${param.tableId}" id="seleectName" htmlEscape="false" maxlength="50" class="input-medium6"/></li>
			<li>
			<li class="btns">
				<button id="btnSubmit" class="btn btn-primary" >查询</button>
			</li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr id="my_tr">
				<th>序号</th>
				<th>状态</th>
				<th>单号</th>
				<th>经营场所</th>
				<th>台号类别</th>
				<th>台号名称</th>
				<th>用餐人数</th>
				<th>点菜数量</th>
				<th>消费金额</th>
				<!-- <th>折扣</th> -->
				<th>折扣金</th>
				<th>折后小计</th>
				<th>开台时间</th>
				<th>结账时间</th>
				<th>客源</th>
				<th>会员/协议/三方单号</th>
				<th>销售员</th>
				<th>联系人</th>
				<th>联系人信息</th>
				<th>用餐类型</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${ordList}" var="ord" varStatus="ordStatus">
			<tr onclick="selectedThisTr(this)" orderId="${ord.id}" orderStatus="${ord.status}">
				<td>${ordStatus.count}</td>
				<td>${ord.status}</td>
				<td><a onclick="getOrder('${ord.id}')">${ord.id}</a></td>
				<td>${storeName }</td>
				<td>${ord.tableTypeName}</td>
				<td>${ord.tableNo}</td>
				<td>${ord.useNum}</td>
				<td>${ord.foodCount}</td>
				<td>${ord.consumeAmount}</td>
				<td>${ord.rateAmount}</td>
				<td>${ord.balanceAmount}</td>
				<td><fmt:formatDate value="${ord.createDate}" type="date" pattern="yyyy-MM-dd HH:mm"/></td>
				<td><fmt:formatDate value="${ord.settleDate}" type="date" pattern="yyyy-MM-dd HH:mm"/></td>
				<td>${ord.sourceName}</td>
				<td>${ord.thirdPartId}</td>
				<td>${ord.userName}</td>
				<td>${ord.memberName}</td>
				<td>${ord.memberPhone}</td>
				<td>${ord.useType}</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="fixed-btn">
		<button class="btn btn-primary" id="addBtn" onclick="revocation()" >撤销结账/撤销PX</button>
	</div>
</body>
</html>