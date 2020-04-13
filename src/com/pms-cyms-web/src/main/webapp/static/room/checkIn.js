
function sourceChange()	//改变客源时获取渠道以及会员其它信息
{
	//1:获取渠道
	$.ajax({
        url:"${ctx}/checkIn/getChannelBySource",
        type: "post",
        dataType: "json",
        data: {
            "sourceId":$("#sourceId").val(),
            "channelId":$("#channelId").val()
        },
        success: function (result) {
        	$("#channelId").select2("val", ""); 
        	$("#channelId").empty();
        	for(var i=0;i<result.length;i++)
        	{
        		var htm="<option value='"+result[i].id+"' >"+result[i].name+"</option>";
        		$("#channelId").append(htm);
        	}
        	if(result.length>0)
        		$("#channelId").select2("val",result[0].id);
        	if($("#sourceId option:selected").html()=="散客")
        	{
        		
        		$("#bcxx").css("display","none");
        	}else if ($("#sourceId option:selected").html()=="会员")
        	{
        		$("#bcxx").css("display","");
        		$("#bcxxwz").html("会员信息");
        	}else if ($("#sourceId option:selected").html()=="协议单位")
        	{
        		$("#bcxx").css("display","");
        		$("#bcxxwz").html("协议单位");
        	}else
        	{
        		$("#bcxx").css("display","");
        		$("#bcxxwz").html("第三方单号");
        	}
        	getPricePlan();
   		}
	});
	$("#bcxx").val("");
	$("#sourceDetail").val($("#sourceId").val());
}

function getPricePlan()
{
	//房价具体信息清空
	$("#mark-info").empty();
	$("#priceFirst").val("");
	//房价方案清空
	$("#pricePlan").empty();
	$("#pricePlan").select2("val", "");
	$("#pricePlan").val(""); 
	//活动清空 
	deleteMkt();
	if($("#sourceDetail").val()==null||$("#channelId").val()==null)
		{
		return;
		}
	$.ajax({
        url:"${ctx}/checkIn/getPricePlan",
        type: "post",
        dataType: "json",
        data: {
            "sourceId":$("#sourceDetail").val(),
            "channelId":$("#channelId").val()
        },
        success: function (result) {
        	for(var i=0;i<result.length;i++)
        	{
        		$("#pricePlan").append("<option value='"+result[i].id+"'>"+result[i].name+"</option>");
        	}
        	if(result.length>0)
        		{
        		$("#pricePlan").select2("val", result[0].id);
        		getPriceDetail();
        		}
        		
   		}
	});
}


function changeRent()
{
	var type=$("#rentId option:selected").attr("checkOutType");
	var value=$("#rentId option:selected").attr("checkOutValue");
	var rentType=$("#rentId option:selected").attr("rentType");
	if(rentType=="1")	//全天房
	{
		var nowDate = new Date();
		nowDate.setDate(new Date("${storeDate}").getDate()+1);
		$("#checkOutTime").val(nowDate.getFullYear()+"-"+(nowDate.getMonth()+1)+"-"+nowDate.getDate()+" "+value);
	}
	if(rentType=="2")	//钟点房
	{
		var nowDate = new Date(new Date().valueOf() + value*60*60*1000);
		$("#checkOutTime").val(nowDate.getFullYear()+"-"+(nowDate.getMonth()+1)+"-"+nowDate.getDate()+" "+nowDate.getHours()+":"+nowDate.getMinutes()+":"+nowDate.getSeconds());
	}
	if(rentType=="3")	//午夜房
	{
		var date1=new Date();
		var date2=new Date(date1.getFullYear()+"-"+(date1.getMonth()+1)+"-"+date1.getDate()+" "+value);
		if(date1>=date2)
			{
			var nowDate = new Date();
			nowDate.setDate(new Date().getDate()+1);
			}
		else
			var nowDate=new Date();
		$("#checkOutTime").val(nowDate.getFullYear()+"-"+(nowDate.getMonth()+1)+"-"+nowDate.getDate()+" "+value);
	}
	getDateDiff();
	getPricePlan();
}


function getExtendInfo()
{
	if($("#sourceId option:selected").html()=="会员")
		getMemberInfo();
	else if ($("#sourceId option:selected").html()=="协议单位")
		getAgreementInfo();
	else
		getOtherInfo();
}

