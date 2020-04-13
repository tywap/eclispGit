package com.jinchuan.pms.cyms.modules.report.web;

import java.math.BigDecimal;
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

import com.jinchuan.pms.cyms.modules.order.dao.OrdPaymentFundDao;
import com.jinchuan.pms.cyms.modules.order.entity.OrdPaymentFund;
import com.jinchuan.pms.cyms.modules.report.entity.RpFoodAnalysis;
import com.jinchuan.pms.cyms.modules.report.entity.RpTableAnalysis;
import com.jinchuan.pms.cyms.modules.report.service.RpFoodAnalysisService;
import com.jinchuan.pms.cyms.modules.report.service.RpTableAnalysisService;
import com.jinchuan.pms.cyms.modules.setting.entity.CtFoodType;
import com.jinchuan.pms.cyms.modules.setting.entity.CtTable;
import com.jinchuan.pms.cyms.modules.setting.service.CtFoodTypeService;
import com.jinchuan.pms.cyms.modules.setting.service.CtTableService;
import com.jinchuan.pms.pub.common.utils.money.Money;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.entity.SysBusiConfig;
import com.jinchuan.pms.pub.modules.sys.enums.SysConfigTypeEnum;
import com.jinchuan.pms.pub.modules.sys.service.SysBusiConfigService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 营业分析表
 *@author LiLingJie
 *@Description
 *@Date 2020年1月13日 下午4:01:16
 */
@Controller
@RequestMapping(value = "${adminPath}/report/businessAnalysis")
public class BusinessAnalysisListController extends BaseController {

	@Autowired
	private RpTableAnalysisService rpTableAnalysisService;
	@Autowired
	private CtTableService ctTableService;
	@Autowired
	private RpFoodAnalysisService rpFoodAnalysisService;
	@Autowired
	private OrdPaymentFundDao ordPaymentFundDao;
	@Autowired
	private CtFoodTypeService ctFoodTypeService;
	@Autowired
	private SysBusiConfigService sysBusiConfigService;

