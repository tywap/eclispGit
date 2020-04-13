<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<script type="text/javascript">
var cookValuesTemp = '${cookValuesTemp}';
var foodCfg=${foodCfgList};
	$(document).ready(function(){
		load();
		$("#button").click(function() {
			addModus();
		});
	});
	var jbox = $(document).height()-180;
	$('.room').height(jbox/2);
	var str='${str }'.split(',');
	function load() {
		//加载时调用
		$.ajax({
	        url:"${ctx}/setting/ctFood/getModus",
	        type: "post",
	        dataType: "json",
	        data: {},
	        success: function (result) {
			if(result.retCode == '000000'){
				var data=result.ret;
				var mapListHtm="";
				var mapListHtm1="";
				$.each(data, function (key, value) {
					var boole=true;
					mapListHtm+="<ul>";
					mapListHtm1+="<ul>";
					for (var i = 0; i < value.length; i++) {
						if (foodCfg != '') {
							for (var k = 0; k < foodCfg.length; k++) {
								if (value[i].id == foodCfg[k].value) {
									boole=false;
									mapListHtm+= "<li class='active' title='"+value[i].name+"' id= '"+value[i].id+"'>"+
									"<span class='"+value[i].id+"' name='roomNo'></span><br />"+
									"<span>"+value[i].name+"</span>"+
								    "</li>";
									break;
								}else {
									boole=true;
								}
							}
						}
						if (boole) {
							mapListHtm1+= "<li title='"+value[i].name+"' id= '"+value[i].id+"'>"+
							"<span class='"+value[i].id+"' name='roomNo'></span><br />"+
							"<span>"+value[i].name+"</span>"+
						    "</li>";
						}
					}
					mapListHtm+="</ul>";
					mapListHtm1+="</ul>";
				});
				mapListHtm+="<ul id='definedModus'>";
				mapListHtm1+="<ul id='definedModus'>";
				 if (cookValuesTemp != '') {
					 var arr = cookValuesTemp.split(",");
					 for (var i = 0; i < arr.length; i++) {
						    mapListHtm+="<li class='active1' title='"+arr[i]+"' onclick='roomClick1(this);'>"+
							"<span name='roomNo'></span><br />"+
							"<span>"+arr[i]+"</span>"+
						    "</li>";
						}
				 }
				mapListHtm+="</ul>";
				$('#system').html(mapListHtm);
				$('#rests').html(mapListHtm1);
				$('.accomplish-select span i').html($('.room ul li.active').length);
				//鼠标按下拖动时
				var up = false,activeList=[],firstTime=0,lastTime=0;
				//按下鼠标时 改变状态值
				$('.this-area-room ul li').mousedown(function(){
						activeList = [];
						firstTime = new Date().getTime();
					    up = true;
			    });
				//鼠标移动时 
				$('.this-area-room ul li').mousemove(function(){
				    if(up){
					   activeList.push($(this).find('span[name=roomNo]').eq(0).html());
				    }
			    })
			    //鼠标抬起时
			    $('.this-area-room ul li').mouseup(function(){
			       up = false;
			 	   lastTime = new Date().getTime();
			 	   if((lastTime - firstTime) > 200 ){
			 		   $.unique(activeList); 
			 		   var starNum = 0,endNum = 0,res = [];
			 		   for(var i=0;i<activeList.length;i++){
			 			    if(activeList.length != 1){	
			 						if(res.indexOf(activeList[i]) == -1){
			 							res.push(activeList[i]);
			 							res.sort();
			 						} 
			 				}
			 		    }
			 	  		for(var j=0;j<$('.this-area-room ul li').length;j++){
							var roomNo = $('.this-area-room ul li').eq(j).find('span[name=roomNo]').html();
							res[0] == roomNo?starNum = j:'';
							res[res.length-1] == roomNo?endNum = j:'';
			 	  		}
			 	  		for(var m = starNum;m<endNum+1;m++){
			 				$('ul li').eq(m).hasClass('active')?$('.this-area-room ul li').eq(m).removeClass('active'):$('.this-area-room ul li').eq(m).addClass('active');
			 		    }
			 	    }  
			   })
				
				$('.room ul li').click(function(){
					roomClick(this);
				});
				
				$('#definedModus li').click(function(){
					roomClick(this);
				});
				
				//checkbox 状态改变时：
				$('#roomBox').change(function(){	
					checkboxRoom(this)
				})
				//checkbox 状态改变时：
				$('#otherRoom').change(function(){	
					checkboxRoom(this)
				})
			}
				
	    }
	});
	}
	function roomClick(_this){
		if($(_this).hasClass('active')){
			$(_this).removeClass('active');
		}else{
			$(_this).addClass('active');
		}
		$('.accomplish-select span i').html($('.room ul li.active').length);
	}
	
	function roomClick1(_this){
		if($(_this).hasClass('active1')){
			$(_this).removeClass('active1');
		}else{
			$(_this).addClass('active1');
		}
		$('.accomplish-select span i').html($('.room ul li.active1').length);
	}
	
	//添加自定义做法
	function addModus() {
	    var foodModus = $("#foodModus").val();
	    if (foodModus != '') {
	    	definedModus="<li class='active1' title='"+foodModus+"' onclick='roomClick1(this);'>"+
			"<span name='roomNo'></span><br />"+
			"<span>"+foodModus+"</span>"+
		    "</li>";
		    $('#definedModus').append(definedModus);
		}else {
			layer.alert("请先填写做法再添加！");
		}
	}
	
