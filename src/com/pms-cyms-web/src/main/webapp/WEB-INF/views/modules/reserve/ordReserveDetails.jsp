<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>预订单详情</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		var judg=${judge}
		$(document).ready(function() {
			if(judg==1){
				$("#btnSubmit").hide();
			}else{
				$("#btnSubmit").show();
			}
			$("#btnSubmit").bind("click",function() {
				top.$.jBox.open(
				    "iframe:${ctx}/reserve/toOrderPartCheckInForm?id=${reserveId}",
					"预定开台", 
					1000,
					$(top.document).height() - 180, {
						buttons : {},
						loaded : function(h) {
							$(".jbox-content",top.document).css("overflow-y",	"hidden");
						},
						closed:function (){
	 	                	top.$.publish("reserveList",{testData:"hello"});
	 	                	window.parent.jBox.close();
	 	                }
					});
			});
		});
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/reserve/ordReserveDetails?reserveId=${reserveId}&storeId=${storeId}&depositAmount=${depositAmount}&tableCount=${tableCount}&judge=${judge}">预订信息</a></li>
		<li><a href="${ctx}/reserve/reserveHaveDotFood?reserveId=${reserveId}&storeId=${storeId}&depositAmount=${depositAmount}&tableCount=${tableCount}&id=${id}&judge=${judge}">已点菜品</a></li>
	</ul>
	<sys:message content="${message}"/>
	<form:form id="inputForm" modelAttribute="" action="" method="post" class="form-horizontal">
		<div class="row" style="width: 100%;">
			<c:if test="${tableCount == '1' }">
		    <div class="span" style="width: 25%">
		        <div class="control-group">
		            <label class="control-label-xs">预订台号：</label>
		            <span>${ordReserve.tableNo }</span>
		        </div>
		    </div>
		    <div class="span"style="width: 25%">
		        <div class="control-group">
		            <label class="control-label-xs">预订台型：</label>
		            <div class="controls">
		               <span>${ordReserve.tableTypeName}</span>
		            </div>
		        </div>
		    </div>
		    <div class="span"style="width: 25%">
	        <div class="control-group">
	            <label class="control-label-xs">用餐人数：</label>
	            <div class="controls">
	                <span>${ordReserve.personCount }</span>
	            </div>
	        </div>
	   		</div>
		    </c:if>
	   		<div class="span"style="width: 25%">
	        <div class="control-group">
	            <label class="control-label-xs">联系人：</label>
	            <div class="controls">
	                <span>${ordReserve.name }</span>
	            </div>
	        </div>
	    </div>
		</div>
		<div class="row"style="width: 100%;">
			 <div class="span" style="width: 25%">
		        <div class="control-group">
		            <label class="control-label-xs">联系方式：</label>
		            <div class="controls" >
		            <span>${ordReserve.phone }</span>
		            </div>
		        </div>
		    </div>
		    <div class="span" style="width: 25%">
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>用餐日期：</label>
		            <div class="controls">
		            	<span>${ordReserve.useDate }</span>
		            </div>
		        </div>
		    </div>
		    
		    <div class="span" style="width: 25%">
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>用餐时段：</label>
		            <div class="controls"> 
						<span>${ordReserve.useLevelName }</span>
					</div>
		        </div>
		    </div>
		    
		    <div class="span" style="width: 25%">
		        <div class="control-group">
		            <label class="control-label-xs" id="bcxxwz" >客源：</label>
		            <div class="controls" style="position:relative;">
						<span>${ordReserve.sourceName }</span>
					</div>
		        </div>
			</div>
			</div>
			<div class="row"style="width: 100%;">
		    <div class="span" style="width: 25%">
		        <div class="control-group">
		            <label class="control-label-xs">协议单位：</label>
		            <div class="controls">
		            	<span>${ordReserve.thirdPartId }</span>
		            </div>
		        </div>
		    </div>
		    
		    <div class="span" style="width: 25%">
		        <div class="control-group">
		            <label class="control-label-xs">销售经理：</label>
		            <div class="controls">
		            <span>${ordReserve.salesPerson }</span>
		            </div>
		        </div>
		    </div>
		    
		     <div class="span" style="width: 25%">
		        <div class="control-group">
		            <label class="control-label-xs">用餐类别：</label>
		            <div class="controls">
		            <span>${ordReserve.useType }</span>
		            </div>
		        </div>
		    </div>
		</div>
		<div class="row"style="width: 100%;">
		    <div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs">备注：</label>
		            <div class="controls">
		            <span>${ordReserve.remarks }</span>
		            </div>
		        </div>
		    </div>
		</div>
	</form:form>
	<div class="fixed-btn-right">
			<input id="btnSubmit" class="btn btn-primary" type="button"
				value="开台" >&nbsp;
	</div>
</body>
</html>