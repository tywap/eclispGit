<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
	<head>
		<meta name="decorator" content="default"/>
		<title>-打印-交接班-</title>
		<link href="${ctxStatic}/common/print-default.css" rel="stylesheet">
		<script type="text/javascript">
			$(document).ready(function() {
				$("body").bind("keypress", function(event) {
					if (event.keyCode == "13") window.print();
				});
			});
		</script>
		<style>
	        table{
	        	border: 1px solid #ddd;
	        	border-collapse: collapse;
	        	width: 100%;
	        }
	        table td{
	        	border: 1px solid #ddd;
	        	width: 25%;
	    		padding: 0 1px;
	        }
	        table td p{
	        	margin: 0;
	        }
	        .detail{
	        	text-align:center;
	        }
	        .sign{
		        height: 50px;
			    text-align: right;
			    vertical-align: bottom;
		    }
		    .sign td{padding-right: 10px;}
		    .remark{
		    	height:75px;
		    }
		    .remark td{
		    	vertical-align: top;
	    		padding: 5px 10px;
		    }
    </style>
	</head>
	<body>
		<div class="container container-245" style="width:245px;">
			<div class="header">
				${hotelName }
				<div class="header-type">交接班凭证</div>
			</div>
			<table class="item-normal">
				<tr>
					<td>班次：</td>
					<td>${shiftName }</td>
					<td>交班：</td>
					<td>${shiftCloseBy }</td>
				</tr>
				<tr>
					<td>时间：</td>
					<td colspan="3">
						<p>${shiftStrTime }</p>
					</td>
				</tr>
				<tr>
					<td>班次：</td>
					<td>${nextShiftName }</td>
					<td>接班：</td>
					<td>${shiftReceiveBy }</td>
				</tr>
				<tr class="detail">
					<td colspan="4">交接班明细</td>
				</tr>
				<c:forEach items="${dataList }" var="data">
					<c:if test="${data.totalMoney != '0.00' }">
						<tr>
							<td colspan="2">${data.label }</td>
							<td colspan="2">${data. totalMoney}</td>
						</tr>
					</c:if>
				</c:forEach>
				
				<tr><td colspan="4">预授权余额：${cashboxPreTotalMoney }</td></tr>
				<tr class="sign">
					<td colspan="4">
						员工签名：_________<span style="width:100px;border-bottom:1px solid #333;"></span>
					</td>
				</tr>
				<tr class="remark">
					<td colspan="4">备注：</td>
				</tr>
				<tr>
					<td colspan="2">打印时间</td>
					<td colspan="2">${printDate }</td>
				</tr>
				<tr>
					<td>打印次数</td>
					<td>1</td>
					<td>打印人</td>
					<td>${printName }</td>
				</tr>
			</table>
		</div>
		<div class="sidebar" media="print">
			<button id="sidebar-print" type="button" class="btn btn-primary" onclick="javascript:window.print();">打 印</button>
			<button id="sidebar-cancel" type="button" class="btn btn-danger" onclick="javascript:window.close();">取 消</button>
		</div>
	</body>
</html>