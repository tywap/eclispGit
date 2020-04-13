/**
 *
 */
package com.jinchuan.pms.cyms.modules.report.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.jinchuan.pms.cyms.modules.order.entity.OrdPaymentFund;
import com.jinchuan.pms.cyms.modules.order.service.OrdPaymentFundService;
import com.jinchuan.pms.pay.enums.PayWayEnum;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.utils.DateUtils;
import com.jinchuan.pms.pub.common.utils.excel.ExportExcel;
import com.jinchuan.pms.pub.common.utils.money.Money;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.entity.PubShift;
import com.jinchuan.pms.pub.modules.sys.entity.SysBusiConfig;
import com.jinchuan.pms.pub.modules.sys.service.PubShiftService;
import com.jinchuan.pms.pub.modules.sys.service.SysBusiConfigService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 支付明细Controller
 * @author tanzao
 * @version 2017-09-14
 */
@Controller
@RequestMapping(value = "${adminPath}/order/ordPaymentFund")
public class OrdPaymentFundReportController extends BaseController {

	@Autowired
	private OrdPaymentFundService ordPaymentFundService;

	@Autowired
	private PubShiftService pubShiftService;

	@Autowired
	private SysBusiConfigService sysBusiConfigService;

	/**
	 * 支付明细
	 * @param ordCashbox
	 * @param model
	 * @param operType
	 * @return
	 */
	@RequestMapping(value = "query")
	public String query(HttpServletRequest request, HttpServletResponse response, Model model,OrdPaymentFund ordPaymentFund){
		String rentId = UserUtils.getUser().getRentId();
		ordPaymentFund.setRentId(rentId);
		/*String strTime=request.getParameter("strTime");
		String endTime=request.getParameter("endTime");*/
		if(ordPaymentFund.getStrTime()==null){
			ordPaymentFund.setStrTime(DateUtils.getDateBeFore());
		}
		if(ordPaymentFund.getEndTime()==null){
			ordPaymentFund.setEndTime(DateUtils.getDateBeFore());
		}
		List<OrdPaymentFund> list = ordPaymentFundService.getHangRoomAccountDetails(ordPaymentFund);
		double amount = 0;
		for (OrdPaymentFund o : list) {
			amount=amount+Double.parseDouble(o.getAmount().toString());
			String str = o.getPayVoucher();
			String [] strs =str.split("/");
			for (int i = 0; i < strs.length; i++) {
				if(i==0){
					o.setRoomNumber(strs[i]);
				}else if(i==1){
					String str2=strs[i].substring(0, strs[i].indexOf(":"));
					String str1 = strs[i].substring(str2.length()+1,strs[i].length());
					o.setRoomNo(str1);
				}else{
					o.setUsetName(strs[i]);
				}
			}
		}
		model.addAttribute("endTime", ordPaymentFund.getEndTime());
		model.addAttribute("strTime", ordPaymentFund.getStrTime());
		model.addAttribute("amount", amount);
		model.addAttribute("list", list);
		model.addAttribute("ordPaymentFund", ordPaymentFund);
		
		return "modules/report/check/ordPaymentFund";
	}
	
	@RequiresPermissions("order:ordPaymentFund:view")
	@RequestMapping(value = { "list", "" })
	public String list(HttpServletRequest request, HttpServletResponse response, Model model) {
		String rentId = UserUtils.getUser().getRentId();
		String storeId = request.getParameter("storeId");
		String shiftId = request.getParameter("shiftId");
		PayWayEnum[] payMethodEnm = PayWayEnum.values();// 支付方式
		List<Map<String, Object>> payMethodListMap = new ArrayList<>();
		for (int j = 0; j < payMethodEnm.length; j++) {
			Map<String, Object> payMethodMap = new HashMap<>();
			payMethodMap.put("code", payMethodEnm[j].getCode());
			payMethodMap.put("message", payMethodEnm[j].getMessage());
			payMethodListMap.add(payMethodMap);
		}

		SysBusiConfig sysBusiConfig = new SysBusiConfig();
		sysBusiConfig.setRentId(UserUtils.getUser().getRentId());
		List<SysBusiConfig> payWayList = sysBusiConfigService.getByType("payWay");
		Map<String, String> payMap = new HashMap<String, String>();
		for (SysBusiConfig s : payWayList) {
			payMap.put(s.getParamKey(), s.getName());
		}

		OrdPaymentFund ordPaymentFund = new OrdPaymentFund();
		ordPaymentFund.setRentId(rentId);
		ordPaymentFund.setStoreId(storeId);
		ordPaymentFund.setShiftId(shiftId);
		ordPaymentFund.setStatus("1");
		List<OrdPaymentFund> ordPaymentFundList = ordPaymentFundService.findList(ordPaymentFund);
		Money totalAmount = new Money("0");
		for (OrdPaymentFund o : ordPaymentFundList) {
			totalAmount.addTo(o.getAmount());
			o.setLabel(payMap.get(o.getPayMethod()));
		}
		model.addAttribute("nameList", ordPaymentFundService.queryUserName(ordPaymentFund.getShiftId()));
		model.addAttribute("totalAmount", totalAmount);
		model.addAttribute("totalNum", ordPaymentFundList.size());
		model.addAttribute("datalist", ordPaymentFundList);
		model.addAttribute("titleTypeList", ordPaymentFundService.queryType(ordPaymentFund.getShiftId()));
		model.addAttribute("payMethodList", payMethodListMap);
		return "modules/report/store/ordPaymentFundList";
	}

	@RequestMapping(value = "ExportExcel", method = RequestMethod.POST)
	@ResponseBody
	public ProcessResult ExportExcel(HttpServletRequest request, HttpServletResponse response, Model model,
			RedirectAttributes redirectAttributes) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String rentId = UserUtils.getUser().getRentId();
			String storeId = request.getParameter("storeId");
			String shiftId = request.getParameter("shiftId");
			String fileName = "收银明细";
			// 收集数据
			SysBusiConfig sysBusiConfig = new SysBusiConfig();
			sysBusiConfig.setRentId(UserUtils.getUser().getRentId());
			List<SysBusiConfig> payWayList = sysBusiConfigService.getByType("payWay");
			Map<String, String> payMap = new HashMap<String, String>();
			for (SysBusiConfig s : payWayList) {
				payMap.put(s.getParamKey(), s.getName());
			}

			OrdPaymentFund ordPaymentFund = new OrdPaymentFund();
			ordPaymentFund.setRentId(rentId);
			ordPaymentFund.setStoreId(storeId);
			ordPaymentFund.setShiftId(shiftId);
			List<OrdPaymentFund> ordPaymentFundList = ordPaymentFundService.findList(ordPaymentFund);
			for (OrdPaymentFund o : ordPaymentFundList) {
				o.setLabel(payMap.get(o.getPayMethod()));
			}
			// 导出
			new ExportExcel(fileName, OrdPaymentFund.class).setDataList(ordPaymentFundList)
					.write(response, fileName + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx").dispose();
		} catch (IOException e) {
			result.setRetCode("999999");
			result.setRetMsg("导出失败");
			throw new RuntimeException("后台数据异常！");
		}
		return result;
	}

}