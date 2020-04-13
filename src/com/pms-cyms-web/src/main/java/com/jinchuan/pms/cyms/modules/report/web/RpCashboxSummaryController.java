package com.jinchuan.pms.cyms.modules.report.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
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

import com.jinchuan.pms.cyms.modules.report.entity.RpCashboxSummaryVO;
import com.jinchuan.pms.cyms.modules.report.service.RpCashboxSummaryService;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.utils.DateUtils;
import com.jinchuan.pms.pub.common.utils.SysBusiConfigUtils;
import com.jinchuan.pms.pub.common.utils.excel.ExportExcelSuper;
import com.jinchuan.pms.pub.common.utils.excel.annotation.ExcelModalVO;
import com.jinchuan.pms.pub.modules.sys.entity.SysBusiConfig;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

@Controller
@RequestMapping("/${adminPath}/Rpcashbox/Summary")
public class RpCashboxSummaryController {
	@Autowired
	private RpCashboxSummaryService rpCashboxSummaryService;

	@RequestMapping("/query")
	public String query(RpCashboxSummaryVO rpCashboxSummaryVO, Model model, String hotelId, String id) {
		String rentid = UserUtils.getUser().getRentId();
		model.addAttribute("HOTELNAME", UserUtils.getHotelList());
		rpCashboxSummaryVO.setRentId(rentid);

		if (rpCashboxSummaryVO.getAccountDate() == null || rpCashboxSummaryVO.getAccountDate() == "") {
			rpCashboxSummaryVO.setAccountDate(DateUtils.getDateBeFore());
			model.addAttribute("accountDate", DateUtils.getDateBeFore());
		} else {
			model.addAttribute("accountDate", rpCashboxSummaryVO.getAccountDate());
		}
		// HtlStore htlStore=new HtlStore();
		// htlStore.setRentId(rentid);
		// htlStore.setId(rpCashboxSummaryVO.getStoreId());
		List<RpCashboxSummaryVO> list = rpCashboxSummaryService.query(rpCashboxSummaryVO);
		List<SysBusiConfig> querystoreId = SysBusiConfigUtils.getSysBusiConfigList("payWay", "1");
		// List<HtlStore> listhtlStore =
		// htlStoreService.queryHtlstore(htlStore);
		List<RpCashboxSummaryVO> listsumm = rpCashboxSummaryService.queryRpsummary(rpCashboxSummaryVO);
		if (listsumm.size() > 0) {
			List<RpCashboxSummaryVO> listhtlStore = new ArrayList<RpCashboxSummaryVO>();
			for (RpCashboxSummaryVO r : listsumm) {
				rpCashboxSummaryVO.setStoreId(r.getStoreId());
				RpCashboxSummaryVO summ = rpCashboxSummaryService.selectrpsummary(rpCashboxSummaryVO);
				listhtlStore.add(summ);
			}
			// List<RpCashboxSummaryVO> listhtlStore =
			// rpCashboxSummaryService.selectrpsummary(rpCashboxSummaryVO);
			model.addAttribute("listhtlStore", listhtlStore);
		}
		model.addAttribute("querylist", list);
		model.addAttribute("querystoreId", querystoreId);
		model.addAttribute("hotelId", hotelId);
		model.addAttribute("backid", id);
		return "modules/report/store/RpCashboxSummary";
	}

	@RequestMapping(value = "ExportRepairExcel", method = RequestMethod.POST)
	@ResponseBody
	public ProcessResult ExportRepairExcel(RpCashboxSummaryVO rpCashboxSummaryVO, String hotelId, String id,
			HttpServletRequest request, HttpServletResponse response, Model model,
			RedirectAttributes redirectAttributes) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		String rentid = UserUtils.getUser().getRentId();
		rpCashboxSummaryVO.setRentId(rentid);
		if (rpCashboxSummaryVO.getAccountDate() == null || rpCashboxSummaryVO.getAccountDate() == "") {
			rpCashboxSummaryVO.setAccountDate(DateUtils.getDateBeFore());
			model.addAttribute("accountDate", DateUtils.getDateBeFore());
		} else {
			model.addAttribute("accountDate", rpCashboxSummaryVO.getAccountDate());
		}
		// 初始化excel导出接口参数
		initialExportData();
		// 组装标题
		int titleColLength[] = new int[] { 1 };
		// 标题组头及子标题
		List<String> singleTitleList = new ArrayList<String>();
		List<SysBusiConfig> querystoreId = SysBusiConfigUtils.getSysBusiConfigList("payWay", "1");
		singleTitleList.add("门店");
		for (SysBusiConfig s : querystoreId) {
			singleTitleList.add(s.getName());
		}
		singleTitleList.add("余额小计");
		// 组装行数据
		List<Object> sortDataList = new ArrayList<Object>();
		try {
			Map<Integer, List<Object>> excelDatas = new HashMap<>();
			List<ExcelModalVO> excelMods = new ArrayList<ExcelModalVO>();
			// ExportExcelSuper.fillTitles(excelMods, singleTitleList);
			ExportExcelSuper.fillTitles(excelMods, singleTitleList.toArray(new String[singleTitleList.size()]), null,
					titleColLength);
			String fileName = "钱箱余额表" + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";
			List<RpCashboxSummaryVO> list = rpCashboxSummaryService.query(rpCashboxSummaryVO);
			List<RpCashboxSummaryVO> listsumm = rpCashboxSummaryService.queryRpsummary(rpCashboxSummaryVO);
			double j = 0.00;// 小计
			double balance = 0.00;// 小计余额总计
			double subtotal = 0.00;// 余额小计
			int k = 0;
			List<RpCashboxSummaryVO> listhtlStore = new ArrayList<RpCashboxSummaryVO>();// 查询门店个数
			for (RpCashboxSummaryVO rp : listsumm) {
				rpCashboxSummaryVO.setStoreId(rp.getStoreId());
				RpCashboxSummaryVO summ = rpCashboxSummaryService.selectrpsummary(rpCashboxSummaryVO);
				listhtlStore.add(summ);
			}
			for (RpCashboxSummaryVO r : listhtlStore) {
				sortDataList.add(r.getStoreName());
				for (SysBusiConfig s : querystoreId) {
					for (RpCashboxSummaryVO rpca : list) {
						if (rpca.getStoreId().equals(r.getId())) {
							if (rpca.getPayClass().equals(s.getParamKey())) {
								sortDataList.add(rpca.getMoney());
								subtotal = subtotal + Double.parseDouble(rpca.getMoney());
							}
						}
					}
				}
				sortDataList.add(subtotal);
				excelDatas.put(k, sortDataList);
				sortDataList = new ArrayList<Object>();
				subtotal = 0.00;
				k++;
			}
			sortDataList.add("合计");
			for (SysBusiConfig s : querystoreId) {
				for (RpCashboxSummaryVO rp : list) {
					if (s.getParamKey().equals(rp.getPayClass())) {
						j = j + Double.parseDouble(rp.getMoney());
						balance = balance + Double.parseDouble(rp.getMoney());
					}
				}
				sortDataList.add(j);
				j = 0.00;
			}
			sortDataList.add(balance);
			excelDatas.put(k, sortDataList);
			new ExportExcelSuper().init2LevelTitleAndSetdata("钱箱余额表", excelMods, excelDatas,
					ExportExcelSuper.EXPORT_NO_TOTAL, 2, null).write(response, fileName).dispose();
		} catch (Exception e) {
			result.setRetCode("500");
			result.setRetMsg("导出失败");
			throw new RuntimeException("后台数据异常！");
		}

		return result;
	}

	private void initialExportData() {
	}

}
