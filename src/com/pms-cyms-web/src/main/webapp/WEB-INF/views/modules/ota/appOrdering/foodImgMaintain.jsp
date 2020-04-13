<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>菜品图片维护</title>
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

	        var i=0;
	        //全选
	        $("#imgSelectAll").on("click",function(){
	            if(i==0){
	                //把所有复选框选中
	                $(".weeks").prop("checked", true);
	                i=1;
	            }else{
	                $(".weeks").prop("checked", false);
	                i=0;
	            }
	            
	        });
			
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
		//上传
		function uploadImg() {
			top.$.jBox.open("iframe:${ctx}/ota/foodImgMaintain/foodImgUpload?mulFlag=1?eventName="+eventName, "菜品图片上传", 1000, 600, {
				buttons : {},
				loaded : function(h) {
					$(".jbox-content", top.document).css("overflow-y", "hidden");
				}
			});
		}; 
		//修改
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
	<form:form id="searchForm" modelAttribute="ota" action="${ctx}/ota/foodImgMaintain/list" method="post" class="breadcrumb form-search ">
		<ul class="ul-form">
			<%-- <li>
			 	<label>分店：</label>
				<select id="storeId" name="storeId" class="select2 select-medium6" style="width: 110px;" onchange="searchChange(this)">
					<c:if test="${storeName == null}">
					<option>--请选择--</option>
					</c:if>
					<c:if test="${storeName.storeName != ''}">
					<option>${storeName.storeName }</option>
					</c:if>
				</select>
			</li>  --%>
			<li>
			<input style="width: 230px;" type="text" name="name" value="${param.name}" id="name" htmlEscape="false" maxlength="80" class="input-medium6" placeholder="按菜品名称搜索图片"/>
			</li>
			<li class="btns">
				<button type="submit" id="btnSubmit" class="btn btn-primary" >查询</button>
			</li>
		</ul>
	</form:form>
	<button id="imgSelectAll" class="btn btn-primary" style="position: absolute; left: 350px;  top: 15px;" >全选</button>
	<div id="foodImgList">	
		<c:forEach items="${ctFoodCfgList}" var="foodimg" >
			<span style="margin:10px;display:inline-block;width:160px;height:180px;position: relative;">
			<img style="float:left;width:160px;height:160px;" src="${foodimg.value }" title="${foodimg.key }"/>
			<font style='float:left;width:160px;height:20px;text-align:center;'>${foodimg.key }<a class="update" onclick="update('${foodimg.id }','${foodimg.key }')"><i class="icon icon-edit" style="float:right; margin-top: 8px;"></i></a></font>
			<i class='icon-trash' style='float:right;z-index:999;position:absolute;top:0px;right:0px;background:#333;color:#fff;padding:5px;' onclick='this.parentNode.parentNode.removeChild(this.parentNode);'></i>
			<i><input id="${foodimg.id }" class="weeks" type="checkbox" name="item" style="position: absolute;  left: 1px;  top: 5px;"></i>
			</span>
		</c:forEach>
	</div>
	<div class="fixed-btn">
		<button class="btn btn-primary" id="uploadImg" onclick="uploadImg();">上传图片</button>
		<button class="btn btn-primary" id="deletes" onclick="deletes();">批量删除</button>
	</div>
</body>
</html>