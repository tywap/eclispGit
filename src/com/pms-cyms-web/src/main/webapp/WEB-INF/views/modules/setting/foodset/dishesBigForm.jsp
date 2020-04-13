<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
	<title>新增大类</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
		function save() {
			var id = document.getElementById("id").value;
			var code = document.getElementById("code").value;
			var name = document.getElementById("name").value;
			var sort = document.getElementById("sort").value;
			if (code == null || code =="") {
				layer.alert("类别编号不允许为空");
				return;
			}
			if (name == null || name =="") {
				layer.alert("类别名称不允许为空");
				return;
			}
			if (sort == null || sort =="") {
				layer.alert("排序号不允许为空");
				return;
			}
			var params = {paramKey:code,name:name,sort:sort,id:id};
			loadAjax("${ctx}/setting/ctFoodType/saveBig",params,function(result){
				if(result.retCode=="000000"){
					  layer.alert("保存成功");
	              	  top.$.publish("dishesCategory",{testData:"hello"});
				      window.parent.jBox.close();
	                }else{
	              	  layer.alert(result.retMsg);
	                }
			});
		}
		
	</script>
</head>
<body>
<form:form id="inputForm" modelAttribute="sysBusiConfig" action="${ctx}/setting/modusSetting/save" method="post" class="form-horizontal">
<input name="id" id="id" value="${DishesBigType.id }" type="text" htmlescape="false" maxlength="64" style="display:none;">
<div class="row" style=" margin-top: 20px;">
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><span class="help-inline"><font color="red">*</font> </span>类别编号：</label>
					<div class="controls">
						<input name="code" id="code" value="${DishesBigType.code }" type="text" htmlescape="false" maxlength="64" class="input-xlarge required">
					</div>
				</div>
			</div>
			
			<div class="span">
			    <div class="control-group">
					<label class="control-label-xs"><font color="red">*</font>类别名称：</label>
					<div class="controls">
						<input name="name" id="name" value="${DishesBigType.name }" type="text" htmlescape="false" maxlength="64" class="input-xlarge required" >
					</div>
				</div>
			</div>
		    <div class="span">
				<div class="control-group">
					<label class="control-label-xs"><font color="red">*</font>排序：</label>
					<div class="controls">
					    <input name="sort" id="sort" value="${DishesBigType.sort }" type="text" htmlescape="false" maxlength="200" class="input-medium6 ">
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