<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@page
	import="com.jinchuan.pms.cyms.modules.setting.entity.CtTableType"%>
<html>
<head>
<title>预订</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
	var eventName = "reserveList";
	$(document).ready(function() {
		//事件名称保持唯一，这里直接用tabId
		//解绑事件
		top.$.unsubscribe(eventName);
		//注册事件，弹出页面需要刷新本页面，或者弹出页面回传数据用
		top.$.subscribe(eventName, function(e, data) {
			//data  可以通过这个对象来回传数据
			$("#searchForm").submit();
		});

		//加载业务人员
		loadSelect("salesman", "${ctx}/sys/userutils/getSalesmanList",
				'${ordReserve.storeId}', '', 'id', 'name');
		//加载分店
		loadSelect("companyCheckDiv",
				"${ctx}/sys/userutils/getOfficeListByType", {
					typesJson : "['3','4','5']"
				}, '${ordReserve.storeId}', 'id', 'name');
		//新增预定
		$("#addBtn6").bind("click",function() {
			top.$.jBox.open(
				"iframe:${ctx}/reserve/toAddReserveForm?eventName="+ eventName, 
				"预订", 
				1000,
				$(top.document).height() - 180, {
					buttons : {},
					loaded : function(h) {
						$(".jbox-content",top.document).css("overflow-y","hidden");
					}
				});
		});
		//分台
		$("#addBtn7").bind("click",function() {
			//js获取复选框值    
			var obj = document.getElementsByName("checkbox");//选择所有name="interest"的对象，返回数组    
			var s = '';//如果这样定义var s;变量s中会默认被赋个null值
			for (var i = 0; i < obj.length; i++) {
				if (obj[i].checked) //取到对象数组后，我们来循环检测它是不是被选中
					s += obj[i].value; //如果选中，将value添加到变量s中    
			}
			if ("" == s) {
				layer.alert("请选择订单！");
				return;
			}
			top.$.jBox.open(
				"iframe:${ctx}/reserve/orderBranchReserveForm?eventName="+ eventName + "&id=" + s,
				"分台", 
				1000, 
				$(top.document).height() - 180, {
					buttons : {},
					loaded : function(h) {
						$(".jbox-content",top.document).css("overflow-y","hidden");
					}
				});
		});
		$("#addBtn2").bind("click",function() {
			//js获取复选框值    
			var obj = document.getElementsByName("checkbox");//选择所有name="interest"的对象，返回数组    
			var s = '';//如果这样定义var s;变量s中会默认被赋个null值
			for (var i = 0; i < obj.length; i++) {
				if (obj[i].checked) //取到对象数组后，我们来循环检测它是不是被选中
					s += obj[i].value; //如果选中，将value添加到变量s中    
			}
			if ("" == s) {
				layer.alert("请选择订单！");
				return;
			}
			top.$.jBox.open(
			    "iframe:${ctx}/reserve/toOrderPartCheckInForm?eventName="+ eventName + "&id=" + s,
				"预定开台", 
				1000,
				$(top.document).height() - 180, {
					buttons : {},
					loaded : function(h) {
						$(".jbox-content",top.document).css("overflow-y",	"hidden");
					}
				});
		});

		$("#addBtn3").bind("click",function() {
			//js获取复选框值    
			var obj = document.getElementsByName("checkbox");//选择所有name="interest"的对象，返回数组    
			var s = '';//如果这样定义var s;变量s中会默认被赋个null值
			var reserveAmount = '';//选中预订单的订金
			for (var i = 0; i < obj.length; i++) {
				if (obj[i].checked){//取到对象数组后，我们来循环检测它是不是被选中
					s += obj[i].value; //如果选中，将value添加到变量s中    
					reserveAmount = obj[i].dataset.amount;
				} 
			}
			if ("" == s) {
				layer.alert("请选择订单！");
				return;
			}
			top.$.jBox.open(
				"iframe:${ctx}/reserve/toReserveDepositForm?eventName="
									+ eventName + "&id=" + s +"&reserveAmount="+reserveAmount,
				"订金管理", 
				1000, $(top.document).height() - 180, {
					buttons : {},
					loaded : function(h) {
						$(".jbox-content",top.document).css("overflow-y","hidden");
					}
				});
		});

		//新增预定，直接预定房间
		$("#addBtn1").bind("click",function() {
			var storeId = $('#storeId').val();
				top.$.jBox.open(
				"iframe:${ctx}/reserve/toSimpleAddReserveForm?eventName="+ eventName + "&storeId="+ storeId, "预订", 1000,
				$(top.document).height() - 180, {
				buttons : {},
				loaded : function(h) {
					$(".jbox-content",top.document).css("overflow-y","hidden");
					}
				});
			});
		//新增预定
		$("#addBtn").bind("click",function() {
			top.$.jBox.open(
				"iframe:${ctx}/reserve/form?eventName="+ eventName, 
				"新增台型设置",
				1000,
				$(top.document).height() - 180, {
					buttons : {},
					loaded : function(h) {
						$(".jbox-content",top.document).css("overflow-y","hidden");
					}
				});
		});

		//修改
		$("#contentTable a.update").click(function(e) {
			var id = $(this).data("id");
			top.$.jBox.open(
				"iframe:${ctx}/setting/tableTyple/toEditCtTableTypeForm?eventName="+ eventName + "&id=" + id,
				"桌型编辑", 
				1000, $(top.document).height() - 180, {
					buttons : {},
					loaded : function(h) {
						$(".jbox-content",top.document).css("overflow-y","hidden");
					}
				});
		});

		//删除
		$("#contentTable a.delete").click(function(e) {
			var id = $(this).data("id");
			confirmx('确认要删除该桌型吗？',"${ctx}/setting/tableTyple/delete?id="+ id);
		});

	});
	//编辑预定单
	function editReserve(id, storeId) {
		var nosId = "#tablesNos" + id;
		var nos = "";
		$(nosId).each(function() {
			nos += $(this).val()
		})
		if (nos != "") {
			layer.alert("该预订单已经分台，不允许修改!如需修改请取消分台！");
			return;
		}
		top.$.jBox.open("iframe:${ctx}/reserve/toEditReserveForm?eventName="
				+ eventName + "&storeId=" + storeId + "&id=" + id, "编辑预定单",
				1000, $(top.document).height() - 180, {
					buttons : {},
					loaded : function(h) {
						$(".jbox-content", top.document).css("overflow-y","hidden");

					}
		});
	}

	function cancelReserve(id, storeId) {
		$.ajax({
			type : "post",
			dataType : "json",
			url : "${ctx}/reserve/cancelReserve",
			async : false,
			data : {
				"id" : id,
				"storeId" : storeId
			},
			success : function(result) {
				if (result.retCode == "000000") {
					top.$.publish("reserveList", {
						testData : "hello"
					});
					//window.location.href = "${ctx}/order/ordReserve/list";
					window.parent.jBox.close();
				} else {
					layer.alert(result.retMsg);
				}
			},
			error : function(result, status) {
				layer.alert("系统错误");
			}
		});

	}
	
	function toShow(reserveId,storeId,depositAmount,tableCount) {
		top.$.jBox.open(
			"iframe:${ctx}/reserve/ordReserveDetails?eventName="+ eventName + "&reserveId=" + reserveId+"&storeId="+storeId+"&depositAmount="+depositAmount+"&tableCount="+tableCount,
			"预订单："+reserveId,
			1000, 
			$(top.document).height() - 180, {
				buttons : {},
				loaded : function(h) {
					$(".jbox-content",top.document).css("overflow-y","hidden");
				}
			});
	}

	//提前点餐
	function orderFood(reserveId,id,storeId,tableNo)  {
		if (tableNo == '') {
			layer.alert("请先分台再点菜！");
			return;
		}
		$.jBox.open(
            	"iframe:${ctx}/reserve/reserveAheadOrderFood?storeId="+storeId+"&reserveId="+reserveId+"&id="+id,
             	"预订单号："+reserveId,
            	/* 1190,
             	580, */
             	$(window).width()-5,
                $(window).height()-7,
                {
	                buttons: {},//"返回":"0"
	                //bottomText: '坐标长沙',
	                opacity:0,
        			showClose: false,
        			draggable: false,
        			showType:"show",
	                loaded: function (h) {
	                	//$(".jbox-content", top.document).css("overflow-y", "hidden");
	                	$(".jbox-content").css("overflow-y", "hidden");
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
	
	$(document).ready(function() {
		$("#contentTableTbody tr").click(function() {
			$("#contentTableTbody tr").each(function(i, n) {
				n.tag = false;
				//			$(n).css("background", "");
			});
			//		$(this).css("background", "#CEF0D6");
			$(':checkbox').removeAttr('checked');
			$(this).find(":checkbox").attr('checked', 'checked');
			this.tag = true;
		}).hover(function() {
			if (!this.tag) {
				//		$(this).css("background", "#DEF7E3");
			}
		}, function() {
			if (!this.tag) {
				//		$(this).css("background", "");
			}
		})

		$(':checkbox').each(function() { //遍历页面中所有的checkbox
			$(this).click(function() {//为页面中每一个checkbox设置点击事件
				if ($(this).attr('checked')) { //如果有checkbox状态为选中
					$(':checkbox').removeAttr('checked'); //移除checked属性，改变checkbox状态为未选中(为页面中所有checkbox复选框添加设置)
					$(this).attr('checked', 'checked'); //为当前点击选中的checkbox复选框添加checked属性
				}
			});
		});
	})
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
	<input type="hidden" id="storeId" value="${ordReserve.storeId}" />
	<form:form id="searchForm" action="${ctx}/reserve/" method="post"
		class="breadcrumb form-search">

		<ul class="ul-form" id="ulsearch" style="overflow: visible">

			<li><label>餐厅：</label> <select id="companyCheckDiv"
				class="input-medium6" name="storeId"
				onchange="searchChange(this.options[this.options.selectedIndex].value)">
			</select></li>
			<li><label>用餐日期：</label> <input id="useDateStart"
				style="margin-right: 3px;" name="useDateStart" type="text"
				readonly="readonly" maxlength="20" class="Wdate input-medium6"
				value="${param.strTime }" pattern="yyyy-MM-dd"
				onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />-
				<input id="useDateEnd" style="margin-right: 3px;" name="useDateEnd"
				type="text" readonly="readonly" maxlength="20"
				class="Wdate input-medium6" value="${param.strTime}"
				pattern="yyyy-MM-dd"
				onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />
			</li>
			<li><label>用餐时段：</label> <select id="useLevel" name="useLevel"
				class="input-medium6">
					<option value="">--请选择--</option>
					<option value="1"
						<c:if test="${'1' eq ordReserve.useLevel}">selected="selected"</c:if>>早餐</option>
					<option value="2"
						<c:if test="${'2' eq ordReserve.useLevel}">selected="selected"</c:if>>中餐</option>
					<option value="3"
						<c:if test="${'3' eq ordReserve.useLevel}">selected="selected"</c:if>>晚餐</option>


			</select></li>

			<li><label>状态：</label> <select id="status" name="status"
				class="input-medium6">
					<option value="">--请选择--</option>
					<option value="stayBranchTable"
						<c:if test="${'stayBranchTable' eq ordReserve.status}">selected="selected"</c:if>>待分台</option>
					<option value="stayCheckIn"
						<c:if test="${'stayCheckIn' eq ordReserve.status}">selected="selected"</c:if>>待开台</option>
					<option value="checkIn"
						<c:if test="${'checkIn' eq ordReserve.status}">selected="selected"</c:if>>已开台</option>
					<option value="checkOut"
						<c:if test="${'checkOut' eq ordReserve.status}">selected="selected"</c:if>>已结账</option>
					<option value="px"
						<c:if test="${'px' eq ordReserve.status}">selected="selected"</c:if>>已
						PX</option>
					<option value="cancel"
						<c:if test="${'cancel' eq ordReserve.status}">selected="selected"</c:if>>已取消</option>
			</select></li>

			<li><label>客源：</label> <select id="source" name="source"
				class="input-medium6">
					<option value="">--请选择--</option>
					<c:forEach items="${sourceList}" var="sourceList">
						<option value="${sourceList.paramKey}"
							<c:if test="${sourceList.paramKey==ordReserve.source}">selected="selected"</c:if>>${sourceList.name}</option>

					</c:forEach>
			</select></li>

			<li><label>销售员：</label> <select id="salesman" name="salesPerson"
				class="select-medium4">
			</select></li>

			<li><label>台位类型：</label> <select id="tableTypeId"
				name="tableTypeId" class="input-medium6">
					<option value="">--请选择--</option>
					<c:forEach items="${tableTypeList}" var="ctTableTypeList">
						<option value="${ctTableTypeList.id}"
							<c:if test="${ctTableTypeList.id==ordReserve.tableTypeId}">selected="selected"</c:if>>${ctTableTypeList.name}</option>

					</c:forEach>
			</select></li>
			<li><input type="text" id="name" name="name" htmlEscape="false"
				maxlength="11" class="input-medium6" /></li>

			<li class="btns"><button id="btnSubmit" class="btn btn-primary"
					type="submit">查询</button></li>
			<li class="clearfix"></li>
		</ul>




	</form:form>
	<table id="contentTable"
		class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>选择</th>
				<th>预定单号</th>
				<th>预定时间</th>
				<th>联系人</th>
				<th>联系方式</th>
				<th>预订数量</th>
				<th>预定台型</th>
				<th>预订台号</th>
				<th>状态</th>
				<th>用餐人数</th>
				<th>用餐时间</th>
				<th>用餐时段</th>
				<th>客源</th>
				<th>第三方单号</th>
				<th>销售员</th>
				<th>用餐类型</th>
				<th>预定订金</th>
				<th>账单号</th>
				<th>编辑</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody id="contentTableTbody">
			<c:set value="" var="lastOrderId" />
			<c:forEach items="${ordReserveList}" var="ordReserveList">
				<tr style="cursor: pointer;">
					<c:if test="${lastOrderId!=ordReserveList.orderId}">
						<td rowspan="${ordReserveList.orderNum }"><input
							type="checkbox" name="checkbox" value="${ordReserveList.orderId}"
							id="checkbox"  data-amount="${ordReserveList.depositAmount }" data-storeId="${ordReserveList.storeId }"/></td>
						<td rowspan="${ordReserveList.orderNum }"><a href="#"
							onclick="toShow('${ordReserveList.orderId }','${ordReserveList.storeId }','${ordReserveList.depositAmount}','${ordReserveList.orderNum }')">${ordReserveList.orderId}</a></td>
						<td rowspan="${ordReserveList.orderNum }">${ordReserveList.useDate}</td>
						<td rowspan="${ordReserveList.orderNum }">${ordReserveList.name}</td>
						<td rowspan="${ordReserveList.orderNum }">${ordReserveList.phone}</td>
						<td rowspan="${ordReserveList.orderNum }">${ordReserveList.orderNum}</td>
					</c:if>
					<td>${ordReserveList.tableTypeName}</td>
					<td>${ordReserveList.tableNo}</td>
					<input type="hidden" id="tablesNos${ordReserveList.orderId}"
						value="${ordReserveList.tableNo}" />
					<td>${ordReserveList.status}</td>
					<td>${ordReserveList.personCount}</td>
					<c:if test="${lastOrderId != ordReserveList.orderId}">
						<td rowspan="${ordReserveList.orderNum }">${ordReserveList.useDate}</td>
						<c:if test="${ordReserveList.useLevel == '1'}">
							<td rowspan="${ordReserveList.orderNum }">早餐</td>
						</c:if>
						<c:if test="${ordReserveList.useLevel == '2'}">
							<td rowspan="${ordReserveList.orderNum }">中餐</td>
						</c:if>
						<c:if test="${ordReserveList.useLevel == '3'}">
							<td rowspan="${ordReserveList.orderNum }">晚餐</td>
						</c:if>
						<c:if test="${ordReserveList.useLevel == ''}">
							<td rowspan="${ordReserveList.orderNum }"></td>
						</c:if>
						<td rowspan="${ordReserveList.orderNum }">${ordReserveList.sourceName}</td>
						<td rowspan="${ordReserveList.orderNum }">${ordReserveList.thirdPartId}</td>
						<td rowspan="${ordReserveList.orderNum }">${ordReserveList.salesPerson}</td>

						<c:if test="${ordReserveList.useType == 'st'}">
							<td rowspan="${ordReserveList.orderNum }">散台</td>
						</c:if>
						<c:if test="${ordReserveList.useType == 'yx'}">
							<td rowspan="${ordReserveList.orderNum }">宴席</td>
						</c:if>
						<c:if test="${ordReserveList.useType == 'hy'}">
							<td rowspan="${ordReserveList.orderNum }">会议</td>
						</c:if>
						<c:if test="${ordReserveList.useType == ''}">
							<td rowspan="${ordReserveList.orderNum }"></td>
						</c:if>
						<td rowspan="${ordReserveList.orderNum }"
							style="text-align: right;">${ordReserveList.depositAmount}</td>
						<td rowspan="${ordReserveList.orderNum }"
							style="text-align: right;">${ordReserveList.depositAmount}</td>
						<td rowspan="${ordReserveList.orderNum }"
							style="text-align: right;"><a
							onclick="editReserve('${ordReserveList.orderId}','${ordReserveList.storeId}')">修改</a>

						</td>
						<c:set value="${ordReserveList.orderId}" var="lastOrderId" />
					</c:if>
					<td>
						<c:if test="${ordReserveList.status == '待分台'||ordReserveList.status == '待开台'}">
							<a onclick="cancelReserve('${ordReserveList.id}','${ordReserveList.storeId}')">取消</a>
						</c:if>
						<c:if test="${ordReserveList.status == '待分台'||ordReserveList.status == '待开台'}">
							<a onclick="orderFood('${ordReserveList.orderId }','${ordReserveList.id}','${ordReserveList.storeId}','${ordReserveList.tableNo }')">点餐</a>
						</c:if>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>

	<div class="fixed-btn">
		<input type="button" id="addBtn1" class="btn btn-primary" value="预订" />
		<input type="button" id="addBtn3" class="btn btn-primary" value="订金" />
		<!-- 	<input type="button" id="addBtn4" class="btn btn-primary" value="取消预订" /> -->
		<input type="button" id="addBtn6" class="btn btn-primary" value="预订" />
		<input type="button" id="addBtn7" class="btn btn-primary" value="分台" />
		<input type="button" id="addBtn2" class="btn btn-primary" value="预订开台" />
	</div>


</body>
</html>