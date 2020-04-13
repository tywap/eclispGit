<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
	<title>新增小类</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
	
		$(document).ready(function() {
			//加载分公司
			loadCheckbox("companyCheckDiv","${ctx}/sys/userutils/getOfficeListByType",{typesJson:"['3','4','5']"},'${storelist}','storeId','id','name');
		});
		
		function save() {
			var id = $("#id").val();
			var code = $("#typeCode").val();
			var name = $("#typeName").val();
			var sort = $("#sort").val();
		    var parentId =$("#parentName").val();
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
			//分店checkbox
			var stores=[];
			var cks = $("[name='storeId']:checked");
			for(var i=0;i<cks.length;i++){
				stores.push(cks[i].value);
			}
			var params = "storeName="+stores+"&code="+code+"&name="+name+"&sort="+sort+"&parentId="+parentId+"&id="+id;
			loadAjax("${ctx}/setting/ctFoodType/saveLittle",params,function(result){
				if(result.retCode=="000000"){
              	  top.$.publish("dishesCategory",{testData:"hello"});
			      window.parent.jBox.close();
                }else{
              	  layer.alert(result.retMsg);
              	  window.parent.jBox.close();
                }
			});
		}
		
	</script>
</head>
<body>
<form:form id="inputForm" modelAttribute="setting" action="${ctx}/setting/ctFoodType/saveLittle" method="post" class="form-horizontal">
<input name="id" id="id" value="${DishesBigType.id }" type="text" htmlescape="false" maxlength="64" style="display:none;">
<div class="row" style=" margin-top: 20px;">
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><span class="help-inline"><font color="red">*</font> </span>类别编号：</label>
					<div class="controls">
						<input name="typeCode" id="typeCode" value="${DishesBigType.code }" type="text" htmlescape="false" maxlength="64" class="input-xlarge required">
					</div>
				</div>
			</div>
			
			<div class="span">
			    <div class="control-group">
					<label class="control-label-xs"><font color="red">*</font>类别名称：</label>
					<div class="controls">
						<input name="typeName" id="typeName" value="${DishesBigType.name }" type="text" htmlescape="false" maxlength="64" class="input-xlarge required" >
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
		    <div class="span" id="parent">
				<div class="control-group">
					<label class="control-label-xs"><font color="red">*</font>归属大类：</label>
					<div class="controls">
					<select name="parentName" id="parentName" class="select-medium6">
							<c:forEach items="${bigTypeList}" var="var"
								varStatus="vs">
								<option value="${var.id}" <c:if test="${DishesBigType.parentId == var.id }">  selected ="selected"</c:if>>${var.name}</option>
							</c:forEach>
						</select>
					</div>
				</div>
			</div>
	  
	 </div>
	        <div class="tab-pane" id="tab2">
	         <hr />
			<!-- 分店选择 -->
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
           
            <div class="fixed-btn-right">
			<input id="btnSubmit" class="btn btn-primary" type="button" value="确  定" onclick="save()">&nbsp;
		</div>
	</form:form>
</body>
</html>