package com.jinchuan.pms.cyms.modules.report.web;

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
import org.springframework.web.bind.annotation.ResponseBody;

import com.jinchuan.pms.cyms.modules.accounting.enums.OrdTableEnum;
import com.jinchuan.pms.cyms.modules.order.entity.OrdTable;
import com.jinchuan.pms.cyms.modules.order.enums.OrdStatusEnum;
import com.jinchuan.pms.cyms.modules.order.service.OrdPaymentFundService;
import com.jinchuan.pms.cyms.modules.order.service.OrdTableService;
import com.jinchuan.pms.cyms.modules.setting.entity.CtFoodType;
import com.jinchuan.pms.cyms.modules.setting.entity.CtTableType;
import com.jinchuan.pms.cyms.modules.setting.service.CtFoodTypeService;
import com.jinchuan.pms.cyms.modules.setting.service.CtTableTypeService;
import com.jinchuan.pms.cyms.modules.setting.service.SourceChannelService;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.utils.DateUtils;
import com.jinchuan.pms.pub.common.utils.ObjectUtils;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.entity.SysBusiConfig;
import com.jinchuan.pms.pub.modules.sys.entity.User;
import com.jinchuan.pms.pub.modules.sys.enums.SysConfigTypeEnum;
import com.jinchuan.pms.pub.modules.sys.service.SysBusiConfigService;
import com.jinchuan.pms.pub.modules.sys.service.SystemService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 账单明细
 *@author LiLingJie
 *@Description
 *@Date 2019年11月8日 上午11:35:07
 */
@Controller
@RequestMapping(value = "${adminPath}/report/checkDetails")
public class CheckDetailsController extends BaseController {

	@Autowired
	private OrdTableService ordTableService;
	@Autowired
	private CtTableTypeService ctTableTypeService;
	@Autowired
	private SourceChannelService sourceChannelService;
	@Autowired
	private SystemService systemService;
	@Autowired
	private CtFoodTypeService ctFoodTypeService;
	@Autowired
	private SysBusiConfigService sysBusiConfigService;
	@Autowired
	private OrdPaymentFundService ordPaymentFundService;

