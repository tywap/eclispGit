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

import com.jinchuan.pms.cyms.modules.report.entity.CollectionQueryReportVO;
import com.jinchuan.pms.cyms.modules.report.service.CollectionQueryReportService;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.utils.DateUtils;
import com.jinchuan.pms.pub.common.utils.ObjectUtils;
import com.jinchuan.pms.pub.common.utils.StringUtils;
import com.jinchuan.pms.pub.common.utils.excel.ExportExcelSuper;
import com.jinchuan.pms.pub.common.utils.excel.annotation.ExcelModalVO;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.entity.Office;
import com.jinchuan.pms.pub.modules.sys.entity.PubShiftConfig;
import com.jinchuan.pms.pub.modules.sys.entity.SysBusiConfig;
import com.jinchuan.pms.pub.modules.sys.service.PubShiftConfigService;
import com.jinchuan.pms.pub.modules.sys.service.SysBusiConfigService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 
 * @ClassName: OrdReserve
 * @Description: 收银汇总
 * @author heyi
 * @date 2017年12月19日 下午5:01:05
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/report/collection")
public class CollectionReportController extends BaseController {

	@Autowired
	private CollectionQueryReportService collectionReportService;

	@Autowired
	private PubShiftConfigService pubShiftConfigService;
	@Autowired
	SysBusiConfigService sysBusiConfigService;
	// *****导出Excel接口参数******
	Map<Integer, List<Object>> excelDatas;
	List<ExcelModalVO> excelMods;
	// *****导出Excel接口参数******

