<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@page import="com.jinchuan.pms.pub.modules.sys.entity.Office"%>
<html>
<head>
	<title>新增台号</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			
			$("#submitBtn").bind("click",function(){
				var name = $("#name").val();
				var sort = $("#sort").val();
			 if (name == "") {

					$.jBox.alert("桌号名称不能为空！");
					return;
				} else if (sort == "") {

					$.jBox.alert("排序不能为空！");
					return;
				} 
								
				var params = $('#inputForm').serialize();
				loadAjax("${ctx}/setting/ctTable/saveFloor",
						params, function(result) {
							if (result.retCode == "000000") {
								top.$.publish("ctTableLsit",{testData:"hello"});
								window.parent.jBox.close();
							} else {
								$.jBox.alert(result.retMsg);
							}
							
							
						});
			      });
				

					//关闭
					$("#closeBtn").bind("click", function() {
						window.parent.jBox.close();
					});
			
				});

	</script>
</head>
<body>
	<form:form id="inputForm"  method="post" class="form-horizontal">
	<input type="hidden" id="storeId" name="storeId"  value="${selectStoreId}">
	<input type="hidden" id="type" name="type"  value="floor">
	     <div class="tab-content">
	         <div class="tab-pane active" id="tab1">
				
				<div class="panel panel-default">
			    	<div class="panel-body">
						<div class="row">
							<div class="span">
								<div class="control-group">
									<label class="control-label-xs"><span class="notice">*</span>区域名称：</label>
								<input type="text" id="name" name="name" htmlEscape="false" class="input-medium6 digits required"/>
								</div>
							</div>
							
							<div class="span">
								<div class="control-group">
									<label class="control-label-xs"><span class="notice">*</span>排序：</label>
								<input type="text" id="sort" name="sort" htmlEscape="false" class="input-medium6 digits required"/>
								</div>
							</div>
				</div>

					<div class="row">
							<div class="span12">
								<div class="control-group">
									<label class="control-label-xs">备注信息：</label>
									<div class="controls">
										 <textarea  id="remarks" name="remarks" ></textarea>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="fixed-btn-right">
				
					<input id="submitBtn" class="btn btn-primary" type="button" value="保 存"/>&nbsp;
		
			</div>
		</div>
	</form:form>
</body>
</html>