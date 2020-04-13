package com.jinchuan.pms.cyms.modules.setting.web;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.time.DateFormatUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.jinchuan.pms.cyms.modules.marcebter.service.CtFoodSpecialService;
import com.jinchuan.pms.cyms.modules.setting.entity.CtFood;
import com.jinchuan.pms.cyms.modules.setting.entity.CtFoodCfg;
import com.jinchuan.pms.cyms.modules.setting.entity.CtFoodStore;
import com.jinchuan.pms.cyms.modules.setting.entity.CtFoodType;
import com.jinchuan.pms.cyms.modules.setting.entity.CtTableTypeStore;
import com.jinchuan.pms.cyms.modules.setting.entity.HtlStore;
import com.jinchuan.pms.cyms.modules.setting.enums.FoodEnum;
import com.jinchuan.pms.cyms.modules.setting.service.CtFoodCfgService;
import com.jinchuan.pms.cyms.modules.setting.service.CtFoodService;
import com.jinchuan.pms.cyms.modules.setting.service.CtFoodStoreService;
import com.jinchuan.pms.cyms.modules.setting.service.CtFoodTypeService;
import com.jinchuan.pms.cyms.modules.setting.service.CtTableTypeService;
import com.jinchuan.pms.cyms.modules.setting.service.HtlStoreService;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.exception.BusinessException;
import com.jinchuan.pms.pub.common.mapper.JsonMapper;
import com.jinchuan.pms.pub.common.utils.DateUtils;
import com.jinchuan.pms.pub.common.utils.ObjectUtils;
import com.jinchuan.pms.pub.common.utils.StringUtils;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.entity.SysBusiConfig;
import com.jinchuan.pms.pub.modules.sys.enums.SysConfigTypeEnum;
import com.jinchuan.pms.pub.modules.sys.service.SysBusiConfigService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 菜品设置
 *@author LiLingJie
 *@Description
 *@Date 2019年9月10日 下午6:11:47
 */
@Controller
@RequestMapping(value = "${adminPath}/setting/ctFood")
public class CtFoodController extends BaseController {

