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
				
								var posPattern = /^\d+$/;
								var no = $("#no").val();
								var sort = $("#sort").val();
								var name = $("#name").val();
								var floor = $("#floor").val();
								var typeId = $("#typeId").val();
								var normalNum = $("#normalNum").val();
								var maxNum = $("#maxNum").val();
								var minNum = $("#minNum").val();

								if (no == "") {

									$.jBox.alert("台位编号不能为空！");
									return;
								} else if (!posPattern.test(normalNum)) {

									$.jBox.alert("标准位数请输入正整数！");
									return;
								} else if (name == "") {

									$.jBox.alert("台位名称不能为空！");
									return;
								} else if (floor == "") {

									$.jBox.alert("经营区域不能为空！");
									return;
								} else if (typeId == "") {

									$.jBox.alert("桌型不能为空！");
									return;
								} else if (normalNum == "") {

									$.jBox.alert("桌台标准位数不能为空！");
									return;
								} else if (!posPattern.test(maxNum)) {

									$.jBox.alert("最大位数请输入正整数！");
									return;
								} else if (!posPattern.test(minNum)) {

									$.jBox.alert("最小位数请输入正整数！");
									return;
								}else if (sort == "") {

									$.jBox.alert("排序不能为空！");
									return;
								}

								
								
								
								var params = $('#inputForm').serialize();
								loadAjax("${ctx}/setting/ctTable/saveTable",
										params, function(result) {
											if (result.retCode == "000000") {
												top.$.publish("ctTableLsit", {
													testData : "hello"
												});
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
	     <div class="tab-content">
	         <div class="tab-pane active" id="tab1">
				
				<div class="panel panel-default">
			    	<div class="panel-body">
						<div class="row">
							<div class="span">
								<div class="control-group">
									<label class="control-label-xs"><span class="notice">*</span>台位编号：</label>
								<input type="text" id="no" name="no" htmlEscape="false" class="input-medium6 digits required"/>
								</div>
							</div>
							<div class="span">
								<div class="control-group">
									<label class="control-label-xs"><span class="notice">*</span>台位名称：</label>
									<div class="controls">
									<input type="text" id="name" name="name" htmlEscape="false" class="input-medium6 digits required"/>
									</div>
								</div>
							
							</div>

							<div class="span">
								<div class="control-group">
									<label class="control-label-xs"><span class="notice">*</span>经营区域：</label>
									<div class="controls">
									<select path="roomType" id="floor" name ="floor" class="input-medium6 digits required">
										<option value="">--选择经营区域--</option>
										<c:forEach items="${foorlList}" var="foorlList">
											<option value="${foorlList.paramKey}"<%-- <c:if test="${roomtype.paramKey==htlRoom.roomType}">selected="selected"</c:if> --%> >${foorlList.name}</option>

										</c:forEach>
									</select>
								   </div>
								</div>
							</div>

							<div class="span">
								<div class="control-group">
									<label class="control-label-xs"><span class="notice">*</span>台号类型：</label>
									<div class="controls">
										<select path="roomFeature" id="typeId" name="typeId"
											class="input-medium6">
											<option value="">--请选择台型--</option>
											<c:forEach items="${ctTableTypeList}" var="ctTableTypeList">
												<option value="${ctTableTypeList.id}">${ctTableTypeList.name}</option>

											</c:forEach>
										</select>
									</div>
								</div>
							</div>

					
						</div>
						<div class="row">

							<div class="span">
								<div class="control-group">
									<label class="control-label-xs">标准位数：</label>
									<div class="controls">
										<input type="text" id="normalNum" name="normalNum" />
									</div>
								</div>
							</div>
							
								<div class="span">
								<div class="control-group">
									<label class="control-label-xs">最大位数：</label>
									<div class="controls">
										<input type="text" id="maxNum" name="maxNum" />
									</div>
								</div>
							</div>
							
								<div class="span">
								<div class="control-group">
									<label class="control-label-xs">最小位数：</label>
									<div class="controls">
										<input type="text" id="minNum" name="minNum" />
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
							<div class="span12">
								<div class="control-group">
									<label class="control-label-xs">备注信息：</label>
									<div class="controls">
										 <textarea  id="remarks" name="remarks"></textarea>
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