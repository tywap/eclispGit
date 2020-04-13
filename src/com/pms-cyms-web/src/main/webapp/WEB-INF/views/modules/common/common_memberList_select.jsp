<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>第三方搜索</title>
	<meta name="decorator" content="default"/>
	<script src="${ctxStatic}/common/date.js" type="text/javascript"> </script>
	<script type="text/javascript">
	
		//查询
		function query(){
			var storeId = '${param.storeId}';
			var quickField = $("#quickField").val();
			if(quickField==""){
				$.jBox.alert("请输入查询条件");
				return;
			}
			var dateNow=new Date().Format("yyyy-MM-dd");
			var params = {storeId:storeId,queryValue:quickField};
			loadAjax("${ctx}/member/member/getMemberList",params,function(result){
				if(result.retCode=="000000"){
					var list = result.ret.list;
					var html = "";
					if(list.length==0){
						html="<tr><td colspan='7'  style='text-align:center;'>无数据</td></tr>";
					}
					for(var i=0;i<list.length;i++){
						var obj = list[i];
						var htmlTemp = 
							"<tr'>"+
								"<td style='text-align:center;'><input type='radio' name='itemCheckBoxBtn'/></td>"+
								"<td>"+obj.memberName+"</td>"+
								"<td>"+obj.accountNo+"</td>"+
								"<td>"+obj.cardTypeName+"</td>"+
								"<td>"+obj.accMoney+"</td>"+
								"<td>"+obj.accScore+"</td>"+
								"<td>"+obj.phone+"</td>"+
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
				id:$(".selectedTr").find("td").eq(7).html(),
				name:$(".selectedTr").find("td").eq(1).html(),
				type:$(".selectedTr").find("td").eq(3).html(),
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
		                <input type="text" id="quickField" style="width:180px;" placeholder="卡号、身份证号、手机号"/>
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
						<th>姓名</th>
						<th>会员卡号</th>
						<th>会员类别</th>
						<th>当前余额</th>
						<th>当前积分</th>
						<th>联系电话</th>
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

