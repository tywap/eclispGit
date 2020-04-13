<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%-- <script src="${ctxStatic}/common/wsize.min.js" type="text/javascript"></script> --%>
<script src="${ctxStatic}/common/newfile5.js" type="text/javascript"></script>
<script src="${ctxStatic}/room/context.js?V=29" type="text/javascript"></script>
<link rel="stylesheet" href="${ctxStatic}/diagram/css/diagram.css" type="text/css" />
<script type="text/javascript">
	// edit by gaoyiping 2018-04-28
	$(document).ready(function() {
		$(".quick_bar").bind("click", function(){
			quickBtn(this);
		});
		getIndexInfo();
		initSetting();
		$('.quick_bar').labelauty();
	});
	
	function quickBtn(obj){
		var thisForm=$("#"+$(obj).attr("name")+"Form");
		if($(obj).attr("checked")=="checked"){
			$(thisForm).val($(thisForm).val()+$(obj).val()+",");
		}else{
			$(thisForm).val($(thisForm).val().replace($(obj).val()+",",""));
		}
		layer.load();
		$("#storeIdForm").val($("#storeId").val());
		$("#searchForm").submit();
	}
	
	function getIndexInfo(){
		//$(".curholder").hide();
		//$(".holder").hide();
		if(typeof addTab != 'undefined' && addTab instanceof Function){
			addTab($("#hiddenA"));			
		}
		//$("#mainFrame").show();
		changeStore();
	}
	
	// 清除条件
	function clearFilter() {
		// 文字搜索
		$("#searchParam").val(null);
		haveSearchParams = false;
		// 选择框
		$('input:checkbox').removeAttr("checked");
		// 楼层
		$("#buildingSelect").val(null);
		// Form参数
		$('#searchForm input').val(null);
		layer.load();
		$("#storeIdForm").val($("#storeId").val());
		$("#searchForm").submit();
	}
	
	var haveSearchParams = false;
	function doSearch() {
		var wd = $("#searchParam").val();
		if (wd.length) {
			haveSearchParams = true;
			$("#searchParamForm").val(wd);
		} else if (haveSearchParams){
			haveSearchParams = false;
			$("#searchParamForm").val(null);
		} else {
			return;
		}
		layer.load();
		$("#storeIdForm").val($("#storeId").val());
		$("#searchForm").submit();
	}
	
	function changeBuilding(){
		var buildId = $("#buildingSelect").val();
		if (buildId.length) {
			$(".floors").css("display","none");
			$(".floors[building*='"+buildId+",']").css("display","");
		} else {
			$(".floors").css("display","");
		}
		$(".floors").find("input").removeAttr("checked");
		$("#floorForm").val(null);
		$("#buildingForm").val($("#buildingSelect").val());
		layer.load();
		$("#storeIdForm").val($("#storeId").val());
		$("#searchForm").submit();
	}
	function changeStore(){
		layer.load();
		var storeId = $("#storeId").val();
		top.$.publish("sysIndex",{storeId:storeId});
		$("#storeIdForm").val(storeId);
		initSetting();
		$("#searchForm").submit();
	}
	function initSetting(){
		var storeId = $("#storeId").val();
		$.ajax({
	        url:"${ctx}/diagram/getSettingByStoreId",
	        type: "post",
	        dataType: "json",
	        data: {
	        	storeId:storeId
	        },
	        success: function (result) {
	        	if(result.retCode=='000000'){
	        		var tableTypesHtml = "";
	        		var tableTypes = result.ret.tableTypes;
	        		for(var i=0;i<tableTypes.length;i++){
	        			var tableType = tableTypes[i];
	        			tableTypesHtml+=""+
	        			"<li>"+
							"<input type='checkbox' name='tableType' value='"+tableType.id+"' data-labelauty='"+tableType.name+"' onclick='quickBtn(this)' class='quick'>"+
						"</li>";
	        		}
	        		$("#tableTypeUl").html(tableTypesHtml);
	        		
	        		var floorsHtml = "";
	        		var floors = result.ret.floors;
	        		for(var i=0;i<floors.length;i++){
	        			var floor = floors[i];
	        			floorsHtml+=""+
	        			"<li>"+
							"<input type='checkbox' name='floor' value='"+floor.id+"' data-labelauty='"+floor.name+"' onclick='quickBtn(this)' class='quick'>"+
						"</li>";
	        		}
	        		$("#floorUl").html(floorsHtml);
	        		$('.quick').labelauty();
	        	}
	   		}
		});
	}
