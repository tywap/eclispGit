<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<script type="text/javascript">
	<!--字典map-->
	var sourceMap = {};
	<c:forEach items="${fns:getSysBusiConfigList('source','')}" var="var">
		sourceMap["${var.paramKey}"]="${var.name}";
	</c:forEach>
	var sourceName="";
	$(document).ready(function() {
		$("#salesman2").hide();
		$("#tableNo2").hide();
		$("#createDate2").hide();
		$("#settleDate2").hide();
		$("#memberName22").hide();
		$("#memberPhone22").hide();
		$("#memberName1").hide();
		$("#memberPhone1").hide();
		$("#bcxx").hide();
		$("#bcxx1").hide();
		/* $("#bcxxw").hide(); */
		$("#toggle").click(function() {
			$("#guestTable").slideToggle();
		});
		$("input[name='secretFlag']").click(function() {
			stopBubbling(event);
		});
		//修改备注
		var statu = 0;
		var edit = document.getElementById('edit');
		if(edit != undefined){
			edit.onclick = function() {
				var item = document.getElementsByClassName('leader');
				var item_length = item.length
				var item_value = new Array(item_length);
				for (i = 0; i < item_length; i++) {
					item_value[i] = item[i].innerHTML;
				}
				if (statu == 0) {
					edit.innerHTML = '<i class="icon icon-save"></i>';
					for (i = 0; i < item_length; i++) {
						item[i].innerHTML = "<textarea class='input-xxlarge' row='2'>" + item_value[i] + "</textarea>";
					}
					//判断是否是会员与协议单位添加客源
					if(sourceName=="会员"||sourceName=="协议单位"){
						var sourceId=$("#sourceName").html();
						var soure='<select style="width:90px" id="sourceId1" onchange="sourceChange2()">';
						$.each(sourceMap,function(key,values){
							if(sourceId==values){
								soure=soure+'<option sourceName='+values+' value='+key+' selected="selected">'+values+'</option>';
							}else{
								soure=soure+'<option sourceName='+values+' value='+key+'>'+values+'</option>';
							}
						});
						soure=soure+'</select>';
						var mem=$("#memberName").html();//获取联系人
						/* alert(mem); */
						$("#memberName11").val(mem);
						var memberPhone=$("#memberPhone").html();//联系电话
						$("#memberPhone11").val(memberPhone);
						
						$("#sourceName11").append(soure);//添加客源
						$("#memberName").hide();
						$("#memberName1").show();//联系人
						$("#memberPhone").hide();
						$("#memberPhone1").show();
						$("#sourceName").hide();
						$("#_sourceName2").hide();
					}else{
						var sourceId=$("#sourceName2").html();
						var soure='<select style="width:90px" id="sourceId" onchange="sourceChange()">';
						$.each(sourceMap,function(key,values){
							if(sourceId==values){
								soure=soure+'<option sourceName='+values+' value='+key+' selected="selected">'+values+'</option>';
							}else{
								soure=soure+'<option sourceName='+values+' value='+key+'>'+values+'</option>';
							}
						});
						soure=soure+'</select>';
						var linkman=$("memberName2").html();//联系人
						$("#memberName33").val(linkman);
						$("#sourceName22").append(soure);//添加客源
						$("#sourceName2").hide();
						$("#memberName2").hide();
					}
					
					/* $("#sourceName").hide();//隐藏客源 */
					$("#salesman").hide();//隐藏业务员
					$("#tableNo").hide();//隐藏台号
					$("#useNum").hide();//隐藏用餐人数
					$("#createDate").hide();//隐藏开台时间
					$("#settleDate").hide();
					$("#memberPhone2").hide();
					$("#salesman2").show();//显示全部的业务员
					$("#tableNo2").show();//显示全部台号
					$("#createDate2").show();//显示开台时间
					$("#settleDate2").show();
					$("#memberName22").show();
					$("#memberPhone22").show();
					//初始化渠道
					sourceChange();
					sourceChange2()
					loadSelect("salesman3","${ctx}/sys/userutils/getSalesmanList",{},'','id','name');//加载业务员
					//加载餐台
					loadSelect("tableNo3","${ctx}/setting/ctTable/getTablesByStoreId",{storeId:'${param.storeId}'},'${param.tableId}','id','no');
					//添加下拉框客源的值
					var foundingtime=$("#createDate").html();//获取开台时间
					$("#createDate3").val(foundingtime);
					var endtime=$("#settleDate").html();//结束时间
					$("#settleDate3").val(endtime);
					
					var number2=$("#useNum").html();//获取用餐人数
					var number='<input type="text" style="width:120px" id="useNum3" value='+number2+' name="useNum3" maxlength="2" class="required digits"/>';//用餐人数
					$("#useNum2").append(number);//添加用餐人数
					
					var phonecontact=$("#memberPhone2").html();//联系电话
					$("#memberPhone33").val(phonecontact);
					statu = 1;
					$("input[name='secretFlag']").removeAttr("disabled");
				} else {
					edit.innerHTML = '<i class="icon icon-edit"></i>';
					var item_input = document.getElementsByClassName('input-xxlarge');
					for (i = 0; i < item_length; i++) {
						item_value[i] = item_input[i].value;
					}
					for (i = 0; i < item_length; i++) {
						item[i].innerHTML = item_value[i];
					}
					$("#tableNo").show();//台号
					$("#tableNo2").hide();
					$("#useNum").show();//人数
					$("#useNum2").hide();
					$("#createDate").show();//开台时间
					$("#createDate2").hide();
					$("#settleDate").show();//结束时间
					$("#settleDate2").hide();
					$("#sourceName2").show();//隐藏客源
					$("#sourceId").hide();
					if(sourceName=="会员"||sourceName=="协议单位"){
						$("#_sourceName2").show();
						$("#bcxx1").hide();
						$("#sourceName").show();
						$("#sourceName11").hide();
						$("#memberName").show();
						$("#memberName1").hide();
						$("#memberPhone").show();
						$("#memberPhone1").hide();
					}else{
						$("#memberName2").show();//联系人
						$("#memberName22").hide();
						$("#memberPhone2").show();//联系电话
						$("#memberPhone22").hide();
						$("#bcxx").hide();
					}
					$("#salesman").show();//业务员 
					$("#salesman2").hide();
					statu = 0
					updateOrderRemarks();
					$("input[name='secretFlag']").attr("disabled","disabled");
				}
				return false;
			};
		}
	});
	
	//修改客源
	function sourceChange(){
		//取消绑定事件
		$("#thirdPartName").unbind("click");
		$("#thirdPartName").removeAttr("readonly");
		$("#thirdPartName").val("");
		$("#thirdPartId").val("");
		$("#thirdPartName").val("");
		//1:获取渠道
		$.ajax({
	        url:"${ctx}/sys/sourceChannel/getChannelBySource",
	        type: "post",
	        dataType: "json",
	        data: {
	            "sourceId":$("#sourceId").val(),
	            "channelId":$("#channelId").val()
	        },
	        success: function (result) {
	        	$("#channelId").select2("val", ""); 
	        	$("#channelId").empty();
	        	for(var i=0;i<result.length;i++){
	        		var htm="<option value='"+result[i].id+"' >"+result[i].name+"</option>";
	        		$("#channelId").append(htm);
	        	}
	        	if(result.length>0){
	        		$("#channelId").select2("val",result[0].id);
	        	}
	        	if($("#sourceId option:selected").html()=="散客"){
	        		$(".bcxx").hide();
	        	}else if ($("#sourceId option:selected").html()=="会员"){
	        		$(".bcxx").show();
	        		$("#thirdPartName").attr("readonly","readonly");
	        		$("#bcxxwz").html("<span style='color:red'>*</span>会员信息：");
	        		
	        		$("#thirdPartName").bind("click",function(){
    	    			top.$.jBox.open(
   			               "iframe:${ctx}/member/member/getMemberListInit?storeId=${storeId}",
   			               "选择会员",
   			               1050,
   			               560,
   			               {
   			                   buttons: {},
   			                   loaded: function (h) {
   			                       $(".jbox-content", top.document).css("overflow-y", "hidden");
   			                   }
   			               }
    			        );
    					$("#thirdPartName").attr("readonly","readonly");	
    				});
	        	}else if ($("#sourceId option:selected").html()=="协议单位"){
	        		$(".bcxx").show();
	        		$("#thirdPartName").attr("readonly","readonly");	
	        		$("#bcxxwz").html("<span style='color:red'>*</span>协议单位：");
	        		
	        		$("#thirdPartName").bind("click",function(){
    	    			top.$.jBox.open(
   			               "iframe:${ctx}/member/group/getGroupListInit?storeId=${storeId}",
   			               "选择协议单位",
   			               1050,
   			               560,
   			               {
   			                   buttons: {},
   			                   loaded: function (h) {
   			                       $(".jbox-content", top.document).css("overflow-y", "hidden");
   			                   }
   			               }
    			        );
    				});
	        	}else{
	        		$(".bcxx").show();
	        		$("#bcxxwz").html("<span style='color:red'>*</span>第三方单号：");
	        	}
	   		}
		});
	}
	//修改客源
	function sourceChange2(){
		//取消绑定事件
		$("#thirdPartName1").unbind("click");
		$("#thirdPartName1").removeAttr("readonly");
		$("#thirdPartName1").val("");
		$("#thirdPartId1").val("");
		$("#thirdPartName1").val("");
		//1:获取渠道
		$.ajax({
	        url:"${ctx}/sys/sourceChannel/getChannelBySource",
	        type: "post",
	        dataType: "json",
	        data: {
	            "sourceId":$("#sourceId1").val(),
	            "channelId":$("#channelId1").val()
	        },
	        success: function (result) {
	        	$("#channelId1").select2("val", ""); 
	        	$("#channelId1").empty();
	        	for(var i=0;i<result.length;i++){
	        		var htm="<option value='"+result[i].id+"' >"+result[i].name+"</option>";
	        		$("#channelId1").append(htm);
	        	}
	        	if(result.length>0){
	        		$("#channelId1").select2("val",result[0].id);
	        	}
	        	if($("#sourceId1 option:selected").html()=="散客"){
	        		$(".bcxx").hide();
	        	}else if ($("#sourceId1 option:selected").html()=="会员"){
	        		$(".bcxx").show();
	        		$("#thirdPartName1").attr("readonly","readonly");
	        		$("#bcxxwz1").html("<span style='color:red'>*</span>会员信息：");
	        		
	        		$("#thirdPartName1").bind("click",function(){
    	    			top.$.jBox.open(
   			               "iframe:${ctx}/member/member/getMemberListInit?storeId=${storeId}",
   			               "选择会员",
   			               1050,
   			               560,
   			               {
   			                   buttons: {},
   			                   loaded: function (h) {
   			                       $(".jbox-content", top.document).css("overflow-y", "hidden");
   			                   }
   			               }
    			        );
    					$("#thirdPartName1").attr("readonly","readonly");	
    				});
	        	}else if ($("#sourceId1 option:selected").html()=="协议单位"){
	        		$(".bcxx").show();
	        		$("#thirdPartName1").attr("readonly","readonly");	
	        		$("#bcxxwz1").html("<span style='color:red'>*</span>协议单位：");
	        		
	        		$("#thirdPartName").bind("click",function(){
    	    			top.$.jBox.open(
   			               "iframe:${ctx}/member/group/getGroupListInit?storeId=${storeId}",
   			               "选择协议单位",
   			               1050,
   			               560,
   			               {
   			                   buttons: {},
   			                   loaded: function (h) {
   			                       $(".jbox-content", top.document).css("overflow-y", "hidden");
   			                   }
   			               }
    			        );
    				});
	        	}else{
	        		$(".bcxx").show();
	        		$("#bcxxwz1").html("<span style='color:red'>*</span>第三方单号：");
	        	}
	   		}
		});
	}
	//加载订单信息
	function getOrdTableById(){
		var orderId = '${orderId}';
		var params = {orderId:orderId};
		loadAjax("${ctx}/order/ordTable/getOrdTableById",params,function(result){
			if(result.retCode=="000000"){
				var ordTable = result.ret.ordTable;
				sourceName = sourceMap[ordTable.source];
				if(sourceName=="会员"||sourceName=="协议单位"){
					$("#tr1").show();
					$("#tr2").hide();
					$("#sourceName").html(sourceName);
					$("#_sourceName").html(sourceName);
					$("#thirdPartName").html(ordTable.thirdPartName);
					$("#memberName").html(ordTable.memberName);
					$("#memberPhone").html(ordTable.memberPhone);
				}else{
					$("#tr1").hide();
					$("#tr2").show();
					$("#sourceName2").html(sourceName);
					$("#memberName2").html(ordTable.memberName);
					$("#memberPhone2").html(ordTable.memberPhone);
				}
				$("#tableNo").html(ordTable.tableNo);
				$("#useNum").html(ordTable.useNum);
				$("#createDate").html(ordTable.createDate);
				$("#settleDate").html(ordTable.settleDate);
				if(ordTable.salesman!=null){
				$("#salesman").html(ordTable.salesman.name);
				}
				$("#remarks").html(ordTable.remarks);
				$("#useTable").html(ordTable.useNum);
			}else{
				layer.alert(result.retMsg);
				return;
			}
		})	
	}
	
	//修改备注
	function updateOrderRemarks(){
		var orderId = '${orderId}';
		var remarks = $("#remarks").html();
		var tableNo3=$("#tableNo3").val();//台号ID
		var useNum2=$("#useNum3").val();//用餐人数 
		var createDate3=$("#createDate3").val();//开台时间
		var settleDate3=$("#settleDate3").val();//结束时间
		var sourceId="";//客源ID
		if(sourceName=="会员"||sourceName=="协议单位"){
			sourceId=$("#sourceId1").val()
		}else{
			sourceId=$("#sourceId").val();
		}
		var memberName33="";//联系人
		if(sourceName=="会员"||sourceName=="协议单位"){
			memberName33=$("#memberName11").val()
		}else{
			memberName33=$("#memberName33").val();//memberName11
		}
		
		var memberPhone33="";//联系电话 
		if(sourceName=="会员"||sourceName=="协议单位"){
			memberName33=$("#memberPhone11").val()
		}else{
			memberName33=$("#memberPhone33").val();//memberName11
		}
		
		var salesman3=$("#salesman3").val();//业务员ID
		var thirdPartName = $("#thirdPartName").val();
		var params = "";
		if(sourceName=="会员"||sourceName=="协议单位"){
			params = {orderId:orderId,remarks:remarks,tableNo:tableNo3,useNum:useNum2,createDate:createDate3,settleDate:settleDate3
					,sourceId:sourceId,memberName:memberName33,memberPhone:memberPhone33,salesman:salesman3,thirdPartName:thirdPartName};
		}else{
			params = {orderId:orderId,remarks:remarks,tableNo:tableNo3,useNum:useNum2,createDate:createDate3,settleDate:settleDate3
					,sourceId:sourceId,memberName:memberName33,memberPhone:memberPhone33,salesman:salesman3,thirdPartName:thirdPartName};
		}
		
		 loadAjax("${ctx}/order/ordTable/updateOrderInfo",params,function(result){
			if(result.retCode=="000000"){
				layer.confirm(result.retMsg, {
  				  btn: ['确定'] 
  				}, function(index){
  					layer.close(index);
  				}, function(){
  					return ;
  				});
			}else{
				layer.alert(result.retMsg);
				return;
			}
		});
	}
	//协议单位详情
	function agreementGroupDetail(obj){
		layer.open({
		  type: 1,
		  skin: 'layui-layer-demo', //样式类名
		  closeBtn: 0, //不显示关闭按钮
		  anim: 2,
		  shadeClose: true, //开启遮罩关闭
		  content: "<div style='margin:10px;'>协议编号：${cmGroup.agreementCode}</br>单位名称：${cmGroup.name}</br>归属酒店：${cmGroup.officeName}</br>业务员：${cmGroup.userName}</br>业务员电话：${cmGroup.userPhone}</br></div>"
		});
	}
