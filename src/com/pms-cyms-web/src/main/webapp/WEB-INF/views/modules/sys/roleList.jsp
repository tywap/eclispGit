]<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>角色管理</title>
	<meta name="decorator" content="default"/>
	<%@include file="/WEB-INF/views/include/treetable.jsp" %>
	<script type="text/javascript">
		//事件名称保持唯一，这里直接用tabId
		var eventName="role111";
		$(document).ready(function() {
		    //解绑事件
		    top.$.unsubscribe(eventName);
		    //注册事件，弹出页面需要刷新本页面，或者弹出页面回传数据用
		    top.$.subscribe(eventName, function (e, data) {
	        //data  可以通过这个对象来回传数据
	        	window.location.reload();
		    });
		    
		    var tpl = $("#treeTableTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
			var data1 = ${list}, rootId = "0";
			addRow("#treeTableList", tpl, data1, rootId, true);
			$("#treeTable").treeTable({expandLevel:5});
		})
		
		function addRow(list, tpl, data1, pid, root){
			for (var i=0; i<data1.length; i++){
				var row = data1[i];
				if ((${fns:jsGetVal('row.parentId')}) == pid){
					$(list).append(Mustache.render(tpl, {row:row,pid: (root?0:pid),
						graphBtn:function(){  
					        if(row.parentId !="0"){
					            return true;  
					        }  
					       return false;  
					    }
					}));
					addRow(list, tpl, data1, row.id);
				}
			}
		}
		
		
        //***************************新增********************************//
        function addRole(){
            top.$.jBox.open(
                "iframe:${ctx}/sys/role/form",
                "新增岗位权限",
                1000,
                $(top.document).height()-180,
                {
                    buttons:{},
                    loaded:function(h){
                        $(".jbox-content", top.document).css("overflow-y","hidden");
                    }
                }
            );
        }
        
      //***************************新增********************************//
        function editRole(id){
            top.$.jBox.open(
                "iframe:${ctx}/sys/role/form?&id="+id,
                "编辑岗位权限",
                1000,
                $(top.document).height()-180,
                {
                    buttons:{},
                    loaded:function(h){
                        $(".jbox-content", top.document).css("overflow-y","hidden");
                    }
                }
            );
        }
	</script>
</head>
<body>
	<%--<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/sys/role/">角色列表</a></li>
		<shiro:hasPermission name="sys:role:edit"><li><a href="${ctx}/sys/role/form">角色添加</a></li></shiro:hasPermission>
	</ul>--%>
	<form:form id="searchForm" modelAttribute="role" action="${ctx}/sys/role/list" method="post" class="breadcrumb form-search ">
		<ul class="ul-form">
			<li><label>岗位名称：</label><form:input path="name" htmlEscape="false" maxlength="50" class="input-medium6"/></li>
			<li class="btns">
				<button id="btnSubmit" class="btn btn-primary" >查询</button>
				<!-- <button id="btnExport" class="btn btn-primary">导出</button>
				<button id="btnImport" class="btn btn-primary">导入</button> -->
			</li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<div style="margin-top:20px;">
	<table id="treeTable" class="table table-striped table-bordered table-condensed">
		<thead>
		<tr><th>角色名称</th><th>岗位类型</th><th>数据范围</th><shiro:hasPermission name="sys:role:edit"><th>操作</th></shiro:hasPermission></tr></thead>
		<tbody id="treeTableList"></tbody>
		</table>
	</div>
		<script type="text/template" id="treeTableTpl">
		<tr id="{{row.id}}" pId="{{row.parentId}}">
			<td>{{row.name}}</td>
			<td>{{row.roleType}}</td>
			<td>{{row.dataScope}}</td>
            {{#graphBtn}}
            <td>
				<a onclick="editRole('{{row.id}}')" <shiro:lacksPermission name="sys:role:edit">disabled</shiro:lacksPermission>>修改</a>
				<a href="${ctx}/sys/role/delete?id={{row.id}}" <shiro:lacksPermission name="sys:role:delete">disabled</shiro:lacksPermission> onclick="return confirmx('确认要删除该角色吗？', this.href)">删除</a>
			</td>
            {{/graphBtn}}
		</tr>
	</script>
	<div class="fixed-btn">
		<button class="btn btn-primary" id="addBtn" <shiro:lacksPermission name="sys:role:edit">disabled</shiro:lacksPermission> onclick="addRole()">新增</button>
	</div>
</body>
</html>