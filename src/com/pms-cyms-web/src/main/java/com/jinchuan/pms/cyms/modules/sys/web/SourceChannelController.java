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

import com.jinchuan.pms.cyms.modules.setting.entity.SourceAndChannel;
import com.jinchuan.pms.cyms.modules.setting.enums.ChannelEnum;
import com.jinchuan.pms.cyms.modules.setting.service.SourceChannelService;
import com.jinchuan.pms.pub.common.mapper.JsonMapper;
import com.jinchuan.pms.pub.common.persistence.Page;
import com.jinchuan.pms.pub.common.utils.StringUtils;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.entity.SysBusiConfig;
import com.jinchuan.pms.pub.modules.sys.service.SysBusiConfigService;

/**
 * 渠道客源Controller
 * @author LYC
 * @version 2017-09-29
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/sourceChannel")
public class SourceChannelController extends BaseController {
	@Autowired
	private SourceChannelService sourceChannelService;
	@Autowired
	private SysBusiConfigService sysBusiConfigService;

	@RequestMapping(value = { "list", "" })
	public String list(SysBusiConfig sys, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<SysBusiConfig> page = sourceChannelService.findPage(new Page<SysBusiConfig>(request, response), sys);
		model.addAttribute("page", page);
		// 获取渠道
		List<Map<String, Object>> channels = ChannelEnum.getChannelList();
		model.addAttribute("channels", channels);

		return "modules/sys/sourceChannel/soucechanelList";
	}

	@RequestMapping(value = "form")
	public String form(String sourceId, Model model) {
		String sourceName = "";
		String sort = "";
		List<SourceAndChannel> sourceAndChannel = new ArrayList<SourceAndChannel>();
		List<Map<String, Object>> channelList = ChannelEnum.getChannelList();
		Map<String, Boolean> checkOprate = new HashMap<String, Boolean>();
		Map<String, Boolean> bookOprate = new HashMap<String, Boolean>();
		Map<String, Boolean> centerOprate = new HashMap<String, Boolean>();
		Map<String, Boolean> hasChannel = new HashMap<String, Boolean>();
		// 获取渠道
		if (StringUtils.isNotBlank(sourceId)) {
			SysBusiConfig source = sysBusiConfigService.get(sourceId);
			if (StringUtils.isNotEmpty(source.getExtend())) {
				List<String> storeList = new ArrayList<>();
				for (String storeId : source.getExtend().split(","))
					storeList.add("{\"storeId\":\"" + storeId + "\"}");
				model.addAttribute("storeList", storeList);
			}

			sourceName = source.getName();
			sort = source.getSort();
			sourceAndChannel = sourceChannelService.getChannelBySourceId(source.getParamKey());
			for (SourceAndChannel sac : sourceAndChannel) {
				checkOprate.put(sac.getChannel(), sac.getCheckVisiable() != null ? true : false);
				bookOprate.put(sac.getChannel(), sac.getBookVisiable() != null ? true : false);
				centerOprate.put(sac.getChannel(), sac.getCenterVisiable() != null ? true : false);
				hasChannel.put(sac.getChannel(), true);
			}
			if (sourceAndChannel.size() > 0)
				model.addAttribute("editable", sourceAndChannel.get(0).getRemarks());
		}

		model.addAttribute("sourceId", sourceId);
		model.addAttribute("sourceName", sourceName);
		model.addAttribute("sort", sort);
		model.addAttribute("channelList", channelList);
		model.addAttribute("checkOprate", checkOprate);
		model.addAttribute("bookOprate", bookOprate);
		model.addAttribute("centerOprate", centerOprate);
		model.addAttribute("hasChannel", hasChannel);
		return "modules/sys/sourceChannel/soucechanelForm";
	}

	@ResponseBody
	@RequestMapping(value = "saveSource")
	public boolean saveSource(@RequestParam("sourceName") String sourceName, @RequestParam("sourceId") String sourceId,
			@RequestParam("sort") String sort, @RequestParam("channelInfo") String channelInfo,
			@RequestParam("storeId") String storeId, HttpServletRequest request, HttpServletResponse response) {
		boolean result = true;
		try {
			Map channelInfoMap = (Map) JsonMapper.fromJsonString(channelInfo.replace("&quot;", "\""), HashMap.class);
			String sysBusiId = sourceChannelService.saveSourceAndChannel(sourceName, sourceId, sort, channelInfoMap,
					storeId);
		} catch (Exception e) {
			e.printStackTrace();
			result = false;
		}
		return result;
	}

	@ResponseBody
	@RequestMapping(value = "deleteSource")
	public boolean deleteSource(@RequestParam("sourceId") String sourceId, HttpServletRequest request,
			HttpServletResponse response) {
		boolean result = true;
		try {
			sourceChannelService.deleteSource(sourceId);
			SysBusiConfig sourceSys = sysBusiConfigService.get(sourceId);
		} catch (Exception e) {
			e.printStackTrace();
			result = false;
		}
		return result;
	}

	@ResponseBody
	@RequestMapping(value = "validateSourceDelete")
	public String validateSourceDelete(@RequestParam("sourceId") String sourceId, HttpServletRequest request,
			HttpServletResponse response) {
		try {
			return sourceChannelService.validateSourceDelete(sourceId);
		} catch (Exception e) {
			e.printStackTrace();
			return "系统错误！";
		}
	}

	@ResponseBody
	@RequestMapping(value = "validateName")
	public boolean validateName(String name, HttpServletRequest request, HttpServletResponse response) {
		boolean result = true;
		try {
			result = sourceChannelService.validateName(name);
		} catch (Exception e) {
			e.printStackTrace();
			result = false;
		}
		return result;
	}

	/**
	 * 
	 * @Title: getChannelBySource  
	 * @Description: 查询渠道
	 * @param sourceId
	 * @param channelId
	 * @param request
	 * @param response
	 * @param model
	 * @return List<Map<String,String>> 
	 * @throws
	 */
	@RequestMapping(value = "getChannelBySource")
	@ResponseBody
	public List<Map<String, String>> getChannelBySource(String sourceId, String channelId, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		List<SourceAndChannel> scList = sourceChannelService.getChannelBySourceId(sourceId);
		List<Map<String, String>> reList = new ArrayList<Map<String, String>>();
		for (SourceAndChannel s : scList) {
			if (StringUtils.isNotBlank(s.getCheckVisiable())
					|| (s.getChannel().equals(channelId) && s.getSource().equals(sourceId))) {
				Map<String, String> reMap = new HashMap<String, String>();
				reMap.put("id", s.getChannel());
				reMap.put("name", ChannelEnum.getNameByChannelId(s.getChannel()));
				reList.add(reMap);
			}
		}
		return reList;
	}
}