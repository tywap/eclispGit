<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
	<head>
		<meta name="decorator" content="default"/>
		<title>预订单</title>
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
				<div class="header-type">预订单</div>
			</div>
			<div class="lines"></div>
			<table class="item-normal">
				<tr>
					<td>预订单号：</td>
					<td>${ordId}</td>
				</tr>
			</table>
			<table class="item-normal">
				<tr>
					<td>接待员：</td>
					<td>${salesPerson}</td>
				</tr>
			</table>
			<table class="item-normal">
				<tr>
					<td>用餐日期：</td>
					<td>${useDate}</td>
				</tr>
			</table>
			<table class="item-normal">
				<tr>
					<td>时段：</td>
					<td>${useLevel2}</td>
				</tr>
			</table>
			<table class="item-normal">
				<tr>
					<td>预订台型：</td>
					<td>${tableTypeName}</td>
				</tr>
			</table>
			<table class="item-normal">
				<tr>
					<td>人数：</td>
					<td>${personCount}</td>
				</tr>
			</table>
			<table class="item-normal">
				<tr>
					<td>预订人：</td>
					<td>${name}</td>
				</tr>
			</table>
			<table class="item-normal">
				<tr>
					<td>预订时间：</td>
					<td>${useDate}</td>
				</tr>
			</table>
			<table class="item-normal">
				<tr>
					<td>打印时间：</td>
					<td>${date}</td>
				</tr>
			</table>
			<div class="lines"></div>
			<div class="sub-header">
				预订菜单
			</div>
			<table class="item-fixed">
				<thead>
					<tr>
						<th style="width: 100px;" align="left">菜品</th>
						<th>数量</th>
						<th>单价</th>
						<th>小计</th>
					</tr>
				</thead>
				<tbody>
					<%-- <c:forEach items="${ordpaymentList}" var="payMentFund">
						<tr>
							<td>${fns:getNameByParamKey(payMentFund.payMethod,'payWay')}</td>
							<td>${payMentFund.payVoucher}</td>
							<td>${payMentFund.amount.amount}</td>
						</tr>
						<c:set var="itemAll" value="${itemAll+payMentFund.money}"/>
					</c:forEach> --%>
					<c:forEach items="${ordlist }" var="ordlist">
						<tr>
							<td align="left">${ordlist.name }</td>
							<td><fmt:formatNumber type="" value="${ordlist.count }" pattern="0"/></td>
							<td>${ordlist.price }</td>
							<%-- <td>${ordlist.rateAmount.toFixed(2) }</td> --%>
							<%-- <fmt:formatNumber type="" value="" pattern="0.00" maxFractionDigits="2" /> --%>
							<td><fmt:formatNumber type="" value="${ordlist.amount }" pattern="0.00" maxFractionDigits="2" /></td>
						</tr>
					</c:forEach>
					<tr>
						<td style="width: 100px;" align="left">消费总计</td>
						<td></td>
						<td></td>
						<td>${price }</td>
					</tr>
					<tr>
						<td style="width: 100px;" align="left">折扣<!-- &nbsp;&nbsp;&nbsp;&nbsp;<label>aaa</label> --></td>
						<td></td>
						<td></td>
						<td>${rateamount }</td>
					</tr>
					<tr>
						<td style="width: 100px;" align="left">实际应付：</td>
						<td></td>
						<td></td>
						<td>${payment }</td>
					</tr>
				</tbody>
			</table>
			<div class="lines"></div>
			<div class="sub-header">
				收款明细
			</div>
			<table class="item-fixed">
				<thead>
					<tr>
						<th align="left">支付方式</th>
						<th>支付凭证</th>
						<th>金额</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${ordpaymentList}" var="payMentFund">
						<tr>
							<%-- <td align="left">${fns:getNameByParamKey(payMentFund.payMethod,'payWay')}</td> --%>
							<td align="left">${payMentFund.payMethod}</td>
							<td>${payMentFund.payVoucher}</td>
							<td>${payMentFund.amount}</td>
						</tr>
						<%-- <c:set var="itemAll" value="${itemAll+payMentFund.money}"/> --%>
					</c:forEach>
				</tbody>
			</table><!-- item-width -->
			<table class="item-fixed">
				<tr>
					<%-- <td style="width:40px;">合计：</td>
					<td style="text-align:right;width: 180px">${amount}</td> --%>
					<td align="left">合计：</td>
					<td></td>
					<td>${amount}</td>
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