package com.jinchuan.pms.cyms.modules.report.web;

import java.math.BigDecimal;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.jinchuan.pms.cyms.modules.accounting.enums.OrdTableEnum;
import com.jinchuan.pms.cyms.modules.report.entity.RpUseTypeAnalysis;
import com.jinchuan.pms.cyms.modules.report.enums.ReportEnums;
import com.jinchuan.pms.cyms.modules.report.service.RpUseTypeAnalysisService;
import com.jinchuan.pms.pub.common.utils.DateUtils;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 用餐类型分析
 *@author LiLingJie
 *@Description
 *@Date 2019年11月20日 上午10:13:17
 */
@Controller
@RequestMapping(value = "${adminPath}/report/useTypeAnalysis")
public class RpUseTypeAnalysisController extends BaseController {

	@Autowired
	private RpUseTypeAnalysisService rpUseTypeAnalysisService;

	@RequestMapping(value = "list")
	private String list(HttpServletRequest request, HttpServletResponse response, Model model,
			RpUseTypeAnalysis rpUseTypeAnalysis) {
		String storeId = rpUseTypeAnalysis.getStoreId();
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
			RpUseTypeAnalysis useTypeCount = rpUseTypeAnalysisService.getUseTypeCount(rpUseTypeAnalysis);//小计行
			if (useTypeCount == null) {
				return "modules/report/analyze/useTypeAnalyze";
			}
			BigDecimal orderCount = new BigDecimal(useTypeCount.getOrderCount());
			BigDecimal useCount = new BigDecimal(useTypeCount.getUseCount());
			useTypeCount.setUseType("小计");
			useTypeCount.setOriginalProportion("100%");//折前占比
			useTypeCount.setOriginalrate((useTypeCount.getOriginalAmount().subtract(useTypeCount.getCostAmount()))
					.multiply(100).divide(useTypeCount.getOriginalAmount().getAmount(), 1).getAmount()
					.setScale(1, BigDecimal.ROUND_DOWN) + "%");//折前毛利率
			useTypeCount.setOriginalTableAvg(useTypeCount.getOriginalAmount().divide(orderCount, 1));//折前桌均
			useTypeCount.setOriginalUseAvg(useTypeCount.getOriginalAmount().divide(useCount, 1));//折前人均

			useTypeCount.setTurnoverProportion("100%");//折后占比
			useTypeCount.setSalesRate((useTypeCount.getSalesAmount().subtract(useTypeCount.getCostAmount()))
					.multiply(100).divide(useTypeCount.getSalesAmount().getAmount(), 1).getAmount()
					.setScale(1, BigDecimal.ROUND_DOWN) + "%");//折后毛利率
			useTypeCount.setRearTableAvg(useTypeCount.getSalesAmount().divide(orderCount, 1));//折后桌均
			useTypeCount.setRearUseAvg(useTypeCount.getSalesAmount().divide(useCount, 1));//折后人均

			useTypeCount.setOptimalProportion("100%");
			useTypeCount.setOptimalRate(
					(useTypeCount.getOptimalFreeGold().multiply(100)
							.divide(useTypeCount.getOriginalAmount().getAmount(), 1)).getAmount().setScale(1,
									BigDecimal.ROUND_DOWN)
							+ "%");//优免率
			useTypeCount.setCanelrate(new BigDecimal(useTypeCount.getCanelCount())
					.multiply(new BigDecimal(100))
					.divide(new BigDecimal(useTypeCount.getFoodCount()), 1, BigDecimal.ROUND_HALF_UP) + "%");//退菜率
			List<RpUseTypeAnalysis> useTypeAnalyzeList = rpUseTypeAnalysisService.getUseTypeAnalyze(rpUseTypeAnalysis);

			for (RpUseTypeAnalysis useTypeAnalyze : useTypeAnalyzeList) {
				BigDecimal orderCount1 = new BigDecimal(useTypeAnalyze.getOrderCount());
				BigDecimal useCount1 = new BigDecimal(useTypeAnalyze.getUseCount());
				useTypeAnalyze.setUseType(OrdTableEnum.getName(useTypeAnalyze.getUseType()));
				useTypeAnalyze.setShiftId(ReportEnums.getName(useTypeAnalyze.getShiftId()));
				useTypeAnalyze.setOriginalProportion(
						useTypeAnalyze.getOriginalAmount().multiply(100)
								.divide(useTypeCount.getOriginalAmount().getAmount(), 1).getAmount()
								.setScale(1, BigDecimal.ROUND_DOWN) + "%");//折前占比
				useTypeAnalyze
						.setOriginalrate((useTypeAnalyze.getOriginalAmount().subtract(useTypeAnalyze.getCostAmount()))
								.multiply(100).divide(useTypeAnalyze.getOriginalAmount().getAmount(), 1).getAmount()
								.setScale(1, BigDecimal.ROUND_DOWN) + "%");//折前毛利率
				useTypeAnalyze.setOriginalTableAvg(useTypeAnalyze.getOriginalAmount().divide(orderCount1, 1));//折前桌均
				useTypeAnalyze.setOriginalUseAvg(useTypeAnalyze.getOriginalAmount().divide(useCount1, 1));//折前人均

				useTypeAnalyze.setTurnoverProportion(
						useTypeAnalyze.getSalesAmount().multiply(100)
								.divide(useTypeCount.getSalesAmount().getAmount(), 1).getAmount()
								.setScale(1, BigDecimal.ROUND_DOWN) + "%");//折后占比
				useTypeAnalyze.setSalesRate((useTypeAnalyze.getSalesAmount().subtract(useTypeAnalyze.getCostAmount()))
						.multiply(100).divide(useTypeAnalyze.getSalesAmount().getAmount(), 1).getAmount()
						.setScale(1, BigDecimal.ROUND_DOWN)
						+ "%");//折后毛利率
				useTypeAnalyze.setRearTableAvg(useTypeAnalyze.getSalesAmount().divide(orderCount1, 1));//折后桌均
				useTypeAnalyze.setRearUseAvg(useTypeAnalyze.getSalesAmount().divide(useCount1, 1));//折后人均

				useTypeAnalyze.setOptimalProportion(
						useTypeAnalyze.getOptimalFreeGold().multiply(100)
								.divide(useTypeCount.getOptimalFreeGold().getAmount(), 1).getAmount()
								.setScale(1, BigDecimal.ROUND_DOWN) + "%");//优免占比
				useTypeAnalyze.setOptimalRate(
						(useTypeAnalyze.getOptimalFreeGold().multiply(100)
								.divide(useTypeCount.getOriginalAmount().getAmount(), 1)).getAmount().setScale(1,
										BigDecimal.ROUND_DOWN)
								+ "%");//优免率
				useTypeAnalyze.setCanelrate(new BigDecimal(useTypeAnalyze.getCanelCount()).multiply(new BigDecimal(100))
						.divide(new BigDecimal(useTypeAnalyze.getFoodCount()), 1, BigDecimal.ROUND_HALF_UP) + "%");//退菜率
			}
			useTypeAnalyzeList.add(useTypeCount);
			model.addAttribute("useTypeAnalyzeList", useTypeAnalyzeList);
			model.addAttribute("selectStoreId", storeId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "modules/report/analyze/useTypeAnalyze";
	}
}
