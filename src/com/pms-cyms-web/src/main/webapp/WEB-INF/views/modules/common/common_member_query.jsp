<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<script type="text/javascript">
	//*******************************************事件区******************************************************************
	$(document).ready(function() {
		//会员查询
		$("#queryCardBtn").click(function(){
			queryCardBtn();
		});
		//回车执行查询
		$('#quickField').bind('keyup', function(event) {
			if (event.keyCode == "13") {
				queryCardBtn();
			}
		});
	});
	function queryCardBtn(){
		var quickField = $("#quickField").val();
		if(quickField==""){
			$.jBox.alert("请输入查询条件");
			return;
		}
		var params = {quickField:quickField};
		loadAjax("${ctx}/member/cmMember/getMemberByQuickField",params,function(result){
			if(result.retCode=="000000"){
				var cmMember = result.ret.cmMember;
				$("#memberId").val(cmMember.id);
				$("#name").val(cmMember.name);
				$("#phone").val(cmMember.phone);
				$("#sexName").val(cmMember.sexName);
				$("#birthday").val(new Date(cmMember.birthday).Format("yyyy-MM-dd"));
				$("#createDate").val(cmMember.createDate);
				$("#cardTypeId").val(cmMember.cards[0].cardType.id);
				$("#cardTypeName").val(cmMember.cards[0].cardType.name);
				
				var accScoreTotal =cmMember.cards[0].accScoreTotal;
				accScoreTotal = (accScoreTotal==undefined)?'0':accScoreTotal;
				var accScore =cmMember.cards[0].accScore;
				accScore = (accScore==undefined)?'0':accScore;
				$("#accScoreTotal").val(accScoreTotal);
				$("#cardFee").val(cmMember.cardFee);
				$("#moneyNum").val(cmMember.moneyNum);
				$("#accScore").val(accScore);
				$("#accScoreConsume").val(parseInt(accScoreTotal)-parseInt(accScore));

				var accMoneyTotal = cmMember.cards[0].accMoneyTotal;
				accMoneyTotal = (accMoneyTotal==undefined)?'0':accMoneyTotal;
				var accMoney = 	cmMember.cards[0].accMoney;
				accMoney = (accMoney==undefined)?'0':accMoney;
				$("#accMoneyTotal").val(accMoneyTotal);
				$("#accMoney").val(accMoney);
				$("#accMoneyConsume").val(parseInt(accMoneyTotal)-parseInt(accMoney));
				
				//初始化证件
				$("#certsDiv").empty();
				if(cmMember.certs!=undefined){
					for(var i=0;i<cmMember.certs.length;i++){
						var cert = cmMember.certs[i];
						var html = ""+
						"<tr class='certs'>"+
							"<td>"+
								"<input type='text' name='certType' value='"+cert.certTypeName+"' readonly='readonly' class='input-mini'/>"+
							"</td>"+
							"<td>"+
								"<input type='text' name='certId' value='"+cert.certId+"' readonly='readonly' class='input-mini'/>"+
							"</td>"+
							"<td>"+
								"<input type='text' name='address' value='"+(cert.address==undefined?'':cert.address)+"' readonly='readonly' class='input-xxlarge'/>"+
							"</td>"+
						"</tr>";
						$("#certsDiv").append(html);
					}
				}
			}else{
				$.jBox.confirm(result.retMsg, "提示", function (v, h, f) {
				    if (v == true){
				    	$("#memberId").val("");
						$("#name").val("");
						$("#phone").val("");
						$("#sexName").val("");
						$("#birthday").val("");
						$("#createDate").val("");
						$("#cardTypeId").val("");
						$("#cardTypeName").val("");
						
						$("#accScoreTotal").val("");
						$("#accScore").val("");
						$("#accScoreConsume").val("");

						$("#accMoneyTotal").val("");
						$("#accMoney").val("");
						$("#accMoneyConsume").val("");
						$("#certsDiv").empty();
				    }
				    return true;
				}, { buttons: { '确定': true}});
			}
		});
	}
	//*******************************************函数区******************************************************************
