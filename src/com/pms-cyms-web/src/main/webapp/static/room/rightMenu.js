$(document).ready(function(){
	context.init({preventDoubleContext: false});
	/*
	$(".ftt").each(function(){
		var stateName="";
		if($(this).attr("dirty")=="1")
			stateName="置干净";
		if($(this).attr("dirty")=="0")
			stateName="置脏";	
		if($(this).attr("roomState")=="01"||$(this).attr("roomState")=="06")
			emptyMenu(this.id,$(this).attr("dirty"),stateName);
		else if($(this).attr("roomState")=="02"){
			if($(this).attr("isUnion")!=''&&$(this).attr("isUnion")!='undefined')
				unionCheckedMenu(this.id,$(this).attr("dirty"),stateName);
			else
				singleCheckedMenu(this.id,$(this).attr("dirty"),stateName);
		}
		else if($(this).attr("roomState")=="03")
			reserveMenu(this.id,$(this).attr("dirty"),stateName,$(this).attr("roomState"));
		else
			otherMenu(this.id,$(this).attr("dirty"),stateName,$(this).attr("roomState"));
	});
	*/
	$(document).on('mouseover', '.me-codesta', function(){
		$('.finale h1:first').css({opacity:0});
		$('.finale h1:last').css({opacity:1});
	});
	
	$(document).on('mouseout', '.me-codesta', function(){
		$('.finale h1:last').css({opacity:0});
		$('.finale h1:first').css({opacity:1});
	});
	
});

//刷新单个房间右击菜单
function reflashRightMenu(roomId){
	return;
	var room=$("#rooms-"+roomId);
	$(".dropdown-menu").remove();
	//$("#dropdown-"+roomId).remove();
	var stateName="";
	var tempStatus = "";
	if($(room).attr("dirty")=="1"){
		stateName="置干净";
	}
	if($(room).attr("dirty")=="0"){
		stateName="置脏";
	}
	console.log("id:" + roomId + ", tempStatus:" + $(room).attr("tempStatus") + ",roomState:" + $(room).attr("roomState"));
	if($(room).attr("roomState")=="01"||$(room).attr("roomState")=="06")
		emptyMenu(room.attr("id"),$(room).attr("dirty"),stateName);
	else if($(room).attr("roomState")=="02"){
		if($(room).attr("isUnion")!=''&&$(room).attr("isUnion")!='undefined')
			unionCheckedMenu(room.attr("id"),$(this).attr("dirty"),stateName);
		else
			singleCheckedMenu(room.attr("id"),$(this).attr("dirty"),stateName);
	}
	else if($(room).attr("roomState")=="03")
		reserveMenu(room.attr("id"),$(room).attr("dirty"),stateName,$(room).attr("roomState"));
	else if($(room).attr("roomState")=="04")
		//维修房
		selRepairMenu(room.attr("id"),$(room).attr("dirty"),stateName,$(room).attr("roomState"));
	else if($(room).attr("roomState")=="05")
		//保留房
		selReserveMenu(room.attr("id"),$(room).attr("dirty"),stateName,$(room).attr("roomState"));
	else
		otherMenu(room.attr("id"),$(room).attr("dirty"),stateName,$(room).attr("roomState"));
	
}

//刷新所有房间右击菜单
function reflashAllRightMenu()
{
	$(".dropdown-menu").remove();
	$("li[id^='rooms-']").each(function(i){  
		var roomId=$(this).attr("id").split("-")[1];
			var room=$(this);
			var stateName="";
			if($(room).attr("dirty")=="1")
				stateName="置干净";
			if($(room).attr("dirty")=="0")
				stateName="置脏";	
			if($(room).attr("roomState")=="01"||$(room).attr("roomState")=="06")
				emptyMenu(room.attr("id"),$(room).attr("dirty"),stateName);
			else if($(room).attr("roomState")=="02"){
				if($(room).attr("isUnion")!=''&&$(room).attr("isUnion")!='undefined')
					unionCheckedMenu(room.attr("id"),$(this).attr("dirty"),stateName);
				else
					singleCheckedMenu(room.attr("id"),$(this).attr("dirty"),stateName);
			}
			else if($(room).attr("roomState")=="03")
				reserveMenu(room.attr("id"),$(room).attr("dirty"),stateName,$(room).attr("roomState"));
			else
				otherMenu(room.attr("id"),$(room).attr("dirty"),stateName,$(room).attr("roomState"));
	}); 
}


