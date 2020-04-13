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
	       $("#addBigType").click(function(){
	    	   var storeId='${storeId}';
		    	if (storeId=='pmscy') {
		    		layer.alert("请先选择分店");
				}else {
					top.$.jBox.open(
			            	"iframe:${ctx}/marcebter/ctfoodSpecial/form?storeId="+storeId,
			                "设置特价菜",
			                1000,
			                $(top.document).height()-180,
			                {
			                    buttons:{},
			                    loaded:function(h){
			                        $(".jbox-content", top.document).css("overflow-y","hidden");
			                    }
			                }
			            );
				}
	        });
	       //加载分店
	         loadSelect("storeId","${ctx}/sys/userutils/getOfficeListByType",{typesJson:"['3','4','5']"},'${storeId}','id','name'); 
	   });
		
		function deleteches(obj){
			top.$.jBox.confirm("确定要保存该活动吗？", "提示", function (v, h, f) {
				 if (v == "ok"){
					$.ajax({
						url:"${ctx}/marcebter/ctfoodSpecial/delete",
						type:"post",
						dataType:"json",
						data:{
							id:obj
						},
						success:function(result){
							if(result.retCode=="000000"){
								 layer.alert("删除成功！");
				        		 window.location.reload();
			                }else{
			              	  layer.alert(result.retMsg);
			                }
						}
					});
				 }
				return true;
			 });	
		}
		
		function deletebatches(){
			var ctfid="";
			$(".weeks:checked").each(function(){
				var a=$(this).val();
				ctfid=ctfid+a+",";
			});
			ctfid=ctfid.substring (0,ctfid.length-1);
			/* loadAjax("${ctx}/marcebter/ctfoodSpecial/delete",ctfid,function(result){
				if(result.retCode=="000000"){
					 layer.alert("删除成功！");
	        		 window.location.reload();
                }else{
              	  layer.alert(result.retMsg);
                }
			}); */
			if(ctfid==null||ctfid==""){
				layer.alert("请选择要删除的数据");
	     		return;
			}
			top.$.jBox.confirm("确定要保存该活动吗？", "提示", function (v, h, f) {
				 if (v == "ok"){
					$.ajax({
						url:"${ctx}/marcebter/ctfoodSpecial/delete",
						type:"post",
						dataType:"json",
						data:{
							ctfid:ctfid
						},
						success:function(result){
							if(result.retCode=="000000"){
								 layer.alert("删除成功！");
				        		 window.location.reload();
			                }else{
			              	  layer.alert(result.retMsg);
			                }
						}
					});
				 }
				return true;
			});			
		}
		
	 	function ctfoodUpdate(obj){
	 		top.$.jBox.open(
	 			"iframe:${ctx}/marcebter/ctfoodSpecial/form?storeId=${storeId}&id=" + obj,
	             "设置特价菜",
	             1000,
	             $(top.document).height()-180,
	             {
	 				 buttons:{},
	                    loaded:function(h){
	                        $(".jbox-content", top.document).css("overflow-y","hidden");
	                    }
	             }
	 		);
	 	}
		
      $(function(){
      	var contentTableTbodyHeight = $('#contentTableTbody tr td:first-child').height();
      	var contentTableTbodyWidth = $('#contentTableTbody tr td:first-child').width();
      	$(".labels").css({
      		'height':contentTableTbodyHeight,
      		'width':contentTableTbodyWidth
      	});
      })
      
      //查询
		function searchChange(storeId){
			if(storeId==''){
				storeId="pmscy";
			}
			self.location.href="${ctx}/marcebter/ctfoodSpecial/List?storeId="+storeId;
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
			<li><label>餐厅：</label>
			
		 	 <select   id="storeId" class="input-medium6"  onchange="searchChange(this.options[this.options.selectedIndex].value)">
			 
			 </select> </li> 
		</ul>

	</form:form>	
	<div style="margin-top:20px;">
	<table id="treeTable" class="table table-striped table-bordered table-condensed">
		<thead>
		<tr>
		<th>选择</th><th>菜品编号</th><th>菜品名称</th><th>单位</th><th>原价</th><th>特价</th>
		<th>开始时间</th><th>结束时间</th><th>单桌限购</th><th>日库存</th><th>允许单点</th>
		<th>允许优惠卷</th><th>允许折扣</th><th>操作</th>
		</tr>
		</thead>
		<tbody id="contentTableTbody">
			<c:forEach items="${list }" var="cftlist">
			
				<tr>
				<td>
				<label class="labels"></label>
				<input type="checkbox" value="${cftlist.id }" class="weeks">
				<%-- <input name="id" class="id" value="${cftlist.id }" type="text" htmlescape="false" maxlength="64" style="display: none;"> --%>
				</td>
				<td>${cftlist.ordernumber }</td>
				<td>${cftlist.nameDishes }</td>
				<td>${cftlist.units }</td>
				<td>${cftlist.oriPrice }</td>
				<td>${cftlist.price }</td>
				<td>${cftlist.effectiveDate }</td>
				<td>${cftlist.expireDate }</td>
				<td>${cftlist.maxBuyCount }</td>
				<td>${cftlist.maxSellCount }</td>
				
				<c:if test="${cftlist.isSinglePoint==1}">
				<td>允许</td>
				</c:if>
				<c:if test="${cftlist.isSinglePoint==0}">
				<td>不允许</td>
				</c:if>
				<c:if test="${cftlist.isCoupon==1}">
				<td>允许</td>
				</c:if>
				<c:if test="${cftlist.isCoupon==0}">
				<td>不允许</td>
				</c:if>
				<c:if test="${cftlist.isDiscount==1}">
				<td>允许</td>
				</c:if>
				<c:if test="${cftlist.isDiscount==0}">
				<td>不允许</td>
				</c:if>
				<td>
			     <a class="update" onclick="ctfoodUpdate('${cftlist.id}')" data-id="${cftlist.id}">修改</a>
			     <a class="particulars" onclick="deleteches('${cftlist.id}')" data-id="${cftlist.id}">删除</a>
			    </td>
			</tr>
			</c:forEach>
		</tbody>
	</table>
	</div>
	<div class="fixed-btn">
		<button
			class="btn btn-primary" type="button" id="addBigType" >新增特价</button>
		<button
			class="btn btn-primary" type="button" onclick="deletebatches()" id="addLittleType">批量删除</button>
	</div>
</body>
</html>