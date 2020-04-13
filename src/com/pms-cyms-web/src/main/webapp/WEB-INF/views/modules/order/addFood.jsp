<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>点餐</title>
    <meta name="decorator" content="default"/>
    <script type="text/javascript">
    	$(document).ready(function(){
    		top.$.unsubscribe("checkIn");
    	    //注册事件，弹出页面需要刷新本页面，或者弹出页面回传数据用
    	    top.$.subscribe("checkIn", function (e, data) {
    	    });
			//开台
			$("#submitBtn").click(function(){
				submitBtn();
			});
    	});
    	
    	//提交
    	function submitBtn(){
			var active = $("[class='active']");
			var active1 = $("[class='active1']");
			var cookValues=[];//系统做法
			var cookValuesTemp=[];//用户自定义做法
			for (var i = 0; i < active.length; i++) {
				cookValues.push(active[i].id);
			}
			for (var i = 0; i < active1.length; i++) {
				cookValuesTemp.push(active1[i].title);
			}
			var params = "storeId=${storeId}&orderId=${orderId}&foodId=${foodId}&cookValues="+cookValues+"&cookValuesTemp="+cookValuesTemp;
				loadAjax("${ctx}/order/checkIn/addFoodCommit", params, function(result) {
					if (result.retCode == "000000") {
						layer.confirm('添加成功', {
							btn: ['确定']
						}, function(){
							top.$.publish("ordIndex",{testData:"hello"});
							window.parent.jBox.close();
						}, function(){
						});
					} else {
						layer.alert(result.retMsg);
					}
				});
    	}
    </script>
</head>
<body>
	<div class="form-horizontal" style="margin-bottom:0;">
		<table style="width:100%;color:#555;">
			<colgroup>
				<col width="33%">
				<col width="33%">
				<col width="33%">
			</colgroup>
			<tbody>
				<tr>
					<td><label>菜品名称：${ctFood.name}</label></td>
					<td><label>菜品编号：${ctFood.code}</label></td>
					<td><label>价格：${ctFood.price}</label></td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="tab-pane active" id="tab0">
		<jsp:include page="./modus.jsp"></jsp:include>
	</div>
	<div class="fixed-btn-right">
		<input type="button" id="submitBtn" class="btn btn-primary"  value="保 存"/>&nbsp;
	</div>
</body>
</html>