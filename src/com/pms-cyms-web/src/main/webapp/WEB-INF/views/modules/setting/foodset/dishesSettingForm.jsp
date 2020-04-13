<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<title>新增菜品</title>
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


</style>
 <script type="text/javascript">
var count =0;//打印机数量
var foodCfg=${foodCfgList};
var foodList=${foodList};
var s=foodCfg.length;//菜品数量
var prices='${ctFood.price}';//价格
var text='${ctFood.packageTypeName}';//菜品类型
if (prices != '' && prices != null) {
	$("#totalInput1").attr("value","${ctFood.price}");
}
if (foodCfg == '' || foodCfg == null) {
	s=0;
}
	 $(document).ready(function() {
		//解绑事件
			var eventName = "dishesSettingForm";
			top.$.unsubscribe(eventName);
			//注册事件，弹出页面需要刷新本页面，或者弹出页面回传数据用
			top.$.subscribe(eventName, function(e, data) {
				foodSelect(data);
			});
			
		$("#addRowBtn").bind("click", function() {
			addRow();
		});
		if (text == "普通" || text=='') {
			$("#setMeal").css("display", "none");
			$("#method").css("display", "none");
		}if (text == "套餐") {
			$("#setMeal").css("display", "block");
			$("#method").css("display", "none");
			loadSetMeal();
		}if (text == "做法") {
			$("#method").css("display", "block");
			$("#setMeal").css("display", "none");
			loadMethod();
		}
		
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
		getStore();
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

	function save(saveStatus) {
		var form = document.getElementById("inputForm");
		var id=form.id.value;
		var code =form.code.value;
		if (code == null || code == '') {
			layer.alert('请填写菜品编号');
        	return;
		}
		var name =form.name.value;
		if (name == null || name == '') {
			layer.alert('请填写菜品名称');
        	return;
		}
		var pinyin=form.pinyin.value;
		if (pinyin == null || pinyin == '') {
			layer.alert('请填写菜品简拼');
        	return;
		}
		var unit =form.unit.value;
		if (unit == null || unit == '') {
			layer.alert('请填写菜品单位');
        	return;
		}
		var price =form.price.value;
		if (price == null || price == '') {
			layer.alert('请填写菜品单价');
        	return;
		}
		var costRate=form.costRate.value;
		if (costRate == null || costRate == '') {
			layer.alert('请填写菜品成本率');
        	return;
		}if (costRate.indexOf("%") != -1 ) {
			costRate=costRate.replace(/%/g,"")
		}
		var foodType= form.foodType.value;
		if (foodType == null || foodType == '') {
			layer.alert('请选择菜品小类');
        	return;
		}
		var packageType= form.packageType.value;
		var status= form.status.value;
		var isWeigh= form.isWeigh.checked;
		if (isWeigh) {
			isWeigh="1";
		}else {
			isWeigh="0";
		}
		var isDiscount= form.isDiscount.checked;
		if (isDiscount) {
			isDiscount="1";
		}else {
			isDiscount="0";
		}
		var isCoupon= form.isCoupon.checked;
		if (isCoupon) {
			isCoupon="1";
		}else {
			isCoupon="0";
		}
		var isSeviceRate= form.isSeviceRate.checked;
		if (isSeviceRate) {
			isSeviceRate="1";
		}else {
			isSeviceRate="0";
		}
		var passFood=document.getElementById("passFood");
		var foodIds=[];//套餐菜品id
        var numbers=[];//套餐菜品数量
		var foodTypes=[];//做法id
        var types={};//做法类型id
		if (form.packageType.options[ form.packageType.selectedIndex].innerHTML=='套餐') {
			$("input[name='foodId']").each(function(index,item){
                foodIds.push($(this).val());
            })
			$("input[name='number']").each(function(index,item){
            	if($(this).val() == ''){
            		numbers = null;
            	}else{
            		numbers.push($(this).val());
            	}
            })
            if(numbers == null  || numbers == ''){
				layer.alert('请填写菜品数量');
            	return;
			}
		}else if (form.packageType.options[ form.packageType.selectedIndex].innerHTML=='做法') {
            var methodList = document.getElementById("methodList");// table 的 id
            var rows = methodList.rows;                           // 获取表格所有行
			for (var i = 0; i < rows.length; i++) {
				var cells = rows[i].cells;
				var cs = cells[1].children;
				var pus = false;
				var input='';
				 for (var j = 0; j < cs.length; j++) {
					if (cs[j].children[0].checked == true) {
						pus = true;
						var typeId=cs[j].children[0].id;
						input+=typeId+",";
					}
				}
				if (pus) {
					foodTypes.push(cells[0].id);
					types[cells[0].id]=input.substring(0,input.length-1);
				} 
			}
		}
		//分店checkbox
		var stores=[];
		var cks = $("[name='storeId']:checked");
		for(var i=0;i<cks.length;i++){
			stores.push(cks[i].value);
		}
       var  params ="id="+id+"&code="+code+"&name="+name+"&pinyin="+pinyin+"&unit="+unit+"&price="+price+"&costRate="+costRate+"&foodType="+foodType+"&packageType="+packageType+"&status="+status;
			params =params+"&isWeigh="+isWeigh+"&isDiscount="+isDiscount+"&isCoupon="+isCoupon+"&isSeviceRate="+isSeviceRate;
			params =params+"&foodIds="+foodIds+"&numbers="+numbers+"&foodTypes="+foodTypes+"&types="+JSON.stringify(types)+"&storeName="+stores;
		loadAjax("${ctx}/setting/ctFood/save", params, function(result) {
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
							color="red">*</font> </span>菜品编号：</label>
					<div class="controls">
						<input name="code" id="code" value="${ctFood.code }"
							type="text" htmlescape="false" maxlength="64"
							class="input-xlarge required" >
					</div>
				</div>
			</div>

			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><font color="red">*</font>菜品名称：</label>
					<div class="controls">
						<input name="name" id="name" value="${ctFood.name }"
							type="text" htmlescape="false" maxlength="64"
							class="input-xlarge required">
					</div>
				</div>
			</div>
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><font color="red">*</font>菜品简称：</label>
					<div class="controls">
						<input name="pinyin" id="pinyin" value="${ctFood.pinyin }"
							type="text" htmlescape="false" maxlength="200"
							class="input-medium6 ">
					</div>
				</div>
			</div>
			<div class="span" id="foodUntis">
				<div class="control-group">
					<label class="control-label-xs" ><font color="red">*</font>单位：</label>
					<div class="controls">
					    <select name="unit" id="unit" class="select-medium6">
							<c:forEach items="${foodUnitsList}" var="var" varStatus="vs">
								<option value="${var.id}"
									<c:if test="${ctFood.unit == var.id }">  selected ="selected"</c:if>>${var.name}</option>
							</c:forEach>
						</select> 
					</div>
				</div>
			</div>
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs" ><font color="red">*</font>单价：</label>
					<div class="controls">
						<input name="price" id="price" value="${ctFood.price }"
							type="text" htmlescape="false" maxlength="200"
							class="input-medium6 "
							onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}"
                            onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'0')}else{this.value=this.value.replace(/\D/g,'')}">
					</div>
				</div>
			</div>
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><font color="red">*</font>成本额：</label>
					<div class="controls">
					<c:if test="${ctFood.costRate != null}">
						<input name="costRate" id="costRate" value="${ctFood.costRate }"
							type="text" htmlescape="false" maxlength="200"
							class="input-medium6 "
							onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^\d.]/g,'')}else{this.value=this.value.replace(/\D/g,'')}"
                            onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^\d.]/g,'0')}else{this.value=this.value.replace(/\D/g,'')}">
                          </c:if>
                    <c:if test="${ctFood.costRate == null}">
						<input name="costRate" id="costRate" value="${ctFood.costRate }"
							type="text" htmlescape="false" maxlength="200"
							class="input-medium6 "
							onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}"
                            onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'0')}else{this.value=this.value.replace(/\D/g,'')}">
                          </c:if>
					</div>
				</div>
			</div>
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><font color="red">*</font>菜品小类：</label>
					<div class="controls">
						<select name="foodType" id="foodType" class="select-medium6" onclick="getStore()">
							<option value="">全部</option>
							<c:forEach items="${littleTypeList}" var="var" varStatus="vs">
								<option value="${var.id}"
									<c:if test="${ctFood.foodType == var.id }">  selected ="selected"</c:if>>${var.name}(${var.code })</option>
							</c:forEach>
						</select> 
					</div>
				</div>
			</div>
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><font color="red">*</font>菜品类别：</label>
					<div class="controls">
						<select name="packageType" id="packageType" class="select-medium6" onchange="changeHoteltype();">
								<c:forEach items="${foodTypeList}" var="var" varStatus="vs">
								<option value="${var.id}"
									<c:if test="${ctFood.packageType == var.id }">  selected ="selected"</c:if>>${var.name}</option>
							</c:forEach>
						</select> 
					</div>
				</div>
			</div>
			<div class="span" style="width: 25%">
				<div class="control-group">
					<label class="control-label-xs">状态：</label>
					<div class="controls">
						<select name="status" id="status" class="select-medium6">
								<option value="0">启用</option>
								<option value="1">停用</option>
						</select> 
					</div>
				</div>
			</div>
			<div class="span" style="width: 15%">
				<div class="control-group">
					<div class="controls">
						<label><input name="isWeigh" id="isWeigh" type="checkbox"  <c:if test="${ctFood.isWeigh == '1' }">checked="checked"</c:if> >
						是否称重</label>
					</div>
				</div>
			</div>
			<div class="span" style="width: 20%">
				<div class="control-group">
					<div class="controls">
						<label><input name="isDiscount" id="isDiscount" type="checkbox"   <c:if test="${ctFood.isDiscount == '1' }">checked="checked"</c:if>>
						是否允许折扣</label>
					</div>
				</div>
			</div>
			<div class="span" style="width: 20%">
				<div class="control-group">
					<div class="controls">
						<label><input name="isCoupon" id="isCoupon" type="checkbox"   <c:if test="${ctFood.isCoupon == '1' }">checked="checked"</c:if>>
						是否允许使用优惠券</label>
					</div>
				</div>
			</div>
			<div class="span" style="width: 20%">
				<div class="control-group">
					<div class="controls">
						<label><input name="isSeviceRate" id="isSeviceRate" type="checkbox"  <c:if test="${ctFood.isSeviceRate == '1' }">checked="checked"</c:if>>
						能否收取服务费</label>
					</div>
				</div>
			</div>
		</div>
		<div id="setMeal">
		<hr>
		<div class="control-group">
			<div class="controls">
			    添加菜品:
			</div>
		</div>
		<table id="contentTable"
		class="table table-striped table-bordered table-condensed"
		style="width: 81%; float: left";>
		<thead>
			<tr>
				<th width="10%">序号</th>
				<th width="15%">菜品编号</th>
				<th width="20%">菜品名称</th>
				<th width="12%">单位</th>
				<th width="13%">单价</th>
				<th width="20%">数量</th>
				<th width="15%">操作  &nbsp;&nbsp;<a style="cursor: pointer; outline: none;" id="addfood">+</a></th>
			</tr>
		</thead>
		<tbody align="center" id ="setMealList" name="setMealList">
		</tbody>
	</table>
	<input id="totalInput" type="text" value="小计：共计  0  份菜品，单品合计 0.00元；" style="color:red; background-color:transparent;border:0; width: 100%"/>
	<input id="totalInput1" type="text" value="0.00" style="display: none;"/>
	</div>
		<div id="method" style=" min-height:250px;　height:auto;　">
			<hr>
			<div class="control-group">
				<div class="controls">做法设置:</div>
			</div>
			<table id="contentTable"
				class="table table-striped table-bordered table-condensed"
				style="width: 81%; float: left";>
				<thead>
					<tr>
						<th width="20%">做法类别</th>
						<th width="75%">做法（勾选默认）</th>
					</tr>
				</thead>
				<tbody align="center" id="methodList" name="methodList" >
				</tbody>
			</table>
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
				value="继续新增" onclick="save(1)">&nbsp;
			<input id="submitBtn" class="btn btn-primary" type="button"
				value="保  存" onclick="save(0)">&nbsp;
		</div>
	</form:form>
</body>
</html>