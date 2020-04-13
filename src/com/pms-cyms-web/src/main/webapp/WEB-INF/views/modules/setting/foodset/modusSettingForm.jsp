<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<title>新增做法</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
	$(document).ready(function() {

	});
	
	function save() {
		var id = $("#id").val();
		var code = $("#code").val();
		var name = $("#name").val();
		var sort = $("#sort").val();
	    var parentId =$("#parentName").val();
		if (code == null || code == "") {
			layer.alert("做法代码不允许为空");
			return;
		}
		if (name == null || name == "") {
			layer.alert("做法名称不允许为空");
			return;
		}
		if (sort == null || sort == "") {
			layer.alert("排序号不允许为空");
			return;
		}
		var params = {
			paramKey : code,
			name : name,
			sort : sort,
			id : id,
			parentId : parentId
		};
		loadAjax("${ctx}/setting/modusSetting/save", params, function(result) {
			if (result.retCode == "000000") {
				top.$.publish("modusSetting", {
					testData : "hello"
				});
				window.parent.jBox.close();
			} else {
				layer.alert(result.retMsg);
			}
		});
	}
</script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="sysBusiConfig" action="${ctx}/setting/modusSetting/save" method="post" class="form-horizontal">
		<input name="id" id="id" value="${modusList.id }" type="text" htmlescape="false" maxlength="64" style="display: none;">
		<div class="row" style="margin-top: 20px;">
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><span class="help-inline"><font
							color="red">*</font> </span>做法代码：</label>
					<div class="controls">
						<input name="code" id="code" value="${modusList.paramKey }"
							type="text" htmlescape="false" maxlength="64"
							class="input-xlarge required">
					</div>
				</div>
			</div>

			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><font color="red">*</font>做法名称：</label>
					<div class="controls">
						<input name="name" id="name" value="${modusList.name }"
							type="text" htmlescape="false" maxlength="64"
							class="input-xlarge required">
					</div>
				</div>
			</div>
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><font color="red">*</font>排序：</label>
					<div class="controls">
						<input name="sort" id="sort" value="${modusList.sort }"
							type="text" htmlescape="false" maxlength="200"
							class="input-medium6 ">
					</div>
				</div>
			</div>
			<div class="span" id="parent">
				<div class="control-group">
					<label class="control-label-xs"><font color="red">*</font>做法类别：</label>
					<div class="controls">
						<select name="parentName" id="parentName" class="select-medium6">
							<c:forEach items="${modusTypeList}" var="var" varStatus="vs">
								<option value="${var.id}"
									<c:if test="${modusList.parentId == var.id }">  selected ="selected"</c:if>>${var.name}</option>
							</c:forEach>
						</select>
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