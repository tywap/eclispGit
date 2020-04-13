/**
 *
 */
package com.jinchuan.pms.cyms.modules.order.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.exception.BusinessException;
import com.jinchuan.pms.pub.common.mapper.JsonMapper;
import com.jinchuan.pms.pub.common.utils.ObjectUtils;
import com.jinchuan.pms.pub.common.utils.SequenceUtils;
import com.fasterxml.jackson.databind.JavaType;
import com.jinchuan.pms.cyms.modules.order.service.OrdDepositService;
import com.jinchuan.pms.cyms.modules.pay.service.OrdPayService;
import com.jinchuan.pms.cyms.modules.setting.entity.HtlStore;
import com.jinchuan.pms.cyms.modules.setting.service.HtlStoreService;
import com.jinchuan.pms.cyms.modules.utils.PmsFacadeUtils;
import com.jinchuan.pms.pay.model.Pay;
import com.jinchuan.pms.pay.model.PayResultVo;
import com.jinchuan.pms.pay.service.impl.PayService;
import com.jinchuan.pms.pay.utils.PayFactory;

/**
 * 支付Controller
 * @author tanzao
 * @version 2017-12-12
 */
@Controller
@RequestMapping(value = "${adminPath}/pay")
public class PayController extends BaseController {
	private Logger log = LoggerFactory.getLogger(PayController.class);
	@Autowired
	private PayFactory payFactory;
	@Autowired
	private PayService payService;
	@Autowired
	private OrdPayService ordPayService;
	@Autowired
	private HtlStoreService htlStoreService;
	@Autowired
	private OrdDepositService ordDepositService;

	/**
	 *储值卡支付初始化
	 * @Title: pay  
	 * @param @param request
	 * @param @param response
	 * @param @param model
	 * @param @param redirectAttributes
	 * @param @return 
	 * @return ProcessResult 
	 * @throws
	 */
	@RequestMapping(value = "memberPayInit")
	public String memberPayInit(HttpServletRequest request, HttpServletResponse response, Model model,
			RedirectAttributes redirectAttributes) {
		return "modules/common/common_member_pay";
	}

