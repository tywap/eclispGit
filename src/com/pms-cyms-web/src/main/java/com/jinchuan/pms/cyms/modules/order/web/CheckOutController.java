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

import com.fasterxml.jackson.databind.JavaType;
import com.jinchuan.pms.cyms.modules.order.enums.TitleEnum;
import com.jinchuan.pms.cyms.modules.order.service.CheckOutService;
import com.jinchuan.pms.cyms.modules.order.service.OrdDepositAccountService;
import com.jinchuan.pms.cyms.modules.order.service.OrdPaymentFundService;
import com.jinchuan.pms.cyms.modules.order.service.OrdTableConsumeItemService;
import com.jinchuan.pms.pub.common.config.Global;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.mapper.JsonMapper;
import com.jinchuan.pms.pub.common.utils.SequenceUtils;
import com.jinchuan.pms.pub.common.utils.StringUtils;
import com.jinchuan.pms.pub.common.utils.money.Money;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 结账Controller
 * @author tanzao
 * @version 2017-11-14
 */
@Controller
@RequestMapping(value = "${adminPath}/order/checkOut")
public class CheckOutController extends BaseController {
	@Autowired
	private CheckOutService checkOutService;
	@Autowired
	private OrdPaymentFundService ordPaymentFundService;
	@Autowired
	private OrdTableConsumeItemService ordTableConsumeItemService;
	@Autowired
	private OrdDepositAccountService ordDepositAccountService;

	/**
	 * 部分结账初始化
	 * @Title: checkOutPart  
	 * @param @param request
	 * @param @param response
	 * @param @param model
	 * @param @return 
	 * @return String 
	 * @throws
	 */
	@RequestMapping("checkOutPart")
	public String checkOutPart(HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/order/checkOutPart";
	}

