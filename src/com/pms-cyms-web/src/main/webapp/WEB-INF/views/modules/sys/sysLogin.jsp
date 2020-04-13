<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.apache.shiro.web.filter.authc.FormAuthenticationFilter"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>餐饮管理系统登录</title>
	<meta name="decorator" content="blank"/>
	<style type="text/css">
        html, body, table {
            background-color: #2E363F;
            width: 100%;
            text-align: center;
        }

        .form-signin-heading {
            font-family: Helvetica, Georgia, Arial, sans-serif, 黑体;
            font-size: 36px;
            margin-top: 20px;
            margin-bottom: 20px;
            color: #0663a2;
        }

        .form-signin {
            position: relative;
            width: 32%;
            margin: 0 auto 20px;
        }

        .form-signin .checkbox {
            margin-bottom: 10px;
            color: #0663a2;
        }

        .form-signin .input-label {
            font-size: 13px;
            text-align: center;
            display: inline-block;
            color: #fff;
            width: 30px;
            padding: 9px 9px;
        }

        .form-signin .input-block-level {
            font-size: 16px;
            height: auto;
            width: 75%;
            text-align: left;
            border: 0px;
            border-radius: 0px;
            margin-top: 13px;
            margin-left: -4px;
            margin-bottom: 16px;
            display:inline-block;
            padding: 9px;
            *width: 283px;
            *padding-bottom: 0;
            _padding: 7px 7px 9px 7px;
        }

        .form-signin .btn.btn-large {
            font-size: 16px;
            border: none;
            border-radius: 0px;
            background: #5BB75B;
            padding: 6px 25px;
            margin-right: 15px;
        }

        .form-signin #themeSwitch {
            position: absolute;
            right: 15px;
            bottom: 10px;
        }

        .form-signin .bg-lg {
            background-color: #31b080;
        }

        .form-signin .bg-ly {
            background-color: #e73962;
        }

        .form-signin .bg-lb {
            background-color: #FFB848;
        }

        .form-signin div.validateCode {
         /*   padding-bottom: 15px; */
        }

        .form-signin .mid {
        	
            display: inline-block;
            color: #fff;
            width: 60px;
            vertical-align: middle;
        }

        .header {
            height: 120px;
            padding-top: 20px;
            border-bottom: 1px solid #3f4954;
            width: 32%;
            margin: 0 auto;
        }

        .alert {
            position: relative;
            width: 300px;
            height:20px;
            margin: 0 auto;
            *padding-bottom: 0px;
        }

        label.error {
            background: none;
            width: 270px;
            font-weight: normal;
            color: inherit;
            margin: 0;
        }

        .footer {
            color: #fff;
        }

        .select2-container .select2-choice {
            border: none;
            border-radius: 0;
            color: #333;
            height: 38px;
            line-height: 38px;
            margin-left: -9px;
            margin-right: -9px;
            background: #FAFFBD;
        }

        .select2-container .select2-choice .select2-arrow {
            border: none;
            background: none;
        }

        .select2-container .select2-choice .select2-arrow b {
            background-position: -5px 6px;
        }

        .select2-drop {
            border: none;
            border-radius: 0;
            margin-top: -9px;
            padding-top: 5px;
        }

        .select2-search {
            display: none;
        }
    </style>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#loginForm").validate({
				rules: {
					validateCode: {remote: "${pageContext.request.contextPath}/servlet/validateCodeServlet"}
				},
				messages: {
					username: {required: "请填写用户名."},password: {required: "请填写密码."},
					validateCode: {remote: "验证码不正确.", required: "请填写验证码."}
				},
				errorLabelContainer: "#messageBox",
				errorPlacement: function(error, element) {
					error.appendTo($("#loginError").parent());
				} 
			});
			if ("${message}") {
            	$("#messageBox").show();
            } else {
            	$("#messageBox").hide();
            }
            var un = $("#username").val().trim();
            if (!isNullVal(un)) {
            	loadbc(un);
            }
            $("#username").blur(function () {
            	var un = $("#username").val().trim();
            	if (isNullVal(un)) return;
            	loadbc(un);
            });
		});
		// 如果在框架或在对话框中，则弹出提示并跳转到首页
		if(self.frameElement && self.frameElement.tagName == "IFRAME" || $('#left').length > 0 || $('.jbox').length > 0){
			alert('未登录或登录超时。请重新登录，谢谢！');
			top.location = "${ctx}";
		}
		
		function loadbc(username) {
            $.ajax({
                url: "${ctx}/bc/pubShift/query",
                type: "post",
                dataType: "json",
                data: {
                    "loginName": username
                },
                success: function (result) {
                    if (result.retCode == "000000") {
                    	$("#shiftId").empty();
                        if (typeof(result.list) == "undefined") {
                            $("#shiftDiv").hide();
                        }else{
                        	if(result.list.length>0){
                        		$("#shiftDiv").show();
                        		$("#shiftId").append($("<option value='" + result.list[0].id + "' selected='selected'>" + result.list[0].shiftName + "</option>"));
                            	$("#shiftId").append($("<option value='" + result.list[1].id + "'>" + result.list[1].shiftName + "</option>"));
                                /* for (var i = 1; i < result.list.length; i++) {
                                	$("#shiftId").append($("<option value='" + result.list[i].id + "' >" + result.list[i].shiftName + "</option>"));
                                } */
                                $("#shiftId").select2('val', result.list[0].id);
                        	}
                        }
                    }else{
                    	 $("#shiftId").empty();
                         $("#shiftId").append("<option selected='true' disabled='true'>班次选择</option>");
                         $("#loginError").html(result.retMsg);
                         $("#messageBox").empty();
                         $("#messageBox").append('<label id="loginError" class="error">' + result.retMsg + '</label>');
                         if(result.retMsg != '' && result.retMsg != null){
                         	$("#username").val('');
                         }
                         $("#messageBox").show();
                         return;
                    }
                },
                error : function() {
                	$("#username").val('');
					alert( "班次配置错误，请重新登录！");
				},
            });
        }
	</script>
