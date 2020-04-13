<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@page import="com.jinchuan.pms.pub.modules.sys.entity.Office"%>
<html>
<head>
	<title>新增桌型</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			
			$("#submitBtn").bind("click",function(){
				
				var code = $("#code").val();
				var name = $("#name").val();
				var sort = $("#sort").val();
				if (code == "") {
					
				$.jBox.alert("编号不能为空！");
					return;
				} else if (name == "") {

					$.jBox.alert("台型名称不能为空！");
					return;
				} else if (sort == "") {

					$.jBox.alert("排序不能为空！");
					return;
				}
								
				var params = $('#inputForm').serialize();
				loadAjax("${ctx}/setting/tableTyple/save",
						params, function(result) {
							if (result.retCode == "000000") {
								top.$.publish("ctTableTypeList",{testData:"hello"});
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
					//加载分公司
					loadCheckbox("companyCheckDiv",
							"${ctx}/sys/userutils/getOfficeListByType", {
								typesJson : "['3','4','5']"
							}, '${storesJsonStr}', 'storeId', 'id', 'name');
				});

		function SignCheck(obj) {
			var aa = document.forms[0].isServiceRate;
			for (var i = 0; i < aa.length; i++) {
				aa[i].checked = false;
			}
			obj.checked = true;
		}
	</script>
</head>
<body>
	<form:form id="inputForm"   method="post" class="form-horizontal">
	
	     <div class="tab-content">
	         <div class="tab-pane active" id="tab1">
				
				<div class="panel panel-default">
					<div class="panel-body">
						<div class="row">
							<div class="span">
								<div class="control-group">
									<label class="control-label-xs"><span class="notice">*</span>类型编号：</label>
								<input type="text" id="code" name="code" htmlEscape="false" class="input-medium6 digits required"/>
								</div>
							</div>
							<div class="span">
								<div class="control-group">
									<label class="control-label-xs"><span class="notice">*</span>台号类型：</label>
									<div class="controls">
									<input type="text" id="name" name="name" htmlEscape="false" class="input-medium6 digits required"/>
									</div>
								</div>
							
							</div>
							
							<div class="span">
								<div class="control-group">
									<label class="control-label-xs"><span class="notice">*</span>排序：</label>
									<div class="controls">
									<input type="text" id="sort" name="sort" htmlEscape="false" class="input-medium6 digits required"/>
									</div>
								</div>
							
							</div>
						</div>
						<div class="row">
							<div class="span">
								<div class="control-group">
									 <label class="control-label-xs">收取服务费：</label>
									<div class="controls">
										<input type="checkbox" id="isServiceRate" name="isServiceRate" value="1" onclick="SignCheck(this)"/>是
										<input type="checkbox" id="isServiceRate" name="isServiceRate" value="0" onclick="SignCheck(this)"/>否
									</div>
								</div>
							</div>
							
								<div class="span">
								<div class="control-group">
									 <label class="control-label-xs">服务费费率：</label>
									<div class="controls">
										<input type="text" id="serviceRate" name="serviceRate" />%
									</div>
								</div>
							</div>
						</div>
				
				
						<div class="row">
							<div class="span12">
								<div class="control-group">
									<label class="control-label-xs">备注信息：</label>
									<div class="controls">
										 <textarea  id="remarks" name="remarks"></textarea>
									</div>
								</div>
							</div>
						</div>
						
	
						<div class="row">
							<div class="span12">
								<div class="control-group">
									<label class="control-label-xs">适用餐厅：</label>
									<div class="controls" id="companyCheckDiv">
									
									<jsp:include page="../../common/common_store_select.jsp"></jsp:include>
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