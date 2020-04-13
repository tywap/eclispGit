package com.jinchuan.pms.cyms.modules.order.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.jinchuan.pms.cyms.modules.order.service.OrdTableConsumeItemService;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.web.BaseController;

@Controller
@RequestMapping("${adminPath}/order/ordTableConsumeItem")
public class OrdTableConsumeItemController extends BaseController {
	@Autowired
	private OrdTableConsumeItemService ordTableConsumeItemService;

	/**
	 * @Title: getConsumesByOrderId  
	 * @Description:获取费用明细
	 * @param request
	 * @param response
	 * @param model
	 * @return ProcessResult 
	 * @throws
	 */
	@RequestMapping("getConsumesByOrderId")
	@ResponseBody
	public ProcessResult getConsumesByOrderId(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String orderId = request.getParameter("orderId");
			String settleStatus = "";
			List<Map<String, Object>> list = ordTableConsumeItemService.getConsumeItemsDetail(orderId, settleStatus);
			Map<String, Object> ret = new HashMap<String, Object>();
			ret.put("list", list);
			result = new ProcessResult("000000", "操作成功", ret);
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

}
