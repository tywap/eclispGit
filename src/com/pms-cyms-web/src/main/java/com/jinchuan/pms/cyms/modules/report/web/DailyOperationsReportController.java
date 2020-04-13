package com.jinchuan.pms.cyms.modules.report.web;

import java.math.BigDecimal;
import java.util.HashMap;
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
import com.jinchuan.pms.cyms.modules.setting.service.CtTableService;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 营业日报
 *@author LiLingJie
 *@Description
 *@Date 2020年1月8日 上午10:42:54
 */
@Controller
@RequestMapping(value = "${adminPath}/report/dailyPaper")
public class DailyOperationsReportController extends BaseController {

	@Autowired
	private RpTableAnalysisService rpTableAnalysisService;
	@Autowired
	private CtTableService ctTableService;
	@Autowired
	private RpFoodAnalysisService rpFoodAnalysisService;
	@Autowired
	private OrdPaymentFundDao ordPaymentFundDao;

	@RequestMapping(value = "list")
	public String checkDetailsList(HttpServletRequest request, HttpServletResponse response, Model model) {
		String storeId = request.getParameter("storeId");
		String accountDate = request.getParameter("date");//账务日期
		String rentId = UserUtils.getUser().getRentId();
		try {
			if (accountDate == null) {
				if (storeId == null || storeId.equals("")) {
					accountDate = UserUtils.getAccountDate(rentId);
				} else {
					accountDate = UserUtils.getAccountDate(storeId.split(",")[0]);
				}
			}
			RpTableAnalysis rpTableAnalysis = new RpTableAnalysis();
			rpTableAnalysis.setAccountDate(accountDate);
			rpTableAnalysis.setRentId(rentId);
			rpTableAnalysis.setStoreId(storeId);

			RpTableAnalysis tableCount = rpTableAnalysisService.getTableCount(rpTableAnalysis);//当日开台情况
			if (tableCount != null) {
				BigDecimal orderCount = new BigDecimal(tableCount.getOrderCount());
				BigDecimal useCount = new BigDecimal(tableCount.getUseCount());
				tableCount.setOriginalTableAvg(tableCount.getOriginalAmount().divide(orderCount, 1));//折前桌均
				tableCount.setOriginalUseAvg(tableCount.getOriginalAmount().divide(useCount, 1));//折前人均
				tableCount.setRearTableAvg(tableCount.getSalesAmount().divide(orderCount, 1));//折后桌均
				tableCount.setRearUseAvg(tableCount.getSalesAmount().divide(useCount, 1));//折后人均
				tableCount.setOptimalRate(tableCount.getOptimalFreeGold().multiply(100)
						.divide(tableCount.getOriginalAmount().getAmount(), 1).getAmount()
						.setScale(1, BigDecimal.ROUND_DOWN) + "%");//优免率
				tableCount.setFoundingRate(new BigDecimal(tableCount.getOrderCount()).multiply(new BigDecimal(100))
						.divide(new BigDecimal(tableCount.getTableCount()), 1, BigDecimal.ROUND_HALF_UP) + "%");
			}
			RpTableAnalysis monthTableCount = rpTableAnalysisService.getMonthTableCount(rpTableAnalysis);//当月开台情况
			if (monthTableCount != null) {
				BigDecimal orderCount1 = new BigDecimal(monthTableCount.getOrderCount());
				BigDecimal useCount1 = new BigDecimal(monthTableCount.getUseCount());
				monthTableCount.setOriginalTableAvg(monthTableCount.getOriginalAmount().divide(orderCount1, 1));//折前桌均
				monthTableCount.setOriginalUseAvg(monthTableCount.getOriginalAmount().divide(useCount1, 1));//折前人均
				monthTableCount.setRearTableAvg(monthTableCount.getSalesAmount().divide(orderCount1, 1));//折后桌均
				monthTableCount.setRearUseAvg(monthTableCount.getSalesAmount().divide(useCount1, 1));//折后人均
				monthTableCount.setOptimalRate(monthTableCount.getOptimalFreeGold().multiply(100)
						.divide(monthTableCount.getOriginalAmount().getAmount(), 1).getAmount()
						.setScale(1, BigDecimal.ROUND_DOWN) + "%");//优免率
				monthTableCount.setCanelrate(
						new BigDecimal(monthTableCount.getCanelCount()).multiply(new BigDecimal(100)).divide(
								new BigDecimal(monthTableCount.getFoodCount()), 1, BigDecimal.ROUND_HALF_UP) + "%");//退菜率
				monthTableCount
						.setFoundingRate(new BigDecimal(monthTableCount.getOrderCount()).multiply(new BigDecimal(100))
								.divide(new BigDecimal(monthTableCount.getTableCount()), 1, BigDecimal.ROUND_HALF_UP)
								+ "%");
			}
			RpFoodAnalysis rpFoodAnalysis = new RpFoodAnalysis();
			rpFoodAnalysis.setStoreId(storeId);
			rpFoodAnalysis.setRentId(rentId);
			RpFoodAnalysis income = rpFoodAnalysisService.getIncome(rpFoodAnalysis);//月收入
			List<RpFoodAnalysis> incomeList = rpFoodAnalysisService.getIncomeList(rpFoodAnalysis);
			rpFoodAnalysis.setAccountDate(accountDate);
			RpFoodAnalysis dayIncome = rpFoodAnalysisService.getIncome(rpFoodAnalysis);//日收入
			List<RpFoodAnalysis> dayIncomeList = rpFoodAnalysisService.getIncomeList(rpFoodAnalysis);
			if (!dayIncomeList.isEmpty()) {
				income.setOriginalDayAmount(dayIncome.getOriginalAmount());
				income.setSalesDayAmount(dayIncome.getSalesAmount());
				for (RpFoodAnalysis incomes : incomeList) {
					for (int i = 0; i < dayIncomeList.size(); i++) {
						if (incomes.getFoodTypeName().equals(dayIncomeList.get(i).getFoodTypeName())) {
							incomes.setOriginalDayAmount(dayIncomeList.get(i).getOriginalAmount());
							incomes.setSalesDayAmount(dayIncomeList.get(i).getSalesAmount());
						}
					}
				}
			}
			OrdPaymentFund dayPaymentFund = ordPaymentFundDao.getProceeds(accountDate, storeId);//当日收款
			OrdPaymentFund monthPaymentFund = ordPaymentFundDao.getProceeds(null, storeId);//当月累计收款
			Map<String, Object> subtotalPay = new HashMap<String, Object>();
			if (dayPaymentFund == null) {
				subtotalPay.put("dayAmount", "");
				subtotalPay.put("dyaProportion", "");
			} else {
				subtotalPay.put("dayAmount", dayPaymentFund.getAmount());
				subtotalPay.put("dyaProportion", "100%");
			}
			subtotalPay.put("monthAmount", monthPaymentFund.getAmount());
			subtotalPay.put("monthProportion", "100%");
			List<OrdPaymentFund> dayPayList = ordPaymentFundDao.getProceedsList(accountDate, storeId);//日数据
			List<OrdPaymentFund> payList = ordPaymentFundDao.getProceedsList(null, storeId);//月数据
			if (!payList.isEmpty()) {
				for (OrdPaymentFund pay : payList) {
					pay.setMonthProportion(pay.getAmount().getAmount().multiply(new BigDecimal(100))
							.divide(monthPaymentFund.getAmount().getAmount(), 1, BigDecimal.ROUND_HALF_UP) + "%");//月占比
					for (int i = 0; i < dayPayList.size(); i++) {
						if (pay.getPayMethod().equals(dayPayList.get(i).getPayMethod())) {
							pay.setDayAmount(dayPayList.get(i).getAmount());
							pay.setDayProportion(dayPayList.get(i).getAmount().getAmount().multiply(new BigDecimal(100))
									.divide(dayPaymentFund.getAmount().getAmount(), 1, BigDecimal.ROUND_HALF_UP) + "%");//日占比
						}
					}
				}
			}
			model.addAttribute("tableCount", tableCount);//当日开台情况
			model.addAttribute("monthTableCount", monthTableCount);//月开台情况
			model.addAttribute("subtotalPay", subtotalPay);//收款小计
			model.addAttribute("income", income);//收入小计行
			model.addAttribute("incomeList", incomeList);//收入
			model.addAttribute("payList", payList);//收款
			model.addAttribute("selectStoreId", storeId);
			model.addAttribute("accountDate", accountDate);//账务日期前一天
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "modules/report/doBusiness/dailyPaper";
	}

}
