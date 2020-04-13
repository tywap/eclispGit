<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>菜品图片上传</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		 var eventName="foodImgUpload";
		 
		top.$.unsubscribe(eventName);
	    //注册事件，弹出页面需要刷新本页面，或者弹出页面回传数据用
	    top.$.subscribe(eventName, function (e, data) {
	        //data  可以通过这个对象来回传数据
	        $("#searchForm").submit();
	    });
		function uploadImg() {
			fileMulUpload("${ctx}/upload/fileUploadInit","foodImgUpload","imgShow","0","logoPicPath","1");
		}
		function save() {
			var imgList=document.getElementById('imgShow').getElementsByTagName('img');
			if (imgList!=null) {
				var fileName=[];
				var fileUrl=[];
				for (var i = 0; i < imgList.length; i++) {
					fileName.push(imgList[i].title);
					fileUrl.push(imgList[i].src);
				}
				var params={fileName:fileName.join(','),fileUrl:fileUrl.join(',')};
    			loadAjax("${ctx}/ota/foodImgMaintain/saveFoodImg", params, function(result) {
    				if (result.retCode == "000000") {
    					layer.confirm('保存成功', {
    						btn: ['确定']
    					}, function(){
    						top.$.publish("foodImgMaintain",{eventName:"holle"});
    						window.parent.jBox.close();
    					}, function(){
    						window.parent.jBox.close();
    					});
    				} else {
    					layer.alert(result.retMsg);
    				}
    			});
			}else {
				layer.alert("请先上传图片");
				return;
			}
		}
	</script>
</head>
<body>
<span>菜品图片展示</span>
	<div id="imgShow">
	</div>
	<div class="fixed-btn-right">
	<input id="submitBtn" class="btn btn-primary" type="button"
				value="上 传" onclick="uploadImg();">&nbsp;
			<input id="submitBtn" class="btn btn-primary" type="button"
				value="保 存" onclick="save()">&nbsp;
		</div>
</body>
</html>