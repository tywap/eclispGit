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

import com.jinchuan.pms.pub.modules.sys.entity.Office;
import com.jinchuan.pms.pub.modules.sys.entity.User;
import com.jinchuan.pms.pub.modules.sys.service.SystemService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.mapper.JsonMapper;
import com.jinchuan.pms.pub.common.utils.CacheUtils;
import com.jinchuan.pms.pub.common.web.BaseController;

/**
 * 用户Controller
 * @author ThinkGem
 * @version 2013-8-29
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/userutils")
public class UserUtilsController extends BaseController {
	@Autowired
	private SystemService systemService;

	/**
	 * 查询节点
	 * @Title: getOfficeListByType  
	 * @param @param request
	 * @param @param response
	 * @param @param model
	 * @param @return 
	 * @return String 
	 * @throws
	 */
	@RequestMapping(value = "getOfficeListByType")
	@ResponseBody
	public ProcessResult getOfficeListByType(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		String typesJson = request.getParameter("typesJson");
		List<String> types = JsonMapper.getInstance().fromJson(typesJson, List.class);
		List<Office> offices = UserUtils.getOfficeListByTypes(types);
		result.setRetCode("000000");
		result.setRetMsg("操作成功");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("lists", offices);
		result.setRet(map);
		return result;
	}

	@RequestMapping(value = "getOfficeListMapByType")
	@ResponseBody
	public List<Map<String, Object>> getOfficeListMapByType(HttpServletRequest request, HttpServletResponse response,
			Model model) {
		String type = request.getParameter("type");
		List<Office> offices = UserUtils.getOfficeListByType(type);
		List<Map<String, Object>> map = new ArrayList<>();
		for (Office office : offices) {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("paramId", office.getId());
			paramMap.put("paramName", office.getName());
			map.add(paramMap);
		}
		return map;
	}

	/**
	 * 查询用户
	 * @Title: getUserList  
	 * @param @param request
	 * @param @param response
	 * @param @param model
	 * @param @return 
	 * @return ProcessResult 
	 * @throws
	 */
	@RequestMapping(value = "getUserList")
	@ResponseBody
	public ProcessResult getUserList(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		User user = new User();
		user.setIsSalesman("1");
		List<User> users = systemService.findUser(user);
		result.setRetCode("000000");
		result.setRetMsg("操作成功");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("lists", users);
		result.setRet(map);
		return result;
	}

	/**
	 * 查询业务员
	 */
	@RequestMapping(value = "getSalesmanList")
	@ResponseBody
	public ProcessResult getSalesmanList(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		User user = new User();
		user.setRentId(UserUtils.getUser().getRentId());
		user.setIsSalesman("1");
		List<User> users = systemService.findSalesmanList(user);
		result.setRetCode("000000");
		result.setRetMsg("操作成功");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("lists", users);
		result.setRet(map);
		return result;
	}

	/**
	 * 查询业务员
	 */
	@RequestMapping(value = "getAccountDate")
	@ResponseBody
	public ProcessResult getAccountDate(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		String storeId = request.getParameter("storeId");
		String accountDate = UserUtils.getAccountDate(storeId);
		result.setRetCode("000000");
		result.setRetMsg("操作成功");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("accountDate", accountDate);
		result.setRet(map);
		return result;
	}
	
	@RequestMapping(value = "removeCacheBykey")
	@ResponseBody
	public ProcessResult removeCacheBykey(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		String key  =request.getParameter("key");
		CacheUtils.remove(key);
		result.setRetCode("000000");
		result.setRetMsg("删除缓存"+key+"成功");
		return result;
	}
}
