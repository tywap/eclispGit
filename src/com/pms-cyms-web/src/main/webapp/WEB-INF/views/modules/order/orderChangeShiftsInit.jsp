<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>交接班</title>
    <meta name="decorator" content="default"/>
    <style>
        [class*="span"]{margin-left: 0;}
        .table tr td label{text-align:right;display:block;}
        .table tfoot tr td label{color:#006DCC;font-weight:bold;}
    </style>
    <script type="text/javascript">
    	$(document).ready(function(){
    		//初始化选中
    		if('${fn:length(offices)}'=='1'){
    			var storeId = '${offices[0].id}';
    			$("#storeId").val(storeId);
    			changeStore(storeId);
    		}
    	});
    	//查询分店班次
        function changeStore(obj){
    		var storeId = $("#storeId").val();
    		var operType = '${param.operType}';
    		if(storeId==""){
    			return;
    		}
    		if(operType=="ordCashbox"){
    			ordIframe.src="${ctx}/order/ordCashbox?storeId="+storeId;
    		}else if(operType=="orderSpareUp"){
    			ordIframe.src="${ctx}/order/orderSpareFund?operType=4001&storeId="+storeId;
    		}else if(operType=="orderSpareDown"){
    			ordIframe.src="${ctx}/order/orderSpareFund?operType=4002&storeId="+storeId;
    		}
        }
    </script>
</head>
<body>
	<form id="inputForm" modelAttribute="ordSpareFund" method="post" class="form-horizontal">
		<div class="row" style="margin-right:20px;">
			<label>餐厅：</label>
			<select class="select-medium10" onchange="changeStore(this)" id="storeId" name="storeId">
				<option value="">--请选择--</option>
				<c:forEach items="${offices}" var="office">
					<option value="${office.id}">${office.name}</option>
				</c:forEach>
			</select>
		</div>
		<div id="left" class="accordion-group" style="width: 100%;border:0;margin:0;height:100%;">
			<iframe id="ordIframe" src="" width="100%" height="880px" frameborder="0" scrolling="no"></iframe>
		</div>
	</form>
</body>
</html>