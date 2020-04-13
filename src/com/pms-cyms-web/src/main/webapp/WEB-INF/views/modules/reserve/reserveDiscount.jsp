<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<title>预订折扣</title>
<meta name="decorator" content="default" />
<style type="text/css">
input::-webkit-outer-spin-button,
    input::-webkit-inner-spin-button {
        -webkit-appearance: none;
    }
    input[type="number"]{
        -moz-appearance: textfield;
        width: 120px;
    }
</style>
<script type="text/javascript">
    	$(document).ready(function(){
    		$("#submitBtn").bind("click", function() {
    			var rate= $("#discount").val();
    			var amount= $("#discountAmount").val();
    			var remarks= $("#remarks").val();
    			var cause= $("#cause").val();
    			var params={foodId:'${foodId}',foodName:'${foodName}',rate:rate,cause:cause,remarks:remarks,tableNo:'${tableNo}'};
    			loadAjax("${ctx}/reserve/ordDiscount", params, function(result) {
    				if (result.retCode == "000000") {
    					layer.confirm('打折成功', {
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
    		});
        	
        	$("#cancel").bind("click", function() {
        		window.parent.jBox.close();
    		});
    		
    	});
    	function discountA(obj) {
			var rate=obj.value;
			var amount= '${subtotalAmount }';
			var money=parseInt(amount)-rate*amount/100;
			$('#discountAmount').val(money.toFixed(1));
		}
    	function discountB(obj) {
			var rate=obj.value;
			var amount= '${subtotalAmount }';
			var money=rate/amount*100;
			$('#discount').val(money.toFixed(1));
		}
    </script>
</head>
<body>
	<form:form id="inputForm" modelAttribute="sysBusiConfig" action="${ctx}/setting/modusSetting/save" method="post" class="form-horizontal">
		<input name="id" id="id" value="${DishesBigType.id }" type="text" htmlescape="false" maxlength="64" style="display:none;">
		<div class="row" style=" margin-top: 20px;">
			<div class="span" >
				<div class="control-group" >
					<label class="control-label-xs" style="width: 120px;">已选：
					<span >${foodSize }份</span>	</label>			
				</div>
			</div>
			
			<div class="span" >
			   <div class="control-group" >
					<label class="control-label-xs" style="width: 246px;">小计金额：
						<span style="width: 40%">¥ ${subtotalAmount }</span></label>
				</div>
			</div>
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs">折扣：</label>
					<div class="controls">
						<input name="discount" id="discount" value="" type="number" class="input-xlarge required" onchange="discountA(this);" placeholder="输入0-100" step="0.01"/>
					</div>
				</div>
			</div>
			
			<div class="span">
			    <div class="control-group">
					<label class="control-label-xs">折扣金额：</label>
					<div class="controls">
						<input name="discountAmount" id="discountAmount" value="" type="number"  class="input-xlarge required" onchange="discountB(this);" step="0.1"/>
					</div>
				</div>
			</div>
			<div class="span">
				<div class="control-group">
					<label class="control-label-xs">折扣原因：</label>
					<div class="controls">
						<select name="cause" id="cause" class="select-medium6" style="width: 200px;">
						<option  >活动价格未生成</option>
						<option  >物业、机关单位外联</option>
						<option  >市场调价</option>
						<option  >零星样品、残次品</option>
						<option  >其它</option>
						</select>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="span12">
					<div class="control-group">
						<label class="control-label-xs">备注信息：</label>
						<div class="controls">
							<textarea id="remarks" name="remarks" style="width: 354px;height: 80px;"></textarea>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="fixed-btn-right">
		<input type="button" id="cancel" class="btn btn-primary"
			style="background-color: #FF6347" value="取消" />&nbsp; 
		<input type="button" id="submitBtn" class="btn btn-primary" value="确 认" />&nbsp;&nbsp;&nbsp;&nbsp;
	</div>
	</form:form>
	
	
</body>
</html>