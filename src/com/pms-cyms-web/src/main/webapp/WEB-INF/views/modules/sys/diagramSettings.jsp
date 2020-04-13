<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>系统设置</title>
	<meta name="decorator" content="default"/>
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/jscolor/jquery.cxcolor.css" />
	<style>
		.ul-form{
			list-style:none;
		}
	</style>
	<script src="${ctxStatic}/jscolor/jquery.cxcolor.js?v=1" type="text/javascript"> </script>
</head>
<body>
<script type="text/javascript">
	$(document).ready(function() {
		$("span").click(function(){
			var box=$(this).prev("input[type='radio'],input[type='checkbox']");
			if(box.length==0)
				return;
			if(box.attr("checked")=="checked")
				box.removeAttr("checked");
			else
				box.attr("checked","checked");
		});
		
		$('#jingkong').cxColor();
		$('#zaizhu').cxColor();
		$('#yuliu').cxColor();
		$('#weixiu').cxColor();
		$('#baoliu').cxColor();
		$('#kongzangc').cxColor();
	});
	
	function saveSetting(){
		var settingInfo={};
		$(".setting").each(function(){
			if($(this).attr("checked")=="checked"){
				settingInfo[$(this).attr("id")]=$(this).val();
			}
		});
		settingInfo["cleanEmpty"]=$("#jingkong").attr("roomColor");
		settingInfo["checkIn"]=$("#zaizhu").attr("roomColor");
		settingInfo["reserve"]=$("#yuliu").attr("roomColor");
		settingInfo["disabled"]=$("#weixiu").attr("roomColor");
		$(".ftt_size").each(function(){
			if($(this).attr("checked")=="checked"){
				settingInfo["ftt_size"]=$(this).val();
			}
		});
		
		$.ajax({
	        url:"${ctx}/diagram/setting/saveDiagramSettings",
	        type: "post",
	        dataType: "json",
	        data: {
	     	 "settingInfo":JSON.stringify(settingInfo),
	     	 "type":"diagramSetting"
	        },
	        success: function (result) {
	     	   if(result)
	     		   {$.jBox.alert("保存成功！");
	     		  	location.reload();
	     		   }
	     		   
	     	   else
	     		  $.jBox.alert("保存失败！");
	     	
	   	}
		});
	}
	
	function checkPhotoThis(obj){
		var box=$(obj).find("input[type='radio'],input[type='checkbox']");
		if(box.length==0)
			return;
		if(box.attr("checked")=="checked")
			box.removeAttr("checked");
		else
			box.attr("checked","checked");
	}
