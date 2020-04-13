<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>系统提醒管理</title>
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
                    "iframe:${ctx}/sys/sysNotify/form?eventName="+eventName,
                    "提醒新增",
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
                    "iframe:${ctx}/sys/sysNotify/form?eventName="+eventName+"&id=" + id,
                    "提醒编辑",
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
            
           //已读
           $("#contentTable a.read").click(function (e) {
           		var id = $(this).data("id");
           		var params = {id:id};
           		$.jBox.confirm("是否标记为已读！", "提示", function (v, h, f) {
				    if (v == true){
				    	loadAjax("${ctx}/sys/sysNotify/read",params,function(result){
					    	if(result.retCode=="000000"){
					    		$.jBox.alert("已读成功！");	
					    		$("#searchForm").submit();
		                	}else{
		                		$.jBox.alert(result.retMsg);	                		
		                	}
						});
				    }
				    return true;
				}, { buttons: { '确定': true}});
				return;
            });

            //删除
            $("#contentTable a.delete").click(function (e) {
                var id = $(this).data("id");
                var name = $(this).data("name");
                confirmx('确认要删除该提醒吗？', "${ctx}/sys/sysNotify/delete?id=" + id);
            });
            
            $("#status").select2('val',"2");
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
	<form:form id="searchForm" modelAttribute="sysNotify" action="${ctx}/sys/sysNotify/" method="post" class="breadcrumb form-search">
		<input id="tabPageId" name="tabPageId" type="hidden" value="${param.tabPageId}"/>
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li>
				<select name="dateType" class="select-medium4">
					<option value="1">提醒时间</option>
					<option value="2">发布时间</option>
				</select>
				<input name="startDate" type="text" readonly="readonly" maxlength="20" class="input-mini Wdate "
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>-
				<input name="endDate" type="text" readonly="readonly" maxlength="20" class="input-mini Wdate "
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
			</li>
			<li>
				<label>状态：</label>
				<form:select id="status" path="status" class="select-medium4" value="2">
					<form:option value="" label="--请选择--"/>
					<form:options items="${fns:getDictList('readStatus')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li>
				<label>类型：</label>
				<form:select id="notifyType" path="notifyType" class="select-medium4">
					<form:option value="" label="--请选择--"/>
					<form:options items="${fns:getDictList('notifyType')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</li>
			<li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				
				<th>提醒类型</th>
				<th>内容</th>
				<th>提醒时间</th>
				<th>已读人</th>
				<th>状态</th>
				<th>发布人</th>
				<th>发布时间</th>
				<shiro:hasPermission name="sys:sysNotify:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="sysNotify">
			<tr>
				<td>
					${fns:getDictLabel(sysNotify.notifyType, 'notifyType', '')}
				</td>
				<td>
					${sysNotify.content}
				</td>
				<td>
					<fmt:formatDate value="${sysNotify.notifyDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
					${sysNotify.readers}
				</td>
				<td>
					${fns:getDictLabel(sysNotify.status, 'readStatus', '')}
				</td>
				<td>
					${sysNotify.createBy.loginName}
				</td>
				<td>
					<fmt:formatDate value="${sysNotify.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<shiro:hasPermission name="sys:sysNotify:edit">
					<td>
						<c:choose>
							<c:when test="${fns:getUser().id.equals(sysNotify.createBy.id)}">
								<a class="update" data-id="${sysNotify.id}">
			    					修改
			    				</a>
								<a class="delete" data-id="${sysNotify.id}" data-name="${sysNotify.id}">
									删除
								</a>
							</c:when>
						</c:choose>
						<c:choose>
							<c:when test="${(sysNotify.status).equals('2')}">
								<a class="read" data-id="${sysNotify.id}" data-name="${sysNotify.id}">
									已读
								</a>
							</c:when>
						</c:choose>
					</td>
				</shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
	<shiro:hasPermission name="member:cmGroup:edit">
	    <div class="fixed-btn"><input type="button" id="addBtn" class="btn btn-primary" value="新增"/></div>
	</shiro:hasPermission>
</body>
</html>