	/**
	 * 部分结账提交
	 * @Title: checkOutPart  
	 * @param @param request
	 * @param @param response
	 * @param @param model
	 * @param @return 
	 * @return String 
	 * @throws
	 */
	@RequestMapping("checkOutPartCommit")
	@ResponseBody
	public ProcessResult checkOutPartCommit(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		String ip = getIpAddress(request);
		String rentId = UserUtils.getUser().getRentId();
		String storeId = request.getParameter("storeId");
		String transactionId = SequenceUtils.getSeq("account_sequence");
		String isUnion = request.getParameter("isUnion");
		String orderId = request.getParameter("orderId");
		try {
			String paymentDetailJson = request.getParameter("paymentDetailJson");
			String paymentFundJson = request.getParameter("paymentFundJson");
			if (StringUtils.isEmpty(storeId)) {
				throw new Exception("【结账】分店号storeId为空");
			}
			if (StringUtils.isEmpty(isUnion)) {
				throw new Exception("【部分结账】订单标志isUnion为空");
			}
			if (StringUtils.isEmpty(orderId)) {
				throw new Exception("【部分结账】订单号orderId为空");
			}
			if (StringUtils.isEmpty(paymentDetailJson)) {
				throw new Exception("【部分结账】消费明细paymentDetailJson为空");
			}
			if (StringUtils.isEmpty(paymentFundJson)) {
				throw new Exception("【部分结账】支付明细paymentFundJson为空");
			}
			JavaType javaType = JsonMapper.getInstance().createCollectionType(List.class, Map.class);
			List<Map<String, Object>> paymentDetails = (List<Map<String, Object>>) JsonMapper.getInstance()
					.fromJson(paymentDetailJson, javaType);// jsonString转list
			List<Map<String, Object>> paymentFunds = (List<Map<String, Object>>) JsonMapper.getInstance()
					.fromJson(paymentFundJson, javaType);// jsonString转list
			if (("0").equals(isUnion)) {
				result = checkOutService.checkOutPart(ip, isUnion, orderId, paymentDetails, paymentFunds, transactionId,
						"部分结账");// 单房部分结账
			} else {
				throw new Exception("【 部分结账】订单标志isUnion异常");
			}
		} catch (Exception e) {
			ordDepositAccountService.unusualPayAccountCommit(ip, rentId, storeId, isUnion, orderId, transactionId,
					Global.YES);// 异常账务处理
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

	/**
	 * 结账初始化
	 * @Title: checkOut  
	 * @param @param request
	 * @param @param response
	 * @param @param model
	 * @param @return 
	 * @return String 
	 * @throws
	 */
	@RequestMapping("checkOut")
	public String checkOut(HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/order/checkOut";
	}

	/**
	 * 单房、整单结账提交
	 * @Title: checkOutPart  
	 * @param @param request
	 * @param @param response
	 * @param @param model
	 * @param @return 
	 * @return String 
	 * @throws
	 */
	@RequestMapping("checkOutCommit")
	@ResponseBody
	public ProcessResult checkOutCommit(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		String ip = getIpAddress(request);
		String rentId = UserUtils.getUser().getRentId();
		String storeId = request.getParameter("storeId");
		String transactionId = SequenceUtils.getSeq("account_sequence");
		String isUnion = request.getParameter("isUnion");
		String orderId = request.getParameter("orderId");
		try {
			String type = request.getParameter("type");
			String paymentFundJson = request.getParameter("paymentFundJson");
			if (StringUtils.isEmpty(storeId)) {
				throw new Exception("【结账】分店号storeId为空");
			}
			if (StringUtils.isEmpty(isUnion)) {
				throw new Exception("【结账】订单标志isUnion为空");
			}
			if (StringUtils.isEmpty(orderId)) {
				throw new Exception("【结账】订单号orderId为空");
			}
			if (StringUtils.isEmpty(paymentFundJson)) {
				throw new Exception("【结账】支付明细paymentFundJson为空");
			}
			JavaType javaType = JsonMapper.getInstance().createCollectionType(List.class, Map.class);
			List<Map<String, Object>> paymentFunds = (List<Map<String, Object>>) JsonMapper.getInstance()
					.fromJson(paymentFundJson, javaType);// jsonString转list

			if (("0").equals(isUnion)) {
				result = checkOutService.checkOut(ip, isUnion, orderId, paymentFunds, transactionId, "结账");
			} else {
				throw new Exception("【结账】订单标志isUnion异常");
			}
		} catch (Exception e) {
			ordDepositAccountService.unusualPayAccountCommit(ip, rentId, storeId, isUnion, orderId, transactionId,
					Global.YES);// 异常账务处理
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

	/**
	 * PX初始化
	 * @Title: checkOut  
	 * @param @param request
	 * @param @param response
	 * @param @param model
	 * @param @return 
	 * @return String 
	 * @throws
	 */
	@RequestMapping("checkOutPX")
	public String checkOutPX(HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/order/checkOutPX";
	}

	/**
	 * PX提交
	 * @Title: checkOutPart  
	 * @param @param request
	 * @param @param response
	 * @param @param model
	 * @param @return 
	 * @return String 
	 * @throws
	 */
	@RequestMapping("checkOutPXCommit")
	@ResponseBody
	public ProcessResult checkOutPXCommit(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String isUnion = request.getParameter("isUnion");
			String orderId = request.getParameter("orderId");
			if (StringUtils.isEmpty(isUnion)) {
				throw new Exception("【 PX】订单标志isUnion为空");
			}
			if (StringUtils.isEmpty(orderId)) {
				throw new Exception("【 PX】订单号orderId为空");
			}
			if (("0").equals(isUnion)) {
				result = checkOutService.checkOutPX(orderId);// 单房px
			} else {
				throw new Exception("【 PX】订单标志isUnion异常");
			}
			result.setRetCode("000000");
			result.setRetMsg("操作成功");
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
			return result;
		}
		return result;
	}

	/**
	 * 获取订单的消费、收款
	 * @Title: getConsumePayTotal 
	 * @param @param request
	 * @param @param response
	 * @param @param model
	 * @param @return 
	 * @return ProcessResult 
	 * @throws
	 */
	@RequestMapping("getConsumePayTotal")
	@ResponseBody
	public ProcessResult getConsumePayTotal(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String orderId = request.getParameter("orderId");
			if (StringUtils.isEmpty(orderId)) {
				throw new Exception("获取订单的消费汇总,订单号orderId为空");
			}
			// 总消费
			String settleStatus = "";
			Money consumeTotal = ordTableConsumeItemService.getConsumeTotalByOrderId(orderId, settleStatus);
			consumeTotal = consumeTotal == null ? new Money("0") : consumeTotal;
			// 总收款
			List<String> titleNos = new ArrayList<String>();
			String status = "1";
			titleNos.add(TitleEnum.ROOM_DEPOSIT.getCode());
			titleNos.add(TitleEnum.ROOM_PART_SETTLE.getCode());
			titleNos.add(TitleEnum.ROOM_SETTLE.getCode());
			Money payTotal = ordPaymentFundService.getOrdPaymentFundTotalByOrderId(orderId, titleNos, status);
			payTotal = payTotal == null ? new Money("0") : payTotal;
			// 预授权总收款
			titleNos = new ArrayList<String>();
			titleNos.add(TitleEnum.ROOM_PRE_AUTH.getCode());
			Money payPreauthTotal = ordPaymentFundService.getOrdPaymentFundTotalByOrderId(orderId, titleNos, status);
			payPreauthTotal = payPreauthTotal == null ? new Money("0") : payPreauthTotal;
			Map<String, Object> retMap = new HashMap<String, Object>();
			retMap.put("consumeAmountTotal", consumeTotal.getAmount().toString());
			retMap.put("payAmountTotal", payTotal.getAmount().toString());
			retMap.put("payPreauthTotal", payPreauthTotal.getAmount().toString());
			retMap.put("balanceAmountTotal", consumeTotal.subtract(payTotal).toString());
			result.setRet(retMap);
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