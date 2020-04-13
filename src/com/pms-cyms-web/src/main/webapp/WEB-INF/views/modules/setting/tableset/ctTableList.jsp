<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>房间资料</title>
<meta name="decorator" content="default" />
<style>
.build-edit {
	display: inline-block;
	width: 100px;
	height: 30px;
	line-height: 30px;
	text-align: center;
	background-color: #fff;
	border: 1px solid #ccc;
	margin-left: 5px;
}

.edit-icon {
	display: inline-block;
	width: 30px;
	height: 30px;
	line-height: 30px;
	text-align: center;
	background-color: #fff;
	border: 1px solid #ccc;
	margin-left: -5px;
}

.build-edit2 {
	display: inline-block;
	width: 103.5px;
	height: 30px;
	line-height: 30px;
	text-align: center;
	background-color: #fff;
	border: 1px solid #ccc;
	margin-left: 5px;
}

.edit-icon2 {
	display: inline-block;
	width: 30px;
	height: 30px;
	line-height: 30px;
	text-align: center;
	background-color: #fff;
	border: 1px solid #ccc;
	margin-left: -5px;
}

.build-edit:hover {
	background-color: #3daae9;
	cursor: pointer;
}

.build-edit2:hover {
	background-color: #3daae9;
	cursor: pointer;
}
</style>
<script type="text/javascript">
	var searchstoreid = "";
	var event_name = "";
	var searchbuilding = "";
	
		$(document).ready(function() {
			//alert("${htlRoom.searchStoreId}");
			//loadStore();
			 //事件名称保持唯一，这里直接用tabId
            event_name="ctTableLsit";
            //alert(event_name);
            //解绑事件
            top.$.unsubscribe(event_name);
            //注册事件，弹出页面需要刷新本页面，或者弹出页面回传数据用
            top.$.subscribe(event_name, function (e, data) {
                //data  可以通过这个对象来回传数据
                $("#searchForm").submit();
            });
            
            //新增经营区域
            $("#bnAddBuilding").click(function () {
            	//alert(event_name);
                top.$.jBox.open(
                    "iframe:${ctx}/setting/ctTable/toAddFloorForm?eventName="+event_name +"&storeId="+${selectStoreId},
                    "新增经营区域",
                    600,
                    300,
                    {
                        buttons: {},
                        loaded: function (h) {
                            $(".jbox-content", top.document).css("overflow-y", "hidden");
                        }
                    }
                );
            });
            
            //新增
            $("#addBtn").click(function () {
   
      			top.$.jBox.open(
                    "iframe:${ctx}/setting/ctTable/toAddCtTableForm?eventName="+event_name +"&storeId="+${selectStoreId} ,
                    "新增台号",
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
                    "iframe:${ctx}/setting/ctTable/toEditCtTableForm?eventName="+event_name+"&id="+id+"&storeId="+${selectStoreId},
                    "台号编辑",
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
    
            

          //加载分店
           
        
         loadSelect("companyCheckDiv","${ctx}/sys/userutils/getOfficeListByType",{typesJson:"['3','4','5']"},'${selectStoreId}','id','name'); 
          
    		
          
		});
		
		//查询
	function searchChange(storeId){
			if(storeId==''){
				
				storeId="pmscy";
			}
			self.location.href="${ctx}/setting/ctTable/getCtTableList?storeId1="+storeId;
			
		}
	
	function del(id){//删除桌台
 		jBox.confirm("是否删除？","删除提示", function (v) {
         if (v) {
			$.ajax({
				type: "post",
				dataType: "json",  
			    url: "${ctx}/setting/ctTable/deleteCtTable?id="+id,
			    success: function (result) {
			    	if(result.retCode=="999999"){
			    		$.jBox.info(result.retMsg);
			    		return false;
			    	}
					if(result.retCode=="000000"){
						window.location.reload();
			    	}
			    },
			    error: function (result, status) {
			    	alert("系统错误");
				}
			});
         }
   		}, {showScrolling: false, buttons: {'是': true, '否': false}});
		}
	//删除
	function delbuilding(id){
 		jBox.confirm("是否删除？","删除提示", function (v) {
         if (v) {
			$.ajax({
				type: "post",
				dataType: "json",  
			    url: "${ctx}/setting/ctTable/deleteFloor?floorId="+id,
			    success: function (result) {
			    	if(result.retCode=="999999"){
			    		$.jBox.info(result.retMsg);
			    		return false;
			    	}
					if(result.retCode=="000000"){
						top.$.publish(
								"ctTableLsit", {
									testData : "hello"
								});
			    	}
					if(result.retCode=="111111"){
			    		$.jBox.info("该区域已有桌台，不允许删除!");
			    		return false;
			    	}
			    },
			    error: function (result, status) {
			    	alert("系统错误");
				}
			});
         }
   		}, {showScrolling: false, buttons: {'是': true, '否': false}});
	}
	
	//编辑经营区域
	function upbuilding(key){
		 top.$.jBox.open(
                    "iframe:${ctx}/setting/ctTable/toEditFloorForm?eventName="+event_name+"&storeId="+${selectStoreId}+"&floorKey="+key,
                    "编辑经营区域",
                    600,
                    300,
                    {
                        buttons: {},
                        loaded: function (h) {
                            $(".jbox-content", top.document).css("overflow-y", "hidden");
                        }
                    }
                );
			
	}
	function checkNum(){
		var posPattern = /^\d+$/;
		var normalNum = $("#normalNum").val();
		if(normalNum!=""&&!posPattern.test(normalNum)){
			
			$.jBox.alert("位数请输入正整数！");
			$("#normalNum").val("");
			return;
		}
		
	}	
	
		
	</script>
	<style>
		.dropdown-menu>li>a{
			padding:3px 20px;
		}
		.input-medium6{width:135px;}
	</style>
</head>
<body>

	<form:form id="searchForm" action="${ctx}/setting/ctTable/" method="post" class="breadcrumb form-search">
		<ul class="ul-form">
			<li><label>餐厅：</label>
			
		 	 <select   id="companyCheckDiv" class="input-medium6"  onchange="searchChange(this.options[this.options.selectedIndex].value)">
			 
			 </select> </li> 
		</ul>

		<ul class="ul-form" style="overflow: inherit;display:inline-block;">
			<li><label>经营区域：</label></li>
			<input type="hidden" id="storeId" name="storeId" value="${selectStoreId}">
			<c:forEach items="${foorlList}" var="foorlList">
			<input type="hidden" id="floorStoreId" value="${foorlList.storeId}">
				
				<li class="dropdown"><span class="build-edit" id="${foorlList.paramKey}">${foorlList.name}</span>
				<shiro:hasPermission name="table:ctTable:edit">
				
				<a class="edit-icon dropdown-toggle" data-toggle="dropdown"><i class="icon-pencil"></i></a>
					<ul class="dropdown-menu" style="min-width: 80px; width: 80px; left: 100px">
						
						<li><a  onclick="upbuilding('${foorlList.paramKey}')"><i class="icon-pencil"></i>&nbsp; 修改</a></li>
						
						<li><a  onclick="delbuilding('${foorlList.id}')"><i class="icon-remove"></i>&nbsp; 删除</a></li>
					</ul>
				</shiro:hasPermission>
				</li>
			</c:forEach>
			   <shiro:hasPermission name="table:ctTable:edit">
				<li class="btns"><button id="bnAddBuilding" type="button" class="btn btn-small btn-primary">+</button></li>
			</shiro:hasPermission>
		</ul>
		<hr />
	<ul class="ul-form" id="ulsearch" style="overflow:visible">
			<li><label>经营区域：</label> 
			<select id="building" name="building"class="input-medium6">
					<option value="">--请选择经营区域--</option>
					<c:forEach items="${foorlList}" var="foorlList">
						<option value="${foorlList.paramKey}" <%-- <c:if test="${roomtype.paramKey==htlRoom.roomType}">selected="selected"</c:if> --%> >${foorlList.name}</option>

					</c:forEach>
			</select></li>
			<li><label>台位类型：</label> 
			<select id="typeId"  name="typeId"class="input-medium6">
					<option value="">--请选择台型--</option>
					<c:forEach items="${ctTableTypeList}" var="ctTableTypeList">
						<option value="${ctTableTypeList.id}" >${ctTableTypeList.name}</option>

					</c:forEach>
			</select></li>
			<li><label>标准位数：</label> 
			<input type="text" id="normalNum" name="normalNum" htmlEscape="false" maxlength="11" class="input-medium6" onblur="checkNum()" /></li>
			
			<li><label>台位名称：</label> 
			<input type="text" id="name" name="name" htmlEscape="false" maxlength="11" class="input-medium6"  /></li>
			
			<li class="btns"><button id="btnSubmit" class="btn btn-primary"
				type="submit" >查询</button> </li>
			 <li class="clearfix"></li> 
		</ul>

	</form:form>
	<table id="contentTable"class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				
				<th>序号</th>
				<th>经营区域</th>
				<th>台位类型</th>
				<th>台位编号</th>
				<th>台位名称</th>
				<th>标准位数</th>
				<th>最大位数</th>
				<th>最小位数</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${ctTableServiceList}" var="ctTableServiceList">
				<tr>
					
					<%-- <td>${htlRoom.storeName}</td> --%>
					<td>${ctTableServiceList.id}</td>
					<td>${ctTableServiceList.floor}</td>
					<td>${ctTableServiceList.typeId}</td>
					<td>${ctTableServiceList.no}</td>
					<td>${ctTableServiceList.name}</td>
					<td>${ctTableServiceList.normalNum}</td>
					<td>${ctTableServiceList.maxNum}</td>
					<td>${ctTableServiceList.minNum}</td>
					<td>
					<shiro:hasPermission name="table:ctTable:edit">
					<a class="update" data-id="${ctTableServiceList.id}">修改</a>
					<a onclick="del(${ctTableServiceList.id})">删除</a>
					</shiro:hasPermission>	
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<shiro:hasPermission name="table:ctTable:edit">
	<div class="fixed-btn" ><input type="button" id="addBtn" class="btn btn-primary"  value="新增桌号"/></div>
	</shiro:hasPermission>
</body>
</html>