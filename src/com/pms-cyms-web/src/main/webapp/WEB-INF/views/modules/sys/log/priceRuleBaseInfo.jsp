<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title></title>
	<meta name="decorator" content="default"/>
	<style>
		.form-horizontal .control-group{margin-bottom:0px;}
		.input-append .btn{margin-left: -35px;}
	</style>
	<style>
		.nav-tabs{
			margin:0;
		}
	</style>
</head>
<body>
<div class="form-horizontal">
		<div class="span"  >
	        <div class="control-group">
	            <label class="control-label-xs">方案名称：</label>
	            <div class="controls">
		            <input type="text"  htmlEscape="false" value="${detailMap.priceName}" />
	            </div>
	        </div>
	    </div>
		<div class="span"  >
	        <div class="control-group">
	            <label class="control-label-xs">状态：</label>
	            <label class="control-label-xs">${detailMap.state}</label>
	        </div>
	    </div>
	    <div class="span"  >
	        <div class="control-group">
	            <label class="control-label-xs">排序：</label>
	            <div class="controls">${detailMap.sort}</div>
	        </div>
	    </div>
	    <div class="span"  >
	        <div class="control-group">
	            <label class="control-label-xs"></label>
	            <div class="controls">
				    <c:if test="${detailMap.isBase!=1}">
						当挂牌默认价格变动时，1.挂牌远期房价会被自动替换，2.其他勾选"挂牌相对"的方案其“默认价”将根据差额自动调整，3.其他勾选"挂牌相对"的方案“远期价”格将被覆盖
					</c:if>
					<c:if test="${detailMap.isBase==1}">
						<span style="margin-left:22px;display:inline-block;">
							<label>
								<c:if test="${detailMap.relatOrigPrice==1}">(挂牌相对)挂牌价变动后，本方案根据差异自动调整价格(如挂牌价188,本方案差额-20实际价168,当挂牌价变为198,本方法差额-20实际价将自动调整为178)</c:if> 
								<c:if test="${detailMap.relatOrigPrice==2}">(方案固定)挂牌价变更，本方案不变</c:if>
							</label>
						</span>
					</c:if>
		</div>
	        </div>
	    </div>
		<hr>
		<div class="form-search">
		<div class="row">
			<div class="span">
		        <div class="control-group">
		            <label class="control-label" style="margin-left:0;">应用客源：</label>
		            <div class="controls">
		           		
		 			</div>
		 		</div>
			</div>
			<div class="span" >
		        <div class="control-group">
		        	<div class="controls">
		        		<div id="sourceAndChannelSelectd" style="display: inline-block;" class="appStore">${detailMap.source}</div>
		        	</div>
		 		</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>