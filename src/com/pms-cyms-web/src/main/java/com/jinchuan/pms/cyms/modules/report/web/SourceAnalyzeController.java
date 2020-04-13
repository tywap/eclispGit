package com.jinchuan.pms.cyms.modules.report.web;

import java.math.BigDecimal;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.jinchuan.pms.cyms.modules.report.entity.RpSourceAnalysis;
import com.jinchuan.pms.cyms.modules.report.enums.ReportEnums;
import com.jinchuan.pms.cyms.modules.report.service.RpSourceAnalysisService;
import com.jinchuan.pms.pub.common.utils.DateUtils;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 客源分析
 *@author LiLingJie
 *@Description
 *@Date 2019年11月19日 下午3:19:53
 */
@Controller
@RequestMapping(value = "${adminPath}/report/sourceAnalyze")
public class SourceAnalyzeController extends BaseController {

	@Autowired
	private RpSourceAnalysisService rpSourceAnalysisService;

	@RequestMapping(value = "list")
	private String list(HttpServletRequest request, HttpServletResponse response, Model model,
			RpSourceAnalysis rpSourceAnalysis) {
		String storeId = rpSourceAnalysis.getStoreId();
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
			RpSourceAnalysis sourceCount = rpSourceAnalysisService.getSourceCount(rpSourceAnalysis);//小计行
			if (sourceCount == null) {
				return "modules/report/analyze/sourceAnalyze";
			}
			BigDecimal orderCount = new BigDecimal(sourceCount.getOrderCount());
			BigDecimal useCount = new BigDecimal(sourceCount.getUseCount());
			sourceCount.setSourceName("小计");
			sourceCount.setOriginalProportion("100%");//折前占比
			sourceCount.setOriginalrate((sourceCount.getOriginalAmount().subtract(sourceCount.getCostAmount()))
					.multiply(100).divide(sourceCount.getOriginalAmount().getAmount(), 1).getAmount()
					.setScale(1, BigDecimal.ROUND_DOWN) + "%");//折前毛利率
			sourceCount.setOriginalTableAvg(sourceCount.getOriginalAmount().divide(orderCount, 1));//折前桌均
			sourceCount.setOriginalUseAvg(sourceCount.getOriginalAmount().divide(useCount, 1));//折前人均

			sourceCount.setTurnoverProportion("100%");//折后占比
			sourceCount.setSalesRate((sourceCount.getSalesAmount().subtract(sourceCount.getCostAmount()))
					.multiply(100).divide(sourceCount.getSalesAmount().getAmount(), 1).getAmount()
					.setScale(1, BigDecimal.ROUND_DOWN) + "%");//折后毛利率
			sourceCount.setRearTableAvg(sourceCount.getSalesAmount().divide(orderCount, 1));//折后桌均
			sourceCount.setRearUseAvg(sourceCount.getSalesAmount().divide(useCount, 1));//折后人均

			sourceCount.setOptimalProportion("100%");
			sourceCount.setOptimalRate(
					sourceCount.getOptimalFreeGold().multiply(100)
							.divide(sourceCount.getOriginalAmount().getAmount(), 1).getAmount()
							.setScale(1, BigDecimal.ROUND_DOWN) + "%");//优免率
			sourceCount.setCanelrate(new BigDecimal(sourceCount.getCanelCount()).multiply(new BigDecimal(100))
					.divide(new BigDecimal(sourceCount.getFoodCount()), 1, BigDecimal.ROUND_HALF_UP) + "%");//退菜率
			List<RpSourceAnalysis> listSourceAnalyze = rpSourceAnalysisService.getSourceAnalyze(rpSourceAnalysis);

			for (RpSourceAnalysis SourceAnalyze : listSourceAnalyze) {
				BigDecimal orderCount1 = new BigDecimal(SourceAnalyze.getOrderCount());
				BigDecimal useCount1 = new BigDecimal(SourceAnalyze.getUseCount());
				SourceAnalyze.setShiftId(ReportEnums.getName(SourceAnalyze.getShiftId()));
				SourceAnalyze.setOriginalProportion(
						SourceAnalyze.getOriginalAmount().multiply(100)
								.divide(sourceCount.getOriginalAmount().getAmount(), 1).getAmount()
								.setScale(1, BigDecimal.ROUND_DOWN) + "%");//折前占比
				SourceAnalyze
						.setOriginalrate((SourceAnalyze.getOriginalAmount().subtract(SourceAnalyze.getCostAmount()))
								.multiply(100).divide(SourceAnalyze.getOriginalAmount().getAmount(), 1).getAmount()
								.setScale(1, BigDecimal.ROUND_DOWN) + "%");//折前毛利率
				SourceAnalyze.setOriginalTableAvg(SourceAnalyze.getOriginalAmount().divide(orderCount1, 1));//折前桌均
				SourceAnalyze.setOriginalUseAvg(SourceAnalyze.getOriginalAmount().divide(useCount1, 1));//折前人均

				SourceAnalyze.setTurnoverProportion(
						SourceAnalyze.getSalesAmount().multiply(100).divide(sourceCount.getSalesAmount().getAmount(), 1)
								.getAmount().setScale(1, BigDecimal.ROUND_DOWN) + "%");//折后占比
				SourceAnalyze.setSalesRate((SourceAnalyze.getSalesAmount().subtract(SourceAnalyze.getCostAmount()))
						.multiply(100).divide(SourceAnalyze.getSalesAmount().getAmount(), 1).getAmount()
						.setScale(1, BigDecimal.ROUND_DOWN) + "%");//折后毛利率
				SourceAnalyze.setRearTableAvg(SourceAnalyze.getSalesAmount().divide(orderCount1, 1));//折后桌均
				SourceAnalyze.setRearUseAvg(SourceAnalyze.getSalesAmount().divide(useCount1, 1));//折后人均

				SourceAnalyze.setOptimalProportion(
						SourceAnalyze.getOptimalFreeGold().multiply(100)
								.divide(sourceCount.getOptimalFreeGold().getAmount(), 1).getAmount()
								.setScale(1, BigDecimal.ROUND_DOWN) + "%");//优免占比
				SourceAnalyze.setOptimalRate(
						(SourceAnalyze.getOptimalFreeGold().multiply(100)
								.divide(sourceCount.getOriginalAmount().getAmount(), 1)).getAmount().setScale(1,
										BigDecimal.ROUND_DOWN)
								+ "%");//优免率
				SourceAnalyze.setCanelrate(new BigDecimal(SourceAnalyze.getCanelCount()).multiply(new BigDecimal(100))
						.divide(new BigDecimal(SourceAnalyze.getFoodCount()), 1, BigDecimal.ROUND_HALF_UP) + "%");//退菜率
			}
			listSourceAnalyze.add(sourceCount);
			model.addAttribute("listSourceAnalyze", listSourceAnalyze);
			model.addAttribute("selectStoreId", storeId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "modules/report/analyze/sourceAnalyze";
	}


}
