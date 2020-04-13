package com.jinchuan.pms.cyms.modules.order.web;

import java.util.ArrayList;
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

import com.jinchuan.pms.cyms.modules.order.entity.OrdPaymentFund;
import com.jinchuan.pms.cyms.modules.order.service.OrdPaymentFundService;
import com.jinchuan.pms.pay.model.PayRefundVo;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.utils.StringUtils;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

@Controller
@RequestMapping("${adminPath}/order/ordPaymentFund")
public class OrdPaymentFundController extends BaseController {
	@Autowired
	private OrdPaymentFundService ordPaymentFundService;

	/**
	 * 获取支付明细
	 * @Title: getPaymentFundsByOrderId  
	 * @param request
	 * @param response
	 * @param model
	 * @return ProcessResult 
	 * @throws
	 */
	@RequestMapping("getPaymentFundsByOrderId")
	@ResponseBody
	public ProcessResult getPaymentFundsByOrderId(HttpServletRequest request, HttpServletResponse response,
			Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String rentId = UserUtils.getUser().getRentId();
			String orderId = request.getParameter("orderId");
			String titleNo = null;
			String status = "1";
			String startDate = null;
			String endDate = null;

			List<OrdPaymentFund> list = ordPaymentFundService.getOrdPaymentFundListByRoomOrdId(rentId, titleNo, status,
					orderId, startDate, endDate);
			Map<String, Object> ret = new HashMap<String, Object>();
			ret.put("list", list);
			result = new ProcessResult("000000", "操作成功", ret);
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

	/**
	 * 获取可退款明细
	 * @Title: getPayRefundVoListByBusiId  
	 * @param @param request
	 * @param @param response
	 * @param @param model
	 * @param @return 
	 * @return ProcessResult 
	 * @throws
	 */
	@RequestMapping("getPayRefundVoListByBusiId")
	@ResponseBody
	public ProcessResult getPayRefundVoListByBusiId(HttpServletRequest request, HttpServletResponse response,
			Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String isUnion = request.getParameter("isUnion");
			String orderId = request.getParameter("orderId");
			if (StringUtils.isEmpty(orderId)) {
				throw new Exception("获取可退款记录,订单号为空");
			}
			List<PayRefundVo> payRefundVos = new ArrayList<PayRefundVo>();
			if (("0").equals(isUnion)) {
				payRefundVos = ordPaymentFundService.getCanPayRefundVoListByRoomOrdId(orderId);
			}
			result.setRetCode("000000");
			result.setRetMsg("操作成功");
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("list", payRefundVos);
			result.setRet(map);
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
			return result;
		}
		return result;
	}

}
