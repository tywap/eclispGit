<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<script type="text/javascript">
	//分页
	var pageIndex = Math.max('${pageIndex}',1);
	var pageSize = 20;
	function page(type){
		if(type=='last'){
			pageIndex = pageIndex-1;
		}else if(type=='next'){
			pageIndex = pageIndex+1;
		}
		console.log("当前页pageIndex="+pageIndex);
		$("#pageIndex").val(pageIndex);
		$("#startPage").val((pageIndex-1)*pageSize);
		$("#endPage").val(pageSize);
		$("#searchForm").submit();
    	return false;
    }
</script>
<div class="pagination">
	<ul>
		<c:choose>
			<c:when test="${pageIndex==1}">
				<li class="disabled"><a>&#171; 上一页</a></li>
			</c:when>
			<c:otherwise>
				<li><a href="javascript:" onclick="page('last');">&#171; 上一页</a></li>
			</c:otherwise>
		</c:choose>
		<li><a href="javascript:" onclick="page('next');">下一页 &#187;</a></li>
		<li class="disabled controls">
			<a href="javascript:">第&nbsp;${pageIndex}&nbsp;页</a>
		</li>
	</ul>
	<div style="clear:both;"></div>
</div>