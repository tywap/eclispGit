package com.jinchuan.pms.cyms.modules.report.web;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.jinchuan.pms.cyms.modules.report.entity.OrdPaymentVO;
import com.jinchuan.pms.cyms.modules.report.service.OrdReportPaymentService;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.utils.DateUtils;
import com.jinchuan.pms.pub.common.utils.StringUtils;
import com.jinchuan.pms.pub.common.utils.excel.ExportExcel;
import com.jinchuan.pms.pub.common.utils.money.Money;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.entity.Office;
import com.jinchuan.pms.pub.modules.sys.entity.PubShiftConfig;
import com.jinchuan.pms.pub.modules.sys.entity.SysBusiConfig;
import com.jinchuan.pms.pub.modules.sys.service.PubShiftConfigService;
import com.jinchuan.pms.pub.modules.sys.service.SysBusiConfigService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 
 * @ClassName: OrdPaymentVO
 * @Description: 支付明细查询
 * @author heyi
 * @date 2017年11月30日 下午5:01:05
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/report/ordPayment")
public class OrdReportPaymentController extends BaseController {

	@Autowired
	private OrdReportPaymentService ordReportPaymentService;
	@Autowired
	private PubShiftConfigService pubShiftConfigService;

	@Autowired
	private SysBusiConfigService sysBusiConfigService;

	/**
	 * 
	 * @Title: 
	 * @Description: 支付明细查询
	 * @author: heyi 
	 * String @throws
	 */
	@RequestMapping("/queryOrderPayment")
	public String queryOrderPayment(Model model, OrdPaymentVO ordPaymentVO, String flag) {
		String rentid = UserUtils.getUser().getRentId();
		ordPaymentVO.setRentId(rentid);
		// 获取班次信息
		PubShiftConfig pubShiftConfig = new PubShiftConfig();
		pubShiftConfig.setRentId(rentid);
		pubShiftConfig.setStatus("1");
		// 当查询所有数据的时候判断数据权限
		if (StringUtils.isEmpty(ordPaymentVO.getStoreId())) {
			ordPaymentVO.setAuthorityStoreId(UserUtils.getStoreCacheStr());
		}
		List<PubShiftConfig> shiftList = pubShiftConfigService.findList(pubShiftConfig);
		// String storeId = UserUtils.getStoreId();
		if (ordPaymentVO.getDateType() != null && ordPaymentVO.getDateType() != "") {
			if (ordPaymentVO.getFlag() != null && !ordPaymentVO.getFlag().equals("1")) {
				ordPaymentVO.setFlag("");
			}
			if (ordPaymentVO.getPayMethod() == null) {
				ordPaymentVO.setPayMethod("");
			}

			SysBusiConfig sysBusiConfig = new SysBusiConfig();
			sysBusiConfig.setRentId(UserUtils.getUser().getRentId());
			List<SysBusiConfig> payWayList = sysBusiConfigService.getByType("payWay");
			Map<String, String> payMap = new HashMap<String, String>();
			for (SysBusiConfig s : payWayList) {
				payMap.put(s.getParamKey(), s.getName());
			}
			List<OrdPaymentVO> ordPaymentList = ordReportPaymentService.queryOrderPayment(ordPaymentVO);
			Money amountSum = new Money("0");
			for (OrdPaymentVO o : ordPaymentList) {
				amountSum = amountSum.addTo(new Money(o.getAmount()));
				o.setPayMethodName(payMap.get(o.getPayMethod()));
				// SysBusiConfig sysBusiConfig =
				// sysBusiConfigService.getByParamKey(o.getPayMethod(),
				// "payWay");
				// o.setPayMethod(sysBusiConfig.getName());
				/* payMentFund.put("payClass", sysBusiConfig.getName()); */
			}
			model.addAttribute("ordPaymentList", ordPaymentList);
			model.addAttribute("amountSum", amountSum);
			model.addAttribute("totalCount", ordPaymentList.size());
			model.addAttribute("flag", flag);
		} else {
			// ordPaymentVO.setDateType("1");
			ordPaymentVO.setStrTime(DateUtils.getDateBeFore() + " 00:00");
			ordPaymentVO.setEndTime(DateUtils.getDateBeFore() + " 23:59");

			model.addAttribute("strTime", DateUtils.getDateBeFore() + " 00:00");
			model.addAttribute("endTime", DateUtils.getDateBeFore() + " 23:59");
		}
		// List<Map<String, String>> titleList =
		// ordReportPaymentService.queryTitle(rentid);
		List<Office> hotelList = UserUtils.getHotelList();
		List<Office> hQList = UserUtils.getOfficeListByType("0");
		hotelList.addAll(hQList);
		// model.addAttribute("titleList", titleList);
		model.addAttribute("hotelList", hotelList);
		model.addAttribute("shiftList", shiftList);
		// model.addAttribute("hotelList", UserUtils.getHotelList());

		return "modules/report/store/orderPaymentQuery";
	}

	@RequestMapping(value = "ExportExcel", method = RequestMethod.POST)
	@ResponseBody
	public ProcessResult ExportExcel(OrdPaymentVO ordPaymentVO, HttpServletRequest request,
			HttpServletResponse response, Model model, RedirectAttributes redirectAttributes) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			// ordReserveVO.setStoreId( UserUtils.getStoreId());
			String rentid = UserUtils.getUser().getRentId();
			ordPaymentVO.setRentId(rentid);
			// 当查询所有数据的时候判断数据权限
			if (StringUtils.isEmpty(ordPaymentVO.getStoreId())) {
				ordPaymentVO.setAuthorityStoreId(UserUtils.getStoreCacheStr());
			}
			String fileName = "收银明细";
			// flag=1表示第三方支付
			if (ordPaymentVO.getFlag() != null && !ordPaymentVO.getFlag().equals("1")) {
				ordPaymentVO.setFlag("");
			} else {
				fileName = "收银明细(第三方支付)";
			}
			// 收集数据
			SysBusiConfig sysBusiConfig = new SysBusiConfig();
			sysBusiConfig.setRentId(UserUtils.getUser().getRentId());
			List<SysBusiConfig> payWayList = sysBusiConfigService.getByType("payWay");
			Map<String, String> payMap = new HashMap<String, String>();
			for (SysBusiConfig s : payWayList) {
				payMap.put(s.getParamKey(), s.getName());
			}
			List<OrdPaymentVO> ordPaymentList = ordReportPaymentService.queryOrderPayment(ordPaymentVO);
			for (OrdPaymentVO o : ordPaymentList) {
				o.setPayMethodName(payMap.get(o.getPayMethod()));
				// SysBusiConfig sysBusiConfig =
				// sysBusiConfigService.getByParamKey(o.getPayMethod(),
				// "payWay");
				// o.setPayMethod(sysBusiConfig.getName());
				/* payMentFund.put("payClass", sysBusiConfig.getName()); */
			}
			// List<OrdPaymentVO> ordPaymentList =
			// ordReportPaymentService.queryOrderPayment(ordPaymentVO);
			// 导出
			new ExportExcel(fileName, OrdPaymentVO.class).setDataList(ordPaymentList)
					.write(response, fileName + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx").dispose();
		} catch (IOException e) {
			result.setRetCode("999999");
			result.setRetMsg("导出失败");
			throw new RuntimeException("后台数据异常！");
		}
		return result;
	}

}
