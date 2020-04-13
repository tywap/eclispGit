package com.jinchuan.pms.cyms.modules.setting.web;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.jinchuan.pms.cyms.modules.setting.entity.CtFood;
import com.jinchuan.pms.cyms.modules.setting.entity.CtFoodStore;
import com.jinchuan.pms.cyms.modules.setting.service.CtFoodService;
import com.jinchuan.pms.cyms.modules.setting.service.CtFoodStoreService;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.utils.money.Money;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.entity.SysBusiConfig;
import com.jinchuan.pms.pub.modules.sys.enums.SysConfigTypeEnum;
import com.jinchuan.pms.pub.modules.sys.service.SysBusiConfigService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 菜品打印机
 *@author LiLingJie
 *@Description
 *@Date 2019年10月14日 下午2:19:15
 */
@Controller
@RequestMapping(value = "${adminPath}/setting/ctFoodPrinter")
public class CtFoodPrinterController extends BaseController {

	@Autowired
	CtFoodService ctFoodService;
	@Autowired
	SysBusiConfigService sysBusiConfigService;
	@Autowired
	CtFoodStoreService ctFoodstoreService;

	@RequestMapping(value = "list")
	public String list(HttpServletRequest request, HttpServletResponse response, Model model) {
		model.addAttribute("selectStoreId", "pmscy");
		return "modules/setting/foodset/ctFoodPrinter";
	}

	/**
	 * @Title: foodPrinter  
	 * 分店菜品列表
	 * @throws
	 */
	@RequestMapping(value = "StoreFoodList")
	public String foodPrinter(HttpServletRequest request, HttpServletResponse response, String storeId, Model model,String foodId) {
		String rentId=UserUtils.getUser().getRentId();
		try {
			//获取对应餐厅的菜品
			List<CtFood> ctFoodList = ctFoodService.getStoreFood(rentId,storeId,foodId);
			for (CtFood ctFood : ctFoodList) {
				String printerId = ctFood.getPrinterId();
				//获取菜品对应打印机
				if (printerId != null && !printerId.equals("")) {
					List<SysBusiConfig> printerList = sysBusiConfigService.getStoreFoodPrinter(printerId);
					List<String> printerNameList = new ArrayList<String>();
					for (SysBusiConfig sysBusiConfig : printerList) {
						printerNameList.add(sysBusiConfig.getParamKey());
					}
					ctFood.setPrinterName(printerNameList);
				}
			}
			model.addAttribute("storeFoodList", ctFoodList);
			model.addAttribute("selectStoreId", storeId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "modules/setting/foodset/ctFoodPrinter";
	}

	/**
	 * @Title: foodPrinterFron  
	 * 分店对应打印机
	 * @throws
	 */
	@RequestMapping(value = "foodPrinterFron")
	public String foodPrinterFron(HttpServletRequest request, HttpServletResponse response, String storeId, Model model,
			String foodIdList, String id) {
		List<String> foodPrinterId = new ArrayList<>();
		try {
			if (id != null && !"".equals(id)) {
				CtFoodStore foodStore = ctFoodstoreService.get(id);
				foodPrinterId.add(foodStore.getPrinter());
				foodIdList = id;
			}
			List<SysBusiConfig> sysBusiConfigList = sysBusiConfigService.getByType(storeId,
					SysConfigTypeEnum.foodPrinter.getType());
			model.addAttribute("foodPrinterList", sysBusiConfigList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("foodStore", foodPrinterId);
		model.addAttribute("foodIdList", foodIdList);
		return "modules/setting/foodset/ctFoodPrinterFrom";

	}
	
	/**
	 * @Title: configuringPrinters  
	 * 配置菜品打印机
	 * @throws
	 */
	@RequestMapping(value = "configuringPrinters")
	@ResponseBody
	public ProcessResult configuringPrinters(HttpServletRequest request, HttpServletResponse response,
			String printersId, Model model, String foodIdList) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String[] storeIds = foodIdList.split(",");
			for (String storeId : storeIds) {
				ctFoodstoreService.updatePrinte(storeId, printersId);
			}
			result = new ProcessResult("000000", "操作成功");
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}
	
	
	/**
	 * @Title: foodPriceFron  
	 * 分店菜品价格
	 * @throws
	 */
	@RequestMapping(value = "foodPriceFrom")
	public String foodPriceFrom(HttpServletRequest request, HttpServletResponse response, String storeId, Model model,
			String foodIdList) {
		try {
			String [] foodIds= foodIdList.split(",");
			List<CtFoodStore> ctFoodStoreList=new ArrayList<CtFoodStore>();
			for (int i = 0; i < foodIds.length; i++) {
				CtFoodStore ctFoodStore = ctFoodstoreService.getFood(foodIds[i]);
				ctFoodStoreList.add(ctFoodStore);
			}
			model.addAttribute("ctFoodStoreList", ctFoodStoreList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "modules/setting/foodset/ctFoodPriceFrom";

	}

	/**
	 * @Title: configuringPrice  
	 * 配置菜品价格
	 * @throws
	 */
	@RequestMapping(value = "configuringPrice")
	@ResponseBody
	public ProcessResult configuringPrice(HttpServletRequest request, HttpServletResponse response, String priceList,
			Model model, String foodIdList) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String[] storeIds = foodIdList.split(",");
			String[] prices = priceList.split(",");
			for (int i = 0; i < storeIds.length; i++) {
				CtFoodStore ctFoodStore = ctFoodstoreService.get(storeIds[i]);
				ctFoodStore.setUpdateDate(new Date());
				ctFoodStore.setPrice(new Money(prices[i]));
				ctFoodstoreService.save(ctFoodStore);
			}
			result = new ProcessResult("000000", "操作成功");
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}
}