	@Autowired
	CtFoodTypeService CtFoodTypeService;
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
	@Autowired
	CtFoodSpecialService ctFoodSpecialService;
	@Autowired
	HtlStoreService htlStoreService;
	@Autowired
	CtFoodTypeService ctFoodTypeService;

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
	 * 菜品设置列表
	 */
	@RequestMapping(value = "list")
	public String list(CtFood ctFood, HttpServletRequest request, HttpServletResponse response, Model model) {
		List<CtFoodType> dishesTypeList = new ArrayList<CtFoodType>();
		List<CtFood> ctFoodList = new ArrayList<>();
		String rentId = UserUtils.getUser().getRentId();
		CtFoodType ctFoodType=new CtFoodType();
		ctFoodType.setRentId(rentId);
		try {
			List<CtFoodType> bigTypeList = CtFoodTypeService.getBigTypeList(null, rentId);
			for (CtFoodType map : bigTypeList) {
				map.setStoreName(new ArrayList<String>());
				dishesTypeList.add(map);
			}
			List<CtFoodType> littleTypeList = CtFoodTypeService.getLittleType(ctFoodType);
			for (CtFoodType map : littleTypeList) {
				String footTypeId = ObjectUtils.toString(map.getId());
				map.setStoreName(CtFoodTypeService.getStoreName(footTypeId));
				dishesTypeList.add(map);
			}
			ctFood.setRentId(rentId);
			ctFoodList = ctFoodService.getFoodList(ctFood);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("dishesTypeList", dishesTypeList);
		model.addAttribute("ctFoodList", ctFoodList);
		return "modules/setting/foodset/dishesSettingList";
	}

	/**
	 * 菜品详情
	 */
	@RequestMapping(value = "form")
	public String form(HttpServletRequest request, HttpServletResponse response, CtFood ctFood, Model model) {
		List<SysBusiConfig> foodUnitsList = new ArrayList<>();//单位
		List<SysBusiConfig> foodTypeList = new ArrayList<>();//菜品类别
		List<CtFoodType> littleTypeList = new ArrayList<>();//菜品小类
		List<CtFoodCfg> foodCfgList = new ArrayList<>();//关联类别
		List<CtFood> foodList = new ArrayList<>();//套餐包含菜品
		List<CtFoodStore> storeList = new ArrayList<>();//分店
		String rentid = UserUtils.getUser().getRentId();
		CtFoodType ctFoodTypea=new CtFoodType();
		ctFoodTypea.setRentId(rentid);
		try {
			storeList = ctFoodService.getStoreId(ctFood.getId());
			SysBusiConfig sysBusiConfig = new SysBusiConfig();
			sysBusiConfig.setRentId(UserUtils.getUser().getRentId());
			sysBusiConfig.setType(SysConfigTypeEnum.foodUnits.getType());
			foodUnitsList = busiConfig.findList(sysBusiConfig);
			sysBusiConfig.setType(SysConfigTypeEnum.foodType.getType());
			foodTypeList = busiConfig.findList(sysBusiConfig);
			littleTypeList = CtFoodTypeService.getLittleType(ctFoodTypea);
			for (SysBusiConfig ctFoodType : foodTypeList) {
				if (ctFoodType.getId().equals(ctFood.getPackageType())) {
					ctFood.setPackageTypeName(ctFoodType.getName());
				}
			}
			if (ctFood.getId() != null && !ctFood.getId().equals("")) {
				CtFoodCfg foodCfg = new CtFoodCfg();
				foodCfg.setFoodId(ctFood.getId());
				foodCfgList = ctFoodCfgService.findList(foodCfg);
				if (ctFood.getPackageType().equals(FoodEnum.setMeal.getCode())) {
					for (CtFoodCfg cfg : foodCfgList) {
						CtFood food = ctFoodService.get(cfg.getKey());
						foodList.add(food);
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("ctFood", ctFood);
		model.addAttribute("foodList", foodList);
		model.addAttribute("storeList", storeList);
		model.addAttribute("foodCfgList", foodCfgList);
		model.addAttribute("foodTypeList", foodTypeList);
		model.addAttribute("foodUnitsList", foodUnitsList);
		model.addAttribute("littleTypeList", littleTypeList);
		return "modules/setting/foodset/dishesSettingForm";
	}

	/**
	 * 菜品选择列表
	 */
	@RequestMapping(value = "select")
	public String select(CtFood ctFood, HttpServletRequest request, HttpServletResponse response, Model model) {
		List<CtFoodType> dishesTypeList = new ArrayList<CtFoodType>();//菜品小类
		List<CtFood> ctFoodList = new ArrayList<>();//菜品
		List<CtFoodType> bigTypeList = new ArrayList<>();//菜品大类
		String rentId = UserUtils.getUser().getRentId();
		CtFoodType ctFoodType=new CtFoodType();
		ctFoodType.setRentId(rentId);
		String status = ctFood.getStatus();
		ctFood.setRentId(rentId);
		try {
			dishesTypeList = CtFoodTypeService.getLittleType(ctFoodType);
			ctFoodList = ctFoodService.foodSelect(ctFood);
			bigTypeList = CtFoodTypeService.getBigTypeList(null, rentId);
			for (CtFood food : ctFoodList) {
				String foodBigType = ctFoodService.getFoodBigType(food.getFoodType());
				food.setFoodBigType(foodBigType);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("status", status);
		model.addAttribute("dishesTypeList", dishesTypeList);
		model.addAttribute("ctFoodList", ctFoodList);
		model.addAttribute("bigTypeList", bigTypeList);
		return "modules/setting/foodset/dishesSettingSelect";
	}

	/**
	 * 查询菜品
	 */
	@RequestMapping(value = "foodSelect")
	@ResponseBody
	public ProcessResult foodSelect(CtFood ctFood, Model model, RedirectAttributes redirectAttributes) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		List<CtFood> foodList = new ArrayList<>();
		try {
			foodList.add(ctFood);
			result = new ProcessResult("000000", "操作成功", foodList);
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

	/**
	 * 获取做法
	 * @Title: getModus  
	 * @return ProcessResult 
	 * @throws
	 */
	@RequestMapping(value = "getModus")
	@ResponseBody
	public ProcessResult getModus(Model model, HttpServletRequest request, HttpServletResponse response) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		SysBusiConfig sysBusiConfig = new SysBusiConfig();
		Map<String, Object> modusMap = new HashMap<String, Object>();
		try {
			List<SysBusiConfig> modusList = new ArrayList<SysBusiConfig>();//做法类别
			List<SysBusiConfig> modusTypeList = new ArrayList<SysBusiConfig>();//做法
			sysBusiConfig.setRentId(UserUtils.getUser().getRentId());
			sysBusiConfig.setType(SysConfigTypeEnum.cookKey.getType());
			modusList = busiConfig.findList(sysBusiConfig);
			for (SysBusiConfig modus : modusList) {
				sysBusiConfig.setType(SysConfigTypeEnum.cookValue.getType());
				sysBusiConfig.setParentId(modus.getId());
				modusTypeList = busiConfig.findList(sysBusiConfig);
				List<SysBusiConfig> modusType = new ArrayList<>();
				for (SysBusiConfig sysBusiConfig2 : modusTypeList) {
					modusType.add(sysBusiConfig2);
				}
				modusMap.put(modus.getId() + "," + modus.getName(), modusType);
			}
			result = new ProcessResult("000000", "操作成功", modusMap);
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

	/**
	 * 查询分店菜品
	 * @Title: saveLittle
	 * @return_type: ProcessResult
	 */
	@RequestMapping(value = "getListByStoreId")
	@ResponseBody
	public ProcessResult getListByStoreId(HttpServletRequest request, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String storeId = request.getParameter("storeId");
			String foodType = request.getParameter("foodType");
			String foodName = request.getParameter("foodName");
			String orderId = request.getParameter("orderId");
			String rentId = UserUtils.getUser().getRentId();
			String date = "";//账务日期
			if (storeId == null || storeId.equals("")) {
				date = UserUtils.getAccountDate(rentId);
			} else {
				date = UserUtils.getAccountDate(storeId);
			}
			String formatDate = DateFormatUtils.format(new Date(), "yyyy-MM-dd");
			String andValue = String.valueOf(DateUtils.getWeekByDate(formatDate));// 获取当前星期
			List<CtFood> ctFoods = ctFoodService.getListByStoreId(storeId, foodType, foodName, date, andValue, orderId);
			Map<String, Object> ret = new HashMap<String, Object>();
			ret.put("list", ctFoods);
			result = new ProcessResult("000000", "操作成功", ret);
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

	/**
	 * 保存菜品
	 */
	@Transactional(readOnly = false)
	@RequestMapping(value = "save")
	@ResponseBody
	public ProcessResult save(CtFood ctfood, HttpServletRequest request, HttpServletResponse response) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			ctFoodService.save(ctfood);
			//关联分店
			List<CtFoodStore> foodStoreList = ctFoodStoreService.foodStoreList(ctfood.getId());
			for (String store : ctfood.getStoreName()) {
				CtFoodStore ctFoodStore1 = ctFoodStoreService.getFoodStore(ctfood.getId(), store);
				if (ctFoodStore1 == null) {
					ctFoodStore1 = new CtFoodStore();
					ctFoodStore1.setStoreId(store);
				}
				//ctFoodStore1.setStock(999);//初始化库存
				ctFoodStore1.setPrice(ctfood.getPrice());
				ctFoodStore1.setFoodId(ctfood.getId());
				ctFoodStoreService.save(ctFoodStore1);
			}
			//删除
			ctFoodStoreService.deleteFood(foodStoreList, ctfood);
			//新增套餐关联
			if (ctfood.getPackageType().equals(FoodEnum.setMeal.getCode())) {
				List<String> foodIds = ctfood.getFoodIds();//菜品id
				List<String> numbers = ctfood.getNumbers();//数量
				ctFoodCfgService.addSetMeal(foodIds, numbers, ctfood);
			}
			//新增做法关联
			if (ctfood.getPackageType().equals(FoodEnum.modus.getCode())) {
				List<String> foodTypes = ctfood.getFoodTypes();//做法类别
				CtFoodCfg cfg = new CtFoodCfg();
				cfg.setFoodId(ctfood.getId());
				Map settingInfoMap = (Map) JsonMapper.fromJsonString(ctfood.getTypes().replace("&quot;", "\""),
						HashMap.class);//做法
				ctFoodCfgService.addModus(foodTypes, cfg, settingInfoMap, ctfood);
			}
			result = new ProcessResult("000000", "操作成功");
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
			throw new BusinessException("菜品" + ctfood.getName() + "新增失败");
		}
		return result;
	}

	/**
	 * 查询小类配置的餐厅
	 * @Title: getOfficeListByType  
	 * @param @param request
	 * @param @param response
	 * @param @param model
	 * @param @return 
	 * @return String 
	 * @throws
	 */
	@RequestMapping(value = "getFoodStore")
	@ResponseBody
	public ProcessResult getOfficeListByType(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		String foodTypeId = request.getParameter("foodTypeId");//小类id
		List<HtlStore> htlStore = new ArrayList<HtlStore>();
		List<CtTableTypeStore> storeList = ctFoodTypeService.getStoreId(foodTypeId);//小类关联分店
		List<String> storeIdList = new ArrayList<String>();
		for (CtTableTypeStore ctTableTypeStore : storeList) {
			storeIdList.add(ctTableTypeStore.getStoreId());
		}
		//若无关联分店 所有分店展示
		if (storeIdList.size() == 0) {
			HtlStore store = new HtlStore();
			store.setRentId(UserUtils.getUser().getRentId());
			htlStore = htlStoreService.findList(store);
		} else {
			htlStore = htlStoreService.findListByIds(storeIdList);
		}
		result.setRetCode("000000");
		result.setRetMsg("操作成功");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("lists", htlStore);
		result.setRet(map);
		return result;
	}

}
