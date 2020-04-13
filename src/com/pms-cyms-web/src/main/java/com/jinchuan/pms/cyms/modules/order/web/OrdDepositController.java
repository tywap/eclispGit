/**
 *
 */
package com.jinchuan.pms.cyms.modules.order.web;

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
import com.jinchuan.pms.cyms.modules.order.service.OrdDepositAccountService;
import com.jinchuan.pms.cyms.modules.order.service.OrdDepositService;
import com.jinchuan.pms.pub.common.config.Global;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.mapper.JsonMapper;
import com.jinchuan.pms.pub.common.utils.SequenceUtils;
import com.jinchuan.pms.pub.common.utils.StringUtils;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 押金Controller
 * @author tanzao
 * @version 2017-11-28
 */
@Controller
@RequestMapping(value = "${adminPath}/order/ordDeposit")
public class OrdDepositController extends BaseController {
	@Autowired
	private OrdDepositService ordDepositService;
	@Autowired
	private OrdDepositAccountService ordDepositAccountService;

	/**
	 * 押金管理界面初始化
	 * @Title: ordDepositInit  
	 * @param @return 
	 * @return String 
	 * @throws
	 */
	@RequestMapping("ordDeposit")
	public String ordDeposit(HttpServletRequest request, HttpServletResponse response, Model model) {
		return "modules/order/ordDeposit";
	}

	/**
	 * 押金管理提交
	 * @Title: ordGoodsCommit  
	 * @param @param request
	 * @param @param response
	 * @param @param model
	 * @param @return 
	 * @return ProcessResult 
	 * @throws
	 */
	@RequestMapping("ordDepositCommit")
	@ResponseBody
	public ProcessResult ordDepositCommit(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		String ip = getIpAddress(request);
		String rentId = UserUtils.getUser().getRentId();
		String storeId = request.getParameter("storeId");
		String transactionId = SequenceUtils.getSeq("account_sequence");
		String isUnion = request.getParameter("isUnion");
		String orderId = request.getParameter("orderId");
		try {
			String paymentFundsJson = request.getParameter("paymentFunds");
			if (StringUtils.isEmpty(storeId)) {
				throw new Exception("【押金调整】房单号storeId为空");
			}
			if (StringUtils.isEmpty(orderId)) {
				throw new Exception("【押金调整】房单号orderId为空");
			}
			if (StringUtils.isEmpty(paymentFundsJson)) {
				throw new Exception("【押金调整】支付明细paymentFunds为空");
			}
			JavaType javaType = JsonMapper.getInstance().createCollectionType(List.class, Map.class);
			List<Map<String, Object>> paymentFunds = (List<Map<String, Object>>) JsonMapper.getInstance()
					.fromJson(paymentFundsJson, javaType);// jsonString转list

			if (isUnion.equals("0")) {
				result = ordDepositService.roomOrdDepositCommit(ip, isUnion, orderId, paymentFunds, transactionId,
						"押金调整");
			} else {
				throw new Exception("【押金管理】，联单标志union异常");
			}
		} catch (Exception e) {
			ordDepositAccountService.unusualPayAccountCommit(ip, rentId, storeId, isUnion, orderId, transactionId,
					Global.YES);// 异常账务处理
			result.setRetMsg(e.getMessage());
			e.printStackTrace();
		}
		return result;
	}
}