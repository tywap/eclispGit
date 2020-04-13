<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>预订</title>
    <meta name="decorator" content="default"/>
    <script type="text/javascript">
  		var num=0;
  		var pageName="reserve";
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
    		//加载业务人员
			loadSelect("salesPerson","${ctx}/sys/userutils/getSalesmanList",{},'','id','name');			
		    //加载分店
	        loadSelect("companyCheckDiv","${ctx}/sys/userutils/getOfficeListByType",{typesJson:"['3','4','5']"},'${selectStoreId}','id','name');
		    //初始化渠道客源
	        sourceChange();
    	});
    	
    	//修改客源
    	function sourceChange(){
    		var storeId = $('#companyCheckDiv').val();
    		if(storeId==""){
    			layer.alert("请选择分店！");
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
        	    			   "iframe:${ctx}/member/member/getMemberListInit?storeId="+storeId,
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
        	    			   "iframe:${ctx}/member/group/getGroupListInit?storeId="+storeId,
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
         	var storeId = $('#companyCheckDiv').val();
        	var name = $('#name').val();
        	var phone = $('#phone').val();
        	var useDate = $('#useDate').val();
        	var useLevel = $('#useLevel').val();
        	var channel = $('#channelId').val();
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
       				channel:channel,
       				source:source,
       				salesPerson:salesPerson,
       				useType:useType,
       				remarks:remarks
        		}
    		var param =JSON.stringify(params);
        	
        	
        	
        	var list = [];
    		var rows = $(".rows");
    		if(rows.length==0){
    			layer.alert("请选择预定的台型！");
    			return;
    		}
    		for(var i=0;i<rows.length;i++){
    			var obj = rows[i];
    			var floorId =  $(obj).find("select[name='floorId']").val();
    			var tableType = $(obj).find("select[name='tableType']").val();
    			var quantity = $(obj).find("input[name='quantity']").val();
    			var personCount = $(obj).find("input[name='personCount']").val();
    			var temp ={floorId:floorId,tableType:tableType,quantity:quantity,personCount:personCount}; 
    			list.push(temp);
    		
    		}
    		
    		var list =JSON.stringify(list);
    		
    		//支付明细
			var obj = getPaymentFunds();
			var paymentFunds = obj.paymentFunds;
			var payAmount = obj.payTotalAmount;
			if(parseInt(payAmount) < 0){
				layer.alert("订金退款额度不允许超过原有订金额度！");
				return;
			}
        $.ajax({
                type: "post",
                dataType: "json",
                url: "${ctx}/reserve/saveReserve",
                async:false,
                data: {
                    "params":param,
                    "list":list,
                    "paymentFundJson":JSON.stringify(paymentFunds)
                },
                success: function (result) {
                    /* if(result.retCode=="000000"){
                    	top.$.publish("reserveList",{testData:"hello"});
                    	//window.location.href = "${ctx}/order/ordReserve/list";
                        window.parent.jBox.close();
                    }else{
                        layer.alert(result.retMsg);
                    } */
                    
                    if(result.retCode=="000000"){
	                    layer.confirm('保存成功！是否打印预订单？', {
	  						  btn: ['确定','取消'],
	  						  cancel: function(index, layero){
	  							top.$.publish("reserveList",{testData:"hello"});
		  				    	window.parent.jBox.close();
	  						  }
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
    	
       function addRow(i,data) {
     
        	var html = '';
      		html += "<tr id='"+num+"' class='rows'><td><select class='input-xlarge required' id='floorId"+num+"' name='tableType' onchange='choseSel("+num+")' style='width: 94%'>";
            html += "<option value=''>全部</option>";
            html += "<c:forEach items='${ctTableTypeList}' var='ctTableTypeList'>";
            html += "<option value='${ctTableTypeList.id}' >${ctTableTypeList.name}</option>";
            html += "</c:forEach></select></td>";
            html += "<td><input type='text' value='10'  name='oldQuantity'    style='width: 94%'></input></td>";
            html += "<td><input type='text'  class='input-xlarge required' name='quantity'  style='width: 92%'></input>";
            html += "<td><input type='text'  class='input-xlarge required' name='personCount'  style='width: 92%'></input>";
            html += "<td><a id='delBtn' onclick='delRow("+num+")'>删除</a></td>";
            html += "</tr>";
            num = num + 1;
           $('#trList').append(html);
         }  
        
        function  delRow(trId) {
            var tab=document.getElementById("trList");
            var row=document.getElementById(trId);
            var index=row.rowIndex;//rowIndex属性为tr的索引值，从0开始
            tab.deleteRow(index); //从table中删除
        }
        
		//查询
    	function searchChange(storeId){
    			if(storeId==''){
    				
    				storeId="pmscy";
    			}
    			self.location.href="${ctx}/reserve/toAddReserveForm?storeId="+storeId;
    			
    		}
		

	

			function choseSel(trId) {
						var choseVal = $('#floorId' + trId).val();
						var list1 = [];
						var rows = $(".rows");
						
						for (var i = 0; i < rows.length; i++) {
							var obj = rows[i];

							var tableType = $(obj).find("select[name='tableType']").val();
							
							if(tableType==choseVal){
								
								list1.push(tableType);
							}

						}
						
						if(list1.length>1){
							
							alert("桌型不能重复，请请重新选择！");
							
							$('#floorId' + trId).val('');
							return;
						}

					}
				</script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="" action="" method="post" class="form-horizontal">
		<div class="row">
		    <div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>分店：</label>
		        	
				<div class="controls">
		 	    	<select   id="companyCheckDiv" class="input-medium6" name="storeId"  onchange="searchChange(this.options[this.options.selectedIndex].value)">
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
		    <div class="span">
	        <div class="control-group">
	            <label class="control-label-xs"><span class="notice">*</span>用餐时间：</label>
	            <div class="controls">
	                <input id="useDate" style="margin-right:3px;" name="useDate" type="text" readonly="readonly" maxlength="20" class="Wdate input-medium6"
                       value="${param.strTime }" pattern="yyyy-MM-dd HH:mm:ss"
                       onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />
	            </div>
	        </div>
	    </div>
		    

		</div>
		
		<div class="row">
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
		
	<div class="row">
    <table class="table table-striped table-bordered table-condensed" id="trList">
        <thead>
            <tr>
                <th>台号类型</th>
                <th>可预订数</th>
                <th>预定台数</th>
                <th>用餐人数</th>
                <th>操作</th>
            </tr>
        </thead>
        <tbody id="trList">
        
        </tbody>
        </table>
        <div style="text-align:right;"><input class="btn btn-primary" type="button" value="新增" onclick="addRow(null,null)"/></div>
        </div>
		<hr>
		 <jsp:include page="../common/common_pay.jsp"></jsp:include> 
		<div class="fixed-btn-right">
			<input type="button" id="submitBtn" class="btn btn-primary" onclick="save()" value="保 存"/>&nbsp;
		</div>
	</form:form>
</body>
</html>