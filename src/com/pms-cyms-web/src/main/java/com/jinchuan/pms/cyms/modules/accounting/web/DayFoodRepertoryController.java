package com.jinchuan.pms.cyms.modules.accounting.web;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.jinchuan.pms.cyms.modules.setting.entity.CtFood;
import com.jinchuan.pms.cyms.modules.setting.entity.CtFoodType;
import com.jinchuan.pms.cyms.modules.setting.service.CtFoodCfgService;
import com.jinchuan.pms.cyms.modules.setting.service.CtFoodService;
import com.jinchuan.pms.cyms.modules.setting.service.CtFoodStoreService;
import com.jinchuan.pms.cyms.modules.setting.service.CtFoodTypeService;
import com.jinchuan.pms.cyms.modules.setting.service.CtTableTypeService;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.utils.DateUtils;
import com.jinchuan.pms.pub.common.utils.ObjectUtils;
import com.jinchuan.pms.pub.common.utils.StringUtils;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.service.SysBusiConfigService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 当日库存
 *@author LiLingJie
 *@Description
 *@Date 2019年10月23日 上午10:09:44
 */
@Controller
@RequestMapping(value = "${adminPath}/accounting/dayFoodRepertory")
public class DayFoodRepertoryController extends BaseController {


	@Autowired
	CtFoodTypeService ctFoodTypeService;
	@Autowired
	SysBusiConfigService busiConfig;
	@Autowired
	CtTableTypeService ctTableTypeService;
	@Autowired
	CtFoodService ctFoodService;
	@Autowired
	CtFoodCfgService ctFoodCfgService;
	@Autowired
	CtFoodStoreService ctFoodStoreService;

	@ModelAttribute
	public CtFood get(@RequestParam(required = false) String id) {
		CtFood entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = ctFoodService.get(id);
		}
		if (entity == null) {
			entity = new CtFood();
		}
		return entity;
	}

	/**
	 * 
	 * @Title: list  
	 * 当日库存列表
	 * @throws
	 */
	@RequestMapping(value = "list")
	public String list(CtFood ctFood, HttpServletRequest request, HttpServletResponse response, Model model) {
		String storeId = ctFood.getFoodStoreId();
		String rentId = UserUtils.getUser().getRentId();
		List<CtFoodType> dishesTypeList = new ArrayList<CtFoodType>();
		List<CtFood> ctFoodList = new ArrayList<>();
		CtFoodType ctFoodType = new CtFoodType();
		try {
			String date = "";//账务日期
			List<CtFoodType> bigTypeList = ctFoodTypeService.getBigTypeListl(rentId);
			for (CtFoodType map : bigTypeList) {
				map.setStoreName(new ArrayList<String>());
				dishesTypeList.add(map);
			}
			if (storeId == null) {
				String storeType = UserUtils.getStore().getType();
				if ("3".equals(storeType) || "4".equals(storeType) || "5".equals(storeType)) {
					storeId = UserUtils.getStoreId();
				}
			}
			if (storeId == null || storeId.equals("")) {
				date = UserUtils.getAccountDate(rentId);
				model.addAttribute("dishesTypeList", dishesTypeList);
				return "modules/account/dayAccounting/dayRepertory";
			} else {
				date = UserUtils.getAccountDate(storeId);
			}
			ctFoodType.setRentId(rentId);
			ctFoodType.setStoreId(storeId);
			ctFood.setFoodStoreId(storeId);
			ctFood.setStatus("1");//设置只查询有菜品的小类
			List<CtFoodType> littleTypeList = ctFoodTypeService.getLittleType(ctFoodType);
			for (CtFoodType map : littleTypeList) {
				String footTypeId = ObjectUtils.toString(map.getId());
				map.setStoreName(ctFoodTypeService.getStoreName(footTypeId));
				dishesTypeList.add(map);

//				Iterator<CtFoodType> iterator = littleTypeList.iterator();
			}
			ctFood.setCreateAccountDate(date);
			ctFoodList = ctFoodService.foodRepertory(ctFood);
//			if (ctFood.getStatus() != null && ctFood.getStatus().equals("1")) {
//				Iterator<CtFood> iterator = ctFoodList.iterator();
//				while (iterator.hasNext()) {
//					CtFood obj = iterator.next();
//					if (obj.getSurplus() <= 0) {
//						iterator.remove();
//					}
//				}
//			}
			model.addAttribute("selectStoreId", storeId);
			model.addAttribute("dishesTypeList", dishesTypeList);
			model.addAttribute("ctFoodList", ctFoodList);
		} catch (Exception e) {
			e.printStackTrace();
			}
		return "modules/account/dayAccounting/dayRepertory";
	}

	/**
	 * 
	 * @Title: setTheChing  
	 * 估清设置
	 * @throws
	 */
	@RequestMapping(value = "setTheChing")
	public String setTheChing(HttpServletRequest request, HttpServletResponse response, Model model) {
		String storeId = request.getParameter("storeId");

		List<CtFood> ctFoodList = new ArrayList<>();//菜品
		//获取当天设置估清的菜品
		try {
			CtFood ctFood = new CtFood();
			ctFood.setFoodStoreId(storeId);
			ctFood.setUpdateDate(new Date());
			ctFood.setRentId(UserUtils.getUser().getRentId());
			ctFoodList = ctFoodService.foodSelect(ctFood);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("storeId", storeId);
		model.addAttribute("ctFoodList", ctFoodList);
		return "modules/account/dayAccounting/setTheChing";
	}

	/**
	 * 
	 * @Title: saveTheChing  
	 * 保存估清设置
	 * @throws
	 */
	@RequestMapping(value = "saveTheChing")
	@ResponseBody
	public ProcessResult saveTheChing(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String storeId = request.getParameter("storeId");
			String[] foodIds = request.getParameter("foodIds").split(",");// 菜品id
			String[] numbers = request.getParameter("numbers").split(",");// 对应数量
			String updateById = UserUtils.getUser().getId();
			String updateDate = DateUtils.getDateTime();
			for (int i = 0; i < foodIds.length; i++) {
				ctFoodStoreService.updateStock(storeId, foodIds[i], numbers[i], updateById, updateDate);
			}
			result = new ProcessResult("000000", "操作成功");
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

}
