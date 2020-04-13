/**
 *
 */
package com.jinchuan.pms.cyms.modules.sys.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.JavaType;
import com.jinchuan.pms.cyms.modules.setting.entity.SourceSubivision;
import com.jinchuan.pms.cyms.modules.setting.service.SourceSubdivisionService;
import com.jinchuan.pms.pub.common.mapper.JsonMapper;
import com.jinchuan.pms.pub.common.persistence.Page;
import com.jinchuan.pms.pub.common.utils.StringUtils;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.entity.SysBusiConfig;
import com.jinchuan.pms.pub.modules.sys.enums.SysConfigTypeEnum;
import com.jinchuan.pms.pub.modules.sys.service.SysBusiConfigService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 客源细分Controller
 * @author HEYI
 * @version 2018-08-13
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/sourceSubdivision")
public class SourceSubdivisionController extends BaseController {

	@Autowired
	private SourceSubdivisionService sourceSubdivisionService;

	@Autowired
	private SysBusiConfigService sysBusiConfigService;

	@RequestMapping(value = { "list", "" })
	public String list(SysBusiConfig sys, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<SysBusiConfig> page = sourceSubdivisionService.findPage(new Page<SysBusiConfig>(request, response), sys);
		model.addAttribute("page", page);
		return "modules/roominfo/souceSubdivisionList";
	}

	@RequestMapping(value = "form")
	public String form(String sourceSubdivisionId, Model model) {
		String sourceSubivisionName = "";
		String sort = "";
		List<SourceSubivision> sourceSubivision = new ArrayList<SourceSubivision>();
		List<Map<String, String>> souceList = sysBusiConfigService.findSourceList(SysConfigTypeEnum.source.getType(),
				"default", UserUtils.getUser().getRentId());
		Map<String, Boolean> hasSouce = new HashMap<String, Boolean>();
		// 获取渠道
		if (StringUtils.isNotBlank(sourceSubdivisionId)) {
			SysBusiConfig source = sysBusiConfigService.get(sourceSubdivisionId);
			sourceSubivisionName = source.getName();
			sort = source.getSort();
			sourceSubivision = sourceSubdivisionService.getSourceBySourceSubdiviosionId(source.getParamKey());
			for (SourceSubivision sac : sourceSubivision) {
				hasSouce.put(sac.getSource(), true);
			}
		}

		model.addAttribute("sourceSubdivisionId", sourceSubdivisionId);
		model.addAttribute("sourceSubivisionName", sourceSubivisionName);
		model.addAttribute("sort", sort);
		model.addAttribute("souceList", souceList);
		model.addAttribute("hasSouce", hasSouce);

		return "modules/roominfo/souceSubdivisionForm";
	}

	@ResponseBody
	@RequestMapping(value = "saveSubdivision")
	public boolean saveSubdivision(@RequestParam("sourceSubdivisionName") String sourceSubdivisionName,
			@RequestParam("sourceSubdivisionId") String sourceSubdivisionId, @RequestParam("sort") String sort,
			HttpServletRequest request, HttpServletResponse response) {
		boolean result = true;
		try {
			JavaType javaType = JsonMapper.getInstance().createCollectionType(List.class, String.class);
			String sourceInfo = request.getParameter("sourceInfo");
			List<String> sources = (List<String>) JsonMapper.getInstance().fromJson(sourceInfo, javaType);
			sourceSubdivisionService.saveSourceSubdiviosion(sourceSubdivisionName, sourceSubdivisionId, sort, sources);
		} catch (Exception e) {
			e.printStackTrace();
			result = false;
		}
		return result;
	}

	@ResponseBody
	@RequestMapping(value = "deleteSource")
	public boolean deleteSource(@RequestParam("sourceSubdivisionId") String sourceSubdivisionId,
			HttpServletRequest request, HttpServletResponse response) {
		boolean result = true;
		try {
			SysBusiConfig sourceSys = sysBusiConfigService.get(sourceSubdivisionId);
			sourceSubdivisionService.deleteSource(sourceSubdivisionId);
			sysBusiConfigService.deleteByParamKey(sourceSys);
		} catch (Exception e) {
			e.printStackTrace();
			result = false;
		}
		return result;
	}

	@ResponseBody
	@RequestMapping(value = "validateName")
	public boolean validateName(String name, HttpServletRequest request, HttpServletResponse response) {
		boolean result = true;
		try {
			result = sourceSubdivisionService.validateName(name);
		} catch (Exception e) {
			e.printStackTrace();
			result = false;
		}
		return result;
	}

}