</script>
<div>
	<div class="row">
		<input type="hidden" id="memberId" name="id"/>
		<div class="span">
			<div class="control-group">
				<label class="control-label-xs"><span class="notice">*</span>会员查询：</label>
				<div class="controls">
					<input type="text" id="quickField" name="quickField" htmlEscape="false" style="width:355px" class="input-medium6 required" placeholder="卡号\身份证号\手机号" />
				</div>
			</div>
		</div>
		<div class="span">
			<div class="control-group">
				<input id="queryCardBtn" class="btn btn-primary" type="button" value="查询"/>&nbsp;
			</div>
		</div>
	</div>
	<div class="row">
		<div class="span">
			<div class="control-group">
				<label class="control-label-xs">姓名：</label>
				<div class="controls">
					<input type="text" id="name" htmlEscape="false" class="input-medium6" readonly="readonly"/>
				</div>
			</div>
		</div>
		<div class="span">	
			<div class="control-group">
				<label class="control-label-xs">联系电话：</label>
				<div class="controls">
					<input type="text" id="phone" htmlEscape="false" class="input-medium6" readonly="readonly"/>
				</div>
			</div>
		</div>
		<div class="span">	
			<div class="control-group">
				<label class="control-label-xs">性别：</label>
				<div class="controls">
					<select id="sex" disabled="disabled">
						<c:forEach var="sex" items="${fns:getDictList('sex')}">
							<option value="${sex.value}">${sex.label}</option>
						</c:forEach>
					</select>
				</div>
			</div>
		</div>	
		<div class="span">
			<div class="control-group">
				<label class="control-label-xs">生日：</label>
				<div class="controls">
					<input type="text" id="birthday" htmlEscape="false" class="input-medium6" readonly="readonly"/>
				</div>
			</div>
		</div>	
	</div>
	<!-- <div class="row">
		<div class="span12">
			<table class="table table-bordered" style="width:100%;" border="1px;">
				<tr>
					<th>证件类型</th>
					<th>证件名称</th>
					<th>地址</th>
				</tr>
				<tbody id="certsDiv">
				</tbody>
			</table>
		</div>		
	</div> -->
	<!-- 积分 -->
	<hr />
	<div class="row">
		<div class="span">
			<div class="control-group">
				<label class="control-label-xs">总积分：</label>
				<div class="controls">
					<input type="text" id="accScoreTotal" name="accScoreTotal" htmlEscape="false" class="input-mini" readonly="readonly"/>
				</div>
			</div>
		</div>
		<div class="span">	
			<div class="control-group">
				<label class="control-label-xs">已用积分：</label>
				<div class="controls">
					<input type="text" id="accScoreConsume" name="accScoreConsume" htmlEscape="false" class="input-mini" readonly="readonly"/>
				</div>
			</div>
		</div>
		<div class="span">	
			<div class="control-group">
				<label class="control-label-xs">当前积分：</label>
				<div class="controls">
					<input type="text" id="accScore" name="accScore" htmlEscape="false" class="input-mini" readonly="readonly"/>
				</div>
			</div>
		</div>	
		<div class="span">
			<div class="control-group">
				<label class="control-label-xs">总充值：</label>
				<div class="controls">
					<input type="text" id="accMoneyTotal" name="accMoneyTotal" htmlEscape="false" class="input-mini" readonly="readonly"/>
				</div>
			</div>
		</div>
		<div class="span">	
			<div class="control-group">
				<label class="control-label-xs">已用储值：</label>
				<div class="controls">
					<input type="text" id="accMoneyConsume" htmlEscape="false" class="input-mini" readonly="readonly"/>
				</div>
			</div>
		</div>
		<div class="span">	
			<div class="control-group">
				<label class="control-label-xs">当前余额：</label>
				<div class="controls">
					<input type="text" id="accMoney" name="accMoney" htmlEscape="false" class="input-mini" readonly="readonly"/>
				</div>
			</div>
		</div>	
		<div class="span">
			<div class="control-group">
				<label class="control-label-xs">发卡时间：</label>
				<div class="controls">
					<input type="text" id="createDate" htmlEscape="false" class="input-medium" readonly="readonly"/>
				</div>
			</div>
		</div>
		<div class="span">	
			<div class="control-group">
				<label class="control-label-xs">已住天数：</label>
				<div class="controls">
					<input type="text" id="" htmlEscape="false" class="input-mini" readonly="readonly"/>
				</div>
			</div>
		</div>
		<div class="span">	
			<div class="control-group">
				<label class="control-label-xs">会员类型：</label>
				<div class="controls">
					<input type="text" id="cardTypeName" htmlEscape="false" class="input-mini" readonly="readonly"/>
					<input type="hidden" id="cardTypeId"/>
				</div>
			</div>
		</div>	
		<div class="span">	
			<div class="control-group">
				<label class="control-label-xs">实收卡费：</label>
				<div class="controls">
					<input type="text" id="cardFee" name="cardFee" htmlEscape="false" class="input-mini" readonly="readonly"/>
				</div>
			</div>
		</div>
		<div class="span">	
			<div class="control-group">
				<label class="control-label-xs">赠送金额：</label>
				<div class="controls">
					<input type="text" id="moneyNum" name="moneyNum" htmlEscape="false" class="input-mini" readonly="readonly"/>
				</div>
			</div>
		</div>
	</div>
</div>