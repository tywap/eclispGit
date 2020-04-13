package com.jinchuan.pms.cyms.modules.order.web;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.jinchuan.pms.cyms.modules.order.dto.OrdTableDto;
import com.jinchuan.pms.cyms.modules.order.entity.OrdTable;
import com.jinchuan.pms.cyms.modules.order.service.OrdTableService;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.utils.DateUtils;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.entity.User;

@Controller
@RequestMapping("${adminPath}/order/ordTable")
public class OrdTableController extends BaseController {
	@Autowired
	private OrdTableService ordTableService;

	/**
	 * 查询订单信息
	 * @Title: getOrdTableById
	 * @return_type: ProcessResult
	 */
	@RequestMapping("getOrdTableById")
	@ResponseBody
	public ProcessResult getOrdTableById(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String orderId = request.getParameter("orderId");
			OrdTable ordTable = ordTableService.get(orderId);
			Map<String, Object> ret = new HashMap<String, Object>();
			ret.put("ordTable", ordTable);
			result = new ProcessResult("000000", "操作成功", ret);
		} catch (Exception e) {
			result.setRetMsg(e.getMessage());
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 修改备注
	 * @Title: updateOrderInfo
	 * @return_type: ProcessResult
	 */
	@RequestMapping("updateOrderInfo")
	@ResponseBody
	public ProcessResult updateOrderInfo(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String orderId = request.getParameter("orderId");
			String remarks = request.getParameter("remarks");
			String tableNo = request.getParameter("tableNo");//台号ID
			String useNum = request.getParameter("useNum");//用餐人数
			Date createDate = DateUtils.parseDate(request.getParameter("createDate"));//开台时间
			Date settleDate = DateUtils.parseDate(request.getParameter("settleDate"));//结束时间sourceId
			String sourceId = request.getParameter("sourceId");//客源ID
			String memberName = request.getParameter("memberName");//联系人memberPhone33
			String memberPhone = request.getParameter("memberPhone");//联系人电话
			String salesman = request.getParameter("salesman");//业务员
			String thirdPartName = request.getParameter("thirdPartName");//第三方单号
			
			/*OrdTable ordTable=new OrdTable();*/
			User u=new User();
			u.setId(salesman);
			OrdTable ordTable=ordTableService.getAndLock(orderId);
			ordTable.setRemarks(remarks);
			ordTable.setTableNo(tableNo);
			ordTable.setUseNum(useNum);
			ordTable.setCreateDate(createDate);
			ordTable.setSettleDate(settleDate);
			ordTable.setSource(sourceId);
			ordTable.setMemberName(memberName);
			ordTable.setMemberPhone(memberPhone);
			ordTable.setSalesman(u);
			ordTable.setThirdPartName(thirdPartName);
			
			ordTableService.upTableStatus(ordTable);
			/*ordTableService.updateOrderRemarks(orderId, remarks);*/
			result.setRetCode("000000");
			result.setRetMsg("操作成功");
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
			return result;
		}
		return result;
	}
}
