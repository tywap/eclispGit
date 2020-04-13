<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>菜品打印机</title>
<meta name="decorator" content="default" />
<style>
/* .build-edit {
	display: inline-block;
	width: 100px;
	height: 30px;
	line-height: 30px;
	text-align: center;
	background-color: #fff;
	border: 1px solid #ccc;
	margin-left: 5px;
} */

/* .edit-icon {
	display: inline-block;
	width: 30px;
	height: 30px;
	line-height: 30px;
	text-align: center;
	background-color: #fff;
	border: 1px solid #ccc;
	margin-left: -5px;
} */

/* .build-edit2 {
	display: inline-block;
	width: 103.5px;
	height: 30px;
	line-height: 30px;
	text-align: center;
	background-color: #fff;
	border: 1px solid #ccc;
	margin-left: 5px;
} */

/* .edit-icon2 {
	display: inline-block;
	width: 30px;
	height: 30px;
	line-height: 30px;
	text-align: center;
	background-color: #fff;
	border: 1px solid #ccc;
	margin-left: -5px;
} */
/* 
.build-edit:hover {
	background-color: #3daae9;
	cursor: pointer;
}

.build-edit2:hover {
	background-color: #3daae9;
	cursor: pointer;
} */
</style>
<script type="text/javascript">
	/* var searchstoreid = "";
	var event_name = "";
	var searchbuilding = ""; */
	
		$(document).ready(function() {
			//alert("${htlRoom.searchStoreId}");
			//loadStore();
			 //事件名称保持唯一，这里直接用tabId
            event_name="sysBusiConfigList";
            //alert(event_name);
            //解绑事件
            top.$.unsubscribe(event_name);
            //注册事件，弹出页面需要刷新本页面，或者弹出页面回传数据用
            top.$.subscribe(event_name, function (e, data) {
                //data  可以通过这个对象来回传数据
                $("#searchForm").submit();
                window.location.reload();
            });
            //新增
            $("#addBtn").click(function () {
   				var selectStoreId='${selectStoreId}';
   				if(selectStoreId=="pmscy"){
   					$.jBox.alert("请选择餐厅 ！");
   					return;
   				}
      			top.$.jBox.open(
                    "iframe:${ctx}/sys/sysBusiConfig/sysbusiForm?storeId="+selectStoreId,
                    "新增打印机",
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
			self.location.href="${ctx}/sys/sysBusiConfig/getCtTableList?storeId1="+storeId;
			
		}
	function sysprinterUpdate(obj){
		top.$.jBox.open(
                "iframe:${ctx}/sys/sysBusiConfig/sysbusiForm?id="+obj,
                "修改打印机",
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
	function sysprinterdelete(id){
	/* 	loadAjax("${ctx}/sys/sysBusiConfig/printerdelete",
				id, function(result) {
					if (result.retCode == "000000") {
						$.jBox.alert(result.retMsg);
					} else {
						$.jBox.alert(result.retMsg);
					}
				});
		 */
		$.ajax({
			type: "post",
			dataType: "json",  
		    url: "${ctx}/sys/sysBusiConfig/printerdelete",
		    data: {
		    	id:id
            },
		    success: function (result) {
		    	if(result.retCode=="999999"){
		    		$.jBox.info(result.retMsg);
		    		return false;
		    	}
				if(result.retCode=="000000"){
					layer.confirm("删除成功！", {
	        			  btn: ['确定']
	        			}, function(){
	        				top.$.publish("sysBusiConfigList", {
	    						event_name : "sysBusiConfigList"
	    					});
	        			});
					
					
		    	}
		    },
		    error: function (result, status) {
		    	$.jBox.info("系统错误");
			}
		});
	}
	/* function del(id){//删除桌台
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
						top.$.publish(
								"ctTableLsit", {
									testData : "hello"
								});
			    	}
			    },
			    error: function (result, status) {
			    	alert("系统错误");
				}
			});
         }
   		}, {showScrolling: false, buttons: {'是': true, '否': false}});
		} */
	
		
	</script>
	<style>
		.dropdown-menu>li>a{
			padding:3px 20px;
		}
		.input-medium6{width:135px;}
	</style>
</head>
<body>

	<form:form id="searchForm" action="${ctx}/sys/sysBusiConfig/branchprinterList" method="post" class="breadcrumb form-search">
		<ul class="ul-form">
			<li><label>餐厅：</label>
			
		 	 <select   id="companyCheckDiv" class="input-medium6"  onchange="searchChange(this.options[this.options.selectedIndex].value)">
			 
			 </select> </li> 
		</ul>
	</form:form>
	<table id="contentTable"class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				
				<th>打印机名称</th>
				<th>ip地址</th>
				<th>端口号</th>
				<th>备注</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${sysbusilist }" var="sysbusilist">
				<tr>
					<td>${sysbusilist.paramKey }</td>
					<td>${sysbusilist.name }</td>
					<td>${sysbusilist.paramValue }</td>
					<td>${sysbusilist.remarks }</td>
					<td>
			    	<a class="update" onclick="sysprinterUpdate('${sysbusilist.id}')" data-id="${sysbusilist.id}">修改</a>
			     	<a class="printerdelete" onclick="sysprinterdelete('${sysbusilist.id}')" data-id="${sysbusilist.id}">删除</a>
			    	</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<div class="fixed-btn"><input type="button" id="addBtn" class="btn btn-primary"  value="新增打印机"/></div>
</body>
</html>