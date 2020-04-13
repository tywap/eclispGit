package com.jinchuan.pms.cyms.modules.ota.web;


import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.jinchuan.pms.cyms.modules.setting.dao.CtFoodCfgDao;
import com.jinchuan.pms.cyms.modules.setting.entity.CtFoodCfg;
import com.jinchuan.pms.cyms.modules.setting.enums.FoodEnum;
import com.jinchuan.pms.cyms.modules.setting.service.CtFoodService;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.exception.BusinessException;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;



/**
 * 菜品图片维护
 *@author ty
 *@Description
 *@Date 2020年1月17日 上午10:45:52
 */
@Controller
@RequestMapping("${adminPath}/ota/foodImgMaintain")
public class OtaFoodImgMaintainController extends BaseController {
	
	@Autowired
	private CtFoodService ctFoodService;
	@Autowired
	private CtFoodCfgDao ctFoodCfgDao;
	/**
	 * 菜品图片列表
	 * @Title: list  
	 * @throws
	 */
	@RequestMapping("list")
	public String list(HttpServletRequest request, HttpServletResponse response, String storeId1, Model model,
			String name) {
		List<CtFoodCfg> ctFoodCfgList = new ArrayList<CtFoodCfg>();
		try {
			ctFoodCfgList = ctFoodCfgDao.getFoodImgList(FoodEnum.foodImg.getCode(), name);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("ctFoodCfgList", ctFoodCfgList);
		return "modules/ota/appOrdering/foodImgMaintain";
	}

	/**
	 * 菜品图片上传界面
	 * @Title: foodImgUpload  
	 * @return String 
	 * @throws
	 */
	@RequestMapping("foodImgUpload")
	public String foodImgUpload(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) {
		return "modules/ota/appOrdering/foodImgUpload";
	}

	/**
	 * 图片名称修改界面
	 * @Title: from  
	 * @return String 
	 * @throws
	 */
	@RequestMapping("form")
	public String form(HttpServletRequest request, HttpServletResponse response, Model model) {
		String id = request.getParameter("id");
		String name = request.getParameter("name");
		model.addAttribute("id", id);
		model.addAttribute("name", name);
		return "modules/ota/appOrdering/foodImgForm";
	}

	@RequestMapping("saveFoodImg")
	@ResponseBody
	public ProcessResult saveFoodImg(HttpServletRequest request, HttpServletResponse response, String fileName,
			String fileUrl) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String[] fileNames = fileName.split(",");
			String[] fileUrls = fileUrl.split(",");
			for (int i = 0; i < fileNames.length; i++) {
				String key = fileNames[i];//图片名称
				String value = fileUrls[i];//图片路径
				String foodId = ctFoodService.getFoodId(key);
				CtFoodCfg ctFoodCfg = new CtFoodCfg();
				ctFoodCfg.setFoodId(foodId);
				ctFoodCfg.setType(FoodEnum.foodImg.getCode());
				ctFoodCfg.setKey(key);
				ctFoodCfg.setValue(value);
				ctFoodCfg.preInsert();
				ctFoodCfgDao.insert(ctFoodCfg);
			}
			result = new ProcessResult("000000", "操作成功");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;

	}

	/**
	 * 修改菜品图片名称
	 * @Title: updateFoodImgName  
	 * @return ProcessResult 
	 * @throws
	 */
	@RequestMapping("updateFoodImgName")
	@ResponseBody
	public ProcessResult updateFoodImgName(HttpServletRequest request, HttpServletResponse response, String id,
			String name) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			CtFoodCfg ctFoodCfg = ctFoodCfgDao.get(id);
			String foodId = ctFoodService.getFoodId(name);
			if (foodId == null) {
				throw new BusinessException("没有该菜品:" + name + ",请核对！");
			}
			ctFoodCfg.setKey(name);
			ctFoodCfg.setUpdateBy(UserUtils.getUser().getCreateBy());
			ctFoodCfg.setFoodId(foodId);
			ctFoodCfgDao.update(ctFoodCfg);
			result = new ProcessResult("000000", "操作成功");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 批量删除
	 * @Title: foodImgDeletes  
	 * @return ProcessResult 
	 * @throws
	 */
	@RequestMapping("foodImgDeletes")
	@ResponseBody
	public ProcessResult foodImgDeletes(HttpServletRequest request, HttpServletResponse response, String id) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String[] ids = id.split(",");
			CtFoodCfg ctFoodCfg = new CtFoodCfg();
			for (int i = 0; i < ids.length; i++) {
				ctFoodCfg.setId(ids[i]);
				ctFoodCfgDao.delete(ctFoodCfg);
			}
			result = new ProcessResult("000000", "操作成功");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

}

