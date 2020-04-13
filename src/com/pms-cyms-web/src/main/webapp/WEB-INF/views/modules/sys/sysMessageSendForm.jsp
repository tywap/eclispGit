<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>发送短信</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//新增接收人
			$("#addPhoneBtn").click(function(){
				addPhoneBtn();
			});
			//发送信息
			$("#sendMessageBtn").click(function(){
				sendMessageBtn();
			});
			
			loadCardTypeCheckbox();
			loadGroupCheckbox();
		});
		
		//新增接收人
		function addPhoneBtn(){
			var html = "<div style='padding:10px;'>手机号码：<input type='text' id='phone' name='phone' /></div>"; 
			var submit = function (v, h, f) { 
			    if (f.yourname == '') { 
			        $.jBox.tip("请输入您的姓名。", 'error', { focusId: "phone" }); // 关闭设置 为焦点 
			        return false; 
			    } 
			 	
			    var phone = f.phone;
			    $("#phones").append(phone+",");
			    return true; 
			}; 
			$.jBox(html, { title: "请输入手机号码", submit: submit });
		}
		
		//保存
		function sendMessageBtn(){
			//表单校验
			if (!$("#inputForm").valid()){
		        return;
		    }
			var phones = $("#phones").val();
			var content = $("#content").val();
			var phoneCount = 0;//选中电话号码个数
			if(content==""){
				$.jBox.alert("短信内容不能为空！");	
				return;
			}
			
			//手填号码
			if(phones!=""){
				var phonesArray = phones.split(",");
				phoneCount = phonesArray.length; 
			}
			
			//会员类型
			var cardTypeIds = "";
			var cks1 = $("[name='cardTypeId']:checked");
			for(var i=0;i<cks1.length;i++){
				cardTypeIds += cks1[i].value+",";
				var tempCount = parseInt($(cks1[i]).attr('count'));
				phoneCount += tempCount;
			}
			cardTypeIds = cardTypeIds.substr(0, cardTypeIds.length-1);
			
			//协议单位
			var agreementGroups = "";
			var cks2 = $("[name='agreementGroup']:checked");
			for(var i=0;i<cks2.length;i++){
				agreementGroups += cks2[i].value+",";
				var tempCount = parseInt($(cks2[i]).attr('count'));
				phoneCount += tempCount;
			}
			agreementGroups = agreementGroups.substr(0, agreementGroups.length-1);
			
			if(phoneCount==0){
				$.jBox.alert("接收电话不能为空！");
				return;
			}		
			
			$.jBox.confirm("选择号码"+phoneCount+"个，立即发送？", "提示", function (v, h, f) {
			    if (v == true){
			    	var params = {phones:phones,content:content,cardTypeIds:cardTypeIds,agreementGroups:agreementGroups};
					loadAjax("${ctx}/sys/sysMessageTemplate/send",params,function(result){
						if(result.retCode=="000000"){
							var ret = result.ret;
							var totalCount = ret.totalCount;
							var wrongList = ret.wrongList;
							if(wrongList.length>0){
								var wrongListStr="";
								for(var i=0;i<wrongList.length;i++){
									wrongListStr += wrongList[i]+",";
								}
								$.jBox.alert("共计选择"+phoneCount+"个号码，发送"+(parseInt(totalCount)-(wrongList.length))+"个成功，异常号码："+wrongListStr);	
							}else{
								$.jBox.alert("共计选择"+phoneCount+"个号码，发送"+(parseInt(totalCount)-(wrongList.length))+"个成功");	
							}
			    	    }else{
			    			$.jBox.alert(result.retMsg);
			    	    }
					});
			    }
			    return true;
			}, { buttons: { '确定': true}});
		}
		
		//加载会员
		function loadCardTypeCheckbox(){
			var id = "#cardTypeDiv";
			var url = "${ctx}/member/cardType/select";
			var params = {};
			loadAjax(url,params,function(result){
				if(result.retCode=="000000"){
					var lists = result.ret.lists;
					  
				    $(id).empty();
				    var htm="";
				    if(typeof(lists)!="undefined"&&lists.length>0){
						for(var i=0;i<lists.length;i++){
							htm += "<div class='span'><label for='c_"+i+"'>"+lists[i]['name']+"("+lists[i]['memberCount']+")</label>"+
								"<input id='c_"+i+"' type='checkbox' name='cardTypeId' value='"+lists[i]['id']+"' count='"+lists[i]['memberCount']+"' /></div>";
				   	    }
				    }
				    $(id).append(htm);
	    	    }else{
	    			$.jBox.alert(result.retMsg);
	    	    }
			});
		}
		//加载协议单位
		function loadGroupCheckbox(){
			var id = "#agreementGroupDiv";
			var url = "${ctx}/member/cmGroup/select";
			var params = {};
			loadAjax(url,params,function(result){
				if(result.retCode=="000000"){
					var lists = result.ret.lists;
					  
				    $(id).empty();
				    var htm="";
				    if(typeof(lists)!="undefined"&&lists.length>0){
						for(var i=0;i<lists.length;i++){
					        htm += "<div class='span'><label for='d_"+i+"'>"+lists[i]['name']+"("+lists[i]['agreementGroupCount']+")</label><input id='d_"+i+"' type='checkbox' name='agreementGroup"+
					        	"' value='"+lists[i]['id']+"' count='"+lists[i]['agreementGroupCount']+"'/></div>";
				   	    }
				    }
				    $(id).append(htm);
	    	    }else{
	    			$.jBox.alert(result.retMsg);
	    	    }
			});
		}
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }
	</script>
	<style type="text/css">
		.span{width:100%;}
		.controls #phones{width:90%;min-height:24px;line-height:24px;border-radius:4px;height:auto;}
		.controls #content{width:90%;line-height:20px;border-radius:4px;height:350px;}
	</style>
