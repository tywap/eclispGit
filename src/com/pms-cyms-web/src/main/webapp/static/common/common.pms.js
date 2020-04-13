//********************************************ajax 数据请求********************************************
function loadAjax(url,paramsJson,func,func2){
	layer.load();
	$.ajax({
		url:url,
        type: "post",
        dataType: "json",
        //async:false,
        data: paramsJson,
        success: function (result) {
        	layer.closeAll("loading");
    	    if(func!=undefined && func!=null){
    		    func(result);
    	    }
  		 },
		 error: function (result, status) {
			 layer.closeAll("loading");
	    	 if(func2!=undefined && func2!=null){
	    		 func2();
	    	 }else{
	    		 $.jBox.alert("系统错误");
	    	 }
		 }
	});
}
//********************************************ajax下拉框控件 ********************************************
function loadSelect(div,url,params,defaultValue,paramId,paramName,func){
	var id = "#" + div;
	$.ajax({
		url:url,
        type: "post",
        dataType: "json",
        data: params,
        success: function (result) {
        	var lists = result.ret.lists;
    	    $(id).empty();
    	    var htm="<option value=''>--请选择--</option>";
    	    if(typeof(lists)!="undefined" && lists.length>0){
    		    for(var i=0;i<lists.length;i++){
    			    var jsonStr = JSON.stringify(lists[i]);
    			    // var obj = JSON.parse(jsonStr);或者var obj = eval(lists[i]);
    			    htm += "<option value='"+lists[i][paramId]+"'jsonStr='"+jsonStr+"'>"+lists[i][paramName]+"</option>";
    		    }
    	    }
    	    $(id).append(htm);
    	    //$(id).select2('val',defaultValue);
    	    $(id).val(defaultValue);
    	    if(func!=undefined && func!=null){
    		    func($(id));
    	    }
  		 },
		 error: function (result, status) {
	    	$.jBox.alert("系统错误");
		 }
	});
}
//********************************************文件上传控件********************************************
/**
 * 上传文件(单个)
 * url:上传初始路径
 * eventName:界面注册事件，用于回调
 * divId:图片div
 * isCover:是否覆盖div的图片
 * inputName:图片input框名称
 */
function fileUpload(url,eventName,divId,isCover,inputName){
	var mulFlag = "0";
	fileMulUpload(url,eventName,divId,isCover,inputName,mulFlag);
}
/**
 * 上传文件(批量)
 * url:上传初始路径
 * eventName:界面注册事件，用于回调
 * divId:图片div
 * isCover:是否覆盖div的图片
 * inputName:图片input框名称
 */
function fileMulUpload(url,eventName,divId,isCover,inputName,mulFlag){
	if(divId==null || divId==""){
		$.jBox.alert("请输入图片div");
		return;
	}
	if(inputName==null || inputName==""){
		$.jBox.alert("请输入图片input");
		return;
	}
	top.$.jBox.open(
        "iframe:"+url+"?eventName="+eventName+"&divId="+divId+"&inputName="+inputName+"&isCover="+isCover+"&mulFlag="+mulFlag,
        "文件上传",
        380,
        180,
        {
            buttons: {},
            loaded: function (h) {
                $(".jbox-content", top.document).css("overflow-y", "hidden");
            },
            closed:function (){
            	var fileUploadParamsJson = cookie("fileUploadParams");
            	var fileUploadParams = JSON.parse(fileUploadParamsJson);
            	fileDownload(fileUploadParams.url,fileUploadParams.divId,fileUploadParams.isCover,fileUploadParams.inputName,fileUploadParams.filePath);
            }
        }
    );
}
/**
 * 下载文件
 * url:下载路径
 * divId:图片div
 * isCover:是否覆盖div的图片
 * inputName:图片input框名称
 * filePath:文件服务器存放路径
 */
function fileDownload(url,divId,isCover,inputName,filePath){
	if(isCover=="1"){
		$("#"+divId+"").empty();//是否覆盖前一图片
	}
	var files = JSON.parse(filePath);
	for(var i=0;i<files.length;i++){
		var file = files[i];
		var fileName = file.fileName;
		var filePath = file.filePath;
		$("#"+divId+"").append(
			"<span style='margin:10px;display:inline-block;width:160px;height:180px;position: relative;'>"+
				"<img style='float:left;width:160px;height:160px;' src='"+filePath+"' title='"+fileName+"'/>"+
				"<font style='float:left;width:160px;height:20px;text-align:center;'  >"+fileName+"</font>"+
				"<i class='icon-trash' style='float:right;z-index:999;position:absolute;top:0px;right:0px;background:#333;color:#fff;padding:5px;' onclick='this.parentNode.parentNode.removeChild(this.parentNode);'></i>"+
			"</span>"
		);
	}
}
//获取图片数组
function getFiles(inputName){
	var picArray = [];
	var array =  $("[name='"+inputName+"']");
	if(array.length==0){
		$.jBox.alert("请上传图片！");
		return;
	}
	for(var i=0;i<array.length;i++){
		var obj = array[i];
		var p = {picPath:$(obj).val()};
		picArray.push(p);
	}
	return picArray;
}

//********************************************业务校验函数********************************************
//校验手机号
function validPhone(url,obj,memberId){
	var recommenderPhone = $(obj).val().trim();
	if(recommenderPhone==""){
		return;
	}
	params = {id:memberId,phone:recommenderPhone};
	loadAjax(url,params,function(result){
		if(result.retCode=="000000"){
			var count = result.ret.count;
    		if(count==0){
    			
    		}else if(count>0){
    			layer.confirm("该手机号已注册", {
  				  btn: ['确定'] 
  				}, function(index){
  					$(obj).val("");
  					layer.close(index);
  				}, function(){
  					return ;
  				});
    		}
	    }else{
			$.jBox.alert(result.retMsg);
	    }
	});			
}
//数量校验
function validDigist(obj){
	if(!(/^(\-|\+)?\d+(\.\d+)?$/.test($(obj).val()))){
		$(obj).val('');
		return false;
	}
	if($(obj).val()==""||$(obj).val()==0){
		$(obj).val('');
		return false;
	}
	return true;
}
//阻止事件
function stopBubbling(e) {
    e = window.event || e;
    if (e.stopPropagation) {
        e.stopPropagation();      //阻止事件 冒泡传播
    } else {
        e.cancelBubble = true;   //ie兼容
    }
}
