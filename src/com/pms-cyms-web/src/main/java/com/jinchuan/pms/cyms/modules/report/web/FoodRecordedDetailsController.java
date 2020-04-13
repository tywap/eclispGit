package com.jinchuan.pms.cyms.modules.report.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.jinchuan.pms.cyms.modules.order.entity.OrdTableConsumeItem;
import com.jinchuan.pms.cyms.modules.order.service.OrdTableConsumeItemService;
import com.jinchuan.pms.cyms.modules.setting.entity.CtFoodType;
import com.jinchuan.pms.cyms.modules.setting.entity.CtTableType;
import com.jinchuan.pms.cyms.modules.setting.service.CtTableTypeService;
import com.jinchuan.pms.cyms.modules.setting.service.HtlStoreService;
import com.jinchuan.pms.cyms.modules.setting.service.SourceChannelService;
import com.jinchuan.pms.pub.common.utils.DateUtils;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.entity.SysBusiConfig;
import com.jinchuan.pms.pub.modules.sys.entity.User;
import com.jinchuan.pms.pub.modules.sys.enums.SysConfigTypeEnum;
import com.jinchuan.pms.pub.modules.sys.service.SysBusiConfigService;
import com.jinchuan.pms.pub.modules.sys.service.SystemService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 菜品入账明细
 *@author LiLingJie
 *@Description
 *@Date 2019年11月12日 下午2:16:21
 */
@Controller
@RequestMapping(value = "${adminPath}/report/foodRecordedDetails")
public class FoodRecordedDetailsController extends BaseController {

	@Autowired
	private CtTableTypeService ctTableTypeService;
	@Autowired
	private SourceChannelService sourceChannelService;
	@Autowired
	private SystemService systemService;
	@Autowired
	private SysBusiConfigService sysBusiConfigService;
	@Autowired
	private OrdTableConsumeItemService ordTableConsumeItemService;
	@Autowired
	private HtlStoreService htlStoreService;

	@RequestMapping(value = "list")
	public String list(HttpServletRequest request, HttpServletResponse response, Model model,
			OrdTableConsumeItem ordTable) {
		String storeId = ordTable.getStoreId();
		String rentId = UserUtils.getUser().getRentId();
		List<OrdTableConsumeItem> ordList = new ArrayList<OrdTableConsumeItem>();
		try {
			String date = "";//账务日期
			if (storeId == null || storeId.equals("")) {
				date = UserUtils.getAccountDate(rentId);
				String storeType = UserUtils.getStore().getType();
				if ("3".equals(storeType) || "4".equals(storeType) || "5".equals(storeType)) {
					storeId = UserUtils.getStoreId();
					ordTable.setStoreId(storeId);
					date = UserUtils.getAccountDate(storeId);
				} else {
					ordTable.setDateType("0");
					ordTable.setStrTime(date);
				}
			} else {
				date = UserUtils.getAccountDate(storeId);
			}
			String accountDate = DateUtils.getSpecifiedDayBefore(date);
			CtFoodType ctFoodType = new CtFoodType();
			ctFoodType.setRentId(rentId);
			ctFoodType.setStoreId(storeId);
			ordList = ordTableConsumeItemService.getFoodRecordedDetails(ordTable);
			User user = new User();
			user.setRentId(UserUtils.getUser().getRentId());
			user.setIsSalesman("1");
			List<User> users = systemService.findSalesmanList(user);
			Map<String, String> paramMap = new HashMap<String, String>();
			paramMap.put("type", SysConfigTypeEnum.source.getType());
			paramMap.put("typeParam", "check_visiable='1'");
			paramMap.put("rentId", rentId);
			paramMap.put("storeId", storeId);
			List<SysBusiConfig> sourceList = sourceChannelService.getSource(paramMap); // 客源
			List<CtTableType> ctTableTypeList = ctTableTypeService.getListByStoreId(storeId);
			SysBusiConfig sysBusiConfig = new SysBusiConfig();
			sysBusiConfig.setRentId(rentId);
			sysBusiConfig.setStoreId(storeId);
			sysBusiConfig.setType(SysConfigTypeEnum.floor.getType());
			List<SysBusiConfig> foorlList = sysBusiConfigService.findStoreByWX(sysBusiConfig);
			model.addAttribute("sourceList", sourceList);//客源
			model.addAttribute("ordList", ordList);//订单数据
			model.addAttribute("salesmanList", users);//操作员
			model.addAttribute("selectStoreId", storeId);//分店id
			model.addAttribute("storeName", htlStoreService.get(storeId));//分店名称
			model.addAttribute("ctTableTypeList", ctTableTypeList);//台号类别
			model.addAttribute("foorlList", foorlList);//经营区域
			model.addAttribute("accountDate", accountDate);//账务日期前一天
			model.addAttribute("selectStoreId", storeId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "modules/report/check/foodRecordedDetails";

	}

}
