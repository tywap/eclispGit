<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>预定分台</title>
<meta name="decorator" content="default" />
<script src="${ctxStatic}/common/jquery.webui-popover.min.js"
	type="text/javascript"></script>
<script src="${ctxStatic}/room/roomCard.js?V=1" type="text/javascript"></script>
<script src="${ctxStatic}/common/analysisIcCard.js"
	type="text/javascript"></script>
<link href="${ctxStatic}/common/jquery.webui-popover.min.css"
	rel="stylesheet">
<style>
[class*="span"] {
	margin-left: 0;
}
</style>
<script type="text/javascript">
  var eventName = "orderBranchReserveForm";
	//加载所有空房
   var emptyRoomMap = [];
	function loadEmptyRooms(storeId,s) {
		$.ajax({
			url : "${ctx}/setting/ctTable/selectByStoreId",
			type : "post",
			dataType : "json",
			data : {
				"storeId" : storeId,
				"tableNos":s
			},
			success : function(result) {
				if (result.length > 0) {
					for (var i = 0; i < result.length; i++) {
						if (emptyRoomMap[result[i].typeId] == null)
						emptyRoomMap[result[i].typeId] = [];
						emptyRoomMap[result[i].typeId].push(result[i]);
						
					}
					console.log(emptyRoomMap);
				}

			}
		});
	}

	//一键分房

	function branchRoom(storeId) {
		var s = "";
		$("input[name='tableTypeId']").each(function(i, n) {

			if ($(this).val() != "") {

				s += $(this).val() + ",";
			}

		});
		loadEmptyRooms(storeId,s);
		$("input[name='tableTypeId']").each(function(i, n) {

			if (n.value != "") {
				return true;

			}
			var typeId = $(n).attr("data-roomtype");

			$.each(emptyRoomMap[typeId], function(j, m) {
				
					if (!m.distributed) {
						n.value = m.no;
						$(n).attr("date-tableId", m.id);
						m.distributed = true;
						return false;
					}
				
		
			});
		});
	}

	//一键清空
	function cleanInput(storeId) {
				var ordReserveId=$("#ordReserveId").val();
				$.ajax({
					type : "post",
					dataType : "json",
					url : "${ctx}/reserve/cleanTableNo",
					async : false,
					data : {
						"ordReserveId":ordReserveId,
						"storeId":storeId
					},
					success : function(result) {
						if (result.retCode == "000000") {
							$("input[name='tableTypeId']").each(function(i, n) {
								$(this).val('');
							});
							layer.confirm("清空完成", {
								btn : [ '确定' ]
							}, function(index) {
								top.$.publish("reserveList",{testData:"hello"});
								window.parent.jBox.close();
							}, function() {
								return;
							});
						} else {
							layer.alert(result.retMsg);
						}
					},
					error : function(result, status) {
						layer.alert("系统错误");
					}
				});


	}
	//手动分房
	function chooseRoom(tableType, storeId, id) {
		var s = "";
		$("input[name='tableTypeId']").each(function(i, n) {

			if ($(this).val() != "") {

				s += $(this).val() + ",";
			}

		});
		$.jBox.open("iframe:${ctx}/reserve/toChoseTableNoForm?eventName="
				+ eventName + "&tableType=" + tableType + "&storeId=" + storeId
				+ "&roomNo=" + s + "&reserveId=" + id, "选择房间", 800, 500, {
			buttons : {},
			loaded : function(h) {
				$(".jbox-content", document).css("overflow-y", "hidden");
			}
		});
	}

	//房间选中返回
	function selectedRoom(roomMap) {
		var tableId = roomMap["tableId"]; //房间编号
		var tableNo = roomMap["tableNo"]; //房间编号
		var reserveId = roomMap["reserveId"];
		$('#' + reserveId).val(tableNo);
		$("#" + reserveId).attr("date-tableId", tableId);
		window.jBox.close();
	}

	
	//保存分房信息
	function save() {
		var ordReserveId=$("#ordReserveId").val();
		var list = [];
		$("input[name='tableTypeId']").each(function(i, n) {
			var tableId = $(n).attr("date-tableId");
			var reserveId = $(n).attr("data-reserveId");
			var tableNo = $(n).val();
			
			var temp ={id:reserveId,tableNo:tableNo,tableId:tableId,unionReserveId:ordReserveId}; 
			list.push(temp);
			

		});
		var list =JSON.stringify(list);
		
		$.ajax({
			type : "post",
			dataType : "json",
			url : "${ctx}/reserve/reserveSetTableNo",
			data : {
				"list":list
				
			},
			success : function(result) {
				if (result.retCode == "000000") {
					top.$.publish("${param.eventName}", {
						testData : "hello"
					});
					layer.alert(result.retMsg);
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


</script>
<style>
#clearCardBox {
	display: none;
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	background-color: rgba(0, 0, 0, .5);
	height: 100%;
}

#clearCardBox .box {
	position: absolute;
	top: 60px;
	left: 120px;
	width: 750px;
	background-color: #fff;
	height: 400px;
}

#clearCardBox .box .title {
	height: 40px;
	line-height: 40px;
	text-align: center;
	background-color: #31B080;
	color: #fff;
}

#clearCardBox .box .title h4, #clearCardBox .box .title .card-close {
	display: inline-block;
}

#clearCardBox .box .title .card-close {
	float: right;
	font-size: 40px;
	margin-top: -2px;
	cursor: pointer;
}

#clearCardBox .bg-active {
	background-color: #DEF5E3;
}

