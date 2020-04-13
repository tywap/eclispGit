package com.jinchuan.pms.cyms.modules.report.web;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.jinchuan.pms.cyms.modules.order.enums.OrdStatusEnum;
import com.jinchuan.pms.cyms.modules.report.entity.ReserveReportVO;
import com.jinchuan.pms.cyms.modules.report.service.ReserveReportService;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.utils.DateUtils;
import com.jinchuan.pms.pub.common.utils.StringUtils;
import com.jinchuan.pms.pub.common.utils.excel.ExportExcel;
import com.jinchuan.pms.pub.common.utils.money.Money;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

@Controller
@RequestMapping(value = "${adminPath}/reserve/Reserve")
public class ReserveReportController {

	@Autowired
	private ReserveReportService reserveService;

	@RequestMapping("/query")
	public String query(Model model, String hotelId, String orderS, Integer selectid, String selectVal) {
		String rentid = UserUtils.getUser().getRentId();
		model.addAttribute("HOTELNAME", UserUtils.getHotelList());
		model.addAttribute("OS", OrdStatusEnum.getList());
		model.addAttribute("backselectid", selectid);
		model.addAttribute("backselectVal", selectVal);
		model.addAttribute("backorderS", orderS);
		model.addAttribute("hotelId", hotelId);
		model.addAttribute("backorderstatus", orderS);
		// 当查询所有数据的时候判断数据权限
		String authorityStoreId = null;
		if (StringUtils.isEmpty(hotelId)) {
			authorityStoreId = UserUtils.getStoreCacheStr();
		}
		model.addAttribute("MC",
				reserveService.moneyTote(rentid, hotelId, orderS, selectid, selectVal, authorityStoreId));
		model.addAttribute("MC2",
				reserveService.moneyTote2(rentid, hotelId, orderS, selectid, selectVal, authorityStoreId));
		List<ReserveReportVO> list = reserveService.query(rentid, hotelId, orderS, selectid, selectVal, authorityStoreId);
		Money opdcount = new Money("0");
		for (ReserveReportVO data : list) {
			opdcount = opdcount.addTo(data.getDepositamount());
		}
		model.addAttribute("totalList", list.size());
		model.addAttribute("opdcount", opdcount);
		model.addAttribute("DATA", list);
		return "modules/report/store/reserveQuery";
	}

	@RequestMapping(value = "ExportRepairExcel", method = RequestMethod.POST)
	public ProcessResult ExportRepairExcel(String hotelId, String orderS, Integer selectid, String selectVal,
			HttpServletRequest request, HttpServletResponse response, Model model,
			RedirectAttributes redirectAttributes) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String fileName = "订金余额" + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";
			String rentid = UserUtils.getUser().getRentId();
			// 当查询所有数据的时候判断数据权限
			String authorityStoreId = null;
			if (StringUtils.isEmpty(hotelId)) {
				authorityStoreId = UserUtils.getStoreCacheStr();
			}
			List<ReserveReportVO> list = reserveService.query(rentid, hotelId, orderS, selectid, selectVal, authorityStoreId);
			new ExportExcel("订金余额", ReserveReportVO.class).setDataList(list).write(response, fileName).dispose();
		} catch (IOException e) {
			result.setRetCode("999999");
			result.setRetMsg("导出失败");
		}
		return result;
	}
}