/* 	//加载自定义做法
	function loadModus(cookValuesTemp) {
	    if (cookValuesTemp != '') {
	    	var definedModus="";
	    	var arr = cookValuesTemp.split(",");
	    	for (var i = 0; i < arr.length; i++) {
	    		definedModus+="<li class='active1' title='"+arr[i]+"' onclick='roomClick1(this);'>"+
				"<span name='roomNo'></span><br />"+
				"<span>"+arr[i]+"</span>"+
			    "</li>";
			}
	    	document.getElementById("definedModus").innerHTML = definedModus;
		    $('#definedModus').html(definedModus); 
		}
	} */
	
</script>
<style>
		.border-content{
			position: relative;
			margin-top: 10px;
		}
		.border-content .title{
			position: absolute;
			top: -10px;
			left: 10px;
			padding: 0 10px 0 5px;
			background-color: #fff;
		}
		.border-content .title p{
			display: inline-block;
		    margin: 0;
		    margin-right: 10px;
	    }
		.border-content div.room,.border-content div.rooms{
			padding: 10px 15px;
			height: 325px;
			overflow: auto;
			border: 1px solid #ccc;
		}
		ul{margin: 0; overflow:hidden;}
		ul li{
			list-style: none;
			float:left;
			margin: 0 10px 10px 0;
			height:50px;
			width:100px;
			color: #fff;
			background-color: #009BDB;
			cursor: pointer;
			text-align: center;
			line-height: 18px;
		}
		ul li span:first-child{
		    display: inline-block;
   			margin-top: 10px;
		}
		ul li span:last-child{
			display: inline-block;
    		transform: scale(0.85);
    		width: 50px;
		    overflow: hidden;
		    text-overflow: ellipsis;
		    white-space: nowrap;
		}
		ul li.active{
			background-color: #E73962;
		}
		ul li.active1{
			background-color: #E73962;
		}
		.accomplish-select{
		    position: absolute;
		    margin: 0;
		    top: 12px;
		    color: 009BDB;
		}
		.accomplish-select span{
			color: #E73962;
			margin-left: 5px;
		}
		.accomplish-select span i{
		    font-style: normal;
		}
		select:focus{
			outline: none;
		}
		.selected-room{
			margin-left: 5px;
		}
</style>
<div class="rests-area-room border-content" style="margin-top: 14px; margin-left: 10px;">
	<hr>
	<div class="room" id='room'>
	<span>菜品默认做法：</span>
	<table id="system"></table>
	<span>其他可选做法：</span>	
	<table id="rests"></table>
	</div>
	
</div>
<div class="search" style="padding: 10px 15px;">
	<div class="input">		
	    <span>自定义做法：</span>		
		<input type="text" id="foodModus" value="" class="input-medium6" placeholder="自定义添加做法" style="width: 200px;"/>
		<input type="button"  id="button" class="btn btn-primary"  value="添 加" style="margin-top: -10px;"/>
	</div>
</div>