</head>
<body>
	<form:form id="inputForm" modelAttribute="sysMessageTemplate" action="${ctx}/sys/sysMessageTemplate/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="row" style="width:70%;float:left;margin-top:10px;">
			<div class="span">
		        <div class="control-group">
		            <label class="control-label-xs">接收人：</label>
		            <div class="controls" >
		            	<input type="text" id="phones" />
		            </div>
		        </div>
		    </div>
		    <div class="span">
		        <div class="control-group">
		            <label class="control-label-xs">发送内容：</label>
		            <div class="controls">
		            	<textarea id="content"></textarea>
		            </div>
		        </div>
		    </div>
		    <div class="span">
		        <div class="control-group">
		            <label class="control-label-xs"></label>
		            <div class="controls">
		            	<span style="color:red;float:left;">多个手机号，请用逗号分隔。短信内容字数请控制在64个字内。</span>
		            	<input id="sendMessageBtn" class="btn btn-primary" type="button" style="float:right;margin-right:10%;" value="发送"/>
		            </div>
		        </div>
		    </div>
	    </div>
	    <div class="panel panel-default" style="width:20%;float:left;margin-top:10px;">
			<div class="panel-heading">
				<h3 class="panel-title">联系人</h3>
			</div>
			<div class="panel-body" style="max-height:450px">
			    <div class="row">
					会员<div id="cardTypeDiv"></div><br/>
					协议单位<div id="agreementGroupDiv" ></div>
			    </div>	
			</div>
		</div>	
		<%-- <table border="1px;" sytle="width:100%;">
			<tr>
				<td rowspan="6">
					<div style="height:650px">
						<p>会员</p>
						<div id="cardTypeDiv" style="width:150px;"></div><br/>
						<p>协议单位</p>
						<div id="agreementGroupDiv" style="width:150px;"></div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					接收人<font style="color:red">(多个手机号,请用逗号分隔)</font>
					<!-- <input id="addPhoneBtn" class="btn btn-primary" type="button" style="float:right;" value="＋"/> -->
				</td>
			</tr>
			<tr>
				<td>
					<div style="width:700px;height:280px">
						<textarea id="phones" rows="10" style="width:98%;height:98%;"></textarea>					
					</div>
				</td>
			</tr>
			<tr>
				<td>发送内容<font style="color:red">(短信内容字数请控制在64个字内)</font></td>
			</tr>
			<tr>
				<td>
					<div style="width:700px;height:280px">
						<textarea id="content" rows="10" style="width:98%;height:98%;" maxlength="64" class="required"></textarea>					
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<shiro:hasPermission name="sys:sysMessageTemplate:edit">
						<input id="sendMessageBtn" class="btn btn-primary" type="button" style="float:right;" value="发送"/>
					</shiro:hasPermission>
				</td>
			</tr>
		</table> --%>
	</form:form>
</body>
</html>