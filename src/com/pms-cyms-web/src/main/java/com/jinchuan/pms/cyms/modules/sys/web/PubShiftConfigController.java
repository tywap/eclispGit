/**
 *
 */
package com.jinchuan.pms.cyms.modules.sys.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.jinchuan.pms.pub.common.config.Global;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.persistence.Page;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.common.utils.StringUtils;
import com.jinchuan.pms.pub.modules.sys.entity.PubShiftConfig;
import com.jinchuan.pms.pub.modules.sys.service.PubShiftConfigService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 班次配置Controller
 * @author LB
 * @version 2017-11-08
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/pubShiftConfig")
public class PubShiftConfigController extends BaseController {
	@Autowired
	private PubShiftConfigService pubShiftConfigService;

	@ModelAttribute
	public PubShiftConfig get(@RequestParam(required = false) String id) {
		PubShiftConfig entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = pubShiftConfigService.get(id);
		}
		if (entity == null) {
			entity = new PubShiftConfig();
		}
		return entity;
	}

	@RequiresPermissions("sys:pubShiftConfig:view")
	@RequestMapping(value = { "list", "" })
	public String list(PubShiftConfig pubShiftConfig, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		pubShiftConfig.setRentId(UserUtils.getUser().getRentId());
		Page<PubShiftConfig> page = pubShiftConfigService.findPage(new Page<PubShiftConfig>(request, response),
				pubShiftConfig);
		model.addAttribute("page", page);
		return "modules/sys/pubShiftConfigList";
	}

	// 编辑班次信息
	@RequiresPermissions("sys:pubShiftConfig:edit")
	@RequestMapping(value = "updatePubShiftConfig")
	public String updatePubShiftConfig(PubShiftConfig pubShiftConfig, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		PubShiftConfig pubShift = pubShiftConfigService.get(pubShiftConfig.getId());
		model.addAttribute(pubShift);
		return "modules/sys/pubShiftConfigForm";
	}

	@RequiresPermissions("sys:pubShiftConfig:view")
	@RequestMapping(value = "form")
	public String form(PubShiftConfig pubShiftConfig, Model model) {
		// model.addAttribute("pubShiftConfig", pubShiftConfig);
		return "modules/sys/pubShiftConfigForm";
	}

	@RequiresPermissions("sys:pubShiftConfig:edit")
	@RequestMapping(value = "save")
	@ResponseBody
	public ProcessResult save(PubShiftConfig pubShiftConfig, Model model, RedirectAttributes redirectAttributes,
			HttpServletRequest request, HttpServletResponse response) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		pubShiftConfig.setRentId(UserUtils.getUser().getRentId());
		Page<PubShiftConfig> page = pubShiftConfigService.findPage(new Page<PubShiftConfig>(request, response),
				pubShiftConfig);
		List<PubShiftConfig> pubShiftConfigList = page.getList();
		for (PubShiftConfig pubShiftConfig2 : pubShiftConfigList) {
			if (pubShiftConfig.getShiftName().equals(pubShiftConfig2.getShiftName())
					&& !pubShiftConfig.getId().equals(pubShiftConfig2.getId())) {
				result.setRetMsg("班次名称不能重复！");
				return result;
			}
		}
		pubShiftConfigService.save(pubShiftConfig);
		result.setRetCode("000000");
		addMessage(redirectAttributes, "保存班次配置成功");
		return result;
	}

	@RequiresPermissions("sys:pubShiftConfig:edit")
	@RequestMapping(value = "delete")
	public String delete(PubShiftConfig pubShiftConfig, RedirectAttributes redirectAttributes) {
		pubShiftConfigService.delete(pubShiftConfig);
		addMessage(redirectAttributes, "修改班次配置成功");
		return "redirect:" + Global.getAdminPath() + "/sys/pubShiftConfig/?repage";
	}
}