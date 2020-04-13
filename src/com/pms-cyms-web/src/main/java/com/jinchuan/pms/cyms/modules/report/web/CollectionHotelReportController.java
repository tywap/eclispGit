package com.jinchuan.pms.cyms.modules.report.web;

import java.math.BigDecimal;
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
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.jinchuan.pms.cyms.modules.report.entity.CollectionQueryHotelReportVO;
import com.jinchuan.pms.cyms.modules.report.service.CollectionQueryHotelReportService;
import com.jinchuan.pms.pay.enums.PayWayEnum;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.utils.DateUtils;
import com.jinchuan.pms.pub.common.utils.ObjectUtils;
import com.jinchuan.pms.pub.common.utils.excel.ExportExcelSuper;
import com.jinchuan.pms.pub.common.utils.excel.annotation.ExcelModalVO;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.entity.Office;
import com.jinchuan.pms.pub.modules.sys.entity.SysBusiConfig;
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
@RequestMapping(value = "${adminPath}/report/collectionHotel")
public class CollectionHotelReportController extends BaseController {

	@Autowired
	private CollectionQueryHotelReportService collectionQueryHotelReportService;

	@Autowired
	private SysBusiConfigService SysBusiConfigService;
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
	@RequestMapping("/queryCollectionHotelReport")
	public String queryCmGoupReport(Model model, CollectionQueryHotelReportVO collectionHotelReportVO) {
		Map<String, Object> param = new HashMap<>();
		String rentid = UserUtils.getUser().getRentId();
		param.put("rentId", rentid);
		collectionHotelReportVO.setRentId(rentid);
		List<SysBusiConfig> payWayList = SysBusiConfigService.getByType("payWay");
		if (!StringUtils.isEmpty(collectionHotelReportVO.getStoreId())) {
			param.put("storeId", collectionHotelReportVO.getStoreId());
		} else {
			param.put("authorityStoreId", UserUtils.getStoreCacheStr());
		}
		if (collectionHotelReportVO.getStrTime() != null && collectionHotelReportVO.getStrTime() != "") {
			/*
			 * collectionHotelReportVO.setStrTime(DateUtils.getDateBeFore());
			 * collectionHotelReportVO.setEndTime(DateUtils.getDateBeFore());
			 */
			param.put("startdate", collectionHotelReportVO.getStartdate());
			param.put("enddate", collectionHotelReportVO.getEnddate());
			param.put("strTime", collectionHotelReportVO.getStrTime());
			param.put("endTime", collectionHotelReportVO.getEndTime());
			param.put("selectid", collectionHotelReportVO.getSelectid());
			List<Map<String, Object>> dataMapList = new ArrayList<>();

			processDataResult(param, dataMapList, payWayList);
			model.addAttribute("dataMapList", dataMapList);
			model.addAttribute("totalCount", dataMapList.size());
		} else {
			model.addAttribute("strTime", DateUtils.getDateBeFore());
			model.addAttribute("endTime", DateUtils.getDateBeFore());
		}
		List<Office> hotelList = UserUtils.getHotelList();
		List<Office> hQList = UserUtils.getOfficeListByType("0");
		hotelList.addAll(hQList);
		model.addAttribute("hotelList", hotelList);
		// List<CollectionQueryHotelReportVO> collectionHotelList =
		// collectionHotelReportService.queryCollectionHotelList(collectionHotelReportVO);
		// List<CollectionQueryHotelReportVO> collectionHotelCountList =
		// collectionHotelReportService.queryCountAmount(collectionHotelReportVO);

		model.addAttribute("payWayList", payWayList);
		model.addAttribute("roeSpanNum", payWayList.size());
		return "modules/report/store/queryCollectionHotelReport";
	}

	@RequestMapping(value = "ExportExcel", method = RequestMethod.POST)
	@ResponseBody
	public ProcessResult ExportExcel(CollectionQueryHotelReportVO collectionHotelReportVO, HttpServletRequest request,
			HttpServletResponse response, Model model, RedirectAttributes redirectAttributes) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		// 初始化excel导出接口参数
		initialExportData();
		// 标题组头及子标题
		Map<String, List<String>> groupTitleMaps = new LinkedHashMap<String, List<String>>();
		Map<Integer, String> singleTitleMaps = new LinkedHashMap<Integer, String>();
		Map<Integer, Integer> titleRowLengthMaps = new LinkedHashMap<Integer, Integer>();
		// 数据行参数
		List<Object> sortDataRowList = new ArrayList<Object>();
		String[] subTitlePart1 = new String[] { "住客押金", "住客结账", "非住客结账", "预订订金", "会员发卡", "会员升级", "会员充值", "会员退卡", "借物押金",
				"单位预交", "挂账结算", "其它小计" };
		String[] subTitlePart2 = new String[] { "充值赠送" };

