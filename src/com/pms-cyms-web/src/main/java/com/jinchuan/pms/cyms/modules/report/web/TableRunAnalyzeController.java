package com.jinchuan.pms.cyms.modules.report.web;

import java.math.BigDecimal;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.jinchuan.pms.cyms.modules.report.entity.RpTableAnalysis;
import com.jinchuan.pms.cyms.modules.report.enums.ReportEnums;
import com.jinchuan.pms.cyms.modules.report.service.RpTableAnalysisService;
import com.jinchuan.pms.cyms.modules.setting.entity.CtTableType;
import com.jinchuan.pms.cyms.modules.setting.service.CtTableTypeService;
import com.jinchuan.pms.pub.common.utils.DateUtils;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 台位经营分析
 *@author ty
 *@Description
 *@Date 2019年11月18日 上午10:00:16
 */
@Controller
@RequestMapping(value = "${adminPath}/report/tableRunAnalyze")
public class TableRunAnalyzeController extends BaseController {

	@Autowired
	private RpTableAnalysisService rpTableAnalysisService;
	@Autowired
	private CtTableTypeService ctTableTypeService;

	@RequestMapping(value = "list")
	private String list(HttpServletRequest request, HttpServletResponse response, Model model,
			RpTableAnalysis rpTableAnalysis) {
		String storeId = rpTableAnalysis.getStoreId();
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
			RpTableAnalysis tableCount = rpTableAnalysisService.getTableCount(rpTableAnalysis);//小计行
			List<CtTableType> ctTableTypeList = ctTableTypeService.findList(new CtTableType());
			if (tableCount == null) {
				return "modules/report/analyze/tableAnalyze";
			}
			BigDecimal orderCount = new BigDecimal(tableCount.getOrderCount());
			BigDecimal useCount = new BigDecimal(tableCount.getUseCount());
			tableCount.setTableType("小计");
			tableCount.setOriginalProportion("100%");//折前占比
			tableCount.setOriginalrate((tableCount.getOriginalAmount().subtract(tableCount.getCostAmount()))
					.multiply(100).divide(tableCount.getOriginalAmount().getAmount(), 1).getAmount()
					.setScale(1, BigDecimal.ROUND_DOWN) + "%");//折前毛利率
			tableCount.setOriginalTableAvg(tableCount.getOriginalAmount().divide(orderCount, 1));//折前桌均
			tableCount.setOriginalUseAvg(tableCount.getOriginalAmount().divide(useCount, 1));//折前人均

			tableCount.setTurnoverProportion("100%");//折后占比
			tableCount.setSalesRate((tableCount.getSalesAmount().subtract(tableCount.getCostAmount()))
					.multiply(100).divide(tableCount.getSalesAmount().getAmount(), 1).getAmount()
					.setScale(1, BigDecimal.ROUND_DOWN) + "%");//折后毛利率
			tableCount.setRearTableAvg(tableCount.getSalesAmount().divide(orderCount, 1));//折后桌均
			tableCount.setRearUseAvg(tableCount.getSalesAmount().divide(useCount, 1));//折后人均

			tableCount.setOptimalProportion("100%");
			tableCount.setOptimalRate(
					tableCount.getOptimalFreeGold().multiply(100).divide(tableCount.getOriginalAmount().getAmount(), 1)
							.getAmount().setScale(1, BigDecimal.ROUND_DOWN) + "%");//优免率
			tableCount.setCanelrate(
					new BigDecimal(tableCount.getCanelCount())
							.multiply(new BigDecimal(100))
							.divide(new BigDecimal(tableCount.getFoodCount()), 1, BigDecimal.ROUND_HALF_UP) + "%");//退菜率
			List<RpTableAnalysis> listTbaleAnalyze = rpTableAnalysisService.getTableAnalyze(rpTableAnalysis);

			for (RpTableAnalysis tableAnalyze : listTbaleAnalyze) {
				BigDecimal orderCount1 = new BigDecimal(tableAnalyze.getOrderCount());
				BigDecimal useCount1 = new BigDecimal(tableAnalyze.getUseCount());
				tableAnalyze.setShiftId(ReportEnums.getName(tableAnalyze.getShiftId()));
				tableAnalyze.setOriginalProportion(tableAnalyze.getOriginalAmount()
						.multiply(100).divide(tableCount.getOriginalAmount().getAmount(), 1).getAmount()
						.setScale(1, BigDecimal.ROUND_DOWN) + "%");//折前占比
				tableAnalyze.setOriginalrate((tableAnalyze.getOriginalAmount().subtract(tableAnalyze.getCostAmount()))
						.multiply(100).divide(tableAnalyze.getOriginalAmount().getAmount(), 1).getAmount()
						.setScale(1, BigDecimal.ROUND_DOWN) + "%");//折前毛利率
				tableAnalyze.setOriginalTableAvg(tableAnalyze.getOriginalAmount().divide(orderCount1, 1));//折前桌均
				tableAnalyze.setOriginalUseAvg(tableAnalyze.getOriginalAmount().divide(useCount1, 1));//折前人均

				tableAnalyze.setTurnoverProportion(
						tableAnalyze.getSalesAmount().multiply(100).divide(tableCount.getSalesAmount().getAmount(), 1)
								.getAmount().setScale(1, BigDecimal.ROUND_DOWN) + "%");//折后占比
				tableAnalyze.setSalesRate((tableAnalyze.getSalesAmount().subtract(tableAnalyze.getCostAmount()))
						.multiply(100).divide(tableAnalyze.getSalesAmount().getAmount(), 1).getAmount()
						.setScale(1, BigDecimal.ROUND_DOWN) + "%");//折后毛利率
				tableAnalyze.setRearTableAvg(tableAnalyze.getSalesAmount().divide(orderCount1, 1));//折后桌均
				tableAnalyze.setRearUseAvg(tableAnalyze.getSalesAmount().divide(useCount1, 1));//折后人均

				tableAnalyze.setOptimalProportion(tableAnalyze.getOptimalFreeGold()
						.multiply(100).divide(tableCount.getOptimalFreeGold().getAmount(), 1).getAmount()
						.setScale(1, BigDecimal.ROUND_DOWN) + "%");//优免占比
				tableAnalyze.setOptimalRate(
						tableAnalyze.getOptimalFreeGold().multiply(100)
								.divide(tableCount.getOriginalAmount().getAmount(), 1).getAmount()
								.setScale(1, BigDecimal.ROUND_DOWN) + "%");//优免率
				tableAnalyze.setCanelrate(new BigDecimal(tableAnalyze.getCanelCount()).multiply(new BigDecimal(100))
						.divide(new BigDecimal(tableAnalyze.getFoodCount()), 1, BigDecimal.ROUND_HALF_UP) + "%");//退菜率
			}
			listTbaleAnalyze.add(tableCount);
			model.addAttribute("listTbaleAnalyze", listTbaleAnalyze);
			model.addAttribute("ctTableTypeList", ctTableTypeList);
			model.addAttribute("selectStoreId", storeId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "modules/report/analyze/tableAnalyze";
	}

}
