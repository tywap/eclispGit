<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
	});
	
	//查询表格
	function getOrdLogByOrdId(){
		var orderId = '${id}';
		var params = {orderId:orderId};
		loadAjax("${ctx}/order/ordLog/getOrdLogsByOrdId",params,function(result){
			if(result.retCode=="000000"){
				var html = "";
				var list = result.ret.list;
				for(var i=0;i<list.length;i++){
					var seq = i+1;
					var obj = list[i];
					var htmlTemp = 
						"<tr>"+
							"<td>"+seq+"</td>"+
							"<td>"+obj.roomNo+"</td>"+
							"<td>"+obj.accountDate+"</td>"+
							"<td>"+obj.createDateStr+"</td>"+
							"<td>"+obj.type+"</td>"+
							"<td>"+obj.description+"</td>"+
							"<td>"+(obj.createByName==undefined?'system':obj.createByName)+"</td>"+
						"</tr>";
					html += htmlTemp;	
				}
				$("#ordLogTableBody").html(html);
		    }else{
				layer.alert(result.retMsg);
		    }
		});
	}
</script>
<div>
	<form:form id="inputForm5" action=" " method="post" class="form-horizontal">
		<div class="row">
			<table id="contentTable5" class="table table-striped table-bordered table-condensed" style="width:100%;">
				<thead>
					<tr>
						<th>序号</th>
						<th>台号</th>
						<th>账务日期</th>
						<th>操作时间</th>
						<th>操作类型</th>
						<th>摘要</th>
						<th>操作工号</th>
					</tr>
				</thead>
				<tbody id="ordLogTableBody">
				</tbody>
			</table>
		</div>
	</form:form>
</div>