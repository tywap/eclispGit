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
import com.jinchuan.pms.pub.common.utils.DateUtils;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 菜品销售统计
 *@author LiLingJie
 *@Description
 *@Date 2019年11月13日 下午4:46:57
 */
@Controller
@RequestMapping(value = "${adminPath}/report/rpFoodAnalysis")
public class RpFoodAnalysisController extends BaseController {

	@Autowired
	private RpFoodAnalysisService rpFoodAnalysisService;

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
			RpFoodAnalysis BusinessCount = rpFoodAnalysisService.getBusinessCount(rpFoodAnalysis);//小计行
			if (BusinessCount == null) {
				return "modules/report/salesStatistics/rpFoodAnalysis";
			}
			BusinessCount.setFoodMainTypeName("小计");
			BigDecimal foodCount = new BigDecimal(BusinessCount.getFoodCount());
			BusinessCount.setOptimalAvgPrice(BusinessCount.getSalesAmount().divide(foodCount, 2));//优免后均价
			BusinessCount.setOptimalRate(BusinessCount.getOptimalFreeGold().multiply(100)
					.divide(BusinessCount.getOriginalAmount().getAmount(), 1).getAmount()
					.setScale(1, BigDecimal.ROUND_DOWN) + "%");//优免率
			BusinessCount.setTurnoverProportion("100%");//营业额占比
			BusinessCount.setClickRate("100%");//点击率
			BusinessCount.setGrossMargin((BusinessCount.getOriginalAmount().subtract(BusinessCount.getCostAmount()))
					.multiply(100).divide(BusinessCount.getOriginalAmount().getAmount(), 1).getAmount()
					.setScale(1, BigDecimal.ROUND_DOWN) + "%");//毛利率
			List<RpFoodAnalysis> rpFoodAnalysisList = rpFoodAnalysisService.getSellCount(rpFoodAnalysis);
			for (RpFoodAnalysis foodAnalysis : rpFoodAnalysisList) {
				BigDecimal foodCount1 = new BigDecimal(foodAnalysis.getFoodCount());
				foodAnalysis.setOptimalRate(
						foodAnalysis.getOptimalFreeGold().multiply(100)
								.divide(foodAnalysis.getOriginalAmount().getAmount(), 1).getAmount()
								.setScale(1, BigDecimal.ROUND_DOWN) + "%");//优免率
				foodAnalysis.setOptimalAvgPrice(foodAnalysis.getSalesAmount().divide(foodCount1, 2));//优免后均价
				foodAnalysis.setTurnoverProportion(
						foodAnalysis.getSalesAmount().multiply(100)
								.divide(BusinessCount.getSalesAmount().getAmount(), 1).getAmount()
								.setScale(1, BigDecimal.ROUND_DOWN) + "%");//营业额占比
				foodAnalysis.setClickRate(
						foodCount1.multiply(new BigDecimal(100).divide(foodCount, 1, BigDecimal.ROUND_DOWN)) + "%");//点击率
				foodAnalysis.setGrossMargin((foodAnalysis.getOriginalAmount().subtract(foodAnalysis.getCostAmount()))
						.multiply(100).divide(foodAnalysis.getOriginalAmount().getAmount(), 1).getAmount()
						.setScale(1, BigDecimal.ROUND_DOWN) + "%");//毛利率
			}
			rpFoodAnalysisList.add(BusinessCount);
			model.addAttribute("rpFoodAnalysisList", rpFoodAnalysisList);
			model.addAttribute("selectStoreId", storeId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "modules/report/salesStatistics/rpFoodAnalysis";
	}

}
