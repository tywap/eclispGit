<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>订单</title>
	<meta name="decorator" content="default"/>
	<style>
		.nav{margin:0;}
		.nav-tabs{border-bottom:2px solid #F2DEDE;}
		.nav-tabs>li{width:80px;text-align:center;background:#b94a48c2;margin-left:5px;float:right;}
		.nav-tabs>li>a{padding:8px;color:#555;margin:0;border-radius:0;border:none;}
		.nav-tabs>li>a:hover{background-color: #FF9900;}
		.nav-tabs>.active>a, .nav-tabs>.active>a:hover, .nav-tabs>.active>a:focus{cursor: default;background-color: #FF9900;border:none;color:#555;}
		.tab-content{border:2px solid #F2DEDE;border-top:0;position: relative;}
		.form-horizontal{margin-bottom:0;}
		.fixed-btn{text-align:center;width:96%;margin-left:3px;padding:10px; background:#31B080;height:15px; line-height:15px;font-size:20px;font-weight:bold;color:#fff;cursor:pointer;}
		.fixed-btn i{font-size:24px;}
		.fixed-btn-hide{width:96%;height:40px;position:fixed;bottom:35px;left:3px;background:#31B080;padding:10px;}
		.fixed-btn-hide .btn{margin-bottom:5px;}
		.modus{margin-top: 20px;border: 1px solid #ddd; box-shadow: 5px 3px 5px #ddd;}
		.row-fluid [class*="span"]{margin-left: 0;}
		.tableText{
		    overflow-y: auto;
    		width: 100%;
    	}
		.modus ul li{
			list-style: none;
			line-height: 29px;
			text-align: center;
		}
		.modus ul li:hover{
			color: blue;
			cursor: pointer;
		}
		.modus ul li.active{
			color: blue;
		}
		.search{
			background-color: #b94a48;/*#b94a48c2*/
			position: relative;
			padding: 0 10px;
			height: 37px;
		}
		.search text{
			display: inline-block;
			line-height: 40px;
			color: #fff;
		}
		.search .input{
			display: inline-block;
			float: right;
			margin-top: 3.5px;	
			outline: none;		
		}
		.search .input button{
			position: absolute;
	    	right: 10px;
	    	bottom: 4px;
	    	outline: none;
    	}
    	#bottom .right{
    		float: right;
    	}
    	.total{
    	font-weight:bold;
    	display:inline-block;
    	width: 130px;
    	overflow:hidden;
    	text-overflow:ellipsis;
    	white-space:normal;
    	vertical-align:top;
    	}
	</style>
	<script type="text/javascript">
		//事件名称保持唯一，这里直接用tabId
	    var eventName="ordIndex";
	    var tabIndex = cookie("tabIndex");
	    tabIndex = (tabIndex == null?"tab0":tabIndex);
	    $(document).keydown(function(event){
	         //屏蔽F5刷新键 
	         if(event.keyCode==116){
	        	 $("#vcon").slideToggle();
	        	 return false;
	         }
	         if (event.keyCode==13) {
	        	 getFoodsByStoreId(event);
			}
	 	});
		$(document).ready(function(){
			top.$.unsubscribe(eventName);
    	    //注册事件，弹出页面需要刷新本页面，或者弹出页面回传数据用
    	    top.$.subscribe(eventName, function (e, data) {
    	    	getOrdConsumesByOrdId();
				getFoodsByStoreId(data);
				if (data.eventName == 'changeTable' || data.eventName =='combineTable') {
					window.parent.reflashAllRooms();
    	    		window.parent.jBox.close();
				}
    	    });
			if($('.tableNo').width() > 400){
				//$('.tableNo').css({'clear':'both',"float": "inherit"});
				//$('.fixed-detail-money').css({'bottom':'86px'});
				$('.tab-content').css({'height': $(window).height()-130+'px'}); //365px
				$('.tableText').css({'height': $(window).height()-130+'px'}); //310px
			}
			$('.tab-content').css({'height': $(window).height()-130+'px'});
			$('.tableText').css({'height': $(window).height()-130+'px'});
			//初始化界面
			var isUnion = '0';
			var storeId = '${storeId}';
			var orderId = '${orderId}';
			var tableId = '${tableId}';
			var tableNo = '${tableNo}';
			//tab切换
			$('#tab a').click(function (e) {
			  	e.preventDefault();//阻止a链接的跳转行为 
			  	$(this).tab('show');
			  	var temp = $(this).data("id");
			  	cookie("tabIndex",temp,{path:'/',expires:1});
			});
			//点击tab			
			$("#tab a[href='#"+tabIndex+"']").click();
			//F5配置
			$("#toggle-btn").click(function() {
				$("#vcon").slideToggle();
			});
			
			var i=0;
	        //全选
	        $(".weeksAll").on("click",function(){
	            if(i==0){
	            	$(".weeksAll").prop("checked", true);
	                //把所有复选框选中
	                $(".weeks").prop("checked", true);
	                i=1;
	            }else{
	                $(".weeks").prop("checked", false);
	                i=0;
	            }
	            
	        });
			
			//押金
			$("input[name='ordDepositBtn']").bind("click",function(){
				top.$.jBox.open(
                   "iframe:${ctx}/order/ordDeposit/ordDeposit?eventName="+eventName+"&storeId="+storeId+"&isUnion="+isUnion+"&orderId="+orderId+"&tableId="+tableId+"&tableNo="+tableNo,
                   "押金",
                   1150,
                   560,
                   {
                       buttons: {},
                       loaded: function (h) {
                           $(".jbox-content", top.document).css("overflow-y", "hidden");
                       }
                   }
               );
			});
			//部分结账
			$("input[name='checkOutPartBtn']").bind("click",function(){
				top.$.jBox.open(
                   "iframe:${ctx}/order/checkOut/checkOutPart?eventName="+eventName+"&storeId="+storeId+"&isUnion="+isUnion+"&orderId="+orderId+"&tableId="+tableId+"&tableNo="+tableNo,
                   "部分结账",
                   1150,
                   560,
                   {
                       buttons: {},
                       loaded: function (h) {
                           $(".jbox-content", top.document).css("overflow-y", "hidden");
                       }
                   }
               );
			});
			//px
			$("input[name='checkOutPXBtn']").bind("click",function(){
				var type = $(this).data("id");
				var name = $('input[name="itemCheckBoxBtn"]');
				for (var i = 0; i < name.length; i++) {
					if (name[i].value=="0") {
						layer.alert("账单内有未下单菜品，请先下单再PX！");
						return;
					}
				}
				top.$.jBox.open(
                   "iframe:${ctx}/order/checkOut/checkOutPX?eventName="+eventName+"&storeId="+storeId+"&isUnion="+isUnion+"&orderId="+orderId+"&tableId="+tableId+"&tableNo="+tableNo,
                   "整单PX",
                   1150,
                   560,
                   {
                       buttons: {},
                       loaded: function (h) {
                           $(".jbox-content", top.document).css("overflow-y", "hidden");
                       },
                       closed:function (){
                      		window.location.reload();
	 	               }
                   }
               );
			});
			//结账
			$("input[name='checkOutBtn']").bind("click",function(){
				var type = $(this).data("id");
				var name = $('input[name="itemCheckBoxBtn"]');
				for (var i = 0; i < name.length; i++) {
					if (name[i].value=="0") {
						layer.alert("账单内有未下单菜品，请先下单再结账！");
						return;
					}
				}
				top.$.jBox.open(
                   "iframe:${ctx}/order/checkOut/checkOut?eventName="+eventName+"&storeId="+storeId+"&isUnion="+isUnion+"&orderId="+orderId+"&tableId="+tableId+"&tableNo="+tableNo,
                   "结账",
                   1150,
                   560,
                   {
                       buttons: {},
                       loaded: function (h) {
                           $(".jbox-content", top.document).css("overflow-y", "hidden");
                       },
                       closed:function (){
                       		window.location.reload();
	 	               }
                   }
               );
			});
			
			$("input[name='printBtn']").bind("click",function(){
				layer.confirm('是否打印对账单？', {
					  btn: ['确定','取消'] 
				}, function(){
					window.open("${ctx}/print/printCheckOut?ordId="+orderId);
					/* top.$.publish(eventName,{testData:"hello"}); */
			    	/*  window.parent.jBox.close(); */
					layer.close(layer.index);
				}, function(){
					/* top.$.publish(eventName,{testData:"hello"}); */
			    	/* window.parent.jBox.close(); */
				});
			});
			//查询菜品小类
			getFoodTypesByStoreId();
			
			//传菜、下单
			$("input[name='chuancaiBtn']").bind("click", function() {
				var cks = $("input[name='itemCheckBoxBtn']:checked");
				var foods = [];
				for(var i=0;i<cks.length;i++){
					var obj = cks[i];
					var jsonStr = $(obj).parent().parent().find("[name='obj']").val();
					var obj = JSON.parse(jsonStr);
					if(obj.status=='1'){
						layer.alert("菜品："+obj.name+"已下单，请勿重复下单！");
						return;
					}else if(obj.status=='2'){
						layer.alert("菜品："+obj.name+"已退单，无法下单！");
						return;
					}
					var id = obj.id;
					var foodId = obj.foodId;
					var foodName = obj.name;
					var num = obj.count;
					var remarks = (obj.remarks==undefined?'':obj.remarks);
					var printers = (obj.printer==undefined?'':obj.printer);
					var modus=obj.cookValues+obj.cookValuesTemp;
					var food ={'id':id,'foodId':foodId,'foodName':foodName,'num':num,'remarks':remarks,'printer':printers,'modus':modus};
					foods.push(food);
				}	
				if (foods.length>0) {
					layer.confirm('是否确认传菜', {
						btn: ['确定']
					}, function(index){
						layer.close(index);
						var params ="foods="+JSON.stringify(foods)+"&type=0&storeId=${storeId}&orderId="+orderId;
		    			loadAjax("${ctx}/order/checkIn/foodStatusSub", params, function(result) {
		    				if (result.retCode == "000000") {
		    					printer(result.ret);
		    					getOrdConsumesByOrdId();
		    				} else {
		    					layer.alert(result.retMsg);
		    				}
		    			});
					}, function(){return;});
				} else {
					layer.alert("请选择需要传菜的菜品！");
					return;
				}
			});
			//即起
			$("input[name='jiqiBtn']").bind("click", function() {
				var cks = $("input[name='itemCheckBoxBtn']:checked");
				var foods = [];
				for(var i=0;i<cks.length;i++){
					var obj = cks[i];
					var jsonStr = $(obj).parent().parent().find("[name='obj']").val();
					var obj = JSON.parse(jsonStr);
					if(obj.status=='1'){
						layer.alert("菜品："+obj.name+"已下单，无法即起！");
						return;
					}
					if(obj.status=='2'){
						layer.alert("菜品："+obj.name+"已退单，无法即起！");
						return;
					}
					var id = obj.id;
					var foodId = obj.foodId;
					var foodName = obj.name;
					var num = obj.count;
					var remarks = (obj.remarks==undefined?'':obj.remarks);
					var printers = (obj.printer==undefined?'':obj.printer);
					var modus=obj.cookValues+obj.cookValuesTemp;
					var food ={'id':id,'foodId':foodId,'foodName':foodName,'num':num,'remarks':remarks,'printer':printers,'modus':modus};
					foods.push(food);
				}	
				if (foods.length>0) {
					layer.confirm('是否确认即起！', {
						btn: ['确定']
					}, function(index){
						layer.close(index);
						var params ="foods="+JSON.stringify(foods)+"&type=1&storeId=${storeId}&orderId="+orderId;
		    			loadAjax("${ctx}/order/checkIn/foodStatusSub", params, function(result) {
		    				if (result.retCode == "000000") {
		    					printer(result.ret);
		    					getOrdConsumesByOrdId();
		    				} else {
		    					layer.alert(result.retMsg);
		    				}
		    			});
					}, function(){return;});
				} else {
					layer.alert("请选择需要即起的菜品！");
					return;
				}
			});
			//加急
			$("input[name='jiajiBtn']").bind("click", function() {
				var cks = $("input[name='itemCheckBoxBtn']:checked");
				var foods = [];
				for(var i=0;i<cks.length;i++){
					var obj = cks[i];
					var jsonStr = $(obj).parent().parent().find("[name='obj']").val();
					var obj = JSON.parse(jsonStr);
					if(obj.status=='1'){
						layer.alert("菜品："+obj.name+"已下单，无法加急！");
						return;
					}
					if(obj.status=='2'){
						layer.alert("菜品："+obj.name+"已退单，无法加急！");
						return;
					}
					if (obj.callStatus!='') {
						layer.alert("菜品："+obj.name+"只能有一个即时状态");
						return;
					}
					var id = obj.id;
					var foodId = obj.foodId;
					var foodName = obj.name;
					var num = obj.count;
					var remarks = (obj.remarks==undefined?'':obj.remarks);
					var printers = (obj.printer==undefined?'':obj.printer);
					var modus=obj.cookValues+obj.cookValuesTemp;
					var food ={'id':id,'foodId':foodId,'foodName':foodName,'num':num,'remarks':remarks,'printer':printers,'modus':modus};
					foods.push(food);
				}	
				if (foods.length>0) {
					layer.confirm('是否确认加急！', {
						btn: ['确定']
					}, function(index){
						layer.close(index);
						var params ="foods="+JSON.stringify(foods)+"&type=2&storeId=${storeId}&orderId="+orderId;
		    			loadAjax("${ctx}/order/checkIn/foodStatusSub", params, function(result) {
		    				if (result.retCode == "000000") {
		    					printer(result.ret);
		    					getOrdConsumesByOrdId();
		    				} else {
		    					layer.alert(result.retMsg);
		    				}
		    			});
					}, function(){return;});
				}else {
					layer.alert("请选择需要加急的菜品！");
					return;
				}
			});
			//叫起
			$("input[name='jiaoqiBtn']").bind("click", function() {
				var cks = $("input[name='itemCheckBoxBtn']:checked");
				var foods = [];
				for(var i=0;i<cks.length;i++){
					var obj = cks[i];
					var jsonStr = $(obj).parent().parent().find("[name='obj']").val();
					var obj = JSON.parse(jsonStr);
					if(obj.status=='1'){
						layer.alert("菜品："+obj.name+"已下单，无法叫起！");
						return;
					}
					if(obj.status=='2'){
						layer.alert("菜品："+obj.name+"已退单，无法叫起！");
						return;
					}
					if (obj.callStatus!='') {
						layer.alert("菜品："+obj.name+"只能有一个即时状态");
						return;
					}
					var id = obj.id;
					var foodId = obj.foodId;
					var foodName = obj.name;
					var num = obj.count;
					var remarks = (obj.remarks==undefined?'':obj.remarks);
					var printers = (obj.printer==undefined?'':obj.printer);
					var modus=obj.cookValues+obj.cookValuesTemp;
					var food ={'id':id,'foodId':foodId,'foodName':foodName,'num':num,'remarks':remarks,'printer':printers,'modus':modus};
					foods.push(food);
				}	
				if (foods.length>0) {
					layer.confirm('是否确认叫起！', {
						btn: ['确定']
					}, function(index){
						layer.close(index);
						var params ="foods="+JSON.stringify(foods)+"&type=3&storeId=${storeId}&orderId="+orderId;
		    			loadAjax("${ctx}/order/checkIn/foodStatusSub", params, function(result) {
		    				if (result.retCode == "000000") {
		    					printer(result.ret);
		    					getOrdConsumesByOrdId();
		    				} else {
		    					layer.alert(result.retMsg);
		    				}
		    			});
					}, function(){return;});
				}else {
					layer.alert("请选择需要叫起的菜品！");
					return;
				}
			});
			//催菜
			$("input[name='cuicaiBtn']").bind("click", function() {
				var cks = $("input[name='itemCheckBoxBtn']:checked");
				var foods = [];
				for(var i=0;i<cks.length;i++){
					var obj = cks[i];
					var jsonStr = $(obj).parent().parent().find("[name='obj']").val();
					var obj = JSON.parse(jsonStr);
					if(obj.status=='2'){
						layer.alert("菜品："+obj.name+"已退单，无法催菜！");
						return;
					}
					var id = obj.id;
					var foodId = obj.foodId;
					var foodName = obj.name;
					var num = obj.count;
					var remarks = (obj.remarks==undefined?'':obj.remarks);
					var printers = (obj.printer==undefined?'':obj.printer);
					var modus=obj.cookValues+obj.cookValuesTemp;
					var food ={'id':id,'foodId':foodId,'foodName':foodName,'num':num,'remarks':remarks,'printer':printers,'modus':modus};
					foods.push(food);
				}	
				if (foods.length>0) {
					layer.confirm('是否确认催菜！', {
						btn: ['确定']
					}, function(index){
						layer.close(index);
						var params ="foods="+JSON.stringify(foods)+"&type=4&storeId=${storeId}&orderId="+orderId;
		    			loadAjax("${ctx}/order/checkIn/foodStatusSub", params, function(result) {
		    				if (result.retCode == "000000") {
		    					printer(result.ret);
		    					getOrdConsumesByOrdId();
		    				} else {
		    					layer.alert(result.retMsg);
		    				}
		    			});
					}, function(){return;});
				}else {
					layer.alert("请选择需要催菜的菜品！");
					return;
				}
			});
			
			//做法
			$("input[name='zuofaBtn']").bind("click", function() {
				var obj = document.getElementsByName("itemCheckBoxBtn");
				var check_val = [];
				for (var i = 0; i < obj.length; i++) {
					if (obj[i].checked){
						if (obj[i].value != 0 ) {
							layer.alert("仅支持对未下单的菜品进行设置！");
							return;
						} 
						check_val.push(obj[i].id);
					}
				}
				if (check_val != "") {
					if (check_val.length >1 && check_val.length!= obj.length) {
						layer.alert("仅支持【单选】菜品，或者【全选】整单！");
						return;
					}
					top.$.jBox.open("iframe:${ctx}/order/checkIn/ordFoodModus?storeId=${storeId}&orderId=${orderId}&type=1&foodId=" + check_val, "做法", 1150, 560, {
						buttons : {},
						loaded : function(h) {
							$(".jbox-content", top.document).css("overflow-y", "hidden");
						}
					});
				}else {
					layer.alert("请选择需要设置做法的菜品！");
					return;
				}
			});
			//退单
			$("input[name='tuidanBtn']").bind("click", function() {
				var cks = $("input[name='itemCheckBoxBtn']:checked");
				var foodId = [];
				var foodName = [];
				for(var i=0;i<cks.length;i++){
					var obj = cks[i];
					var jsonStr = $(obj).parent().parent().find("[name='obj']").val();
					var obj = JSON.parse(jsonStr);
					if(obj.status=='2'){
						layer.alert("菜品："+obj.name+"已退单，无法退单！");
						return;
					}if(obj.settleStatus == '1'){
						layer.alert("菜品："+obj.name+"已结账，无法退单！");
						return;
					}
					foodId.push(obj.id);
					foodName.push(obj.name);
				}	
				if (foodId.length>0) {
					var foodName = encodeURI(encodeURI(foodName));
					top.$.jBox.open("iframe:${ctx}/order/checkIn/foodStatus?type=5&foodId="+foodId+"&foodName="+foodName, "退单", 500, 320, {
						buttons : {},
						loaded : function(h) {
							$(".jbox-content", top.document).css("overflow-y", "hidden");
						}
					});
					}else {
						layer.alert("请选择需要退单的菜品！");
						return;
					}
				
			});
			//折扣
			$("input[name='zhekouBtn']").bind("click", function() {
				var count=$("#count").val();
				var cks = $("input[name='itemCheckBoxBtn']:checked");
				var foodId = [];
				var foodName = [];
				var subtotal =0;
				var noFoodName =[];
				for(var i=0;i<cks.length;i++){
					var obj = cks[i];
					var jsonStr = $(obj).parent().parent().find("[name='obj']").val();
					var obj = JSON.parse(jsonStr);
					if (count==cks.length) {
						if(obj.status == '2' || obj.isDiscount == '0' || obj.settleStatus == '1'){
							noFoodName+=obj.name+"、";
							continue;
						}
					}else {
						if(obj.status == '2'){
							layer.alert("菜品："+obj.name+"已退单，不允许打折！");
							return;
						}if (obj.isDiscount == '0') {
							layer.alert("菜品："+obj.name+"不允许打折！");
							return;
						}if (obj.settleStatus == '1') {
							layer.alert("菜品："+obj.name+"已结账，不允许打折！");
							return;
						}
					}
					subtotal =parseFloat(subtotal)+parseFloat(obj.price);
					foodId.push(obj.id);
					foodName.push(obj.name);
				}	
				if (foodId.length>0) {
					if (count==cks.length && noFoodName != '') {
						layer.confirm("菜品："+noFoodName+'不参与折扣，是否继续？', {
							btn: ['确定']
						}, function(index){
							layer.close(index);
							var foodName = encodeURI(encodeURI(foodName));
							top.$.jBox.open("iframe:${ctx}/order/checkIn/foodStatus?type=6&foodId="+foodId+"&foodName="+foodName+"&subtotal="+subtotal, "折扣", 550, 350, {
								buttons : {},
								loaded : function(h) {
									$(".jbox-content", top.document).css("overflow-y", "hidden");
								}
							});
						}, function(){return;});
					}else {
						var foodName = encodeURI(encodeURI(foodName));
						top.$.jBox.open("iframe:${ctx}/order/checkIn/foodStatus?type=6&foodId="+foodId+"&foodName="+foodName+"&subtotal="+subtotal, "折扣", 550, 350, {
							buttons : {},
							loaded : function(h) {
								$(".jbox-content", top.document).css("overflow-y", "hidden");
							}
						});
					}
				}else if (cks.length>0) {
					layer.alert("没有可打折的菜品！");
					return;
				}else{
					layer.alert("请选择打折的菜品！");
					return;
				}
			});
			//赠送
			$("input[name='zengsongBtn']").bind("click", function() {
				var cks = $("input[name='itemCheckBoxBtn']:checked");
				var foodId = [];
				var foodName = [];
				var subtotal =0;
				for(var i=0;i<cks.length;i++){
					var obj = cks[i];
					var jsonStr = $(obj).parent().parent().find("[name='obj']").val();
					var obj = JSON.parse(jsonStr);
					if(obj.status=='2'){
						layer.alert(obj.name+"已退单，无法赠送！");
						return;
					}
					if (obj.settleStatus == '1') {
						layer.alert(obj.name+"已结账，无法赠送！");
						return;
					}
					subtotal =parseFloat(subtotal)+parseFloat(obj.price);
					foodId.push(obj.id);
					foodName.push(obj.name);
				}	
				if (foodId.length>0) {
					var foodName = encodeURI(encodeURI(foodName));
					top.$.jBox.open("iframe:${ctx}/order/checkIn/foodStatus?type=7&foodId="+foodId+"&foodName="+foodName+"&subtotal="+subtotal, "赠送", 550, 350, {
						buttons : {},
						loaded : function(h) {
							$(".jbox-content", top.document).css("overflow-y", "hidden");
						}
					});
				}else {
					layer.alert("请选择需要赠送的菜品！");
					return;
				}
			});
			//转台
			$("input[name='zhuantaiBtn']").bind("click", function() {
				var consume = $("#consume").val();//消费
				var proceeds = $("#proceeds").val();//收款
				top.$.jBox.open("iframe:${ctx}/order/checkIn/changeTable?tableNo="+tableNo+"&consume="+consume+"&proceeds=" + proceeds+"&orderId=${orderId}&storeId=${storeId}", "转台", 600, 350, {
					buttons : {},
					loaded : function(h) {
						$(".jbox-content", top.document).css("overflow-y", "hidden");
					}
				});
			});
			//并台
			$("input[name='bingtaiBtn']").bind("click", function() {
				var consume = $("#consume").val();//消费
				var proceeds = $("#proceeds").val();//收款
				top.$.jBox.open("iframe:${ctx}/order/checkIn/combineTable?tableNo="+tableNo+"&consume="+consume+"&proceeds=" + proceeds+"&orderId=${orderId}&storeId=${storeId}", "并台", 600, 350, {
					buttons : {},
					loaded : function(h) {
						$(".jbox-content", top.document).css("overflow-y", "hidden");
					}
				});
			});
			//增加临时菜
			$("input[name='foodBut']").bind("click", function() {
				
			});
			
			function getRowObj(obj) {
				var i = 0;
				while (obj.tagName.toLowerCase() != "tr") {
					obj = obj.parentNode;
					if (obj.tagName.toLowerCase() == "table")
						return null;
				}
				return obj;
			}
		});
		//菜品类型小类查询
		function getFoodTypesByStoreId() {
			var params = {
				storeId : '${storeId}'
			};
			loadAjax("${ctx}/setting/ctFoodType/getListByStoreId", params, function(result) {
				if (result.retCode == "000000") {
					var list = result.ret.list;
					var html = "<li class='active' foodType='' onclick='getFoodsByStoreId(this)'>全部</li><li foodType='' onclick='getFoodsSpecial(this)'>特价</li>";				
					for (var i = 0; i < list.length; i++) {
						var obj = list[i];
						html += "<li foodType='" + obj.id + "' onclick='getFoodsByStoreId(this)'>" + obj.name + "</li>";
					}
					$(".span3").html(html);
					$(".active").click();
				} else {
					layer.alert(result.retMsg);
				}
			});
		}

/* 		//菜品查询
		function getFoodsByStoreId(obj) {
			var foodType = $(obj).attr('foodType');
			var foodName = $("#foodName").val();
			var params = {
				storeId : '${storeId}',
				foodType : foodType,
				foodName : foodName
			};
			loadAjax("${ctx}/setting/ctFood/getListByStoreId", params, function(result) {
				if (result.retCode == "000000") {
					var list = result.ret.list;
					var html = ""
					for (var i = 0; i < list.length; i++) {
						var obj = list[i];
						var isDiscount="";
						if (obj.isDiscount == '1') {
							isDiscount="折";
						}
						html += "<tr foodJson='" + JSON.stringify(obj) + "' name='foodItem' id='" + obj.id + "' calss='change' ondblclick='addFood(this,0)'>"
								+ "<td>"+isDiscount+"</td>" + "<td>" + obj.code + "</td>" + "<td>" + obj.name + "</td>" + "<td>" + obj.foodUnitName + "</td>" + "<td>" + obj.price.amount
								+ "</td>" + "<td>" + obj.surplus + "</td>" + "</tr>";
					}
					$("#tableBody2").html(html);
					
					//表格选择
					$("tr[name='foodItem']").bind("click",function(){
					}).hover(function(){
						if(!this.tag){
							$(this).css("background", "#FF9900");
						}
					}, function(){
						if(!this.tag){
							$(this).css("background", "");
						}
					});
				} else {
					layer.alert(result.retMsg);
				}
			});
		} */
		
		/* //特价菜查询
		function getFoodsSpecial() {
			var params = {
				storeId : '${storeId}'
			};
			$.ajax({
				type : "POST",
				url : "${ctx}/order/checkIn/getSpecialFood",
				contentType : 'application/x-www-form-urlencoded;charset=utf-8',
				global : false,
				data : params,
				dataType : "json",
				success : function(result) {
					if (result.retCode == "000000") {
						var list = result.list;
						var html = ""
						if (list != undefined) {
							for (var i = 0; i < list.length; i++) {
								var obj = list[i];
								var isDiscount = "特";
								html += "<tr foodJson='" + JSON.stringify(obj) + "' name='foodItem' id='" + obj.foodId + "' calss='change' ondblclick='addFood(this,1)' value='"
										+ obj.id + "'>" + "<td>" + isDiscount + "</td>" + "<td>" + obj.ordernumber + "</td>" + "<td>" + obj.nameDishes + "</td>" + "<td>"
										+ obj.units + "</td>" + "<td>" + obj.price + "</td>" 
										if (obj.isMaxSellCount == '0') {
											html+= "<td>999</td>" + "</tr>";
										}else {
											html+= "<td>" + obj.maxSellCount + "</td>" + "</tr>";
										}
									
							}
						}
						$("#tableBody2").html(html);

						//表格选择
						$("tr[name='foodItem']").bind("click", function() {
						}).hover(function() {
							if (!this.tag) {
								$(this).css("background", "#FF9900");
							}
						}, function() {
							if (!this.tag) {
								$(this).css("background", "");
							}
						});
					} else {
						layer.alert(result.retMsg);
					}
				},
				error : function(e) {
					console.log(e);
				}
			});
		} */
		//获取特价菜
		function getFoodsSpecial(obj) {
			$(obj).addClass('active').siblings().removeClass('active');
			var params = {
				storeId : '${storeId}',
				foodType : "",
				foodName : "",
				orderId : '${orderId}'
			};
			$.ajax({
				type : "POST",
				url : "${ctx}/setting/ctFood/getListByStoreId",
				contentType : 'application/x-www-form-urlencoded;charset=utf-8',
				global : false,
				data : params,
				dataType : "json",
				success : function(result) {
					if (result.retCode == "000000") {
						var list = result.ret.list;
						var html = ""
						for (var i = 0; i < list.length; i++) {
							var obj = list[i];
							var isDiscount = "";
								if (obj.isSpecial !=0) {
									if (obj.ctFoodSpecial.surplus > 0 ) {
										html += "<tr foodJson='" + JSON.stringify(obj) + "' name='foodItem' id='" + obj.id + "' calss='change' ondblclick='addFood(this,1)'>" + 
										"<td>特</td>" + "<td>" + obj.code + "</td>" + "<td>" + obj.name + "</td>" + "<td>" + obj.foodUnitName + "</td>" + "<td>"
										+ obj.ctFoodSpecial.price + "</td>";
										if (obj.ctFoodSpecial.isMaxSellCount != 0) {
											html +="<td>" + obj.ctFoodSpecial.surplus + "</td>" + "</tr>";
										}else{
											html +="<td>" + obj.surplus + "</td>" + "</tr>";
										}
									}
							}
						}
						$("#tableBody2").html(html);

						//表格选择
						$("tr[name='foodItem']").bind("click", function() {
						}).hover(function() {
							if (!this.tag) {
								$(this).css("background", "#FF9900");
							}
						}, function() {
							if (!this.tag) {
								$(this).css("background", "");
							}
						});
					} else {
						layer.alert(result.retMsg);
					}
				},
				error : function(e) {
					console.log(e);
				}
			});
		}
		//菜品查询
		function getFoodsByStoreId(obj) {
			$(obj).addClass('active').siblings().removeClass('active');
			var foodType = $(obj).attr('foodType');
			var foodName = $("#foodName").val();
			var params = {
				storeId : '${storeId}',
				foodType : foodType,
				foodName : foodName,
				orderId : '${orderId}'
			};
			$.ajax({
				type : "POST",
				url : "${ctx}/setting/ctFood/getListByStoreId",
				contentType : 'application/x-www-form-urlencoded;charset=utf-8',
				global : false,
				data : params,
				dataType : "json",
				success : function(result) {
					if (result.retCode == "000000") {
						var list = result.ret.list;
						var html = ""
						for (var i = 0; i < list.length; i++) {
							var obj = list[i];
							var isDiscount = "";
							if (obj.surplus > 0 || obj.stock ==0) {
								if (obj.isSpecial !=0 ) {
									if (obj.ctFoodSpecial.surplus > 0) {
										html += "<tr foodJson='" + JSON.stringify(obj) + "' name='foodItem' id='" + obj.id + "' calss='change' ondblclick='addFood(this,1)'>" + 
										"<td>特</td>" + "<td>" + obj.code + "</td>" + "<td>" + obj.name + "</td>" + "<td>" + obj.foodUnitName + "</td>" + "<td>"
										+ obj.ctFoodSpecial.price + "</td>";
										if (obj.ctFoodSpecial.isMaxSellCount !=0) {
											html +="<td>" + obj.ctFoodSpecial.surplus + "</td>" + "</tr>";
										}else{
											html +="<td>" + obj.surplus + "</td>" + "</tr>";
										}
									}else {
										if (obj.isDiscount == '1') {
											isDiscount = "折";
										}
										html += "<tr foodJson='" + JSON.stringify(obj) + "' name='foodItem' id='" + obj.id + "' calss='change' ondblclick='addFood(this,0)'>" + "<td>"
										+ isDiscount + "</td>" + "<td>" + obj.code + "</td>" + "<td>" + obj.name + "</td>" + "<td>" + obj.foodUnitName + "</td>" + "<td>"
										+ obj.storePrice.amount + "</td>";
										if (obj.stock =='0' ) {
											html +="<td>999+</td>" + "</tr>";
										}else {
											html +="<td>" + obj.surplus + "</td>" + "</tr>";
										}
										
									}
								}else {
									if (obj.isDiscount == '1') {
										isDiscount = "折";
									}
									html += "<tr foodJson='" + JSON.stringify(obj) + "' name='foodItem' id='" + obj.id + "' calss='change' ondblclick='addFood(this,0)'>" + "<td>"
									+ isDiscount + "</td>" + "<td>" + obj.code + "</td>" + "<td>" + obj.name + "</td>" + "<td>" + obj.foodUnitName + "</td>" + "<td>"
									+ obj.storePrice.amount + "</td>";
									if (obj.stock =='0' ) {
										html +="<td>999+</td>" + "</tr>";
									}else {
										html +="<td>" + obj.surplus + "</td>" + "</tr>";
									}
								}
							}
						}
						$("#tableBody2").html(html);

						//表格选择
						$("tr[name='foodItem']").bind("click", function() {
						}).hover(function() {
							if (!this.tag) {
								$(this).css("background", "#FF9900");
							}
						}, function() {
							if (!this.tag) {
								$(this).css("background", "");
							}
						});
					} else {
						layer.alert(result.retMsg);
					}
				},
				error : function(e) {
					console.log(e);
				}
			});
		}

		
		//添加菜品
		function addFood(obj, status) {
			var foodJson = $(obj).attr('foodJson');
			var packageTypeName = JSON.parse(foodJson).packageTypeName;
			var surplus = JSON.parse(foodJson).surplus
			var foodId = $(obj).attr('id');
			var specialId = "";
			if (surplus != '0') {
				if (packageTypeName == '普通' || packageTypeName == '套餐') {
					if (status == 1) {
						specialId = JSON.parse(foodJson).ctFoodSpecial.id;
					}
					var params = {
						storeId : '${storeId}',
						orderId : '${orderId}',
						foodId : foodId,
						status : status,
						specialId : specialId
					}
					loadAjax("${ctx}/order/checkIn/addFoodCommit", params, function(result) {
						if (result.retCode == "000000") {
							getOrdConsumesByOrdId();
							getFoodsByStoreId(result);
						} else {
							layer.alert("添加失败："+result.retMsg);
						}
					});
				} else {
					top.$.jBox.open("iframe:${ctx}/order/checkIn/addFood?storeId=${storeId}&orderId=${orderId}&foodId=" + foodId, "做法", 1150, 560, {
						buttons : {},
						loaded : function(h) {
							$(".jbox-content", top.document).css("overflow-y", "hidden");
						}
					});
				}
			} else {
				layer.alert('该菜品无库存，请选择其他菜品！');
				return;
			}
		}

		function closeIframe() {
			window.parent.jBox.close();
		}
		function printer(ret) {
			for ( var key in ret) {
				if (ret[key] != '') {
					var arr = key.split(",");
					if (!ret[key].foodItems == '') {
						readPrinter(arr[1], ret[key],1);
					}
				}
			}
		}
		//修改菜品
		function updateFood(ordObj) {
			if (ordObj != '') {
				var id=ordObj.id;
				top.$.jBox.open("iframe:${ctx}/order/checkIn/updateFoodForm?ordId="+id, "菜品编辑", 550, 320, {
					buttons : {},
					loaded : function(h) {
						$(".jbox-content", top.document).css("overflow-y", "hidden");
					}
				});
			}else {
				layer.alert('不存在改菜品,请重新选择');
				return;
			}
		}
	</script>
</head>
<body>
	<div class="row-fluid">
	<jsp:include page="../common/common_read_printer.jsp"></jsp:include>
	<div class="span8">
			<form:form id="inputForm" action="" method="post" class="form-horizontal">
				<div class="row">
					<div class="span7 tableNo" style="line-height:36px; color:#555;">
						<label style="margin-right:20px">台号：<span title="${tableNo}" style="color:#E04445;font-weight:bold;display:inline-block;width: 189px;overflow:hidden;text-overflow:ellipsis;white-space:normal;vertical-align:top;">${tableNo}</span></label>
						<label>用餐人数：<span id="useTable" style="color:#E04445;font-weight:bold;display:inline-block;width: 89px;overflow:hidden;text-overflow:ellipsis;white-space:normal;vertical-align:top;">${useTable }</span></label>
					</div>
					
					<ul class="nav nav-tabs nav-justified" id="tab">
						 <li>
				         	<a href="#tab3" data-id="tab3" data-taggle="tab" onclick="getUnusualPayList();">异常账务</a>
				         </li>
						 <li>
				         	<a href="#tab2" data-id="tab2" data-taggle="tab" onclick="getOrdLogByOrdId();">操作日志</a>
				         </li>
				         <li>
				         	<a href="#tab1" data-id="tab1" data-taggle="tab" onclick="getOrdTableById()">订单信息</a>
				         </li>    
				         <li>
				         	<a href="#tab0" data-id="tab0" data-taggle="tab" onclick="getOrdConsumesByOrdId()">明细账</a>
				         </li>
				     </ul>
				 </div>
			     <div class="tab-content" style="position: relative;">
			     	<div class="tab-pane active" id="tab0" >
			     		<jsp:include page="./ordInfoDetail.jsp"></jsp:include>
			     	</div>
			     	<div class="tab-pane" id="tab1">
			     		<jsp:include page="./ordInfo.jsp"></jsp:include>
			     	</div>
			     	<div class="tab-pane" id="tab2">
			     		<jsp:include page="./ordInfoLog.jsp"></jsp:include>
			     	</div>
			     	<div class="tab-pane" id="tab3">
			     		<jsp:include page="./ordInfoUnusualPay.jsp"></jsp:include>
			     	</div>
			     </div>
			     <div style="margin-left: 10px;color: red; ">
			     <label style="margin-right:20px">
			     <span id="totalCount" class="total" ></span>
			     <span id="totalConsume"  class="total"></span>
			     <span id="totalRateAmount"  class="total"></span>
			     <span id="totalAmount" class="total"></span>
			     <span id="theTotalPayment" class="total"></span>
			     <span id="accountsDue" class="total"></span>
			     <input type="hidden" id="count"/>
			     <input type="hidden" id="consume"/>
			     <input type="hidden" id="proceeds"/>
			     </label>
			     </div>
			     <div id="bottom" class="fixed-btn-right" style="width: 98.5%;text-align: left;">
					<input id="chuancaiBtn" name="chuancaiBtn" class="btn btn-primary" type="button" ${chuancaiBtn} <shiro:lacksPermission name="index:order:chuancai">disabled</shiro:lacksPermission> value="传菜"/>&nbsp;
					<input id="jiqiBtn" name="jiqiBtn" class="btn btn-primary" type="button" ${jiqiBtn} <shiro:lacksPermission name="index:order:jiqi">disabled</shiro:lacksPermission> value="即起"/>&nbsp;
					<input id="jiajiBtn" name="jiajiBtn" class="btn btn-primary" type="button" ${jiajiBtn} <shiro:lacksPermission name="index:order:jiaji">disabled</shiro:lacksPermission> value="加急"/>&nbsp;
					<input id="jiaoqiBtn" name="jiaoqiBtn" class="btn btn-primary" type="button" ${jiaoqiBtn} <shiro:lacksPermission name="index:order:jiaoqi">disabled</shiro:lacksPermission> value="叫起"/>&nbsp;
					<input name="cuicaiBtn" class="btn btn-primary" type="button" ${cuicaiBtn} <shiro:lacksPermission name="index:order:cuicai">disabled</shiro:lacksPermission> value="催菜"/>&nbsp;
					<input name="tuidanBtn" class="btn btn-primary" type="button" ${tuidanBtn} <shiro:lacksPermission name="index:order:tuidan">disabled</shiro:lacksPermission> value="退单"/>&nbsp;
					<input name="zuofaBtn" class="btn btn-primary" type="button" ${zuofaBtn} <shiro:lacksPermission name="index:order:zuofa">disabled</shiro:lacksPermission> value="做法"/>&nbsp;
					<input name="zhekouBtn" class="btn btn-primary" type="button" ${zhekouBtn} <shiro:lacksPermission name="index:order:zhekou">disabled</shiro:lacksPermission> value="折扣"/>&nbsp;
					<input name="zengsongBtn" class="btn btn-primary" type="button" ${zengsongBtn} <shiro:lacksPermission name="index:order:zengsong">disabled</shiro:lacksPermission> value="赠送"/>&nbsp;
					<input name="zhuantaiBtn" class="btn btn-primary" type="button" ${zhuantaiBtn} <shiro:lacksPermission name="index:order:zhuantai">disabled</shiro:lacksPermission> value="转台"/>&nbsp;
					<input name="bingtaiBtn" class="btn btn-primary" type="button" ${bingtaiBtn} <shiro:lacksPermission name="index:order:bingtai">disabled</shiro:lacksPermission> value="并台"/>&nbsp;
					<input name="ordDepositBtn" class="btn btn-primary" type="button" ${ordDepositBtn} <shiro:lacksPermission name="index:order:ordDeposit">disabled</shiro:lacksPermission> value="押金"/>&nbsp;
					<input name="checkOutPartBtn" class="btn btn-primary" type="button" ${checkOutPartBtn} <shiro:lacksPermission name="index:order:checkOutPart">disabled</shiro:lacksPermission> value="部分结账"/>&nbsp;
					<input name="checkOutPXBtn" class="btn btn-primary" type="button" ${checkOutPXBtn} <shiro:lacksPermission name="index:order:checkOutPX">disabled</shiro:lacksPermission> value="整单PX"/>&nbsp;
					<input name="checkOutBtn" class="btn btn-primary" type="button" ${checkOutBtn} <shiro:lacksPermission name="index:order:checkOut">disabled</shiro:lacksPermission> value="结账"/>&nbsp;
					<input name="printBtn" class="btn btn-primary" type="button" ${printBtn} <shiro:lacksPermission name="index:order:print">disabled</shiro:lacksPermission> value="打印对账单"/>&nbsp;
					<input name="printBtn2" class="btn btn-primary back" type="button" value="返回" onclick="closeIframe()" style="float:right;"/>
				</div>
				<div style="height: 46px;"></div>
			</form:form>
		</div>
		<div class="span4 modus">
			<div class="search">
				<text>菜单</text>
				<div class="input">				
					<input type="text" id="foodName" value="${param.foodName }" placeholder="输入菜品名称/编号/简拼查询"/>
					<button class="btn"  onclick="getFoodsByStoreId(this)">搜索</button>
				</div>
			</div>
			<div class="row tableText" >
				<ul class="span3" style="height: 100%;border-right: 1px solid #ddd;margin-bottom: 0;">
				</ul>
				<div class="span9 " style="padding:0px;overflow:auto;float: right;">
					<table id="contentTable2" class="table table-striped table-bordered table-condensed" style="margin-bottom:0px;">
						<thead>
							<tr>
								<th>折</th>
								<th>编号</th>
								<th>菜名</th>
								<th>单位</th>
								<th>单价</th>
								<th>库存</th>
							</tr>
						</thead>
						<tbody id="tableBody2">
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</body>
</html>