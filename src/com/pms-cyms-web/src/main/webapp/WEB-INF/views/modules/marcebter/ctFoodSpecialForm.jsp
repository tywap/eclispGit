<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<title>新增菜品</title>
<meta name="decorator" content="default" />
<script type="text/javascript">
	var weeks = '${cfFoodSpecial.andValue}';
	var buyCount='${cfFoodSpecial.isMaxBuyCount}';
	var isCount='${cfFoodSpecial.isMaxSellCount}';
	 $(document).ready(function() {
		//解绑事件
		top.$.unsubscribe("checkIn");
    	    //注册事件，弹出页面需要刷新本页面，或者弹出页面回传数据用
    	    top.$.subscribe("checkIn", function (e, data) {
    	    	var params={id:data.str}
    	    	loadAjax("${ctx}/marcebter/ctfoodSpecial/ctFoodspecial", params, function(result){
					if(result.retCode=="000000"){
						var data=result.list;
						formselect(data);
					}
				});
    	    });
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
    	    
    	    $("#passFood").click(function(){
    	    	pass();
    	    });
    	    $("#passsales").click(function(){
    	    	salesy();
    	    });
    	    if(buyCount==1){
    	    	pass();
    	    }
    	    if(isCount==1){
    	    	salesy();
    	    }
		}); 
	//菜品选择
	function cusine(){
		top.$.jBox.open("iframe:${ctx}/marcebter/ctfoodSpecial/select?foodStoreId=${storeId}", "菜品选择", 1000, $(top.document).height() - 180, {
			buttons : {},
			loaded : function(h) {
				$(".jbox-content", top.document).css("overflow-y", "hidden");
			}
		});
	}
	
	function formselect(data){
		var list =[];
        $(".dishes").each(function(){
        	list.push($(this).val());
        })
        var fig=0;
        	for (var i= 1;  i<= data.length; i++) {
        		var bool=true;
        		for (var j= 0;  j<= list.length; j++) {
        				if(data[i-1].id==list[j]){
        					bool=false;
        				}
        		}
        		if(bool==true){
        			var len=$("#setMealList tr").length+parseInt(1);
        			var split='<tr id="lab">'+
        			'<input type="hidden" class="dishes" value='+data[i-1].id+'>'+
        			'<td class="serial">'+len+'</td>'+
        			'<td>'+data[i-1].code+'</td>'+
        			'<td>'+data[i-1].name+'</td>'+
        			'<td>'+data[i-1].foodUnitName+'</td>'+
        			'<td>'+data[i-1].price.amount+'</td>'+
        			'<td name="price"><input type="text" name="price" class="price" value="0.00" style="width: 80px;text-align:center;color:red" /></td>'+
        			'<td><a onclick="remove(this)">移除</a></td>'+
        		'</tr>';
        		$("#setMealList").append(split);
        		}
    		}
	}
	
	function remove(obj) {
		var tr = this.getRowObj(obj);
		if (tr != null) {
			tr.parentNode.removeChild(tr);
			sortTrNumber(obj);
		} else {
			layer.alert("移除失败！");
		}
	}
	//序号处理
	function sortTrNumber(obj){
		 var len=$("#setMealList tr").length;
		 for(var i = 0;i<len;i++){
	     /*  $('#setMealList tr').eq(i).find('.serial').html(i+1); */
		  $('#setMealList tr:eq('+i+') td:first').text(i+1);
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
	//保存
	function submitBtnn(){
		var mktInfo={};
	 	var array=[];
		var effectiveDate=$("#effectiveDate").val();
		var expireDate=$("#expireDate").val();
		var id=$("#id").val();
		mktInfo["andType"]="weeks";
		if(expireDate<effectiveDate){
			layer.alert("结束日期不能小于开始日期");
     		return;
		}
		if(effectiveDate.length<=0){
			layer.alert("请选择特价开始日期");
     		return;
		}
		if(expireDate.length<=0){
			layer.alert("请选择特价结束日期");
     		return;
		}
		if(getCollapsaGValue("weeks") == '' || getCollapsaGValue("weeks") == null){
			layer.alert("适用时间段必须选一个或多个！");
			return ;
		}
		mktInfo["id"]=id;
		mktInfo["storeId"]='${storeId}';
		mktInfo["andValue"]=getCollapsaGValue("weeks");
		mktInfo["effectiveDate"]=effectiveDate
		mktInfo["expireDate"]=expireDate
		//是否允许单独点单
		var passalone=$("#passalone").is(':checked');
		if(passalone){
			mktInfo["isSinglePoint"]="1";
		}else{
			mktInfo["isSinglePoint"]="0";
		}
		//是否允许使用优惠卷
		var isCoupon=$("#passcoupon").is(":checked");
		if(isCoupon){
			mktInfo["isCoupon"]="1";
		}else{
			mktInfo["isCoupon"]="0";
		}
		//是否允许折扣
		var isDiscount=$("#discount").is(":checked");
		if(isDiscount){
			mktInfo["isDiscount"]="1";
		}else{
			mktInfo["isDiscount"]="0";
		}
		//单桌购买数量
		var passFood=$("#passFood").is(':checked');
		var pression=/^[1-9]\d*$/;
		if(passFood){
			mktInfo["isMaxBuyCount"]="1";
			var buyvalue=$("#quantity").val();
			if(!pression.test(buyvalue)){
				layer.alert("单桌购买数量输入有误，请输入数字");
				return;
			}
			mktInfo["maxBuyCount"]=buyvalue;
		}else{
			mktInfo["isMaxBuyCount"]="0";
			mktInfo["maxBuyCount"]=null;
		}
		//销售库存
		var passsales=$("#passsales").is(':checked');
		if(passsales){
			mktInfo["isMaxSellCount"]="1";
			var salesoftory=$("#salesoftory").val();
			if(!pression.test(salesoftory)){
				layer.alert("销售库存输入有误，请输入数字");
				return;
			}
			mktInfo["maxSellCount"]=salesoftory
		}else{
			mktInfo["isMaxSellCount"]="0";
			mktInfo["maxSellCount"]=null;
		}
		//选择菜品ID与特价
		/* var zz=/^[1-9]+\d*(\.\d{0,2})?$|^0?\.\d{0,2}$/; */
		var reg = /^\d+(\.\d{0,2})?$|^\.\d{1,2}$/;
		var boole=true;
		$(".dishes").each(function(){
			var mktInf={};
			var foodId=$(this).val();//.find("input[class='dishes']")
			mktInf["foodId"]=foodId;
			var price=$(this).parent().find("input[name='price']").val();
			if(!reg.test(price)){
				boole=false;
			}
			mktInf["price"]=price;
			/* mktInf["mktInfo"]=mktInfo; */
			array.push(mktInf);
		});
		if(boole==false){
			layer.alert("特价输入有误，请重新输入");
			return;
		}
		$.ajax({
			type:"post",
			datatype:"json",
			url: "${ctx}/marcebter/ctfoodSpecial/save",
			data:{
				array:JSON.stringify(array),
				mktInfo:JSON.stringify(mktInfo)
			},
			success:function(result){
				 if(result.retCode=="000000"){
					top.$.publish("dishesSettingForm", {
						testData :""
					});
					window.parent.jBox.close();
				 }else{
					 layer.alert(result.retMsg);
				 }
			}
		});
	}
	
	//显示设置数量
	function pass(){
		var aa=$("#passFood").is(':checked');
		if(aa){
			$('#quantity').removeAttr('disabled');
		}else{
			$('#quantity').attr('disabled',true);
		}
	}
	function salesy(){
		var aa=$("#passsales").is(':checked');
		if(aa){
			$('#salesoftory').removeAttr('disabled');
		}else{
			$('#salesoftory').attr('disabled',true);
		}
	}
	function getCollapsaGValue(type)
	{
		var reV="";
		  $("."+type).each(function(){
			  if($(this).is(':checked'))
			  	reV+=$(this).val()+",";
		});
		if(reV!="")
			return reV.substring(0,reV.length-1);
		else
			return "";
	}
</script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="sysBusiConfig" action="" method="post" class="form-horizontal">
		<input name="id" id="id" value="${cfFoodSpecial.id }" type="text" htmlescape="false" maxlength="64" style="display: none;">
		<div class="row" style="margin-top: 20px;">
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><span class="help-inline"><font
							color="red">*</font> </span>特价日期：</label>
					<div class="controls">
						<input id="effectiveDate" style="margin-right:3px;" name="effectiveDate" type="text" readonly="readonly" maxlength="20" class="Wdate input-medium6"
                        value="${cfFoodSpecial.effectiveDate }" pattern="yyyy-MM-dd HH:mm"
                        onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm',isShowClear:false,});" />-
		                <input id="expireDate" name="expireDate" type="text" readonly="readonly" maxlength="20" class="input-medium6 Wdate "
		                value="${cfFoodSpecial.expireDate }" pattern="yyyy-MM-dd HH:mm"
		                onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm',isShowClear:false,});" />
					</div>
				</div>
			</div>
		</div>
		<div class="row" style="margin-top: 20px;">
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs"><font color="red">*</font>特价日期：</label>
					<div class="controls">
					<div class="widget-content">
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
		<div class="row" style="margin-top: 20px;">
			<div class="span">
				<div class="control-group">
					<div class="controls">
					<label>
					<input name="passalone " id="passalone" <c:if test="${cfFoodSpecial.isSinglePoint==1 }">checked="checked"</c:if> type="checkbox">
				               允许单独点单
					</label>
					<label style="position: absolute;left:400px;">
					<input name="passcoupon" id="passcoupon" <c:if test="${cfFoodSpecial.isCoupon==1 }">checked="checked"</c:if> type="checkbox">
				    	允许使用优惠卷
					</label>
					<label style="position: absolute;left:800px;">
					<input name="discount" id="discount" <c:if test="${cfFoodSpecial.isDiscount==1 }">checked="checked"</c:if> type="checkbox">
				    	允许折扣
					</label>
					</div>
				</div>
				<div class="controls">
					<div class="">
						<label>
						<input name="passFood" id="passFood" <c:if test="${cfFoodSpecial.isMaxBuyCount==1 }">checked="checked"</c:if> type="checkbox">
				    	限制单桌购买数量：
				    	<input disabled type="text" id="quantity" value="${cfFoodSpecial.maxBuyCount }" style="width: 50px" />
						</label>
						<label style="position: absolute;left:400px;margin:-30px 0;">
						<input name="passsales" id="passsales" <c:if test="${cfFoodSpecial.isMaxSellCount==1 }">checked="checked"</c:if> type="checkbox">
				    	显示日销售库存：
				    	<input disabled id="salesoftory" value="${cfFoodSpecial.maxSellCount }" type="text" style="width: 50px" />
						</label>
					</div>
				</div>
			</div>
		</div>
		<hr>
		<div class="control-group">
			<div class="controls">
			    选择特价菜品:
			</div>
		</div>
		<table id="contentTable"
		class="table table-striped table-bordered table-condensed"
		style="width: 81%; float: left";>
		<thead>
			<tr>
				<th width="14.2%">序号</th>
				<th width="14.2%">菜品编号</th>
				<th width="14.2%">菜品名称</th>
				<th width="14.2%">单位</th>
				<th width="14.2%">原价</th>
				<th width="14.2%">特价</th>
				<c:if test="${cfFoodSpecial.id ==null }">
				<th width="14.2%">操作  &nbsp;&nbsp;<a style="cursor: pointer; outline: none;" id="addfood" onclick="cusine()">+</a></th>
				</c:if>
			</tr>
		</thead>
		<tbody align="center" id ="setMealList" name="setMealList">
				<c:if test="${cfFoodSpecial.id !=null }">
					<tr>
        			<input type="hidden" class="dishes" value="${cfFoodSpecial.foodId }">
        			<td>1</td>
        			<td>${cfFoodSpecial.ordernumber }</td>
        			<td>${cfFoodSpecial.nameDishes }</td>
        			<td>${cfFoodSpecial.units }</td>
        			<td>${cfFoodSpecial.oriPrice }</td>
        			<td name="price"><input type="text" name="price" class="price" value="${cfFoodSpecial.price}" style="width: 80px;text-align:center;color:red" /></td>
        			</tr>
				</c:if>
		</tbody>
		</table>
		<div class="fixed-btn-right">
			<input id="submitBtn" class="btn btn-primary" type="button"
				value="保  存" onclick="submitBtnn()">&nbsp;
		</div>
	</form:form>
</body>
</html>