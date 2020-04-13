<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>选择房间</title>
	<meta name="decorator" content="default"/>

</head>

<body>
<style>
	.labelTr label{
		position:absolute;
		width:96%;
		height:37px;
		margin-top:-8px;
		margin-left:-8px;
	}
	.table tr td input:focus{
		border:none;
	}
</style>
<script>


	 



function saveRoom()
{
    $.each($('input:radio:checked'),function(){
		var roomMap={};
		roomMap["tableId"]=$(this).val();
		roomMap["tableNo"]=$(this).attr("tableNo");
		roomMap["reserveId"]=$(this).attr("reserveId");
		parent.selectedRoom(roomMap);
		
		
	});
    
}

</script>
	<div class="form-horizontal">

		<div class="form-horizontal">
			<table id="contentTable" class="table table-bordered">
				<thead>
					<tr>
						<th>选择</th>
						<th>台号</th>
						<th>房态</th>
						<th>台型</th>
					</tr>
				</thead>
				<tfoot>
					<c:forEach items="${ctTableList}" var="table">
						<tr class='labelTr'>
							<td><input type="radio" name="radio" value="${table.id}"
								tableNo="${table.no}" reserveId="${reserveId}" /></td>
							<td>${table.no}</td>
							<td><c:if test="${'cleanEmpty' eq table.status}">空台</c:if></td>
							<td>${table.typeId}</td>
						</tr>
					</c:forEach>

				</tfoot>
			</table>
		</div>
		<div class="fixed-btn-right">
			<input id="btnSubmit" class="btn btn-primary" type="button"
				onclick="saveRoom()" value="确 定" />&nbsp;
		</div>

	</div>
</body>
</html>