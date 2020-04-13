/**
 *
 */
package com.jinchuan.pms.cyms.modules.test.web;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.service.JpushMessageService;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.entity.AppJpushConfig;
import com.jinchuan.pms.pub.modules.sys.entity.WxPrizeMember;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;


/**
 * 单表生成Controller
 * @author ThinkGem
 * @version 2015-04-06
 */
@Controller
@RequestMapping(value = "${adminPath}/test")
public class TestJPushController extends BaseController {

	@Autowired
	private JpushMessageService jpushMessageService;
	
	
	@ModelAttribute
	public AppJpushConfig get(@RequestParam(required=false) String id) {
		AppJpushConfig config = new AppJpushConfig();		
		return config;
	}
	
	@RequestMapping(value = {"form", ""})
	public String form(AppJpushConfig config, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "jpush/jpushConfigForm";
	}	

	@RequestMapping(value = {"jpush", ""})
	public ProcessResult jpush(AppJpushConfig config, HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("000000", "操作成功");
		try {
//			boolean sendResult = jpushMessageService.sendPushAll(config);
//			System.out.println(sendResult);
		}catch(Exception e) {
			e.printStackTrace();	
			result.setRetCode("999999");
			result.setRetMsg("推送失败，后台数据库故障!");
		}		
		return result;
	}
}