	@RequestMapping(value = "list")
	public String checkDetailsList(HttpServletRequest request, HttpServletResponse response, Model model,
			OrdTable ordTable) {
		String storeId = ordTable.getStoreId();
		String rentId = UserUtils.getUser().getRentId();
		List<OrdTable> ordList = new ArrayList<OrdTable>();
		List<CtFoodType> foodTypeList = new ArrayList<CtFoodType>();
		List<SysBusiConfig> payWayList = new ArrayList<SysBusiConfig>();
		List<Map<String, Object>> ordFoodTypeList = new ArrayList<Map<String, Object>>();
		String date = "";//账务日期
		try {
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
			foodTypeList = ctFoodTypeService.getLittleType(ctFoodType);
			ordList = ordTableService.ordTableList(ordTable);
			SysBusiConfig sys = new SysBusiConfig();
			sys.setRentId(rentId);
			sys.setStatus("1");
			sys.setType(SysConfigTypeEnum.payWay.getType());
			payWayList = sysBusiConfigService.findList(sys);
			Map<String, Object> typeMaps = new LinkedHashMap<String, Object>();
			typeMaps.put("priceSubtotal", "0.00");
			for (CtFoodType map : foodTypeList) {
				typeMaps.put(map.getId(), "0.00");
			}
			Map<String, Object> payMaps = new LinkedHashMap<String, Object>();
			payMaps.put("paySubtotal", "0.00");
			for (SysBusiConfig map : payWayList) {
				payMaps.put(map.getParamKey(), "0.00");
			}
			for (OrdTable ordTable2 : ordList) {
				ordTable2.setStatus(OrdStatusEnum.getByCode(ordTable2.getStatus()).getMessage());
				if (ordTable2.getUseType() != null) {
					ordTable2.setUseType(OrdTableEnum.getByCode(ordTable2.getUseType()).getMessage());
				}
				List<Map<String, Object>> priceMap = ordTableService.getFoodTypePrice(ordTable2.getId());
				List<Map<String, Object>> checkMap = ordPaymentFundService.getCheck(rentId, ordTable2.getId(), null);
				double priceSubtotal = 0;
				double paySubtotal = 0;
				Map<String, Object> payMap = new HashMap<String, Object>();
				payMap.putAll(payMaps);
				Map<String, Object> typeMap = new HashMap<String, Object>();
				typeMap.putAll(typeMaps);
				for (Map<String, Object> map : priceMap) {
					if (map != null && !map.isEmpty() && map.get("foodTypeId") != null) {
						priceSubtotal += Double.valueOf(ObjectUtils.toString(map.get("foodTypePrice")));

						typeMap.put(ObjectUtils.toString(map.get("foodTypeId")),
								ObjectUtils.toString(map.get("foodTypePrice")));
					}
				}
				for (Map<String, Object> map : checkMap) {
					if (map != null && !map.isEmpty()) {
						paySubtotal += Double.valueOf(ObjectUtils.toString(map.get("amount")));
						payMap.put(ObjectUtils.toString(map.get("payMethod")),
								ObjectUtils.toString(map.get("amount")));
					}
				}
				payMap.put("paySubtotal", paySubtotal);
				typeMap.put("priceSubtotal", priceSubtotal);
				ordTable2.setFoodTypePrice(typeMap);
				ordTable2.setPayWayPrice(payMap);
			}
			User user = new User();
			user.setRentId(UserUtils.getUser().getRentId());
			user.setIsSalesman("1");
			List<User> users = systemService.findSalesmanList(user);
			Map<String, String> paramMap = new HashMap<String, String>();
			paramMap.put("type", SysConfigTypeEnum.source.getType());
			paramMap.put("typeParam", "check_visiable='1'");
			paramMap.put("rentId", rentId);
//			paramMap.put("storeId", storeId);
			List<SysBusiConfig> sourceList = sourceChannelService.getSource(paramMap); // 客源
			List<CtTableType> ctTableTypeList = ctTableTypeService.getListByStoreId(storeId);
			SysBusiConfig sysBusiConfig = new SysBusiConfig();
			sysBusiConfig.setRentId(rentId);
//			sysBusiConfig.setStoreId(storeId);
			sysBusiConfig.setType(SysConfigTypeEnum.floor.getType());
			List<SysBusiConfig> foorlList = sysBusiConfigService.findStoreByWX(sysBusiConfig);
			model.addAttribute("sourceList", sourceList);//客源
			model.addAttribute("ordList", ordList);//订单数据
			model.addAttribute("salesmanList", users);//操作员
			model.addAttribute("foodTypeList", foodTypeList);//消费小类
			model.addAttribute("payWayList", payWayList);//收款
			model.addAttribute("ordFoodTypeList", ordFoodTypeList);//消费小类金额
			model.addAttribute("selectStoreId", storeId);//分店id
//			model.addAttribute("storeName", htlStoreService.get(storeId));//分店名称
			model.addAttribute("ctTableTypeList", ctTableTypeList);//台号类别
			model.addAttribute("foorlList", foorlList);//经营区域
			model.addAttribute("accountDate", accountDate);//账务日期前一天
			model.addAttribute("selectStoreId", storeId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "modules/report/check/checkDetails";

	}

	@RequestMapping(value = "getComboBox")
	@ResponseBody
	public ProcessResult getComboBox(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		String storeId = request.getParameter("storeId");
		String rentId = UserUtils.getUser().getRentId();
		try {
			List<CtTableType> ctTableTypeList = ctTableTypeService.getListByStoreId(storeId);
			SysBusiConfig sysBusiConfig = new SysBusiConfig();
			sysBusiConfig.setRentId(rentId);
			sysBusiConfig.setStoreId(storeId);
			sysBusiConfig.setType(SysConfigTypeEnum.floor.getType());
			List<SysBusiConfig> foorlList = sysBusiConfigService.findStoreByWX(sysBusiConfig);
			result = new ProcessResult("000000", "操作成功");
			result.setList(ctTableTypeList);
			result.setTmp(foorlList);
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

	@RequestMapping(value = "storeData")
	@ResponseBody
	public List<Map<String, Object>> storeData(HttpServletResponse response) {
		return UserUtils.storeData();
	}
}
