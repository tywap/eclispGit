<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>活动基础信息</title>
	<meta name="decorator" content="default"/>
	<link rel="stylesheet" href="${ctxStatic}/common/jquery-ui.min.css">
	<link rel="stylesheet" href="${ctxStatic}/common/jquery-ui.theme.min.css">
	<style>
	  ul,li{margin:0;list-style:none !important;} 
	
	  .nav-tabs{margin-left:0;}
	
	  .widget-content>label{
	  	display:inline-block;
	  	width:120px;
	  }
	  #notDate span:hover{
	  	cursor:pointer;
	  }
	</style>
</head>
<body>
	<div class="form-horizontal">
		<ul class="ul-form">
			<li class="control-group">
				<label class="control-label-xs">活动名称：</label>
				<input class="input-medium6" type="text"  value="${detailMap.name}" />
			</li>
			<li class="control-group">
				<label class="control-label-xs">活动日期：</label>
				<input type="text" value="${detailMap.validDate}" readonly="readonly" class="input-medium6 Wdate " style="margin-right:3px;"/>-
				<input type="text" value="${detailMap.expireDate}" readonly="readonly" class="input-medium6 Wdate "	/>
			</li>
			<li class="control-group">
				<label class="control-label-xs">每天时段：</label>
				<input type="text" value="${detailMap.beginTime}" readonly="readonly" class="input-medium6 Wdate "	style="margin-right:3px;"/>-
				<input type="text" value="${detailMap.endTime}" readonly="readonly" class="input-medium6 Wdate " />
			</li>
			<li class="control-group">
				<label class="control-label-xs">状态：</label>
				<c:if test="${detailMap.status=='1'}">正常</c:if>
				<c:if test="${detailMap.status=='0'}">停用</c:if>
			</li>
		</ul>
		<hr />
		<div class="widget-box" style="float: left; margin-top: 10px; margin-bottom: 10px;">
			<div class="widget-title"> <span class="icon"> <i class="fa fa-calendar"></i> </span>
				<h5>活动参与时段</h5>
			</div>
			<div class="widget-content nopadding" id="collapse-group" style="border-bottom: 0;">
			<c:if test="${detailMap.andType=='weeks'}">
				<div class="accordion-group" style="margin: 0; border: 0;">
					<div class="accordion-heading">
						<div class="widget-title">
							<a data-parent="#collapse-group" href="#collapseGOne" onclick="collapsaGType('weeks')" data-toggle="collapse">
								<h5>星期 Weeks</h5>
							</a>
						</div>
					</div>
					<div class="collapse in accordion-body" >
						<div class="widget-content">
							
							<label>
								<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '1')>-1}">checked="checked"</c:if> />星期一</label>
							<label>
								<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '2')>-1}">checked="checked"</c:if>/>星期二</label>
							<label>
								<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '3')>-1}">checked="checked"</c:if>/>星期三</label>
							<label>
								<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '4')>-1}">checked="checked"</c:if>/>星期四</label>
							<label>
								<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '5')>-1}">checked="checked"</c:if>/>星期五</label>
							<label>
								<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '6')>-1}">checked="checked"</c:if>/>星期六</label>
							<label>
								<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '7')>-1}">checked="checked"</c:if>/>星期日</label>
						</div>
					</div>
				</div>
			</c:if>
			<c:if test="${detailMap.andType=='days'}">
					<div class="accordion-group" style="margin: 0; border: 0;">
						<div class="accordion-heading">
							<div class="widget-title">
								<a data-parent="#collapse-group" href="#collapseGOne" onclick="collapsaGType('weeks')" data-toggle="collapse">
									<h5>日期  Days</h5>
								</a>
							</div>
						</div>
						<div class="collapse in accordion-body" >
							<div class="widget-content">
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '01')>-1}">checked="checked"</c:if> />1号</label>
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '02')>-1}">checked="checked"</c:if> />2号</label>
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '03')>-1}">checked="checked"</c:if> />3号</label>
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '04')>-1}">checked="checked"</c:if> />4号</label>
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '05')>-1}">checked="checked"</c:if> />5号</label>
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '06')>-1}">checked="checked"</c:if> />6号</label>
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '07')>-1}">checked="checked"</c:if> />7号</label>
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '08')>-1}">checked="checked"</c:if> />8号</label>
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '09')>-1}">checked="checked"</c:if> />9号</label>
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '10')>-1}">checked="checked"</c:if> />10号</label>
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '11')>-1}">checked="checked"</c:if> />11号</label>
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '12')>-1}">checked="checked"</c:if> />12号</label>
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '13')>-1}">checked="checked"</c:if> />13号</label>
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '14')>-1}">checked="checked"</c:if> />14号</label>
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '15')>-1}">checked="checked"</c:if> />15号</label>
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '16')>-1}">checked="checked"</c:if> />16号</label>
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '17')>-1}">checked="checked"</c:if> />17号</label>
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '18')>-1}">checked="checked"</c:if> />18号</label>
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '19')>-1}">checked="checked"</c:if> />19号</label>
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '20')>-1}">checked="checked"</c:if> />20号</label>
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '21')>-1}">checked="checked"</c:if> />21号</label>
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '22')>-1}">checked="checked"</c:if> />22号</label>
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '23')>-1}">checked="checked"</c:if> />23号</label>
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '24')>-1}">checked="checked"</c:if> />24号</label>
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '25')>-1}">checked="checked"</c:if> />25号</label>
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '26')>-1}">checked="checked"</c:if> />26号</label>
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '27')>-1}">checked="checked"</c:if> />27号</label>
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '28')>-1}">checked="checked"</c:if> />28号</label>
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '29')>-1}">checked="checked"</c:if> />29号</label>
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '30')>-1}">checked="checked"</c:if> />30号</label>
								<label>
									<input type="checkbox" <c:if test="${fn:indexOf(detailMap.andValue, '31')>-1}">checked="checked"</c:if> />31号</label>
							</div>
						</div>
					</div>
			</c:if>
			</div>
		</div>
		<li><label>以下日期不参与活动：</label>
		</li>
		<li>
		
		<button id="ShowButton" type="button">选择日期</button>
		<div  class="control-group" style="border:black 1px solid;width: 848px;height: 50px;border:1px solid #ccc;margin-top:3px;border-radius:4px;" >
			${detailMap.notValue}
		</div>
		</li>
		
		<div class="control-group">
			<label style="font-weight: bold;">优惠方式：</label>
			<c:if test="${detailMap.actType=='1'}">在住期间</c:if>
			<c:if test="${detailMap.actType=='0'}">单次</c:if>
		
			<c:if test="${detailMap.discountType=='0'}">固定价格</c:if>
			<c:if test="${detailMap.discountType=='1'}">减免金额</c:if>
			<c:if test="${detailMap.discountType=='2'}">折扣率</c:if>
		</div>
		
		<hr />
		<div class="lodger_infor" style="width: 840px;">
			<div class="room_title" style="margin-bottom: 10px;"></div>
			<div class="room room1" style="width: 800px;">
				<label style="font-weight: bold;">特殊渠道\客源选项：</label>
			</div>
			<div class="control-group">
				<label style="margin-right: 5px;">会员积分翻倍</label>
					<c:if test="${detailMap.inteMulti=='0'}">0倍</c:if>
					<c:if test="${detailMap.inteMulti=='1'}">0.5倍</c:if>
					<c:if test="${detailMap.inteMulti=='2'}">1倍</c:if>
					<c:if test="${detailMap.inteMulti=='3'}">1.5倍</c:if>
					<c:if test="${detailMap.inteMulti=='4'}">2倍</c:if>
					<c:if test="${detailMap.inteMulti=='5'}">3倍</c:if>
				<label style="margin-right: 5px;">限制每个客人每天单数</label>
					<c:if test="${empty detailMap.cardNo}">不限</c:if>
					<c:if test="${detailMap.cardNo=='1'}">1单</c:if>
					<c:if test="${detailMap.cardNo=='2'}">2单</c:if>
					<c:if test="${detailMap.cardNo=='3'}">3单</c:if>
					<c:if test="${detailMap.cardNo=='4'}">4单</c:if>
					<c:if test="${detailMap.cardNo=='5'}">5单</c:if>
					<c:if test="${detailMap.cardNo=='6'}">6单</c:if>
					
			</div>
			<div class="control-group">
				<label style="margin-right: 5px;">微信|官网|app：</label>
				<label style="margin-right: 20px;">
					<input type="checkbox" style="margin-right: 5px; margin-top: 0;"  <c:if test="${detailMap.onlinePay=='1'}">checked="checked"</c:if>/>
					仅在线支付参与
				</label>
				<label>
					<input type="checkbox" style="margin-right: 5px; margin-top: 0;" <c:if test="${detailMap.hasCoupon=='1'}">checked="checked"</c:if>/>
					优惠券同享
				</label>
			</div>
			<div class="control-group">
				<input type="checkbox" id="numberOfMembersRadio" <c:if test="${!empty detailMap.numberOfMembers}">checked="checked"</c:if> />
				<label style="margin-right: 5px;">会员仅第
					<input type="text"  value="${detailMap.numberOfMembers}"  style="margin-right: 5px; margin-top: 0;"  class="input-medium6" />
					次参与
				</label>
				</label>
			</div>
			<div class="control-group">
				<input type="checkbox" <c:if test="${detailMap.birthOnly=='1'}">checked="checked"</c:if> />
					<label for="birthOnly">会员仅生日参与</label>
			</div>
			<div class="control-group">
				<label style="margin-right: 5px;">OTA直连状态</label>
					<c:if test="${empty detailMap.ota}">不限</c:if>
					<c:if test="${detailMap.ota=='0'}">上架</c:if>
					<c:if test="${detailMap.ota=='1'}">下架</c:if>
			</div>
			<div class="room room1">
				
				<label>活动说明：</label>
				<textarea >${detailMap.remarks}</textarea>
			</div>
		</div>
	</div>
</body>
</html>