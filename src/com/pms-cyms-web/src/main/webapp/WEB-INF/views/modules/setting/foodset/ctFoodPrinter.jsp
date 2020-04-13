<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>菜品打印机</title>
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

		$(document).ready(function() {
			//alert("${htlRoom.searchStoreId}");
			//loadStore();
			 //事件名称保持唯一，这里直接用tabId
            event_name="ctFoodPrinter";
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
            	obj = document.getElementsByName("weeks");
     		    check_val = [];
     		    for(k in obj){
     		        if(obj[k].checked)
     		            check_val.push(obj[k].value);
     		    }
     		   if (check_val != "") {
     			  top.$.jBox.open(
     	                    "iframe:${ctx}/setting/ctFoodPrinter/foodPrinterFron?foodIdList="+check_val +"&storeId="+${selectStoreId} ,
     	                    "配置打印机",
     	                    800,
     	                    $(top.document).height() - 180,
     	                    {
     	                        buttons: {},
     	                        loaded: function (h) {
     	                            $(".jbox-content", top.document).css("overflow-y", "hidden");
     	                        }
     	                    }
     	                );
				}else {
					layer.alert("请选择需要配置的菜品！");
				}
            });
            
            //配置菜品
            $("#addFoodPrice").click(function () {
            	obj = document.getElementsByName("weeks");
     		    check_val = [];
     		    for(k in obj){
     		        if(obj[k].checked)
     		            check_val.push(obj[k].value);
     		    }
     		   if (check_val != "") {
     			  top.$.jBox.open(
     	                    "iframe:${ctx}/setting/ctFoodPrinter/foodPriceFrom?foodIdList="+check_val +"&storeId=${selectStoreId}" ,
     	                    "配置菜品价格",
     	                    800,
     	                    $(top.document).height() - 180,
     	                    {
     	                        buttons: {},
     	                        loaded: function (h) {
     	                            $(".jbox-content", top.document).css("overflow-y", "hidden");
     	                        }
     	                    }
     	                );
				}else {
					layer.alert("请选择需要配置的菜品！");
				}
            });
            
            //修改
            $("#contentTable a.update").click(function (e) {
                var id = $(this).data("id");
                top.$.jBox.open(
                    "iframe:${ctx}/setting/ctFoodPrinter/foodPrinterFron?id="+id+"&storeId="+${selectStoreId}+"&foodIdList=",
                    "编辑打印机配置",
                    800,
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
         loadSelect("storeId","${ctx}/sys/userutils/getOfficeListByType",{typesJson:"['3','4','5']"},'${selectStoreId}','id','name'); 
          
		});
		
		function selectweeks() {
			if ($("#weeksall").attr("checked") == "checked")
				$(".weeks").attr("checked", "checked");
			else
				$(".weeks").removeAttr("checked");
		}
		//查询
		function searchChange(storeId){
			if(storeId==''){
				storeId="pmscy";
			}
			self.location.href="${ctx}/setting/ctFoodPrinter/StoreFoodList?storeId="+storeId;
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

	<form:form id="searchForm" action="${ctx}/setting/ctFoodPrinter/StoreFoodList" method="post" class="breadcrumb form-search">
		<ul class="ul-form">
			<li><label>餐厅：</label>
			
		 	 <select   id="storeId" class="input-medium6"  onchange="searchChange(this.options[this.options.selectedIndex].value)">
			 
			 </select> </li> 
		</ul>

	</form:form>
	<table id="contentTable"class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th width="5%">选择<input type="checkbox" value="" id="weeksall"
							onclick="selectweeks()"/></th>
				<th width="20%">编号</th>
				<th width="20%">菜品名称</th>
				<th width="10%">菜品价格</th>
				<th width="35%">打印机</th>
				<th width="10%">操作</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${storeFoodList}" var="food">
				<tr>
					<td><label class="labels"> <input type="checkbox"
								class="weeks" value="${food.foodStoreId}" id="weeks_${food.foodStoreId}"  name="weeks"></label></td>
					<td>${food.id}</td>
					<td>${food.name}</td>
					<td>${food.storePrice}</td>
					<td>${food.printerName}</td>
					<td>
					<a class="update" data-id="${food.foodStoreId}">修改</a>
					</a>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<div class="fixed-btn"><input type="button" id="addBtn" class="btn btn-primary"  value="配置打印机"/>
	<input type="button" id="addFoodPrice" class="btn btn-primary"  value="配置菜品价格"/>
	</div>
</body>
</html>