</head>
<body>
	<!--[if lte IE 6]><br/><div class='alert alert-block' style="text-align:left;padding-bottom:10px;"><a class="close" data-dismiss="alert">x</a><h4>温馨提示：</h4><p>你使用的浏览器版本过低。为了获得更好的浏览体验，我们强烈建议您 <a href="http://browsehappy.com" target="_blank">升级</a> 到最新版本的IE浏览器，或者使用较新版本的 Chrome、Firefox、Safari 等。</p></div><![endif]-->
	<div class="header">
		<div id="messageBox" class="alert alert-error ${empty message ? 'hide' : ''}" style="position: relative;">
			<button data-dismiss="alert" class="close">×</button>
			<label id="loginError" class="error">${message}</label>
		</div>
	</div>
	<h1 class="form-signin-heading"><img alt="" src="${pageContext.request.contextPath}/static/images/logo.png"></h1>
	<form id="loginForm" class="form-signin" action="${ctx}/login" method="post">
		<div>
			<label class="input-label bg-lg" for="username"><i class="icon-user"></i></label>
			<input type="text" id="username" name="username" placeholder="请输入用户名" class="input-block-level required" value="${username}">
		</div>
		<div>
			<label class="input-label bg-ly" for="password"><i class="icon-lock"></i></label>
			<input type="password" id="password" name="password" placeholder="请输入密码"  class="input-block-level required">
		</div>
		<div id="shiftDiv">
	        <label class="input-label bg-lb" for="shiftId"><i class="icon-time"></i></label>
	        <select id="shiftId" name="shiftId" class="input-block-level" style="padding-top:8px; padding-bottom:7px;">
	        	<option value="" selected="true" disabled="true">班次选择</option>
	        </select>
	    </div>
		<c:if test="${isValidateCodeLogin}"><div class="validateCode">
			<label class="mid" for="validateCode">验证码：</label>
			<sys:validateCode name="validateCode" inputCssStyle="margin-bottom:0;"/>
		</div></c:if><%--
		<label for="mobile" title="手机登录"><input type="checkbox" id="mobileLogin" name="mobileLogin" ${mobileLogin ? 'checked' : ''}/></label> --%>
		<div style="border-top: 1px solid #3f4954;margin-top: 20px;padding-top: 15px;text-align:right;">
			<input class="btn btn-large btn-primary" type="submit" value="登 录"/>
		</div>
		<!--<label for="rememberMe" title="下次不需要再登录"><input type="checkbox" id="rememberMe" name="rememberMe" ${rememberMe ? 'checked' : ''}/> 记住我（公共场所慎用）</label>-->
		<!--<div id="themeSwitch" class="dropdown">
			<a class="dropdown-toggle" data-toggle="dropdown" href="#">${fns:getDictLabel(cookie.theme.value,'theme','默认主题')}<b class="caret"></b></a>
			<ul class="dropdown-menu">
			  <c:forEach items="${fns:getDictList('theme')}" var="dict"><li><a href="#" onclick="location='${pageContext.request.contextPath}/theme/${dict.value}?url='+location.href">${dict.label}</a></li></c:forEach>
			</ul>
			[if lte IE 6]><script type="text/javascript">$('#themeSwitch').hide();</script><![endif]
		</div>-->
	</form>
	<!--<div class="footer">
		Copyright &copy; 2012-${fns:getConfig('copyrightYear')} <a href="${pageContext.request.contextPath}${fns:getFrontPath()}">${fns:getConfig('productName')}</a> - Powered By <a href="http://jeesite.com" target="_blank">JeeSite</a> ${fns:getConfig('version')} 
	</div>-->
	<script src="${ctxStatic}/flash/zoom.min.js" type="text/javascript"></script>
</body>
</html>