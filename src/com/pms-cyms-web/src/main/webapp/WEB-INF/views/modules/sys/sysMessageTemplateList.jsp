<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>短信模板管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//事件名称保持唯一，这里直接用tabId
            var eventName="${param.tabPageId}";
            //解绑事件
            top.$.unsubscribe(eventName);
            //注册事件，弹出页面需要刷新本页面，或者弹出页面回传数据用
            top.$.subscribe(eventName, function (e, data) {
                //data  可以通过这个对象来回传数据
                $("#searchForm").submit();
            });
            
          //新增
            $("#addBtn").click(function () {
                top.$.jBox.open(
                    "iframe:${ctx}/sys/sysMessageTemplate/form?eventName="+eventName,
                    "新增-短信模板",
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
            
          	//修改
            $("#contentTable a.update").click(function (e) {
                var id = $(this).data("id");
                top.$.jBox.open(
                    "iframe:${ctx}/sys/sysMessageTemplate/form?eventName="+eventName+"&id=" + id+"&editFlag=edit",
                    "编辑-短信模板",
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
          	
          	//删除
            $("#contentTable a.delete").click(function (e) {
                var id = $(this).data("id");
                var name = $(this).data("name");
                confirmx('确认要删除短信模板吗？', "${ctx}/sys/sysMessageTemplate/delete?id=" + id);
            });
            
			//短信测试
			$("#contentTable a.preview").click(function(e){
				var id = $(this).data("id");
				var html = "<div style='padding:10px;'>手机号码：<input type='text' id='phone' name='phone' /></div>"; 
				var submit = function (v, h, f) { 
				    if (f.yourname == '') { 
				        $.jBox.tip("请输入您的姓名。", 'error', { focusId: "phone" }); // 关闭设置 为焦点 
				        return false; 
				    } 
				    var phone = f.phone;
				    var params = {id:id,phone:phone};
				    loadAjax("${ctx}/sys/sysMessageTemplate/preview",params,function(result){
				    	if(result.retCode=="000000"){
	                		$.jBox.alert(result.retMsg);
	                	}else{
	                		$.jBox.alert(result.retMsg);	                		
	                	}
					});
				    return true; 
				}; 
				$.jBox(html, { title: "请输入手机号码？", submit: submit });
			});
		});
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }
	</script>
</head>
<body>
	<form:form id="searchForm" modelAttribute="sysBusiConfig" action="${ctx}/sys/sysMessageTemplate/" method="post" class="breadcrumb form-search">
		<input id="tabPageId" name="tabPageId" type="hidden" value="${param.tabPageId}"/> 
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>类型</th>
				<th>状态</th>
				<th>内容</th>
				<!--<th>更新时间</th>
				 <th>备注信息</th> -->
				<shiro:hasPermission name="sys:sysMessageTemplate:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="sysMessageTemplate">
			<tr>
				<td>
					${sysMessageTemplate.typeName}
				</td>
				<td>
					${fns:getDictLabel(sysMessageTemplate.status, 'status', '')}
				</td>
				<td>
					${sysMessageTemplate.content}
				</td>
				<!--<td>
					<fmt:formatDate value="${sysMessageTemplate.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
					${sysMessageTemplate.remarks}
				</td> -->
				<shiro:hasPermission name="sys:sysMessageTemplate:edit">
					<td>
	    				<a class="update" data-id="${sysMessageTemplate.id}">修改</a>
	    				<!-- <a class="delete" data-id="${sysMessageTemplate.id}"> 删除 </a> 
						<a class="preview" data-id="${sysMessageTemplate.id}">
							测试
						</a>-->
					</td>
				</shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
	<shiro:hasPermission name="member:cmGroup:edit">
	    <!-- <div class="fixed-btn"><input type="button" id="addBtn" class="btn btn-primary" value="新增"/></div> -->
	</shiro:hasPermission>
</body>
</html>