		List<SysBusiConfig> payWayList = SysBusiConfigService.getByType("payWay");
		List<String> singleTitleList = new ArrayList<String>();
		for (SysBusiConfig sb : payWayList) {
			String payName = sb.getName();
			singleTitleList.add(payName);
		}
		singleTitleList.add("收银小计");
		String[] subTitlePart3 = singleTitleList.toArray(new String[singleTitleList.size()]);
		/*
		 * String[] subTitlePart3 = new String[] { "现金", "银行卡", "微信扫码",
		 * "微信线上支付", "支付宝扫码", "支付宝线上支付", "储值卡", "预交款", "挂账", "减免", "微信-手工",
		 * "支付宝-手工", "收银小计" };
		 */
		// 查询参数
		Map<String, Object> param = new HashMap<>();
		String rentid = UserUtils.getUser().getRentId();
		param.put("rentId", rentid);
		collectionHotelReportVO.setRentId(rentid);
		try {
			param.put("strTime", collectionHotelReportVO.getStrTime());
			param.put("endTime", collectionHotelReportVO.getEndTime());
			param.put("startdate", collectionHotelReportVO.getStartdate());
			param.put("enddate", collectionHotelReportVO.getEnddate());
			if (!StringUtils.isEmpty(collectionHotelReportVO.getStoreId())) {
				param.put("storeId", collectionHotelReportVO.getStoreId());
			} else {
				param.put("authorityStoreId", UserUtils.getStoreCacheStr());
			}
			param.put("selectid", collectionHotelReportVO.getSelectid());
			// 组装独立标题
			singleTitleMaps.put(1, "酒店");
			titleRowLengthMaps.put(1, 2);
			// 组装分组标题
			groupTitleMaps.put("操作类型", Arrays.asList(subTitlePart1));
			groupTitleMaps.put("赠送", Arrays.asList(subTitlePart2));
			groupTitleMaps.put("收银", Arrays.asList(subTitlePart3));
			// 组装标题
			ExportExcelSuper.fillTitles(excelMods, singleTitleMaps, titleRowLengthMaps, groupTitleMaps);
			// 处理行数据
			// List<CollectionQueryHotelReportVO> collectionHotelList =
			// collectionHotelReportService.queryCollectionHotelList(collectionHotelReportVO);
			//// List<CollectionQueryHotelReportVO> collectionHotelCountList =
			// collectionHotelReportService.queryCountAmount(collectionHotelReportVO);
			//// collectionHotelList.add(collectionHotelCountList.get(0));
			List<Map<String, Object>> dataMapList = new ArrayList<>();
			processDataResult(param, dataMapList, payWayList);
			int i = 0;
			for (Map<String, Object> map : dataMapList) {
				sortDataRowList.add(map.get("hotelName"));
				sortDataRowList.add(map.get("guestDeposit"));
				sortDataRowList.add(map.get("guestCheckOut"));
				sortDataRowList.add(map.get("unGuestCheckOut"));
				sortDataRowList.add(map.get("orderDeposit"));
				sortDataRowList.add(map.get("numberCard"));
				sortDataRowList.add(map.get("numberUp"));
				sortDataRowList.add(map.get("numberRecharge"));
				sortDataRowList.add(map.get("numberBackCard"));
				sortDataRowList.add(map.get("borrowDeposit"));
				sortDataRowList.add(map.get("advanceUnit"));
				sortDataRowList.add(map.get("settleMent"));
				// 其它小计
				sortDataRowList.add(totalForBigDecimalMoney(map.get("guestDeposit"), map.get("guestCheckOut"),
						map.get("unGuestCheckOut"), map.get("orderDeposit"), map.get("numberCard"), map.get("numberUp"),
						map.get("numberRecharge"), map.get("numberBackCard"), map.get("borrowDeposit"),
						map.get("advanceUnit"), map.get("settleMent")));
				sortDataRowList.add(map.get("topUpGive"));
				for (SysBusiConfig sb : payWayList) {
					sortDataRowList.add(map.get(sb.getParamKey()));
				}
				/*
				 * sortDataRowList.add(map.get("cash"));
				 * sortDataRowList.add(map.get("unionpay"));
				 * sortDataRowList.add(map.get("wechat"));
				 * sortDataRowList.add(map.get("wechatOnline"));
				 * sortDataRowList.add(map.get("alipay"));
				 * sortDataRowList.add(map.get("alipayOnline"));
				 * sortDataRowList.add(map.get("personPrePaid"));
				 * sortDataRowList.add(map.get("groupPrePaid"));
				 * sortDataRowList.add(map.get("ownMoney"));
				 * sortDataRowList.add(map.get("discount"));
				 * sortDataRowList.add(map.get("wechatSG"));
				 * sortDataRowList.add(map.get("alipaySG"));
				 */
				sortDataRowList.add(map.get("totalAmount"));
				excelDatas.put(i++, sortDataRowList);
				sortDataRowList = new ArrayList<Object>();
			}
			// 导出
			String fileName = "收银汇总（门店）" + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";
			new ExportExcelSuper()
					.init2LevelTitleAndSetdata("收银汇总（门店）", excelMods, excelDatas, ExportExcelSuper.EXPORT_NO_TOTAL)
					.write(response, fileName).dispose();
		} catch (

		Exception e) {
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

	private void processDataResult(Map<String, Object> param, List<Map<String, Object>> dataMapList,
			List<SysBusiConfig> payWayList) {
		List<Map<String, Object>> hotelPaymentList = collectionQueryHotelReportService
				.queryHotelPaymentTransaction(param);
		List<Map<String, Object>> hotelPayWayList = collectionQueryHotelReportService
				.queryHotelPayWayTransaction(param);
		Map<String, String> payMap = new HashMap<>(hotelPaymentList.size());
		for (Map<String, Object> hotelPayWayMap : hotelPayWayList) {
			payMap.put(hotelPayWayMap.get("storeId") + "_" + hotelPayWayMap.get("payMethod"),
					ObjectUtils.toString(hotelPayWayMap.get("amount")));
		}
		for (int i = 0; i < hotelPaymentList.size(); i++) {
			Map<String, Object> dataMap = new HashMap<>();
			Map<String, Object> map = hotelPaymentList.get(i);
			if (map != null) {
				dataMap.put("hotelName", map.get("hotelName"));
				dataMap.put("guestDeposit", map.get("guestDeposit"));
				dataMap.put("guestCheckOut", map.get("guestCheckOut"));
				dataMap.put("unGuestCheckOut", map.get("unGuestCheckOut"));
				dataMap.put("orderDeposit", map.get("orderDeposit"));
				dataMap.put("numberCard", map.get("numberCard"));
				dataMap.put("numberUp", map.get("numberUp"));
				dataMap.put("numberRecharge", map.get("numberRecharge"));
				dataMap.put("numberBackCard", map.get("numberBackCard"));
				dataMap.put("borrowDeposit", map.get("borrowDeposit"));
				dataMap.put("advanceUnit", map.get("advanceUnit"));
				dataMap.put("settleMent", map.get("settleMent"));
				dataMap.put("topUpGive", map.get("topUpGive"));
				double totalAmount = 0.0;
				for (SysBusiConfig d : payWayList) {
					if (!(PayWayEnum.PRE_AUTH.getCode()).equals(d.getParamKey())) {
						String payMoney = payMap.get(map.get("storeId") + "_" + d.getParamKey());
						if (StringUtils.isEmpty(payMoney)) {
							payMoney = "0";
						}
						dataMap.put(d.getParamKey(), payMoney);
						totalAmount = totalAmount + Double.parseDouble(payMoney);
					}
				}
				dataMap.put("totalAmount", totalAmount);
				dataMapList.add(dataMap);
			}
		}
	}

	private BigDecimal totalForBigDecimalMoney(Object... val) {
		BigDecimal result = new BigDecimal("0");
		for (int i = 0; i < val.length; i++) {
			if (val[i] == null)
				continue;
			BigDecimal tmp = (BigDecimal) val[i];
			result = result.add(tmp);
		}
		return result;
	}

	public static void main(String[] args) {
		BigDecimal result = new BigDecimal("0");
		BigDecimal tmp = new BigDecimal(12);
		result.add(new BigDecimal(111));
		System.out.println(result);
	}
}