function getMemberInfo()
{
	$.ajax({
        url:"${ctx}/member/cmMember/getMemberByAccountNo",
        type: "post",
        dataType: "json",
        data: {
            "quickField":$("#sourceExtend").val()
        },
        success: function (result) {
        	if(result.retCode=="000000"){
        		$("#extendId").val(result.ret.cmMember.id);
        		$("#extendName").val(result.ret.cmMember.name);
        		$("#sourceDetail").val(result.ret.cmMember.cards[0].cardTypeId);
        		var accScoreTotal =result.ret.cmMember.cards[0].accScoreTotal;
				var accScore =result.ret.cmMember.cards[0].accScore;
				var scoreNow=parseInt(accScoreTotal)-parseInt(accScore);
				var accMoneyTotal = result.ret.cmMember.cards[0].accMoneyTotal;
				var accMoney = 	result.ret.cmMember.cards[0].accMoney;
				var moneyNow=parseInt(accMoneyTotal)-parseInt(accMoney);
				getPricePlan();
        		alert("会员卡号:"+result.ret.cmMember.id+",result.ret.cmMember姓名:"+result.ret.cmMember.name+",会员类别:"+result.ret.cmMember.cards[0].cardTypeName+",当前积分:"+scoreNow+",当前余额:"+moneyNow+",联系方式:"+result.ret.cmMember.phone)
        		
        	}else
        	{
        		alert("查无此会员");
        		$("#sourceExtend").val("");
        	}
   		}
	});
}

function getAgreementInfo()
{
	
}

function getOtherInfo()
{

}

function changeCheckOutTime()
{
	//预计天数
	getDateDiff();
	getPriceDetail();
}

function getDateDiff()
{
	var startDate=$("#checkInTime").val().split(" ")[0];
	var endDate=$("#checkOutTime").val().split(" ")[0];
	$("#days").val(DateDiff(startDate,endDate));
}

function  DateDiff(sDate1,  sDate2){    //sDate1和sDate2是2002-12-18格式  
    var  aDate,  oDate1,  oDate2,  iDays;
    aDate  =  sDate1.split("-");
    oDate1  =  new  Date(aDate[1]  +  '-'  +  aDate[2]  +  '-'  +  aDate[0]);
    aDate  =  sDate2.split("-");
    oDate2  =  new  Date(aDate[1]  +  '-'  +  aDate[2]  +  '-'  +  aDate[0]);
    iDays  =  parseInt(Math.abs(oDate1  -  oDate2)  /  1000  /  60  /  60  /24);
    if(iDays==0)
    	iDays=0.5;
    return  iDays; 
}

var guestCount=0;

function addGuest(certType,sex){
	guestCount+=1;
	var htm='<ul class="ul-form guest" name="guestUl_'+guestCount+'">';
	htm+='<li><input type="hidden" name="mainguest_'+guestCount+'" value="0"><label>姓名:<input type="text" name="name_'+guestCount+'" style="width: 150px"/></label>';
	htm+='<label>联系方式:<input type="text" name="phone_'+guestCount+'" style="width: 130px"/></label>';
	htm+='<label>证件类型:<select style="width: 100px"  name="certType_'+guestCount+'">';
	for(var i=0;i<certType.length;i++)
		htm+='<option value="'+certType[i].value+'"> '+certType[i].label+'</option>';
	htm+='</select></label><label>证件号码:<input type="text" name="certNo_'+guestCount+'" style="width: 130px"/></label></li>';
	htm+='<li><label>性别:<select style="width: 50px" name="sex_'+guestCount+'">';
	for(var i=0;i<sex.length;i++)
		htm+='<option value="'+sex[i].value+'"> '+sex[i].label+'</option>';
	htm+='</select></label>';
	htm+='<input class="btn btn-primary" type="button" onclick="delGuest('+guestCount+')" value="删除随客"/>';
	htm+='</li></ul>';
	$("#guest").append(htm);
}



function delGuest(no)
{
	$("ul[name='guestUl_"+no+"']").remove();
}
	 
		
var payCount=0;
function addPay(payWay){
	payCount+=1;
	var htm='<ul class="pays" name="deUl_'+payCount+'"><li><label>支付方式:<select name="payClass_'+payCount+'" class="select-medium4">';
	for(var i=0;i<payWay.length;i++)
		htm+='<option value="'+payWay[i].value+'"> '+payWay[i].label+'</option>';
	htm+='</select></label><label>押金:<input name="deposit_'+payCount+'" type="text" style="width: 130px"/></label>';
	htm+='<label>支付凭证:<input name="voucher_'+payCount+'" type="text" style="width: 130px"/></label>';
	htm+='<input class="btn btn-primary" type="button" onclick="delPay('+payCount+')" value="删除押金"/>';
	htm+='</li></ul>';
	$("#de").append(htm);
}
	