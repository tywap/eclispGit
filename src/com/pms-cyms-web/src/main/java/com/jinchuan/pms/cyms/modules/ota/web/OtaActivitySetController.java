package com.jinchuan.pms.cyms.modules.ota.web;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.jinchuan.pms.cyms.modules.ota.entity.OtaFoodMkt;
import com.jinchuan.pms.cyms.modules.setting.entity.CtFoodCfg;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.entity.SysBusiConfig;
import com.jinchuan.pms.pub.modules.sys.enums.SysConfigTypeEnum;
import com.jinchuan.pms.pub.modules.sys.service.SysBusiConfigService;

/**
 * 活动设置
 *@author ty
 *@Description
 *@Date 2020年1月20日 下午4:38:32
 */
@Controller
@RequestMapping("${adminPath}/ota/activitySet")
public class OtaActivitySetController extends BaseController {

	@Autowired
	public SysBusiConfigService sysBusiConfigService;

	/**
	 * 活动列表
	 * @Title: list  
	 * @throws
	 */
	@RequestMapping("list")
	public String list(HttpServletRequest request, HttpServletResponse response, String storeId1, Model model,
			String name) {
		List<CtFoodCfg> ctFoodCfgList = new ArrayList<CtFoodCfg>();
		List<SysBusiConfig> activityTypeList = new ArrayList<SysBusiConfig>();
		try {
			activityTypeList = sysBusiConfigService.getByType(SysConfigTypeEnum.activity.getType());
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("activityTypeList", activityTypeList);
		model.addAttribute("ctFoodCfgList", ctFoodCfgList);
		return "modules/ota/scanCodeOrdering/activitySetList";
	}

	/**
	 * 新增活动
	 * @Title: form  
	 * @throws
	 */
	@RequestMapping("form")
	public String form(HttpServletRequest request, HttpServletResponse response, String storeId1, Model model,
			String name) {
		List<SysBusiConfig> activityTypeList = new ArrayList<SysBusiConfig>();
		try {
			activityTypeList = sysBusiConfigService.getByType(SysConfigTypeEnum.activity.getType());
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("activityTypeList", activityTypeList);
		return "modules/ota/scanCodeOrdering/activityForm";
	}

	/**
	 * 保存活动
	 * @Title: saveActivity  
	 * @throws
	 */
	@RequestMapping(value = "saveActivity")
	@ResponseBody
	public ProcessResult saveActivity(Model model, HttpServletRequest request, HttpServletResponse response,
			OtaFoodMkt otaFoodMkt) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			result = new ProcessResult("000000", "操作成功");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;

	}
}
