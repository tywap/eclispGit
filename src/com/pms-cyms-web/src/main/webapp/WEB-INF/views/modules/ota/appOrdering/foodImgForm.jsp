<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<title>修改图片名称</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
	$(document).ready(function() {

	});
	
	function save() {
		var id = $("#id").val();
		var name = $("#name").val();
		var params = {
			name : name,
			id : id
		};
		loadAjax("${ctx}/ota/foodImgMaintain/updateFoodImgName", params, function(result) {
			if (result.retCode == "000000") {
				layer.confirm('修改成功', {
					btn: ['确定']
				}, function(){
					top.$.publish("foodImgMaintain", {
						testData : "hello"
					});
					window.parent.jBox.close();
				}, function(){
					window.parent.jBox.close();
				});
			} else {
				layer.alert(result.retMsg);
			}
		});
	}
</script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="sysBusiConfig" action="${ctx}/setting/modusSetting/update" method="post" class="form-horizontal">
		<input name="id" id="id" value="${id }" type="text" htmlescape="false" maxlength="64" style="display: none;">
		<div class="row" style="margin-top: 50px;">
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><span class="help-inline"><font
							color="red"></font> </span>图片名称：</label>
					<div class="controls">
						<input name="name" id="name" value="${name}"
							type="text" htmlescape="false" maxlength="64"
							class="input-xlarge required">
					</div>
				</div>
			</div>
		</div>
		<div class="fixed-btn-right">
			<input id="btnSubmit" class="btn btn-primary" type="button"
				value="确  定" onclick="save()">&nbsp;
		</div>
	</form:form>
</body>
</html>