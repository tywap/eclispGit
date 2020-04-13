package com.jinchuan.pms.cyms.modules.setting.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.jinchuan.pms.cyms.modules.setting.entity.CtFoodType;
import com.jinchuan.pms.cyms.modules.setting.entity.CtTableTypeStore;
import com.jinchuan.pms.cyms.modules.setting.service.CtFoodTypeService;
import com.jinchuan.pms.cyms.modules.setting.service.CtTableTypeService;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.utils.ObjectUtils;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.entity.SysBusiConfig;
import com.jinchuan.pms.pub.modules.sys.enums.SysConfigTypeEnum;
import com.jinchuan.pms.pub.modules.sys.service.SysBusiConfigService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 菜品类别设置
 *@author LiLingJie
 *@Date 2019年9月4日 下午3:58:16
 */
@Controller
@RequestMapping(value = "${adminPath}/setting/ctFoodType")
public class CtfoodTypeController extends BaseController {

	@Autowired
	CtFoodTypeService ctFoodTypeService;
	@Autowired
	SysBusiConfigService busiConfig;
	@Autowired
	CtTableTypeService ctTableTypeService;

	/**
	 * 菜品类别列表
	 */
	@RequiresPermissions("setting:ctFoodType:view")
	@RequestMapping(value = "list")
	public String list(HttpServletRequest request, HttpServletResponse response, Model model) {
		List<CtFoodType> dishesList = new ArrayList<CtFoodType>();
		String rentId = UserUtils.getUser().getRentId();
		try {
			List<CtFoodType> bigTypeList = ctFoodTypeService.getBigTypeList(null, rentId);
			for (CtFoodType map : bigTypeList) {
				map.setType("大类");
				map.setStoreName(new ArrayList<String>());
				dishesList.add(map);
			}
			String rentid = UserUtils.getUser().getRentId();
			CtFoodType ctFoodType=new CtFoodType();
			ctFoodType.setRentId(rentid);
			List<CtFoodType> littleTypeList = ctFoodTypeService.getLittleType(ctFoodType);
			for (CtFoodType map : littleTypeList) {
				map.setType("小类");
				String footTypeId = ObjectUtils.toString(map.getId());
				map.setStoreName(ctFoodTypeService.getStoreName(footTypeId));
				dishesList.add(map);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("list", dishesList);
		return "modules/setting/foodset/dishesCategoryList";
	}

	/**
	 * 新增修改菜品类别
	 */
	@RequiresPermissions("setting:ctFoodType:edit")
	@RequestMapping(value = "form")
	public String form(CtFoodType dishesBigType, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		String type = dishesBigType.getType();
		String rentId = UserUtils.getUser().getRentId();
		List<CtFoodType> bigTypeList = new ArrayList<>();
		List<CtTableTypeStore> storelist = new ArrayList<>();
		try {
			if (dishesBigType.getId() != null) {
				if ("0".equals(type)) {
					dishesBigType = ctFoodTypeService.getBigType(dishesBigType.getId());
				} else {
					dishesBigType = ctFoodTypeService.getLittle(dishesBigType.getId());
					storelist = ctFoodTypeService.getStoreId(dishesBigType.getId());
				}
			}
			bigTypeList = ctFoodTypeService.getBigTypeList(null, rentId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("bigTypeList", bigTypeList);
		model.addAttribute("type", dishesBigType.getType());
		model.addAttribute("DishesBigType", dishesBigType);
		model.addAttribute("storelist", storelist);
		if ("0".equals(type)) {
			return "modules/setting/foodset/dishesBigForm";
		} else {
			return "modules/setting/foodset/dishesTypeForm";

		}
	}

	/**
	 * 保存大类
	 * @Title: save  
	 * @throws
	 */
	@RequiresPermissions("setting:ctFoodType:edit")
	@RequestMapping(value = "saveBig")
	@ResponseBody
	public ProcessResult saveBig(SysBusiConfig sysBusiConfig, Model model, RedirectAttributes redirectAttributes) {
		ProcessResult result = new ProcessResult("000000", "操作成功");
		try {
			sysBusiConfig.setType(SysConfigTypeEnum.foodMainType.getType());
			sysBusiConfig.setStatus("1");
			sysBusiConfig.setDescription(SysConfigTypeEnum.foodMainType.getName());
			sysBusiConfig.setParentId("0");
			busiConfig.save(sysBusiConfig);
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetCode("999999");
			result.setRetMsg("操作失败");
			return result;
		}
		return result;
	}

	/**
	 * 保存小类
	 * @Title: save  
	 * @throws
	 */
	@RequiresPermissions("setting:ctFoodType:edit")
	@RequestMapping(value = "saveLittle")
	@ResponseBody
	public ProcessResult saveLittle(CtFoodType dishesBigType, Model model, RedirectAttributes redirectAttributes) {
		ProcessResult result = new ProcessResult("000000", "操作成功");
		try {
			ctFoodTypeService.saveBigType(dishesBigType);
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetCode("999999");
			result.setRetMsg("操作失败");
			return result;
		}
		return result;
	}

	/**
	 * 删除新增修改菜品类别
	 * @Title: save  
	 * @throws
	 */
	@Transactional(readOnly = false)
	@RequiresPermissions("setting:ctFoodType:delete")
	@RequestMapping(value = "delete")
	@ResponseBody
	public ProcessResult delete(String id, String type, Model model, RedirectAttributes redirectAttributes) {
		ProcessResult result = new ProcessResult("000000", "删除成功");
		try {
			if ("0".equals(type)) {
				busiConfig.romve(id);
			} else {
				ctFoodTypeService.deleteLittle(id);
			}
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetCode("999999");
			result.setRetMsg("删除失败");
			return result;
		}
		return result;

	}

	/**
	 * 查询分店菜品小类
	 * @Title: saveLittle
	 * @return_type: ProcessResult
	 */
	@RequestMapping(value = "getListByStoreId")
	@ResponseBody
	public ProcessResult getListByStoreId(HttpServletRequest request, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String rentId = UserUtils.getUser().getRentId();
			String storeId = request.getParameter("storeId");
			List<CtFoodType> ctFoodTypes = ctFoodTypeService.getListByStoreId(storeId, rentId);
			Map<String, Object> ret = new HashMap<String, Object>();
			ret.put("list", ctFoodTypes);
			result = new ProcessResult("000000", "操作成功", ret);
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}
}
