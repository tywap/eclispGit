<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>选择班次</title>
	<meta name="decorator" content="default"/>

</head>
<body>
<script>
 var logoutUrl = '${logoutUrl }';
$.get(logoutUrl, function(){
	sessionid = '';
	J.showToast('退出成功！', 'success');
	J.Router.goTo('#login_section');
}); 

//定时器 异步运行 
function closeWindow(){ 
	 window.parent.jBox.close();
} 

function saveShift()
{
	var shiftId,url,username,password,storeId;
    $.each($('input:radio:checked'),function(){
		shiftId = $(this).val();
		url=$('#url_').val();
		username=$('#username_').val();
		password=$('#password_').val();
		storeId=$('#storeId_').val();
	});
    $.ajax({
        url:"${ctx}/sys/office/getPubShiftData",
        type: "post",
        dataType: "json",
        data: {
            "shiftId":shiftId
        },
        success: function (result) {
        	if(result != null){
        		var status = result.status;
        		if(status == '0'){
        			$.jBox.alert("该班次已交班，请重新选择班次！");
        			return;
        		}
        	}
        	
   		}
	});
    if(shiftId == null || shiftId == ''){
    	 $.jBox.alert("请选择班次！");
    	 return;
    }else{
    	submitForm(storeId,shiftId,username,password,url);
    }
}
function submitForm(storeId,shiftId,username,password,url){
	var formStr = '';
	//设置样式为隐藏，打开新标签再跳转页面前，如果有可现实的表单选项，用户会看到表单内容数据
    	formStr = '<form style="visibility:hidden;"  id="QRcodeForm" method="get" target="QRcodeWin" action="' + url + '">' +
	        '<input type="hidden" id="shiftId" name="shiftId" value="' + shiftId + '" />' +
	        '<input type="hidden" id="username" name="username" value="' + username + '" />' +
	        '<input type="hidden" id="password" name="password" value="' + password + '" />' +
	        '<input type="hidden" id="storeId" name="storeId" value="' + storeId + '" />' +
	        '<input type="hidden" id="storeInLogin" name="storeInLogin" value="' + true + '" />' +
	        '</form>';
	        $("body").append(formStr);//在body中添加form表单  
	      	//打开新的窗口  
	        //window.open(url,"QRcodeWin","_blank");  
	        //提交表单  
	        $("#QRcodeForm").submit();  
	      	//使用方法名字执行方法 
	        var t1 = window.setTimeout(closeWindow,3000);

}
</script>
<style>
	label{
		position:absolute;
		width:96%;
		height:37px;
		margin-top:-8px;
		margin-left:-8px;
	}
	.table tr td input:focus{
		border:none;
	}
</style>
<div class="form-horizontal">
	<table id="contentTable" class="table table-bordered">
		<thead><tr><th>选择</th><th>班次：</th></tr></thead>
		<tfoot>
			<c:forEach items="${shiftList}" var="shift">
				<tr>
					<td>
						<label for="${shift.id}"></label>
						<input type="radio" name="radio" id="${shift.id}" value="${shift.id}" shiftname="${shift.shiftName}" style="outline:none;" />
					</td>
					<td>${shift.shiftName}</td>
				</tr>
			</c:forEach>
		</tfoot>
	</table>
</div>
		
	<div class="fixed-btn-right">
	<input id="storeId_" class="btn btn-primary" type="hidden" value="${storeId }" />
	<input id="username_" class="btn btn-primary" type="hidden" value="${username }"/>
	<input id="password_" class="btn btn-primary" type="hidden" value="${password }"/>
	<input id="url_" class="btn btn-primary" type="hidden" value="${url }"/>
	<input id="logoutUrl" class="btn btn-primary" type="hidden" value="${logoutUrl }"/>
	<input id="btnSubmit" class="btn btn-primary" type="button" onclick="saveShift()" value="确 定"/>&nbsp;
	</div>
</body>
</html>