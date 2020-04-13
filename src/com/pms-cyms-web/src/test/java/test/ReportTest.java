package test;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.AbstractJUnit4SpringContextTests;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.jinchuan.pms.cyms.modules.task.service.NightAnalysisReportService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath*:/spring-context*.xml")
public class ReportTest extends AbstractJUnit4SpringContextTests {
	Logger log = LoggerFactory.getLogger(ReportTest.class);
	@Autowired
	NightAnalysisReportService nightAnalysisReportService;

	@Test
	public void test() throws JsonProcessingException {
		try {
			log.info("开始测试");
			long beginTime = System.currentTimeMillis();
			String rentId = "1000000385";
			String storeId = "1000000402";
			String nowdate = "2019-12-16";
			// 初始化
			nightAnalysisReportService.setReportInfo(storeId, nowdate, rentId);
			// 钱箱余额表
			nightAnalysisReportService.createCashboxSummary();
			// 菜品销售分析表
			nightAnalysisReportService.insertRpFoodAnalysis();
			// 订单分析表
			nightAnalysisReportService.insertRpOrderAnalysis();
			// 客源分析表
			nightAnalysisReportService.insertRpSourceAnalysis();
			// 台位分析表
			nightAnalysisReportService.insertRpTableAnalysis();
			// 用餐类型分析表
			nightAnalysisReportService.insertRpUseTypeAnalysis();
			log.info("测试完成,耗时={}秒", (System.currentTimeMillis() - beginTime) / 1000);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
