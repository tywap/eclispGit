<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>集团酒店管理</title>
	<meta name="decorator" content="default"/>
	<%@include file="/WEB-INF/views/include/treetable.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {
			//window.parent.jBox.close();
			//alert("${rentId}");
			var tpl = $("#treeTableTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
			var data = ${fns:toJson(list)}, rootId = "${not empty office.id ? office.id : rentId}";
			addRow("#treeTableList", tpl, data, rootId, true);
			$("#treeTable").treeTable({expandLevel : 5});
		});
		function addRow(list, tpl, data, pid, root){
			//console.log(data);
			for (var i=0; i<data.length; i++){
				var row = data[i];
				//alert(${fns:jsGetVal('row.parentId')});
				if ((${fns:jsGetVal('row.parentId')}) == pid){
					$(list).append(Mustache.render(tpl, {
						dict: {
							type: getDictLabel(${fns:toJson(fns:getDictList('sys_office_type'))}, row.type)
						}, pid: (root?0:pid), row: row
					}));
					addRow(list, tpl, data, row.id);
				}
			}
			//alert(list);
		}
		
		
		//***************************新增********************************//
		function addOffice(){
			var officeType = '${office.type}';
			if(officeType == '3' || officeType == '4'){
				$.jBox.alert("分店与直营店下面不允许再新增机构！");
				return;
			}
			top.$.jBox.open(
					"iframe:${ctx}/sys/office/form?tabPageId=${tabPageId}&parent.id=${office.id}", 
					"新增机构",
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
		
		//*********************************************//
		function editOffice(id){
			top.$.jBox.open(
					"iframe:${ctx}/sys/office/form?tabPageId=${tabPageId}&id="+id, 
					"修改机构",
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
	
	<sys:message content="${message}"/>
	<div style="margin-top:20px;">
	<table id="treeTable" class="table table-striped table-bordered table-condensed">
		<thead><tr><th>公司名称</th><th>公司编码</th><th>公司类型</th>
		<th>联系人</th><th>联系电话</th><shiro:hasPermission name="sys:office:edit"><th>操作</th></shiro:hasPermission>
		<th>地址</th><th>创建时间</th></tr></thead>
		<tbody id="treeTableList"></tbody>
	</table></div>
	<script type="text/template" id="treeTableTpl">
		<tr id="{{row.id}}" pId="{{pid}}">
			<td>{{row.name}}</td>
			
			<td>{{row.code}}</td>
			<td>{{dict.type}}</td>
			<td>{{row.master}}</td>
			<td>{{row.phone}}</td>
			<td>
				<a onclick="editOffice('{{row.id}}')" <shiro:lacksPermission name="sys:office:edit">disabled</shiro:lacksPermission> >修改</a>
				<a href="${ctx}/sys/office/delete?id={{row.id}}"  <shiro:lacksPermission name="sys:office:delete">disabled</shiro:lacksPermission> onclick="return confirmx('要删除该机构及所有子机构项吗？', this.href)">删除</a>
			</td>
			<td>{{row.area.parentNames}}-{{row.area.name}}</td>
			<td>{{row.createDate}}</td>
		</tr>
	</script>
	<div class="fixed-btn">
	<button class="btn btn-primary" <shiro:lacksPermission name="sys:office:edit">disabled</shiro:lacksPermission> id="addBtn" onclick="addOffice()">新增</button>
	</div>
</body>
</html>