//维修房
function selRepairMenu(id,state,stateName){
	var roomId = id.split("-")[1];
	var ordRoom=$("#rooms-"+id.split("-")[1]);
	var tempStatus = $(ordRoom).attr("tempStatus");
	var tempName = "+增加临时态";
	var isFinished = "";
	if(tempStatus=="0"){
		tempName = "-完成临时态";
		isFinished = "1";
	}	
	context.attach(id, [
	     {text: '维修完成', subMenu: [               		
   		     {text: "维修完成", action: function(e){
   		    	selRepairFinish(roomId,$(ordRoom).attr("roomno"));
   		     }}
   		  ]},
   		  {text: '变更房态', subMenu: [               		
 		     {text: stateName, action: function(e){
 		    	changeRoomCleanStatus(id.split("-")[1],$(ordRoom).attr("dirty"),$(ordRoom).attr("roomno"));
 		     }}
 		  ]},
   		  {divider: true},
		  {
	   		text: '电控', show:top.m_qudian==1, subMenu: [
	   			{
	   				text: '维修取电', action: function(e){
	   					top.callElectricApi($(ordRoom), "repair");
	   				},
	   			},
	   			{
	   				text: '房态重传', action: function(e){
	   					top.synRoomStateToQD($(ordRoom), false);
	   				}
	   			}
	   		]
	   	  },
	   	  {text: '其它', subMenu: [
  	    	{text: "门锁发卡", action: function(e){
  	    		newCardInit($(ordRoom).attr("lockNo"),$(ordRoom).attr("checkTime"),$(ordRoom).attr("membername"),
  	    				$(ordRoom).attr("roomno"),$(ordRoom).attr("roomTypeName")
  	    				,$(ordRoom).attr("rentTypeName"),$(ordRoom).attr("days"));
	    	   }},
  	       {text: "门锁清卡", action: function(e){
  	    	   cleanCardInit($(ordRoom).attr("lockNo"),$(ordRoom).attr("checkTime"),$(ordRoom).attr("membername"),
		    				$(ordRoom).attr("roomno"),$(ordRoom).attr("roomTypeName")
		    				,$(ordRoom).attr("rentTypeName"),$(ordRoom).attr("days"));
  	       }},
  	       {text: tempName,action: function(e){
    		    	newTempStatus(id.split("-")[1],$(ordRoom).attr("roomno"),isFinished);
  		     }}
  	    ]}
   	 ]);
}

//保留房
function selReserveMenu(id,state,stateName){
	var roomId = id.split("-")[1];
	var ordRoom=$("#rooms-"+id.split("-")[1]);
	var tempStatus = $(ordRoom).attr("tempStatus");
	var tempName = "+增加临时态";
	var isFinished = "";
	if(tempStatus=="0"){
		tempName = "-完成临时态";
		isFinished = "1";
	}	
	context.attach(id, [
	     {text: '保留完成', subMenu: [               		
   		     {text: "保留完成", action: function(e){
   		    	selReserveFinish(roomId,$(ordRoom).attr("roomno"));
   		     }}
   		  ]},
   		  {text: '变更房态', subMenu: [               		
 		     {text: stateName, action: function(e){
 		    	changeRoomCleanStatus(id.split("-")[1],$(ordRoom).attr("dirty"),$(ordRoom).attr("roomno"));
 		     }}
 		  ]},
   		  {divider: true},
		  {
	   		text: '电控', show:top.m_qudian==1, subMenu: [
	   			{
	   				text: '维修取电', action: function(e){
	   					top.callElectricApi($(ordRoom), "repair");
	   				},
	   			},
	   			{
	   				text: '房态重传', action: function(e){
	   					top.synRoomStateToQD($(ordRoom), false);
	   				}
	   			}
	   		]
	   	  },
	   	  {text: '其它', subMenu: [
  	    	{text: "门锁发卡", action: function(e){
  	    		newCardInit($(ordRoom).attr("lockNo"),$(ordRoom).attr("checkTime"),$(ordRoom).attr("membername"),
  	    				$(ordRoom).attr("roomno"),$(ordRoom).attr("roomTypeName")
  	    				,$(ordRoom).attr("rentTypeName"),$(ordRoom).attr("days"));
	    	   }},
  	       {text: "门锁清卡", action: function(e){
  	    	   cleanCardInit($(ordRoom).attr("lockNo"),$(ordRoom).attr("checkTime"),$(ordRoom).attr("membername"),
		    				$(ordRoom).attr("roomno"),$(ordRoom).attr("roomTypeName")
		    				,$(ordRoom).attr("rentTypeName"),$(ordRoom).attr("days"));
  	       }},
  	       {text: tempName,action: function(e){
    		    	newTempStatus(id.split("-")[1],$(ordRoom).attr("roomno"),isFinished);
  		     }}
  	    ]}
   	 ]);
}

