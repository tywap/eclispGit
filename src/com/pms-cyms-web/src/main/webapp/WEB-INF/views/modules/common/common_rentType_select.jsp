<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<script type="text/javascript">
	//*******************************************事件区******************************************************************
	$(document).ready(function() {
	});
	//*******************************************函数区******************************************************************
	//酒店checkbox控件
	function loadRentTypeCheckbox(div,url,params,defaultValue,checkboxName,paramId,paramName){
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
			    var htm="<label  style='display:inline-block;min-width:80px;'><input type='checkbox' id='allRent' name='allRent'/>全选</label>";
			    if(typeof(lists)!="undefined"&&lists.length>0){
					for(var i=0;i<lists.length;i++){
				        htm += "<label style='display:inline-block;min-width:80px;'>"+
				        "<input type='checkbox' class='rentTypecheckBoxItem' name='"+checkboxName+"' value='"+lists[i][paramId]+"'/>"+lists[i][paramName]+
				        "</label>";
			   	    }
			    }
			    $(id).append(htm);
			    
			    //添加全选事件
			    $("#allRent").click(function(){
			    	if($(this).is(':checked')){
			    		$("[name='"+checkboxName+"']").attr("checked",'true');//全选     
			    	}else{
			    		$("[name='"+checkboxName+"']").removeAttr("checked");//取消全选     
			    	}
			    });
			    $(".checkBoxItem").click(function(){
			    	if($(this).is(':checked')){
			    	}else{
			    		$("#allRent").removeAttr("checked");//取消全选     
			    	}
			    });
			    //初始化
			    if(defaultValue!=null && defaultValue!= ""){
			    	var array = JSON.parse(defaultValue);
				    for(var i=0;i<array.length;i++){
				    	var temp = array[i];
						$("[class='rentTypecheckBoxItem'][value='"+temp+"']").attr("checked",'true');
					}
			    }
			},
			error: function (result, status) {
		    	$.jBox.alert("系统错误");
			}
		});
	}
</script>
<div class="row">
	<div class="span12">
		<div class="control-group">
			<label class="control-label-xs">租类：</label>
			<div class="controls">
				<div id="rentTypeDiv"></div>
			</div>
		</div>
	</div>
</div>