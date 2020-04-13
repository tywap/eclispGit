<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>配置打印机</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//添加全选事件
			$('#quickField').bind('keyup', function(event) {
				if (event.keyCode == "13") {
					storeQueryBtn();
				}
			});
		    $("#allStore").click(function(){
		    	if($(this).is(':checked')){
		    		$("[name='foodPrinter']").attr("checked",'true');//全选     
		    	}else{
		    		$("[name='foodPrinter']").removeAttr("checked");//取消全选     
		    	}
		    });
		    $(".checkBoxItem").click(function(){
		    	if($(this).is(':checked')){
		    	}else{
		    		$("#allStore").removeAttr("checked");//取消全选     
		    	}
		    });
			var foodStore =${foodStore};
			if(foodStore!=null && foodStore!= ""){
			    for(var i=0;i<foodStore.length;i++){
			    	var temp = foodStore[i];
			    	$("[name='foodPrinter'][value='"+temp+"']").attr("checked",'true');
			    }
		    } 
		});
		function save() {
			obj = document.getElementsByName("foodPrinter");
 		    check_val = [];
 		    for(k in obj){
 		        if(obj[k].checked)
 		            check_val.push(obj[k].value);
 		    }
 		    var storeId='${foodIdList}';
 		    var params="foodIdList="+storeId+"&printersId="+check_val;
			loadAjax("${ctx}/setting/ctFoodPrinter/configuringPrinters", params, function(result) {
				if (result.retCode == "000000") {
					top.$.publish("ctFoodPrinter",{testData:"hello"});
					window.parent.jBox.close();
					layer.alert("配置成功！");
				} else {
					layer.alert(result.retMsg);
				}
			});
		};
	</script>
</head>
<body>
	<div class="tab-content">
			<div class="panel-body">
				<div class="row">
					<div class="span12">
						<div class="control-group">
							<label class="control-label-xs">可配置打印机：</label>
							<input type='checkbox' id='allStore'
									name='allStore' />全选</label>&nbsp;&nbsp; <br />
							<div class="controls">
								<label>
								<c:forEach items="${foodPrinterList}" var="printer">
									<label style="display: inline-block; width: 260px;"> <input
										type="checkbox" class="checkBoxItem" name="foodPrinter"
										value="${printer.id}" id="${printer.id}" /> <strong>${printer.paramKey}</strong>(<span> ${printer.name}</span>)
									</label>
								</c:forEach>
							</div>
						</div>
					</div>
			</div>
		</div>
		<div class="fixed-btn-right">
			<input id="submitBtn" class="btn btn-primary" type="button"
				value="保 存" onclick="save()" />&nbsp;
		</div>
	</div>
</body>
</html>