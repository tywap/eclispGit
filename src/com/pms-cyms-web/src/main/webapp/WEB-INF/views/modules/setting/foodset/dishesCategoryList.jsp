<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>菜品类别设置</title>
	<meta name="decorator" content="default"/>
	<%@include file="/WEB-INF/views/include/treetable.jsp" %>
		<style>
	.remarks{
	width: 500px;
	font-size:12px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    display: block;
    
    }
	</style>
	<script type="text/javascript">
		//事件名称保持唯一，这里直接用tabId
		var eventName="dishesCategory";
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
			
	        //***************************新增********************************//
	        //新增大类
	       $("#addBigType").click(function(){
	            top.$.jBox.open(
	            	"iframe:${ctx}/setting/ctFoodType/form?type=0",
	                "新增大类",
	                1000,
	                $(top.document).height()-180,
	                {
	                    buttons:{},
	                    loaded:function(h){
	                        $(".jbox-content", top.document).css("overflow-y","hidden");
	                    }
	                }
	            );
	        });
	        
	      //新增小类
	      $("#addLittleType").click(function(){
	            top.$.jBox.open(
	                "iframe:${ctx}/setting/ctFoodType/form?type=1",
	                "新增小类",
	                1000,
	                $(top.document).height()-180,
	                {
	                    buttons:{},
	                    loaded:function(h){
	                        $(".jbox-content", top.document).css("overflow-y","hidden");
	                    }
	                }
	            );
	        });
		});
		
		function addRow(list, tpl, data1, pid, root){
			for (var i=0; i<data1.length; i++){
				var row = data1[i];
				if ((${fns:jsGetVal('row.parentId')}) == pid){
					$(list).append(Mustache.render(tpl, {row:row,pid: (root?0:pid)
					}));
					addRow(list, tpl, data1, row.id);
				}
			}
		}
        
      //***************************新增********************************//
        function editdishes(id,type){
	    	var dishesType='';
	    	if (type == '大类') {
	    		  dishesType='0';
			}if (type == '小类') {
	    		  dishesType='1';
			}
            top.$.jBox.open(
                "iframe:${ctx}/setting/ctFoodType/form?id="+id+"&type="+dishesType,
                "编辑菜品类别",
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
      
      
      function deleteishes(id,type) {
    	  var dishesType='';
	    	if (type == '大类') {
	    		  dishesType='0';
			}if (type == '小类') {
	    		  dishesType='1';
			}
			params = {id:id,type:dishesType};
			loadAjax("${ctx}/setting/ctFoodType/delete",params,function(result){
				if(result.retCode=="000000"){
					 layer.alert("删除成功！");
	        		 window.location.reload();
                }else{
              	  layer.alert(result.retMsg);
                }
			});
	}
	</script>
</head>
<body>
	
	<div style="margin-top:20px;">
	<table id="treeTable" class="table table-striped table-bordered table-condensed">
		<thead>
		<tr><th>编号</th><th>列表名称</th><th>类别</th><th style="width:500px;">应用分店</th><shiro:hasPermission name="sys:role:edit"><th>操作</th></shiro:hasPermission></tr></thead>
		<tbody id="treeTableList"></tbody>
		</table>
	</div>
		<script type="text/template" id="treeTableTpl">
		<tr id="{{row.id}}" pId="{{row.parentId}}">
			<td>{{row.code}}</td>
			<td>{{row.name}}</td>
			<td>{{row.type}}</td>
			<td class="remarks" title="{{row.storeName}}">{{row.storeName}}</td>
            <td>
				<a onclick="editdishes('{{row.id}}','{{row.type}}')" <shiro:lacksPermission name="dishesCategory:setting:edit">disabled</shiro:lacksPermission>>修改</a>
				<a onclick="deleteishes('{{row.id}}','{{row.type}}')" <shiro:lacksPermission name="dishesCategory:setting:delete">disabled</shiro:lacksPermission> onclick="return confirmx('确认要删除该菜品吗？', this.href)">删除</a>
			</td>
		</tr>
	</script>
	<div class="fixed-btn">
		<button
			class="btn btn-primary" type="button" id="addBigType" >新增大类</button>
		<button
			class="btn btn-primary" type="button" id="addLittleType">新增小类</button>
	</div>
</body>
</html>