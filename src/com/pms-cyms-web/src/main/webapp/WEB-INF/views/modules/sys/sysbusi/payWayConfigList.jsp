<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>支付方式配置</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//事件名称保持唯一，这里直接用tabId
            var eventName="payWayConfig";
            //解绑事件
            top.$.unsubscribe(eventName);
            //注册事件，弹出页面需要刷新本页面，或者弹出页面回传数据用
            top.$.subscribe(eventName, function (e, data) {
                //data  可以通过这个对象来回传数据
                $("#searchForm").submit();
            });
            
         	//新增-支付方式
            $("#qBtn").click(function(){
            	top.$.jBox.open(
                    "iframe:${ctx}/sys/sysBusiConfig/payWayConfigForm?eventName="+eventName+"&editFlag=add",
                    "新增-支付方式",
                    500,
                    260,
                    {
                        buttons: {},
                        loaded: function (h) {
                            $(".jbox-content", top.document).css("overflow-y", "hidden");
                        }
                    }
                );
            });
         	
        	//编辑-支付方式
            $("#contentTable2 a.update").click(function (e) {
                var id = $(this).data("id");
                top.$.jBox.open(
                    "iframe:${ctx}/sys/sysBusiConfig/payWayConfigForm?eventName="+eventName+"&id=" + id + "&editFlag=edit",
                    "编辑-支付方式",
                    500,
                    260,
                    {
                        buttons: {},
                        loaded: function (h) {
                            $(".jbox-content", top.document).css("overflow-y", "hidden");
                        }
                    }
                );
            });
        	
        	//删除-支付方式
        	$("#contentTable2 a.remove").click(function (e) {
        		var id = $(this).data("id");
        		var name = $(this).data("name");
        		confirmx('确认要删除支付方式【'+name+'】吗？', "${ctx}/sys/sysBusiConfig/deletePayWayConfig?id=" + id);
        	});
        	
        	//启用及关闭
        	<c:forEach var="var" items="${payWayConfigs}" varStatus="vs">
	        	switchEvent("#fly${var.id}",function(){switchBtn('${var.id}','1')},function(){switchBtn('${var.id}','0')});
        	</c:forEach>
		});
		
		//启用及关闭
		function switchBtn(id,status){
			var params = {id:id,status:status}
			loadAjax("${ctx}/sys/sysBusiConfig/savePayWayConfig",params,function(result){
				if(result.retCode=="000000"){
					 $("#searchForm").submit();
		    	}else{
		    		$.jBox.alert(result.retMsg);
		    	}
			});
		}
	</script>
</head>
<body>
	<sys:message content="${message}"/>
	<form:form id="searchForm" modelAttribute="sysBusiConfig" action="" method="post" class="breadcrumb form-search">	
		<table id="contentTable2" class="table table-striped table-bordered table-condensed" style="width:15%;float:left;margin-right:1%;margin-bottom:50px;">
			<thead>
				<tr>
					<th></th>
					<th>支付方式</th>
					<th>操作</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${payWayConfigs}" var="payWayConfig">
					<tr>
						<td>
							<c:if test="${payWayConfig.extend.equals('2')||payWayConfig.extend.equals('3')}">
								<div class="common-row">
									<div class="cell-right">
										<c:choose>
											<c:when test="${payWayConfig.status.equals('1')}">
												<span class="switch-on" themeColor="#31B080" id="fly${payWayConfig.id}"></span>
											</c:when>
											<c:otherwise>
												<span class="switch-off" themeColor="#31B080" id="fly${payWayConfig.id}"></span>
											</c:otherwise>
										</c:choose>
									</div>
								</div>
							</c:if>
						</td>
						<td>${payWayConfig.name}</td>
						<td>
							<c:if test="${payWayConfig.extend.equals('3')}">
								<a class="update" data-id="${payWayConfig.id}" >
									编辑
								</a>
								<!-- <a class="remove" data-id="${payWayConfig.id}" data-name="${payWayConfig.name}">
									删除
								</a> -->
							</c:if>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</form:form>
	
	<div class="fixed-space">
		<div class="fixed-btn">
	    	<input type="button" id="qBtn" class="btn btn-primary" <shiro:lacksPermission name="sys:sysBusiConfig:edit">disabled</shiro:lacksPermission> value="Q.新增支付方式"/>
	    </div>
	</div>
</body>
</html>