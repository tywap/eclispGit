<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>预订单</title>
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
				if(data.eventName == 'close' ) {
					window.location.reload();
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
			var storeId = '${storeId}';//餐厅id
			var reserveId = '${reserveId}';//预订单id
			var tableId = '${tableId}';//台号id
			var tableNo = '${tableNo}';//台号
			var useNum = '${useNum}';//用餐人数
			var tableNum = '${tableNum}';//台数
			var id = '${id}'//订单信息id
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
			
			$("input[name='printBtn']").bind("click",function(){
				layer.confirm('是否打印对账单？', {
					  btn: ['确定','取消'] 
				}, function(){
					window.open("${ctx}/print/printCheckOut?ordId="+orderId);
					/* top.$.publish(eventName,{testData:"hello"}); */
			    	window.parent.jBox.close(); 
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
						var params ="foods="+JSON.stringify(foods)+"&storeId="+storeId+"&reserveId=${id}&tableNo="+tableNo;
		    			loadAjax("${ctx}/reserve/reservePassFood", params, function(result) {
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
					top.$.jBox.open("iframe:${ctx}/reserve/ordFoodModus?storeId=${storeId}&reserveId=${id}&type=1&foodId=" + check_val, "做法", 1150, 560, {
						buttons : {},
						loaded : function(h) {
							$(".jbox-content", top.document).css("overflow-y", "hidden");
						}
					});
				}else {
					layer.alert("请选择需要设置做法的菜品！");
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
						layer.alert("菜品："+obj.name+"已退单，无法继续退单！");
						return;
					}
					foodId.push(obj.id);
					foodName.push(obj.name);
				}	
				if (foodId.length>0) {
					var foodName = encodeURI(encodeURI(foodName));
					top.$.jBox.open("iframe:${ctx}/reserve/foodStatus?type=5&foodId="+foodId+"&foodName="+foodName+"&tableNo="+tableNo, "退单", 500, 320, {
						buttons : {},
						loaded : function(h) {
							$(".jbox-content", top.document).css("overflow-y", "hidden");
						}
					});
					}else {
						layer.alert("请选择需要退单的菜品！");
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
						if(obj.status == '2' || obj.isDiscount == '0'){
							noFoodName+=obj.name+"、";
							continue;
						}
					}else {
						if(obj.status == '2'){
							layer.alert("菜品："+obj.name+"已退单，无法进行折扣！");
							return;
						}if (obj.isDiscount == '0') {
							layer.alert("菜品："+obj.name+"不允许打折！");
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
							top.$.jBox.open("iframe:${ctx}/reserve/foodStatus?type=6&foodId="+foodId+"&foodName="+foodName+"&subtotal="+subtotal+"&tableNo="+tableNo, "折扣", 550, 350, {
								buttons : {},
								loaded : function(h) {
									$(".jbox-content", top.document).css("overflow-y", "hidden");
								}
							});
						}, function(){return;});
					}else {
						var foodName = encodeURI(encodeURI(foodName));
						top.$.jBox.open("iframe:${ctx}/reserve/foodStatus?type=6&foodId="+foodId+"&foodName="+foodName+"&subtotal="+subtotal+"&tableNo="+tableNo, "折扣", 550, 350, {
							buttons : {},
							loaded : function(h) {
								$(".jbox-content", top.document).css("overflow-y", "hidden");
							}
						});
					}
				}else {
					layer.alert("请选择打折的菜品！");
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
					subtotal =parseFloat(subtotal)+parseFloat(obj.price);
					foodId.push(obj.id);
					foodName.push(obj.name);
				}	
				if (foodId.length>0) {
					var foodName = encodeURI(encodeURI(foodName));
					top.$.jBox.open("iframe:${ctx}/reserve/foodStatus?type=7&foodId="+foodId+"&foodName="+foodName+"&subtotal="+subtotal+"&tableNo="+tableNo, "赠送", 550, 350, {
						buttons : {},
						loaded : function(h) {
							$(".jbox-content", top.document).css("overflow-y", "hidden");
						}
					});
				}else {
					layer.alert("请选择需要赠送的菜品！");
				}
			});
			//转台
			$("input[name='zhuantaiBtn']").bind("click", function() {
				var consume = $("#consume").val();//消费
				var proceeds = $("#proceeds").val();//收款
				top.$.jBox.open("iframe:${ctx}/reserve/changeTable?tableNo="+tableNo+"&consume="+consume+"&proceeds=" + proceeds+"&reserve=${id}&storeId=${storeId}", "转台", 600, 350, {
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

		//获取特价菜
		function getFoodsSpecial(obj) {
			$(obj).addClass('active').siblings().removeClass('active');
			var params = {
				storeId : '${storeId}',
				foodType : "",
				foodName : "",
				orderId : '${reserveId}'
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
				orderId : '${reserveId}'
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
							if (obj.surplus > 0) {
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
										+ obj.storePrice.amount + "</td>" + 
										"<td>" + obj.surplus + "</td>" + "</tr>";
									}
								}else {
									if (obj.isDiscount == '1') {
										isDiscount = "折";
									}
									html += "<tr foodJson='" + JSON.stringify(obj) + "' name='foodItem' id='" + obj.id + "' calss='change' ondblclick='addFood(this,0)'>" + "<td>"
									+ isDiscount + "</td>" + "<td>" + obj.code + "</td>" + "<td>" + obj.name + "</td>" + "<td>" + obj.foodUnitName + "</td>" + "<td>"
									+ obj.storePrice.amount + "</td>" + 
									"<td>" + obj.surplus + "</td>" + "</tr>";
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

		function selectweeks() {
			if ($("#weeksall").attr("checked") == "checked")
				$(".weeks").attr("checked", "checked");
			else
				$(".weeks").removeAttr("checked");
		}
		
		
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
						reserveId : '${reserveId}',
						foodId : foodId,
						status : status,
						specialId : specialId,
						id : '${id}'
					}
					loadAjax("${ctx}/reserve/reserveAheadOrderFoodSave", params, function(result) {
						if (result.retCode == "000000") {
							getOrdConsumesByOrdId();
							getFoodsByStoreId(index);
						} else {
							layer.alert(result.retMsg);
						}
					});
				} else {
					top.$.jBox.open("iframe:${ctx}/reserve/addFood?storeId=${storeId}&orderId=${orderId}&foodId=" + foodId, "做法", 1150, 560, {
						buttons : {},
						loaded : function(h) {
							$(".jbox-content", top.document).css("overflow-y", "hidden");
						}
					});
				}
			} else {
				layer.confirm('该菜品无库存，请选择其他菜品！');
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
	</script>
</head>
<body>
	<div class="row-fluid">
	<jsp:include page="../common/common_read_printer.jsp"></jsp:include>
	<div class="span8">
			<form:form id="inputForm" action="" method="post" class="form-horizontal">
				<div class="row">
					<div class="span7 tableNo" style="line-height:36px; color:#555;">
						<label style="margin-right:20px">台号：<span title="${tableNo}" style="color:#E04445;font-weight:bold;display:inline-block;width: 89px;overflow:hidden;text-overflow:ellipsis;white-space:normal;vertical-align:top;">${ordReserve.tableNo}</span></label>
						<label>用餐人数：<span id="useNum" style="color:#E04445;font-weight:bold;display:inline-block;width: 89px;overflow:hidden;text-overflow:ellipsis;white-space:normal;vertical-align:top;">${useNum }</span></label>
					</div>
					
					<ul class="nav nav-tabs nav-justified" id="tab">
						 <li>
				         	<a href="#tab2" data-id="tab2" data-taggle="tab" onclick="getOrdLogByOrdId();">操作日志</a>
				         </li>
				         <li>
				         	<a href="#tab1" data-id="tab1" data-taggle="tab" onclick="getOrdTableById()">台号信息</a>
				         </li>    
				         <li>
				         	<a href="#tab0" data-id="tab0" data-taggle="tab" onclick="getOrdConsumesByOrdId()">明细账</a>
				         </li>
				     </ul>
				 </div>
			     <div class="tab-content" style="position: relative;">
			     	<div class="tab-pane active" id="tab0" >
			     		<jsp:include page="./reserveInfoDetail.jsp"></jsp:include>
			     	</div>
			     	<div class="tab-pane" id="tab1">
			     		<jsp:include page="./reserveInfo.jsp"></jsp:include>
			     	</div>
			     	<div class="tab-pane" id="tab2">
			     		<jsp:include page="./reserveInfoLog.jsp"></jsp:include>
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
					<input name="tuidanBtn" class="btn btn-primary" type="button" ${tuidanBtn} <shiro:lacksPermission name="index:order:tuidan">disabled</shiro:lacksPermission> value="退单"/>&nbsp;
					<input name="zuofaBtn" class="btn btn-primary" type="button" ${zuofaBtn} <shiro:lacksPermission name="index:order:zuofa">disabled</shiro:lacksPermission> value="做法"/>&nbsp;
					<input name="zhekouBtn" class="btn btn-primary" type="button" ${zhekouBtn} <shiro:lacksPermission name="index:order:zhekou">disabled</shiro:lacksPermission> value="折扣"/>&nbsp;
					<input name="zengsongBtn" class="btn btn-primary" type="button" ${zengsongBtn} <shiro:lacksPermission name="index:order:zengsong">disabled</shiro:lacksPermission> value="赠送"/>&nbsp;
					<input name="zhuantaiBtn" class="btn btn-primary" type="button" ${zhuantaiBtn} <shiro:lacksPermission name="index:order:zhuantai">disabled</shiro:lacksPermission> value="转台"/>&nbsp;
					<input name="printBtn" class="btn btn-primary" type="button" ${printBtn} <shiro:lacksPermission name="index:order:print">disabled</shiro:lacksPermission> value="打印预订单"/>&nbsp;
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