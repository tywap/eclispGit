<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>编辑方案</title>
	<meta name="decorator" content="default"/>
</head>
<body>
<div class="form-horizontal">
	<div class="breadcrumb form-search" style="padding:0px;">
		<div class="control-group">
			<div class="span">
				<label class="control-label" style="">应用门店：${detailMap.storeList}</label>
			</div>	
		</div>
		<div class="control-group">
			<label class="control-label">基于：</label>
			${detailMap.changBase}——${detailMap.changType}
		</div>
	<div id="div_container" >
		<div id="my_div" class="fakeContainer first_div">
			<table class="table table-bordered center" id="demoTable">
				<thead>
					<tr id="my_tr">
					<th rowspan="2">房型</th>
					<c:forEach items="${detailMap.rentList}" var="rent">
						<c:if test="${rent.rent_type=='2'}">		<!-- 钟点房 -->
							<th colspan='2'>${rent.name}</th>
						</c:if>
						<c:if test="${rent.rent_type!='2'}">		<!-- 其他 -->
							<th rowspan="2">${rent.name}</th>
						</c:if>
					</c:forEach>
				</tr>
				<tr>
					<c:forEach items="${detailMap.rentList}" var="rent">
						<c:if test="${rent.rent_type=='2'}">		
							<th>起钟</th><th>加钟</th>
						</c:if>
					</c:forEach>
				</tr>
			</thead>
			<tbody id="tableTbody">
				<c:forEach items="${detailMap.roomTypeList}" var="roomType">
					<tr>
					<td>${roomType.roomTypeName}</td>
					<c:forEach items="${detailMap.rentList}" var="rent">
						<td><input type='text' value="${detailMap.priceDetail[roomType.id.concat('@').concat(rent.id).concat('@0')]}" /></td>
						<c:if test="${rent.rent_type=='2'}">
							<td><input type='text' value="${detailMap.priceDetail[roomType.id.concat('@').concat(rent.id).concat('@1')]}" /></td>
						</c:if>
					</c:forEach>
					</tr>
				</c:forEach>
			</tbody>
			</table>
		</div>
	</div>

		<ul class="ul-form" style="margin-top:10px;">
			<li>
				<label class="control-label">周末价：</label>
				<label>
					${detailMap.weekendPrice}
				</label>
			</li>
			<c:if test="${!empty detailMap.weekendDays}">
				<li style="height:auto;">
					${detailMap.weekendDays}
					<label>差异金额：<input type="text" class="input-medium4" value="${detailMap.weekendMoney}" /> 正数为上调，负数为减少。</label> <br />
					<label>${detailMap.weekendRent}</label>
				</li>
			</c:if>
			<li>
				<label>修改房价：</label>
				<label>
					${detailMap.canUpdate}
				</label>
			</li>
			<li id="updateMoneyLi" >
				<label>最高减免金额：</label>
				<label>
					<input type="text"  class="input-medium6" value="${detailMap.updateMoney}" />
				</label>
			</li>
			<li>
				<label>早餐情况：</label>
				<label>
					${detailMap.breakfast}
				</label>
			</li>
		</ul>
	</div>
</div>

</body>
</html>