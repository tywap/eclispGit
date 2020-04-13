<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>角色管理</title>
	<meta name="decorator" content="default"/>
	<%@include file="/WEB-INF/views/include/treeview.jsp" %>
	<script type="text/javascript">
		$(document).ready(function(){
			/*  $("#name").focus();
			$("#inputForm").validate({ 
				rules: {
					name: {remote: "${ctx}/sys/role/checkName?oldName=" + encodeURIComponent("${role.name}")},
					enname: {remote: "${ctx}/sys/role/checkEnname?oldEnname=" + encodeURIComponent("${role.enname}")}
				},
				messages: {
					name: {remote: "角色名已存在"},
					enname: {remote: "英文名已存在"}
				},
				 submitHandler: function(form){
					var ids = [], nodes = tree.getCheckedNodes(true);
					for(var i=0; i<nodes.length; i++) {
						ids.push(nodes[i].id);
					}
					//$("#menuIds").val(ids);
					//var ids2 = [];
					var nodes2 = tree2.getCheckedNodes(true);
					for(var i=0; i<nodes2.length; i++) {
                        ids.push(nodes2[i].id);
					}
                    $("#menuIds").val(ids);
					//$("#officeIds").val(ids2);
					loading('正在提交，请稍等...');
					if($('#reduceAmount').val() == ''){
                        $('#reduceAmount').val(0);
					}
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});  */
			roleTypes();
			
			var reduceAmount = $('#reduceAmount').val();
			if(reduceAmount== null || reduceAmount == ''){
				$('#reduceAmount').val(0);
			}
			var setting = {check:{enable:true,nocheckInherit:true},view:{selectedMulti:false},
					data:{simpleData:{enable:true}},callback:{beforeClick:function(id, node){
						tree.checkNode(node, !node.checked, true, true);
						return false;
					}}};
			
			// 用户-菜单
			var zNodes=[
					<c:forEach items="${menuList}" var="menu">{id:"${menu.id}", pId:"${not empty menu.parent.id?menu.parent.id:0}", name:"${not empty menu.parent.id?menu.name:'权限列表'}"},
		            </c:forEach>];
			// 初始化树结构
			var tree = $.fn.zTree.init($("#menuTree"), setting, zNodes);
			// 不选择父节点
			tree.setting.check.chkboxType = { "Y" : "ps", "N" : "s" };
			// 默认选择节点
			var ids = "${role.menuIds}".split(",");
			for(var i=0; i<ids.length; i++) {
				var node = tree.getNodeByParam("id", ids[i]);
				try{tree.checkNode(node, true, false);}catch(e){}
			}
			// 默认展开全部节点
			tree.expandAll(true);
			
			// 用户-机构
			var zNodes2=[
                    <c:forEach items="${bussinessMenuList}" var="menuBus">{id:"${menuBus.id}", pId:"${not empty menuBus.parent.id?menuBus.parent.id:0}", name:"${not empty menuBus.parent.id?menuBus.name:'分店权限列表'}"},
                </c:forEach>];
			// 初始化树结构
			var tree2 = $.fn.zTree.init($("#officeTree"), setting, zNodes2);
			// 不选择父节点
			tree2.setting.check.chkboxType = { "Y" : "ps", "N" : "s" };
			// 默认选择节点
			var ids2 = "${role.menuIds}".split(",");
			for(var i=0; i<ids2.length; i++) {
				var node = tree2.getNodeByParam("id", ids2[i]);
				try{tree2.checkNode(node, true, false);}catch(e){}
			}
			// 默认展开全部节点
			tree2.expandAll(true);
			// 刷新（显示/隐藏）机构
			//refreshOfficeTree();
			/*$("#dataScope").change(function(){
				refreshOfficeTree();
			});*/
            var result = $('#reduceAmount').val();
            if(result > 0){
                $('#flag').attr('checked', true);
                $('#reduceAmount').show();
            }
            
          //保存岗位信息
          $("#btnSubmit").click(function(){
        	  	var name = $('#name').val();
        	  	var reduceAmount = $('#reduceAmount').val();
              	if(name == null || name == ''){
            	    $.jBox.alert("岗位名称不允许为空");
            	    $("#name").get(0).focus();
            	    $('#name').val('');
                  return;
              	}
              	if($("#flag").attr("checked")=='checked'){
              		if(reduceAmount < 1){
              			$.jBox.alert("可允许修改房价不允许小于1");
              			return;
              		}
              	}else{
              		$('#reduceAmount').val(0);
              	}
              	var ids = [], nodes = tree.getCheckedNodes(true);
	   			for(var i=0; i<nodes.length; i++) {
	   				ids.push(nodes[i].id);
	   			}
	   			var nodes2 = tree2.getCheckedNodes(true);
	   			for(var i=0; i<nodes2.length; i++) {
	                   ids.push(nodes2[i].id);
	   			}
                $("#menuIds").val(ids);
                var form = new FormData(document.getElementById("inputForm"));
    			  $.ajax({
    	              type: "post",
    	              url: "${ctx}/sys/role/save",
    	              async:false,
    	              data:form, 
    	              processData:false,
    	              contentType:false,
    	              success: function (result) {
    	                  if(result.retCode=="000000"){
    	                	  top.$.publish("role111",{testData:"hello"});
    	  			    	  window.parent.jBox.close();
    	                  }else{
    	                	  $.jBox.alert(result.retMsg);
    	                	  $('#name').val('');
    	                  }
    	              },
    	              error: function (result, status) {
    	                  $.jBox.alert("系统错误");
    	              }
    	          });
          })
  		  /* function save(){
  			
  		  } */
            
		});
		function checkedBox(){
            if($('#flag').is(':checked')) {
				$('#reduceAmount').show();
            }else{
                $('#reduceAmount').hide();
			}
		}
		
		
		function roleTypes() {
			 var role=${role};
			$.ajax({
                url:"${ctx}/sys/role/getParent",
                data: {
                    "roleTypeId":$("#roleType").val()
                },
                success: function (result) {
                	$("#parentId").empty();
                	var d=result.list;
					for(var i=0;i<d.length;i++){
						var htm="";
						if (role.parentId == d[i].id) {
							 htm+="<option value='"+d[i].id+"' selected ='selected'>"+d[i].name+"</option>";
						}else{
							 htm="<option value='"+d[i].id+"' >"+d[i].name+"</option>";
						}
                    	$("#parentId").append(htm);
                	}
                }
        	});
		}
		
		
	</script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="role" action="${ctx}/sys/role/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<div class="row">
			<div class="span">
				<div class="control-group">
					<label class="control-label"><span class="help-inline"><font color="red">*</font> </span>岗位名称：</label>
					<div class="controls">
						<input id="oldName" name="oldName" type="hidden" value="${role.name}">
						<form:input path="name" htmlEscape="false" maxlength="50" class="required"/>
					</div>
				</div>
			</div>
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs">岗位类型：</label>
					<div class="controls">
						<form:select path="roleType" class="input-medium" onchange="roleTypes()">
							<form:options items="${fns:getDictList('sys_post_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
					</div>
				</div>
			</div>
			 <div class="span">
				<div class="control-group">
					<label class="control-label-xs">数据范围：</label>
					<div class="controls">
						<form:select path="dataScope" class="input-medium">
							<form:options items="${fns:getDictList('sys_data_scope')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
						</form:select>
					</div>
				</div>
			</div> 
			 <div class="span">
				<div class="control-group">
					<label class="control-label-xs">上级岗位：</label>
					<div class="controls">
						<select id="parentId" name="parentId" class="input-medium">	
						<%-- <c:forEach items="${list}" var="list"> --%>
								<%-- <c:if test="${role.name != '系统管理员' }"> --%>
										<%--<option value="${list.id }" <c:if test="${role.parentId == list.id }"> selected ="selected"</c:if>>${list.name }</option>
								<%-- </c:if> --%>
								<%--</c:forEach>	--%>
						</select>
					</div>
				</div>
			</div>
		</div>
		<%-- <div class="span">
			<div class="control-group">
				<label class="control-label-xs">系统数据：</label>
				<div class="controls">
					<form:select path="sysData">
						<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
					<!-- <span class="help-inline">“是”代表此数据只有超级管理员能进行修改，“否”则表示拥有角色修改人员的权限都能进行修改</span> -->
				</div>
			</div>
		</div> --%>
		<div class="control-group">
			<div class="controls">
				<!-- <div  style="width:40%;float:left;padding-left:14px;">
					<label class="control-label" id="storeRole">前台授权：</label><br />
					<div id="officeTree" class="ztree" style="margin-top:3px;margin-left:60px;"></div>
					<form:hidden path="officeIds"/>
				</div> -->
				<div style="float:left;padding-left:14px;">
					<label class="control-label">菜单授权：</label><br />
					<div id="menuTree" class="ztree" style="margin-top:3px;margin-left:60px;"></div>
					<form:hidden path="menuIds"/>
				</div>
			</div>
		</div>
		<div class="fixed-btn-right">
			<c:if test="${(role.sysData eq fns:getDictValue('是', 'yes_no', '1') && fns:getUser().admin) ||!(role.sysData eq fns:getDictValue('是', 'yes_no', '1')) }">
				<shiro:hasPermission name="sys:role:edit">
				<input id="btnSubmit" class="btn btn-primary" type="button"  value="保 存"/>&nbsp;
				</shiro:hasPermission>
			</c:if>
			
		</div>
	</form:form>
</body>
</html>