	/**
	 * @Title: 
	 * @Description: 收银汇总
	 * @author: heyi 
	 * String @throws
	 */
	@RequestMapping("/queryCollectionReport")
	public String queryCmGoupReport(Model model, CollectionQueryReportVO collectionReportVO) {
		Map<String, Object> dataMap = new HashMap<>();
		String rentid = UserUtils.getUser().getRentId();
		dataMap.put("rentId", rentid);
		collectionReportVO.setRentId(rentid);
		// 获取班次信息
		PubShiftConfig pubShiftConfig = new PubShiftConfig();
		pubShiftConfig.setRentId(rentid);
		pubShiftConfig.setStatus("1");
		List<PubShiftConfig> shiftList = pubShiftConfigService.findList(pubShiftConfig);
		List<SysBusiConfig> dataList = sysBusiConfigService.getByType("payWay");
		/*
		 * if (collectionReportVO.getShiftId() != null &&
		 * collectionReportVO.getShiftId() != "") {
		 * 
		 * }
		 */
		// if (collectionReportVO.getSelectid() == null ||
		// collectionReportVO.getSelectid() == "")

		if (StringUtils.isNotEmpty(collectionReportVO.getStoreId())) {
			dataMap.put("storeId", collectionReportVO.getStoreId());
		} else {
			dataMap.put("authorityStoreId", UserUtils.getStoreCacheStr());
		}
		if (collectionReportVO.getStrTime() != null && collectionReportVO.getStrTime() != "") {
			/*
			 * collectionReportVO.setStrTime(DateUtils.getDateBeFore());
			 * collectionReportVO.setEndTime(DateUtils.getDateBeFore());
			 */
			/*
			 * dataMap.put("strTime", DateUtils.getDateBeFore());
			 * dataMap.put("endTime", DateUtils.getDateBeFore());
			 */
			dataMap.put("shiftId", collectionReportVO.getShiftId());
			dataMap.put("selectid", collectionReportVO.getSelectid());
			dataMap.put("strTime", collectionReportVO.getStrTime());
			dataMap.put("endTime", collectionReportVO.getEndTime());
			dataMap.put("startdate", collectionReportVO.getStartdate());
			dataMap.put("enddate", collectionReportVO.getEnddate());
			List<Map<String, Object>> dataMapList = collectionReportService.queryCollectionCount(dataMap);

			double guestDeposit = 0;// 住客押金
			double guestCheckOut = 0;// 住客结账
			double unGuestCheckOut = 0;// 非住客账
			double orderDeposit = 0;// 预定订金
			double numberCard = 0;// 会员发卡
			double numberUp = 0;// 会员升级
			double numberRecharge = 0;// 会员充值
			double numberBackCard = 0;// 会员退卡
			double borrowDeposit = 0; // 借物押金
			double advanceUnit = 0;// 单位预交
			double settleMent = 0;// 挂账结算
			for (int i = 0; i < dataMapList.size(); i++) {
				Map<String, Object> m = dataMapList.get(i);
				if (m != null && m.get("guestDeposit") != null && m.get("guestDeposit") != "") {
					guestDeposit = guestDeposit + Double.parseDouble(String.valueOf(m.get("guestDeposit")));
				}
				if (m != null && m.get("guestCheckOut") != null && m.get("guestCheckOut") != "") {
					guestCheckOut = guestCheckOut + Double.parseDouble(String.valueOf(m.get("guestCheckOut")));
				}
				if (m != null && m.get("unGuestCheckOut") != null && m.get("unGuestCheckOut") != "") {
					unGuestCheckOut = unGuestCheckOut + Double.parseDouble(String.valueOf(m.get("unGuestCheckOut")));
				}
				if (m != null && m.get("orderDeposit") != null && m.get("orderDeposit") != "") {
					orderDeposit = orderDeposit + Double.parseDouble(String.valueOf(m.get("orderDeposit")));
				}
				if (m != null && m.get("numberCard") != null && m.get("numberCard") != "") {
					numberCard = numberCard + Double.parseDouble(String.valueOf(m.get("numberCard")));
				}
				if (m != null && m.get("numberUp") != null && m.get("numberUp") != "") {
					numberUp = numberUp + Double.parseDouble(String.valueOf(m.get("numberUp")));
				}
				if (m != null && m.get("numberRecharge") != null && m.get("numberRecharge") != "") {
					numberRecharge = numberRecharge + Double.parseDouble(String.valueOf(m.get("numberRecharge")));
				}
				if (m != null && m.get("numberBackCard") != null && m.get("numberBackCard") != "") {
					numberBackCard = numberBackCard + Double.parseDouble(String.valueOf(m.get("numberBackCard")));
				}
				if (m != null && m.get("borrowDeposit") != null && m.get("borrowDeposit") != "") {
					borrowDeposit = borrowDeposit + Double.parseDouble(String.valueOf(m.get("borrowDeposit")));
				}
				if (m != null && m.get("advanceUnit") != null && m.get("advanceUnit") != "") {
					advanceUnit = advanceUnit + Double.parseDouble(String.valueOf(m.get("advanceUnit")));
				}
				if (m != null && m.get("settleMent") != null && m.get("settleMent") != "") {
					settleMent = settleMent + Double.parseDouble(String.valueOf(m.get("settleMent")));
				}
			}
			model.addAttribute("dataMapList", dataMapList);

			model.addAttribute("guestDeposit", guestDeposit);
			model.addAttribute("guestCheckOut", guestCheckOut);
			model.addAttribute("unGuestCheckOut", unGuestCheckOut);
			model.addAttribute("orderDeposit", orderDeposit);
			model.addAttribute("numberCard", numberCard);
			model.addAttribute("numberUp", numberUp);
			model.addAttribute("numberRecharge", numberRecharge);
			model.addAttribute("numberBackCard", numberBackCard);
			model.addAttribute("borrowDeposit", borrowDeposit);
			model.addAttribute("advanceUnit", advanceUnit);
			model.addAttribute("settleMent", settleMent);
			double totalMoney = 0;
			List<Map<String, Object>> moneyMapList = collectionReportService.queryCollectionCountByPayWay(dataMap);
			for (Map<String, Object> m : moneyMapList) {
				if (m.get("amount") != null)
					totalMoney = totalMoney + Double.valueOf(ObjectUtils.toString(m.get("amount")));
			}
			model.addAttribute("moneyMapList", moneyMapList);
			model.addAttribute("totalMoney", totalMoney);
		} else {
			model.addAttribute("strTime", DateUtils.getDateBeFore());
			model.addAttribute("endTime", DateUtils.getDateBeFore());
		}

		List<Office> hotelList = UserUtils.getHotelList();
		List<Office> hQList = UserUtils.getOfficeListByType("0");
		hotelList.addAll(hQList);
		model.addAttribute("hotelList", hotelList);
		model.addAttribute("shiftList", shiftList);
		model.addAttribute("dataList", dataList);
		return "modules/report/queryCollectionReport";
	}

