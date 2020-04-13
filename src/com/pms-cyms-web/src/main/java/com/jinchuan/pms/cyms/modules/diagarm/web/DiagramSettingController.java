/**
 *
 */
package com.jinchuan.pms.cyms.modules.diagarm.web;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.jinchuan.pms.cyms.modules.diagarm.service.DiagramSettingService;
import com.jinchuan.pms.pub.common.config.Global;
import com.jinchuan.pms.pub.common.mapper.JsonMapper;
import com.jinchuan.pms.pub.common.utils.HttpURLConnectionUtils;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.dao.UserDao;

/**
 * 系统设置Controller
 * @author LYC
 * @version 2017-09-29
 */
@Controller
@RequestMapping(value = "${adminPath}/diagram/setting")
public class DiagramSettingController extends BaseController {
	private Logger log = LoggerFactory.getLogger(DiagramSettingController.class);
	@Autowired
	DiagramSettingService diagramSettingService;
	@Autowired
	UserDao userDao;

	/**
	 * @Title: list  
	 * @param @param request
	 * @param @param response
	 * @param @param model
	 * @param @return 
	 * @return String 
	 * @throws
	 */
	@RequestMapping(value = "")
	public String list(HttpServletRequest request, HttpServletResponse response, Model model) {
		Map<String, String> settingMap = diagramSettingService.getSettingMap("diagramSetting");
		model.addAttribute("settingMap", settingMap);
		return "modules/sys/diagramSettings";
	}

	@RequestMapping(value = "nightSetting")
	public String nightSettings(HttpServletRequest request, HttpServletResponse response, Model model) {
		Map<String, String> settingMap = diagramSettingService.getSettingMap("nightSetting");
		model.addAttribute("settingMap", settingMap);
		return "modules/sys/nightSetting";
	}

	@RequestMapping(value = "guestAccounts")
	public String guestAccounts(HttpServletRequest request, HttpServletResponse response, Model model) {
		Map<String, String> settingMap = diagramSettingService.getSettingMap("guestAccounts");
		model.addAttribute("settingMap", settingMap);
		return "modules/sys/guestAccounts";
	}

	@ResponseBody
	@RequestMapping(value = "saveDiagramSettings")
	public boolean saveDiagramSettings(@RequestParam("settingInfo") String settingInfo, String type,
			HttpServletRequest request, HttpServletResponse response) {
		Map settingInfoMap = (Map) JsonMapper.fromJsonString(settingInfo.replace("&quot;", "\""), HashMap.class);
		boolean result = true;
		try {
			diagramSettingService.saveDiagramSettings(settingInfoMap, type);
		} catch (Exception e) {
			e.printStackTrace();
			result = false;
		}
		return result;
	}

	@ResponseBody
	@RequestMapping(value = "httpTest")
	public void test(HttpServletRequest request, HttpServletResponse response) {
		try {
			Map<String, Object> result = HttpURLConnectionUtils
					.sendHttpRequest(Global.getConfig("pubAccountInterface.url"), "storeId=1&newTime=2018-01-01");
			if (result != null) {
				String retStr = (String) result.get("retStr");
				if (!retStr.equals("true"))
					throw new RuntimeException();

			}
		} catch (Exception e) {
			throw new RuntimeException("更新缓存错误，门店号为:1");
		}
	}

}