</script>
<style>
	.fa-icon{position:relative;}
	.fa-icon i{
		position: absolute;
	    left: -15px;
	    top: 3px;
	    color: blue;
	    font-size: 16px;
	}
</style>
<div>
	<div class="form-horizontal" style="margin-bottom:0;">
		<table style="width:100%;color:#555;">
			<colgroup>
				<col width="25%">
				<col width="25%">
				<col width="25%">
				<col width="25%">
			</colgroup>
			<tbody>
				<tr>
					<td><label>台号：<span id="tableNo"></span></label><span id="tableNo2">
					<select id="tableNo3" name="salsman" class="select-medium4"></select></span>
					</td>
					<td><label>用餐人数：<span id="useNum"></span></label><span id="useNum2"></span></td>
					<td><label>开台时间：<span id="createDate"></span></label><span id="createDate2">
						<input id="createDate3" style="margin-right:3px; width: 155px" name="createDate3" type="text" readonly="readonly" maxlength="20" class="Wdate input-medium6"
                        value="" pattern="yyyy-MM-dd HH:mm:ss"
                        onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm',isShowClear:false,});" />
					</span></td>
					<td><label>结账时间：<span id="settleDate"></span></label><span id="settleDate2">
					<input id="settleDate3" style="margin-right:3px; width: 155px" name="settleDate3" type="text" readonly="readonly" maxlength="20" class="Wdate input-medium6"
                        value="" pattern="yyyy-MM-dd HH:mm:ss"
                        onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm',isShowClear:false,});" />
					</span></td>
				</tr>
				<tr id="tr1">
					<td><label>客源：<span id="sourceName"></span></label><span id="sourceName11"></span></td>
					<td id="bcxx1" class="bcxx"><span id="bcxxwz1">补充信息：</span>
						<input type="text" id="thirdPartName1" style="cursor:pointer; width: 120px" value=""/>
						<span class="controls" style="position:relative;">
						<i class="icon-search" style="position:absolute;right:20px;top:6px;"></i>
						<input type="hidden" id="thirdPartId1"  value=""/>
						<input type="hidden" id="thirdPartType1"  />
						</span>
					</td>
					<td id="_sourceName2"><label><span id="_sourceName"></span>：<span id="thirdPartName2"></span></label></td>
					<td><label>联系人：<span id="memberName"></span></label><span id="memberName1">
					<input type="text" style="width:120px" id="memberName11" value="" name="memberName11" maxlength="10" class="required digits"/>
					</span></td>
					<td><label>联系电话：<span id="memberPhone"></span></label><span id="memberPhone1">
					<input type="text" style="width:120px" id="memberPhone11" value="" maxlength="11" name="memberPhone11" class="required digits"/>
					</span></td>		
				</tr>
				<tr id="tr2">
					<td><label>客源：<span id="sourceName2"></span></label><span id="sourceName22"></span></td>
					<td id="bcxx" class="bcxx"><span id="bcxxwz">补充信息：</span>
						<input type="text" id="thirdPartName" style="cursor:pointer; width: 120px" value=""/>
						<span class="controls" style="position:relative;">
						<i class="icon-search" style="position:absolute;right:20px;top:6px;"></i>
						<input type="hidden" id="thirdPartId"  value=""/>
						<input type="hidden" id="thirdPartType"  />
						</span>
					</td>
					<td><label>联系人：<span id="memberName2"></span></label><span id="memberName22">
					<input type="text" style="width:120px" id="memberName33" value="" name="memberName33" maxlength="10" class="required digits"/>
					</span></td>
					<td colspan="2"><label>联系电话：<span id="memberPhone2"></span></label><span id="memberPhone22">
					<input type="text" style="width:120px" id="memberPhone33" value="" maxlength="11" name="memberPhone33" class="required digits"/>
					</span></td>
				</tr>
				<tr>
					<td><label>业务员：<span id="salesman"></span></label>
					<span id="salesman2">
					<select id="salesman3" name="salsman" class="select-medium4"></select></span>
					</td>
				</tr>
				<tr>
					<td colspan="4">
						<label>备注：<span class="leader" id='remarks'></span>
							<shiro:hasPermission name="index:order:checkIn">
								<span style="top:30px;left:215px;font-size:18px;">
									<span><a id="edit" href="#"><i class="icon icon-edit"></i></a></span>
								</span>
							</shiro:hasPermission>
						</label>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>