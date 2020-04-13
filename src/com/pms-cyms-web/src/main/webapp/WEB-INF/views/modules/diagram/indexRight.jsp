<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>房态图</title>
	<meta name="decorator" content="default"/>
	<link rel="stylesheet" href="${ctxStatic}/diagram/css/diagram.css?v=2" type="text/css" />
	<script type="text/javascript">
		//事件名称保持唯一，这里直接用tabId
	    var eventName="index";
		$(document).ready(function() {
	        //解绑事件
	        top.$.unsubscribe(eventName);
	        //注册事件，弹出页面需要刷新本页面，或者弹出页面回传数据用
	        top.$.subscribe(eventName, function (e, data) {
	            //data  可以通过这个对象来回传数据
	            if (data.roomList != null && data.roomList != undefined && data.roomList != '') {
	        		if(data.roomList.tableId!=null){
	        			reflashRoom(data.roomList.tableId);
	        			getOrder(data.roomList.tableId,data.roomList.tableNo,data.roomList.orderId);
	        		}else{
	        			reflashRoom(data.roomList);	
	        		}
	            } else if(data.reload) {
	            	window.location.reload();
	            }
	        });
	        
			$("#floatShow").bind("click", function(){
				$("#onlineService").animate({
					width: "show",
					opacity: "show"
				}, "normal", function() {
					$("#onlineService").show();
				});
				$("#floatShow").attr("style", "display:none");
				$("#floatHide").attr("style", "display:block");
				return false;
			});
			
			$("#r_layer").bind("click", function(){
				$("#onlineService").animate({
					width: "hide",
					opacity: "hide"
				}, "normal", function() {
					$("#onlineService").hide();
				});
				$("#floatShow").attr("style", "display:block");
				$("#floatHide").attr("style", "display:none");
				return false;
			});
			
			tableTypeMap = {};
			<c:forEach items="${tableTypeMap}" var="rt">
				tableTypeMap["${rt.key}"]="${rt.value}";
			</c:forEach>
			
			parent.layer.closeAll('loading');
		});
		
		function reflashRoom(roomnoList, syncToQD){
			layer.load();
			for(var i=0;i<roomnoList.split(",").length;i++){
				$.ajax({
			        url:"${ctx}/diagram/reflashRoom",
			        type: "post",
			        dataType: "json",
			        data: {
			            "tableId":roomnoList.split(",")[i]
			        },
			        success: function (result) {
			        	if(result!=null){
							var htm="";
							htm+='<li class="ftt fttsize" id="rooms-'+result.tableId+'" building="'+result.building+'" floor="'+result.floor+'" tableId="'+result.tableId+'" ';
							htm+=' tableNo="'+result.tableNo+'" tableStatus="'+result.tableStatus+'" orderId="'+result.orderId+'" isUnion="'+result.isUnion+'" ';
							htm+=' style="background-color: '+result.color+'" ';
							htm+=' onclick="roomClickShow(this,event)" ondblclick="getRooms(this)" onmousedown="bindingInfo(this)" onmouseover="validateRoomStatus(this)" >';
							htm+=' <a href="#" class="fttsize"><div class="lump-left"><span class="lump-number">'+result.tableNo+'</span>';
							if (tableTypeMap[result.tableTypeId] != null && tableTypeMap[result.tableTypeId] != undefined && tableTypeMap[result.tableTypeId] != '') {
								htm+=' <span class="">'+tableTypeMap[result.tableTypeId]+'</span><span class="">';
							}
							if (result.unionName != null && result.unionName != undefined && result.unionName != '') {
								htm+='('+result.unionName+')</span><span class="">';
							}
							if (result.name != null && result.name != undefined && result.name != '') {
								htm+=result.name;
							}
							htm+=' </span></div><div class="lump-right"><span class="">';
							if (result.joint != null && result.joint != undefined && result.joint != '') {
								htm+='<i class="fa fa-chain"></i>';
							}
							if (result.dirty == '1') {
								//htm+='<i class="fa fa-trash-o"></i>';
							}
							htm+='</span></div>';
							if(result.joint!=''&&result.joint!=null&&typeof(result.joint) != "undefined")
								htm+='<div class="fttsizeA unionSelected_'+result.joint+'" style="display: none;">';
							else
								htm+='<div class="fttsizeA" style="display: none;">';
							htm+='</div> </a>';
							htm+='<div class="room-message" tableId="rooms-${rooms.tableId}"></div></li>'
							$("#rooms-"+result.tableId).replaceWith(htm);
							reflashRightMenu(result.tableId);
							bindFttSize();
							if(result.oldRoomState!=null&&result.oldRoomState!=result.tableStatus){
								changeRoomState(result.oldRoomState,result.tableStatus);
							}
						}
			        	layer.closeAll('loading');
			        	faClockO();
			        	
			        	if(top.m_qudian==1 && syncToQD && result.tableStatus=="02"){	//电控，确保在住房有电
			        		var $obj = $(obj);
			        		top.synRoomStateToQD($("#rooms-"+result.tableId), true);
			        	}
			   		}
				});
			}
		}
		
		function changeRoomState(oldRoomState,tableStatus){
			$("#roomState_"+oldRoomState).html($("#roomState_"+oldRoomState).html()-1);
			$("#roomState_"+tableStatus).html($("#roomState_"+tableStatus).html()-(-1));
		}
		
		function reflashAllRooms(){		//刷新所有台态
            $(".ftt").each(function(){
                reflashRoom($(this).attr("tableId"));
            });
            window.location.reload();
		}
		
		function getRooms(obj) {
			if(clickTimer) {
				window.clearTimeout(clickTimer);
				clickTimer = null;
			}
			if ($(obj).attr("tableStatus")=="reserve") {
				//预定
				reserveDetails($(obj).attr("tableId"),$(obj).attr("tableNo"),$(obj).attr("orderId"));
			}else if($(obj).attr("tableStatus")=="cleanEmpty"){
				//空
				checkIn($(obj).attr("tableId"),$(obj).attr("tableNo"),$(obj).attr("tableTypeId"));
			}else if($(obj).attr("tableStatus")=="checkIn"){
				//在用
				getOrder($(obj).attr("tableId"),$(obj).attr("tableNo"),$(obj).attr("orderId"));
			}else if($(obj).attr("tableStatus")=="06"){
				//脏房双击
				layer.confirm('该房间为脏房，是否确定办理入住？', {
					  btn: ['确定','取消'] 
					}, function(){
						checkIn($(obj).attr("tableId"),$(obj).attr("tableNo"),$(obj).attr("tableTypeId"));
						layer.closeAll();
					}, function(){
					}
				)
			}
		}
		
		function getOrder(tableId,tableNo,orderId){
            $.jBox.open(
            	"iframe:${ctx}/order/checkIn/ordTableIndexInit?storeId=${param.storeId}&tableId="+tableId+"&tableNo="+tableNo+"&orderId="+orderId,
             	"单号："+orderId,
            	/* 1190,
             	580, */
             	$(window).width()-5,
                $(window).height()-7,
                {
	                buttons: {},//"返回":"0"
	                //bottomText: '坐标长沙',
	                opacity:0,
        			showClose: false,
        			draggable: false,
        			showType:"show",
	                loaded: function (h) {
	                	//$(".jbox-content", top.document).css("overflow-y", "hidden");
	                	$(".jbox-content").css("overflow-y", "hidden");
	                },
	                closed:function (){
	                	var roomIds = cookie("roomIds");
	                	if(roomIds!=null){
	                		reflashRoom(roomIds);	                		
	                	}
	                	var minusRoomIds = cookie("minusRoomIds");
	                	if(minusRoomIds!=null){
	                		reflashRoom(minusRoomIds);	                		
	                	}
	                	cookie("roomIds",null,{path:'/',expires:-1});
	                	cookie("minusRoomIds",null,{path:'/',expires:-1});
	                	cookie("ordIndex",null,{path:'/',expires:-1});
	                	cookie("tabIndex",null,{path:'/',expires:-1});
	                }
                }
			);
		}
		
		function checkIn(tableId,tableNo,tableTypeId){
			<shiro:lacksPermission name="index:order:checkIn">
			layer.alert("暂无权限！");
			return;
			</shiro:lacksPermission>
			
            top.$.jBox.open(
            	"iframe:${ctx}/order/checkIn/checkInInit?storeId=${param.storeId}&tableId="+tableId,
            	"开台",
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
		
		function reserveDetails(tableId,tableNo,reserveId) {
			top.$.jBox.open(
				"iframe:${ctx}/reserve/ordReserveDetails?reserveId=" + reserveId+"&storeId=${param.storeId}&depositAmount=&tableCount=1",
				"预订单："+reserveId,
				1000, 
				$(top.document).height() - 180, {
					buttons : {},
					loaded : function(h) {
						$(".jbox-content",top.document).css("overflow-y","hidden");
					}
				});
		}
		
		function teamCheckIn(){
			<shiro:lacksPermission name="order:teamCheckIn">
			layer.alert("暂无权限！");
			return;
			</shiro:lacksPermission>
			
            top.$.jBox.open(
                "iframe:${ctx}/checkIn/teamCheckIn",
                "团队入住",
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
		
		//批量设置房态
		function setBatchRooms(tableId,tableNo,tableTypeId){
			<shiro:lacksPermission name="order:setbatch:roomstatus">
			layer.alert("暂无权限！");
			return;
			</shiro:lacksPermission>
			
            top.$.jBox.open(
            	"iframe:${ctx}/diagram/linkToSetBatchRoom?eventName=" + eventName,
            	"批量设置房态",
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
		
		//验证房间状态，同步数据库
		function validateRoomStatus(obj){
			//增加一步：联房样式
			var unionId=$(obj).attr("isUnion");
			$(".fttsizeA").css("display","none");
			if(unionId!=null&&unionId!=""){
				$(".unionSelected_"+unionId).css("display","");
			}else{
				$(".fttsizeA").css("display","none");
			}
			$.ajax({
		        url:"${ctx}/diagram/validateRoomStatus",
		        type: "post",
		        dataType: "json",
		        data: {
		            "tableId":$(obj).attr("tableId"),
		            "tableStatus":$(obj).attr("tableStatus")
		        },
		        success: function (result) {
		        	if(result){
		        		reflashRoom($(obj).attr("tableId"), true);
		        	}
		   		}
			});
		}
	
		function bindingInfo(obj){
			$(".dropdown-menu").remove();
			$('.room-message').hide();
			reflashRightMenu($(obj).attr("tableId"));
		}
		var hide = false;
		var clickTimer = null;
		function roomClickShow(val,event){
			if(clickTimer) {
		          window.clearTimeout(clickTimer);
		          clickTimer = null;
		      }
		      clickTimer = window.setTimeout(function(){
					if($(val).find('.room-message').css('display') == 'none'){
						var tableId=$(val).attr("id");
						$('.room-message').html('').hide();
						getRoomInfo(val);			
						var e = event==undefined?window.event:event;
			            var scrollX = document.documentElement.scrollLeft || document.body.scrollLeft;
			            var scrollY = document.documentElement.scrollTop || document.body.scrollTop;
			            var x=y=0;
			            x = e.pageX ;
			            y = e.pageY ;
			            if(y > ($(document).height() - $('#'+tableId+' .room-message').height())){
							if(x > ($(document).width() - 200)){
								$('.room-message').css({
									"left":"-160px",
									"top":'-'+($('#'+tableId+' .room-message').height()/2-100)+'px'
								})
							}else{
								$('.room-message').css({
									"left":"50px",
									"top":'-'+($('#'+tableId+' .room-message').height()/2-100)+'px'
								})
							}
							if(y > ($(document).height() - 130)){
								if(x > ($(document).width() - 200)){
									$('.room-message').css({
										"left":"-160px",
										"top":'-'+($('#'+tableId+' .room-message').height()-30)+'px'
									})
								}else{
									$('.room-message').css({
										"left":"50px",
										"top":'-'+($('#'+tableId+' .room-message').height()-30)+'px'
									})
								}
							}
			            }else{
			            	if(x > ($(document).width() - 200)){
								$('.room-message').css({
									"left":"-160px",
									"top":"50px"
								})
							}else{
								$('.room-message').css({
									"left":"50px",
									"top":"50px"
								})
							}
			            } 
					}else{
			        	$(val).find('.room-message').css('display','none'); 
			        }
		      }, 300);
		}
		function roomHide(obj){
			//var tableId=$(obj).attr("tableId");
			//$('#'+obj+' .room-message').hide()	
		}
		function roomShow(obj){
			/* var tableId=$(obj).attr("tableId");
			$('#'+tableId+' .room-message').show()	 */
		}
		$(document).ready(function(){
			var left = $(document).width()/2-450;
			var top = $(document).height()/2-150;
			$('.Card .box').css({
				left:left,
				top:top
			});				
		})
		function cardHide(card){
			$('.'+card).hide();
		}
	</script>
	<style>
		.room-message{
			display:none;
			width: 200px;
			background-color: #fff;
			border-radius: 3px;
			position: absolute;
			top: 50px;
			left: 100px;
			padding: 5px;
			border: 1px solid #ddd;
			z-index:999;
			cursor: pointer;
			text-align: left;
			/* pointer-events:none; */
		}
		.room-message .godet{
			height:0;
		}
		.room-message .mb10{
			margin-bottom: 10px;
		}
		.room-message p{
			margin: 0;
		}
		.Card{
			display: none;
		    position: absolute;
		    top: 0;
		    left: 0;
		    width: 100%;
		    background-color: rgba(0,0,0,.5);
		    height: 100%;
		}
		.Card .box{
			position: absolute;
		    top: 30%;
		    left: 30%;
		    width: 550px;
		    background-color: #fff;
		    height: 300px;
		}
		.Card .box .title{
			height: 40px;
			line-height: 40px;
		    text-align: center;
		    background-color: #ee5f5b;
		    color: #fff;
		}
		.Card .box .title h4,.Card .box .title .card-close{
			display: inline-block;
		}
		.Card .box .title .card-close{
			float: right;
			font-size: 40px;
			margin-top: -2px;
			cursor: pointer;
		}
		.Card .box .title .card-close:hover{
			color:#ddd;
		}
		.Card .box .row{
			padding: 0 10px;
			margin-top: 20px;
		}
		.span2{
			width: 150px;
		}
		.span3{
			text-align: center;
		}
		.Card .box .row span{
			display: inline-block;
			border-bottom: 1px solid #eee;
			width: 105px;
			text-align: left;
		}
		.box .btns{
			margin-top: 80px;
			text-align: center;
		}
		.box .btns .btn{
			width: 80px;
		}
		.ftt-length {
			float: right;
			margin-right: 30px;
			color: red;
		}
		.ftt-length span{
			font-size: 1rem;
		}
	</style>
</head>
<body>
<jsp:include page="./rightMenu.jsp?checkType=single"></jsp:include>
<div id="content" class="row-fluid">
	<div id="right" style="position:relative;">
	<div class="lump_homepage">
		<ul class="lump">
			<c:forEach items="${tableInfoList}" var="rooms" varStatus="flag">
				<!-- 楼层排序 -->
				<c:if test="${flag.index!=0 &&tableInfoList[flag.index-1].floor!=rooms.floor&&(!empty settings.loucengpaixu)}">
					<ul class="lump">
						<div class="lump-floors floor_ul" style="clear: both;text-align: left;" floor="${rooms.floor}">${floorNameMap[rooms.floor]}</div>
					</ul>
				</c:if>
				<c:if test="${flag.index==0&&(!empty settings.loucengpaixu)}">
					<ul class="lump">
						<div class="lump-floors floor_ul" style="clear: both;text-align: left;" floor="${rooms.floor}">${floorNameMap[rooms.floor]}</div>
					</ul>
				</c:if>
				<!-- 楼层排序结束 -->	
				<!-- 房态图 -->
				<li class="ftt fttsize" id="rooms-${rooms.tableId}" building="${rooms.building}" floor="${rooms.floor}" tableId="${rooms.tableId}"
	        		tableNo="${rooms.tableNo}" tableStatus="${rooms.tableStatus}" orderId="${rooms.orderId}"  isUnion="${rooms.joint}"
					style="background-color: ${rooms.color}" 
					onclick="roomClickShow(this,event)" ondblclick="getRooms(this)" onmousedown="bindingInfo(this)" onmouseover="validateRoomStatus(this)" 
					>	
					<a href="#" class="fttsize">
						<div class="lump-left">
							<span class="lump-number">${rooms.tableNo}-${rooms.tableName}</span>
							<span class=""><c:if test="${!empty tableTypeMap[rooms.tableTypeId]}">${tableTypeMap[rooms.tableTypeId]}</c:if></span>
							<span class=""><c:if test="${!empty rooms.unionName}">(${rooms.unionName})</c:if></span>
							<span class="">${rooms.name}</span>
						</div>
						<div class="lump-right">
							<span class="">
								<c:if test="${!empty rooms.joint}">
									<i class="fa fa-chain"></i>
								</c:if>
							</span>
							<span class="">
								<!--<c:if test="true">
									<i class="fa fa-trash-o"></i>
								</c:if>-->
							</span>
						</div>
						<div class="fttsizeA <c:if test="${!empty rooms.joint}">unionSelected_${rooms.joint}</c:if>" style="display: none;"></div> 
					</a>
					<div class="room-message" tableId="rooms-${rooms.tableId}"></div>
				</li>
			</c:forEach>
		</ul>
	</div>
	
	<!--content_bottom-->
	<div class="lump_fix">
		<div class="lump_colors">
			<em style="background-color:${settings.disabled}">停用</em>
			<a href="#"><b id="roomState_disabled">${statusCount.disabled}</b>台</a>
		</div>
		<div class="lump_colors">
			<em style="background-color:${settings.cleanEmpty}">空台</em>
			<a href="#"><b id="roomState_cleanEmpty">${statusCount.cleanEmpty}</b>台</a>
		</div>
		<div class="lump_colors">
			<em style="background-color:${settings.reserve}">预订</em>
			<a href="#"><b id="roomState_reserve">${statusCount.reserve}</b>台</a>
		</div>
		<div class="lump_colors">
			<em style="background-color:${settings.checkIn}">用餐</em>
			<a href="#"><b id="roomState_openIn">${statusCount.checkIn}</b>台</a>
		</div>
		<div class="lump_colors">
			<!-- <button id="pop_ruzhu" onclick="checkIn()" <shiro:lacksPermission name="index:order:openIn">disabled</shiro:lacksPermission> class="btn btn-success">入住登记</button>
			<button id="pop_tm" onclick="teamCheckIn()" <shiro:lacksPermission name="order:teamCheckIn">disabled</shiro:lacksPermission> class="btn btn-danger">团队入住</button>
			<button id="set_batch_rooms" onclick="setBatchRooms();"  class="btn btn-danger">批量设置房态</button> -->
			<button id="reflash_rooms" onclick="reflashAllRooms()"  class="btn btn-danger">刷新台态</button>
		</div>
		<div class="ftt-length">当前选中餐台数：<span></span></div>
	</div>
		
	<!--右侧标签隐藏栏
	<div id="r_layer">
		<div id="r_tab">
			<a id="floatShow" style="display:block;" href="javascript:void(0);">收缩</a>
			<a id="floatHide" style="display:none;" href="javascript:void(0);">展开</a>
		</div>
		<div id="onlineService">
			<div class="onlineMenu">
				<ul>
					<li><i class="fa fa-chain"></i>联房&nbsp;&nbsp;&nbsp;</li>
					<li><i class="fa fa-vimeo" aria-hidden="true"></i>会员</li>
					<li><img src="${ctxStatic}/room/images/arrearage-02.png" style="width: 10px; height: 12px; margin-right: 3px;" />欠费&nbsp;&nbsp;&nbsp;</li>
					<li><i class="fa fa-trash-o"></i>脏房</li>
					<li><i class="fa fa-shopping-bag" aria-hidden="true"></i>借物&nbsp;&nbsp;&nbsp;</li>
					<li><i class="fa fa-clock-o"></i>钟点房</li>
					<li><i class="fa fa-moon-o"></i>午夜房</li>
					<li><i class="fa fa-arrow-right"></i>预离房</li>
					<li><i class="fa fa-map-marker"></i>预留房</li>
					<li><img src="${ctxStatic}/room/images/temp-status-flag2.png" style="width: 12px; height: 14px; margin-right: 1px;" />临时态</li>
					<li><i class="fa fa-share-square-o" aria-hidden="true"></i>待查退</li>
					<li><i class="fa fa-check-square-o" aria-hidden="true"></i>已查退</li>
					<li><i class="fa fa-user"></i>有人&nbsp;&nbsp;&nbsp;</li>
					<li><i class="fa fa-bell-slash" aria-hidden="true"></i>勿扰</li>
				</ul>
			</div>
		</div>
	</div>-->
	</div>
</div>
<!-- 发卡 -->
<div class="Card">
	<div class="box">
		<div class="title">
			<h4 id="lockTitle">门锁发卡</h4>
			<span class="card-close" onclick="cardHide('Card')">×</span>
		</div>
		<div class="row">
			<div class="span2">
				<label>房号：</label>
				<span id="_roomNo"></span>
			</div>
			<div class="span3">
				<label>房型：</label>
				<span id="_roomTypeName"></span>
			</div>
			<div class="span2">
				<label>租类：</label>
				<span id="_rentTypeName"></span>
			</div>			
		</div>
		<div class="row">			
			<div class="span2">
				<label>住客：</label>
				<span id="_name"></span>
			</div>
			<div class="span3">
				<label>离店：</label>
				<span id="_checkOutDateTime"></span>
			</div>
			<div class="span2">
				<label>天数：</label>
				<span id="_days"></span>
			</div>
		</div>
		<input type="hidden" id="_lockNo2" />
		<input type="hidden" id="_checkTime2" />
		
		<input type="hidden" id="_roomNo2" />
		<input type="hidden" id="_roomTypeName2" />
		<input type="hidden" id="_rentTypeName2" />
		<input type="hidden" id="_name2" />
		<input type="hidden" id="_checkOutDateTime2" />
		<input type="hidden" id="_days2" />
		<div class="btns">
			<button class="btn btn-warning" id="newCardBtn" onclick="writeCardBtn();">发卡</button>
			<button class="btn btn-warning" id="copyCardBtn" onclick="copyCardBtn();">复制卡</button>
			<button class="btn btn-warning" id="readCardBtn" onclick="readCardBtn();">读卡</button>
			<button class="btn btn-warning" id="cleanCardBtn" onclick="cleanCardBtn();">清卡</button>
		</div>
	</div>
</div>
	<script type="text/javascript">
		var leftWidth = 220; // 左侧窗口大小
		var htmlObj = $("html"), mainObj = $("#main");
		var frameObj = $("#left, #openClose, #right, #right iframe");
		function wSize(){
			var strs = getWindowSize().toString().split(",");
			htmlObj.css({"overflow-x":"hidden", "overflow-y":"hidden"});
			mainObj.css("width","auto");
			frameObj.height(strs[0] - 5);
			$(".lump_homepage").height(strs[0] - 45);
			var leftWidth = ($("#left").width() < 0 ? 0 : $("#left").width());
			$("#right").width($("#content").width()- leftWidth - $("#openClose").width() -5);
			//$(".ztree").width(leftWidth - 10).height(frameObj.height() - 46);
			$('.ftt-length span').html($('#right li.fttsize').length)
		};
		
		//调整钟点房图标样式
		function faClockO(){
			var liw = $('.lump li.fttsize').width();
			var lih = $('.lump li.fttsize').height();
			var iconw = $('.lump li.fttsize .fttsize .fa-clock-o').width();
			var iconh = $('.lump li.fttsize .fttsize .fa-clock-o').height();
			$('.lump li.fttsize .fttsize .fa-clock-o').css({
				"position":"absolute",
				"right":((liw/2)-(iconw/2))+'px',
				"top": ((lih/2)-(iconh/2))+'px',
				"z-index":"1"
			});
		}
		// 调整为前端可控型样式
		$(function() {
			bindFttSize();
			faClockO();
		});
		var sizeclass = {
			"0": {"width": "140px", "height": "75px",},
			"1": {"width": "160px", "height": "88px"},
			"2": {"width": "190px", "height": "108px"},
			"3": {"width": "110px", "height": "60px"}
		};
		var sizeAclass = {
			"0": {"width": "138px", "height": "73px"},
			"1": {"width": "158px", "height": "86px"},
			"2": {"width": "188px", "height": "106px"},
			"3": {"width": "108px", "height": "58px"}
		};
		function bindFttSize() {
			var mode="${settings.ftt_size}";
			$(".fttsize").css("width", sizeclass[mode]["width"]);
			$(".fttsize").css("height", sizeclass[mode]["height"]);
			$(".fttsizeA").css("width", sizeAclass[mode]["width"]);
			$(".fttsizeA").css("height", sizeAclass[mode]["height"]);
		}
	</script>
	<script src="${ctxStatic}/common/wsize.min.js" type="text/javascript"></script>
	<script src="${ctxStatic}/common/newfile5.js" type="text/javascript"></script>
	<script src="${ctxStatic}/room/context.js?V=29" type="text/javascript"></script>
	<script src="${ctxStatic}/room/rightMenu.js?V=124" type="text/javascript"></script>
</body>
</html>