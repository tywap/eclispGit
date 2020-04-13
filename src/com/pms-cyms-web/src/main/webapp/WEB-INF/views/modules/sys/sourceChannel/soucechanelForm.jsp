<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>渠道客源</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() { 
			$('table tbody tr').removeAttr("onclick");
			//tab切换
			var validFlag = true;
			$('#tab a').click(function (e) {
			  	validFlag = $("#inputForm").valid();//页签切换,保存前一菜单的表单状态
			  	e.preventDefault();//阻止a链接的跳转行为 
			  	$(this).tab('show');
			})
			Store=document.getElementsByName('storeId');
			//加载分公司
			loadCheckbox("companyCheckDiv","${ctx}/sys/userutils/getOfficeListByType",{typesJson:"['3','4','5']"},'${storeList}','storeId','id','name');
		});
		
		function save()
		{
			if($("#name").val()==""){
				$.jBox.alert("客源名称不能为空！");
				return false;
			}
			
			var params = {};			//房价数据
			$(".channelClass").each(function(){
				if($(this).attr("checked")=="checked")
					{
					var key=$(this).attr("channelId");
					var value="";
					if($("#check_"+key).attr("checked")=="checked")
						value+="1,"
					else
						value+="0,"
					if($("#book_"+key).attr("checked")=="checked")
						value+="1,"
					else
						value+="0,"
					if($("#center_"+key).attr("checked")=="checked")
						value+="1"
					else
						value+="0"
					params[key]=value;
					}
			});
			
			if(Object.getOwnPropertyNames(params).length==0)
			{
				$.jBox.alert("请至少选择一个渠道");	
				return ;
			}
			
			if($("#sort").val()<4)
			{
				$.jBox.alert("排序必须>3");	
				return ;
			}
			var storeId = "";
			for(var i=0; i<Store.length; i++){ 
				if(Store[i].checked) {
					storeId+=Store[i].value+',';
				}
			}
			
			$.ajax({
				type: "post",
				dataType: "json",  
			    url: "${ctx}/sys/sourceChannel/saveSource",
			    async:false,
		        data: {
		        	 "sourceName":$("#sourceName").val(),
		        	 "sourceId":$("#sourceId").val(),
		        	 "sort":$("#sort").val(),
		        	 "channelInfo":JSON.stringify(params),
		        	 "storeId":storeId
		           },
			    success: function (result) {
			    	if(result){
			    		$.jBox.alert("保存成功！")
			    		top.$.publish("sourceAndChannel",{testData:"hello"});
				    	window.parent.jBox.close();
			    	}else{
			    		$.jBox.alert("保存失败！")
			    	}
			        
			    }
			});
		}
		
		function validateSource()
		{
			if($("#sourceName").val()==""){
				$.jBox.alert("客源名称不能为空！");
				return ;
			}
			if($("#sourceName").val()=="${sourceName}"){
				save();
			}
			else
			{
				$.ajax({
		               url:"${ctx}/sys/sourceChannel/validateName",
		               type: "post",
		               dataType: "json",
		               data: {
		            	   name:$("#sourceName").val()
		               },
		               success: function (result) {
		            	   if(!result){
		            		   $.jBox.alert("客源名称冲突！");
		            	   }
		            	   else
		            		   save();
			      		}
					});
			}	
		}
	</script>
	<style>
	 .table tr td input, .table tr td select{width:auto;}
	 
	 .pl{
	 	display:inline-block;
	 	text-align:center;
	 	width:30%;
	 }
	</style>
</head>
<body>
	<form:form id="inputForm" modelAttribute="sourceChannel"  method="post" class="form-horizontal">
	<div class="control-group">
		<ul class="nav nav-tabs" id="tab" style="margin:0;">
	         <li class="active">
	         	<a href="#tab1" data-taggle="tab" class="t1">基本参数</a>
	         </li>
	         <li>
	         	<a href="#tab2" data-taggle="tab" class="t2">状态</a>
	         </li>
	     </ul>
	</div>
	<div class="tab-content">
		<div class="tab-pane active" id="tab1">
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs">客源名称：</label>
					<div class="controls">
						<input id="sourceName" maxlength="50" type="text" 
						<c:if test="${editable=='2'}">
							readonly="readonly"
						</c:if>
						class="input-medium6" value="${sourceName}"/>
						<input id="sourceId" type="hidden" value="${sourceId}"/>
					</div>
				</div>
			</div>
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs">排序：</label>
					<div class="controls">
						<input id="sort" maxlength="50" type="text" class="input-medium6"  onkeyup="this.value=this.value.replace(/[^\-?\d.]/g,'')" onafterpaste="this.value=this.value.replace(/[^\-?\d.]/g,'')" value="${sort}"/>
					</div>
				</div>
			</div>
			<div class="span" style="clear:both; width:90%;">
				<div class="control-group">
					<label class="control-label-xs">选择渠道：</label>
					<div class="controls">
						<table id="contentTable" class="table table-striped table-bordered table-condensed">
							<tfoot>
								<tr>
									<th>渠道</th>
									<th>操作</th>
								</tr>
									<c:forEach items="${channelList}" var="channel">
										<c:if test="${channel.used}">
											<tr>
												<td>
													<input type="checkbox" id="${channel.channelId}" class="channelClass" channelId="${channel.channelId}" <c:if test="${hasChannel[channel.channelId]}"> checked="checked" </c:if> />
													<label for="${channel.channelId}">${channel.name}</label>
												</td>
												<td>
													<div class="pl">
														<input type="checkbox" id="check_${channel.channelId}" <c:if test="${checkOprate[channel.channelId]}"> checked="checked" </c:if> />
														<label for="check_${channel.channelId}">开台时可见</label>
													</div>
													<div class="pl">
														<input type="checkbox" id="book_${channel.channelId}" <c:if test="${bookOprate[channel.channelId]}"> checked="checked" </c:if> />
														<label for="book_${channel.channelId}">预定时可见</label>
													</div>
													<div class="pl">
														<input type="checkbox" id="center_${channel.channelId}" <c:if test="${centerOprate[channel.channelId]}"> checked="checked" </c:if> />
														<label for="center_${channel.channelId}">中央预定可见</label>
													</div>
												</td>
											</tr>
										</c:if>
									</c:forEach>
							</tfoot>
						</table>
					</div>
				</div>
			</div>
		</div>
		<div class="tab-pane" id="tab2">		
			<!-- 分店选择 -->
			<jsp:include page="../../common/common_store_select.jsp"></jsp:include>
		</div>
	</div>

	<div class="fixed-btn-right">
		<input onclick="validateSource()" <shiro:lacksPermission name="roominfo:soucechanel:edit">disabled</shiro:lacksPermission>   class="btn btn-primary" type="button" value="保 存" />&nbsp;
	</div>
		
		
	</form:form>
</body>
</html>