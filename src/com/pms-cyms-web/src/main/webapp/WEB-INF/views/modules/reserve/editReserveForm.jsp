<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>修改预订</title>
    <meta name="decorator" content="default"/>
    <script type="text/javascript">
  		var num=0;
  		var pageName="reserve";
    	$(document).ready(function(){
    		top.$.unsubscribe("reserve");
    		var obj = document.getElementById("sourceId");
    		var txt = obj.options[obj.selectedIndex].text;
    		//初始化渠道客源
	        sourceChange(); 
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
  	});
    	
    	//修改客源
    	function sourceChange(){
    		//取消绑定事件
    		$("#thirdPartName").unbind("click");
    	/* 	$("#thirdPartName").removeAttr("readonly");
    		$("#thirdPartName").val("");
    		$("#thirdPartId").val("");
    		$("#thirdPartName").val(""); */
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
         	var storeId = $('#storeId').val();
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
        	var id= $('#ordUnionReserveId').val();
    		var params = {
    				id:id,
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
    			layer.alert("请填写桌型信息！");
    			return;
    		}
    		for(var i=0;i<rows.length;i++){
    			var obj = rows[i];
    			var floorId =  $(obj).find("select[name='floorId']").val();
    			var tableType = $(obj).find("select[name='tableType']").val();
    			var quantity = $(obj).find("input[name='quantity']").val();
    			var id = $(obj).find("input[name='ordUnionReserveDetailId']").val();
    			var personCount = $(obj).find("input[name='personCount']").val();//
    			var oldQuantity = $(obj).find("input[name='oldQuantity']").val();
    			var temp ={id:id,floorId:floorId,tableType:tableType,quantity:quantity,personCount:personCount,oldQuantity:oldQuantity}; 
    			list.push(temp);
    		
    		}
    		
    		var list =JSON.stringify(list);
        $.ajax({
                type: "post",
                dataType: "json",
                url: "${ctx}/reserve/editReserve",
                async:false,
                data: {
                    "params":param,
                    "list":list
                },
                success: function (result) {
                    if(result.retCode=="000000"){
                    	top.$.publish("${param.eventName}",{testData:"hello"});
                    	//window.location.href = "${ctx}/order/ordReserve/list";
                        window.parent.jBox.close();
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
    	
/*     	 function choseSel(trId) {
    		 var html='';
			 var choseVal = $('#floorId'+trId).val();
         	$.ajax({
                 url:"${ctx}/setting/ctTable/selectByTypeId",
                 type: "post",
                 dataType: "json",
                 async: false,
                 data: {
                     "floorId":choseVal
                 },
                 success: function (result) {
                	 for(var i=0;i<result.length;i++){
                    	html += "<option value='"+result[i].typeId+"'>"+result[i].ctTableTypeName+"</option>";
                     	$('#floorIdType'+trId).empty();
                     	$('#floorIdType'+trId).append(html);
	       	            }
            	 	}
         	});
         } */
    	
        function addRow(i,data) {
     
        	var html = '';
      		html += "<tr id='"+num+"' class='rows'><td><select class='input-xlarge required' id='floorId"+num+"' name='tableType' onchange='choseSel("+num+")' style='width: 94%'>";
            html += "<option value=''>全部</option>";
            html += "<c:forEach items='${ctTableTypeList}' var='ctTableTypeList'>";
            html += "<option value='${ctTableTypeList.id}' >${ctTableTypeList.name}</option>";
            html += "</c:forEach></select></td>";
            html += "<td><input type='text' value='10'  name='oldQuantity'    style='width: 94%'></input></td>";
            html += "<td><input type='text'  name='quantity'  style='width: 92%'></input>";
            html += "<td><input type='text'  name='personCount'  style='width: 92%'></input>";
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
        
    </script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="" action="" method="post" class="form-horizontal">
	<input type="hidden" id="ordUnionReserveId" name="ordUnionReserveId" value="${ordUnionReserve.id}" />
	<input type="hidden" id="storeId" name="storeId" value="${ordUnionReserve.storeId}" />
		<div class="row"> 
		    <div class="span">
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>联系人：</label>
		            <div class="controls">
		                <input type="text" id="name" name="name"  class="required" value="${ordUnionReserve.name}">
		            </div>
		        </div>
		    </div>
		    <div class="span">
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>联系方式：</label>
		            <div class="controls">
		                <input type="text" id="phone" name="phone" maxlength="32" class="required"  value="${ordUnionReserve.phone}">
		            </div>
		        </div>
		    </div>
		    <div class="span">
	        <div class="control-group">
	            <label class="control-label-xs"><span class="notice">*</span>用餐时间：</label>
	            <div class="controls">
	                <input id="useDate" style="margin-right:3px;" name="useDate" type="text" readonly="readonly" maxlength="20" class="Wdate input-medium6"
                       value="${ordUnionReserve.useDate}" pattern="yyyy-MM-dd"
                       onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});" />
	            </div>
	        </div>
	    </div>
		   
		   	 <div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>用餐时段：</label>
		            <div class="controls" >
		            	<select id="useLevel" name="useLevel" >
			                
						<option value="1" <c:if test="${ordUnionReserve.useLevel=='1'}">selected="selected"</c:if>>早餐</option>
						<option value="2" <c:if test="${ordUnionReserve.useLevel=='2'}">selected="selected"</c:if>>中餐</option>
						<option value="3" <c:if test="${ordUnionReserve.useLevel=='3'}">selected="selected"</c:if>>晚餐</option>
							
						</select>	
		            </div>
		        </div>
		    </div> 

		</div>
		
		<div class="row">
		
		    <div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>客源：</label>
		            <div class="controls">
		            	<select id="sourceId" name="source" onchange="sourceChange()">
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
						<select id="channelId" name="channel">
						</select>
					</div>
		        </div>
		    </div>
		    
		    <div class="span" id="bcxx" style="display: none;">
		        <div class="control-group">
		            <label class="control-label-xs" id="bcxxwz" >补充信息：</label>
		            <div class="controls" style="position:relative;">
						<input type="text" id="thirdPartName" style="cursor:pointer;" value="${ordUnionReserve.thirdPartId}" />
						<i class="icon-search" style="position:absolute;right:18px;top:9px;"></i>
						<input type="hidden" id="thirdPartId" value="${ordUnionReserve.thirdPartId}" />
						<input type="hidden" id="thirdPartType"  />
					</div>
		        </div>
			</div>
			
		    <div class="span">
		        <div class="control-group">
		            <label class="control-label-xs">业务员：</label>
		            <div class="controls">
		            	<select id="salesPerson" name="salesPerson" class="select-medium4"  value="${ordUnionReserve.salesPerson}">
						</select>
		            </div>
		        </div>
		    </div>
		    
		    <div class="span">
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>用餐类别：</label>
		            <div class="controls">
		                <select id="useType" name="useType">
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
		                <textarea id="remarks" name="remarks" rows="5" maxlength="255" class="input-xxlarge">${ordUnionReserve.remarks}</textarea>
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
        <c:forEach items='${ordUnionReserveDetail}' var='ordUnionReserveDetail'>
		
					<tr id="${ordUnionReserveDetail.id}" class='rows'>
					<input type="hidden" name="ordUnionReserveDetailId" value="${ordUnionReserveDetail.id}" />
					<input type="hidden" name="oldQuantity" value="${ordUnionReserveDetail.quantity}" />
						<td><select class='input-xlarge required' id='floorId"+${ordUnionReserveDetail.id}+"'
							name='tableType' onchange='choseSel("${ordUnionReserveDetail.id}")' style='width: 94%'>
								<option value=''>全部</option>
								<c:forEach items='${ctTableTypeList}' var='ctTableTypeList'>
									<option value='${ctTableTypeList.id}' <c:if test="${ordUnionReserveDetail.tableType eq ctTableTypeList.id}">selected="selected"</c:if>>${ctTableTypeList.name}</option>
								</c:forEach>
						</select>
						</td>
						<td>
						<input type='text' value='10' name='oldQuantity' style='width: 94%'></input>
						</td>
						<td>
						<input type='text' name='quantity' style='width: 92%' value="${ordUnionReserveDetail.quantity}"></input>
						</td>
						<td>
						<input type='text' name='personCount' style='width: 92%' value="${ordUnionReserveDetail.personCount} "></input>
						</td>
						<td><a id='delBtn' onclick='delRow("${ordUnionReserveDetail.id}")'>删除</a></td>
					</tr>
		</c:forEach>
				</tbody>
        </table>
        <div style="text-align:right;"><input class="btn btn-primary" type="button" value="新增" onclick="addRow(null,null)"/></div>
        </div>
		
		<div class="fixed-btn-right">
			<input type="button" id="submitBtn" class="btn btn-primary" onclick="save()" value="保 存"/>&nbsp;
		</div>
	</form:form>
</body>
</html>