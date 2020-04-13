/**
 *
 */
package com.jinchuan.pms.cyms.modules.sys.web;

import java.util.HashMap;
import java.util.Map;

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

import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.config.Global;
import com.jinchuan.pms.pub.common.persistence.Page;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.common.utils.SequenceUtils;
import com.jinchuan.pms.pub.common.utils.StringUtils;
import com.jinchuan.pms.pub.modules.sys.entity.Sequence;
import com.jinchuan.pms.pub.modules.sys.entity.SysMessageTemplate;
import com.jinchuan.pms.pub.modules.sys.service.SysMessageSendService;
import com.jinchuan.pms.pub.modules.sys.service.SysMessageTemplateService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 短信模板Controller
 * @author tanzao
 * @version 2017-10-17
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/sysMessageTemplate")
public class SysMessageTemplateController extends BaseController {
	@Autowired
	private SysMessageSendService sysMessageSendService;
	@Autowired
	private SysMessageTemplateService sysMessageTemplateService;

	@ModelAttribute
	public SysMessageTemplate get(@RequestParam(required = false) String id) {
		SysMessageTemplate entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = sysMessageTemplateService.get(id);
		}
		if (entity == null) {
			entity = new SysMessageTemplate();
		}
		return entity;
	}

	@RequiresPermissions("sys:sysMessageTemplate:view")
	@RequestMapping(value = { "list", "" })
	public String list(SysMessageTemplate sysMessageTemplate, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		sysMessageTemplate.setRentId(UserUtils.getUser().getRentId());
		Page<SysMessageTemplate> page = sysMessageTemplateService
				.findPage(new Page<SysMessageTemplate>(request, response), sysMessageTemplate);
		model.addAttribute("page", page);
		return "modules/sys/sysMessageTemplateList";
	}

	@RequiresPermissions("sys:sysMessageTemplate:view")
	@RequestMapping(value = "form")
	public String form(SysMessageTemplate sysMessageTemplate, Model model) {
		model.addAttribute("sysMessageTemplate", sysMessageTemplate);
		return "modules/sys/sysMessageTemplateForm";
	}

	@RequiresPermissions("sys:sysMessageTemplate:edit")
	@RequestMapping(value = "save")
	@ResponseBody
	public ProcessResult save(SysMessageTemplate sysMessageTemplate, Model model,
			RedirectAttributes redirectAttributes) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		if (!beanValidator(model, sysMessageTemplate)) {
			result.setRetMsg((String) model.asMap().get("message"));
			return result;
		}
		sysMessageTemplateService.save(sysMessageTemplate);
		result = ProcessResult.SUCCESS;
		return result;
	}

	@RequiresPermissions("sys:sysMessageTemplate:edit")
	@RequestMapping(value = "delete")
	public String delete(SysMessageTemplate sysMessageTemplate, RedirectAttributes redirectAttributes) {
		sysMessageTemplateService.delete(sysMessageTemplate);
		addMessage(redirectAttributes, "删除短信模板成功");
		return "redirect:" + Global.getAdminPath() + "/sys/sysMessageTemplate/?repage";
	}

	@RequiresPermissions("sys:sysMessageTemplate:edit")
	@RequestMapping(value = "sendForm")
	public String sendForm(SysMessageTemplate sysMessageTemplate, Model model) {
		model.addAttribute("sysMessageTemplate", sysMessageTemplate);
		return "modules/sys/sysMessageSendForm";
	}

	/**
	 * 自定义发送短信
	 * @Title: preview  
	 * @param @param sysMessageTemplate
	 * @param @param request
	 * @param @param response
	 * @param @param redirectAttributes
	 * @param @return 
	 * @return ProcessResult 
	 * @throws
	 */
	@RequiresPermissions("sys:sysMessageTemplate:edit")
	@RequestMapping(value = "send")
	@ResponseBody
	public ProcessResult send(SysMessageTemplate sysMessageTemplate, HttpServletRequest request,
			HttpServletResponse response, RedirectAttributes redirectAttributes) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String cardTypeIds = request.getParameter("cardTypeIds");
			String agreementGroups = request.getParameter("agreementGroups");
			String phones = request.getParameter("phones");
			String content = request.getParameter("content");
			Map<String, Object> ret = sysMessageTemplateService.sendMessage(cardTypeIds, agreementGroups, phones,
					content);
			result.setRet(ret);
			result.setRetCode("000000");
			result.setRetMsg("操作成功");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 模板发送
	 * @Title: preview  
	 * @param @param sysMessageTemplate
	 * @param @param request
	 * @param @param response
	 * @param @param redirectAttributes
	 * @param @return 
	 * @return ProcessResult 
	 * @throws
	 */
	@RequiresPermissions("sys:sysMessageTemplate:view")
	@RequestMapping(value = "preview")
	@ResponseBody
	public ProcessResult preview(SysMessageTemplate sysMessageTemplate, HttpServletRequest request,
			HttpServletResponse response, RedirectAttributes redirectAttributes) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String phone = request.getParameter("phone");
			String messageBusinessCode = "0";
			String messageType = sysMessageTemplate.getType();
			Map<String, Object> model = new HashMap<String, Object>();
			// Map<String, Object> ret = MessageUtils.sendMessage(phone,
			// messageBusinessCode, messageType, model);
			result.setRetCode("000000");
			// result.setRetMsg(ret.get("message").toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

}