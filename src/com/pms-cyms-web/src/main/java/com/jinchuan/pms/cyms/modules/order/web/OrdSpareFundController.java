/**
 *
 */
package com.jinchuan.pms.cyms.modules.order.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.jinchuan.pms.cyms.modules.order.entity.OrdCashbox;
import com.jinchuan.pms.cyms.modules.order.entity.OrdSpareFund;
import com.jinchuan.pms.cyms.modules.order.service.OrdCashboxService;
import com.jinchuan.pms.cyms.modules.order.service.OrdSpareFundService;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.utils.StringUtils;
import com.jinchuan.pms.pub.common.utils.money.Money;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.entity.PubShift;
import com.jinchuan.pms.pub.modules.sys.entity.SysBusiConfig;
import com.jinchuan.pms.pub.modules.sys.entity.User;
import com.jinchuan.pms.pub.modules.sys.service.PubShiftService;
import com.jinchuan.pms.pub.modules.sys.service.SysBusiConfigService;
import com.jinchuan.pms.pub.modules.sys.service.SystemService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 备用金Controller
 * @author tanzao
 * @version 2017-09-14
 */
@Controller
@RequestMapping(value = "${adminPath}/order/orderSpareFund")
public class OrdSpareFundController extends BaseController {

	@Autowired
	private OrdSpareFundService ordSpareFundService;

	@Autowired
	private PubShiftService pubShiftService;

	@Autowired
	private OrdCashboxService ordCashboxService;

	@Autowired
	private SystemService systemService;

	@Autowired
	private SysBusiConfigService sysBusiConfigService;

	@ModelAttribute
	public OrdSpareFund get(@RequestParam(required = false) String id) {
		OrdSpareFund entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = ordSpareFundService.get(id);
		}
		if (entity == null) {
			entity = new OrdSpareFund();
		}
		preRentId(entity);// 集团数据过滤
		return entity;
	}

	@RequiresPermissions("order:orderSpareFund:view")
	@RequestMapping(value = "")
	public String form(OrdSpareFund ordSpareFund, String operType, HttpServletRequest request, Model model) {
		// 获取班次信息
		String rentId = UserUtils.getUser().getRentId();
		String storeId = request.getParameter("storeId");
		List<PubShift> shiftList = pubShiftService.queryStoreShift(storeId, rentId);

		model.addAttribute("shiftList", shiftList);
		model.addAttribute("operType", operType);
		model.addAttribute("ordSpareFund", ordSpareFund);
		return "modules/order/orderSpareFundForm";
	}

	/**
	 *  根据班次Id获取班次对象
	 * @return
	 */
	@RequiresPermissions("order:orderSpareFund:view")
	@RequestMapping(value = "queryShift")
	@ResponseBody
	public ProcessResult queryShift(String id, Model model, RedirectAttributes redirectAttributes) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		// 获取班次信息
		PubShift shift = pubShiftService.queryShift(id);
		List<OrdCashbox> cashboxList = ordCashboxService.queryCashbox(id, shift.getStoreId(), shift.getRentId());
		for (OrdCashbox o : cashboxList) {
			SysBusiConfig sysBusiConfig = sysBusiConfigService.getByParamKey(o.getPayMethod(), "payWay");
			if (sysBusiConfig != null) {
				o.setLabel(sysBusiConfig.getName());
			}
		}
		// 返回钱箱钱总数
		Money totalMoney = new Money("0");
		for (OrdCashbox o : cashboxList) {
			totalMoney.addTo(o.getChangeMoney()).addTo(o.getPreTransfer()).addTo(o.getSpareDown());
		}
		Map<String, Object> ret = new HashMap<String, Object>();
		ret.put("shift", shift);
		ret.put("cashboxList", cashboxList);
		ret.put("totalMoney", totalMoney);
		result.setRetCode("000000");
		result.setRetMsg("成功");
		result.setRet(ret);
		return result;
	}

	@RequiresPermissions("order:orderSpareFund:view")
	@RequestMapping(value = "save")
	@ResponseBody
	public ProcessResult save(OrdSpareFund ordSpareFund, Model model, RedirectAttributes redirectAttributes) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			ordSpareFund.setStoreId(UserUtils.getStoreId());
			if (!beanValidator(model, ordSpareFund)) {
				result.setRetMsg((String) model.asMap().get("message"));
				return result;
			}
			if (!"true".equals(checkLoginName(ordSpareFund.getPayee(), ordSpareFund.getPassword()))) {
				result.setRetMsg("收款人不存在，或收款人密码不正确！");
				return result;
			}
			/*
			 * if(ordSpareFund.getOperType()
			 * .equals(TitleEnum.SPARE_UP.getCode())){ Money amount =
			 * ordSpareFund.getAmount();
			 * ordSpareFund.setAmount(amount.negate()); }
			 */
			String spareFundIds = ordSpareFundService.saveOrdSpareFund(ordSpareFund);
			result.setRetCode("000000");
			result.setRetMsg(spareFundIds);
			/*
			 * model.addAttribute("spareFundIds", spareFundIds);
			 * if(ordSpareFund.getOperType()
			 * .equals(TitleEnum.SPARE_DOWN.getCode())){
			 * result.setRetMsg("备用金下放成功"); }else{ result.setRetMsg("备用金上缴成功");
			 * }
			 */

		} catch (Exception e) {
			e.printStackTrace();
			return result;
		}
		return result;
	}

	/**
	 * 验证登录名和登录密码是否有效
	 * @param loginPassword
	 * @param loginName
	 * @return
	 */
	@ResponseBody
	@RequiresPermissions("order:orderSpareFund:edit")
	@RequestMapping(value = "checkLoginName")
	public String checkLoginName(String loginName, String loginPassword) {
		if (loginName.equals("") || loginPassword.equals("")) {
			return "false";
		}
		User user = systemService.getUserByLoginName(loginName);
		if (user != null) {
			boolean result = SystemService.validatePassword(loginPassword, user.getPassword());
			if (result) {
				return "true";
			}
		}
		return "false";
	}
}