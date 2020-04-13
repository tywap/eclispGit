/**
 *
 */
package com.jinchuan.pms.cyms.modules.sys.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.jinchuan.pms.cyms.modules.setting.entity.CtTable;
import com.jinchuan.pms.cyms.modules.setting.entity.CtTableType;
import com.jinchuan.pms.cyms.modules.setting.service.CtTableService;
import com.jinchuan.pms.cyms.modules.setting.service.CtTableTypeService;
import com.jinchuan.pms.cyms.modules.setting.service.PayWayConfigService;
import com.jinchuan.pms.pub.common.config.Global;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.persistence.Page;
import com.jinchuan.pms.pub.common.utils.StringUtils;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.entity.SysBusiConfig;
import com.jinchuan.pms.pub.modules.sys.enums.SysConfigTypeEnum;
import com.jinchuan.pms.pub.modules.sys.service.SysBusiConfigService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 系统参数配置Controller
 * @author LYC
 * @version 2017-09-12
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/sysBusiConfig")
public class SysBusiConfigController extends BaseController {
	@Autowired
	private SysBusiConfigService sysBusiConfigService;
	@Autowired
	private PayWayConfigService payWayConfigService;

	/*
	 * @Autowired private CtTableTypeService ctTableTypeService;
	 * 
	 * @Autowired private CtTableService ctTableService;
	 */
	@ModelAttribute
	public SysBusiConfig get(@RequestParam(required = false) String id) {
		SysBusiConfig entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = sysBusiConfigService.get(id);
		}
		if (entity == null) {
			entity = new SysBusiConfig();
		}
		return entity;
	}

	@RequiresPermissions("sys:sysBusiConfig:view")
	@RequestMapping(value = { "list", "" })
	public String list(SysBusiConfig sysBusiConfig, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		sysBusiConfig.setRentId(UserUtils.getUser().getRentId());
		Page<SysBusiConfig> page = sysBusiConfigService.findPage(new Page<SysBusiConfig>(request, response),
				sysBusiConfig);
		model.addAttribute("page", page);
		return "modules/sys/sysbusi/sysBusiConfigList";
	}

	@RequiresPermissions("sys:sysBusiConfig:view")
	@RequestMapping(value = "form")
	public String form(SysBusiConfig sysBusiConfig, Model model) {
		model.addAttribute("sysBusiConfig", sysBusiConfig);
		model.addAttribute("parentId", sysBusiConfig.getParentId()); // 单独传parentId

		return "modules/sys/sysbusi/sysBusiConfigForm";
	}

	@RequiresPermissions("sys:sysBusiConfig:edit")
	@RequestMapping(value = "save")
	public String save(SysBusiConfig sysBusiConfig, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, sysBusiConfig)) {
			return form(sysBusiConfig, model);
		}
		if (StringUtils.isBlank(sysBusiConfig.getId())) {
			sysBusiConfig.preInsert();
			if (StringUtils.isBlank(sysBusiConfig.getParamKey())) {
				sysBusiConfig.setParamKey(sysBusiConfig.getId());
			}
		}
		sysBusiConfigService.save(sysBusiConfig);
		addMessage(redirectAttributes, "保存系统参数配置成功");
		return "redirect:" + Global.getAdminPath() + "/sys/sysBusiConfig/?repage";
	}

	@RequiresPermissions("sys:sysBusiConfig:edit")
	@RequestMapping(value = "delete")
	public String delete(SysBusiConfig sysBusiConfig, RedirectAttributes redirectAttributes) {
		sysBusiConfigService.delete(sysBusiConfig);
		addMessage(redirectAttributes, "删除系统参数配置成功");
		return "redirect:" + Global.getAdminPath() + "/sys/sysBusiConfig/?repage";
	}

	@RequiresPermissions("sys:sysBusiConfig:view")
	@RequestMapping(value = "getTypeAll")
	@ResponseBody
	public ProcessResult getTypeAll(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String type = request.getParameter("type");
			String storeId = request.getParameter("storeId");
			Map<String, String> paramMap = new HashMap<String, String>();
			paramMap.put("type", type);
			if (StringUtils.isEmpty(storeId)) {
				storeId = UserUtils.getStoreId();
			}
			paramMap.put("storeId", storeId);
			List<SysBusiConfig> sysBusiConfigs = sysBusiConfigService.getByType(paramMap);
			result.setRetCode("000000");
			Map<String, Object> ret = new HashMap<String, Object>();
			ret.put("lists", sysBusiConfigs);
			result.setRet(ret);
		} catch (Exception e) {
			e.printStackTrace();
			return result;
		}
		return result;
	}

	@RequiresPermissions("sys:sysBusiConfig:view")
	@RequestMapping("{type}/list")
	public String typeList(SysBusiConfig sysBusiConfig, HttpServletRequest request, HttpServletResponse response,
			Model model, @PathVariable("type") String type) {
		sysBusiConfig.setType(type);
		sysBusiConfig.setRentId(UserUtils.getUser().getRentId());
		Page<SysBusiConfig> page = sysBusiConfigService.findPage(new Page<SysBusiConfig>(request, response),
				sysBusiConfig);
		model.addAttribute("page", page);
		model.addAttribute("type", type);
		model.addAttribute("typeName", SysConfigTypeEnum.getEnumByType(type).getName());
		return "modules/sys/sysbusi/otherConfigList";
	}

	@RequiresPermissions("sys:sysBusiConfig:view")
	@RequestMapping(value = "{type}/form")
	public String typeForm(SysBusiConfig sysBusiConfig, Model model, @PathVariable("type") String type) {
		sysBusiConfig.setType(type);
		model.addAttribute("sysBusiConfig", sysBusiConfig);
		model.addAttribute("typeName", SysConfigTypeEnum.getEnumByType(type).getName());
		return "modules/sys/sysbusi/otherConfigForm";
	}

	@RequiresPermissions("sys:sysBusiConfig:edit")
	@RequestMapping(value = "{type}/delete")
	public String typeDelete(SysBusiConfig sysBusiConfig, RedirectAttributes redirectAttributes,
			@PathVariable("type") String type) {
		sysBusiConfig.setType(type);
		sysBusiConfigService.delete(sysBusiConfig);
		addMessage(redirectAttributes, "删除成功");
		return "redirect:" + Global.getAdminPath() + "/sys/sysBusiConfig/" + type + "/list?repage";
	}

	@RequiresPermissions("sys:sysBusiConfig:edit")
	@RequestMapping(value = "{type}/save")
	public String typeSave(SysBusiConfig sysBusiConfig, Model model, RedirectAttributes redirectAttributes,
			@PathVariable("type") String type) {
		sysBusiConfig.setType(type);
		if (!beanValidator(model, sysBusiConfig)) {
			return form(sysBusiConfig, model);
		}
		if (sysBusiConfig.getType().equals("goodsBrand")) {
			List<SysBusiConfig> dataList = sysBusiConfigService.getByName(sysBusiConfig.getName(), "default",
					"goodsBrand", UserUtils.getUser().getRentId());
			for (SysBusiConfig s : dataList) {
				if (sysBusiConfig.getName().equals(s.getName()) && !sysBusiConfig.getId().equals(s.getId())) {
					// addMessage(redirectAttributes, "协商品品牌名称不能重复！");
					// return form(sysBusiConfig, model);
					addMessage(redirectAttributes, "协商品品牌名称不能重复！");
					return "redirect:" + Global.getAdminPath() + "/sys/sysBusiConfig/" + type + "/list?repage";
				}
			}
		}
		if (StringUtils.isBlank(sysBusiConfig.getId())) {
			sysBusiConfig.preInsert();
			if (StringUtils.isBlank(sysBusiConfig.getParamKey())) {
				sysBusiConfig.setParamKey(sysBusiConfig.getId());
			}
			sysBusiConfig.setSort("0");
			sysBusiConfigService.insert(sysBusiConfig);
		} else {
			sysBusiConfigService.update(sysBusiConfig);
		}

		addMessage(redirectAttributes, "保存成功");
		return "redirect:" + Global.getAdminPath() + "/sys/sysBusiConfig/" + type + "/list?repage";
	}

	/**
	 * 支付方式配置
	 * @Title: typeList  
	 * @param sysBusiConfig
	 * @param request
	 * @param response
	 * @param model
	 * @param type
	 * @return 
	 * String 
	 * @throws
	 */
	@RequiresPermissions("sys:sysBusiConfig:view")
	@RequestMapping("payWayConfigList")
	public String payWayConfigList(SysBusiConfig sysBusiConfig, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		sysBusiConfig.setRentId(UserUtils.getUser().getRentId());
		sysBusiConfig.setType("payWay");
		List<SysBusiConfig> payWayConfigs = sysBusiConfigService.findList(sysBusiConfig);
		model.addAttribute("payWayConfigs", payWayConfigs);
		return "modules/sys/sysbusi/payWayConfigList";
	}

	@RequiresPermissions("sys:sysBusiConfig:view")
	@RequestMapping(value = "payWayConfigForm")
	public String payWayConfigForm(SysBusiConfig sysBusiConfig, Model model) {
		model.addAttribute("sysBusiConfig", sysBusiConfig);
		return "modules/sys/sysbusi/payWayConfigForm";
	}

	@RequiresPermissions("sys:sysBusiConfig:edit")
	@RequestMapping(value = "savePayWayConfig")
	@ResponseBody
	public ProcessResult savePayWayConfig(HttpServletRequest request, HttpServletResponse response,
			SysBusiConfig sysBusiConfig, Model model, RedirectAttributes redirectAttributes) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String editFlag = request.getParameter("editFlag");
			sysBusiConfig.setType("payWay");
			payWayConfigService.savePayWayConfig(sysBusiConfig, editFlag);
			result.setRetCode("000000");
			result.setRetMsg("保存支付配置成功");
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

	@RequiresPermissions("sys:sysBusiConfig:edit")
	@RequestMapping(value = "deletePayWayConfig")
	public String deletePayWayConfig(SysBusiConfig sysBusiConfig, RedirectAttributes redirectAttributes) {
		sysBusiConfigService.delete(sysBusiConfig);
		addMessage(redirectAttributes, "删除支付配置成功");
		return "redirect:" + Global.getAdminPath() + "/sys/sysBusiConfig/payWayConfigList";
	}

	@RequestMapping(value = "branchprinterList")
	public String branchprinterList(SysBusiConfig sysBusiConfig, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		model.addAttribute("selectStoreId", "pmscy");
		return "modules/sys/branchprinter/sysBusiConfigList";
	}

	@RequestMapping(value = "getCtTableList") // 选择餐厅查询打印机
	public String getOfficeList(HttpServletRequest request, HttpServletResponse response, String storeId1, Model model,
			CtTable ctTable1) {
		String rentId = UserUtils.getUser().getRentId();
		if ("".equals(storeId1) || null == storeId1) {
			storeId1 = ctTable1.getStoreId();
		}
		// List<SysBusiConfig>
		// foorlList=sysBusiConfigService.getByType(storeId1, "floor",rentId );
		// List<CtTableType>
		// ctTableTypeList=ctTableTypeService.getListByStoreId(storeId1);
		ctTable1.setStoreId(storeId1);
		ctTable1.setRentId(rentId);
		SysBusiConfig sysBusiConfig = new SysBusiConfig();
		sysBusiConfig.setRentId(rentId);
		sysBusiConfig.setType("printer");
		sysBusiConfig.setStoreId(storeId1);

		List<SysBusiConfig> sysbusilist = sysBusiConfigService.foodTypeList(sysBusiConfig);
		// List<CtTable> ctTableServiceList=
		// ctTableService.findAllListWithName(ctTable1);

		// model.addAttribute("foorlList", foorlList);
		// model.addAttribute("ctTableTypeList", ctTableTypeList);
		// model.addAttribute("ctTableServiceList", ctTableServiceList);
		model.addAttribute("sysbusilist", sysbusilist);
		model.addAttribute("selectStoreId", storeId1);
		return "modules/sys/branchprinter/sysBusiConfigList";
	}

	@RequestMapping(value = "sysbusiForm") // 跳转到新增打印机页面
	public String toEditCtTableForm(SysBusiConfig sysBusiConfig, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		String rentId = UserUtils.getUser().getRentId();
		String storeId = request.getParameter("storeId");
		if (sysBusiConfig.getId() != null) {
			SysBusiConfig sysbusi = sysBusiConfigService.get(sysBusiConfig.getId());
			model.addAttribute("sysbusi", sysbusi);
		}
		model.addAttribute("selectStoreId", storeId);
		return "modules/sys/branchprinter/sysBusiConfigForm";
	}

	@RequestMapping(value = "savesysbusi")
	@ResponseBody
	public ProcessResult savesysbusi(SysBusiConfig sysBusiConfig, HttpServletRequest request,
			HttpServletResponse response) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		String rentId = UserUtils.getUser().getRentId();
		sysBusiConfig.setRentId(rentId);
		// List<SysBusiConfig> list =
		// sysBusiConfigService.findprinterList(sysBusiConfig);
		if (StringUtils.isNotBlank(sysBusiConfig.getId())) {
			SysBusiConfig sys = sysBusiConfigService.get(sysBusiConfig.getId());
			sys.setName(sysBusiConfig.getName());
			sys.setParamKey(sysBusiConfig.getParamKey());
			sys.setParamValue(sysBusiConfig.getParamValue());
			sys.setRemarks(sysBusiConfig.getRemarks());
			sysBusiConfigService.update(sys);
			result.setRetCode("000000");
			result.setRetMsg("修改成功");
		} else {
			List<SysBusiConfig> list = sysBusiConfigService.getByName(sysBusiConfig.getName(),
					sysBusiConfig.getStoreId(), "printer", rentId);
			if (list.size() > 0) {
				result.setRetMsg("已存在改打印机，请重新输入！");
			} else {
				sysBusiConfig.preInsert();
				/*if (StringUtils.isBlank(sysBusiConfig.getParamKey())) {
					sysBusiConfig.setParamKey(sysBusiConfig.getId());
				}*/
				sysBusiConfig.setType("printer");
				sysBusiConfig.setSort("0");
				sysBusiConfigService.insert(sysBusiConfig);
				result.setRetCode("000000");
				result.setRetMsg("保存成功");
			}
		}
		return result;
	}
	@RequestMapping(value = "printerdelete")
	@ResponseBody
	public ProcessResult printerdelete(SysBusiConfig sysBusiConfig, HttpServletRequest request,
			HttpServletResponse response) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			sysBusiConfigService.delete(sysBusiConfig);
			result.setRetCode("000000");
			result.setRetMsg("删除成功");
		} catch (Exception e) {
			// TODO: handle exception
		}
		
		return result;
	}
}