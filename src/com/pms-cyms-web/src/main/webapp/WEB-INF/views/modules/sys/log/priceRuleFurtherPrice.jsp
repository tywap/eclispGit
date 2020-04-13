<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>远期价格调整</title>
	<meta name="decorator" content="default"/>

</head>
<body>
<style>
		.table tr td input{
			width:85%;
		}
		td input[type="text"]{
		 	border:1px solid #e8e8e8;
		 	border-radius:0;	
		}
		.input-append .btn{margin-left:-35px;}
		.control-label{min-width:60px;}  
	</style>
<div class="form-horizontal">
	<div class="breadcrumb form-search">
		<div class="row">
			<div class="span">
				<div class="control-group">
					<label class="control-label">应用门店：</label>
					<div class="controls">
						${detailMap.storeList}
					</div>
				</div>
			</div>
		</div>
		<hr />
		<div id="adjustTimes">
			<div class="row timeRow">
				<div class="span">
					<div class="control-group">
						<label class="control-label">调整时段：</label>
						<div class="controls">
						<c:forEach items="${detailMap.startDateList}" var="startDate" varStatus="status">
							<input type="text" readonly="readonly"  class="input-medium6 Wdate " style="margin-right:3px;" value="${startDate}"/>-
							<input type="text" readonly="readonly" class="input-medium6 Wdate " value="${detailMap.endDateList[status.index]}"/>
						</c:forEach>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<hr />
		<div class="row">
			<div class="span">
				<div class="control-group">
					<label class="control-label">调整星期：</label>
					<div class="controls">
						<li>
							<label><input type="checkbox" value="1" <c:if test="${fn:indexOf(detailMap.weekendList, '1')>-1}">checked="checked"</c:if> />周一</label>
							<label><input type="checkbox" value="2" <c:if test="${fn:indexOf(detailMap.weekendList, '2')>-1}">checked="checked"</c:if> />周二</label>
							<label><input type="checkbox" value="3" <c:if test="${fn:indexOf(detailMap.weekendList, '3')>-1}">checked="checked"</c:if> />周三</label>
							<label><input type="checkbox" value="4" <c:if test="${fn:indexOf(detailMap.weekendList, '4')>-1}">checked="checked"</c:if> />周四</label>
							<label><input type="checkbox" value="5" <c:if test="${fn:indexOf(detailMap.weekendList, '5')>-1}">checked="checked"</c:if> />周五</label>
							<label><input type="checkbox" value="6" <c:if test="${fn:indexOf(detailMap.weekendList, '6')>-1}">checked="checked"</c:if> />周六</label>
							<label><input type="checkbox" value="0" <c:if test="${fn:indexOf(detailMap.weekendList, '0')>-1}">checked="checked"</c:if> />周日</label>
						</li>
					</div>
				</div>
			</div>
		</div>
		<hr />
		<div class="row">
			<div class="span">
				<div class="control-group">
					<label class="control-label">基于：</label>
					<div class="controls">
						${detailMap.changBase}——${detailMap.changType}
					</div>
				</div>
			</div>
		</div>
		
		<hr />
		<div id="div_container" >			
			<div id="my_div" class="fakeContainer first_div">
				<table class="table table-bordered center" id="demoTable">
					<thead>
						<tr id="my_tr">
							<th>房型</th>
							<c:forEach items="${detailMap.rentList}" var="rent">
								<c:if test="${rent.id=='2'}">		<!-- 钟点房 -->
									<th>${rent.name}(起钟)</th>
								</c:if>
								<c:if test="${rent.id!='2'}">		<!-- 其他 -->
									<th>${rent.name}</th>
								</c:if>
							</c:forEach>
						</tr>
					</thead>
					<tbody id="tableTbody">
						<c:forEach items="${detailMap.roomTypeList}" var="roomType">
							<tr>
							<td>${roomType.roomTypeName}</td>
							<c:forEach items="${detailMap.rentList}" var="rent">
								<td><input type='text' value="${detailMap.priceDetail[roomType.id.concat('@').concat(rent.id)]}" /></td>
							</c:forEach>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>
</div>
</body>
</html>