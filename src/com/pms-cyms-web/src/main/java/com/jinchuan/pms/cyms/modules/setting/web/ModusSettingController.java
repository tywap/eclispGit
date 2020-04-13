package com.jinchuan.pms.cyms.modules.setting.web;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.utils.StringUtils;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.entity.SysBusiConfig;
import com.jinchuan.pms.pub.modules.sys.enums.SysConfigTypeEnum;
import com.jinchuan.pms.pub.modules.sys.service.SysBusiConfigService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 做法设置
 *@author LiLingJie
 *@Description
 *@Date 2019年9月6日 下午4:21:17
 */
@Controller
@RequestMapping(value = "${adminPath}/setting/modusSetting")
public class ModusSettingController extends BaseController {

	@Autowired
	SysBusiConfigService busiConfig;

	@ModelAttribute
	public SysBusiConfig get(@RequestParam(required = false) String id) {
		SysBusiConfig entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = busiConfig.get(id);
		}
		if (entity == null) {
			entity = new SysBusiConfig();
		}
		return entity;
	}

	/**
	 * 做法设置列表
	 */
	@RequestMapping(value = "list")
	public String list(SysBusiConfig sysBusiConfig, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		List<SysBusiConfig> modusList = new ArrayList<SysBusiConfig>();
		List<SysBusiConfig> modusTypeList = new ArrayList<SysBusiConfig>();
		try {
			sysBusiConfig.setRentId(UserUtils.getUser().getRentId());
			sysBusiConfig.setType(SysConfigTypeEnum.cookValue.getType());
			modusTypeList = busiConfig.foodTypeList(sysBusiConfig);
			sysBusiConfig.setType(SysConfigTypeEnum.cookKey.getType());
			sysBusiConfig.setParentId("");
			modusList = busiConfig.findList(sysBusiConfig);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("modusList", modusList);
		model.addAttribute("modusTypeList", modusTypeList);
		return "modules/setting/foodset/modusSettingList";
	}

	/**
	 * 
	 */
	@RequestMapping(value = "typeForm")
	public String typeForm(SysBusiConfig sysBusiConfig, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		model.addAttribute("modusList", sysBusiConfig);
		return "modules/setting/foodset/modusTypeSettingForm";
	}

	/**
	 * 
	 */
	@RequestMapping(value = "form")
	public String form(SysBusiConfig sysBusiConfig, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		SysBusiConfig sysBusiConfig1 = new SysBusiConfig();
		sysBusiConfig1.setRentId(UserUtils.getUser().getRentId());
		sysBusiConfig1.setType(SysConfigTypeEnum.cookKey.getType());
		List<SysBusiConfig> modusTypeList = busiConfig.findList(sysBusiConfig1);
		model.addAttribute("modusList", sysBusiConfig);
		model.addAttribute("modusTypeList", modusTypeList);
		return "modules/setting/foodset/modusSettingForm";
	}

	@Transactional(readOnly = false)
	@RequestMapping(value = "save")
	@ResponseBody
	public ProcessResult save(SysBusiConfig sysBusiConfig, Model model, HttpServletRequest request,
			HttpServletResponse response, RedirectAttributes redirectAttributes) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			if (!beanValidator(model, sysBusiConfig)) {
				return result;
			}
			sysBusiConfig.setStatus("1");
			if ("0".equals(sysBusiConfig.getType())) {
				sysBusiConfig.setType(SysConfigTypeEnum.cookKey.getType());
				sysBusiConfig.setDescription(SysConfigTypeEnum.cookKey.getName());
			} else {
				sysBusiConfig.setType(SysConfigTypeEnum.cookValue.getType());
				sysBusiConfig.setDescription(SysConfigTypeEnum.cookValue.getName());
			}
			sysBusiConfig.setRentId(UserUtils.getUser().getRentId());
			if (sysBusiConfig.getId() != null && !sysBusiConfig.getId().equals("")) {

			} else {
				List<SysBusiConfig> sysBusiConfigList = busiConfig.findList(sysBusiConfig);
				for (SysBusiConfig sysBusiConfig2 : sysBusiConfigList) {
					if (sysBusiConfig.getName().equals(sysBusiConfig2.getName())) {
						result.setRetMsg("名称不能重复！");
						return result;
					}
					if (sysBusiConfig.getParamKey().equals(sysBusiConfig2.getParamKey())) {
						result.setRetMsg("编号不能重复！");
						return result;
					}
				}
			}
			busiConfig.save(sysBusiConfig);
			result = new ProcessResult("000000", "新增成功");
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg("编号重复！");
		}
		return result;
	}

	@Transactional(readOnly = false)
	@RequestMapping(value = "delete")
	@ResponseBody
	public ProcessResult delete(SysBusiConfig sysBusiConfig, RedirectAttributes redirectAttributes) {
		ProcessResult result = new ProcessResult("999999", "删除失败");
		String id = sysBusiConfig.getId();
		try {
			if (sysBusiConfig.getType().equals(SysConfigTypeEnum.cookKey.getType())) {
				SysBusiConfig sysBusiConfig1 = new SysBusiConfig();
				sysBusiConfig1.setRentId(UserUtils.getUser().getRentId());
				sysBusiConfig1.setParentId(id);
				sysBusiConfig1.setType(SysConfigTypeEnum.cookValue.getType());
				List<SysBusiConfig> modusTypeList = busiConfig.findList(sysBusiConfig1);
				for (SysBusiConfig sysBusiConfig2 : modusTypeList) {
					busiConfig.romve(sysBusiConfig2.getId());
				}
			}
			busiConfig.romve(id);
			result = new ProcessResult("000000", "新增成功");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

//	@RequestMapping(value = "getModus")
//	@ResponseBody
//	public ProcessResult getModus(HttpServletRequest request,HttpServletResponse response,SysBusiConfig sysBusiConfig) {
//		ProcessResult result = new ProcessResult("999999", "操作失败");
//		try {
//			sysBusiConfig.setType(SysConfigTypeEnum.cookValue.getType());
//			List<SysBusiConfig> modusList = busiConfig.findList(sysBusiConfig);
//			result = new ProcessResult("999999", "操作成功", modusList);
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//		return result;
//	}

}
