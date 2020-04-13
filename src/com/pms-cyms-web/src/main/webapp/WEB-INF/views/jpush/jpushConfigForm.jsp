<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>JPush推送测试</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {				
			
			$("#submitBtn").click(function(){
				submitBtn();
			});
			
			function submitBtn(){
				if(isNullInput($("#alias").val())){
					$.jBox.alert("必须填写【设备别名】!");
					$("#alias").focus();
					return false;
				}else if(isNullInput($("#title").val())){
					$.jBox.alert("必须填写【推送标题】!");
					$("#title").focus();
					return false;
				}else if(isNullInput($("#content").val())){
					$.jBox.alert("必须填写【推送内容】!");
					$("#content").focus();
					return false;
				}
				
				//$("#inputForm").submit();
				
				$.ajax({
					type: "post",
					dataType: "json",  
				    url: "${ctx}/test/jpush",
				    async:false,
				    data:$("#inputForm").serialize(),				    
				    success: function (result) {
				    	if(result.retCode==("000000")){
				       		$.alert("推送成功!");
				    	}else{
				    	}
				    }
				});
			}
		});
		function isNullInput(input){
			return input==null||input=='';
		}		
	</script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="jpushConfig" action="${ctx}/test/jpush" method="post" class="form-horizontal">
		<div class="row">
			<div class="span" style="margin-left:2rem;">	
				<div class="control-group" style="color:blue;font-size:1rem;">
					语音推送消息测试：${adminPath}/test/form 接口：JpushMessageService.sendPushAll
				</div>
			</div>			
		</div>
		<div class="row" style="margin-left: -.3rem;">
			<div class="span">	
				<div class="control-group">
					<div class="controls">
						<label class="control-label-xs">语音类型：</label>
						<div class="controls">
							<select id="soundType" name="soundType" class="input-xlarge ">
								<option value="service.mp3" selected="selected">客房服务</option>
								<option value="clean.mp3">请即打扫</option>
								<option value="electric.mp3">取电服务</option>
								<option value="shop.mp3">送餐服务</option>
								<option value="checkout.mp3">查退服务</option>
								<option value="fix.mp3">维修服务</option>
							</select>									
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs">设备别名：</label>
					<div class="controls">
						<form:input path="alias" htmlEscape="false" maxlength="32" class="input-xxlarge " />
					</div>
				</div>
			</div>			
		</div>	
		<div class="row">
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs">推送标题：</label>
					<div class="controls">
						<form:input path="title" htmlEscape="false" maxlength="32" class="input-xxlarge " />
					</div>
				</div>
			</div>				
		</div>		
		<div class="row">
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs">推送内容：</label>
					<div class="controls">
						<form:textarea path="content" htmlEscape="false"  maxlength="32" style="width:20rem;height:5rem;" class="input-xxlarge " />
					</div>
				</div>
			</div>				
		</div>					
		<div class="fixed-btn-right">
			<shiro:hasPermission name="wechat:wxPayConfig:edit">
			<input id="submitBtn" class="btn btn-primary" type="button" value="保 存"/>&nbsp;
			</shiro:hasPermission>
			<!-- <input id="closeBtn" class="btn" type="button" value="关 闭"/> -->
		</div>
	</form:form>
</body>
</html>