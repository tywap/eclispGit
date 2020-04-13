<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>夜审</title>
	<meta name="decorator" content="default"/>
</head>
<body>
<script type="text/javascript">
function saveSetting()
{
	var settingInfo={};
	$(".setting").each(function(){
		if($(this).attr("checked")=="checked")
			{
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
     	 "type":"nightSetting"
        },
        success: function (result) {
     	   if(result)
     		   {
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
		<div class="control-group">
			<ul class="nav nav-tabs">
				<li><a href="${ctx}/diagram/setting" >房态参数</a></li>
				<li><a href="${ctx}/diagram/setting/guestAccounts">宾客账务</a></li>
				<li class="active"><a href="${ctx}/diagram/setting/nightSetting" >系统参数</a></li>
			</ul>
		</div>
		<div class="control-group">
			<ul class="ul-form">
				<li>			
					夜审时间：<input id="nightTime" name="nightTime" type="text" value="${settingMap.nightTime}" readonly="readonly" maxlength="20" class="input-medium6 Wdate "
						onclick="WdatePicker({dateFmt:'HH:mm',isShowClear:true});"/>
					<input type="radio" disabled="disabled" checked="checked" />自动夜审
					<input type="checkbox" value="1" class="setting" id="authorization" <c:if test="${settingMap.authorization=='1'}">checked="checked"</c:if> >
					<label for="authorization">权限不足时启用授权功能</label>
				</li>
			</ul>
		</div>
	<div class="fixed-btn-right">
		<input id="btnSubmit" class="btn btn-primary" type="button" onclick="saveSetting()" value="保 存"/>&nbsp;
	</div>
</body>
</html>



