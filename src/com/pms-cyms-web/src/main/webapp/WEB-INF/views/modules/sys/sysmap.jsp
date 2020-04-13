<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>获取地图</title>
	<meta name="decorator" content="default"/>
		<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=bEqdLFnGwGyruHhfeLbT68HZ82abRojH"></script>
		<script src="http://api.map.baidu.com/library/MarkerTool/1.2/src/MarkerTool_min.js" type="text/javascript"></script>
		<script src="${ctxStatic}/jquery/jquery.min.js"></script>
		<script type="text/javascript" src="${ctxStatic}/jquery/jquery.query-object.js"></script>
		
	<style>
			#f_container{border: 1px solid #999999;position: absolute;top:10px;left: 10px;z-index: 1000;    }
			#container{width:250px;overflow: hidden;height: 30px;background:#F2F3F5;border: 5px solid #F2F3F5; }
			#container select{border: 1px solid #ccc;}	
	</style>
		
	<script type="text/javascript">
	var marker = null;
	var map = null;
	var localSearch = null;
	
	$(function(){
		
		// 百度地图API功能
		map = new BMap.Map("allmap");            // 创建Map实例
		//var city = $.query.get("city");
		//var city ="北京市";
		//var keyword = $.query.get("keyword");
		//var keyword = true;
		//if(typeof keyword == "boolean")
		//	keyword="";
		$("#mapKeyword").val('${address}');
		
		//var x = $.query.get("x");
		var x = true;
		if(typeof x == "boolean")x="";
		//var y = $.query.get("y");
		var y = true;
		if(typeof y == "boolean")y="";
		
		map.centerAndZoom('${address}', 13);
		map.enableScrollWheelZoom(true);
		map.addControl(new BMap.ScaleControl({anchor: BMAP_ANCHOR_BOTTOM_RIGHT}));    // 右下比例尺
		map.setDefaultCursor("Crosshair");//鼠标样式
		map.addControl(new BMap.NavigationControl({anchor: BMAP_ANCHOR_TOP_RIGHT}));  //右上角，仅包含平移和缩放按钮
		localSearch = new BMap.LocalSearch(map);
		map.addEventListener("click", markerMe);
		function markerMe(e){
			map.clearOverlays();
			document.getElementById("lng").value = e.point.lng;
			document.getElementById("lat").value = e.point.lat;
			marker = new BMap.Marker(new BMap.Point(e.point.lng, e.point.lat));  // 创建标注
			map.addOverlay(marker);
		}
		
		function markerPoint(x,y){
			map.clearOverlays();
			document.getElementById("lng").value = x;
			document.getElementById("lat").value = y;
			marker = new BMap.Marker(new BMap.Point(x, y));  // 创建标注
			map.addOverlay(marker);
		}
		
		
		
		if(x!="" && y!=""){
			markerPoint(x,y);
		} 
		//else if(keyword!=""){
			searchByKeyword();
		//}
		
			
		});
	
	function searchByKeyword() {
	    map.clearOverlays();//清空原来的标注
	    var keyword = document.getElementById("mapKeyword").value;
	    //alert(keyword);
	    if(keyword!=""){
	    	localSearch.setSearchCompleteCallback(function (searchResult) {
		        var poi = searchResult.getPoi(0);
		        map.centerAndZoom(poi.point, 14);
		      //获取经纬度
				document.getElementById("lng").value = poi.point.lng;
				document.getElementById("lat").value = poi.point.lat;
		        var marker = new BMap.Marker(new BMap.Point(poi.point.lng, poi.point.lat));  // 创建标注，为要查询的地方对应的经纬度
		        map.addOverlay(marker);
		    });
		    localSearch.search(keyword);
	    }
	    
	} 
		
	function chooseMapLocation(){
		var lng = document.getElementById("lng").value;
		var lat = document.getElementById("lat").value;
		if(lng!=""&&lat!=""){
			window.parent.getlatlog(lat,lng);
			window.parent.jBox.close();
		}
	}
		
	function cloasMapDlg(){
		map.clearOverlays();
		document.getElementById("lng").value = '';
		document.getElementById("lat").value = '';
		window.parent.jBox.close();
	}
		
	</script>
</head>
<body>

<div class="content">
			<div id="f_container">
				<div id="container">
					<input id="mapKeyword" name="mapKeyword" type="text" value="${address }" style="width: 180px" />
					<input type="button"  value="查询" onclick="searchByKeyword()"/>
				</div>
			</div>
			<div id="allmap" style="width:490px;height:290px;"></div>
			<div style="margin-top: 15px;text-align: right">
				<input type="hidden" id="lat"><input type="hidden" id="lng">
				<input type="button" onclick="chooseMapLocation()" class="btn" value="确定">
				<input type="button" onclick="cloasMapDlg()" class="btn" value="关闭">
			</div>
</div>
		
	
</body>
</html>