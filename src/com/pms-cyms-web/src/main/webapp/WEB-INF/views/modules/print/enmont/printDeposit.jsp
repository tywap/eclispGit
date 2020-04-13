<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
	<head>
		<meta name="decorator" content="default"/>
		<title>收款凭证</title>
		<link href="${ctxStatic}/common/print-default.css" rel="stylesheet">
		<script type="text/javascript">
			$(document).ready(function() {
				$("body").bind("keypress", function(event) {
					if (event.keyCode == "13") window.print();
				});
			});
			function doPrint() {
				window.print();
			}
		</script>
	</head>
	<body>
		<div class="container container-245">
			<div class="main-logo">
				<img src="${ctxStatic}/print/logo.png"/>
			</div>
			<div class="header">
				<div class="header-type">收款凭证</div>
			</div>
			<div class="lines"></div>
			<table class="item-normal">
				<tr>
					<td>单号：</td>
					<td>${ordtable.id}</td>
				</tr>
			</table>
			<table class="item-normal">
				<tr>
					<td>接待员：</td>
					<td>${ordtable.salesman.name}</td>
				</tr>
			</table>
			<table class="item-normal">
				<tr>
					<td>台号：</td>
					<td>${ordtable.tableNo}</td>
				</tr>
			</table>
			<table class="item-normal">
				<tr>
					<td>人数：</td>
					<td>${ordtable.useNum}</td>
				</tr>
			</table>
			<table class="item-normal">
				<tr>
					<td>打印时间：</td>
					<td>${date}</td>
				</tr>
			</table>
			<table class="item-normal">
				<tr>
					<td>收款时间：</td>
					<td>${date}</td>
				</tr>
			</table>
			<div class="lines"></div>
			<div class="sub-header">
				收款明细
			</div>
			<table class="item-fixed">
				<thead>
					<tr>
						<th>支付方式</th>
						<th>支付凭证</th>
						<th>金额</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${ordpaymentList}" var="payMentFund">
						<tr>
							<%-- <td>${fns:getNameByParamKey(payMentFund.payMethod,'payWay')}</td> --%>
							<td>${payMentFund.payMethod}</td>
							<td>${payMentFund.payVoucher}</td>
							<td>${payMentFund.amount}</td>
						</tr>
						<%-- <c:set var="itemAll" value="${itemAll+payMentFund.money}"/> --%>
					</c:forEach>
				</tbody>
			</table>
			<table class="item-width">
				<tr>
					<td style="width:40px;">合计：</td>
					<td style="text-align:right;width: 180px">${amount}</td>
				</tr>
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
			<div class="signin" style="float: right;">客人签名：<span style="display: inline-block;width: 100px;border-bottom: 1px solid #333;"></span></div>
		</div>
		<div class="sidebar" media="print">
			<button id="sidebar-print" type="button" class="btn btn-primary" onclick="doPrint();">打 印</button>
			<button id="sidebar-cancel" type="button" class="btn btn-danger" onclick="javascript:window.close();">取 消</button>
		</div>
	</body>
</html>