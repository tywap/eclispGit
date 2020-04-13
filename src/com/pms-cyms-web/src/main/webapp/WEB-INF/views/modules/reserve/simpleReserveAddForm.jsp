<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>选台预订</title>
    <meta name="decorator" content="default"/>
    <script type="text/javascript">
  		var num=0;
  		var pageName="reserve";
  		var eventName = '${param.eventName}';
    	$(document).ready(function(){
    		top.$.unsubscribe("reserve");
    	    //注册事件，弹出页面需要刷新本页面，或者弹出页面回传数据用
    	    top.$.subscribe("checkIn", function (e, data) {
    	        if (data.id != null) {
    	        	$("#thirdPartName").val("");
    	        	$("#thirdPartName").val(data.name);
    	        	$("#thirdPartId").val(data.id);
    	    		$("#thirdPartType").val(data.type);
    	        }
    	    });
    	    document.getElementById('useDate').value = new Date().Format("yyyy-MM-dd");
    		//加载业务人员
			loadSelect("salesman","${ctx}/sys/userutils/getSalesmanList",{},'','id','name');			
			//加载分店
	        loadSelect("companyCheckDiv","${ctx}/sys/userutils/getOfficeListByType",{typesJson:"['3','4','5']"},'${storeId}','id','name');
			//加载餐台
			loadSelect("tableNo","${ctx}/setting/ctTable/getTablesByStoreIdAndStatus",{storeId:'${storeId}'},'','id','no');     
    	});
    	
    	//查询
    	function searchChange(storeId){
   			if(storeId==''){
   				storeId="pmscy";
   			}
   			self.location.href="${ctx}/reserve/toSimpleAddReserveForm?storeId="+storeId;
   		}
    	
    	//修改客源
    	function sourceChange(){
    		var storeId = $('#companyCheckDiv').val();
    		if(storeId==""){
    			layer.alert("请选择餐厅！");
    		}
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
       			               "iframe:${ctx}/member/member/getMemberListInit",
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
       			               "iframe:${ctx}/member/group/getGroupListInit",
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
    	
        //保存预订信息
        function save(){
        	if (!$("#inputForm").valid()){
		        return;
		    }
         	var storeId = $('#storeId').val();
         	if (storeId =="") {
         		layer.alert("请选择餐厅！");
			}
         	var tableId = $('#tableNo').val();
         	var personCount= $('#personCount').val();
        	var name = $('#name').val();
        	var phone = $('#phone').val();
        	var useDate = $('#useDate').val();
        	var useLevel = $('#useLevel').val();
        	var source = $('#sourceId').val();
        	var thirdPartType = $('#thirdPartType').val();
        	var thirdPartId = $('#thirdPartId').val();
        	var salesPerson = $('#salsman').val();
        	var useType = $('#useType').val();
        	var remarks = $('#remarks').val();
    		var params = {
       				storeId:storeId,
       				name:name,
       				phone:phone,
       				useDate:useDate,
       				thirdPartType:thirdPartType,
       				thirdPartId:thirdPartId,
       				useLevel:useLevel,
       				source:source,
       				salesPerson:salesPerson,
       				useType:useType,
       				remarks:remarks
        		}
    		var param =JSON.stringify(params);
    		
    		//支付明细
			var obj = getPaymentFunds();
			var paymentFunds = obj.paymentFunds;
			var payAmount = obj.payTotalAmount;
			if(tableId==null||tableId==""){
				layer.alert("台号不能为空");
				return;
			}
			if(parseInt(payAmount) < 0){
				layer.alert("订金退款额度不允许超过原有订金额度！");
				return;
			}
        $.ajax({
                type: "post",
                dataType: "json",
                url: "${ctx}/reserve/saveSimpleReserve",
                async:false,
                data: {
                    "params":param,
                    "tableId":tableId,
                    "personCount":personCount,
                    "paymentFundJson":JSON.stringify(paymentFunds)
                },
                success: function (result) {
                    if(result.retCode=="000000"){
                    	//top.$.publish(eventName,{testData:"hello"});
                    	//window.location.href = "${ctx}/order/ordReserve/list";
                        //window.parent.jBox.close();
                        
	                    layer.confirm('保存成功！是否打印预订单？', {
	  						  btn: ['确定','取消'] 
	  					}, function(){
	  						window.open("${ctx}/print/printReserve?"+result.retMsg);
	  						top.$.publish("reserveList",{testData:"hello"});
	  				    	window.parent.jBox.close();
	  					}, function(){
	  						top.$.publish("reserveList",{testData:"hello"});
	  				    	window.parent.jBox.close();
	  					});
                        
                    }else{
                        layer.alert(result.retMsg);
                    }
                },
                error: function (result, status) {
                    layer.alert("系统错误");
                }
            });
        }
		//手机号码验证
		function checkPhone(){ 
		    var phone =$('#phone').val();
		    if(!(/^1[34578]\d{9}$/.test(phone))){ 
		    	layer.alert("手机号码有误，请重填");
		        $('#phone').val('');
		        return; 
		    } 
		}
    	
    	

       
    </script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="" action="" method="post" class="form-horizontal">
	<input type="hidden" id="storeId" value="${storeId}">
		<div class="row">
			<div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>餐厅：</label>
					<div class="controls">
			 	    	<select id="companyCheckDiv" class="input-medium6" name="storeId" onchange="searchChange(this.options[this.options.selectedIndex].value)">
				 		</select> 
				 	</div>
			   </div>
		  </div>
		    <div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>台号名称：</label>
		        	
				<div class="controls">
		 	        <select id="tableNo" class="required">
					</select>
			 	</div>
			 
		   </div>
		  </div> 
		    <div class="span">
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>联系人：</label>
		            <div class="controls">
		                <input type="text" id="name" name="name" class="required">
		            </div>
		        </div>
		    </div>
		    <div class="span">
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>联系方式：</label>
		            <div class="controls">
		                <input type="text" id="phone" name="phone" maxlength="32" class="required">
		            </div>
		        </div>
		    </div>
		</div>    
		<div class="row">
		    <div class="span">
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>用餐时间：</label>
		            <div class="controls">
		                <input id="useDate"
						style="margin-right: 3px;" name="useDateStart" type="text"
						readonly="readonly" maxlength="20" class="Wdate input-medium6"
						value="${param.useDate }" pattern="yyyy-MM-dd"
						onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />
		            </div>
		        </div>
		    </div>
		    
		  <div class="span">
		        <div class="control-group" style="margin-left: 8px;">
		            <label class="control-label-xs"><span class="notice">*</span>用餐人数：</label>
		            <div class="controls">
		                <input type="text" id="personCount" name="personCount" maxlength="32" class="required" />
		            </div>
		        </div>
		    </div>
			 <div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>用餐时段：</label>
		            <div class="controls" >
		            	<select id="useLevel" name="useLevel" >
			                
						<option value="1">早餐</option>
						<option value="2">中餐</option>
						<option value="3">晚餐</option>
							
						</select>	
		            </div>
		        </div>
		    </div>
		    <div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>客源：</label>
		            <div class="controls">
		            	<select id="sourceId" name="source" onchange="sourceChange()">
			                <c:forEach items="${sourceList}" var="source">
								<option value="${source.paramKey}" sourceName="${source.name}">${source.name}</option>
							</c:forEach>
						</select>	
		            </div>
		        </div>
		    </div>
		 </div>
		 <div class="row">
		     <div class="span" style="display:none">
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>渠道：</label>
		            <div class="controls"> 
						<select id="channelId" name="channel">
						</select>
					</div>
		        </div>
		    </div>
		    <div class="span" id="bcxx" style="display: none;">
		        <div class="control-group">
		            <label class="control-label-xs" id="bcxxwz" >补充信息：</label>
		            <div class="controls" style="position:relative;">
						<input type="text" id="thirdPartName" style="cursor:pointer;" />
						<i class="icon-search" style="position:absolute;right:18px;top:9px;"></i>
						<input type="hidden" id="thirdPartId"  />
						<input type="hidden" id="thirdPartType"  />
					</div>
		        </div>
			</div>
			
		    <div class="span">
		        <div class="control-group">
		            <label class="control-label-xs">业务员：</label>
		            <div class="controls">
		            	<select id="salesPerson" name="salesPerson" class="select-medium4">
						</select>
		            </div>
		        </div>
		    </div>
		    
		    <div class="span">
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>用餐类别：</label>
		            <div class="controls">
		                <select id="useType" name="useType">
		                	<option value="st">散台</option>
		                	<option value="yx">宴席</option>
		                	<option value="hy">会议</option>
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
		                <textarea id="remarks" name="remarks" rows="5" maxlength="255" class="input-xxlarge"></textarea>
		            </div>
		        </div>
		    </div>
		</div>
 
		<hr>
		 <jsp:include page="../common/common_pay.jsp"></jsp:include> 
		<div class="fixed-btn-right">
			<input type="button" id="submitBtn" class="btn btn-primary" onclick="save()" value="保 存"/>&nbsp;
		</div>
	</form:form>
</body>
</html>