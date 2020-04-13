<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>价格调整</title>
	<meta name="decorator" content="default"/>
<style>
    table,table tr th, table tr td { border:1px solid #ccc; }
	ul,li{margin:0;list-style:none !important;}
	.table tr td input, .table tr td select{
		width:86%;
	}
	.breadcrumb .ul-form{
		display: inline-block;
    	vertical-align: top;
	}
	#sourceAndChannelSelectd{
		display:none;
		border-radius: 4px;
	    background-color: #eee;
	    border: 1px solid #ddd;
	    padding: 3px 10px;
	}
	td input[type="text"] {
	    padding: 1px 3px;
	}
	.form-search .ul-form li{
		height: inherit;
	}
</style>
</head>
<body>
	<div class="form-horizontal">
	<div class="form-search">	
		<ul class="ul-form">
			<li>
				<label>应用门店：</label>
				${detailMap.storeList}
		    </li>
			<li>
				<label>渠道客源：</label>
				${detailMap.source}
			 </li>
		</ul>
	</div>
		<div id="searchForm">
		<div id="div_container" >			
			<div id="my_div" class="fakeContainer first_div">
				<table class="table table-bordered center" id="demoTable">
					<thead>
						<tr id="my_tr">
							<th rowspan='2' style='min-width: 100px;'>房型</th>
							<c:forEach items="${detailMap.rentList}" var="rent">
									<th colspan="2">${rent.name}</th>
							</c:forEach>
						</tr>
						<tr>
							<c:forEach items="${detailMap.rentList}" var="rent">
									<th>${detailMap.type}</th>
									<th>配额</th>
							</c:forEach>
						</tr>
					</thead>
					<tbody id="tableTbody">
					
						<c:forEach items="${detailMap.roomTypeList}" var="roomType">
							<tr>
							<td>${roomType.roomTypeName}</td>
							<c:forEach items="${detailMap.rentList}" var="rent">
								<td><input type='text' value="${detailMap.priceMap[roomType.id.concat('@').concat(rent.id)]}" /></td>
								<td><input type='text' value="${detailMap.peMap[roomType.id.concat('@').concat(rent.id)]}" /></td>
							</c:forEach>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
		</div>
	</div>			
		
		<%-- <div class="fixed-btn-right">
			<shiro:hasPermission name="mkt:edit"><input id="btnSubmit" class="btn btn-primary" type="button" onclick="saveMktDetail()" value="保 存"/>&nbsp;</shiro:hasPermission>
		</div> --%>
		
</body>
</html>