//临时态
function emptyMenu(id,state,stateName)
{
	var ordRoom=$("#rooms-"+id.split("-")[1]);
	var tempStatus = $(ordRoom).attr("tempStatus");
	var tempName = "+增加临时态";
	var isFinished = "";
	if(tempStatus=="0"){
		tempName = "-完成临时态";
		isFinished = "1";
	}	
	context.attach(id, [
		 {text: '入住', subMenu: [
		     {text: "入住登记", action: function(e){
		    	 checkIn($(ordRoom).attr("roomId"),id.split("-")[1],$(ordRoom).attr("roomType"));
		     }},
		 ]},
		 {text: '变更房态', subMenu: [               		
		     {text: stateName, action: function(e){
		    	 changeRoomCleanStatus(id.split("-")[1],$(ordRoom).attr("dirty"),$(ordRoom).attr("roomno"));
		     }},              			
		     {text: '置维修房',action: function(e){
		    	 changeRoomStatus(id.split("-")[1],"repair");
		     }},
		     {text: '置保留房',action: function(e){
		    	 changeRoomStatus(id.split("-")[1],"retain");
		     }}		    
		  ]},
		  {divider: true},
		  {
	   		text: '电控', show:top.m_qudian==1, subMenu: [
	   			{
	   				text: '打扫取电', action: function(e){
	   					if($(ordRoom).attr("dirty")=="1"){
	   						top.callElectricApi($(ordRoom), "clean");
	   					} else {
	   						top.$.jBox.info("干净房不能进行打扫取电!");
	   					}
	   				},
	   			},
	   			{
	   				text: '查房取电', action: function(e){
	   					top.callElectricApi($(ordRoom), "inspect");
	   				},
	   			},
	   			{
	   				text: '房态重传', action: function(e){
	   					top.synRoomStateToQD($(ordRoom), false);
	   				}
	   			}
	   		]
	   	  },
	   	  {text: '其它', subMenu: [
      	       {text: "门锁清卡", action: function(e){
      	    	 cleanCardInit($(ordRoom).attr("lockNo"),$(ordRoom).attr("checkTime"),$(ordRoom).attr("membername"),
		    				$(ordRoom).attr("roomno"),$(ordRoom).attr("roomTypeName")
		    				,$(ordRoom).attr("rentTypeName"),$(ordRoom).attr("days"));
      	    	}},
	  	    	 {text: tempName,action: function(e){
			    	 newTempStatus(id.split("-")[1],$(ordRoom).attr("roomno"),isFinished);
			     }}
      	    ]}
	 ]);
}