</script>
<script type="text/javascript">
var leftWidth = 220; // 左侧窗口大小
var htmlObj = $("html"), mainObj = $("#main");
var headerObj = $("#header"), footerObj = $("#footer");
var frameObj = $("#left, #openClose, #right, #right iframe");
function wSize() {
	var minHeight = 500, minWidth = 980;
	var strs = getWindowSize().toString().split(",");
	htmlObj.css({"overflow-x":"hidden"});
	mainObj.css("width","auto");
	frameObj.height(strs[0] - 5);
	$(".lump_homepage").height(strs[0] - 45);
	var leftWidth = ($("#left").width() < 0 ? 0 : $("#left").width());
	frameObj.height((strs[0] < minHeight ? minHeight : strs[0]) - headerObj.height() - footerObj.height());
	$("#right").width($("#content").width()- leftWidth - $("#openClose").width() -5);
	//$(".ztree").width(leftWidth - 10).height(frameObj.height() - 46);
}
</script>
<div id="index_sidebar" class="accordion">
	<a id="hiddenA" style="display: none" data-href=".menu3-98" href="${ctx}/diagram/indexRight?storeId=${offices[0].id}" target="mainFrame" >首页</a>
	<form id="searchForm" style="display: none" method="post" action="${ctx}/diagram/indexRight" target="jerichotabiframe_0">
		<input type="hidden" name="searchParam" id="searchParamForm" />	<!-- 搜索框 -->
		<input type="hidden" name="storeId" id="storeIdForm" />		<!-- 楼栋 -->
		<input type="hidden" name="building" id="buildingForm" />		<!-- 楼栋 -->
		<input type="hidden" name="floor" id="floorForm" />			<!-- 楼层 -->
		<input type="hidden" name="tableType" id="tableTypeForm" />		<!-- 房型 -->
		<input type="hidden" name="tableStatus" id="tableStatusForm" />	<!-- 房态 -->
		<input type="hidden" name="guestState" id="guestStateForm" />	<!-- 客态 -->
	</form>
	<ul>
		<li style="margin:10px; padding-top:10px;">
			<button id="clear-button" type="button" onclick="javascript:clearFilter()">一键清除</button>
		</li>
		<li id="search">
			<input type="text" id="searchParam" onkeypress="javascript:doSearch()" placeholder="输入台号、预定信息、联系人、业务员快速查询" />
			<button class="" type="button" onclick="javascript:doSearch()" ><i class="fa fa-search"></i></button>
		</li>
		<li class=""><i class="fa fa-sort-amount-desc"></i><span>餐厅</span>
			<div style="padding:5px 17px;">
				<select class="select-medium10" onchange="changeStore()" id="storeId">
					<c:forEach items="${offices}" var="office">
						<option value="${office.id}">${office.name}</option>
					</c:forEach>
				</select>
			</div>
		</li>
		<c:if test="${!empty settings.floor}">
			<li class=""><i class="fa fa-cube"></i><span>区域</span>
				<ul class="dowebok" id="floorUl">
				</ul>
			</li>
		</c:if>
		<c:if test="${!empty settings.tableType}">
			<li class=""><i class="fa fa-cube"></i><span>餐台类型</span>
				<ul class="dowebok" id="tableTypeUl">
				</ul>
			</li>
		</c:if>
		<c:if test="${!empty settings.tableStatus}">
			<li class=""><i class="fa fa-cube"></i><span>台态</span>
				<ul class="dowebok">
					<c:forEach items="${tableStatus}" var="tableStatus">
						<li>
							<input type="checkbox" name="tableStatus" value="${tableStatus.code}" data-labelauty="${tableStatus.name}" class="quick_bar">
						</li>
					</c:forEach>
				</ul>
			</li>
		</c:if>
		<c:if test="${!empty settings.guestStatus}">
			<li class=""><i class="fa fa-cube"></i><span>客态</span>
				<ul class="dowebok">
					<c:forEach items="${tableStatus}" var="tableStatus">
						<li>
							<input type="checkbox" name="tableStatus" value="${tableStatus.code}" data-labelauty="${tableStatus.name}" class="quick_bar">
						</li>
					</c:forEach>
				</ul>
			</li>
		</c:if>
	</ul>
</div>
	