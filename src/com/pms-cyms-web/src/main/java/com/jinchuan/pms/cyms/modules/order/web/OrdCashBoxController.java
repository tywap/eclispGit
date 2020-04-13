/**
 *
 */
package com.jinchuan.pms.cyms.modules.order.web;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

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
import com.jinchuan.pms.cyms.modules.order.entity.OrdPaymentFund;
import com.jinchuan.pms.cyms.modules.order.service.OrdCashboxService;
import com.jinchuan.pms.cyms.modules.order.service.OrdPaymentFundService;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.exception.BusinessException;
import com.jinchuan.pms.pub.common.utils.DateUtils;
import com.jinchuan.pms.pub.common.utils.StringUtils;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.entity.Office;
import com.jinchuan.pms.pub.modules.sys.entity.PubShift;
import com.jinchuan.pms.pub.modules.sys.service.PubShiftService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 钱箱Controller
 * @author tanzao
 * @version 2017-09-14
 */
@Controller
@RequestMapping(value = "${adminPath}/order/ordCashbox")
public class OrdCashBoxController extends BaseController {
	@Autowired
	private OrdPaymentFundService ordPaymentFundService;
	@Autowired
	private PubShiftService pubShiftService;
	@Autowired
	private OrdCashboxService ordCashboxService;

	@ModelAttribute
	public OrdCashbox get(@RequestParam(required = false) String id) {
		OrdCashbox entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = ordCashboxService.get(id);
		}
		if (entity == null) {
			entity = new OrdCashbox();
		}
		preRentId(entity);// 集团数据过滤
		return entity;
	}

	@RequestMapping(value = "ordCashboxInit")
	public String ordCashboxInit(OrdCashbox ordCashbox, Model model) {
		List<Office> offices = UserUtils.getHotelList();// 用户可访问的酒店
		model.addAttribute("offices", offices);
		return "modules/order/orderChangeShiftsInit";
	}

	/**
	 * 交接班
	 * @param ordCashbox
	 * @param model
	 * @param operType
	 * @return
	 */
	@SuppressWarnings("static-access")
	@RequiresPermissions("order:ordCashbox:view")
	@RequestMapping(value = "")
	public String form(OrdCashbox ordCashbox, HttpServletRequest request, Model model) {
		String rentId = UserUtils.getUser().getRentId();
		String storeId = request.getParameter("storeId");
		// 获取班次信息
		PubShift pubShift = new PubShift();
		pubShift.setRentId(rentId);
		pubShift.setStoreId(storeId);
		pubShift.setStatus(pubShift.SHIFT_STATUS_ON);
		List<PubShift> shiftList = pubShiftService.findList(pubShift);
		if (shiftList.size() == 0) {
			throw new BusinessException("分店班次未初始化！");
		}
		String shiftId = shiftList.get(0).getId();
		String sort = shiftList.get(0).getSort();
		if (UserUtils.getShift() != null) {
			shiftId = UserUtils.getShift().getId();
			sort = UserUtils.getShift().getSort();
		}
		List<OrdCashbox> cashboxList = ordCashboxService.queryCashbox(shiftId, storeId, rentId);
		// 返回钱箱钱总数
		OrdCashbox cashboxTotalMoney = ordCashboxService.countTotal(shiftId, storeId, rentId);
		// 预授权汇总
		String cashboxPreTotalMoney = ordCashboxService.countPreTotal(shiftId, storeId, rentId, "7");
		// 支付记录
		List<OrdPaymentFund> paymentDetailList = ordPaymentFundService.findPaymentDetailByshift(shiftId);
		model.addAttribute("cashboxList", cashboxList);
		model.addAttribute("cashboxTotalMoney", cashboxTotalMoney);
		model.addAttribute("cashboxPreTotalMoney", cashboxPreTotalMoney);
		model.addAttribute("ordCashbox", ordCashbox);
		model.addAttribute("shiftName", cashboxList.get(0).getShiftName());
		model.addAttribute("endTime", cashboxList.get(0).getEndTime());
		model.addAttribute("beginTime", cashboxList.get(0).getBeginTime());
		model.addAttribute("sort", sort);
		// 接班班次
		List<PubShift> newPubShift = new ArrayList<PubShift>();
		for (PubShift p : shiftList) {
			if (!p.getShiftName().equals(cashboxList.get(0).getShiftName())
					&& Integer.parseInt(p.getSort()) > Integer.parseInt(sort)) {
				newPubShift.add(p);
			}
		}
		model.addAttribute("shiftList", newPubShift);
		model.addAttribute("userName", UserUtils.getUser().getName());
		model.addAttribute("paymentDetailList", paymentDetailList);
		model.addAttribute("openCashboxTimeStr", DateUtils.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss"));
		return "modules/order/orderChangeShiftsForm";
	}

	@RequiresPermissions("order:ordCashbox:edit")
	@RequestMapping(value = "save")
	@ResponseBody
	public ProcessResult save(OrdCashbox ordCashbox, Model model, HttpServletRequest request,
			RedirectAttributes redirectAttributes) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		String rentId = UserUtils.getUser().getRentId();
		String storeId = request.getParameter("storeId");
		String openCashboxTimeStr = request.getParameter("openCashboxTimeStr");
		String name = request.getParameter("name");
		String password = request.getParameter("password");
		String transferWork = request.getParameter("transferWorks");
		String payMethod = request.getParameter("payMethods");
		String[] transferWorkMoney = transferWork.split(",");
		String[] payMethods = payMethod.split(",");
		String total = request.getParameter("total");
		String remarks = request.getParameter("remarks");
		String shiftClose = request.getParameter("payee");
		String shiftId = request.getParameter("shiftId");
		PubShift pubShift = UserUtils.getShiftByStroreId(storeId);
		String currentShiftId = pubShift.getId();
		PubShift pubShiftData = pubShiftService.get(currentShiftId);
		String sort = pubShiftData.getSort();
		try {
			ordCashboxService.handover(rentId, storeId, name, password, total, shiftClose, shiftId, currentShiftId,
					payMethods, transferWorkMoney, remarks, sort, openCashboxTimeStr);
			result.setRetCode("000000");
			result.setRetMsg("交接班成功");
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
			return result;
		}
		return result;
	}
}