function reserveMenu(id,state,stateName,tempStatus)
{
	var ordRoom=$("#rooms-"+id.split("-")[1]);
	var tempStatus = $(ordRoom).attr("tempStatus");
	var tempName = "+增加临时态";
	var isFinished = "";
	if(tempStatus=="0"){
		tempName = "-完成临时态";
		isFinished = "1";
	}	
	context.attach(id, [
	     {text: '转入住', subMenu: [               		
   		     {text: "转入住", action: function(e){
   		    	orderCheckIn($(ordRoom).attr("orderNo"),$(ordRoom).attr("roomId"));
   		     }}
   		  ]},
   		 {text: '变更房态', subMenu: [               		
   		     {text: stateName, action: function(e){
   		    	changeRoomCleanStatus(id.split("-")[1],$(ordRoom).attr("dirty"),$(ordRoom).attr("roomno"));
   		     }},              			
   		     {text: '置空房',action: function(e){
   		    	changeRoomStatus(id.split("-")[1],"empty");
   		     }}   		     
   		  ]},
   		  {divider: true},
   		  {
  	   		text: '电控', show:top.m_qudian==1, subMenu: [
  	   			{
  	   				text: '房态重传', action: function(e){
  	   					top.synRoomStateToQD($(ordRoom), false);
  	   				}
  	   			}
  	   		]
  	   	  },
   	   	  {text: '其它', subMenu: [
       	       {text: "门锁清卡", action: function(e){
       	    	cleanCardInit($(ordRoom).attr("lockNo"),$(ordRoom).attr("checkTime"),$(ordRoom).attr("membername"),
	    				$(ordRoom).attr("roomno"),$(ordRoom).attr("roomTypeName")
	    				,$(ordRoom).attr("rentTypeName"),$(ordRoom).attr("days"));
       	    	}},
       	    	{text: tempName,action: function(e){
       		    	newTempStatus(id.split("-")[1],$(ordRoom).attr("roomno"),isFinished);
     		     }}
       	    ]}
   	 ]);
}

function otherMenu(id,state,stateName)
{
	var ordRoom=$("#rooms-"+id.split("-")[1]);
	var tempStatus = $(ordRoom).attr("tempStatus");
	var tempName = "+增加临时态";
	var isFinished = "";
	if(tempStatus=="0"){
		tempName = "-完成临时态";
		isFinished = "1";
	}	
	context.attach(id, [
  		 {text: '变更房态', subMenu: [               		
  		     {text: stateName, action: function(e){
  		    	changeRoomCleanStatus(id.split("-")[1],$(ordRoom).attr("dirty"),$(ordRoom).attr("roomno"));
  		     }}
  		  ]},
  		  {divider: true},
  		  {
	   		text: '电控', show:top.m_qudian==1, subMenu: [
	   			{
	   				text: '维修取电', action: function(e){
	   					top.callElectricApi($(ordRoom), "repair");
	   				},
	   			},
	   			{
	   				text: '房态重传', action: function(e){
	   					top.synRoomStateToQD($(ordRoom), false);
	   				}
	   			}
	   		]
	   	  },
  	   	  {text: '其它', subMenu: [
    	    	{text: "门锁发卡", action: function(e){
    	    		newCardInit($(ordRoom).attr("lockNo"),$(ordRoom).attr("checkTime"),$(ordRoom).attr("membername"),
    	    				$(ordRoom).attr("roomno"),$(ordRoom).attr("roomTypeName")
    	    				,$(ordRoom).attr("rentTypeName"),$(ordRoom).attr("days"));
	    	   }},
    	       {text: "门锁清卡", action: function(e){
    	    	   cleanCardInit($(ordRoom).attr("lockNo"),$(ordRoom).attr("checkTime"),$(ordRoom).attr("membername"),
		    				$(ordRoom).attr("roomno"),$(ordRoom).attr("roomTypeName")
		    				,$(ordRoom).attr("rentTypeName"),$(ordRoom).attr("days"));
    	       }},
    	       {text: tempName,action: function(e){
      		    	newTempStatus(id.split("-")[1],$(ordRoom).attr("roomno"),isFinished);
    		     }}
    	    ]}
  	 ]);
}

