<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@page import="com.jinchuan.pms.pub.modules.sys.entity.Office"%>
<html>
<head>
	<title>新增打印机</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			
		 	$("#submitBtn").bind("click",function(){
				 		var name = $("#name").val();
						var storeId=$("#storeId").val();
						var remarks=$("#remarks").val();
						var paramKey=$("#paramKey").val();
						var paramValue=$("#paramValue").val();
						if (name == "") {
							$.jBox.alert("打印机不能为空！");
							return;
						}else if(paramKey==""){
							$.jBox.alert("ip地址不能为空！");
							return;
						}else if(paramValue==""){
							$.jBox.alert("端口号不能为空！");
							return;
						}
						var params = $('#inputForm').serialize();
						loadAjax("${ctx}/sys/sysBusiConfig/savesysbusi",
								params, function(result) {
									if (result.retCode == "000000") {
										 layer.confirm("保存成功！", {
						        			  btn: ['确定']
						        			}, function(){
						        				top.$.publish("sysBusiConfigList", {
						    						event_name : "sysBusiConfigList"
						    					});
											window.parent.jBox.close();
						        			}); 
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
		
		function validCert(){
			
			/* $.ajax({
				type: "post",
				dataType: "json",  
			    url: "${ctx}/sys/sysBusiConfig/savesysbusi",
			    data: {
			    	name:name,
			    	storeId:storeId,
			    	remarks:remarks
                },
			    success: function (result) {
			    	if(result.retCode=="999999"){
			    		$.jBox.info(result.retMsg);
			    		return false;
			    	}
					if(result.retCode=="000000"){
						top.$.publish(
								"ctTableLsit", {
									testData : "hello"
								});
			    	}
			    },
			    error: function (result, status) {
			    	$.jBox.info("系统错误");
				}
			}); */
			
		}
	</script>
</head>
<body>
	<form:form id="inputForm"  method="post" class="form-horizontal">
	<input type="hidden" id="storeId" name="storeId"  value="${selectStoreId}">
	<input type="hidden" id="id" name="id"  value="${sysbusi.id}">
	     <div class="tab-content">
	         <div class="tab-pane active" id="tab1">
				<div class="panel panel-default">
			    	<div class="panel-body">
						<div class="row">
							<div class="span">
								<div class="control-group">
									<label class="control-label-xs"><span class="notice">*</span>打印机名称：</label>
								<input type="text" id="paramKey" name="paramKey" value="${sysbusi.paramKey }" htmlEscape="false" class="input-medium6 digits required"/>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="span">
								<div class="control-group">
									<label class="control-label-xs"><span class="notice">*</span>ip地址：</label>
								<input type="text" id="name" name="name" value="${sysbusi.name }" htmlEscape="false" class="input-medium6 digits required"/>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="span">
								<div class="control-group">
									<label class="control-label-xs"><span class="notice">*</span>端口号：</label>
								<input type="text" id="paramValue" name="paramValue" value="${sysbusi.paramValue }" htmlEscape="false" class="input-medium6 digits required"/>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="span12">
								<div class="control-group">
									<label class="control-label-xs">备注信息：</label>
									<div class="controls">
										 <textarea  id="remarks" name="remarks">${sysbusi.remarks }</textarea>
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