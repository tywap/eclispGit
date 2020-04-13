/**
 *
 */
package com.jinchuan.pms.cyms.modules.report.web;

import java.util.ArrayList;
import java.util.Arrays;
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

import com.jinchuan.pms.cyms.modules.order.entity.OrdPaymentFund;
import com.jinchuan.pms.cyms.modules.order.service.OrdPaymentFundService;
import com.jinchuan.pms.cyms.modules.report.entity.OrdCashBoxVO;
import com.jinchuan.pms.cyms.modules.report.service.OrdCashBoxReportService;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.utils.DateUtils;
import com.jinchuan.pms.pub.common.utils.excel.ExportExcelSuper;
import com.jinchuan.pms.pub.common.utils.excel.annotation.ExcelModalVO;
import com.jinchuan.pms.pub.modules.sys.entity.PubShift;
import com.jinchuan.pms.pub.modules.sys.entity.SysBusiConfig;
import com.jinchuan.pms.pub.modules.sys.entity.User;
import com.jinchuan.pms.pub.modules.sys.service.PubShiftService;
import com.jinchuan.pms.pub.modules.sys.service.SysBusiConfigService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 钱箱汇总Controller
 * @author heyi
 * @version 2018-4-28
 */
@Controller
@RequestMapping(value = "${adminPath}/report/ordCashbox")
public class OrdCashBoxReportController {

	@Autowired
	private OrdCashBoxReportService ordCashBoxReportService;

	@Autowired
	private PubShiftService pubShiftService;

	@Autowired
	OrdPaymentFundService ordPaymentFundService;

	@Autowired
	SysBusiConfigService sysBusiConfigService;

	// *****导出excel接口参数******
	Map<Integer, List<Object>> excelDatas;
	List<ExcelModalVO> excelMods;
	// *****导出excel接口参数******

	@RequestMapping("/query")
	public String query(HttpServletRequest request, HttpServletResponse response, Model model) {
		String rentId = UserUtils.getUser().getRentId();
		String storeId = request.getParameter("storeId");
		String shiftId = request.getParameter("shiftId");
		List<PubShift> shiftList = pubShiftService.queryStoreShift(UserUtils.getStoreId(),
				UserUtils.getUser().getRentId());
		// PayMethodEnum[] payMethodEnm = PayMethodEnum.values();// 支付方式
		List<SysBusiConfig> payWayList = sysBusiConfigService.getByType("payWay");
		// 钱箱汇总
		User user = new User();
		user.setRentId(rentId);
		user.setCompanyId(storeId);
		List<OrdPaymentFund> userList = ordPaymentFundService.queryUserName(shiftId);

		OrdCashBoxVO ordCashBoxVO = new OrdCashBoxVO();
		ordCashBoxVO.setRentId(rentId);
		ordCashBoxVO.setStoreId(storeId);
		ordCashBoxVO.setShiftId(shiftId);
		List<Map<String, Object>> ordCashBoxTotal = ordCashBoxReportService.queryOrdCashBoxReport(ordCashBoxVO);
		// Map<String, Object> ordCashBoxTotal1 =new LinkedHashMap<>();
		List<Map<String, Object>> totalList = new ArrayList<>();
		// 钱箱小计
		Double spareDownTotal = 0.0;// 备用金
		Double spareUpTotal = 0.0;// 上缴
		Double preTransferTotal = 0.0;// 上班转入
		Double changeMoneyTotal = 0.0;// 交接下班
		Map<String, Object> totalMap = ordCashBoxReportService.queryOrdCashBoxTotal(ordCashBoxVO);
		for (Map<String, Object> m : ordCashBoxTotal) {
			String payCode = String.valueOf(m.get("payMethod"));
			Map<String, Object> map = new HashMap<String, Object>();
			Double spareDown = Double.parseDouble(String.valueOf(m.get("spareDown")));
			spareDownTotal = spareDownTotal + spareDown;
			Double spareUp = Double.parseDouble(String.valueOf(m.get("spareUp")));
			spareUpTotal = spareUpTotal + spareUp;
			Double preTransfer = Double.parseDouble(String.valueOf(m.get("preTransfer")));
			preTransferTotal = preTransferTotal + preTransfer;
			Double changeMoney = Double.parseDouble(String.valueOf(m.get("changeMoney")))
					+ Double.parseDouble(String.valueOf(m.get("spareDown")))
					+ Double.parseDouble(String.valueOf(m.get("preTransfer")));
			changeMoneyTotal = changeMoneyTotal + changeMoney;
			map.put(payCode, spareDown + spareUp + preTransfer + changeMoney);
			totalList.add(map);

		}
		// 该代码主要是为了界面显示问题
		if (ordCashBoxTotal.size() < 1) {
			for (int i = 0; i < payWayList.size(); i++) {
				SysBusiConfig d = payWayList.get(i);
				if (!"7".equals(d.getParamKey())) {
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("spareUp", "");
					map.put("preTransfer", "");
					map.put("spareDown", "");
					ordCashBoxTotal.add(map);
				}
			}
		}
		if (ordCashBoxTotal.size() < payWayList.size() - 1) {
			Map<String, Object> map2 = new HashMap<String, Object>();
			map2.put("payCode", "14");
			map2.put("changeMoney", "0.00");
			map2.put("spareUp", "0.00");
			map2.put("preTransfer", "0.00");
			map2.put("spareDown", "0.00");
			ordCashBoxTotal.add(12, map2);
		}

		// 收银汇总
		List<Map<String, Object>> payMentTotal = ordCashBoxReportService.queryPaymentInfo(ordCashBoxVO);
		model.addAttribute("totalList", totalList);
		model.addAttribute("ordCashBoxTotal", ordCashBoxTotal);
		model.addAttribute("shiftList", shiftList);
		model.addAttribute("payWayList", payWayList);
		model.addAttribute("payMentTotal", payMentTotal);
		model.addAttribute("spareDownTotal", spareDownTotal);
		model.addAttribute("spareUpTotal", spareUpTotal);
		model.addAttribute("preTransferTotal", preTransferTotal);
		model.addAttribute("changeMoneyTotal", changeMoneyTotal);
		model.addAttribute("userList", userList);
		model.addAttribute("shiftId", shiftId);
		model.addAttribute("totalMap", totalMap);
		return "modules/report/store/orderCashBoxShiftsForm";
	}

