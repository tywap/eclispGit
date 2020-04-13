package com.jinchuan.pms.cyms.modules.report.web;

import java.math.BigDecimal;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.jinchuan.pms.cyms.modules.report.entity.RpFoodAnalysis;
import com.jinchuan.pms.cyms.modules.report.service.RpFoodAnalysisService;
import com.jinchuan.pms.cyms.modules.setting.entity.CtFoodType;
import com.jinchuan.pms.cyms.modules.setting.service.CtFoodTypeService;
import com.jinchuan.pms.pub.common.utils.DateUtils;
import com.jinchuan.pms.pub.common.utils.money.Money;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 菜品类别销售统计
 *@author LiLingJie
 *@Description
 *@Date 2019年11月13日 下午5:17:27
 */
@Controller
@RequestMapping(value = "${adminPath}/report/rpFoodTypeAnalysis")
public class RpFoodTypeAnalysisController extends BaseController {

	@Autowired
	private RpFoodAnalysisService rpFoodAnalysisService;
	@Autowired
	private CtFoodTypeService ctFoodTypeService;

	@RequestMapping(value = "list")
	private String list(HttpServletRequest request, HttpServletResponse response, Model model,
			RpFoodAnalysis rpFoodAnalysis) {
		String storeId = rpFoodAnalysis.getStoreId();
		String rentId = UserUtils.getUser().getRentId();
		String date = "";//账务日期
		try {
			if (storeId == null || storeId.equals("")) {
				date = UserUtils.getAccountDate(rentId);
			} else {
				date = UserUtils.getAccountDate(storeId.split(",")[0]);
			}
			String accountDate = DateUtils.getSpecifiedDayBefore(date);
			model.addAttribute("accountDate", accountDate);//账务日期前一天
			List<CtFoodType> foodTypeNameList = ctFoodTypeService.findList(new CtFoodType());
			RpFoodAnalysis BusinessCount = rpFoodAnalysisService.getBusinessCount(rpFoodAnalysis);//小计行
			if (BusinessCount == null) {
				return "modules/report/salesStatistics/rpFoodTypeAnalysis";
			}
			BigDecimal foodCount = new BigDecimal(BusinessCount.getFoodCount());//总销售数量
			BigDecimal canelCount = new BigDecimal(BusinessCount.getCanelCount());//总退菜数量
			BusinessCount.setFoodMainTypeName("小计");
			BusinessCount.setCostProportion("100%");//成本占比
			BusinessCount.setOriginalProportion("100%");//折前销售占比
			BusinessCount.setOriginalrate((BusinessCount.getOriginalAmount().subtract(BusinessCount.getCostAmount()))
					.multiply(100).divide(BusinessCount.getOriginalAmount().getAmount(), 1).getAmount()
					.setScale(1, BigDecimal.ROUND_DOWN) + "%");//标准毛利率
			BusinessCount.setOriginalDayAmount(BusinessCount.getOriginalAmount().divide(1));//折前日均销售额
			BusinessCount.setTurnoverProportion("100%");//折后销售占比
			BusinessCount.setSalesrate((BusinessCount.getSalesAmount().subtract(BusinessCount.getCostAmount()))
					.multiply(100).divide(BusinessCount.getSalesAmount().getAmount(), 1).getAmount()
					.setScale(1, BigDecimal.ROUND_DOWN) + "%");//实际毛利率
			BusinessCount.setSalesDayAmount(BusinessCount.getSalesAmount().divide(1));//折后日均营业额
			BusinessCount.setOptimalProportion("100%");//优免占比
			BusinessCount.setOptimalRate(
					BusinessCount.getOptimalFreeGold().multiply(100)
							.divide(BusinessCount.getOriginalAmount().getAmount(), 1).getAmount()
							.setScale(1, BigDecimal.ROUND_DOWN) + "%");//优免率
			BusinessCount.setCanelrate(
					canelCount.multiply(new BigDecimal(100)).divide(foodCount, 1, BigDecimal.ROUND_HALF_UP) + "%");//退菜率
			List<RpFoodAnalysis> rpFoodAnalysisList = rpFoodAnalysisService.getSellTypeCount(rpFoodAnalysis);
			for (RpFoodAnalysis FoodAnalysis : rpFoodAnalysisList) {
				BigDecimal foodCount1 = new BigDecimal(BusinessCount.getFoodCount());//单项销售数量
				BigDecimal canelCount1 = new BigDecimal(BusinessCount.getCanelCount());//单项退菜数量
//				if (BusinessCount.getCostAmount().getAmount().compareTo(BigDecimal.ZERO) == 0) {
//					FoodAnalysis.setCostProportion("100%");//成本占比
//				} else {
					FoodAnalysis.setCostProportion(FoodAnalysis.getCostAmount().multiply(100)
							.divide(BusinessCount.getCostAmount().getAmount(), 1).getAmount()
							.setScale(1, BigDecimal.ROUND_DOWN) + "%");//成本占比
//				}
				FoodAnalysis.setOriginalProportion(FoodAnalysis.getOriginalAmount().multiply(100)
						.divide(BusinessCount.getOriginalAmount().getAmount(), 1).getAmount()
						.setScale(1, BigDecimal.ROUND_DOWN) + "%");//折前销售占比
				FoodAnalysis.setOriginalrate((FoodAnalysis.getSalesAmount().subtract(FoodAnalysis.getCostAmount()))
						.multiply(100).divide(FoodAnalysis.getSalesAmount().getAmount(), 1).getAmount()
						.setScale(1, BigDecimal.ROUND_DOWN) + "%");//标准毛利率
				FoodAnalysis.setOriginalDayAmount(FoodAnalysis.getOriginalAmount().divide(1));//折前日均销售额
				FoodAnalysis.setTurnoverProportion(FoodAnalysis.getSalesAmount().multiply(100)
						.divide(BusinessCount.getSalesAmount().getAmount(), 1).getAmount()
						.setScale(1, BigDecimal.ROUND_DOWN) + "%");//折后销售占比
				FoodAnalysis.setSalesrate((FoodAnalysis.getSalesAmount().subtract(FoodAnalysis.getCostAmount()))
						.multiply(100).divide(FoodAnalysis.getSalesAmount().getAmount(), 1).getAmount()
						.setScale(1, BigDecimal.ROUND_DOWN) + "%");//实际毛利率
				FoodAnalysis.setSalesDayAmount(FoodAnalysis.getSalesAmount().divide(1));//折后日均营业额
				FoodAnalysis.setOptimalProportion(
						FoodAnalysis.getOptimalFreeGold().multiply(100)
								.divide(BusinessCount.getOptimalFreeGold().getAmount(), 1).getAmount()
								.setScale(1, BigDecimal.ROUND_DOWN) + "%");//优免占比
				FoodAnalysis.setOptimalRate(
						FoodAnalysis.getOptimalFreeGold().multiply(100)
								.divide(BusinessCount.getOriginalAmount().getAmount(), 1).getAmount()
								.setScale(1, BigDecimal.ROUND_DOWN) + "%");//优免率
				FoodAnalysis.setCanelrate(
						canelCount1.multiply(new BigDecimal(100)).divide(foodCount1, 1, BigDecimal.ROUND_HALF_UP)
								+ "%");//退菜率	
			}
			rpFoodAnalysisList.add(BusinessCount);
			model.addAttribute("foodTypeNameList", foodTypeNameList);//菜品小类
			model.addAttribute("rpFoodAnalysisList", rpFoodAnalysisList);
			model.addAttribute("selectStoreId", storeId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "modules/report/salesStatistics/rpFoodTypeAnalysis";
	}

	public static void main(String[] args) {
		Money a = new Money("0.00");
		if (a.getAmount().compareTo(BigDecimal.ZERO) == 0) {
			System.err.println("11111");
		}

	}
}
