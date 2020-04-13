<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>开台</title>
    <meta name="decorator" content="default"/>
    <script type="text/javascript">
    var reserveId='${ordUnionReserve.id}';
    	$(document).ready(function(){
    		top.$.unsubscribe("checkIn");
    	    //注册事件，弹出页面需要刷新本页面，或者弹出页面回传数据用
    	    top.$.subscribe("checkIn", function (e, data) {
    	        if (data.id != null) {
    	        	$("#thirdPartName").val("");
    	        	$("#thirdPartName").val(data.name);
    	        	$("#thirdPartId").val(data.id);
    	    		$("#thirdPartType").val(data.type);
    	        }
    	    });
    		//加载业务人员
			loadSelect("salesman","${ctx}/sys/userutils/getSalesmanList",{},'','id','name');
			//加载餐台
			loadSelect("tableNo","${ctx}/setting/ctTable/getTablesByStoreId",{storeId:'${param.storeId}',status:'${status}'},'${param.tableId}','id','no');
			//开台
			$("#submitBtn").click(function(){
				submitBtn();
			});
			document.getElementById("useNum").focus();
			if (reserveId != null && reserveId != "") {
				var ele = document.getElementById("remarks");
				ele.value = ele.value + "----预定开台，预定单号："+reserveId;
			}
			//初始化渠道
			sourceChange();
    	});
    	
    	//修改客源
    	function sourceChange(){
    		//取消绑定事件
    		$("#thirdPartName").unbind("click");
    		$("#thirdPartName").removeAttr("readonly");
    		$("#thirdPartName").val("");
    		$("#thirdPartId").val("");
    		$("#thirdPartName").val("");
    		//1:获取渠道
    		$.ajax({
    	        url:"${ctx}/sys/sourceChannel/getChannelBySource",
    	        type: "post",
    	        dataType: "json",
    	        data: {
    	            "sourceId":$("#sourceId").val(),
    	            "channelId":$("#channelId").val()
    	        },
    	        success: function (result) {
    	        	$("#channelId").select2("val", ""); 
    	        	$("#channelId").empty();
    	        	for(var i=0;i<result.length;i++){
    	        		var htm="<option value='"+result[i].id+"' >"+result[i].name+"</option>";
    	        		$("#channelId").append(htm);
    	        	}
    	        	if(result.length>0){
    	        		$("#channelId").select2("val",result[0].id);
    	        	}
    	        		
    	        	if($("#sourceId option:selected").html()=="散客"){
    	        		$("#bcxx").css("display","none");
    	        	}else if ($("#sourceId option:selected").html()=="会员"){
    	        		$("#thirdPartName").attr("readonly","readonly");
    	        		$("#bcxx").css("display","");
    	        		$("#bcxxwz").html("<span class='notice'>*</span>会员信息：");
    	        		
    	        		$("#thirdPartName").bind("click",function(){
        	    			top.$.jBox.open(
       			               "iframe:${ctx}/member/member/getMemberListInit?storeId=${storeId}",
       			               "选择会员",
       			               1050,
       			               560,
       			               {
       			                   buttons: {},
       			                   loaded: function (h) {
       			                       $(".jbox-content", top.document).css("overflow-y", "hidden");
       			                   }
       			               }
        			        );
        					$("#thirdPartName").attr("readonly","readonly");	
        				});
    	        	}else if ($("#sourceId option:selected").html()=="协议单位"){
    	        		$("#thirdPartName").attr("readonly","readonly");	
    	        		$("#bcxx").css("display","");
    	        		$("#bcxxwz").html("<span class='notice'>*</span>协议单位：");
    	        		
    	        		$("#thirdPartName").bind("click",function(){
        	    			top.$.jBox.open(
       			               "iframe:${ctx}/member/group/getGroupListInit?storeId=${storeId}",
       			               "选择协议单位",
       			               1050,
       			               560,
       			               {
       			                   buttons: {},
       			                   loaded: function (h) {
       			                       $(".jbox-content", top.document).css("overflow-y", "hidden");
       			                   }
       			               }
        			        );
        				});
    	        	}else{
    	        		$("#bcxx").css("display","");
    	        		$("#bcxxwz").html("<span class='notice'>*</span>第三方单号：");
    	        	}
    	   		}
    		});
    	}
    	
    	//提交
    	function submitBtn(){
    		if (!$("#inputForm").valid()){
				$("#name").focus();
		        return;
		    }
    		var channelId = $("#channelId").val();
    		var sourceId = $("#sourceId").val();
    		var thirdPartId = $("#thirdPartId").val();
    		var thirdPartType = $("#thirdPartType").val();
			if($("#sourceId option:selected").html()!="散客"&&(thirdPartId==""||thirdPartType=="")){
				layer.alert("请输入客源信息！");
				return;
    		}
			var thirdPartName = $("#thirdPartName").val();
    		var memberName = $("#memberName").val();
    		var memberPhone = $("#memberPhone").val();
    		var useType = $("#useType").val();
    		var useNum = $("#useNum").val();
    		var salesman = $("#salesman").val();
    		var remarks = $("#remarks").val();
    		//表单
    		var params = {
   				storeId:'${storeId}',
   				tableId:'${tableId}',
   				channel:channelId,
   				source:sourceId,
   				thirdPartType:thirdPartType,
   				thirdPartId:thirdPartId,
   				thirdPartName:thirdPartName,
   				memberName:memberName,
   				memberPhone:memberPhone,
   				useType:useType,
   				useNum:useNum,
   				salesman:salesman,
   				remarks:remarks
    		}
			var params = {params:JSON.stringify(params)};
    		if (reserveId != '' && reserveId != null) {
    			var tableList =[];
    			var map ={
    					id:'${id}',
    					tableId:'${tableId}',
    					unionReserveId:reserveId,
    					tableType:'${tableType}',
    					description:remarks
    					};
    			tableList.push(map);
    			$.ajax({
    	            url:"${ctx}/reserve/reserveCheckIn",
    	            type: "post",
    	            dataType: "json",
    	            data: {
    	            	"unionReserveId":reserveId,
    	                "reserves":JSON.stringify(tableList)
    	            },
    	            success: function (result) {
    	            	if(result.retCode=="000000"){
    	            		layer.confirm("预订单转订单成功！", {
    							btn: ['确定'] 
    						}, function(){
    							top.$.publish("orderPartCheckForm",{testData:"hello"});
    							window.parent.jBox.close();
    						}, function(){
    							window.parent.jBox.close();
    						});
    	            	}else{
    	            		layer.alert(result.retMsg);
    	            	}
    	            }
    	        });
			}else {
				loadAjax("${ctx}/order/checkIn/checkInCommit",params,function(result){
					if(result.retCode=="000000"){
						top.$.publish("index",{roomList:result.ret});
				    	window.parent.jBox.close();
			    	}else{
			    		layer.alert(result.retMsg);
			    	}
				});
    		}
			
    	}
    </script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="" action="" method="post" class="form-horizontal">
		<div class="row">
		    <div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>台号：</label>
		            <div class="controls">
		                <select id="tableNo" >
						</select>
		            </div>
		        </div>
		    </div>
		    <div class="span">
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>用餐人数：</label>
		            <div class="controls">
		                <input type="text" id="useNum" name="useNum" maxlength="2" class="required digits" value="${(ordUnionReserve.useNumber==0?'':ordUnionReserve.useNumber) }";>
		            </div>
		        </div>
		    </div>
		    <div class="span">
		        <div class="control-group">
		            <label class="control-label-xs">联系人：</label>
		            <div class="controls">
		                <input type="text" id="memberName" name="memberName" value="${ordUnionReserve.name }";>
		            </div>
		        </div>
		    </div>
		    <div class="span">
		        <div class="control-group">
		            <label class="control-label-xs">联系方式：</label>
		            <div class="controls">
		                <input type="text" id="memberPhone" name="memberPhone" value="${ordUnionReserve.phone }";>
		            </div>
		        </div>
		    </div>
		</div>
		
		<div class="row">
		    <div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>客源：</label>
		            <div class="controls">
		            	<select id="sourceId" onchange="sourceChange()">
			                <c:forEach items="${sourceList}" var="source">
								<option value="${source.paramKey}" sourceName="${source.name}" <c:if test="${ordUnionReserve.source==source.paramKey}">selected="selected"</c:if>>${source.name}</option>
							</c:forEach>
						</select>	
		            </div>
		        </div>
		    </div>
		    
		    <div class="span" style="display:none">
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>渠道：</label>
		            <div class="controls"> 
						<select id="channelId">
						</select>
					</div>
		        </div>
		    </div>
		    
		    <div class="span" id="bcxx" style="display: none;">
		        <div class="control-group">
		            <label class="control-label-xs" id="bcxxwz" >补充信息：</label>
		            <div class="controls" style="position:relative;">
						<input type="text" id="thirdPartName" style="cursor:pointer;" value="${ordUnionReserve.thirdPartId}"/>
						<i class="icon-search" style="position:absolute;right:18px;top:9px;"></i>
						<input type="hidden" id="thirdPartId"  value="${ordUnionReserve.thirdPartId}"/>
						<input type="hidden" id="thirdPartType"  />
					</div>
		        </div>
			</div>
			
		    <div class="span">
		        <div class="control-group">
		            <label class="control-label-xs">业务员：</label>
		            <div class="controls">
		            	<select id="salesman" name="salsman" class="select-medium4" value="${ordUnionReserve.salesPerson}">
						</select>
		            </div>
		        </div>
		    </div>
		    
		    <div class="span">
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>用餐类别：</label>
		            <div class="controls">
		                <select id="useType">
		                	<option value="st" <c:if test="${ordUnionReserve.useType=='st'}">selected="selected"</c:if>>散台</option>
		                	<option value="yx" <c:if test="${ordUnionReserve.useType=='yx'}">selected="selected"</c:if>>宴席</option>
		                	<option value="hy" <c:if test="${ordUnionReserve.useType=='hy'}">selected="selected"</c:if>>会议</option>
		                </select>
		            </div>
		        </div>
		    </div>
		</div>
		<div class="row">
		    <div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs">备注：</label>
		            <div class="controls">
		                <textarea id="remarks" name="remarks" rows="5" maxlength="255" class="input-xxlarge" >${ordUnionReserve.remarks}</textarea>
		            </div>
		        </div>
		    </div>
		</div>
		
		<div class="fixed-btn-right">
			<input type="button" id="submitBtn" class="btn btn-primary" <shiro:lacksPermission name="index:order:checkIn">disabled</shiro:lacksPermission> value="保 存"/>&nbsp;
		</div>
	</form:form>
</body>
</html>