package com.jinchuan.pms.cyms.modules.report.web;

import java.io.IOException;
import java.util.Date;
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

import com.jinchuan.pms.cyms.modules.report.entity.PubShiftVO;
import com.jinchuan.pms.cyms.modules.report.service.PubShiftReportService;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.utils.DateUtils;
import com.jinchuan.pms.pub.common.utils.excel.ExportExcel;
import com.jinchuan.pms.pub.modules.sys.entity.PubShift;
import com.jinchuan.pms.pub.modules.sys.service.PubShiftService;
import com.jinchuan.pms.pub.modules.sys.service.SystemService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

@Controller
@RequestMapping("/${adminPath}/report/pubShift")
public class PubShiftReportController {

	@Autowired
	private PubShiftReportService pubShiftReportService;
	@Autowired
	private PubShiftService pubShiftService;
	@Autowired
	private SystemService systemService;

	@RequestMapping("/query")
	public String query(HttpServletRequest request, HttpServletResponse response, PubShiftVO pubShiftVO, Model model) {
		String rentId = UserUtils.getUser().getRentId();
		String storeId = request.getParameter("storeId");
		pubShiftVO.setRentId(rentId);
		if (pubShiftVO.getShiftStrTime() == null || pubShiftVO.getShiftStrTime() == "") {
			pubShiftVO.setShiftStrTime(DateUtils.getDateBeFore() + " 00:00");
			pubShiftVO.setShiftEndTime(DateUtils.getDateBeFore() + " 23:59");

			model.addAttribute("shiftStrTime", DateUtils.getDateBeFore() + " 00:00");
			model.addAttribute("shiftEndTime", DateUtils.getDateBeFore() + " 23:59");
		}
		List<PubShiftVO> dataList = pubShiftReportService.queryPubShiftReport(pubShiftVO);
		// 获取班次信息
		PubShift pubShift = new PubShift();
		pubShift.setStoreId(storeId);
		pubShift.setRentId(rentId);
		pubShift.setStatus(pubShift.SHIFT_STATUS_ON);
		List<PubShift> shiftList = pubShiftService.findList(pubShift);
		// 获取交班用户
		List<Map<String, String>> closeNameList = pubShiftReportService.queryShifgCloseName(pubShiftVO);

		// 获取接班用户
		List<Map<String, String>> receiveNameList = pubShiftReportService.queryShifgReceiveName(pubShiftVO);
		// List<User> userList = systemService.getUserByCompanyId(storeId,
		// rentId);
		model.addAttribute("dataList", dataList);
		model.addAttribute("shiftList", shiftList);
		model.addAttribute("closeNameList", closeNameList);
		model.addAttribute("receiveNameList", receiveNameList);
		return "modules/report/store/pubShiftQuery";
	}

	@RequestMapping(value = "ExportExcel", method = RequestMethod.POST)
	@ResponseBody
	public ProcessResult ExportExcel(PubShiftVO pubShiftVO, HttpServletRequest request, HttpServletResponse response,
			Model model, RedirectAttributes redirectAttributes) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			pubShiftVO.setStoreId(UserUtils.getStoreId());
			String rentid = UserUtils.getUser().getRentId();
			pubShiftVO.setRentId(rentid);
			String fileName = "交接班记录";
			// 收集数据
			List<PubShiftVO> dataList = pubShiftReportService.queryPubShiftReport(pubShiftVO);
			// 导出
			for (PubShiftVO pubShiftVO2 : dataList) {
				pubShiftVO2.setShiftCloseDate(DateUtils.parseDate(pubShiftVO2.getShiftCloseDate()));
			}
			new ExportExcel(fileName, PubShiftVO.class).setDataList(dataList)
					.write(response, fileName + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx").dispose();
		} catch (IOException e) {
			result.setRetCode("999999");
			result.setRetMsg("导出失败");
			throw new RuntimeException("后台数据异常！");
		}
		return result;
	}

}