	// 导出：收银汇总
	@RequestMapping(value = "ExportExcel", method = RequestMethod.POST)
	@ResponseBody
	public ProcessResult ExportExcel(CollectionQueryReportVO collectionReportVO, HttpServletRequest request,
			HttpServletResponse response, Model model, RedirectAttributes redirectAttributes) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		// 初始化excel导出接口参数
		initialExportData();
		// 组装标题
		int titleColLength[] = new int[] { 1 };
		// 标题组头及子标题
		List<String> singleTitleList = new ArrayList<String>();
		List<SysBusiConfig> payWayList = sysBusiConfigService.getByType("payWay");
		singleTitleList.add("类型");
		for (SysBusiConfig t : payWayList) {
			if (!t.getParamKey().equals("7")) {
				singleTitleList.add(t.getName());
			}
		}
		singleTitleList.add("合计");
		// String[] singleTitles = new String[] { "类型", "现金", "银行卡", "微信",
		// "支付宝", "储值卡", "挂账", "预授权", "减免", "单位预交",
		// "微信网上支付", "支付宝网上支付" };
		// 0-住客押金,1-住客结账,2-非住客结,3-非住客结,4-预订订金,5-会员发卡,6-会员升级,7-会员充值,8-会员退卡,9-借物押金,10-单位预交,11-挂账结算
		String[] sortRowKeys = new String[] { "guestDeposit", "guestCheckOut", "unGuestCheckOut", "orderDeposit",
				"numberCard", "numberUp", "numberRecharge", "numberBackCard", "borrowDeposit", "advanceUnit",
				"settleMent", "amount" };
		String[] firstColVals = new String[] { "住客押金", "住客结账", "非住客结", "预订订金", "会员发卡", "会员升级", "会员充值", "会员退卡", "借物押金",
				"单位预交", "挂账结算", "小计" };
		List<Object> sortRowList = new ArrayList<Object>();
		// 查询参数
		Map<String, Object> dataMap = new HashMap<>();
		String rentid = UserUtils.getUser().getRentId();
		dataMap.put("rentId", rentid);
		collectionReportVO.setRentId(rentid);
		try {
			// 组装标题
			// ExportExcelSuper.fillTitles(excelMods, singleTitles);
			ExportExcelSuper.fillTitles(excelMods, singleTitleList.toArray(new String[singleTitleList.size()]), null,
					titleColLength);
			dataMap.put("strTime", collectionReportVO.getStrTime());
			dataMap.put("endTime", collectionReportVO.getEndTime());
			dataMap.put("startdate", collectionReportVO.getStartdate());
			dataMap.put("enddate", collectionReportVO.getEnddate());
			dataMap.put("selectid", collectionReportVO.getSelectid());
			if (collectionReportVO.getStoreId() != null && collectionReportVO.getStoreId() != "") {
				dataMap.put("storeId", collectionReportVO.getStoreId());
			} else {
				dataMap.put("authorityStoreId", UserUtils.getStoreCacheStr());
			}
			if (collectionReportVO.getShiftId() != null && collectionReportVO.getShiftId() != "") {
				dataMap.put("shiftId", collectionReportVO.getShiftId());
			}
			List<Map<String, Object>> dataMapList = collectionReportService.queryCollectionCount(dataMap);
			double totalMoney = 0; // 小计
			// 先扫行
			for (int row = 0; row < sortRowKeys.length; row++) {
				sortRowList.add(firstColVals[row]);
				// 再扫列
				if (!sortRowKeys[row].equals("amount")) {
					double totalval = 0.00;
					for (int col = 0; col < dataMapList.size(); col++) {
						Map<String, Object> mapObj = dataMapList.get(col);
						Object val = mapObj == null ? 0 : mapObj.get(sortRowKeys[row]);
						val = val == null ? 0 : val;
						sortRowList.add(val);
						totalval = totalval + Double.valueOf(ObjectUtils.toString(val));
					}
					sortRowList.add(totalval);
				} else {
					List<Map<String, Object>> moneyMapList = collectionReportService
							.queryCollectionCountByPayWay(dataMap);
					for (Map<String, Object> m : moneyMapList) {
						sortRowList.add(m.get("amount") == null ? "0.00" : m.get("amount"));
						if (m.get("amount") != null) {
							totalMoney = totalMoney + Double.valueOf(ObjectUtils.toString(m.get("amount")));
						}
					}
					sortRowList.add(totalMoney);
				}
				excelDatas.put(row, sortRowList);
				sortRowList = new ArrayList<Object>();
			}
			// 导出
			String fileName = "收银汇总" + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";
			new ExportExcelSuper()
					.init2LevelTitleAndSetdata("收银汇总", excelMods, excelDatas, ExportExcelSuper.EXPORT_NO_TOTAL, 2, null)
					.write(response, fileName).dispose();
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
