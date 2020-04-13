<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>预定开台</title>
    <meta name="decorator" content="default"/>
    <script src="${ctxStatic}/room/roomCard.js?V=1" type="text/javascript"></script>
    <style>
        [class*="span"]{margin-left: 0;}
        ul{list-style:none;}
        li{float:left;margin:10px 5px;width:60px;height:50px;text-align:center;background:#009BDB;}
        li div{margin-top:5px;}
    </style>
    <script type="text/javascript">
    var eventName="orderPartCheckForm";
    var Detail = ${ordUnionReserveDetail};
    var storeId= '';
    var tableTypeId='';
    var s=0;
    $(document).ready(function() { 
    	top.$.unsubscribe(eventName);
        //注册事件，弹出页面需要刷新本页面，或者弹出页面回传数据用
    	top.$.subscribe(eventName, function (e, data) {
    		if (data.testData == 'hello') {
	    		window.parent.jBox.close();
	        }
        });
        for (var i = 0; i < Detail.length; i++) {
        	for (var j = 0; j < Detail[i].reserveList.length; j++) {
        		if (Detail[i].reserveList[j].tableNo != null) {
                    s++;
                    tableTypeId=Detail[i].tableType;
                    storeId = Detail[i].storeId;
        		}
			}
		}
        if (s==1) {
        	chooseAll(tableTypeId);
		}
        
    });
    function toCheckIn(){
    	var unionReserveId = $('#ordReserveId').val();
    	var tableList=[];
    	$("li").each(function(){ 
    		if($(this).data("choosed")==1){
    			var tableId=$(this).attr("tableId");
    			var reserveId =$(this).attr("reserveId");
    			var temp ={id:reserveId,tableId:tableId,unionReserveId:unionReserveId,tableType:tableTypeId};
    			tableList.push(temp);
    		}
    	});
    	if(tableList == "" ){
    		layer.alert("请勾选需要入住的房间！");
    		return;
    	}
    	if(s == 1){
    		 top.$.jBox.open(
    				"iframe:${ctx}/order/checkIn/checkInInit?storeId="+storeId+"&tableId="+tableList[0].tableId+"&reserveId="+tableList[0].unionReserveId+"&tableType="+tableList[0].tableType+"&id="+tableList[0].id,
    	            "开台", 1000, 560,{
    	 	             	buttons: {},
    	 	             	loaded: function (h) {
    	 	             		$(".jbox-content", top.document).css("overflow-y", "hidden");
    	 	                },
    	 	                closed:function (){
    	 	                	top.$.publish("${param.eventName}",{testData:"hello"});
    	 	                	window.parent.jBox.close();
    	 	                }
    	             }
    	 	);
    	}else {
    		$.ajax({
            url:"${ctx}/reserve/reserveCheckIn",
            type: "post",
            dataType: "json",
            data: {
            	"unionReserveId":unionReserveId,
                "reserves":JSON.stringify(tableList)
            },
            success: function (result) {
            	if(result.retCode=="000000"){
            		layer.confirm("预订单转订单成功！", {
						btn: ['确定'] 
					}, function(){
						top.$.publish("${param.eventName}",{testData:"hello"});
				    	window.parent.jBox.close();
					}, function(){
					});
            	}else{
            		layer.alert(result.retMsg);
            	}
            }
        }); 
		}
    }  
    
    function chooseAll(checkName){
    	var num_ = 0;
    	$("li[name='"+checkName+"']").each(function(){ 
    		$(this).css("background","#FF6600");
			$(this).data("choosed", 1);
    		num_ = num_ + 1;
    	});
    	$("#checkNum").html(num_);
    }
    
    $(document).ready(function(){  
    	$('li').click(function() { 
    		var num = $("#checkNum").html();
    		if($(this).data("choosed")==1){
    			$(this).css("background","#009BDB");
    			$(this).data("choosed", 0);
    			num = Number(num) - 1;
    		} else {
    			$(this).css("background","#FF6600");
    			$(this).data("choosed", 1);
    			num = Number(num) + 1;
    		}
    		$("#checkNum").html(num);
    	});  
    });
    
    </script>
  
</head>
<body>
<form id="inputForm" modelAttribute="ordReserve" method="post" class="form-horizontal">
		<div class="row">
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><span class="notice">*</span>订单号：</label>
					<div class="controls">
						<input type="text" id="ordReserveId" name="ordReserveId" maxlength="32"
							readonly="readonly" class="required digits"
							value="${ordUnionReserve.id}">
					</div>
				</div>
			</div>
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><span class="notice">*</span>联系人：</label>
					<div class="controls">
						<input type="text" id="name" name="name" 
							readonly="readonly" class="required"
							value="${ordUnionReserve.name}">
					</div>
				</div>
			</div>
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><span class="notice">*</span>联系方式：</label>
					<div class="controls">
						<input type="text" id="phone" name="phone" maxlength="32"
							readonly="readonly" class="required"
							value="${ordUnionReserve.phone}">
					</div>
				</div>
			</div>
	</div>  
<div style="clear:both;"></div>
<div class="row">
    <div id="roomTypeList" style="border-bottom:1px solid #ccc;">
    	<c:forEach items="${ordUnionReserveDetail}" var="item">
    		<div  class="span">
    			<label class='control-label-xs' style="margin-right:100px;" >${item.tableTypeName}</label>
    			<label class='control-label-xs' style="margin-left:600px;"></label>
    			<label class='control-label-xs'><a href="#" onclick="chooseAll('${item.tableType}')">一键勾选</a></label>
    		 </div>
    		 <div style="clear:both;"></div>
    		 <div  class="span" >
    		 <ul class="roomChoose">
	    		<c:forEach items="${item.reserveList}" var="var"> 
	    			
	    				 <c:if test="${not empty var.tableNo}"> 
	    					<li name="${item.tableType}" tableId="${var.tableId}" reserveId="${var.id}" data-choosed="0" style="cursor:pointer;">
	    					<a style="background:#009BDB;"></a>
	    					<div>
	    					<span style="font: 14px;color: #fff">${var.tableNo}</span><br>
	    					<%-- <span style="font: 14px;color: red">${reserve.flagStr }</span> --%>
	    					</div>
	    					</li>
	    			
	    				 </c:if>
	    		 </c:forEach> 
	    	</ul>
    		 </div>
    	</c:forEach> 
    </div>
</div>

    <div class="fixed-btn-right">
    	<label style="margin-right: 10px;">已选择：<span id="checkNum">0</span></label>
        <input id="submitBtn" class="btn btn-primary"  type="button" value="确定" onclick="toCheckIn()" />&nbsp;
    </div>

</form>
</body>
</html>