function unionCheckedMenu(id,state,stateName)
{
	var ordRoom=$("#rooms-"+id.split("-")[1]);
	var tempStatus = $(ordRoom).attr("tempStatus");
	var tempName = "+增加临时态";
	var isFinished = "";
	if(tempStatus=="0"){
		tempName = "-完成临时态";
		isFinished = "1";
	}	
	context.attach(id, [
   		 {text: '增加消费',action: function(e){
   			 	 addConsume($(ordRoom).attr("orderno"));
		     }},
		 {text: '住客服务',action: function(e){
			 addRoomService($(ordRoom).attr("orderno"),id.split("-")[1]);
		     }},    
   		 {text: '结账', subMenu: [               		
   		     {text: "整单结账", action: function(e){
   		    	checkOut("1",$(ordRoom).attr("isunion"),"",$(ordRoom).attr("roomno"),id.split("-")[1]);
   		     }},              			
   		     {text: '整单PX',action: function(e){
   		    	checkOutPX("1",$(ordRoom).attr("isunion"),"",$(ordRoom).attr("roomno"),id.split("-")[1]);
   		     }},        			
   		     {text: '单房结账',action: function(e){
   		    	checkOut("0",$(ordRoom).attr("orderno"),"",$(ordRoom).attr("roomno"));
   		     }},
   		     {text: '不结账退房',action: function(e){
   		    	checkOutPX("0",$(ordRoom).attr("orderno"),"",$(ordRoom).attr("roomno"),id.split("-")[1]);
   		     }}
   		  ]},
    	{text: '调整', subMenu: [               		
  		     {text: "房价调整", action: function(e){
  		    	adjustPrice($(ordRoom).attr("orderno"));
  		     }},
  		     {text: '换房',action: function(e){
  		    	changeRooms($(ordRoom).attr("orderno"));
  		     }},
  		     {text: '转账',action: function(e){
  		    	ordTransfer($(ordRoom).attr("isUnion"),$(ordRoom).attr("orderno"),$(ordRoom).attr("roomno"),$(ordRoom).attr("memberName"));
  		     }},
  		     {text: '续住',action: function(e){
  		    	 addDays($(ordRoom).attr("orderno"),$(ordRoom).attr("rentTimer"),$(ordRoom).attr("channelId"));
  		     }},
  		     {text: '押金',action: function(e){
  		    	 getdDeposit($(ordRoom).attr("orderno"));
  		     }}
  		  ]},
	  {text: '变更房态',subMenu: [
 		     {text: stateName, action: function(e){
 		    	changeRoomCleanStatus(id.split("-")[1],$(ordRoom).attr("dirty"),$(ordRoom).attr("roomno"));
		     }},			    
		     getCheckOutApplyInfo($(ordRoom).attr("isunion"),$(ordRoom).attr("orderno"),$(ordRoom).attr("checkOutStatus"),1)
		     ,
    		 getCheckOutApplyInfoAll($(ordRoom).attr("isunion"),$(ordRoom).attr("orderno"),$(ordRoom).attr("checkOutStatus"),0)
	     ]},
	  {text: '打印',subMenu: [
	         {text: '打印入住单', action: function(e){
	        	 window.open("../print/printCheckIn?ordId="+$(ordRoom).attr("orderno")); 
	         }}
	     ]},
	  {divider: true},
	  {
   		text: '电控', show:top.m_qudian==1, subMenu: [
   			{
   				text: '延长用电时间', action: function(e){
   					top.prolongPowerTime($(ordRoom));
   				}
   			},
   			{
   				text: '房态重传', action: function(e){
   					top.synRoomStateToQD($(ordRoom), false);
   				}
   			}
   		]
   	  },
   	  {text: '其它', subMenu: [
    	    {text: "门锁发卡", action: function(e){
	    		newCardInit($(ordRoom).attr("lockNo"),$(ordRoom).attr("checkTime"),$(ordRoom).attr("membername"),
	    				$(ordRoom).attr("roomno"),$(ordRoom).attr("roomTypeName")
	    				,$(ordRoom).attr("rentTypeName"),$(ordRoom).attr("days"));
    	    }},
  	        {text: "门锁清卡", action: function(e){
  	    	 cleanCardInit($(ordRoom).attr("lockNo"),$(ordRoom).attr("checkTime"),$(ordRoom).attr("membername"),
	    				$(ordRoom).attr("roomno"),$(ordRoom).attr("roomTypeName")
	    				,$(ordRoom).attr("rentTypeName"),$(ordRoom).attr("days"));
  	    	}},
  	    	{text: tempName,action: function(e){
		    	 newTempStatus(id.split("-")[1],$(ordRoom).attr("roomno"),isFinished);
		     }}
  	    ]}
   ]);
}