	/**
	 *储值卡密码校验
	 * @Title: cardPayCheckPassword  
	 * @param @param request
	 * @param @param response
	 * @param @param model
	 * @param @param redirectAttributes
	 * @param @return 
	 * @return ProcessResult 
	 * @throws
	 */
	@RequestMapping(value = "validMemberPayPassword")
	@ResponseBody
	public ProcessResult validMemberPayPassword(HttpServletRequest request, HttpServletResponse response, Model model,
			RedirectAttributes redirectAttributes) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String storeId = request.getParameter("storeId");
			String memberId = request.getParameter("memberId");
			String payPassword = request.getParameter("payPassword");
			HtlStore htlStore = htlStoreService.get(storeId);
			if (htlStore == null) {
				throw new BusinessException("分店不存在storeId=" + storeId);
			}
			String pmsRentId = htlStore.getPmsRentId();
			String pmsStoreId = htlStore.getPmsStoreId();
			Map<String, String> paramMap = new HashMap<String, String>();
			paramMap.put("rentId", pmsRentId);
			paramMap.put("storeId", pmsStoreId);
			paramMap.put("memberId", memberId);
			paramMap.put("payPassword", payPassword);
			String responseStr = PmsFacadeUtils.sendPostToPMS(PmsFacadeUtils.validMemberPayPassword, paramMap);
			JavaType javaType = JsonMapper.getInstance().createCollectionType(List.class, Map.class);
			Map<String, Object> retMap = (Map<String, Object>) JsonMapper.getInstance().fromJson(responseStr,
					Map.class);// jsonString转list
			if ("000000".equals(retMap.get("retCode"))) {
				result = new ProcessResult("000000", "操作成功");
			} else {
				result.setRetMsg(ObjectUtils.toString(retMap.get("retMsg")));
			}
		} catch (Exception e) {
			result.setRetMsg(e.getMessage());
			e.printStackTrace();
		}
		return result;
	}

	/**
	 *挂账支付初始化
	 * @Title: pay  
	 * @param @param request
	 * @param @param response
	 * @param @param model
	 * @param @param redirectAttributes
	 * @param @return 
	 * @return ProcessResult 
	 * @throws
	 */
	@RequestMapping(value = "groupPayInit")
	public String groupPayInit(HttpServletRequest request, HttpServletResponse response, Model model,
			RedirectAttributes redirectAttributes) {
		return "modules/common/common_group_pay";
	}

	/**
	 *挂房账初始化
	 * @Title: pay  
	 * @param @param request
	 * @param @param response
	 * @param @param model
	 * @param @param redirectAttributes
	 * @param @return 
	 * @return ProcessResult 
	 * @throws
	 */
	@RequestMapping(value = "roomPayInit")
	public String roomPayInit(HttpServletRequest request, HttpServletResponse response, Model model,
			RedirectAttributes redirectAttributes) {
		return "modules/common/common_room_pay";
	}

	/**
	 * @Title: getOrdRooms  
	 * @Description: 房单搜索
	 * @param request
	 * @param response
	 * @param model
	 * @return ProcessResult 
	 * @throws
	 */
	@RequestMapping("getOrdRooms")
	@ResponseBody
	public ProcessResult getOrdRooms(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String storeId = request.getParameter("storeId");
			String queryValue = request.getParameter("queryValue");
			HtlStore htlStore = htlStoreService.get(storeId);
			if (htlStore == null) {
				throw new BusinessException("分店不存在storeId=" + storeId);
			}
			String pmsRentId = htlStore.getPmsRentId();
			String pmsStoreId = htlStore.getPmsStoreId();
			Map<String, String> paramMap = new HashMap<String, String>();
			paramMap.put("rentId", pmsRentId);
			paramMap.put("storeId", pmsStoreId);
			paramMap.put("queryValue", queryValue);
			String responseStr = PmsFacadeUtils.sendPostToPMS(PmsFacadeUtils.roomQuery, paramMap);
			JavaType javaType = JsonMapper.getInstance().createCollectionType(List.class, Map.class);
			Map<String, Object> retMap = (Map<String, Object>) JsonMapper.getInstance().fromJson(responseStr,
					Map.class);// jsonString转list
			if ("000000".equals(retMap.get("retCode"))) {
				Map<String, Object> responseRet = (Map<String, Object>) retMap.get("ret");
				List<Map<String, Object>> ordRooms = (List<Map<String, Object>>) responseRet.get("result");
				Map<String, Object> ret = new HashMap<String, Object>();
				ret.put("list", ordRooms);
				result = new ProcessResult("000000", "操作成功", ret);
			} else {
				result.setRetMsg(ObjectUtils.toString(retMap.get("retMsg")));
			}
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

	/**
	 * 支付调用
	 * @Title: pay  
	 * @param @param request
	 * @param @param response
	 * @param @param model
	 * @param @param redirectAttributes
	 * @param @return 
	 * @return ProcessResult 
	 * @throws
	 */
	@RequestMapping(value = "pay")
	@ResponseBody
	public ProcessResult pay(HttpServletRequest request, HttpServletResponse response, Model model,
			RedirectAttributes redirectAttributes) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			log.info("开始支付");
			long beginMs = System.currentTimeMillis();
			String substoreId = UserUtils.getStoreId();
			String subject = request.getParameter("subject");
			String payWay = request.getParameter("payWay");
			String amount = request.getParameter("amount");
			String authCode = request.getParameter("authCode");
			if (StringUtils.isEmpty(substoreId)) {
				throw new Exception("分店号为空");
			}
			if (StringUtils.isEmpty(subject)) {
				throw new Exception("支付标题为空");
			}
			if (StringUtils.isEmpty(payWay)) {
				throw new Exception("支付方式为空");
			}
			if (StringUtils.isEmpty(amount)) {
				throw new Exception("支付金额为空");
			}
			if (StringUtils.isEmpty(authCode)) {
				throw new Exception("支付条码为空");
			}
			Double amountDouble = Double.parseDouble(amount);
			substoreId = "001";
			String ip = request.getRemoteAddr();
			// ThirdpartyPayResult thirdpartyPayResult =
			// thirdpartyPayService.tradePay(payWay, substoreId, subject,
			// amountDouble, authCode, ip);
			Map<String, Object> map = new HashMap<String, Object>();
			// map.put("thirdpartyPayResult", thirdpartyPayResult);
			result.setRet(map);
			result.setRetCode("000000");
			result.setRetMsg("操作成功");
			log.info("支付耗时={}", System.currentTimeMillis() - beginMs);
		} catch (Exception e) {
			result.setRetMsg(e.getMessage());
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 手工退款
	 * @Title: tradeRefund  
	 * @param request
	 * @param response
	 * @param model
	 * @return 
	 * ProcessResult 
	 * @throws
	 */
	@RequestMapping(value = "tradeRefund")
	@ResponseBody
	public ProcessResult tradeRefund(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		String ip = getIpAddress(request);
		String payId = request.getParameter("payId");
		Pay pay = payService.getById(payId);
		if (pay == null) {
			throw new BusinessException("查无此支付流水" + payId);
		}
		String transactionId = SequenceUtils.getSeq("account_sequence");
		String mchId = pay.getMchId();
		String rentId = pay.getRentId();
		String storeId = pay.getStoreId();
		String busiId = pay.getBusiId();
		String payWay = pay.getPayWay();
		String subject = "客户退款(手工)";
		Double amount = pay.getAmount();
		String token = "";
		Map<String, String> substoreThirdpartyPayInfo = payService.getSubstorePayInfo(storeId);
		if (substoreThirdpartyPayInfo != null) {
			token = substoreThirdpartyPayInfo.get("appAuthToken");
		}
		// 允许不按收款方式结账(现金、银行卡、减免、微信-手工、支付宝-手工)
		PayResultVo thirdpartyPayResult = payFactory.get(payWay).doTradeRefund(ip, rentId, storeId, busiId,
				transactionId, mchId, token, subject, payWay, payId, "000000", "接口退款", amount, amount, subject, "0");
		result.setRetCode("000000");
		result.setRetMsg(JsonMapper.toJsonString(thirdpartyPayResult));
		return result;
	}

	/**
	 * 异常账务查询
	 * @Title: tradeRefund  
	 * @param request
	 * @param response
	 * @param model
	 * @return 
	 * ProcessResult 
	 * @throws
	 */
	@RequestMapping(value = "getUnusualPayList")
	@ResponseBody
	public ProcessResult getUnusualPayList(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String isUnion = request.getParameter("isUnion");
			String orderId = request.getParameter("orderId");
			if (StringUtils.isEmpty(orderId)) {
				throw new Exception("获取房单的可退款记录,参数orderId为空");
			}
			List<Map<String, String>> unusualPays = new ArrayList<Map<String, String>>();
			if (("0").equals(isUnion)) {
				unusualPays = ordPayService.getUnusualPayListByOrdId(orderId);
			} else if (("1").equals(isUnion)) {
				unusualPays = ordPayService.getUnusualPayListByUnionId(orderId);
			}
			result.setRetCode("000000");
			result.setRetMsg("操作成功");
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("list", unusualPays);
			result.setRet(map);
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
			return result;
		}
		return result;
	}

	/**
	 * 异常账务补录
	 * @Title: tradeRefund  
	 * @param request
	 * @param response
	 * @param model
	 * @return 
	 * ProcessResult 
	 * @throws
	 */
	@RequestMapping(value = "entryUnusualPay")
	@ResponseBody
	public ProcessResult entryUnusualPay(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String isUnion = request.getParameter("isUnion");
			String orderId = request.getParameter("orderId");
			String payId = request.getParameter("payId");
			String roomNosStr = request.getParameter("roomNosStr");
			String remarks = "异常账务补录";
			ordDepositService.entryUnusualPay(isUnion, orderId, payId, roomNosStr, remarks);
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