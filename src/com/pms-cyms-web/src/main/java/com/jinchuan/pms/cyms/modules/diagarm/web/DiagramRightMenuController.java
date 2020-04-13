
package com.jinchuan.pms.cyms.modules.diagarm.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.service.SysBusiConfigService;

/**
 * 房态图Controller
 * 
 * @author LYC
 * @version 2017-09-15
 */
@Controller
@RequestMapping(value = "${adminPath}/diagramRightMenu")
public class DiagramRightMenuController extends BaseController {

	@Autowired
	SysBusiConfigService sysBusiConfigService;

}