function singleCheckedMenu(id,state,stateName)
{
	var ordRoom=$("#rooms-"+id.split("-")[1]);
	var tempStatus = $(ordRoom).attr("tempStatus");
	var tempName = "+增加临时态";
	var isFinished = "";
	if(tempStatus=="0"){
		tempName = "-完成临时态";
		isFinished = "1";
	}	
	context.attach(id, [
  		 {text: '增加消费',action: function(e){
  			 	 addConsume($(ordRoom).attr("orderno"));
	     }},
	     {text: '住客服务',action: function(e){
	    	 addRoomService($(ordRoom).attr("orderno"),id.split("-")[1]);
	     }}, 
  		 {text: '结账', subMenu: [            			
    		     {text: '单房结账',action: function(e){
      		    	checkOut("0",$(ordRoom).attr("orderno"),"",$(ordRoom).attr("roomno"),id.split("-")[1]);
      		     }},
      		     {text: '不结账退房',action: function(e){
      		    	checkOutPX("0",$(ordRoom).attr("orderno"),"",$(ordRoom).attr("roomno"),id.split("-")[1]);
      		     }}
  		 ]},
       	{text: '调整', subMenu: [               		
     		     {text: "房价调整", action: function(e){
     		    	adjustPrice($(ordRoom).attr("orderno"));
     		     }},              			
     		     {text: '换房',action: function(e){
     		    	changeRooms($(ordRoom).attr("orderno"));
     		     }},
     		     {text: '转账',action: function(e){
     		    	ordTransfer($(ordRoom).attr("isUnion"),$(ordRoom).attr("orderno"),$(ordRoom).attr("roomno"),$(ordRoom).attr("memberName"));
     		     }},              			
     		     {text: '续住',action: function(e){
     		    	 addDays($(ordRoom).attr("orderno"),$(ordRoom).attr("rentTimer"),$(ordRoom).attr("channelId"));
     		     }},
     		     {text: '押金',action: function(e){
     		    	 getdDeposit($(ordRoom).attr("orderno"));
     		     }}
     	 ]},
   	  {text: '变更房态',subMenu: [
    		 {text: stateName, action: function(e){
    		    	changeRoomCleanStatus(id.split("-")[1],$(ordRoom).attr("dirty"),$(ordRoom).attr("roomno"));
   		     }},		    
    		 getCheckOutApplyInfo($(ordRoom).attr("orderno"),$(ordRoom).attr("orderno"),$(ordRoom).attr("checkOutStatus"),0)
   	     ]},
   	  {text: '打印',subMenu: [
   	         {text: '打印入住单', action: function(e){
   	        	 window.open("../print/printCheckIn?ordId="+$(ordRoom).attr("orderno")); 
   	         }}
   	     ]},
   	  {divider: true},
   	  {
   		text: '电控', show:top.m_qudian==1, subMenu: [
   			{
   				text: '延长用电时间', action: function(e){
   					top.prolongPowerTime($(ordRoom));
   				}
   			},
   			{
   				text: '房态重传', action: function(e){
   					top.synRoomStateToQD($(ordRoom), false);
   				}
   			}
   		]
   	  },
   	  {text: '其它', subMenu: [
  	    	  {text: "门锁发卡", action: function(e){
	  	    		newCardInit($(ordRoom).attr("lockNo"),$(ordRoom).attr("checkTime"),$(ordRoom).attr("membername"),
		    				$(ordRoom).attr("roomno"),$(ordRoom).attr("roomTypeName")
		    				,$(ordRoom).attr("rentTypeName"),$(ordRoom).attr("days"));
  	    	   }},
  	    	   {text: "门锁清卡", action: function(e){
	  	    	   cleanCardInit($(ordRoom).attr("checkTime"),$(ordRoom).attr("membername"),
		    				$(ordRoom).attr("roomno"),$(ordRoom).attr("roomTypeName")
		    				,$(ordRoom).attr("rentTypeName"),$(ordRoom).attr("days"));
  	    	   }},
  	  	       {text: tempName,action: function(e){
  			    	 newTempStatus(id.split("-")[1],$(ordRoom).attr("roomno"),isFinished);
  			   }}
  	    ]}
      ]);
}