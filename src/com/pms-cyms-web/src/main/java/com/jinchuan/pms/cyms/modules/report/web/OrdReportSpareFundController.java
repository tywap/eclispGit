package com.jinchuan.pms.cyms.modules.report.web;

import java.io.IOException;
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

import com.jinchuan.pms.cyms.modules.report.entity.OrdSpareFundVO;
import com.jinchuan.pms.cyms.modules.report.service.OrdReportSpareFundService;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.utils.DateUtils;
import com.jinchuan.pms.pub.common.utils.excel.ExportExcel;
import com.jinchuan.pms.pub.common.utils.excel.ExportExcelSuper;
import com.jinchuan.pms.pub.common.utils.excel.annotation.ExcelModalVO;
import com.jinchuan.pms.pub.common.utils.money.Money;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.entity.SysBusiConfig;
import com.jinchuan.pms.pub.modules.sys.service.SysBusiConfigService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 
 * @ClassName: OrdPaymentVO
 * @Description: 备用金变动明细查询
 * @author heyi
 * @date 2017年11月30日 下午5:01:05
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/report/ordSpareFund")
public class OrdReportSpareFundController extends BaseController {

	@Autowired
	private OrdReportSpareFundService ordReportSpareFundService;

	@Autowired
	private SysBusiConfigService sysBusiConfigService;

	// *****导出excel接口参数******
	Map<Integer, List<Object>> excelDatas;
	List<ExcelModalVO> excelMods;

	// *****导出excel接口参数******
	/**
	 * 
	 * @Title: 
	 * @Description: 备用金变动明细查询
	 * @author: heyi 
	 * String @throws
	 */
	@RequestMapping("/queryOrdSpareFund")
	public String queryOrdSpareFund(Model model, OrdSpareFundVO ordSpareFundVO) {
		String rentid = UserUtils.getUser().getRentId();
		ordSpareFundVO.setRentId(rentid);
		// 当查询所有数据的时候判断数据权限
		/*
		 * if (StringUtils.isEmpty(ordSpareFundVO.getStoreId())) {
		 * ordSpareFundVO.setAuthorityStoreId(UserUtils.getStoreCacheStr()); }
		 */
		ordSpareFundVO.setStoreId(UserUtils.getStoreId());
		if (ordSpareFundVO.getQueryType() == null || ordSpareFundVO.getQueryType() == "") {
			ordSpareFundVO.setQueryType("1");
			ordSpareFundVO.setStrTime(DateUtils.getDateBeFore());
			ordSpareFundVO.setEndTime(DateUtils.getDateBeFore());

			model.addAttribute("strTime", DateUtils.getDateBeFore());
			model.addAttribute("endTime", DateUtils.getDateBeFore());
		}
		SysBusiConfig sysBusiConfig = new SysBusiConfig();
		sysBusiConfig.setRentId(rentid);
		List<SysBusiConfig> payWayList = sysBusiConfigService.getByType("payWay");
		Map<String, String> payMap = new HashMap<String, String>();
		for (SysBusiConfig s : payWayList) {
			payMap.put(s.getParamKey(), s.getName());
		}
		List<OrdSpareFundVO> ordSpareFundList = ordReportSpareFundService.querySpareFund(ordSpareFundVO);
		Money amountSum = new Money("0");
		for (OrdSpareFundVO o : ordSpareFundList) {
			o.setPayMethodName(payMap.get(o.getPayMethod()));
			amountSum = amountSum.addTo(new Money(o.getAmount()));
		}
		/* List<Office> hotelList = UserUtils.getHotelList(); */
		// List<Office> hQList = UserUtils.getOfficeListByType("0");
		// hotelList.addAll(hQList);
		/* model.addAttribute("hotelList", hotelList); */
		model.addAttribute("ordSpareFundList", ordSpareFundList);
		model.addAttribute("amountSum", amountSum);
		model.addAttribute("totalCount", ordSpareFundList.size());
		return "modules/report/store/orderSpareFundQuery";
	}

	/**
	 * 
	 * @Title: 
	 * @Description: 备用金变动汇总查询
	 * @author: heyi 
	 * String @throws
	 */
	@RequestMapping("/querySpareFundSummary")
	public String querySpareFundSummary(Model model, OrdSpareFundVO ordSpareFundVO) {
		String rentid = UserUtils.getUser().getRentId();
		ordSpareFundVO.setRentId(rentid);
		// 当查询所有数据的时候判断数据权限
		/*
		 * if (StringUtils.isEmpty(ordSpareFundVO.getStoreId())) {
		 * ordSpareFundVO.setAuthorityStoreId(UserUtils.getStoreCacheStr()); }
		 */
		ordSpareFundVO.setStoreId(UserUtils.getStoreId());
		List<SysBusiConfig> payWayList = sysBusiConfigService.getByType("payWay");
		if (ordSpareFundVO.getQueryType() == null || ordSpareFundVO.getQueryType() == "") {
			ordSpareFundVO.setQueryType("1");
			ordSpareFundVO.setStrTime(DateUtils.getDateBeFore());
			ordSpareFundVO.setEndTime(DateUtils.getDateBeFore());

			model.addAttribute("strTime", DateUtils.getDateBeFore());
			model.addAttribute("endTime", DateUtils.getDateBeFore());
		}
		List<Map<String, Object>> ordSpareFundList = ordReportSpareFundService.querySpareFundSummary(ordSpareFundVO);
		/* List<Office> hotelList = UserUtils.getHotelList(); */
		/* model.addAttribute("hotelList", hotelList); */
		model.addAttribute("payWayList", payWayList);
		model.addAttribute("ordSpareFundList", ordSpareFundList);
		model.addAttribute("totalCount", ordSpareFundList.size());
		return "modules/report/store/orderSpareFundSummaryQuery";
	}

