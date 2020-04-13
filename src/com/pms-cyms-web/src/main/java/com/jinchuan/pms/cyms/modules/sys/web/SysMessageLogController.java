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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.jinchuan.pms.pub.common.config.Global;
import com.jinchuan.pms.pub.common.persistence.Page;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.common.utils.DateUtils;
import com.jinchuan.pms.pub.common.utils.StringUtils;
import com.jinchuan.pms.pub.modules.sys.entity.SysMessageLog;
import com.jinchuan.pms.pub.modules.sys.service.SysMessageLogService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 短信记录Controller
 * @author tanzao
 * @version 2017-10-16
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/sysMessageLog")
public class SysMessageLogController extends BaseController {

	@Autowired
	private SysMessageLogService sysMessageLogService;

	@ModelAttribute
	public SysMessageLog get(@RequestParam(required = false) String id) {
		SysMessageLog entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = sysMessageLogService.get(id);
		}
		if (entity == null) {
			entity = new SysMessageLog();
		}
		return entity;
	}

	@RequiresPermissions("sys:sysMessageLog:view")
	@RequestMapping(value = { "list", "" })
	public String list(SysMessageLog sysMessageLog, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		Integer pageIndex = sysMessageLog.getPageIndex();
		Integer startPage = sysMessageLog.getStartPage();
		Integer endPage = sysMessageLog.getEndPage();
		String startDate=request.getParameter("startDate");
		String endDate=request.getParameter("endDate");
		if (startPage == null) {
			startPage = 0;
		}
		if (endPage == null) {
			endPage = Integer.valueOf(Global.getConfig("page.pageSize"));
		}
		if (pageIndex == null) {
			pageIndex = 1;
		}
		sysMessageLog.setStartPage(startPage);
		sysMessageLog.setEndPage(endPage);
		sysMessageLog.setRentId(UserUtils.getUser().getRentId());
		List<SysMessageLog> sysMessageLogs = sysMessageLogService.findList(sysMessageLog);
		if(startDate==null){
			startDate= DateUtils.getDateBeFore();
		}
		if(endDate==null){
			endDate= DateUtils.getDateBeFore();
		}
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		model.addAttribute("pageIndex", pageIndex);
		model.addAttribute("sysMessageLogs", sysMessageLogs);
		return "modules/sys/sysMessageLogList";
	}

	@RequiresPermissions("sys:sysMessageLog:view")
	@RequestMapping(value = "form")
	public String form(SysMessageLog sysMessageLog, Model model) {
		model.addAttribute("sysMessageLog", sysMessageLog);
		return "modules/sys/sysMessageLogForm";
	}

	@RequiresPermissions("sys:sysMessageLog:edit")
	@RequestMapping(value = "save")
	public String save(SysMessageLog sysMessageLog, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, sysMessageLog)) {
			return form(sysMessageLog, model);
		}
		sysMessageLogService.save(sysMessageLog);
		addMessage(redirectAttributes, "保存短信记录成功");
		return "redirect:" + Global.getAdminPath() + "/sys/?repage";
	}

	@RequiresPermissions("sys:sysMessageLog:edit")
	@RequestMapping(value = "delete")
	public String delete(SysMessageLog sysMessageLog, RedirectAttributes redirectAttributes) {
		sysMessageLogService.delete(sysMessageLog);
		addMessage(redirectAttributes, "删除短信记录成功");
		return "redirect:" + Global.getAdminPath() + "/sys/?repage";
	}

}