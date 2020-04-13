<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>文件上传</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		var type = '${param.type}';
		var filePath = '${filePath}';
		if(type=='upload'){
			//上传后台提交返回
			if(filePath==""){
				//上传失败
				top.$.jBox.alert("请选择上传文件！");
			}else{
				//上传成功
				var eventName = '${param.enventName}';
				var divId = '${param.divId}';
				var isCover = '${param.isCover}';
				var inputName = '${param.inputName}';
				var params = {url:"${ctx}/upload/fileDownload",divId:divId,isCover:isCover,inputName:inputName,filePath:filePath};
				var paramsJson = JSON.stringify(params);
				cookie("fileUploadParams",paramsJson,{path:'/',expires:1});
		    	window.parent.jBox.close();
			}
		}else{
			//初始化上传界面
		}
	</script>
</head>
<body>
	<div class="row">
		<form id="inputForm" class="form-horizontal" action="${ctx}/upload/fileUpload3" enctype="multipart/form-data" method="POST">
			<input type="hidden" name="enventName" value="${param.eventName}"/>
			<input type="hidden" name="divId" value="${param.divId}"/>
			<input type="hidden" name="isCover" value="${param.isCover}"/>
			<input type="hidden" name="inputName" value="${param.inputName}"/>
			<input type="hidden" name="type" value="upload"/>
			<input type="hidden" id="fileDir" name="fileDir"/>
			<div style="margin:15px;">
				<c:choose>
					<c:when test="${'1'.equals(param.mulFlag)}">
						<input type="file" name="fileName" multiple="multiple"/>
						<input type="submit" class="btn btn-primary" value="批量上传"/>
					</c:when>
					<c:otherwise>
						<input type="file" name="fileName"/>
						<input type="submit" class="btn btn-primary" value="上传"/>
					</c:otherwise>
				</c:choose>
			</div>
		</form>
	</div>
</body>
</html>