	@RequestMapping(value = "ExportExcel", method = RequestMethod.POST)
	@ResponseBody
	public ProcessResult ExportExcel(OrdSpareFundVO ordSpareFundVO, HttpServletRequest request,
			HttpServletResponse response, Model model, RedirectAttributes redirectAttributes) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			ordSpareFundVO.setStoreId(UserUtils.getStoreId());
			String rentid = UserUtils.getUser().getRentId();
			ordSpareFundVO.setRentId(rentid);
			// 当查询所有数据的时候判断数据权限
			/*
			 * if (StringUtils.isEmpty(ordSpareFundVO.getStoreId())) {
			 * ordSpareFundVO.setAuthorityStoreId(UserUtils.getStoreCacheStr());
			 * }
			 */
			String fileName = "备用金明细";
			// 收集数据
			SysBusiConfig sysBusiConfig = new SysBusiConfig();
			sysBusiConfig.setRentId(rentid);
			List<SysBusiConfig> payWayList = sysBusiConfigService.getByType("payWay");
			Map<String, String> payMap = new HashMap<String, String>();
			for (SysBusiConfig s : payWayList) {
				payMap.put(s.getParamKey(), s.getName());
			}
			List<OrdSpareFundVO> ordSpareFundList = ordReportSpareFundService.querySpareFund(ordSpareFundVO);
			for (OrdSpareFundVO o : ordSpareFundList) {
				o.setPayMethodName(payMap.get(o.getPayMethod()));
			}
			// 导出
			new ExportExcel(fileName, OrdSpareFundVO.class).setDataList(ordSpareFundList)
					.write(response, fileName + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx").dispose();
		} catch (IOException e) {
			result.setRetCode("999999");
			result.setRetMsg("导出失败");
			throw new RuntimeException("后台数据异常！");
		}
		return result;
	}

	@RequestMapping(value = "ExportExcelSummary", method = RequestMethod.POST)
	@ResponseBody
	public ProcessResult ExportExcelSummary(Model model, OrdSpareFundVO ordSpareFundVO, HttpServletResponse response) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		// 初始化excel导出接口参数
		initialExportData();
		List<SysBusiConfig> payWayList = sysBusiConfigService.getByType("payWay");
		List<String> singleTitleList = new ArrayList<String>();
		singleTitleList.add("酒店");
		for (SysBusiConfig t : payWayList) {
			if (!t.getParamKey().equals("7")) {
				singleTitleList.add(t.getName());
			}
		}
		singleTitleList.add("合计");

		// 查询参数
		ordSpareFundVO.setRentId(UserUtils.getUser().getRentId());
		ordSpareFundVO.setStoreId(UserUtils.getStoreId());
		try {
			// 组装标题
			int titleColLength[] = new int[] { 1 };
			ExportExcelSuper.fillTitles(excelMods, singleTitleList.toArray(new String[singleTitleList.size()]), null,
					titleColLength);
			// 钱箱周转
			List<Map<String, Object>> ordSpareFundList = ordReportSpareFundService
					.querySpareFundSummary(ordSpareFundVO);
			int i = 0;// excel扫描的map-key值，自增长
			List<Object> dataList = new ArrayList<>();
			for (Map<String, Object> m : ordSpareFundList) {
				dataList.add(m.get("hotelName"));
				for (SysBusiConfig t : payWayList) {
					if (!t.getParamKey().equals("7")) {
						dataList.add(m.get(t.getParamKey()));
					}
				}
				dataList.add(m.get("totalMoney"));
				excelDatas.put(i, dataList);
				i++;
			}
			// 导出
			String fileName = "备用金变动汇总" + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";
			new ExportExcelSuper().init2LevelTitleAndSetdata("备用金变动汇总", excelMods, excelDatas,
					ExportExcelSuper.EXPORT_NO_TOTAL, 1, null).write(response, fileName).dispose();
		} catch (Exception e) {
			result.setRetCode("500");
			result.setRetMsg("导出失败");
			throw new RuntimeException("后台数据异常！");
		}
		return result;
	}

	private void initialExportData() {
		excelDatas = new LinkedHashMap<Integer, List<Object>>();
		excelMods = new ArrayList<ExcelModalVO>();
	}

}
