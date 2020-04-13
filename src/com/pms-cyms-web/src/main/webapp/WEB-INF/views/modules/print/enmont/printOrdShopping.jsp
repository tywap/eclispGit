<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
	<head>
		<meta name="decorator" content="default"/>
		<title>销售单</title>
		<link href="${ctxStatic}/common/print-default.css" rel="stylesheet">
		<script type="text/javascript">
			$(document).ready(function() {
				$("body").bind("keypress", function(event) {
					if (event.keyCode == "13") window.print();
				});
			});
		</script>
	</head>
	<body>
		<div class="container container-245">
			<div class="header">
				${office.name}
				<div class="header-type">销售单</div>
			</div>
			<div class="lines"></div>
			<table class="item-normal">
				<tr>
					<td style="width:42px;">单号：</td>
					<td>${shoppingId}</td>
				</tr>
			</table>
			<table class="item-normal">
				<tr>
					<td style="width:68px;">操作时间：</td>
					<td>${creatTime}</td>
				</tr>
			</table>
			<div class="lines"></div>
			<div class="sub-header">
				消费金额
			</div>
			<table class="item-fixed">
				<thead>
					<tr>
						<th>名称</th>
						<th style="width:48px;">单价</th>
						<th style="width:38px;">数量</th>
						<th style="width:48px;">金额</th>
					</tr>
				</thead>
				<tbody>
					<c:set var="costTotal" value="0"/>
					<c:forEach items="${costList}" var="cost">
						<tr style="text-align: center;">
							<td class="overflow">${cost.name}</td>
							<td><fmt:formatNumber type="number" value="${cost.price}" pattern="0.00" maxFractionDigits="2"/></td>
							<td>${cost.count}</td>
							<td>${cost.amount}</td>
							<c:set var="costTotal" value="${cost.amount+costTotal}"/>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			<table class="item-width">
				<tr>
					<td style="width:40px;">合计：</td>
					<td style="text-align:right;">${costTotal}</td>
				</tr>
			</table>
			<div class="lines"></div>
			<div class="sub-header">
				收款金额
			</div>
			<table class="item-fixed">
				<thead>
					<tr>
						<th>方式</th>
						<th style="width:48px;">金额</th>
					</tr>
				</thead>
				<tbody>
					<c:set var="payTotal" value="0"/>
					<c:forEach items="${ordPaymentFunds}" var="payMentFund">
						<tr style="text-align: center;">
							<td class="overflow">${fns:getNameByParamKey(payMentFund.payMethod,'payWay')}</td>
							<td>${payMentFund.amount}</td>
							<c:set var="payOne" value="${payMentFund.amount} "/>
							<c:set var="payTotal" value="${payTotal+payOne}"/>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			<table class="item-diwth">
				<tr>
					<td style="width:40px;">合计：</td>
					<td style="text-align:right;"><fmt:formatNumber type="number" value="${payTotal}" pattern="0.00" maxFractionDigits="2"/></td>
				</tr>
			</table>
			<div class="lines"></div>
			<table class="item-width">
				<tbody>
					<tr>
						<td style="width:88px; text-align:right;">费用总计：</td>
						<td style="text-align:center;">${costTotal}</td>
					</tr>
					<tr>
						<td style="width:88px; text-align:right;">实收总计：</td>
						<td style="text-align:center;">
							<fmt:formatNumber type="number" value="${payTotal}" pattern="0.00" maxFractionDigits="2"/>
						</td>
					</tr>
					<tr>
						<td style="width:88px; text-align:right;">余额：</td>
						<td style="text-align:center; font-weight:bold;">
							<fmt:formatNumber type="number" value="${payTotal-costTotal}" pattern="0.00" maxFractionDigits="2"/>  
						</td>
					</tr>
				</tbody>
			</table>
			<!-- 暂时不用
			<div class="lines"></div>
			<table class="item-width">
				<tbody>
					<tr>
						<td style="width:88px; text-align:right;">卡号：</td>
						<td style="text-align:center;">[#]</td>
					</tr>
					<tr>
						<td style="width:88px; text-align:right;">可用余额：</td>
						<td style="text-align:center;">[#]</td>
					</tr>
					<tr>
						<td style="width:88px; text-align:right;">可用积分：</td>
						<td style="text-align:center;">[#]</td>
					</tr>
				</tbody>
			</table>
			-->
			<div class="lines"></div>
			<div class="signin">客人签名：</div>
			<div class="lines"></div>
			<div class="reminder">暂无</div>
			<table class="item-width">
				<tr>
					<td style="width:70px; text-align:right;">打印时间：</td>
					<td style="text-align:center;"><fmt:formatDate value="${Time}" pattern="yyyy-MM-dd HH:mm"/></td>
				</tr>
			</table>
			<table class="item-width">
				<tr>
					<td style="width:70px; text-align:right;">打印次数：</td>
					<td style="width:30px;">1</td>
					<td style="width:58px; text-align:right;">打印人：</td>
					<td style="text-align:left;">${user}</td>
				</tr>
			</table>
		</div>
		<div class="sidebar" media="print">
			<button id="sidebar-print" type="button" class="btn btn-primary" onclick="javascript:window.print();">打 印</button>
			<button id="sidebar-cancel" type="button" class="btn btn-danger" onclick="javascript:window.close();">取 消</button>
		</div>
	</body>
</html>