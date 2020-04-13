<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<meta name="decorator" content="default"/>
	<title>开关房设置</title>
	<style>
		ul li{list-style: none;}
		.title{padding: 5px 15px;color: red;border-bottom:1px dashed #eee;}
		ul.ul-form{border-bottom:1px dashed #eee;padding:10px 0;margin: 0;}
		.form-search .control-label-xs{
			padding-top: 3px;
		    float: left;
		    width: 90px;
		    text-align: right;
		}
		.affrim{
			position: fixed;
		    bottom: 0;
		    width: 100%;
		    height: 40px;
		    line-height: 30px;
		    text-align: right;
		    background-color: #fff;
		}
		.affrim button{
		    margin-right: 20px;
    		padding: 5px 20px;
		}
	</style>
</head>
<body>
	<div class="row form-horizontal">
		<h4 class="title"></h4>
		<ul class="ul-form" style="margin-bottom:10px;">
			<li class="btns">
				<label class="control-label-xs">调整时段：</label>
				<input type="text" readonly="readonly" class="input-medium6 Wdate " value="${detailMap.startDate}" style="margin-right:3px;"/>-
				<input type="text" readonly="readonly" class="input-medium6 Wdate " value="${detailMap.endDate}" />
			</li>
			<li class="clearfix"></li>
		</ul>
		<div class="row">
			<div class="control-group">
				<label class="control-label-xs">房态：</label>
				<div class="controls">
				<c:if test="${detailMap.operateType=='Open'}">开</c:if>
				<c:if test="${detailMap.operateType=='Close'}">关</c:if>
				</div>
			</div>
		</div>
	</div>
</body>
</html>