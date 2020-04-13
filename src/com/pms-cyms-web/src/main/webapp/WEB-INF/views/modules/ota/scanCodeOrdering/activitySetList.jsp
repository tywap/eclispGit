<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>活动设置</title>
	<meta name="decorator" content="default"/>
	<script src="${ctxStatic}/jqprint/jquery.jqprint-0.3.js" type="text/javascript"></script>
	<script type="text/javascript">
	var storeName=  $("#storeId option:selected").text();
		//事件名称保持唯一，这里直接用tabId
	    var eventName="foodImgMaintain";
	  	//解绑事件
        top.$.unsubscribe(eventName);
        //注册事件，弹出页面需要刷新本页面，或者弹出页面回传数据用
        top.$.subscribe(eventName, function (e, data) {
            //data  可以通过这个对象来回传数据
            $("#searchForm").submit();
        });
		$(document).ready(function() {
			
			//加载分店
	        loadSelect("storeId","${ctx}/sys/userutils/getOfficeListByType",{typesJson:"['3','4','5']"},'${selectStoreId}','id','name'); 

		});
		
		
		//此处调用superTables.js里需要的函数
		window.onload=function(){
			new superTable("demoTable", {cssSkin : "sDefault",  
				headerRows :2,  //头部固定行数
				onStart : function () {  
				   this.start = new Date(); 
				},  
				onFinish : function () {  
				}  
			}); 

			var searchFormW = ($(".form-search").width() + 20)+"px";
			$("#div_container").css({"width":searchFormW+20});//这个宽度是容器宽度，不同容器宽度不同
			$(".fakeContainer").css("height",($(document).height()-100)+"px");//这个高度是整个table可视区域的高度，不同情况高度不同
				$("#demoTable").css({"width":searchFormW +"!important"});
			//.sData是调用superTables.js之后页面自己生成的  这块就是出现滚动条 达成锁定表头和列的效果				
			$(".sHeader").css("width",($(document).width())+"px");
			$(".sData").css("width",($(document).width())+"px");//这块的宽度是用$("#div_container")的宽度减去锁定的列的宽度
			$(".sData").css("height",($(document).height()-195)+"px");//这块的高度是用$("#div_container")的高度减去锁定的表头的高度
			
			//目前谷歌  ie8+  360浏览器均没问题  有些细小的东西要根据项目需求改
	
			//有兼容问题的话可以在下面判断浏览器的方法里写
			if(navigator.appName == "Microsoft Internet Explorer" && navigator.appVersion.match(/9./i)=="9.") 
			{//alert("IE 9.0");
				
			}else if (!!window.ActiveXObject || "ActiveXObject" in window){//alert("IE 10");
				
			}else{//其他浏览器
				//alert("其他浏览器");
			}
		}			
		//新增活动
		function addActivity() {
			top.$.jBox.open("iframe:${ctx}/ota/activitySet/form", "新增活动", 1000, 600, {
				buttons : {},
				loaded : function(h) {
					$(".jbox-content", top.document).css("overflow-y", "hidden");
				}
			});
		}; 
		
		function update(id,name) {
			top.$.jBox.open("iframe:${ctx}/ota/foodImgMaintain/form?id=" + id +"&name=" + name, 
					"修改图片名称", 
					350, 250, {
					buttons : {},
					loaded : function(h) {	
						$(".jbox-content", top.document).css("overflow-y", "hidden");
					}
				});
		}
		
		//批量删除
		function deletes() {
			var cks = $("input[name='item']:checked");
			var id = [];
			for(var i=0;i<cks.length;i++){
				var obj = cks[i];
				id.push(obj.id);
			}
			if (id.length>0) {
				layer.confirm('是否确认删除！', {
					btn: ['确定']
				}, function(index){
					layer.close(index);
					var params={id:id.join(',')};
	    			loadAjax("${ctx}/ota/foodImgMaintain/foodImgDeletes", params, function(result) {
	    				layer.confirm('删除成功', {
	    					btn: ['确定']
	    				}, function(){
	    					 $("#searchForm").submit();
	    				}, function(){
	    					 $("#searchForm").submit();
	    				});
	    			});
				}, function(){return;});
				
			}else {
				layer.alert("请选择需要删除的菜品图片！");
				return;
			}
		}
	</script>
	<style type="text/css">
	.select-medium6{
	width: 80px;
	margin-left: 5px;
	};
	#roleId option{
	width: 80px;
	}
	select:{
	width: auto;
	padding: 0 2%;
	margin: 0;
	}
	option{
	text-align:center;
	}
	.selectedTr{background-color: #FF9900}
	</style>
</head>
<body>
	<form:form id="searchForm" modelAttribute="ota" action="${ctx}/ota/activitySet/list" method="post" class="breadcrumb form-search ">
		<ul class="ul-form">
			<li>
			 	<label>分店：</label>
				<select id="storeId" name="storeId" class="select2 select-medium6" style="width: 110px;" onchange="searchChange(this)">
					<c:if test="${storeName == null}">
					<option>--请选择--</option>
					</c:if>
					<c:if test="${storeName.storeName != ''}">
					<option>${storeName.storeName }</option>
					</c:if>
				</select>
			</li>
			<li>
				<label>状态：</label>
				<select id="status" style="width: 100px;" name="status"  class="select-medium6"  >
					<option value="" >全部</option>
					<option value="0" <c:if test="${0==param.status}">selected</c:if>>停用</option>
					<option value="1" <c:if test="${1==param.status}">selected</c:if>>启用</option>
				</select>
			</li>
			<li>
				<label>活动类型：</label>
				<select id="activityType" style=" width: 100px;" name="activityType"  class="select-medium6"  >
						<option value="" >全部</option>
						<c:forEach items="${activityTypeList}" var="activityType" varStatus="vs">
                      	<option value="${activityType.id}" <c:if test="${activityType.id == param.activityType }">selected ="selected"</c:if>> ${activityType.name}</option>
                    </c:forEach>
				</select>
			</li> 
			<li>
				<label>活动名称：</label>
				<input style="width: 160px;" type="text" name="name" value="${param.name}" id="name" htmlEscape="false" maxlength="80" class="input-medium6" placeholder="请输入活动编号或名称查询"/>
				</select>
			</li>
			<li>
				<label>活动日期：</label>
			</li>
			<li>
			<input style="width: 160px;" type="text" name="name" value="${param.name}" id="name" htmlEscape="false" maxlength="80" class="input-medium6" placeholder="按菜品名称搜索图片"/>
			</li>
			<li class="btns">
				<button type="submit" id="btnSubmit" class="btn btn-primary" >查询</button>
			</li>
		</ul>
	</form:form>
	<div id="my_div" class="fakeContainer first_div" style="overflow:auto;">
		<table class="table table-bordered center" id="demoTable">
		<thead>
			<tr id="my_tr">
				<th >选择</th>
				<th >状态</th>
				<th >活动编号</th>
				<th >活动名称</th>
				<th >活动类型</th>
				<th >活动日期</th>
				<th >活动时间</th>
				<th >操作</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${ordList}" var="ord" varStatus="ordStatus">
			<tr orderId="${ord.id}" orderStatus="${ord.status}">
				<td>${ord.storeName}</td>
				<td>${ord.status}</td>
				<td><fmt:formatDate value="${ord.createDate}" type="date" pattern="yyyy-MM-dd HH:mm"/></td>
				<td>${ord.userName}</td>
				<td><a onclick="getOrder('${ord.id}')">${ord.id }</a></td>
				<td>${ord.tableNo}</td>
				<td>${ord.floorName}</td>
				<td>${ord.tableTypeName}</td>
				<td>${ord.useNum}</td>
				<td>${ord.sourceName}</td>
				<td>${ord.thirdPartId}</td>
				<td>${ord.userName}</td>
				<td>${ord.useType }</td>
				<td>${ord.useLevel}</td>
				<c:forEach items="${ord.foodTypePrice}" var="price" >
					<td><fmt:formatNumber type="number" value="${price.value}" pattern="0.00" maxFractionDigits="2"/></td>
				</c:forEach>
				<c:forEach items="${ord.payWayPrice}" var="pay" >
					<td><fmt:formatNumber type="number" value="${pay.value}" pattern="0.00" maxFractionDigits="2"/></td>
				</c:forEach>
				<td><fmt:formatDate value="${ord.settleDate}" type="date" pattern="yyyy-MM-dd HH:mm" /></td>
				<td>${ord.userName}</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
</div>
	<div class="fixed-btn">
		<button class="btn btn-primary" id="uploadImg" onclick="addActivity()">新增活动</button>
		<button class="btn btn-primary" id="deletes" onclick="deletes();">批量删除</button>
	</div>
</body>
</html>