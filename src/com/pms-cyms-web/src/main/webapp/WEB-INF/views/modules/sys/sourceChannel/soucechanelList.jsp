<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>渠道客源-增删改查管理</title>
	<meta name="decorator" content="default"/>
	<style>
		.build-edit{display:inline-block;width:100px;height:30px;line-height:30px;text-align:center;background-color:#fff;border:1px solid #ccc;margin-left:5px;}
		.edit-icon{display:inline-block;width:30px;height:30px;line-height:30px;text-align:center;background-color:#fff;border:1px solid #ccc;margin-left:-5px;}
		.build-edit:hover{ background-color:#3daae9;cursor:pointer;}

	</style>
	<script type="text/javascript">
		$(document).ready(function() {
            //解绑事件
            top.$.unsubscribe("sourceAndChannel");
            //注册事件，弹出页面需要刷新本页面，或者弹出页面回传数据用
            top.$.subscribe("sourceAndChannel", function (e, data) {
                //data  可以通过这个对象来回传数据
            	window.location.reload();
            });

            //新增
            $("#addBtn").click(function () {
                top.$.jBox.open(
                    "iframe:${ctx}/sys/sourceChannel/form",
                    "客源新增",
                    1000,
                    $(top.document).height() - 180,
                    {
                        buttons: {},
                        loaded: function (h) {
                            $(".jbox-content", top.document).css("overflow-y", "hidden");
                        }
                    }
                );
            });
		});
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }
		
		
        
        function delchannel(key){
        }
        
        function editSource(sourceId){
            top.$.jBox.open(
                    "iframe:${ctx}/sys/sourceChannel/form?sourceId="+sourceId,
                    "客源编辑",
                    1000,
                    $(top.document).height() - 180,
                    {
                        buttons: {},
                        loaded: function (h) {
                            $(".jbox-content", top.document).css("overflow-y", "hidden");
                        }
                    }
             );
        }
        
        
        function deleteSource(sourceId){
    		var r=confirm("是否确认删除");
    	    if (r==true){
    			$.ajax({
 	               url:"${ctx}/sys/sourceChannel/validateSourceDelete",
 	               type: "post",
 	               dataType: "text",
 	               data: {
 	            	   sourceId:sourceId
 	               },
 	               success: function (result) {
 	            	   if(result==null||result==""){
 	            		  deleteSourceFinal(sourceId);
 	            	   }
 	            	   else
 	            		   $.jBox.alert(result);
 		      		}
 				});
    	    	
    	    }else{
    	    }
        }
        
        function deleteSourceFinal(sourceId){
			$.ajax({
	               url:"${ctx}/sys/sourceChannel/deleteSource",
	               type: "post",
	               dataType: "json",
	               data: {
	            	   sourceId:sourceId
	               },
	               success: function (result) {
	            	   if(result){
	            		   $.jBox.alert("删除成功！");
	            		   window.location.reload();
	            	   }
	            	   else
	            		   $.jBox.alert("删除失败！");
		      		}
				});
        }
        
	</script>
</head>
<body>
	<%-- <form:form id="searchForm" modelAttribute="sourceChannel" action="${ctx}/roominfo/soucechanel/" method="post" class="breadcrumb form-search">
		<input id="tabPageId" name="tabPageId" type="hidden" value="${param.tabPageId}"/> 
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
	</form:form> --%>
		<ul class="ul-form" style="display: none">
			<li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li>
			<li class="clearfix"></li>
		</ul>

	
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed" style="margin-top:20px;">
		<thead>
			<tr>
				<th>客源名称</th>
				<th>应用渠道</th>
				<th>排序</th>
				<shiro:hasPermission name="roominfo:soucechanel:edit">
				<th>操作</th>
				</shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="sourceChannel">
			<tr>
				<td>
					${sourceChannel.name}
				</td>
				<td>
					${sourceChannel.extend}
				</td>
				<td>${sourceChannel.sort}</td>
				<shiro:hasPermission name="roominfo:soucechanel:edit">
				<td>
					<c:if test="${sourceChannel.remarks=='1'}">
						<a onclick="editSource('${sourceChannel.id}')">修改</a>
	 					<a onclick="deleteSource('${sourceChannel.id}')" >删除</a>
 					</c:if>
 					<c:if test="${sourceChannel.remarks=='2'}">
 						<a onclick="editSource('${sourceChannel.id}')">修改</a>
 					</c:if>
				</td>
				</shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
	<shiro:hasPermission name="roominfo:soucechanel:edit">
	<div class="fixed-btn" id="btns" ${(page==null)?"style='display:none'":""}>
	<button class="btn btn-primary" id="addBtn" >新增</button>&nbsp;&nbsp;&nbsp;
	</div>
	</shiro:hasPermission>
</body>
</html>