#clearCardBox tr .btns {
	text-align: center;
}
</style>
</head>
<body>
	<form id="inputForm" modelAttribute="ordReserve" method="post"
		class="form-horizontal">

		<input type="hidden" id="ordReserveId" value="${ordUnionReserve.id}">
		<div class="row">
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><span class="notice">*</span>联系人：</label>
					<div class="controls">
						<input type="text" id="name" name="name" readonly="readonly"
							class="required" value="${ordUnionReserve.name}">
					</div>
				</div>
			</div>
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><span class="notice">*</span>联系方式：</label>
					<div class="controls">
						<input type="text" id="phone" name="phone" maxlength="32" readonly="readonly"
							class="required" value="${ordUnionReserve.phone}">
					</div>
				</div>
			</div>
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><span class="notice">*</span>用餐时间：</label>
					<div class="controls">
						<input id="useDate" style="margin-right: 3px;" name="useDate"
							type="text" readonly="readonly" maxlength="20"
							class="Wdate input-medium6" value="${ordUnionReserve.useDate}"
							pattern="yyyy-MM-dd"
							 />
					</div>
				</div>
			</div>

			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><span class="notice">*</span>用餐时段：</label>


					<div class="controls">
						<c:if test="${ordUnionReserve.useLevel=='1'}">
							<input type="text" id="useLevel" name="useLevel" maxlength="32"
								readonly="readonly" class="required digits" value="早餐">
						</c:if>
						<c:if test="${ordUnionReserve.useLevel=='2'}">
							<input type="text" id="useLevel" name="useLevel" maxlength="32"
								readonly="readonly" class="required digits" value="中餐">
						</c:if>
						<c:if test="${ordUnionReserve.useLevel=='3'}">
							<input type="text" id="useLevel" name="useLevel" maxlength="32"
								readonly="readonly" class="required digits" value="晚餐">
						</c:if>
					</div>

				</div>
			</div>

		</div>
		<div class="row">
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><span class="notice">*</span>客源：</label>
					<div class="controls">
						<select id="sourceId" name="source" readonly="readonly">
							<c:forEach items="${sourceList}" var="source">
								<option value="${source.paramKey}" sourceName="${source.name}"
									<c:if test="${ordUnionReserve.source==source.paramKey}">selected="selected"</c:if>>${source.name}</option>
							</c:forEach>
						</select>
					</div>
				</div>
			</div>

			<div class="span">
				<div class="control-group">
					<label class="control-label-xs">业务员：</label>
					<div class="controls">
						<select id="salesman" name="salsman" class="select-medium4" readonly="readonly"
							value="${ordUnionReserve.salesPerson}">
						</select>
					</div>
				</div>
			</div>

			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><span class="notice">*</span>用餐类别：</label>
					<div class="controls">
					
					<c:if test="${ordUnionReserve.useType=='st'}">
							<input type="text" id="useType" name="useType" maxlength="32"
								readonly="readonly" class="required digits" value="散台">
						</c:if>
						<c:if test="${ordUnionReserve.useType=='yx'}">
							<input type="text" id="useType" name="useType" maxlength="32" 
								readonly="readonly" class="required digits" value="宴席">
						</c:if>
						<c:if test="${ordUnionReserve.useType=='hy'}">
							<input type="text" id="useType" name="useType" maxlength="32" 
								readonly="readonly" class="required digits" value="会议">
						</c:if>
					
					</div>
				</div>
			</div>
		</div>

		<div class="row">
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs">备注：</label>
					<div class="controls">
						<textarea id="remarks" name="remarks" rows="5" maxlength="255" readonly="readonly"
							class="input-xxlarge">${ordUnionReserve.remarks}</textarea>
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<span style="display: block; text-align: right"> <input
				class="btn btn-primary" type="button" value="一键分台"
				onclick="branchRoom('${ordUnionReserve.storeId}')" /> <input class="btn btn-primary"
				type="button" value="一键清空" onclick="cleanInput('${ordUnionReserve.storeId}')" />
			</span>

		</div>
		<div class="row">
			<ul class="nav nav-tabs" style="margin-top: 0;">
				<li id="roomsLi" class="active"><a href="#"
					onclick="getChecked()">分房信息</a></li>
			</ul>
			<div id="roomTypeList">

				<c:forEach items="${ordUnionReserveDetail}" var="item">

					<div class="span">
						<label class="control-label-xs" style="font-size: 14px;">桌型：</label><label
							class="control-label" style="font-size: 14px;">${item.tableTypeName}</label>
						<div
							style="clear: both; width: 920px; border-bottom: 1px dashed #31B080; margin-left: 40px;"></div>

						<c:forEach items="${item.reserveList}" var="var">
							<label style="margin-left: 40px;"> <input type="text"
								placeholder="--请选择--" name="tableTypeId" id="${var.id}" value="${var.tableNo}" data-reserveId="${var.id}" date-tableId='${var.tableId}' data-roomtype="${item.tableType}"
								readonly="readonly" onclick="chooseRoom('${item.tableType}','${item.storeId}','${var.id}')"
								style="width: 80px; margin-left: 10px; margin-top: 10px;" />


							</label>
						</c:forEach>
					</div>
				</c:forEach>

			</div>

		</div>
	<div class="fixed-btn-right">
		<input id="btnSubmit" class="btn btn-primary" type="button" onclick="save()" value="确 定"/>&nbsp;
	</div>	
	</form>
</body>
</html>