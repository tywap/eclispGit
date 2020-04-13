<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>进入分店</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		var storeId;
		function page(n,s){
			if(n) $("#pageNo").val(n);
			if(s) $("#pageSize").val(s);
			$("#searchForm").attr("action","${ctx}/sys/office/branchList");
			$("#searchForm").submit();
	    	return false;
	    }
		
		
		
        //***************************进入分店********************************//
         function toBranch(code){
        	storeId = code
            top.$.jBox.open(
                "iframe:${ctx}/sys/office/choseShift?storeId="+storeId,
                "选择班次",
                600,
                $(top.document).height() - 380,
                {
                    buttons: {},
                    loaded: function (h) {
                        $(".jbox-content", top.document).css("overflow-y", "hidden");
                    }
                }
            );
        }
      
	</script>
</head>
<body>
	<form:form id="searchForm" modelAttribute="office" action="${ctx}/sys/office/branchList" method="post" class="breadcrumb form-search ">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<sys:tableSort id="orderBy" name="orderBy" value="${page.orderBy}" callback="page();"/>
		 <ul class="ul-form">
		 	<li><label>酒店地址：</label><form:input path="address" htmlEscape="false" maxlength="50" class="input-medium6"/></li>
			<li><label>所属机构：</label>
				<form:select id="parentIds" path="parentIds" class="input-medium6">
					<form:option value="" /><form:options items="${officeList}" itemValue="id" itemLabel="name" htmlEscape="false"/>
				</form:select>
			</li>
			<li><label>酒店名称：</label><form:input path="name" htmlEscape="false" maxlength="50" class="input-medium6"/></li>
			<li class="btns"><button id="btnSubmit" class="btn btn-primary" type="submit"  onclick="return page();">查询</button>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead><tr><th class="sort-column login_name">酒店名称</th><th>酒店编号</th><th>地址</th>
		<th>操作</th></tr></thead>
		<tbody>
		<c:forEach items="${page.list}" var="office">
			<tr>
				<td>${office.name}</td>
				<td>${office.code}</td>
				<td>${office.address}</td>
				<td>
    				<a onclick="toBranch('${office.id}')">进入分店</a>
				</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>