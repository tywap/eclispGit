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
import com.jinchuan.pms.pub.modules.sys.service.SequenceService;

/**
 * 序列配置Controller
 * @author tanzao
 * @version 2017-09-13
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/sequence")
public class SequenceController extends BaseController {

	@Autowired
	private SequenceService sequenceService;

	@ModelAttribute
	public Sequence get(@RequestParam(required = false) String id) {
		Sequence entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = sequenceService.get(id);
		}
		if (entity == null) {
			entity = new Sequence();
		}
		return entity;
	}

	@RequiresPermissions("sys:sequence:view")
	@RequestMapping(value = { "list", "" })
	public String list(Sequence sequence, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<Sequence> page = sequenceService.findPage(new Page<Sequence>(request, response), sequence);
		model.addAttribute("page", page);
		return "modules/sys/sequenceList";
	}

	@RequiresPermissions("sys:sequence:view")
	@RequestMapping(value = "form")
	public String form(Sequence sequence, Model model) {
		model.addAttribute("sequence", sequence);
		return "modules/sys/sequenceForm";
	}

	@RequiresPermissions("sys:sequence:edit")
	@RequestMapping(value = "save")
	public String save(Sequence sequence, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, sequence)) {
			return form(sequence, model);
		}
		sequenceService.save(sequence);
		addMessage(redirectAttributes, "保存序列成功");
		return "redirect:" + Global.getAdminPath() + "/sys/sequence/?repage";
	}

	@RequiresPermissions("sys:sequence:edit")
	@RequestMapping(value = "delete")
	public String delete(Sequence sequence, RedirectAttributes redirectAttributes) {
		sequenceService.delete(sequence);
		addMessage(redirectAttributes, "删除序列成功");
		return "redirect:" + Global.getAdminPath() + "/sys/sequence/?repage";
	}

	@RequiresPermissions("sys:sequence:view")
	@RequestMapping(value = "preview")
	@ResponseBody
	public ProcessResult preview(Sequence sequence, RedirectAttributes redirectAttributes) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String prefixType = sequence.getPrefixType();
			String tableName = sequence.getTableName();
			String prefix = sequence.getPrefix();
			String seq = "";
			if (("1").equals(prefixType)) {
				seq = SequenceUtils.getSeq(tableName);
			} else if (("2").equals(prefixType)) {
				Map<String, Object> map = new HashMap<String, Object>();
				int start = prefix.indexOf("{");
				int end = prefix.indexOf("}");
				if (start == -1 || end == -1) {
					result.setRetCode("000000");
					result.setRetMsg("动态前缀格式有误");
					return result;
				}
				prefix = prefix.substring(start + 1, end);
				map.put(prefix, "***");
				seq = SequenceUtils.getSeq(tableName, map);
			}
			result.setRetCode("000000");
			result.setRetMsg("操作成功");
			Map<String, Object> retMap = new HashMap<String, Object>();
			retMap.put("seq", seq);
			result.setRet(retMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

}