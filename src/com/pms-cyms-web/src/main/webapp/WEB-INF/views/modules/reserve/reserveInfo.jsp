<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<script type="text/javascript">
	<!--字典map-->
	var sourceMap = {};
	<c:forEach items="${fns:getSysBusiConfigList('source','')}" var="var">
		sourceMap["${var.paramKey}"]="${var.name}";
	</c:forEach>
	$(document).ready(function() {
		$("#toggle").click(function() {
			$("#guestTable").slideToggle();
		});
		$("input[name='secretFlag']").click(function() {
			stopBubbling(event);
		});
		//修改备注
		var statu = 0;
		var edit = document.getElementById('edit');
		if(edit != undefined){
			edit.onclick = function() {
				var item = document.getElementsByClassName('leader');
				var item_length = item.length
				var item_value = new Array(item_length);
				for (i = 0; i < item_length; i++) {
					item_value[i] = item[i].innerHTML;
				}
				if (statu == 0) {
					edit.innerHTML = '<i class="icon icon-save"></i>';
					for (i = 0; i < item_length; i++) {
						item[i].innerHTML = "<textarea class='input-xxlarge' row='2'>" + item_value[i] + "</textarea>";
					}
					statu = 1;
					$("input[name='secretFlag']").removeAttr("disabled");
				} else {
					edit.innerHTML = '<i class="icon icon-edit"></i>';
					var item_input = document.getElementsByClassName('input-xxlarge');
					for (i = 0; i < item_length; i++) {
						item_value[i] = item_input[i].value;
					}
					for (i = 0; i < item_length; i++) {
						item[i].innerHTML = item_value[i];
					}
					statu = 0
					updateOrderRemarks();
					$("input[name='secretFlag']").attr("disabled","disabled");
				}
				return false;
			};
		}
	});
	
	//加载订单信息
	function getOrdTableById(){
		var orderId = '${orderId}';
		var params = {orderId:orderId};
		loadAjax("${ctx}/order/ordTable/getOrdTableById",params,function(result){
			if(result.retCode=="000000"){
				var ordTable = result.ret.ordTable;
				var sourceName = sourceMap[ordTable.source];
				if(sourceName=="会员"||sourceName=="协议单位"){
					$("#tr1").show();
					$("#tr2").hide();
					$("#sourceName").html(sourceName);
					$("#_sourceName").html(sourceName);
					$("#thirdPartName").html(ordTable.thirdPartName);
					$("#memberName").html(ordTable.memberName);
					$("#memberPhone").html(ordTable.memberPhone);
				}else{
					$("#tr1").hide();
					$("#tr2").show();
					$("#sourceName2").html(sourceName);
					$("#memberName2").html(ordTable.memberName);
					$("#memberPhone2").html(ordTable.memberPhone);
				}
				$("#tableNo").html(ordTable.tableNo);
				$("#useNum").html(ordTable.useNum);
				$("#createDate").html(ordTable.createDate);
				$("#settleDate").html(ordTable.settleDate);
				$("#salesman").html(ordTable.salesman.name);
				$("#remarks").html(ordTable.remarks);
				$("#useNum").html(ordTable.useNum);
			}else{
				layer.alert(result.retMsg);
				return;
			}
		})	
	}
	
	//修改备注
	function updateOrderRemarks(){
		var orderId = '${orderId}';
		var remarks = $("#remarks").html();
		var params = {orderId:orderId,remarks:remarks};
		loadAjax("${ctx}/order/ordTable/updateOrderInfo",params,function(result){
			if(result.retCode=="000000"){
				layer.confirm(result.retMsg, {
  				  btn: ['确定'] 
  				}, function(index){
  					layer.close(index);
  				}, function(){
  					return ;
  				});
			}else{
				layer.alert(result.retMsg);
				return;
			}
		});
	}
	//协议单位详情
	function agreementGroupDetail(obj){
		layer.open({
		  type: 1,
		  skin: 'layui-layer-demo', //样式类名
		  closeBtn: 0, //不显示关闭按钮
		  anim: 2,
		  shadeClose: true, //开启遮罩关闭
		  content: "<div style='margin:10px;'>协议编号：${cmGroup.agreementCode}</br>单位名称：${cmGroup.name}</br>归属酒店：${cmGroup.officeName}</br>业务员：${cmGroup.userName}</br>业务员电话：${cmGroup.userPhone}</br></div>"
		});
	}
</script>
<style>
	.fa-icon{position:relative;}
	.fa-icon i{
		position: absolute;
	    left: -15px;
	    top: 3px;
	    color: blue;
	    font-size: 16px;
	}
</style>
<div>
	<div class="form-horizontal" style="margin-bottom:0;">
		<table style="width:100%;color:#555;">
			<colgroup>
				<col width="25%">
				<col width="25%">
				<col width="25%">
				<col width="25%">
			</colgroup>
			<tbody>
				<tr>
					<td><label>台号：<span id="tableNo">${tableNo }</span></label></td>
					<td><label>用餐人数：<span id="useNum">${useNum }</span></label></td>
					<td><label>预订时间：<span id="createDate"><fmt:formatDate value="${ordUnionReserve.createDate }" type="date" pattern="yyyy-MM-dd HH:mm"/></span></label></td>
					<td><label>结账时间：<span id="settleDate"></span></label></td>
				</tr>
				<tr id="tr1">
					<td><label>客源：<span id="sourceName">${ordUnionReserve.source }</span></label></td>
					<td><label><span id="_sourceName"></span>：<span id="thirdPartName"></span></label></td>
					<td><label>联系人：<span id="memberName">${ordUnionReserve.name }</span></label></td>
					<td><label>联系电话：<span id="memberPhone">${ordUnionReserve.phone }</span></label></td>		
				</tr>
				<tr id="tr2">
					<td><label>客源：<span id="sourceName2">${ordUnionReserve.source }</span></label></td>
					<td><label>联系人：<span id="memberName2">${ordUnionReserve.name }</span></label></td>
					<td><label>联系电话：<span id="memberPhone2">${ordUnionReserve.phone }</span></label></td>
					<td><label>用餐类型：<span id="memberPhone2">${ordUnionReserve.useLevelName }</span></label></td>
				</tr>
				<tr>
					<td><label>业务员：<span id="salesman">${ordUnionReserve.salesPerson }</span></td>
				</tr>
				<tr>
					<td colspan="4">
						<label>备注：<span class="leader" id='remarks'></span>
							<shiro:hasPermission name="index:order:checkIn">
								<span style="top:30px;left:215px;font-size:18px;">
									<span>${ordUnionReserve.remarks }<a id="edit" href="#"><i class="icon icon-edit"></i></a></span>
								</span>
							</shiro:hasPermission>
						</label>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>