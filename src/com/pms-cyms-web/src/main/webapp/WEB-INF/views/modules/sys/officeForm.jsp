<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>集团酒店管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			var hoteltype = $('#hoteltype').val();
			if(hoteltype == '3' || hoteltype == '4'){
				$("#c_latlng").css("display","block");
			}
			$("#name").focus();
			$("#inputForm").validate({
				submitHandler: function(form){
					loading('正在提交，请稍等...');
					form.submit();

				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});
			disableHoteltype('${office.id}');
			
		});
		
		//********************************************************//
		function disableHoteltype(officeid){
			//console.log(officeid);
			if(officeid==""){
				$("#hoteltype").attr("disabled",false);
			}else{
				$("#hoteltype").attr("disabled",true);
			} 
		}
		
		//*******************************************************//
		function changeHoteltype(this_){
			//console.log("酒店类型切换"+this_.value);
			if(this_.value=="3" || this_.value=="4" || this_.value=="5"){//直营酒店或者加盟酒店
				$("#c_latlng").css("display","block");
				//$("#c_phone").css("display","block")
			}else{
				$("#c_latlng").css("display","none");
               // $("#c_phone").css("display","none")
			}
			
		}
		
		//*******************************************************//
		function seeMap(){
			//console.log("弹出地图${ctx}");
			var city = $('#areaName').val();
			var address = $('#address').val();
			city = encodeURI(encodeURI(city));
			address = encodeURI(encodeURI(address));
			jBox.open(
					"iframe:${ctx}/sys/office/sysmap?city="+city+"&address="+address, 
					"获取地图",
					520, 
					420,
					{
						buttons:false,
			            loaded:function(h){
			                $(".jbox-content", top.document).css("overflow-y","hidden");
			            }
		            }
				);
			//jBox.open("iframe:${ctx}/sys/office/sysmap", "获取地图", 520, 420,{buttons:false});
			
		}
		
		//*******************************************************//
		function getlatlog(lat,lng){
			$("#latlng").val(lat+","+lng);
		}
		
		//*********************************************************//
		function over(){
			//alert("关闭");
			window.parent.jBox.close();
		}
		
		function saveForm(){
		    var orgVal = $('#hoteltype').val();
            var telVal = $('#phone').val();
            var office  = $('#officeId').val();
            var name  = $('#name').val();
            var latlng = $('#latlng').val();
            var master = $('#master').val();
			if( telVal == ''|| telVal == null){
				$.jBox.alert("联系电话不允许为空！");
			    return;
			}
			if( master == ''|| master == null){
				$.jBox.alert("联系人不允许为空！");
			    return;
			}
			if(office == ''|| office == null){
				$.jBox.alert("隶属上级不允许为空！");
			    $('#office').val('');
			    return;
			}
			if(name == ''|| name == null){
				$.jBox.alert("机构名称不允许为空！");
			    return;
			}
			if(orgVal == '3' || orgVal == '4'){
				if(latlng == null || latlng == ''){
					$.jBox.alert("定位信息不允许为空！");
				    return;
				}
			}
            var form = new FormData(document.getElementById("inputForm"));
            $.ajax({
                url:"${ctx}/sys/office/save",
                type:"post",
                data:form,
                processData:false,
                contentType:false,
                success:function(result){
                	if(result.retCode=="000000"){
                		layer.confirm("保存成功！", {
		        			  btn: ['确定']
		        			}, function(){
		        				var parentTabPage = top.document.getElementById("${param.tabPageId}");
		    			    	parentTabPage.src=parentTabPage.src; 
		                        window.parent.jBox.close();
		        			});
                		
	                  }else{
	                	  $.jBox.alert(result.retMsg);
	                  }
                },
                error:function(e){
                	$.jBox.alert("保存机构失败！！");
                }
            }); 
		}
	</script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="office"  method="post" class="form-horizontal breadcrumb form-search">
		<form:hidden path="id" id="id"/>
		<sys:message content="${message}"/>
	<div class="row">
		<div class="span" >
			<div class="control-group">
				<label class="control-label-xs">隶属上级：</label>
				<div class="controls">
	                <sys:treeselect id="office" name="parent.id" value="${office.parent.id}" labelName="parent.name" labelValue="${office.parent.name}"
						 title="机构" url="/sys/office/editTreeData" extId="${office.id}" cssClass="select-medium6" allowClear="${office.currentUser.admin}"/>
				</div>
			</div
		</div>
		<div class="span" >
			<div class="control-group">
				<label class="control-label-xs"><span class="help-inline"><font color="red">*</font> </span>机构名称：</label>
				<div class="controls">
					<form:input path="name" htmlEscape="false" maxlength="50" class="input-medium6 required"/>
				</div>
			</div>
		</div>
		<div class="span" >
			<div class="control-group">
				<label class="control-label-xs">公司编码：</label>
				<div class="controls">
					<form:input path="code" htmlEscape="false" maxlength="50" class="input-medium6"/>
				</div>
			</div>
		</div>
		<div class="span" >
			<div class="control-group">
				<label class="control-label-xs">机构类型：</label>
				<div class="controls" >
					<form:select path="type" class="select-medium6" disabled="false" id="hoteltype" onchange="changeHoteltype(this)">
						<form:options items="${fns:getDictList('sys_office_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</div>
			</div>
		</div>
		<div class="span" >
			<div class="control-group">
				<label class="control-label-xs">是否可用：</label>
				<div class="controls">
					<form:select path="useable" class="select-medium6" >
						<form:options items="${fns:getDictList('yes_no')}"  itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</div>
			</div>
		</div>
		<div class="span" >
			<div class="control-group">
				<label class="control-label-xs"><font color="red">*</font>联系人：</label>
				<div class="controls">
					<form:input class="input-medium6" path="master" id="master" htmlEscape="false" maxlength="50"/>
				</div>
			</div>
		</div>
		<div class="span" >
			<div class="control-group"  id="c_phone">
				<label class="control-label-xs"><font color="red">*</font>联系电话：</label>
				<div class="controls">
					<form:input class="input-medium6"  path="phone" htmlEscape="false" id="phone" maxlength="50"/>
				</div>
			</div>
		</div>
		<div class="span" >
			<div class="control-group">
				<label class="control-label-xs">省市区/县：</label>
				<div class="controls">
	                <sys:treeselect id="area" name="area.id" value="${office.area.id}" labelName="area.name" labelValue="${office.area.name}"
						title="区域" url="/sys/area/treeData" cssClass="required"/>
				</div>
			</div>
		</div>
		<div class="span" >
			<div class="control-group">
				<label class="control-label-xs">具体地址：</label>
				<div class="controls">
					<form:input path="address" htmlEscape="false" maxlength="50" style="width:355px;" />
				</div>
			</div>
		</div>
	</div>
	<div class="span" >
			<div class="control-group" id="c_latlng" style="display: none;">
				<label class="control-label-xs"><font color="red">*</font>定位信息：</label>
				<div class="controls">
					<form:input path="latlong" htmlEscape="false" class="input-medium6"  maxlength="50" readonly="true" id="latlng"/>
					<input id="seemap" class="btn btn-primary" type="button" value="获取地图" onclick="seeMap()" />
				</div>
			</div>
		</div>
	<div class="row">
		 <div class="span" >
			<div class="control-group">
				<label class="control-label-xs">备注：</label>
				<div class="controls">
					<form:textarea path="remarks" htmlEscape="false" rows="3" maxlength="200" class="input-xlarge"/>
				</div>
			</div>
		</div>
	</div>
		<div class="fixed-btn-right">
			<shiro:hasPermission name="sys:office:edit">
			<input id="savafrom" class="btn btn-primary" type="button" value="保 存" onclick="saveForm()" />&nbsp;
			</shiro:hasPermission>
		</div>
	</form:form>
</body>
</html>