</script>
<style>
	.ul-form li span:hover{
		cursor:pointer;
	}
	.ul-form .fttsize{background:#2A80EE;float: left;color:#fff;position:relative; padding:5px;margin-right:15px;border-radius: 5px;box-shadow: 1px 1px 1px #666666;}
	.ul-form .largeSize{width: 190px;height: 108px;background:#2A80EE;}
	.ul-form .mediumSize{width: 160px;height: 88px;}
	.ul-form .smallSize{width: 140px;height: 75px;}
	.ul-form .smallerSize{width: 110px;height: 60px;}
	.ul-form .fttsize span{display:block;}
	.room-number{font-weight: bold;font-size: 16px;}
	.chain{position:absolute;top:3px;right:5px;}
	.user{position:absolute;top:3px;right:22px;}
</style>
	<div id="content" class="row-fluid">
		<ul class="nav nav-tabs" style="margin:10px 0 !important;">
			<li class="active"><a href="${ctx}/diagram/setting" >业务参数</a></li>
			<li><a href="${ctx}/diagram/setting/guestAccounts">宾客账务</a></li>
			<li><a href="${ctx}/diagram/setting/nightSetting" >系统参数</a></li>
		</ul>
		<div class="control-group">
			<ul class="ul-form">
				<li><label>首页-左侧快捷搜索：</label>
				</li>
				<li>			
					<input type="checkbox" value="1" class="setting" id="floor" <c:if test="${settingMap.floor=='1'}">checked="checked"</c:if> ><span>区域</span>
					<input type="checkbox" value="1" class="setting" id="tableType" <c:if test="${settingMap.tableType=='1'}">checked="checked"</c:if> ><span>台型</span>
					<input type="checkbox" value="1" class="setting" id="tableStatus" <c:if test="${settingMap.tableStatus=='1'}">checked="checked"</c:if> ><span>台态</span>
					<input type="checkbox" value="1" class="setting" id="guestStatus" <c:if test="${settingMap.guestStatus=='1'}">checked="checked"</c:if> ><span>客态</span>
				</li>
			</ul>
		</div>
		<!-- <div class="control-group">
			<ul class="ul-form">
				<li><label>首页-房态图标示：</label>
				</li>
				<li>
					<input type="checkbox" value="1" class="setting" id="lianfang" <c:if test="${settingMap.lianfang=='1'}">checked="checked"</c:if> ><span>联房</span>
					<input type="checkbox" value="1" class="setting" id="huiyuan" <c:if test="${settingMap.huiyuan=='1'}">checked="checked"</c:if> ><span>会员</span>
					<input type="checkbox" value="1" class="setting" id="xieyidanwei" <c:if test="${settingMap.xieyidanwei=='1'}">checked="checked"</c:if> ><span>协议单位</span>
					<input type="checkbox" value="1" class="setting" id="pingtai" <c:if test="${settingMap.pingtai=='1'}">checked="checked"</c:if> ><span>平台</span>
					<input type="checkbox" value="1" class="setting" id="zhongdianfang" <c:if test="${settingMap.zhongdianfang=='1'}">checked="checked"</c:if> ><span>钟点房</span>
					<input type="checkbox" value="1" class="setting" id="wuyefang" <c:if test="${settingMap.wuyefang=='1'}">checked="checked"</c:if> ><span>午夜房</span>
					<input type="checkbox" value="1" class="setting" id="changzu" <c:if test="${settingMap.changzu=='1'}">checked="checked"</c:if> ><span>长租</span>
					<input type="checkbox" value="1" class="setting" id="yushouquandaoqi" <c:if test="${settingMap.yushouquandaoqi=='1'}">checked="checked"</c:if> ><span>预授权到期</span>
					<input type="checkbox" value="1" class="setting" id="zangfang" <c:if test="${settingMap.zangfang=='1'}">checked="checked"</c:if> ><span>脏房</span>
					<input type="checkbox" value="1" class="setting" id="jieyong" <c:if test="${settingMap.jieyong=='1'}">checked="checked"</c:if> ><span>借用</span>
					<input type="checkbox" value="1" class="setting" id="lingshitai" <c:if test="${settingMap.lingshitai=='1'}">checked="checked"</c:if> ><span>临时态</span>
					<input type="checkbox" value="1" class="setting" id="dangriyuli" <c:if test="${settingMap.dangriyuli=='1'}">checked="checked"</c:if> ><span>当日预离</span>
					<input type="checkbox" value="1" class="setting" id="qianfei" <c:if test="${settingMap.qianfei=='1'}">checked="checked"</c:if> ><span>欠费</span>
					<input type="checkbox" value="1" class="setting" id="youren" <c:if test="${settingMap.youren=='1'}">checked="checked"</c:if> ><span>有人</span>
					<input type="checkbox" value="1" class="setting" id="wurao" <c:if test="${settingMap.wurao=='1'}">checked="checked"</c:if> ><span>勿扰</span>
				</li>
			</ul>
		</div> -->
		<div class="control-group">
			<ul class="ul-form" style="height: 140px">
				<li><label>首页-房态图大小：</label>
				</li>
				<li>
					<div class="fttsize largeSize" onclick="checkPhotoThis(this)">
						<span class="room-number">3002</span>
						<span>包厢</span>
						<span>李珊珊</span>
						<span class="chain"><i class="icon-link"></i></span>
						<span class="user"><i class="icon-user"></i></span>
						<input type="radio"   <c:if test="${settingMap.ftt_size=='2'}">checked="checked"</c:if> name="ftt_size" class="ftt_size" value="2" style="float: right;margin-top: 32px;">
					</div>
					<div class="fttsize mediumSize" onclick="checkPhotoThis(this)" >
						<span class="room-number">3002</span>
						<span>包厢</span>
						<span>李珊珊</span>
						<span class="chain"><i class="icon-link"></i></span>
						<span class="user"><i class="icon-user"></i></span>
						<input type="radio"  <c:if test="${settingMap.ftt_size=='1'}">checked="checked"</c:if> name="ftt_size" class="ftt_size" value="1" style="float: right;margin-top: 10px;">
					</div>
					<div class="fttsize smallSize" onclick="checkPhotoThis(this)">
						<span class="room-number">3002</span>
						<span>包厢</span>
						<span>李珊珊</span>
						<span class="chain"><i class="icon-link"></i></span>
						<span class="user"><i class="icon-user"></i></span>
						<input type="radio"  <c:if test="${settingMap.ftt_size=='0'}">checked="checked"</c:if> name="ftt_size" class="ftt_size" value="0" style="float: right;margin-top: 0px;">
					</div>
					<div class="fttsize smallerSize" onclick="checkPhotoThis(this)">
						<span class="room-number">3002</span>
						<span>包厢</span>
						<span>李珊珊</span>
						<span class="chain"><i class="icon-link"></i></span>
						<span class="user"><i class="icon-user"></i></span>
						<input type="radio"   <c:if test="${settingMap.ftt_size=='3'}">checked="checked"</c:if> name="ftt_size" class="ftt_size" value="3" style="float: right;margin-top: -13px;">
					</div>
				</li>
			</ul>
		</div>
		<div class="control-group">
			<ul class="ul-form">
				<li><label>首页-房间排序规则：</label>
				</li>
				<li>
					<input type="checkbox" class="setting" value="1" id="loucengpaixu"   <c:if test="${settingMap.loucengpaixu=='1'}">checked="checked"</c:if> ><span>按楼层排序</span>
				</li>
			</ul>
		</div>
		<div class="control-group">
			<ul class="ul-form">
				<li><label>首页-房态颜色：</label>
				</li>
				<li>
					<div class="demo">
						<input id="weixiu" style="width: 80px;text-align: center;<c:if test="${settingMap.disabled!=null}">background-color:${settingMap.disabled}</c:if>" roomColor="<c:if test="${settingMap.disabled!=null}">${settingMap.disabled}</c:if>"  type="text" class="input_cxcolor" readonly  value="停用">
				   		<input id="jingkong" style="width: 80px;text-align: center;<c:if test="${settingMap.cleanEmpty!=null}">background-color:${settingMap.cleanEmpty}</c:if>" roomColor="<c:if test="${settingMap.cleanEmpty!=null}">${settingMap.cleanEmpty}</c:if>" type="text" class="input_cxcolor" readonly  value="空台">
				   		<input id="yuliu" style="width: 80px;text-align: center;<c:if test="${settingMap.reserve!=null}">background-color:${settingMap.reserve}</c:if>" roomColor="<c:if test="${settingMap.reserve!=null}">${settingMap.reserve}</c:if>"  type="text" class="input_cxcolor" readonly  value="预订">
				   		<input id="zaizhu" style="width: 80px;text-align: center;<c:if test="${settingMap.checkIn!=null}">background-color:${settingMap.checkIn}</c:if>" roomColor="<c:if test="${settingMap.checkIn!=null}">${settingMap.checkIn}</c:if>"  type="text" class="input_cxcolor" readonly  value="用餐">
				   </div>
				</li>
			</ul>
		</div>
	</div>
	<!-- <div class="control-group" style="margin-bottom:50px;">	
		<ul class="ul-form">
			<li><label>房态其他：</label>
			</li>
			<li>
				换房后自动转为<select id="huanfangzhuan" class="select-medium6">
				<option value="0" <c:if test="${settingMap.huanfangzhuan=='0'}">selected="selected"</c:if>>空脏房</option>
				<option value="1" <c:if test="${settingMap.huanfangzhuan=='1'}">selected="selected"</c:if>>净空房</option>
				</select>
				<input type="checkbox" value="1" <c:if test="${settingMap.yeshenhouzhuanhuan=='1'}">checked="checked"</c:if> class="setting" id="yeshenhouzhuanhuan" ><span>夜审后在住房转为脏房</span>
				<input type="checkbox" value="1" style="display: none;"  <c:if test="${settingMap.huanfangqianqingka=='1'}">checked="checked"</c:if> class="setting" id="huanfangqianqingka" ><span style="display: none;">换房前必须先清卡</span>
				<input type="checkbox" value="1" style="display: none;" <c:if test="${settingMap.kongfangfaka=='1'}">checked="checked"</c:if>class="setting" id="kongfangfaka" ><span style="display: none;">空房允许发门锁卡</span>
			</li>
		</ul>
	</div> -->
	<div class="fixed-btn-right">
		<input id="btnSubmit" class="btn btn-primary" type="button" onclick="saveSetting()" value="保 存"/>&nbsp;
	</div>
</body>
</html>



