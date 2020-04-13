<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>菜品类别设置</title>
	<meta name="decorator" content="default"/>
	<%@include file="/WEB-INF/views/include/treetable.jsp" %>
	<style>
	.remarks{
	width: 500px;
	font-size:12px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    display: block;
    
    }
	</style>
	<script type="text/javascript">
		//事件名称保持唯一，这里直接用tabId
		var eventName="dishesCategory";
		var busi= ${busitils}
		$(document).ready(function() {
		    //解绑事件
		    top.$.unsubscribe(eventName);
		    var eventName = "dishesSettingForm";
		    //注册事件，弹出页面需要刷新本页面，或者弹出页面回传数据用
		    top.$.subscribe(eventName, function (e, data) {
	        //data  可以通过这个对象来回传数据
	        	window.location.reload();
		    });
	        //新增特价
	       //加载分店
	         loadSelect("storeId","${ctx}/sys/userutils/getOfficeListByType",{typesJson:"['3','4','5']"},'${selectStoreId}','id','name'); 
	   });
		
		//查询
		 function searchChange(storeId){
				if(storeId==''){
					storeId="pmscy";
				}
				self.location.href="${ctx}/ota/appCfg/list?storeId1="+storeId;
				
			}
		
		var payCount=0;
		function addPay(){
			payCount+=1;
			var htm='<select id="menus" name="deUl_'+payCount+'" class="input-medium6 menus">';
				htm+='<option>--请选择--</option>';
				for (var i = 0; i < busi.length; i++) {
					 htm+='<option value="'+busi[i].name+'"> '+busi[i].name+'</option>';
				}
				htm+='</select>';
				htm+='<input class="btn btn-primary" type="button" name="de_'+payCount+'"onclick="delPay('+payCount+')" value="X"/>';
				$("#dynamicWrapper").append(htm);
		}
		function delPay(no)
		{
			$("select[name='deUl_"+no+"']").remove();
			$("input[name='de_"+no+"']").remove();
		}
		function save(){
			var status;//启动APP点餐模块
			var map=[];
			$("input[type='checkbox']:checked").each(function(){
				status=$(this).val();
			 });
			if(status==null){
				status=0;
			}
			var standbyMinute=$("#standbyMinute").val();//设置待机时长
			var samel={};
			samel["status"]=status;
			samel["standbyMinute"]=standbyMinute;
			var menus="";
			$(".menus").each(function(){
				menus=menus+$(this).val()+",";
				
			 });
			menus = menus.substring(0, menus.length - 1);
			samel["menus"]=menus;
			
			var printer=$('input[name="printer"]:checked').val(); 
			samel["printer"]=printer;
			var printername=$('input[name="printer"]:checked').attr("data-id"); 
			samel["printername"]=printername;
			var storeId=$("#storeId").val();
			samel["storeId"]=storeId;
			map.push(samel);
			$.ajax({
	    		type: "post",
				dataType: "json",  
				url: "${ctx}/ota/appCfg/save",
				data:{
					map:JSON.stringify(map)
				},
				success: function (result) {	
				if(result.retCode==("000000")){
					/* if(result.retCode==("000000")){
			       		$.jBox.alert("保存成功!");
			    	} */
			    	
				   }
				}
			});
			/* alert(map); */
		}
	</script>
	<style>
		#contentTableTbody tr:hover{
			cursor:pointer;
		}
		.labels{
			position:absolute;
			width:100%;
		}
		.edit{
			position:relative;
			z-idnex:99;
		}
	</style>
</head>
<body>
<form:form id="searchForm" action="${ctx}/marcebter/ctfoodSpecial/List" method="post" class="breadcrumb form-search">
		<ul class="ul-form">
			<li><label>酒店：</label>
			
		 	 <select id="storeId" class="input-medium6" onchange="searchChange(this.options[this.options.selectedIndex].value)">
			 
			 </select> </li> 
		</ul>
		<hr />
		<div class="row">
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><input id="status" name="Fruit" type="checkbox" value="1" /> 启用APP点餐模块：</label>
				</div>
			</div>
		</div>	
		<div class="row">
			<div class="span">
				<div class="control-group">
					<label>设置待机时长：
						<input name="Fruit" id="standbyMinute" type="text" value="" style="width: 100px" />
						分钟：
					</label>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="span">
				<div class="control-group">
					<label id="dynamicWrapper">自定义底部菜单：
						<select id="menus" name="menus" class="input-medium6 menus">
			 				<!-- <option>点餐台</option> -->
			 				<option value=''>--请选择--</option>
		                    <c:forEach items="${busitils}" var="var">
		                    	<option value="${var.name}"> ${var.name}</option>
		                    </c:forEach>
						</select>
					</label>
					<input class="btn btn-primary" type="button" onclick="addPay()" value="+"/>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="span">
				<div class="control-group">
					<label>设置账单打印机：
					</label>
					<c:forEach items="${sysbusilist }" var="sysbusilist">
						<label name="printerName">
						<input name="printer" type="radio" value="${sysbusilist.id}" data-id="${sysbusilist.paramKey }"/>
							<label>${sysbusilist.paramKey }</label>
						<label>
					</c:forEach>
				</div>
			</div>
		</div>
</form:form>	
	<div class="fixed-btn">
		<button
			class="btn btn-primary" type="button" id="addBigType" onclick="save()">保存</button>
		<!-- <button
			class="btn btn-primary" type="button" onclick="deletebatches()" id="addLittleType">批量删除</button> -->
	</div>
</body>
</html>