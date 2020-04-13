<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>开关房</title>
<meta name="decorator" content="default" />
<style>
	.form-horizontal .controls{
		margin-left:0 !important;
	}

</style>
</head>
<body>
		<div class="row">
			<div class="span"  >
				<div class="control-group">
					<label class="control-label-xs">价格类型：</label>
					<div class="controls">
						${detailMap.rePriceType}
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="span"  >
				<div class="control-group">
					<label class="control-label-xs">调整时段：</label>
					<div class="controls">
						 <input type="text"	readonly="readonly" style="margin-right:3px;" class="input-medium6 Wdate "
				value="${detailMap.startDate}" />-
						<input type="text"	readonly="readonly" style="margin-right:3px;" class="input-medium6 Wdate "
				value="${detailMap.endDate}" />
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="span"  >
				<div class="control-group">
					<label class="control-label-xs">房型：</label>
					<div class="controls">
						<c:forEach items="${detailMap.roomTypeList}" var="roomType" >
							${roomType},
						</c:forEach>
					</div>
				</div>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label-xs">租类开关：</label>
		</div>
		<div class="row">
			<div class="span"  >
				<div class="control-group">
					<div class="controls">
						<c:forEach  items="${detailMap.operateRent}" var="operate">
							<div class="span">
								<div class="control-group">
						    		<label class="control-label-xs">${operate.rentName}</label>
						    		<div class="controls">
								    	${operate.operateValue}
									</div>
								</div>
							</div>
						</c:forEach>
					</div>
				</div>
			</div>
		</div>
</body>

</html>