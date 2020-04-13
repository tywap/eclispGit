<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		//新增行
		$("#addRowBtn").click(function(e){
			addRow();
		});
		$("a[name='delCardBtn']").click(function(e){
			var id=$(this).data("id");
			$("#row"+id).remove();
		});
	});
	
	function addRow(){
		var count = $('#certsDiv').children('.certs').length+1;
		var certTypeModel = $("#certTypeModel").html();
		var html = ""+
		"<tr class='certs' id='row"+count+"'>"+
			"<td>"+
				"<select name='certType' class='required'>"+
					certTypeModel+
				"</select>"+
			"</td>"+
			"<td>"+
				"<input type='text' name='certId' class='required' onblur='validCert(this);'/>"+
			"</td>"+
			"<td>"+
				"<input type='text' name='cardAddress' class=''/>"+
			"</td>"+
			"<td style='text-align:center;'>"+
				"<a name='delCardBtn' data-id='"+count+"'>删除</a>"+
			"</td>"+
		"</tr>";
		$("#certsDiv").append(html);
		
		$("a[name='delCardBtn']").click(function(e){
			var id=$(this).data("id");
			$("#row"+id).remove();
		});
	}
	
	//校验证件号
	function validCert(obj){
		var certId = $(obj).val().trim();
		var certType = $(obj).parent().parent().find("select[name='certType']").val();
		if(certId==""){
			return;
		}
		if(certType=='1'&&!checkIdcard(certId)){
			$.jBox.confirm("身份证号码有误！", "提示", function (v, h, f) {
			    if (v == true){
			    	$(obj).val("");
			    }
			    return true;
			}, { buttons: { '确定': true}});
			return;
		}
		var id="";
		if(editFlag=='edit'){
			id='${cmMember.id}';
		}
		params = {id:id,certType:certType,certId:certId};
		loadAjax("${ctx}/member/cmMemberValid/validCert",params,function(result){
			if(result.retCode=="000000"){
    			var count = result.ret.count;
	    		if(count==0){
	    			
	    		}else if(count>0){
	    			$.jBox.confirm("该证件号已注册！", "提示", function (v, h, f) {
					    if (v == true){
					    	$(obj).val("");
					    }
					    return true;
					}, { buttons: { '确定': true}});
					return;
	    		}
    	    }else{
    			$.jBox.alert(result.retMsg);
    	    }
		});
	}
	
	//会员证件信息
	function getCert(){
		var certs = $(".certs");
		var arr = [];
		var certTypes = [];
		if(certs.length==0){
			$.jBox.alert("会员至少填写一种证件！");
			return;
		}
		for(var i=0;i<certs.length;i++){
			var id = $(certs[i]).find("input[name='cid']").val();
			var certType =  $(certs[i]).find("select[name='certType']").val();
			if(certTypes.indexOf(certType)>=0){
				$.jBox.alert("证件类型重复！");
				return;
			}else{
				certTypes.push(certType);
			}
			var certId = $(certs[i]).find("input[name='certId']").val();
			if(certId==""){
				$.jBox.alert("证件号码不能为空！");
				return;
			}
			var address = $(certs[i]).find("input[name='cardAddress']").val();
			var temp ={id:id,certId:certId,certType:certType,address:address};
			arr.push(temp);
		}
		var certObj = {certs:arr};
		return certObj;
	}
</script>
<div>
	<div class="row">
		<table class="table table-bordered table-condensed">
			<div style="display:none">
				<select id="certTypeModel" name="certType" class="input-mini">
				    <c:forEach items="${fns:getDictList('certType')}" var="var" varStatus="vs">
                         <option value="${var.value}"> ${var.label}</option>
                     </c:forEach>
				</select>
			</div>
			<colgroup>
				<col width="30%"/>
				<col width="30%"/>
				<col width="30%"/>
				<col width="10%"/>
			</colgroup>
			<tr>
				<th>证件类型</th>
				<th>证件号码</th>
				<th>地址</th>
				<th>操作</th>
			</tr>
			<tbody id="certsDiv">
				<c:forEach var="cert" items="${cmMember.certs}" varStatus="status">
					<tr class='certs' id='row${status.count}'>
						<input type="hidden" name="cid" value="${cert.id}">
						<td>
							<select name="certType" class="required">
								 <c:forEach items="${fns:getDictList('certType')}" var="var" varStatus="vs">
								 	<c:choose>
								 		<c:when test="${(var.value).equals(cert.certType)}">
								 			<option value="${var.value}" selected="selected"> ${var.label}</option>
								 		</c:when>
								 		<c:otherwise>
								 			 <option value="${var.value}"> ${var.label}</option>
								 		</c:otherwise>
								 	</c:choose>
	                            </c:forEach>
							</select>
						</td>
						<td>
							<input type='text' name="certId" value="${cert.certId}" class='required' onblur='validCert(this);'/>
						</td>
						<td>
							<input type='text' name="cardAddress" value="${cert.address}"  class=""/>
						</td>
						<td style='text-align:center;'>
							<a name='delCardBtn' data-id='${status.count}'>删除</a>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<div style="text-align:right;"><input id="addRowBtn" class="btn btn-primary" type="button" value="新增"/></div>
	</div>
</div>

