<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<meta name="decorator" content="default"/>
	<script src="${ctxStatic}/room/roomCard.js?V=4" type="text/javascript"></script>
	<script type="text/javascript">
	function addConsume(ordId){
		<shiro:lacksPermission name="order:deposit">
		$.jBox.alert("暂无权限！");
		return;
		</shiro:lacksPermission>
        top.$.jBox.open(
                "iframe:${ctx}/order/ordConsume/ordConsumeInit?isUnion=0&ordNo="+ordId,
                "增加消费",
                1050,
                560,
                {
                    buttons: {},
                    loaded: function (h) {
                        $(".jbox-content", top.document).css("overflow-y", "hidden");
                    }
                }
            );
	}
	
	//新增客房服务
	function addRoomService(roomOrdId,roomId){
		<shiro:lacksPermission name="roomstatus:Roomserver:edit">
		$.jBox.alert("暂无权限！");
		return;
		</shiro:lacksPermission>
		top.$.jBox.open(
             "iframe:${ctx}/room/roomServer/form?eventName=" + eventName + "&editFlag=add" + "&roomOrdId="+roomOrdId+ "&roomId="+roomId,
             "新增客房服务",
             600,
             400,
             {
                 buttons: {},
                 loaded: function (h) {
                     $(".jbox-content", top.document).css("overflow-y", "hidden");
                 }
             }
         );
	}
	
	function getdDeposit(ordId){
		<shiro:lacksPermission name="order:room:addDeposit">
		$.jBox.alert("暂无权限！");
		return;
		</shiro:lacksPermission>
        top.$.jBox.open(
                "iframe:${ctx}/order/ordDeposit/ordDepositInit?ordNo="+ordId+"&isUnion=0",
                "押金调整",
                1050,
                560,
                {
                    buttons: {},
                    loaded: function (h) {
                        $(".jbox-content", top.document).css("overflow-y", "hidden");
                    }
                }
            );
	}		
			
	function changeRoomCleanStatus(roomId,cleanStatus,roomNo){
		if(cleanStatus=='1'){
			<shiro:lacksPermission name="diagram:setClean">
			$.jBox.alert("暂无权限！");
			return;
			</shiro:lacksPermission>
			top.$.jBox.open(
                    "iframe:${ctx}/roomstatus/htlRoomStatus/htlCleanFinishedLoad?roomId=" + roomId + "&roomNo=" + roomNo,
                    "打扫完成",
                    700,
                    350,
                    {
                        buttons: {},
                        loaded: function (h) {
                            $(".jbox-content", top.document).css("overflow-y", "hidden");
                        },
                        closed: function () {
                        	reflashRoom(roomId);
                        }
                    }
                );
		}else{			//置脏房
			<shiro:lacksPermission name="diagram:setDirty">
			$.jBox.alert("暂无权限！");
			return;
			</shiro:lacksPermission>
			$.ajax({
		        url:"${ctx}/diagramRightMenu/changeRoomCleanStatus",
		        type: "post",
		        data: {
		            "roomId":roomId,
		            "cleanStatus":cleanStatus,
		        },
		        success: function (result) {
		        	$.jBox.alert(result);
		        	reflashRoom(roomId);
		        	
		        	//电控
					if(top.m_qudian==1){
						var request = {
							"roomNo" : roomNo
						}
						top.callQudianApi("dirty", request);
					}
		   		}
			});
		}
	}
	
	
	//预留房转入住
	 //本单全部转入住
        function orderCheckIn(sid,roomId){
        	var roomList=[];
        	roomList.push(roomId);
        	$.ajax({
                url:"${ctx}/order/orderUnionReserve/validateStatus?roomIds="+roomList,
                type: "post",
                dataType: "json",
                data: {
                    "id":sid
                },
                success: function (result) {
                	if(result.retCode=="000000"){
                		 top.$.jBox.open(
           	                "iframe:${ctx}/order/orderUnionReserve/orderCheckInForm?eventName="+eventName+"&id="+sid+"&roomIds="+roomList,
           	                "本单全部转入住",
           	                1000,
           	                560,
           	                {
           	                    buttons: {},
           	                    loaded: function (h) {
           	                        $(".jbox-content", top.document).css("overflow-y", "hidden");
           	                    }
           	                }
           	            );
                	}else{
                		$.jBox.alert(result.retMsg);
                	}
	            }
	        })
           
		}
	
	function getCheckOutApplyInfo(unionId,orderno,infoStatus,unionFlag){
		if(infoStatus=="1"||infoStatus=="2"){
			return  {text: '设置单房作废', action: function(e){
		        	 setChekcOut(orderno,"0",0);
		         }};
		}else{
			return  {text: '设置单房待查退', action: function(e){
				setChekcOut(orderno,"1",0);
	        }};
		}
	}
	
	function getCheckOutApplyInfoAll(unionId,orderno,infoStatus,unionFlag){
		if(infoStatus=="1"||infoStatus=="2"){
			return  {text: '设置联房作废', action: function(e){
				setChekcOut(unionId,"0",1)
	        }};
		}else{
			return  {text: '设置联房待查退', action: function(e){
				setChekcOut(unionId,"1",1)
	        }};
		}
	}
	
	function changeRoomStatus(roomId,status){
		if(status=="repair"){
			<shiro:lacksPermission name="diagram:setRepair">
			$.jBox.alert("暂无权限！");
			return;
			</shiro:lacksPermission>
			top.$.jBox.open(
                    "iframe:${ctx}/roomstatus/htlRoomStatus/htlNewRepairLoad?id="+roomId+"&status=1",
                    "新增维修",
                    700,
                    350,
                    {
                        buttons: {},
                        loaded: function (h) {
                            $(".jbox-content", top.document).css("overflow-y", "hidden");
                        },
                        closed: function () {
                        	reflashRoom(roomId);
                        }
                    }
                );
		}
		if(status=="retain"){
			<shiro:lacksPermission name="diagram:setRetain">
			$.jBox.alert("暂无权限！");
			return;
			</shiro:lacksPermission>
			top.$.jBox.open(
                    "iframe:${ctx}/roomstatus/htlRoomStatus/htlNewReserveLoad?id="+roomId+"&status=1",
                    "新增保留",
                    700,
                    350,
                    {
                        buttons: {},
                        loaded: function (h) {
                            $(".jbox-content", top.document).css("overflow-y", "hidden");
                        },
                        closed: function () {
                        	reflashRoom(roomId);
                        }
                    }
                );
		}
	}
	
	function addDays(ordId,rentTimer,channelId){
		<shiro:lacksPermission name="order:room:addDays">
		$.jBox.alert("暂无权限！");
		return;
		</shiro:lacksPermission>
		
		if(rentTimer!="1"){
			layer.alert("只有全天房才能续住！");	
			return ;
		}
		if(channelId=='02'||channelId=='03'||channelId=='04'||channelId=='05'){
			layer.alert("第三方订单不能续住！");	
			return ;
		}
		top.$.jBox.open(
               "iframe:${ctx}/order/ordOperation/addDays?ordId="+ordId,
               "续住",
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
	
	function changeRooms(ordId){
		<shiro:lacksPermission name="order:room:changeRooms">
		$.jBox.alert("暂无权限！");
		return;
		</shiro:lacksPermission>
		top.$.jBox.open(
              "iframe:${ctx}/order/ordOperation/changeRooms?ordId="+ordId,
              "换房",
              1000,
              560,
              {
                  buttons: {},
                  loaded: function (h) {
                      $(".jbox-content", top.document).css("overflow-y", "hidden");
                  }
              }
         );
	}
	
	function adjustPrice(ordId){
		<shiro:lacksPermission name="order:room:adjustPrice">
		$.jBox.alert("暂无权限！");
		return;
		</shiro:lacksPermission>
		top.$.jBox.open(
              "iframe:${ctx}/order/ordOperation/adjustPrice?ordId="+ordId,
              "调整房价",
              1000,
              $(document).height() - 180,
              {
                  buttons: {},
                  loaded: function (h) {
                      $(".jbox-content", top.document).css("overflow-y", "hidden");
                  }
              }
         );
	}
	
	function ordTransfer(isUnion,ordNo,roomNo,memberName){
		<shiro:lacksPermission name="order:room:transferAccount">
		$.jBox.alert("暂无权限！");
		return;
		</shiro:lacksPermission>
		
		isUnion="0";
		top.$.jBox.open(
                "iframe:${ctx}/order/ordTransferAccount/ordTransferAccountInit?isUnion="+isUnion+"&ordNo="+ordNo+"&roomNo="+roomNo+"&memberName="+memberName,
                "转账",
                1050,
                560,
                {
                    buttons: {},
                    loaded: function (h) {
                        $(".jbox-content", top.document).css("overflow-y", "hidden");
                    }
                }
            );
	}
	
	function checkOut(isUnion,ordNo,type,roomNo,roomId){
		<shiro:lacksPermission name="order:menu:checkout">
		$.jBox.alert("暂无权限！");
		return;
		</shiro:lacksPermission>
		
		top.$.jBox.open(
              "iframe:${ctx}/order/checkOut/checkOut?isUnion="+isUnion+"&ordNo="+ordNo+"&type="+type+"&roomNo="+roomNo,
              "整单结账",
              1050,
              560,
              {
                  buttons: {},
                  loaded: function (h) {
                      $(".jbox-content", top.document).css("overflow-y", "hidden");
                  },                        
                  closed: function () {
                     }
              }
          );
	}
	
	function checkOutPX(isUnion,ordNo,type,roomNo,roomId){
		<shiro:lacksPermission name="order:menu:checkout">
		$.jBox.alert("暂无权限！");
		return;
		</shiro:lacksPermission>
		top.$.jBox.open(
               "iframe:${ctx}/order/checkOut/checkOutPX?isUnion="+isUnion+"&ordNo="+ordNo+"&type="+type+"&roomNo="+roomNo+"&roomId="+roomId,
               "整单PX",
               1050,
               560,
               {
                   buttons: {},
                   loaded: function (h) {
                       $(".jbox-content", top.document).css("overflow-y", "hidden");
                   },                        
                   closed: function () {
                   	reflashRoom(roomId);
                   }
               }
           );
	}
	
	//发卡初始化
	function newCardInit(lockNo,checkTime,mainName,roomNo,roomTypeName,rentTypeName,days){
		var lockType = '${fns:getStore().lockType}';
		$("#lockTitle").html("门锁发卡");
		$('#newCardBtn').attr("disabled",false);
		$('#copyCardBtn').attr("disabled",false);
		$('#cleanCardBtn').attr("disabled",true);
		$('#readCardBtn').attr("disabled",true);
		
		$("#_lockNo2").val(lockNo);
		$("#_checkTime2").val(checkTime);
		$("#_roomNo").html(roomNo);
		$("#_roomTypeName").html(roomTypeName);
		$("#_rentTypeName").html(rentTypeName);
		$("#_name").html(mainName);
		$("#_checkOutDateTime").html(checkTime.substring(12,16)+"-"+checkTime.substring(16,18)+"-"+checkTime.substring(18,20)+" "+checkTime.substring(20,22)+":"+checkTime.substring(22,24));
		$("#_days").html(days);
		$('.Card').show();
	}
	
	//写卡提交
	function writeCardBtn(){
		var lockType = '${fns:getStore().lockType}';
		if(lockType==""){
			layer.confirm("当前分店未配置【门锁类型】", {btn: ['确定'] }, function(index){layer.close(index);}, function(){return;});
			return;
		}
		var port = "${fns:getValueByParamKey(fns:getStore().lockType,'lockType')}";
		if(port==""){
			layer.confirm("当前分店未配置【门锁端口】", {btn: ['确定'] }, function(index){layer.close(index);}, function(){return;});
			return;
		}
		var lockNo = $("#_lockNo2").val();
		if(lockNo==""||lockNo==undefined){
			layer.confirm("当前房间未配置【门锁号】", {btn: ['确定'] }, function(index){layer.close(index);}, function(){return;});
			return;
		}
		var checkTime = $("#_checkTime2").val();
		var checkInDateTime = checkTime.substring(0,12);
		var checkOutDateTime = checkTime.substring(12,24);
		var curDate = new Date().Format("yyyyMMddhhmm");
		console.log(checkOutDateTime);
		console.log(curDate);
		if(checkOutDateTime < curDate){
			layer.confirm("预离时间小于当前时间不可制卡", {btn: ['确定'] }, function(index){layer.close(index);}, function(){return;});
			return;
		}
		console.log(lockType+"|"+port+"|"+lockNo+"|"+checkInDateTime+"|"+checkOutDateTime);
		window.RoomCard.write(lockType, port, lockNo, checkInDateTime, checkOutDateTime);
	}
	function writeCardRes(r){
		console.debug(r);
		var status = r.State;
		var message = r.Message;
		layer.confirm(message, {btn: ['确定'] }, function(index){layer.close(index);}, function(){return;});
		return;
	}
	
	//复制卡提交
	function copyCardBtn(){
		var lockType = '${fns:getStore().lockType}';
		if(lockType==""){
			layer.confirm("当前分店未配置【门锁类型】", {btn: ['确定'] }, function(index){layer.close(index);}, function(){return;});
			return;
		}
		var port = "${fns:getValueByParamKey(fns:getStore().lockType,'lockType')}";
		if(port==""){
			layer.confirm("当前分店未配置【门锁端口】", {btn: ['确定'] }, function(index){layer.close(index);}, function(){return;});
			return;
		}
		var lockNo = $("#_lockNo2").val();
		if(lockNo==""||lockNo==undefined){
			layer.confirm("当前房间未配置【门锁号】", {btn: ['确定'] }, function(index){layer.close(index);}, function(){return;});
			return;
		}
		var checkTime = $("#_checkTime2").val();
		var checkInDateTime = checkTime.substring(0,12);
		var checkOutDateTime = checkTime.substring(12,24);
		var curDate = new Date().Format("yyyyMMddhhmm");
		console.log(checkOutDateTime);
		console.log(curDate);
		if(checkOutDateTime < curDate){
			layer.confirm("预离时间小于当前时间不可制卡", {btn: ['确定'] }, function(index){layer.close(index);}, function(){return;});
			return;
		}
		console.log(lockType+"|"+port+"|"+lockNo+"|"+checkInDateTime+"|"+checkOutDateTime);
		window.RoomCard.copy(lockType, port, lockNo, checkInDateTime, checkOutDateTime);
	}
	function copyCardRes(r){
		console.debug(r);
		var status = r.State;
		var message = r.Message;
		layer.confirm(message, {btn: ['确定'] }, function(index){layer.close(index);}, function(){return;});
		return;
	}
	
	//清卡初始化
	function cleanCardInit(lockNo,checkTime,mainName,roomNo,roomTypeName,rentTypeName,days){
		var lockType = '${fns:getStore().lockType}';
		$("#lockTitle").html("门锁清卡");
		$('#newCardBtn').attr("disabled",true);
		$('#copyCardBtn').attr("disabled",true);
		$('#readCardBtn').attr("disabled",false);
		$('#cleanCardBtn').attr("disabled",true);
		
		$("#_roomNo").html("");
		$("#_roomTypeName").html("");
		$("#_rentTypeName").html("");
		$("#_name").html("");
		$("#_checkOutDateTime").html("");
		$("#_days").html("");
		$('.Card').show();
	}
	
	//读卡提交
	function readCardBtn(){
		var lockType = '${fns:getStore().lockType}';
		if(lockType==""){
			layer.confirm("当前分店未配置【门锁类型】", {btn: ['确定'] }, function(index){layer.close(index);}, function(){return;});
			return;
		}
		var port = "${fns:getValueByParamKey(fns:getStore().lockType,'lockType')}";
		if(port==""){
			layer.confirm("当前分店未配置【门锁端口】", {btn: ['确定'] }, function(index){layer.close(index);}, function(){return;});
			return;
		}
		console.log(lockType+"|"+port);
		RoomCard.read(lockType,port);
		//var r = {State:'0',Message:'',DoorID:'0184011',BeginTime:'2019-02-16',EndTime:'2019-02-16'};
		//readCardRes(r);
	}
	function readCardRes(r){
		console.debug(r);
		var status = r.State;
		var message = r.Message;
		if(status=="0"){
			var lockNo = r.DoorID;
			var checkInDateTime = r.BeginTime;
			var checkOutDateTime = r.EndTime;
			
			if(lockNo == ""){
				layer.confirm("读取门锁【编号】失败", {btn: ['确定'] }, function(index){layer.close(index);}, function(){return;});
				return;
			}
			if(checkInDateTime == ""){
				layer.confirm("读取门锁【入住时间】失败", {btn: ['确定'] }, function(index){layer.close(index);}, function(){return;});
				return;
			}
			if(checkOutDateTime == ""){
				layer.confirm("读取门锁【离店时间】失败", {btn: ['确定'] }, function(index){layer.close(index);}, function(){return;});
				return;
			}
			var params = {
				lockNo:lockNo,
				checkInDateTime:checkInDateTime,
				checkOutDateTime:checkOutDateTime
			}
			loadAjax("${ctx}/diagram/getOrderMsgByLockNo",params,function(result){
				if(result.retCode=="000000"){
					var ret = result.ret;
					$('#cleanCardBtn').attr("disabled",false);
					$("#_lockNo2").val(lockNo);
					
					$("#_roomNo").html(ret.roomNo);
					$("#_roomTypeName").html(ret.roomTypeName);
					$("#_rentTypeName").html(ret.rentTypeName);
					$("#_name").html(ret.name);
					$("#_days").html(ret.days);
					$("#_checkOutDateTime").html(ret.checkOutDateTime);
		    	}else{
		    		layer.confirm(result.retMsg, {btn: ['确定'] }, function(index){layer.close(index);}, function(){return;});
		    		return;
		    	}
			});
		}else{
			layer.confirm(message, {btn: ['确定'] }, function(index){
				layer.close(index);
				$("#_roomNo").html("");
				$("#_roomTypeName").html("");
				$("#_rentTypeName").html("");
				$("#_name").html("");
				$("#_checkOutDateTime").html("");
				$("#_days").html("");
			}, function(){return;});
			return;
		}
	}
	
	//清卡提交
	function cleanCardBtn(){
		var lockType = '${fns:getStore().lockType}';
		if(lockType==""){
			layer.confirm("当前分店未配置【门锁类型】", {btn: ['确定'] }, function(index){layer.close(index);}, function(){return;});
			return;
		}
		var port = "${fns:getValueByParamKey(fns:getStore().lockType,'lockType')}";
		if(port==""){
			layer.confirm("当前分店未配置【门锁端口】", {btn: ['确定'] }, function(index){layer.close(index);}, function(){return;});
			return;
		}
		console.log(lockType+"|"+port);
		RoomCard.clean(lockType,port);
	}
	function cleanCardRes(r){
		console.debug(r);
		var status = r.State;
		var message = r.Message;
		if(status=="0"){
			layer.confirm(message, {btn: ['确定'] }, function(index){
				layer.close(index);
				$("#_lockNo2").val("");
				$("#_roomNo").html("");
				$("#_roomTypeName").html("");
				$("#_rentTypeName").html("");
				$("#_name").html("");
				$("#_checkOutDateTime").html("");
				$("#_days").html("");
			}, function(){return;});
			return;
		}else{
			layer.confirm(message, {btn: ['确定'] }, function(index){layer.close(index);}, function(){return;});
			return;
		}
	}
	
	function setChekcOut(ordNo,type,unionFlag){
		<shiro:lacksPermission name="roomstatus:htlRoomCheckOut:view">
		$.jBox.alert("暂无权限！");
		return;
		</shiro:lacksPermission>
		<shiro:lacksPermission name="roomstatus:htlRoomCheckOut:edit">
		$.jBox.alert("暂无权限！");
		return;
		</shiro:lacksPermission>
		layer.load();
		$.ajax({
	        url:"${ctx}/checkOutApply/setCheckOutDiagram",
	        type: "post",
	        data: {
	            "ordNo":ordNo,
	            "type":type,
	            "unionFlag":unionFlag,
	        },
	        success: function (result) {
	        	if(result.retCode=="999999")
	        		$.jBox.alert(result.retMsg);
	        	else{
	        		$.jBox.alert("设置成功!");
	        		reflashRoom(result.retMsg);
	        	}
	        	layer.closeAll('loading');
	   		}
		});
	}
	
	/**
	function cardLock(type,lockNo,checkTime,mainName,roomNo,roomTypeName,rentTypeName,date){
		var ts="";
		if(type=="0"){
			var noCef="locker://newcard&锁号&00&入住时间+离店时间&主客姓名&0&房号&房型名称&租类名称&入住天数";
		}
		if(type=="1"){
			var noCef="locker://cleancard&锁号&房号&房型名称&&";
		}
	}**/
	
	function getRoomInfo(obj){
		var roomState=$(obj).attr("roomState");
		var tempStatus = $(obj).attr("tempStatus");
        //console.log(tempStatus);
		//空房
		if(roomState=="01"){
			$.ajax({
		        url:"${ctx}/diagram/getEmptyRoomTempStatus",
		        type: "post",
		        dataType: "json",
		        async: false,
		        data: {
		            "roomId":$(obj).attr("roomId"),
		            "tempStatus":tempStatus		            
		        },
			    success: function (result) {
			    	if(result!=null){
						var htm= '<div class="mb10">';
			        	htm+='<p class="">【房号】'+$(obj).attr("roomno")+'</p>';
			        	htm+='<p class="">【开始人】'+result.startName+'</p>';
			        	htm+='<p class="">【开始时间】'+result.startTime+'</p>';
			        	if(tempStatus=="0"){
				        	htm+='<p class="">【临时态】'+result.tempRemarks+'</p>';//临时态
			        	}			
						htm+='</div><div class="godet"></div>';
						$('#'+$(obj).attr("id")+' .room-message').html(htm).show();
			    	}
			    }
			});
		}
		//入住房
		if(roomState=="02"){
			$.ajax({
		        url:"${ctx}/diagram/getCheckInInfo",
		        type: "post",
		        dataType: "json",
		        async: false,
		        data: {
		            "ordId":$(obj).attr("orderno"),
		            "roomId":$(obj).attr("roomId"),
		            "tempStatus":tempStatus		            
		        },
		        success: function (result) {
		        	var htm= '<div class="mb10">';
		        	htm+='<p class="">【房单号】'+result.ordId+'</p>';
		        	htm+='<p class="">【房号】'+result.roomNo+'</p>';
		        	htm+='<p class="">【租类】'+result.rentType+'【预计房费】'+result.price+'</p>';
					if(result.thirdType!=null)
						htm+='<p class="">【'+result.thirdType+'】'+result.thirdValue+'</p>';
					htm+='</div>';
					htm+='<div class="mb10">';
					htm+='<p class="">【姓名】'+result.name+'</p>';
					htm+='<p class="">【联系方式】'+result.phone+'</p>';
					htm+='<p class="">【入住时间】'+result.checkInDate+'</p>';
					htm+='<p class="">【离店时间】'+result.checkOutDate+'</p>';
					htm+='<p class="">【总收款】'+result.giveMoney+'【预授权】'+result.preAuth+'</p>';
					htm+='<p class="">【余额】'+result.balance+'【总消费】'+result.consume+'</p>';
					htm+='<p class="">【备注】'+result.memo+'</p>';
					if(tempStatus=="0"){
			        	htm+='<p class="">【临时态】'+result.tempRemarks+'</p>';//临时态
		        	}
					htm+='</div>';
					if(result.unionId!=null){
						htm+='<div class="mb10">';
						htm+='<p class="">【团队】'+result.unionName+'</p>';
						htm+='<p class="">【联系人】'+result.unionPhone+'</p>';
						htm+='<p class="">【联房信息】'+result.unionRooms+'</p>';
						htm+='<p class="">【联房收款】'+result.unionGiveMoney+'【联房预授权】'+result.unionPreAuth+'</p>';
						htm+='<p class="">【联房余额】'+result.unionBalance+'【联房总消费】'+result.unionConsume+'</p>';
						htm+='</div>';
					}					
					htm+='<div class="godet"></div>';
					$('#'+$(obj).attr("id")+' .room-message').html(htm).show();
		   		}
			});
		}
		//预留房
		if(roomState=="03"){
			$.ajax({
		        url:"${ctx}/diagram/getReserveInfo",
		        type: "post",
		        dataType: "json",
		        async: false,
		        data: {
		            "roomType":$(obj).attr("roomtype"),
		            "roomNo":$(obj).attr("roomno"),
		            "unionReserveId":$(obj).attr("orderno"),
		            "roomId":$(obj).attr("roomId"),
		            "tempStatus":tempStatus
		        },
		        success: function (result) {
		        	var htm= '<div class="mb10">';
		        	htm+='<p class="">【预订单号】'+result.unionReserveId+'</p>';
		        	htm+='<p class="">【房号】'+result.roomNo+'</p>';
		        	htm+='<p class="">【租类】'+result.rentType+'【预计房费】'+result.price+'</p>';
					htm+='</div>';
					htm+='<div class="mb10">';
					htm+='<p class="">【预订人】'+result.name+'</p>';
					htm+='<p class="">【预定联系方式】'+result.phone+'</p>';
					htm+='<p class="">【保留时间】'+result.reserveDate+'</p>';
					htm+='<p class="">【担保类型】'+result.assureTypeName+'</p>';
					htm+='<p class="">【订单来源】'+result.reserveSource+'</p>';
					htm+='<p class="">【定金】'+result.ordPrice+'</p>';
					if(tempStatus=="0"){
			        	htm+='<p class="">【临时态】'+result.tempRemarks+'</p>';//临时态
		        	}
					htm+='</div>';
					htm+='<div class="godet"></div>';
					$('#'+$(obj).attr("id")+' .room-message').html(htm).show();
		   		}
			});
		}
		//维修房/保留房
		if(roomState=="04"||roomState=="05"){
			$.ajax({
		        url:"${ctx}/diagram/getRepairOrRetainInfo",
		        type: "post",
		        dataType: "json",
		        async: false,
		        data: {
		            "roomState":roomState,
		            "roomId":$(obj).attr("roomId"),
		            "tempStatus":tempStatus
		        },
		        success: function (result) {
		        	var htm= '<div class="mb10">';
		        	htm+='<p class="">【房号】'+$(obj).attr("roomno")+'</p>';
		        	htm+='<p class="">【开始人】'+result.startName+'</p>';
		        	htm+='<p class="">【开始时间】'+result.startTime+'</p>';
		        	if(roomState=="04")
		        		htm+='<p class="">【维修原因】'+result.reason+'</p>';
		        	if(roomState=="05")
		        		htm+='<p class="">【保留原因】'+result.reason+'</p>';
		        	htm+='<p class="">【备注】'+result.remarks+'</p>';
		        	if(tempStatus=="0"){
			        	htm+='<p class="">【临时态】'+result.tempRemarks+'</p>';//临时态
		        	}
					htm+='</div>';					
					htm+='<div class="godet"></div>';
					$('#'+$(obj).attr("id")+' .room-message').html(htm).show();
		   		}
			});
		}
	}	
	
	/*维修完成*/
	function selRepairFinish(roomId,roomNo){
		var url = "htlRepairFinishedLoad";
		var titleName ="维修完成";
		top.$.jBox.open(
            "iframe:${ctx}/roomstatus/htlRoomStatus/" + url + "?eventName="+eventName + "&roomid=" + roomId +"&roomNo=" + roomNo,
            titleName,
	        1000,
	        $(top.document).height() - 180,
	        {
	            buttons: {},
	            loaded: function (h) {
	                $(".jbox-content", top.document).css("overflow-y", "hidden");
	            },
                closed: function () {
                	reflashRoom(roomId);
                }	            
	        }
	    );
	}	
	
	/*保留完成*/
	function selReserveFinish(roomId,roomNo){
		var url = "htlReserveFinishedLoad";
		var titleName ="保留完成";
		top.$.jBox.open(
            "iframe:${ctx}/roomstatus/htlRoomStatus/" + url + "?eventName="+eventName + "&roomid=" + roomId +"&roomNo=" + roomNo,
            titleName,
	        1000,
	        $(top.document).height() - 180,
	        {
	            buttons: {},
	            loaded: function (h) {
	                $(".jbox-content", top.document).css("overflow-y", "hidden");
	            },
                closed: function () {
                	reflashRoom(roomId);
                }	            
	        }
	    );
	}	
	
	/*新增/完成 临时态*/
	function newTempStatus(roomId,roomNo,isFinished){
		var url = isNull(isFinished)?"htlNewTempLoad":"htlTempStatusFinishedLoad";
		var titleName = isNull(isFinished)?"新增临时态":"完成临时态";
		top.$.jBox.open(
            "iframe:${ctx}/roomstatus/htlRoomStatus/" + url + "?eventName="+eventName + "&id=" + roomId + "&roomNo=" + roomNo,
            titleName,
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
	
	function isNull(str){
		return str==null||str=="";
	}
	</script>
</head>
</html>