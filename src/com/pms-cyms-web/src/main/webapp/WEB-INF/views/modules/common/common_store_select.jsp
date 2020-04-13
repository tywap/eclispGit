<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<script type="text/javascript">
	//*******************************************事件区******************************************************************
	$(document).ready(function() {
	});
	//*******************************************函数区******************************************************************
	//酒店checkbox控件
	function loadCheckbox(div,url,params,defaultValue,checkboxName,paramId,paramName){
		var id = "#" + div;
		$.ajax({
			url:url,
	        type: "post",
	        dataType: "json",
	        data: params,
	        success: function (result) {
				var lists = result.ret.lists;
				//var lists = result;
			    $(id).empty();
			    var htm="<label><input type='checkbox' id='allStore' name='allStore'/>餐厅通用</label>&nbsp;&nbsp;"+
			    		"<input type='text' id='quickField' class='input-medium6'/>&nbsp;"+
			    		"<input type='button' onclick='storeQueryBtn();' class='btn btn-primary' value='查询'/>"+
			    		"<br/>";
			    if(typeof(lists)!="undefined"&&lists.length>0){
					for(var i=0;i<lists.length;i++){
						if(paramName=="foodTyepStore"){
							 htm += "<label style='display:inline-block;width:130px;'>"+
						        "<input type='checkbox' class='checkBoxItem' name='"+checkboxName+"' value='"+lists[i].id+"'/><span>"+lists[i].storeName+
						        "</label></span>";
						}else{
							htm += "<label style='display:inline-block;width:130px;'>"+
						        "<input type='checkbox' class='checkBoxItem' name='"+checkboxName+"' value='"+lists[i][paramId]+"'/><span>"+lists[i][paramName]+
						        "</label></span>";
						}
			   	    }
			    }
			    $(id).append(htm);
			    
			    //添加全选事件
				$('#quickField').bind('keyup', function(event) {
					if (event.keyCode == "13") {
						storeQueryBtn();
					}
				});
			    $("#allStore").click(function(){
			    	if($(this).is(':checked')){
			    		$("[name='"+checkboxName+"']").attr("checked",'true');//全选     
			    	}else{
			    		$("[name='"+checkboxName+"']").removeAttr("checked");//取消全选     
			    	}
			    });
			    $(".checkBoxItem").click(function(){
			    	if($(this).is(':checked')){
			    	}else{
			    		$("#allStore").removeAttr("checked");//取消全选     
			    	}
			    });
			    //初始化
			    //scopeTypeChange();
			    if(defaultValue!=null && defaultValue!= ""){
			    	var array = JSON.parse(defaultValue);
			    	if(array!=null){
					    for(var i=0;i<array.length;i++){
					    	var temp = array[i].storeId;
							$("[class='checkBoxItem'][value='"+temp+"']").attr("checked",'true');
						}
			    	}
			    }
			},
			error: function (result, status) {
		    	$.jBox.alert("系统错误");
			}
		});
	}
	//查询酒店
	function storeQueryBtn(){
		var quickField = $("#quickField").val();
		var stores=[];
		var cks = $("[name='storeId']");
		$(cks).parent().find("span").css("background", "");
		for(var i=0;i<cks.length;i++){
			var sp = $(cks[i]).parent().find("span");
			var name = sp.html();
			if(name.indexOf(quickField)!=-1){
				sp.css("background", "#FF9900");	
			}
		}
	}
	//是否指定酒店
	function scopeTypeChange(){
		var scopeType = $("#scopeType").val();
		if(scopeType=="1"){
			$("#companyDiv").css("display","none");
		}else{
			$("#companyDiv").css("display","block");
		}
	}
</script>
<div class="row">
	<div class="span6" style="width:auto;">
		<div class="form-group">
           	<label class="control-label-xs">分店：</label>
           	<div class="controls">
           		<div id="companyCheckDiv"></div>
             </div>
       	</div>
	</div>
</div>