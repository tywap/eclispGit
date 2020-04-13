<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>第三方搜索</title>
	<meta name="decorator" content="default"/>
	<script src="${ctxStatic}/common/date.js" type="text/javascript"> </script>
	<script type="text/javascript">
	
		//查询协议单位
		function query(){
			var storeId = '${param.storeId}';
			var quickField = $("#quickField").val();
			if(quickField==""){
				$.jBox.alert("请输入查询条件");
				return;
			}
			var params = {storeId:storeId,queryValue:quickField};
			loadAjax("${ctx}/member/group/getGroupList",params,function(result){
				if(result.retCode=="000000"){
					var list = result.ret.list;
					var html = "";
					if(list.length==0){
						html="<tr><td colspan='8'  style='text-align:center;'>无数据</td></tr>";
					}
					for(var i=0;i<list.length;i++){
						var obj = list[i];
						var htmlTemp = 
							"<tr'>"+
								"<td style='text-align:center;'><input type='radio' name='itemCheckBoxBtn'/></td>"+
								"<td>"+obj.agreementCode+"</td>"+
								"<td>"+obj.name+"</td>"+
								"<td>"+obj.linkMan+"</td>"+
								"<td>"+obj.phone+"</td>"+
								"<td>"+obj.userName+"</td>"+
								"<td>"+(obj.userPhone==undefined?'':obj.userPhone)+"</td>"+
								"<td>"+obj.officeName+"</td>"+
								"<td style='display:none'>"+obj.groupType+"</td>"+
								"<td style='display:none'>"+obj.id+"</td>"+
							"</tr>";
						html += htmlTemp;
					}
					$("#tableBody").empty();
					$("#tableBody").append(html);
					
					//表格单选
					$('#tableBody tr').click(function(){
						tableSelected(this);
						selectedThisTr(this);
					});
				}else{
					$.jBox.alert(result.retMsg);
				}
			});
		}
		
		function selectedThisTr(obj){
			$("tr").removeClass("selectedTr");
			$(obj).addClass("selectedTr");
		}
		
		//提交		
		function confirm(){
			top.$.publish("checkIn",{
				id:$(".selectedTr").find("td").eq(9).html(),
				name:$(".selectedTr").find("td").eq(2).html(),
				type:$(".selectedTr").find("td").eq(8).html()
			});
			parent.window.jBox.close(); 
		}
	</script>
	<style>
	.selectedTr{background-color: #DEF5E3}
	</style>
</head>
<body>
	<form:form id="inputForm" action=" " method="post" class="form-horizontal">
		<div class="row">
			<div class="span" >
		        <div class="control-group">
		            <label class="control-label-xs"><span class="notice">*</span>查询条件：</label>
		            <div class="controls">
		                <input type="text" id="quickField" style="width:180px;" placeholder="协议单位号、联系方式、协议单位名称"/>
		                <input type="button" class="btn btn-primary" onclick="query()" value="查询" />
		            </div>
		        </div>
		    </div>
		</div>    
		<div class="row">
			<table id="contentTable" class="table table-striped table-bordered table-condensed" style="width:100%;">
				<thead>
					<tr>
						<th></th>
						<th>编号</th>
						<th>协议单位名称</th>
						<th>联系人</th>
						<th>联系电话</th>
						<th>业务员</th>
						<th>业务员电话</th>
						<th>归属酒店</th>
					</tr>
				</thead>
				<tbody id="tableBody">
				</tbody>
			</table>
		</div>
		<div class="fixed-btn-right" style="padding:8px 5px;">
	        <input class="btn btn-primary" onclick="confirm()" type="button" value="确定" />
	    </div>
	</form:form>
</body>

