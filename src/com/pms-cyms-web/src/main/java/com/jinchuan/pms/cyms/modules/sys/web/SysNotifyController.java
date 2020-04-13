/**
 *
 */
package com.jinchuan.pms.cyms.modules.sys.web;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.text.DateFormatter;

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
import com.jinchuan.pms.pub.modules.sys.entity.SysNotify;
import com.jinchuan.pms.pub.modules.sys.service.SysNotifyService;
import com.jinchuan.pms.pub.modules.sys.service.SystemService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 系统提醒Controller
 * @author tanzao
 * @version 2017-10-26
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/sysNotify")
public class SysNotifyController extends BaseController {

	@Autowired
	private SysNotifyService sysNotifyService;
	@Autowired
	private SystemService systemService;

	@ModelAttribute
	public SysNotify get(@RequestParam(required = false) String id) {
		SysNotify entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = sysNotifyService.get(id);
		}
		if (entity == null) {
			entity = new SysNotify();
			entity.setCreateBy(UserUtils.getUser());
		}
		return entity;
	}

	@RequiresPermissions("sys:sysNotify:view")
	@RequestMapping(value = { "list", "" })
	public String list(SysNotify sysNotify, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<SysNotify> page = sysNotifyService.findPage(new Page<SysNotify>(request, response), sysNotify);
		model.addAttribute("page", page);
		return "modules/sys/sysNotifyList";
	}

	@RequiresPermissions("sys:sysNotify:view")
	@RequestMapping(value = "queryCurUserNotify")
	@ResponseBody
	public ProcessResult queryCurUserNotify(SysNotify sysNotify, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		String userId = UserUtils.getUser().getId();
		String ctx = request.getContextPath() + Global.getAdminPath();
		Map<String, Object> map = sysNotifyService.queryCurUserNotify(userId);
		map.put("ctx", ctx);
		result.setRetCode("000000");
		result.setRetMsg("操作成功");
		result.setRet(map);
		return result;
	}

	@RequiresPermissions("sys:sysNotify:view")
	@RequestMapping(value = "form")
	public String form(SysNotify sysNotify, Model model) {
		model.addAttribute("allRoles", systemService.findAllRole());
		model.addAttribute("sysNotify", sysNotify);
		return "modules/sys/sysNotifyForm";
	}

	@RequiresPermissions("sys:sysNotify:edit")
	@RequestMapping(value = "save")
	@ResponseBody
	public ProcessResult save(SysNotify sysNotify, HttpServletRequest request, HttpServletResponse response,
			Model model, RedirectAttributes redirectAttributes) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			sysNotify.setStoreId(UserUtils.getStoreId());
			sysNotifyService.saveSysNotify(sysNotify);
			result = ProcessResult.SUCCESS;
		} catch (Exception e) {
			e.printStackTrace();
			return result;
		}
		return result;
	}

	@RequiresPermissions("sys:sysNotify:edit")
	@RequestMapping(value = "read")
	@ResponseBody
	public ProcessResult read(SysNotify sysNotify, HttpServletRequest request, HttpServletResponse response,
			Model model, RedirectAttributes redirectAttributes) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		if (!beanValidator(model, sysNotify)) {
			result.setRetMsg((String) model.asMap().get("message"));
			return result;
		}
		sysNotifyService.read(sysNotify);
		result = ProcessResult.SUCCESS;
		return result;
	}

	@RequiresPermissions("sys:sysNotify:edit")
	@RequestMapping(value = "delete")
	public String delete(SysNotify sysNotify, RedirectAttributes redirectAttributes) {
		sysNotifyService.delete(sysNotify);
		addMessage(redirectAttributes, "删除系统提醒成功");
		return "redirect:" + Global.getAdminPath() + "/sys/sysNotify/?repage";
	}

}