	@RequestMapping(value = "list")
	public String checkDetailsList(HttpServletRequest request, HttpServletResponse response, Model model) {
		String storeId = request.getParameter("storeId");
		String startDate = request.getParameter("startDate");//开始日期
		String endDate = request.getParameter("endDate");//结束日期
		String dateType = request.getParameter("dateType");//日期类型(0-按日,1-按月)
		String rentId = UserUtils.getUser().getRentId();
		List<CtFoodType> foodTypeList = new ArrayList<CtFoodType>();
		List<SysBusiConfig> payWayList = new ArrayList<SysBusiConfig>();
		try {
			if (startDate == null && endDate == null) {
				if (storeId == null || storeId.equals("")) {
					startDate = UserUtils.getAccountDate(rentId);
					endDate = startDate;
				} else {
					startDate = UserUtils.getAccountDate(storeId.split(",")[0]);
					endDate = startDate;
				}
			}
			CtFoodType ctFoodType = new CtFoodType();
			ctFoodType.setRentId(rentId);
			ctFoodType.setStoreId(storeId);
			foodTypeList = ctFoodTypeService.getLittleType(ctFoodType);
			SysBusiConfig sys = new SysBusiConfig();
			sys.setRentId(rentId);
			sys.setStatus("1");
			sys.setType(SysConfigTypeEnum.payWay.getType());
			payWayList = sysBusiConfigService.findList(sys);
			Map<String, Object> typeMaps = new LinkedHashMap<String, Object>();
			typeMaps.put("小计", "0.00");
			for (CtFoodType map : foodTypeList) {
				typeMaps.put(map.getName(), "0.00");
			}
			Map<String, Object> payMaps = new LinkedHashMap<String, Object>();
			payMaps.put("小计", "0.00");
			for (SysBusiConfig map : payWayList) {
				payMaps.put(map.getName(), "0.00");
			}
			RpFoodAnalysis rpFoodAnalysis = new RpFoodAnalysis();
			rpFoodAnalysis.setAccountDate(startDate);
			rpFoodAnalysis.setAccountEndDate(endDate);
			rpFoodAnalysis.setStoreId(storeId);
			rpFoodAnalysis.setRentId(rentId);
			RpTableAnalysis rpTableAnalysis = new RpTableAnalysis();
			rpTableAnalysis.setAccountDate(startDate);
			rpTableAnalysis.setStoreId(storeId);
			rpTableAnalysis.setAccountEndDate(endDate);
			rpTableAnalysis.setRentId(rentId);
			OrdPaymentFund ordPaymentFund = new OrdPaymentFund();
			ordPaymentFund.setAccountDate(startDate);
			ordPaymentFund.setAccountEndDate(endDate);
			ordPaymentFund.setStoreId(storeId);
			ordPaymentFund.setRentId(rentId);
			List<CtTable> storeTableList = ctTableService.getStoreTableList(storeId);//对应分店总台数
			List<RpTableAnalysis>  openTableSubtotal=rpTableAnalysisService.getTableCountList(rpTableAnalysis);
			RpTableAnalysis tableCount = openTableSubtotal.get(0);
			if (tableCount != null) {
				BigDecimal orderCount = new BigDecimal(tableCount.getOrderCount());
				BigDecimal useCount = new BigDecimal(tableCount.getUseCount());
				tableCount.setStoreName("小计");
				tableCount.setOriginalTableAvg(tableCount.getOriginalAmount().divide(orderCount, 1));//折前桌均
				tableCount.setOriginalUseAvg(tableCount.getOriginalAmount().divide(useCount, 1));//折前人均
				tableCount.setRearTableAvg(tableCount.getSalesAmount().divide(orderCount, 1));//折后桌均
				tableCount.setRearUseAvg(tableCount.getSalesAmount().divide(useCount, 1));//折后人均
				tableCount.setOptimalRate(tableCount.getOptimalFreeGold().multiply(100)
						.divide(tableCount.getOriginalAmount().getAmount(), 1).getAmount()
						.setScale(1, BigDecimal.ROUND_DOWN) + "%");//优免率
				tableCount.setFoundingRate(new BigDecimal(tableCount.getOrderCount()).multiply(new BigDecimal(100))
						.divide(new BigDecimal(storeTableList.size()), 1, BigDecimal.ROUND_HALF_UP) + "%");//开台率
				List<RpFoodAnalysis> subtotalList = rpFoodAnalysisService.getExpenditureList(rpFoodAnalysis);
				List<OrdPaymentFund> ordPaySubtotalList = ordPaymentFundDao.getOrdPayList(ordPaymentFund);
				Money foodSubtotal = new Money();
				Money paySubtotal = new Money();
				Map<String, Object> payMap = new HashMap<String, Object>();
				payMap.putAll(payMaps);
				Map<String, Object> typeMap = new HashMap<String, Object>();
				typeMap.putAll(typeMaps);
				for (RpFoodAnalysis subtotal : subtotalList) {
					if (subtotal != null && subtotal.getFoodTypeName() != null) {
						foodSubtotal.addTo(subtotal.getSalesAmount());
						typeMap.put(subtotal.getFoodTypeName(), subtotal.getSalesAmount());
					}
				}
				for (OrdPaymentFund ordPaySubtotal : ordPaySubtotalList) {
					if (ordPaySubtotal != null && ordPaySubtotal.getPayMethod() != null) {
						paySubtotal.addTo(ordPaySubtotal.getAmount());
						payMap.put(ordPaySubtotal.getPayMethodName(), ordPaySubtotal.getAmount());
					}
				}
				payMap.put("小计", paySubtotal);
				typeMap.put("小计", foodSubtotal);
				tableCount.setFoodTypePrice(typeMap);
				tableCount.setPayWayPrice(payMap);
			} else {
				openTableSubtotal.remove(tableCount);
			}
			rpTableAnalysis.setDateType(dateType);
			rpFoodAnalysis.setDateType(dateType);
			ordPaymentFund.setDateType(dateType);
			List<RpFoodAnalysis> expenditureList = rpFoodAnalysisService.getExpenditureList(rpFoodAnalysis);
			List<OrdPaymentFund> ordPayList = ordPaymentFundDao.getOrdPayList(ordPaymentFund);
			List<RpTableAnalysis> tableCountList = rpTableAnalysisService.getTableCountList(rpTableAnalysis);//开台情况
			for (int i = 0; i < tableCountList.size();) {
				RpTableAnalysis tableCount1 = tableCountList.get(i);
				if (tableCount1 != null) {
					BigDecimal orderCount = new BigDecimal(tableCount1.getOrderCount());
					BigDecimal useCount = new BigDecimal(tableCount1.getUseCount());
					tableCount1.setOriginalTableAvg(tableCount1.getOriginalAmount().divide(orderCount, 1));//折前桌均
					tableCount1.setOriginalUseAvg(tableCount1.getOriginalAmount().divide(useCount, 1));//折前人均
					tableCount1.setRearTableAvg(tableCount1.getSalesAmount().divide(orderCount, 1));//折后桌均
					tableCount1.setRearUseAvg(tableCount1.getSalesAmount().divide(useCount, 1));//折后人均
					tableCount1.setOptimalRate(tableCount1.getOptimalFreeGold().multiply(100)
							.divide(tableCount1.getOriginalAmount().getAmount(), 1).getAmount()
							.setScale(1, BigDecimal.ROUND_DOWN) + "%");//优免率
					tableCount1
							.setFoundingRate(new BigDecimal(tableCount1.getOrderCount()).multiply(new BigDecimal(100))
							.divide(new BigDecimal(storeTableList.size()), 1, BigDecimal.ROUND_HALF_UP) + "%");//开台率
					Money foodSubtotal = new Money();
					Money paySubtotal = new Money();
					Map<String, Object> payMap = new HashMap<String, Object>();
					payMap.putAll(payMaps);
					Map<String, Object> typeMap = new HashMap<String, Object>();
					typeMap.putAll(typeMaps);
					for (RpFoodAnalysis expenditure : expenditureList) {
						if (expenditure != null && expenditure.getFoodTypeName() != null
								&& tableCount1.getAccountDate().equals(expenditure.getAccountDate())) {
							foodSubtotal.addTo(expenditure.getSalesAmount());
							typeMap.put(expenditure.getFoodTypeName(), expenditure.getSalesAmount());
						}
					}
					for (OrdPaymentFund ordPay : ordPayList) {
						if (ordPay != null && ordPay.getPayMethod() != null
								&& tableCount1.getAccountDate().equals(ordPay.getAccountDate())) {
							paySubtotal.addTo(ordPay.getAmount());
							payMap.put(ordPay.getPayMethodName(), ordPay.getAmount());
						}
					}
					payMap.put("小计", paySubtotal);
					typeMap.put("小计", foodSubtotal);
					tableCount1.setFoodTypePrice(typeMap);
					tableCount1.setPayWayPrice(payMap);
					i++;
				} else {
					tableCountList.remove(tableCount1);
				}
			}
			if (!openTableSubtotal.isEmpty()) {
				tableCountList.add(openTableSubtotal.get(0));
			}
			model.addAttribute("tableCountList", tableCountList);//开台情况list
			model.addAttribute("foodTypeList", typeMaps);//消费（按小类）
			model.addAttribute("payWayList", payMaps);//收款（按支付方式）
			model.addAttribute("startDate", startDate);
			model.addAttribute("endDate", endDate);
			model.addAttribute("selectStoreId", storeId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "modules/report/doBusiness/businessAnalysis";
	}
}
