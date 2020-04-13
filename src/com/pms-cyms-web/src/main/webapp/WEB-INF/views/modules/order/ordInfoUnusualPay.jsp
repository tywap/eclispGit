<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		//getUnusualPayList();
	});
	
	//查询表格
	function getUnusualPayList(){
		var isUnion = "0";
		var orderId = '${orderId}';
		var params = {orderId:orderId,isUnion:isUnion};
		loadAjax("${ctx}/pay/getUnusualPayList",params,function(result){
			if(result.retCode=="000000"){
				var totalAmount = 0;
				var list = result.ret.list;
				var html = "";
				$("#tableBody6").empty();
				for(var i=0;i<list.length;i++){
					var obj = list[i];
					var htmlTemp = 
						"<tr>"+
							"<td>"+obj.id+"</td>"+
							"<td>"+(obj.refundFlag=='0'?'支付':'退款')+"</td>"+
							"<td>"+obj.payWayName+"</td>"+
							"<td>"+obj.amount+"</td>"+
							"<td>"+obj.payStatus+"</td>"+
							"<td>"+obj.subject+"</td>"+
							"<td>"+obj.operator+"</td>"+
							"<td>"+obj.createDate+"</td>"+
							"<td>"+"<a class='update' data-id='"+obj.id+"' payId='"+obj.id+"' roomNo='"+obj.roomNo+"' onclick='addPayDetail(this);'>补录账务</a>"+"</td>"+
						"</tr>";
					html += htmlTemp;	
				}
				$("#tableBody6").append(html);
		    }else{
				layer.alert(result.retMsg);
		    }
		});
	}
	
	//添加账务明细
	function addPayDetail(obj){
		var isUnion = "0";
		var orderId = '${orderId}';
		var payId = $(obj).attr("payId");
		var roomNosStr = $(obj).attr("roomNo");
		var params = {orderId:orderId,isUnion:isUnion,payId:payId,roomNosStr:roomNosStr};
		loadAjax("${ctx}/pay/entryUnusualPay",params,function(result){
			if(result.retCode=="000000"){
				$.jBox.confirm("账务补录成功", "提示", function (v, h, f) {
				    if (v == true){
				    	getUnusualPayList();
				    }
				    return true;
				}, { buttons: { '确定': true}});
			}else{
    			$.jBox.alert(result.retMsg);
    	    }
		})	
	}
</script>
<div>
	<form:form id="inputForm5" action=" " method="post" class="form-horizontal">
		<div class="row">
			<table id="contentTable5" class="table table-striped table-bordered table-condensed" style="width:100%;">
				<thead>
					<tr>
						<th>支付流水</th>
						<th>类型</th>
						<th>方式</th>
						<th>金额</th>
						<th>状态</th>
						<th>摘要</th>
						<th>操作工号</th>
						<th>操作时间</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody id="tableBody6">
				</tbody>
			</table>
		</div>
	</form:form>
</div>