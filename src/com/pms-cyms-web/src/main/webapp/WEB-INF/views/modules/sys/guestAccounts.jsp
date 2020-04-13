<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>宾客账务</title>
	<meta name="decorator" content="default"/>
</head>
<body>
<script type="text/javascript">
function saveSetting()
{
	var settingInfo={};
	$(".setting").each(function(){
		if($(this).attr("checked")=="checked"){
			settingInfo[$(this).attr("id")]=$(this).val();
		}
	});
	$(".selectSettings").each(function(){
		if($("#selectedInput_"+$(this).attr("id")).attr("checked")=="checked"){
			settingInfo[$(this).attr("id")]=$(this).val();
		}
	});
	settingInfo["nightTime"]=$("#nightTime").val();
	
	$.ajax({
        url:"${ctx}/diagram/setting/saveDiagramSettings",
        type: "post",
        dataType: "json",
        data: {
     	 "settingInfo":JSON.stringify(settingInfo),
     	 "type":"guestAccounts"
        },
        success: function (result) {
     	   if(result){
     		  	$.jBox.alert("保存成功！");
     		  	location.reload();
     		}  
     	   else
     		  $.jBox.alert("保存失败！");
     	
   	}
	});
}
</script>
	<style>
		.ul-form{
			list-style:none;
		}
	</style>
	<div id="content" class="row-fluid">		
		<ul class="nav nav-tabs" style="margin:10px 0 !important;">
			<li><a href="${ctx}/diagram/setting" >房态参数</a></li>
			<li class="active"><a href="${ctx}/diagram/setting/guestAccounts">宾客账务</a></li>
			<li><a href="${ctx}/diagram/setting/nightSetting" >系统参数</a></li>
		</ul>
		<div class="control-group">
			<ul class="ul-form">
				<!-- <li><label>入住|续住|换房|结账：</label> -->
				</li>
					<li>			
					<!-- <input type="checkbox" value="1" class="setting" id="detectionIdCard" <c:if test="${settingMap.detectionIdCard=='1'}">checked="checked"</c:if> >
					<label for="detectionIdCard">检测身份证件号码</label>
					<input type="checkbox" value="1" class="setting" id="idCardOneOrd" <c:if test="${settingMap.idCardOneOrd=='1'}">checked="checked"</c:if> >
					<label for="idCardOneOrd">同一证件只能开一间房</label> -->
					<input type="checkbox" value="1" class="setting" id="canNotPx" <c:if test="${settingMap.canNotPx=='1'}">checked="checked"</c:if> >
					<label for="canNotPx">余额不足时允许挂PX</label>
					<!-- <input type="checkbox" id="selectedInput_underRemind" <c:if test="${!empty settingMap.underRemind}">checked="checked"</c:if> >
					<label for="underRemind">余额不足
						<select id="underRemind" class="selectSettings">
							<option value="100" <c:if test="${settingMap.underRemind=='100'}">selected="selected"</c:if> >100</option>
							<option value="200" <c:if test="${settingMap.underRemind=='200'}">selected="selected"</c:if> >200</option>
							<option value="300" <c:if test="${settingMap.underRemind=='300'}">selected="selected"</c:if> >300</option>
							<option value="400" <c:if test="${settingMap.underRemind=='400'}">selected="selected"</c:if> >400</option>
							<option value="500" <c:if test="${settingMap.underRemind=='500'}">selected="selected"</c:if> >500</option>
							<option value="600" <c:if test="${settingMap.underRemind=='600'}">selected="selected"</c:if> >600</option>
							<option value="700" <c:if test="${settingMap.underRemind=='700'}">selected="selected"</c:if> >700</option>
							<option value="800" <c:if test="${settingMap.underRemind=='800'}">selected="selected"</c:if> >800</option>
						</select>
					元时，弹窗提醒</label> -->
				</li>
			</ul>
		</div>
		<!-- <div class="control-group">
			<ul class="ul-form">
				<li><label>预定：</label>
				</li>
				<li>			
					<input type="checkbox" id="selectedInput_reserveRetainTime" <c:if test="${!empty settingMap.reserveRetainTime}">checked="checked"</c:if> >
					<label for="reserveRetainTime">保留时间默认为
						<select id="reserveRetainTime" class="selectSettings">
							<option value="12:00" <c:if test="${settingMap.reserveRetainTime=='12:00'}">selected="selected"</c:if> >12:00</option>
							<option value="13:00" <c:if test="${settingMap.reserveRetainTime=='13:00'}">selected="selected"</c:if> >13:00</option>
							<option value="14:00" <c:if test="${settingMap.reserveRetainTime=='14:00'}">selected="selected"</c:if> >14:00</option>
							<option value="15:00" <c:if test="${settingMap.reserveRetainTime=='15:00'}">selected="selected"</c:if> >15:00</option>
							<option value="16:00" <c:if test="${settingMap.reserveRetainTime=='16:00'}">selected="selected"</c:if> >16:00</option>
							<option value="17:00" <c:if test="${settingMap.reserveRetainTime=='17:00'}">selected="selected"</c:if> >17:00</option>
							<option value="18:00" <c:if test="${settingMap.reserveRetainTime=='18:00'}">selected="selected"</c:if> >18:00</option>
							<option value="19:00" <c:if test="${settingMap.reserveRetainTime=='19:00'}">selected="selected"</c:if> >19:00</option>
							<option value="20:00" <c:if test="${settingMap.reserveRetainTime=='20:00'}">selected="selected"</c:if> >20:00</option>
							<option value="21:00" <c:if test="${settingMap.reserveRetainTime=='21:00'}">selected="selected"</c:if> >21:00</option>
							<option value="23:00" <c:if test="${settingMap.reserveRetainTime=='23:00'}">selected="selected"</c:if> >23:00</option>
						</select>
					点</label>
					<input type="checkbox" value="1" id="selectedInput_preArrivalRemind" <c:if test="${!empty settingMap.preArrivalRemind}">checked="checked"</c:if> >
					<label for="preArrivalRemind">预抵未到订单提前
						<select id="preArrivalRemind" class="selectSettings">
							<option value="20" <c:if test="${settingMap.preArrivalRemind=='20'}">selected="selected"</c:if> >20</option>
							<option value="30" <c:if test="${settingMap.preArrivalRemind=='30'}">selected="selected"</c:if> >30</option>
							<option value="60" <c:if test="${settingMap.preArrivalRemind=='60'}">selected="selected"</c:if> >60</option>
							<option value="90" <c:if test="${settingMap.preArrivalRemind=='90'}">selected="selected"</c:if> >90</option>
							<option value="120" <c:if test="${settingMap.preArrivalRemind=='120'}">selected="selected"</c:if> >120</option>
						</select>
					分钟提醒</label>
				</li>
			</ul>
		</div>
		<div class="control-group">
			<ul class="ul-form">
				<li><label>房价调整：</label>
				</li>
				<li>			
					<input type="checkbox" value="1" class="setting" id="addPrice" <c:if test="${!empty settingMap.addPrice}">checked="checked"</c:if> >允许无限制上调房价
				</li>
			</ul>
		</div> -->
	</div>

	<div class="fixed-btn-right">
		<input id="btnSubmit" class="btn btn-primary" type="button" onclick="saveSetting()" value="保 存"/>&nbsp;
	</div>
</body>
</html>