	@RequestMapping(value = "ExportExcel", method = RequestMethod.POST)
	public ProcessResult ExportExcel(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		String rentId = UserUtils.getUser().getRentId();
		String storeId = request.getParameter("storeId");
		String shiftId = request.getParameter("shiftId");
		// 初始化excel导出接口参数
		initialExportData();
		// 标题组头及子标题
		// Map<String, List<String>> groupTitleMaps=new LinkedHashMap<String,
		// List<String>>();
		// Map<Integer,String> singleTitleMaps = new
		// LinkedHashMap<Integer,String>();
		// Map<Integer,Integer> titleRowLengthMaps = new
		// LinkedHashMap<Integer,Integer>();
		// 标题名
		List<SysBusiConfig> payWayList = sysBusiConfigService.getByType("payWay");
		// PayMethodEnum[] payMethodEnm = PayMethodEnum.values();//
		// 支付方式(根据支付方式动态取标题头）
		List<String> singleTitleList = new ArrayList<String>();
		singleTitleList.add("类型");
		for (SysBusiConfig t : payWayList) {
			if (!t.getParamKey().equals("7")) {
				singleTitleList.add(t.getName());
			}
		}
		singleTitleList.add("合计");
		// String[] singleTitles = new String[]
		// {"类型","现金","银行卡","微信扫码支付","支付宝扫码支付","储值卡"," 挂账",
		// "预授权","减免","单位预交","微信网上支付","支付宝网上支付","合计"};
		int titleColLength[] = new int[] { 2 };
		// 钱箱周转、实收
		String[] colPart1 = new String[] { "spareDown_备用金", "preTransfer_上班转入", "spareUp_本班上缴" };// 钱箱周转
		String[] colPart2 = new String[] { "guestDeposit_住客押金", "guestCheckOut_住客结账", "orderDeposit_预订订金",
				"unGuestCheckOut_非住客账", "numberCard_会员发卡", "numberRecharge_会员充值", "numberUp_会员升级",
				"numberBackCard_会员退卡", "advanceUnit_单位预交", "settleMent_挂账结算", "topUpGive_借用押金", "changeMoney_小计" };
		// 一列占多行的情况(数据）
		Map<String, List<Map<String, Object>>> colGetTooRowsMap = new LinkedHashMap<String, List<Map<String, Object>>>();
		List<Map<String, Object>> colGetTooRowsList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> colGetTooRowsList2 = new ArrayList<Map<String, Object>>();
		// 数据行参数
		PubShift pubShift = new PubShift();
		pubShift.setStoreId(UserUtils.getStoreId());
		pubShift.setRentId(UserUtils.getUser().getRentId());
		pubShift.setStatus(pubShift.SHIFT_STATUS_ON);
		try {
			// 组装标题
			// ExportExcelSuper.fillTitles(excelMods, singleTitleMaps,
			// titleRowLengthMaps, groupTitleMaps);
			ExportExcelSuper.fillTitles(excelMods, singleTitleList.toArray(new String[singleTitleList.size()]), null,
					titleColLength);
			// 钱箱周转
			OrdCashBoxVO ordCashBoxVO = new OrdCashBoxVO();
			ordCashBoxVO.setRentId(rentId);
			ordCashBoxVO.setStoreId(storeId);
			ordCashBoxVO.setShiftId(shiftId);
			List<Map<String, Object>> ordCashBoxTotal = ordCashBoxReportService.queryOrdCashBoxReport(ordCashBoxVO);
			int i_1 = 0;// excel扫描的map-key值，自增长
			if (ordCashBoxTotal.size() < payWayList.size() - 1) {
				Map<String, Object> map2 = new HashMap<String, Object>();
				map2.put("payCode", "14");
				map2.put("changeMoney", "0.00");
				map2.put("spareUp", "0.00");
				map2.put("preTransfer", "0.00");
				map2.put("spareDown", "0.00");
				ordCashBoxTotal.add(12, map2);
			}
			for (String cp1 : colPart1) {
				Double rowTotal = 0.0;// 行的合计列
				String key = cp1.split("_")[0];
				String val = cp1.split("_")[1];
				Map<String, Object> rowMap = new LinkedHashMap<String, Object>();
				rowMap.put(key, val);
				for (Map<String, Object> m : ordCashBoxTotal) {
					if (m == null) {
						rowMap.put(String.valueOf(i_1++), "0.00");
						continue;
					}
					String mKeyVal = m.get(key) == null ? "0.00" : String.valueOf(m.get(key));
					Double keyValue = Double.parseDouble(mKeyVal);
					// 钱箱周转.交接下班 = changeMoney + spareUp + preTransfer +
					// spareDown
					// if (cp1.equals(colPart1[colPart1.length - 1])) {
					// for (int k = 0; k < colPart1.length - 1; k++) {
					// String key2 = colPart1[k].split("_")[0];
					// mKeyVal = m.get(key2) == null ? "0.00" :
					// String.valueOf(m.get(key2));
					// keyValue += Double.parseDouble(mKeyVal);
					// }
					// }
					// 封装一行数据
					rowMap.put(String.valueOf(i_1++), keyValue);
					rowTotal += keyValue;
				}
				rowMap.put("rowTotal", rowTotal);// 行合计
				colGetTooRowsList.add(rowMap);// 放入list
			}
			// 组装数据(钱箱周转)
			colGetTooRowsMap.put("钱箱周转", colGetTooRowsList);
			// 实收
			List<Map<String, Object>> payMentTotal = ordCashBoxReportService.queryPaymentInfo(ordCashBoxVO);
			for (String cp2 : colPart2) {
				Double rowTotal = 0.0;// 行的合计列
				String key = cp2.split("_")[0];
				String val = cp2.split("_")[1];
				Map<String, Object> rowMap = new LinkedHashMap<String, Object>();
				rowMap.put(key, val);
				if (key.equals("changeMoney")) {
					for (Map<String, Object> map : ordCashBoxTotal) {
						if (map == null) {
							rowMap.put(String.valueOf(i_1++), "0.00");
							continue;
						}
						// 封装一行数据
						String mKeyVal = map.get(key) == null ? "0.00" : String.valueOf(map.get(key));
						Double keyValue = Double.parseDouble(mKeyVal);
						rowMap.put(String.valueOf(i_1++), keyValue);
						rowTotal += keyValue;
					}
				} else {
					for (Map<String, Object> m : payMentTotal) {
						if (m == null) {
							rowMap.put(String.valueOf(i_1++), "0.00");
							continue;
						}
						// 封装一行数据
						String mKeyVal = m.get(key) == null ? "0.00" : String.valueOf(m.get(key));
						Double keyValue = Double.parseDouble(mKeyVal);
						rowMap.put(String.valueOf(i_1++), keyValue);
						rowTotal += keyValue;
					}
				}
				rowMap.put("rowTotal", rowTotal);// 行合计
				colGetTooRowsList2.add(rowMap);// 放入list
			}
			// 组装数据(钱箱周转)
			colGetTooRowsMap.put("实收", colGetTooRowsList2);
			excelDatas.put(0, Arrays.asList(colGetTooRowsMap));
			List<Object> cellRangeTotalRow = new ArrayList<Object>();
			for (int c = 0; c < singleTitleList.size() + 1; c++) {
				cellRangeTotalRow.add("");
			}
			// 导出
			String fileName = "当班钱箱汇总" + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";
			new ExportExcelSuper().init2LevelTitleAndSetdata("当班钱箱汇总", excelMods, excelDatas,
					ExportExcelSuper.EXPORT_NO_TOTAL, 1, cellRangeTotalRow).write(response, fileName).dispose();
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