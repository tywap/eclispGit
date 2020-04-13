<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<title>新增活动</title>
<meta name="decorator" content="default" />
 <style type="text/css">
.mui-numbox [class*=numbox-btn]{
	width: 30px;
}
.mui-numbox{position:relative;display:inline-block;overflow:hidden;width:60px;height:35px;padding:0 40px;vertical-align:top;vertical-align:middle;border:solid 1px #bbb;border-radius:3px;background-color:#efeff4}.mui-numbox [class*=btn-numbox],.mui-numbox [class*=numbox-btn]{font-size:18px;font-weight:400;line-height:100%;position:absolute;top:0;overflow:hidden;width:40px;height:100%;padding:0;color:#555;border:none;border-radius:0;background-color:#f9f9f9}.mui-numbox [class*=btn-numbox]:active,.mui-numbox [class*=numbox-btn]:active{background-color:#ccc}.mui-numbox [class*=btn-numbox][disabled],.mui-numbox [class*=numbox-btn][disabled]{color:silver}.mui-numbox .mui-btn-numbox-plus,.mui-numbox .mui-numbox-btn-plus{right:0;border-top-right-radius:3px;border-bottom-right-radius:3px}.mui-numbox .mui-btn-numbox-minus,.mui-numbox .mui-numbox-btn-minus{left:0;border-top-left-radius:3px;border-bottom-left-radius:3px}.mui-numbox .mui-input-numbox,.mui-numbox .mui-numbox-input{display:inline-block;overflow:hidden;width:100%!important;height:100%;margin:0;padding:0 3px!important;text-align:center;text-overflow:ellipsis;word-break:normal;border:none!important;border-right:solid 1px #ccc!important;border-left:solid 1px #ccc!important;border-radius:0!important}.mui-input-row .mui-numbox{float:right;margin:2px 8px}@font-face{font-family:Muiicons;font-weight:400;font-style:normal;src:url(../fonts/mui.ttf) format('truetype')}.mui-icon{font-family:Muiicons;font-size:24px;color:#fff;font-weight:400;font-style:normal;line-height:1;display:inline-block;text-decoration:none;-webkit-font-smoothing:antialiased}.mui-icon.mui-active{color:#007aff}.mui-icon.mui-right:before{float:right;padding-left:.2em}.mui-icon-contact:before{content:'\e100'}.mui-icon-person:before{content:'\e101'}.mui-icon-personadd:before{content:'\e102'}.mui-icon-contact-filled:before{content:'\e130'}.mui-icon-person-filled:before{content:'\e131'}.mui-icon-personadd-filled:before{content:'\e132'}.mui-icon-phone:before{content:'\e200'}.mui-icon-email:before{content:'\e201'}.mui-icon-chatbubble:before{content:'\e202'}.mui-icon-chatboxes:before{content:'\e203'}.mui-icon-phone-filled:before{content:'\e230'}.mui-icon-email-filled:before{content:'\e231'}.mui-icon-chatbubble-filled:before{content:'\e232'}.mui-icon-chatboxes-filled:before{content:'\e233'}.mui-icon-weibo:before{content:'\e260'}.mui-icon-weixin:before{content:'\e261'}.mui-icon-pengyouquan:before{content:'\e262'}.mui-icon-chat:before{content:'\e263'}.mui-icon-qq:before{content:'\e264'}.mui-icon-videocam:before{content:'\e300'}.mui-icon-camera:before{content:'\e301'}.mui-icon-mic:before{content:'\e302'}.mui-icon-location:before{content:'\e303'}.mui-icon-mic-filled:before,.mui-icon-speech:before{content:'\e332'}.mui-icon-location-filled:before{content:'\e333'}.mui-icon-micoff:before{content:'\e360'}.mui-icon-image:before{content:'\e363'}.mui-icon-map:before{content:'\e364'}.mui-icon-compose:before{content:'\e400'}.mui-icon-trash:before{content:'\e401'}.mui-icon-upload:before{content:'\e402'}.mui-icon-download:before{content:'\e403'}.mui-icon-close:before{content:'\e404'}.mui-icon-redo:before{content:'\e405'}.mui-icon-undo:before{content:'\e406'}.mui-icon-refresh:before{content:'\e407'}.mui-icon-star:before{content:'\e408'}.mui-icon-plus:before{content:'\e409'}.mui-icon-minus:before{content:'\e410'}.mui-icon-checkbox:before,.mui-icon-circle:before{content:'\e411'}.mui-icon-clear:before,.mui-icon-close-filled:before{content:'\e434'}.mui-icon-refresh-filled:before{content:'\e437'}.mui-icon-star-filled:before{content:'\e438'}.mui-icon-plus-filled:before{content:'\e439'}.mui-icon-minus-filled:before{content:'\e440'}.mui-icon-circle-filled:before{content:'\e441'}.mui-icon-checkbox-filled:before{content:'\e442'}.mui-icon-closeempty:before{content:'\e460'}.mui-icon-refreshempty:before{content:'\e461'}.mui-icon-reload:before{content:'\e462'}.mui-icon-starhalf:before{content:'\e463'}.mui-icon-spinner:before{content:'\e464'}.mui-icon-spinner-cycle:before{content:'\e465'}.mui-icon-search:before{content:'\e466'}.mui-icon-plusempty:before{content:'\e468'}.mui-icon-forward:before{content:'\e470'}.mui-icon-back:before,.mui-icon-left-nav:before{content:'\e471'}.mui-icon-checkmarkempty:before{content:'\e472'}.mui-icon-home:before{content:'\e500'}.mui-icon-navigate:before{content:'\e501'}.mui-icon-gear:before{content:'\e502'}.mui-icon-paperplane:before{content:'\e503'}.mui-icon-info:before{content:'\e504'}.mui-icon-help:before{content:'\e505'}.mui-icon-locked:before{content:'\e506'}.mui-icon-more:before{content:'\e507'}.mui-icon-flag:before{content:'\e508'}.mui-icon-home-filled:before{content:'\e530'}.mui-icon-gear-filled:before{content:'\e532'}.mui-icon-info-filled:before{content:'\e534'}.mui-icon-help-filled:before{content:'\e535'}.mui-icon-more-filled:before{content:'\e537'}.mui-icon-settings:before{content:'\e560'}.mui-icon-list:before{content:'\e562'}.mui-icon-bars:before{content:'\e563'}.mui-icon-loop:before{content:'\e565'}.mui-icon-paperclip:before{content:'\e567'}.mui-icon-eye:before{content:'\e568'}.mui-icon-arrowup:before{content:'\e580'}.mui-icon-arrowdown:before{content:'\e581'}.mui-icon-arrowleft:before{content:'\e582'}.mui-icon-arrowright:before{content:'\e583'}.mui-icon-arrowthinup:before{content:'\e584'}.mui-icon-arrowthindown:before{content:'\e585'}.mui-icon-arrowthinleft:before{content:'\e586'}.mui-icon-arrowthinright:before{content:'\e587'}.mui-icon-pulldown:before{content:'\e588'}.mui-fullscreen{position:absolute;top:0;right:0;bottom:0;left:0}.mui-fullscreen.mui-slider .mui-slider-group{height:100%}.mui-fullscreen .mui-segmented-control~.mui-slider-group{position:absolute;top:40px;bottom:0;width:100%;height:auto}.mui-fullscreen.mui-slider .mui-slider-item>a{top:50%;-webkit-transform:translateY(-50%);transform:translateY(-50%)}.mui-fullscreen .mui-off-canvas-wrap .mui-slider-item>a{top:auto;-webkit-transform:none;transform:none}.mui-bar-nav~.mui-content .mui-slider.mui-fullscreen{top:44px}.mui-bar-tab~.mui-content .mui-slider.mui-fullscreen .mui-segmented-control~.mui-slider-group{bottom:50px}.mui-android.mui-android-4-0 input:focus,.mui-android.mui-android-4-0 textarea:focus{-webkit-user-modify:inherit}.mui-android.mui-android-4-2 input,.mui-android.mui-android-4-2 textarea,.mui-android.mui-android-4-3 input,.mui-android.mui-android-4-3 textarea{-webkit-user-select:text}.mui-ios .mui-table-view-cell{-webkit-transform-style:preserve-3d;transform-style:preserve-3d}.mui-plus-visible,.mui-wechat-visible{display:none!important}.mui-plus-hidden,.mui-wechat-hidden{display:block!important}.mui-tab-item.mui-plus-hidden,.mui-tab-item.mui-wechat-hidden{display:table-cell!important}.mui-plus .mui-plus-visible,.mui-wechat .mui-wechat-visible{display:block!important}.mui-plus .mui-tab-item.mui-plus-visible,.mui-wechat .mui-tab-item.mui-wechat-visible{display:table-cell!important}.mui-plus .mui-plus-hidden,.mui-wechat .mui-wechat-hidden{display:none!important}.mui-plus.mui-statusbar.mui-statusbar-offset .mui-bar-nav{height:64px;padding-top:20px}.mui-plus.mui-statusbar.mui-statusbar-offset .mui-bar-nav~.mui-content{padding-top:64px}.mui-plus.mui-statusbar.mui-statusbar-offset .mui-bar-header-secondary,.mui-plus.mui-statusbar.mui-statusbar-offset .mui-bar-nav~.mui-content .mui-pull-top-pocket{top:64px}.mui-plus.mui-statusbar.mui-statusbar-offset .mui-bar-header-secondary~.mui-content{padding-top:94px}.mui-iframe-wrapper{position:absolute;right:0;left:0;-webkit-overflow-scrolling:touch}.mui-iframe-wrapper iframe{width:100%;height:100%;border:0}

.mui-numbox .mui-numbox-input {
    display: inline-block;
    overflow: hidden;
    height: 35px;
    margin: 0;
    padding: 0 3px!important;
    text-align: center;
    text-overflow: ellipsis;
    word-break: normal;
    border: none!important;
    border-right: solid 1px #ccc!important;
    border-left: solid 1px #ccc!important;
    border-radius: 0!important;
}

	input::-webkit-outer-spin-button,
    input::-webkit-inner-spin-button {
        -webkit-appearance: none !important;
        margin: 0;
    }


</style>
 <script type="text/javascript">
 var weeks = '${cfFoodSpecial.andValue}';
	 $(document).ready(function() {
		//解绑事件
			var eventName = "dishesSettingForm";
			top.$.unsubscribe(eventName);
			//注册事件，弹出页面需要刷新本页面，或者弹出页面回传数据用
			top.$.subscribe(eventName, function(e, data) {
				foodSelect(data);
			});
			
		//菜品选择
		$("#addfood").bind("click", function() {
			top.$.jBox.open("iframe:${ctx}/setting/ctFood/select?status=0", "菜品选择", 1000, $(top.document).height() - 180, {
				buttons : {},
				loaded : function(h) {
					$(".jbox-content", top.document).css("overflow-y", "hidden");
				}
			});
		});
		//加载所有餐厅
		loadCheckbox("companyCheckDiv","${ctx}/sys/userutils/getOfficeListByType",{typesJson:"['3','4','5']"},'${storeList}','storeId','id','name');
		
		if(weeks.indexOf("1") != -1){
			$('#weeks_1').attr('checked', 'checked');
		}
		if(weeks.indexOf("2") != -1){
			 $("#weeks_2").prop("checked", true);
		}
		if(weeks.indexOf("3") != -1){
			 $("#weeks_3").prop("checked", true);
		}
		if(weeks.indexOf("4") != -1){
			 $("#weeks_4").prop("checked", true);
		}
		if(weeks.indexOf("5") != -1){
			 $("#weeks_5").prop("checked", true);
		}
		if(weeks.indexOf("6") != -1){
			 $("#weeks_6").prop("checked", true);
		}
		if(weeks.indexOf("7") != -1){
			 $("#weeks_7").prop("checked", true);
		}
	}); 
	
		//根据选择的小类加载餐厅
		function getStore(){
			 //获取被选中的option标签
			 var foodTypeId = $('#foodType  option:selected').val();
			 if (foodTypeId!="") {
				 loadCheckbox("companyCheckDiv","${ctx}/setting/ctFood/getFoodStore",{foodTypeId:foodTypeId},'${storeList}','storeId','id','foodTyepStore'); 
			}else {
				loadCheckbox("companyCheckDiv","${ctx}/sys/userutils/getOfficeListByType",{typesJson:"['3','4','5']"},'${storeList}','storeId','id','name');
			}
		}
	 
	 //加载选择的菜品
	 function foodSelect(data) {
			var onkeyup ="''";
			var list =[];
		        $("input[name='foodId']").each(function(){
		        	list.push($(this).val());
		        })
			 for (var i = 0; i < data.testData.length; i++) {
				 var params = {id:data.testData[i]}
				 loadAjax("${ctx}/setting/ctFood/foodSelect", params, function(result) {
						if (result.retCode == "000000") {
							var data=result.list;
							var boole=true;
								for (var i = 0; i < list.length; i++) {
									if (data[0].id == list[i]) {
										boole=false;
									}
							    }
								if (boole) {
									var len=$("#setMealList tr").length+parseInt(1);
									var setMealList="<tr>"+
									"<input type='hidden' value='"+data[0].id+"' name='foodId'>"+
									"<td>"+len+"</td>"+
									"<td>"+data[0].code+"</td>"+
									"<td>"+data[0].name+"</td>"+
									"<td>"+data[0].foodUnitName+"</td>"+
									"<td>"+data[0].price.amount+"</td>"+
									"<td><div class='mui-numbox' data-numbox-step='1' data-numbox-min='1' data-numbox-max=''>"+
									"<button class='mui-btn mui-numbox-btn-minus' type='button'  onclick='decrease(this,"+data[0].price.amount+")'>-</button>"+
									"<input name='number' id='input' class='mui-numbox-input' type='number' data-max='10' value='1' readonly='readonly' >"+
									"<button id='buyCount'  class='mui-btn mui-numbox-btn-plus' type='button' onclick='add(this,"+data[0].price.amount+")';>+</button>"+
									"</div></td>"+
									"<td><a class='delete' data-id="+data[0].id+" onclick='remove(this,"+data[0].price.amount+","+prices+");' >移除</a></td>"+
									"</tr>"
									 $("#setMealList").append(setMealList);
									 var  prices =document.getElementById('totalInput1').value;
									 prices=parseInt(prices)+parseInt(data[0].price.amount);
									 document.getElementById("totalInput").value="小计：共计  "+len+" 份菜品，单品合计 "+prices+"元；";
									 document.getElementById("totalInput1").value=prices;
									 s=len;
								}
						} else {
							layer.alert(result.retMsg);
						}
					});
			}
	}
	 
	 //加载套餐
	 function loadSetMeal() {
			var original=0;
			for (var i = 0; i < foodList.length; i++) {
				var len=$("#setMealList tr").length+parseInt(1);
				var setMealList="<tr>"+
				"<input type='hidden' value='"+foodList[i].id+"' name='foodId'>"+
				"<td>"+len+"</td>"+
				"<td>"+foodList[i].code+"</td>"+
				"<td>"+foodList[i].name+"</td>"+
				"<td>"+foodList[i].unit+"</td>"+
				"<td>"+foodList[i].price.amount+"</td>"+
				"<td><div class='mui-numbox' data-numbox-step='1' data-numbox-min='1' data-numbox-max=''>"+
				"<button class='mui-btn mui-numbox-btn-minus' type='button'  onclick='decrease(this,"+foodList[i].price.amount+")'>-</button>"+
				"<input name='number' id='input' class='mui-numbox-input' type='number' data-max='10' value='"+foodCfg[i].value+"' readonly='readonly' >"+
				"<button id='buyCount'  class='mui-btn mui-numbox-btn-plus' type='button' onclick='add(this,"+foodList[i].price.amount+")';>+</button>"+
				"</div></td>"+
				"<td><a class='delete' data-id="+foodList[i].id+" onclick='remove(this,"+foodList[i].price.amount+");' >移除</a></td></tr>";
				 $("#setMealList").append(setMealList);
				 var prices =document.getElementById('totalInput1').value;
				 prices=parseInt(prices)+parseInt(foodList[i].price.amount)*parseInt(foodCfg[i].value);
				 document.getElementById("totalInput1").value=prices;
				 document.getElementById("totalInput").value="小计：共计  "+len+" 份菜品，单品合计 "+prices+" 元；";
			}
	}
	 
	 //加载做法
	 function loadMethod() {
		 var params={};
		 loadAjax("${ctx}/setting/ctFood/getModus", params, function(result) {
			 $("#methodList").empty();
				if (result.retCode == "000000") {
					var data=result.ret;
					$.each(data, function (key, value) {
						var inputs="";
						var boole=true;
						for (var i = 0; i < value.length; i++) {
							for (var k = 0; k < foodCfg.length; k++) {
								if (value[i].id == foodCfg[k].value) {
									boole=false;
									inputs+="<label><input class='checkbox' id='"+value[i].id+"' type='checkbox' checked><span>&nbsp;"+value[i].name+"</span>&nbsp;&nbsp;</label>";
									break;
								}else {
									boole=true;
								}
							}
							if (boole) {
								inputs+="<label><input id='"+value[i].id+"' type='checkbox' ><span>&nbsp;"+value[i].name+"</span>&nbsp;&nbsp;</label>";
							}
						}
						var arr = key.split(",");
						var methodList="<tr>"+
						"<td id="+arr[0]+" name='foodType'>"+arr[1]+"</td>"+
						"<td style='text-align:left'>"+inputs+"</td>"+
						"</tr>"
						$("#methodList").append(methodList);
					});
				} else {
					layer.alert(result.retMsg);
				}
			});
	}
	 
	 //菜品增加
	 function add(obj,price) {
		    var tr = this.getRowObj(obj);
		    if (tr != null) {
		    	var prices =document.getElementById('totalInput1').value;
				prices=parseInt(prices)+parseInt(price);
				document.getElementById("totalInput").value="小计：共计  "+s+" 份菜品，单品合计 "+prices+" 元；";
				var number = $(obj).parents('tr').find('.mui-numbox-input').val();
				document.getElementById("totalInput1").value=prices;
				number=parseInt(number)+1;
				tr.children[6].children[0].children[1].value=number;
			}
		} 
	 
	 //菜品减少
	 function decrease(obj,price){
		 var tr = this.getRowObj(obj);
		    if (tr != null) {
		    	var number = $(obj).parents('tr').find('.mui-numbox-input').val();
		    	if (number == '1') {
		    		layer.alert("该菜品不能再减少了");
				}else {
					var prices =document.getElementById('totalInput1').value;
					prices=parseInt(prices)-parseInt(price);
					document.getElementById("totalInput").value="小计：共计  "+s+" 份菜品，单品合计 "+prices+" 元；";
					document.getElementById("totalInput1").value=prices;
					number=parseInt(number)-1;
					tr.children[6].children[0].children[1].value=number;
				}
			}
	 }
	 
	 //增加打印机
	 function addRow() {
		 var myDiv = document.getElementById("printer");
		 var div_s = myDiv.getElementsByTagName("div");
		 var count =parseInt(div_s.length/3+1);
		 var html = ""+
			"<div class='span'>"+
			"<div class='control-group'>"+
			"<label class='control-label-xs'>打印机"+count+"：</label>"+
			"<div class='controls'>"+
				"<select name='printer"+count+"' id='printer"+count+"' class='select-medium6'>"+
						"<option value='0'"+
							"<c:if test='${modusList.parentId == var.value }'>  selected ='selected'</c:if>>普通</option>"+
				 "</select>"+
				"</div>"+
			  "</div>"+
			"</div>";
			$("#printer").append(html);
	}
	
	 function addActivity() {
		 var activitys = document.getElementById("activitys");
		 var i=activitys.children.length+1;
		 var html = ""+
		 "<span style='margin-left: 30px;' id='activity"+i+"' class='project'>方案"+i+"：满&nbsp;&nbsp;&nbsp;"+
		 "<input class='input-xlarge' style='width: 50px; height: 12px;' type='number' />&nbsp;&nbsp;元，减&nbsp;&nbsp;&nbsp;"+
		 "<input class='input-xlarge' style='width: 50px; height: 12px;' type='number' />元；&nbsp;"+
		 "<table>"+
		 "<input type='checkbox'>允许叠加满减&nbsp;"+
		 "<input class='btn btn-primary' type='button'  onclick='addActivity()' value='+' style='margin-left:21px;'/>"+
					 "<input class='btn btn-primary' type='button'  data-id='"+i+"' onclick='delActivity(this)' value='-' style='margin-left:21px;'/>"+
				 "</table>"+
			 "</span>";
		 $("#activitys").append(html);
	} 
	//删除列
	 function delActivity(obj) {
		var index=$(obj).data("id");
		$("#activity"+index).remove();
	}
	 
	 //移除菜品
	function remove(obj,price) {
		var tr = this.getRowObj(obj);
		if (tr != null) {
			var rows = tr.rowIndex;                           
			var count= $(obj).parents('tr').find('.mui-numbox-input').val();
			tr.parentNode.removeChild(tr);
			rows=rows-1;
			var prices =document.getElementById('totalInput1').value;
			prices=parseInt(prices)-parseInt(price*count);
			document.getElementById("totalInput").value="小计：共计  "+rows+" 份菜品，单品合计 "+prices+" 元；";
			document.getElementById("totalInput1").value=prices;
		} else {
			$.jBox.info("移除失败！");
		}
	}

	function getRowObj(obj) {
		var i = 0;
		while (obj.tagName.toLowerCase() != "tr") {
			obj = obj.parentNode;
			if (obj.tagName.toLowerCase() == "table")
				return null;
		}
		return obj;
	}

	//根据选择的菜品类别展示
	function changeHoteltype() {
		//获取被选中的option标签
		var text = $('#packageType  option:selected').text();
		if (text == "普通") {
			$("#setMeal").css("display", "none");
			$("#method").css("display", "none");
		}
		if (text == "套餐") {
			$("#setMeal").css("display", "block");
			$("#method").css("display", "none");
		}
		if (text == "做法") {
			$("#method").css("display", "block");
			$("#setMeal").css("display", "none");
			var params={};
			 loadAjax("${ctx}/setting/ctFood/getModus", params, function(result) {
				 $("#methodList").empty();
					if (result.retCode == "000000") {
						var data=result.ret;
						$.each(data, function (key, value) {
							var inputs="";
							for (var i = 0; i < value.length; i++) {
								inputs+="<label><input class='checkbox' id='"+value[i].id+"' type='checkbox' ><span>&nbsp;"+value[i].name+"</span>&nbsp;&nbsp;</label>";
							}
							var arr = key.split(",");
							var methodList="<tr>"+
							"<td id="+arr[0]+" name='foodType'>"+arr[1]+"</td>"+
							"<td style='text-align:left'>"+inputs+"</td>"+
							"</tr>"
							$("#methodList").append(methodList);
						});
					} else {
						layer.alert(result.retMsg);
					}
				});
		}

	}

	function save() {
		var form = document.getElementById("inputForm");
		var id=form.id.value;
		var code =form.code.value;
		if (code == null || code == '') {
			layer.alert('请填写活动编号');
        	return;
		}
		var name =form.name.value;
		if (name == null || name == '') {
			layer.alert('请填写活动名称');
        	return;
		}
		var activityType=form.activityType.value;
		if (activityType == null || activityType == '') {
			layer.alert('请选择活动类型');
        	return;
		}
		var status =form.status.value;
		if (status == null || status == '') {
			layer.alert('请选择状态');
        	return;
		}
		var shareFlag= form.shareFlag.checked;
		if (shareFlag) {
			shareFlag="1";
		}else {
			shareFlag="0";
		}
		var useCouponFlag= form.useCouponFlag.checked;
		if (useCouponFlag) {
			useCouponFlag="1";
		}else {
			useCouponFlag="0";
		}
		var effectiveDate=form.effectiveDate.value;
		var expireDate=form.expireDate.value;
		var effectiveTime=form.effectiveTime.value;
		var expiretime=form.expiretime.value;
		//周期checkbox
		var andValue=[];
		var weeks=document.getElementsByClassName("weeks");
		for (var i = 1; i < weeks.length; i++) {
			if (weeks[i].checked) {
				andValue.push(weeks[i].val);
			}
		}
		//方案
		var fullAmount=[];
		var reduceAmount=[];
		var overlayFlag=[];
		var projects=document.getElementsByClassName("project");
		for (var i = 0; i < projects.length; i++) {
			fullAmount.push(projects[i].children[0].value);
			reduceAmount.push(projects[i].children[1].value);
			var checked= projects[i].children[2].checked;
			if (checked) {
				overlayFlag.push(1);
			}else {
				overlayFlag.push(0);
			}
		}
		//分店checkbox
		var storeId=[];
		var cks = $("[name='storeId']:checked");
		for(var i=0;i<cks.length;i++){
			storeId.push(cks[i].value);
		}
     /*   var  params ="id="+id+"&code="+code+"&name="+name+"&pinyin="+pinyin+"&unit="+unit+"&price="+price+"&costRate="+costRate+"&foodType="+foodType+"&packageType="+packageType+"&status="+status;
			params =params+"&isWeigh="+isWeigh+"&isDiscount="+isDiscount+"&isCoupon="+isCoupon+"&isSeviceRate="+isSeviceRate;
			params =params+"&foodIds="+foodIds+"&numbers="+numbers+"&foodTypes="+foodTypes+"&types="+JSON.stringify(types)+"&storeName="+stores;
 */		var params={
		 id:id,
		 code:code,
		 name:name,
		 type:activityType,
		 status:status,
		 shareFlag:shareFlag,
		 useCouponFlag:useCouponFlag,
		 andValue:andValue.join(','),
		 fullAmount:fullAmount.join(','),
		 reduceAmount:reduceAmount.join(','),
		 overlayFlag:overlayFlag.join(','),
		 storeId:storeId.join(','),
		 effectiveDate:effectiveDate,
		 expireDate:expireDate,
		 effectiveTime:effectiveTime,
		 expireTime:expireTime
		 
 		}
		 loadAjax("${ctx}/ota/activitySet/saveActivity", params, function(result) {
			if (result.retCode == "000000") {
				if (saveStatus == 0) {
					layer.alert("保存成功");
					top.$.publish("dishesSetting", {
						testData : "hello"
					});
					window.parent.jBox.close();
				}else {
					layer.alert("保存成功");
					$("#name").attr("value","");
					$("#pinyin").attr("value","");
					$("#price").attr("value","");
					$("#costRate").attr("value","");
					$("#isWeigh").prop("checked",false);
					if (form.packageType.options[ form.packageType.selectedIndex].innerHTML=='套餐') {
						$("#setMealList").empty(); 
						 document.getElementById("totalInput").value="小计：共计  0  份菜品，单品合计 0.00元；";
					}
				}
			} else {
				layer.alert(result.retMsg);
			}
		}); 
	}
	
</script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="sysBusiConfig" action="${ctx}/setting/ctFood/save" method="post" class="form-horizontal">
		<input name="id" id="id" value="${ctFood.id }" type="text" htmlescape="false" maxlength="64" style="display: none;">
		<div class="row" style="margin-top: 20px;">
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><span class="help-inline"><font
							color="red">*</font> </span>活动编号：</label>
					<div class="controls">
						<input name="code" id="code" value="${ctFood.code }"
							type="text" htmlescape="false" maxlength="64"
							class="input-xlarge required" >
					</div>
				</div>
			</div>

			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><font color="red">*</font>活动名称：</label>
					<div class="controls">
						<input name="name" id="name" value="${ctFood.name }"
							type="text" htmlescape="false" maxlength="64"
							class="input-xlarge required">
					</div>
				</div>
			</div>
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><font color="red">*</font>活动类型：</label>
					<div class="controls">
						<select name="activityType" id="activityType" class="select-medium6">
							<c:forEach items="${activityTypeList}" var="var" varStatus="vs">
								<option value="${var.id}"
									<c:if test="${ctFood.foodType == var.id }">  selected ="selected"</c:if>>${var.name}</option>
							</c:forEach>
						</select> 
					</div>
				</div>
			</div>
			<div class="span" style="width: 25%">
				<div class="control-group">
					<label class="control-label-xs"><font color="red">*</font>状态：</label>
					<div class="controls">
						<select name="status" id="status" class="select-medium6">
								<option value="0">启用</option>
								<option value="1">停用</option>
						</select> 
					</div>
				</div>
			</div>
			<div class="span" style="width: 20%; margin-left: 50px;">
				<div class="control-group">
					<div class="controls">
						<label><input name="shareFlag" id="shareFlag" type="checkbox"  <c:if test="${ctFood.isWeigh == '1' }">checked="checked"</c:if> >
						 不予其他活动同享</label>
					</div>
				</div>
			</div>
			<div class="span" style="width: 20%">
				<div class="control-group">
					<div class="controls">
						<label><input name="useCouponFlag" id="useCouponFlag" type="checkbox"   <c:if test="${ctFood.isCoupon == '1' }">checked="checked"</c:if>>
						是否允许使用优惠券</label>
					</div>
				</div>
			</div>
		</div>
		<hr>
		<div class="row" style="margin-top: 10px;">
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><span class="help-inline"><font
							color="red">*</font> </span>特价日期：</label>
					<div class="controls">
						<input id="effectiveDate" style="margin-right:3px;" name="effectiveDate" type="text" readonly="readonly" maxlength="20" class="Wdate input-medium6"
                        value="${cfFoodSpecial.effectiveDate }" pattern="yyyy-MM-dd"
                        onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false,});" />-
		                <input id="expireDate" name="expireDate" type="text" readonly="readonly" maxlength="20" class="input-medium6 Wdate "
		                value="${cfFoodSpecial.expireDate }" pattern="yyyy-MM-dd"
		                onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false,});" />
					</div>
				</div>
			</div>
		</div>
		<div class="row" style="margin-top: 10px;">
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><span class="help-inline"><font
							color="red">*</font> </span>特价时段：</label>
					<div class="controls">
						<input id="effectiveTime" style="margin-right:3px;" name="effectiveTime" type="text" readonly="readonly" maxlength="20" class="Wdate input-medium6"
                        value="${cfFoodSpecial.effectiveTime }" pattern="HH:mm"
                        onclick="WdatePicker({dateFmt:'HH:mm',isShowClear:false,});" />-
		                <input id="expiretime" name="expiretime" type="text" readonly="readonly" maxlength="20" class="input-medium6 Wdate "
		                value="${cfFoodSpecial.expireTime }" pattern="HH:mm"
		                onclick="WdatePicker({dateFmt:'HH:mm',isShowClear:false,});" />
					</div>
				</div>
			</div>
		</div>
		<div class="row" style="margin-top: 10px;">
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><font color="red">*</font>特价周期：</label>
					<div class="controls">
					<div class="widget-content" >
					<label>
						<input type="checkbox" class="weeks" id="weeks_1" value="1" />周一</label>
					<label>
						<input type="checkbox" class="weeks" id="weeks_2" value="2" />周二</label>
					<label>
						<input type="checkbox" class="weeks" id="weeks_3" value="3" />周三</label>
					<label>
						<input type="checkbox" class="weeks" id="weeks_4" value="4" />周四</label>
					<label>
						<input type="checkbox" class="weeks" id="weeks_5" value="5" />周五</label>
					<label>
						<input type="checkbox" class="weeks" id="weeks_6" value="6" />周六</label>
					<label>
						<input type="checkbox" class="weeks" id="weeks_7" value="7" />周日</label>
					</div>
					</div>
				</div>
			</div>
		</div>
		<hr>
		<div id="activitys">
			<span style="margin-left: 30px;" id="activity1" class="project">方案1：满&nbsp&nbsp
			<input class="input-xlarge " style="width: 50px; height: 12px;" type="number" />&nbsp&nbsp元，减&nbsp&nbsp
			<input class="input-xlarge " style="width: 50px; height: 12px;" type="number" />元；
				<table>
					<input type="checkbox">允许叠加满减
					<input class="btn btn-primary" type="button" onclick="addActivity()" value='+' style='margin-left: 21px;' />
				</table>
			</span>
		</div>
		<div  id="store">
			 <hr>
			<!-- 分店选择 -->
			<div class="row">
				<div class="span12">
					<div class="control-group">
						<label class="control-label-xs">适用餐厅：</label>
						<div class="controls" id="companyCheckDiv">
						<jsp:include page="../../common/common_store_select.jsp"></jsp:include>
						</div> 
					</div>
				</div>
			</div>
		</div>
		<div class="fixed-btn-right">
			<input id="submitBtn" class="btn btn-primary" type="button"
				value="保  存" onclick="save();">&nbsp;
		</div>
	</form:form>
</body>
</html>