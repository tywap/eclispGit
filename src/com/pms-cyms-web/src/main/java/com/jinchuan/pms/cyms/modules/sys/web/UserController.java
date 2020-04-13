/**
 *
 */
package com.jinchuan.pms.cyms.modules.sys.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.jinchuan.pms.pub.common.beanvalidator.BeanValidators;
import com.jinchuan.pms.pub.common.config.Global;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.persistence.Page;
import com.jinchuan.pms.pub.common.utils.DateUtils;
import com.jinchuan.pms.pub.common.utils.StringUtils;
import com.jinchuan.pms.pub.common.utils.excel.ExportExcel;
import com.jinchuan.pms.pub.common.utils.excel.ImportExcel;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.entity.Office;
import com.jinchuan.pms.pub.modules.sys.entity.Role;
import com.jinchuan.pms.pub.modules.sys.entity.User;
import com.jinchuan.pms.pub.modules.sys.service.OfficeService;
import com.jinchuan.pms.pub.modules.sys.service.SystemService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 用户Controller
 * @author ThinkGem
 * @version 2013-8-29
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/user")
public class UserController extends BaseController {
	@Autowired
	private SystemService systemService;
	@Autowired
	private OfficeService officeService;

	@ModelAttribute
	public User get(@RequestParam(required = false) String id) {
		if (StringUtils.isNotBlank(id)) {
			return systemService.getUser(id);
		} else {
			return new User();
		}
	}

	@RequiresPermissions("sys:user:view")
	@RequestMapping(value = { "index" })
	public String index(User user, Model model) {
		return "modules/sys/userIndex";
	}

	@RequiresPermissions("sys:user:view")
	@RequestMapping(value = { "list", "" })
	public String list(User user, HttpServletRequest request, HttpServletResponse response, Model model) {
		List<Role> roleList = systemService.findAllRole();
		List<Office> officeList = officeService.findAll();
		user.setRentId(UserUtils.getUser().getRentId());
		// 权限
		String authorityStoreId = UserUtils.getStoreCacheStr();
		if (StringUtils.isEmpty(user.getCompanyId())) {
			user.setAuthorityStoreId(authorityStoreId);
		}
		Page<User> page = systemService.findUser(new Page<User>(request, response), user);
		User user1 = UserUtils.getUser();
		List<User> userList = systemService.findUser(user1);
		String roleId = userList.get(0).getRoleId();
		model.addAttribute("page", page);
		model.addAttribute("roleList", roleList);
		model.addAttribute("roleId", roleId);
		model.addAttribute("officeList", officeList);
		return "modules/sys/userList";
	}

	@ResponseBody
	@RequiresPermissions("sys:user:view")
	@RequestMapping(value = { "listData" })
	public Page<User> listData(User user, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<User> page = systemService.findUser(new Page<User>(request, response), user);
		return page;
	}

	@RequiresPermissions("sys:user:view")
	@RequestMapping(value = "form")
	public String form(User user, Model model) {
		if (user.getCompany() == null || user.getCompany().getId() == null) {
			user.setCompany(UserUtils.getUser().getCompany());
		}
		if (user.getOffice() == null || user.getOffice().getId() == null) {
			user.setOffice(UserUtils.getUser().getOffice());
		}
		List<Office> officeList = officeService.findAll();
		/*
		 * List<Office> returnList = new ArrayList<>(); for (Office office :
		 * officeList) { if (!office.getId().equals(office.getRentId()))
		 * returnList.add(office); }
		 */
		if (StringUtils.isEmpty(user.getId())) {
			user = new User();
		} else {
			user = systemService.queryUser(user.getId());
		}
		Role rolel = new Role();
		rolel.setRentId(UserUtils.getUser().getRentId());
		List<Role> list = systemService.findRole(rolel);
		for (Role role : list) {
			role.setParentId(systemService.getParentId(UserUtils.getUser().getRentId(), role.getId()));
			role.setParentName(systemService.getParentName(UserUtils.getUser().getRentId(), role.getParentId()));
		}
		User user1 = UserUtils.getUser();
		List<User> userList = systemService.findUser(user1);
		String roleId = userList.get(0).getRoleId();
		String selectId = "0";
		if (user.getRoleId() != null && !user.getRoleId().equals("null")) {
			selectId = user.getRoleId();
		}
		if (userList.get(0).getRoleName().equals("系统管理员")) {
			roleId = "0";
		}
		model.addAttribute("roleId", roleId);
		model.addAttribute("selectId", selectId);
		model.addAttribute("user", user);
		model.addAttribute("list", list);
		model.addAttribute("allRoles", systemService.findAllRole());
		model.addAttribute("officeList", officeList);
		return "modules/sys/userForm";
	}

	@RequiresPermissions("sys:user:edit")
	@RequestMapping(value = "save")
	@ResponseBody
	public ProcessResult save(User user, HttpServletRequest request, HttpServletResponse response, Model model,
			RedirectAttributes redirectAttributes) {
		ProcessResult result = new ProcessResult();
		user.setRentId(UserUtils.getUser().getRentId());
		/*
		 * if(Global.isDemoMode()){ addMessage(redirectAttributes,
		 * "演示模式，不允许操作！"); return "redirect:" + adminPath +
		 * "/sys/user/list?repage"; }
		 */
		// 修正引用赋值问题，不知道为何，Company和Office引用的一个实例地址，修改了一个，另外一个跟着修改。
		user.setCompanyId(request.getParameter("companyId"));
		// 如果用户Id不为空，则不需要设置密码
		if (user.getId().equals("")) {
			user.setPassword(SystemService.entryptPassword("888888")); // 新增员工时,默认密码为888888
		}
		if (!beanValidator(model, user)) {
			result.setRetCode("999999");
			result.setRetMsg("数据验证失败");
		}
		if (!"true".equals(checkLoginName(user.getOldLoginName(), user.getLoginName()))) {
			// addMessage(model, "保存用户'" + user.getLoginName() + "'失败，登录名已存在");
			result.setRetCode("999999");
			result.setRetMsg("保存用户" + user.getLoginName() + "失败，登录名已存在");
			return result;
		}

		String isSalesman = user.getIsSalesman();
		// ===============================================================================
		/*
		 * by hjw
		 * 
		 * @param RentId CompanyId no findUserCountByCheckUserNo(user)
		 */
		/*
		 * Page<User> page = systemService.findUser(new Page<User>(request,
		 * response), user); List<User> userList = page.getList(); for(User
		 * user_ : userList){
		 * 
		 * }
		 */
		if (!user.getId().equals("") && systemService.findUserCountByCheckUserNo(user) > 0) {
			result.setRetCode("999999");
			result.setRetMsg("保存用户" + user.getLoginName() + "失败，工号" + user.getNo() + "已存在");
			return result;
		} else if (systemService.findUserCountByCheckUserNo(user) > 0 && user.getId().equals("")) { // 同一集团同一酒店的员工工号重复验证
			result.setRetCode("999999");
			result.setRetMsg("保存用户" + user.getLoginName() + "失败，工号" + user.getNo() + "已存在");
			return result;
		}
		// ===============================================================================
		// 角色数据有效性验证，过滤不在授权内的角色
		List<Role> roleList = Lists.newArrayList();
		Role role = systemService.getRole(user.getRoleId());
		roleList.add(role);

		user.setRoleList(roleList);
		// 保存用户信息
		if (user.getLoginFlag().equals("0")) {
			user.setLoginName("");
		}
		systemService.saveUser(user);
		// 清除当前用户缓存
		if (user.getLoginName().equals(UserUtils.getUser().getLoginName())) {
			UserUtils.clearCache();
			// UserUtils.getCacheMap().clear();
		}
		result.setRetCode("000000");
		result.setRetMsg("保存用户" + user.getLoginName() + "成功");
		// addMessage(redirectAttributes, "保存用户'" + user.getLoginName() +
		// "'成功");
		// return "redirect:" + adminPath + "/sys/user/list?repage";
		return result;
	}

	@RequiresPermissions("sys:user:edit")
	@RequestMapping(value = "delete")
	public String delete(User user, RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/sys/user/list?repage";
		}
		if (UserUtils.getUser().getId().equals(user.getId())) {
			addMessage(redirectAttributes, "删除用户失败, 不允许删除当前用户");
		} else if (User.isAdmin(user.getId())) {
			addMessage(redirectAttributes, "删除用户失败, 不允许删除超级管理员用户");
		} else {
			systemService.deleteUser(user);
			addMessage(redirectAttributes, "删除用户成功");
		}
		return "redirect:" + adminPath + "/sys/user/list?repage";
	}

	/**
	 * 导出用户数据
	 * @param user
	 * @param request
	 * @param response
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("sys:user:view")
	@RequestMapping(value = "export", method = RequestMethod.POST)
	public String exportFile(User user, HttpServletRequest request, HttpServletResponse response,
			RedirectAttributes redirectAttributes) {
		try {
			String fileName = "用户数据" + DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";
			Page<User> page = systemService.findUser(new Page<User>(request, response, -1), user);
			new ExportExcel("用户数据", User.class).setDataList(page.getList()).write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出用户失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + adminPath + "/sys/user/list?repage";
	}

	/**
	 * 导入用户数据
	 * @param file
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("sys:user:edit")
	@RequestMapping(value = "import", method = RequestMethod.POST)
	public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/sys/user/list?repage";
		}
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<User> list = ei.getDataList(User.class);
			for (User user : list) {
				try {
					if ("true".equals(checkLoginName("", user.getLoginName()))) {
						user.setPassword(SystemService.entryptPassword("888888"));
						BeanValidators.validateWithException(validator, user);
						systemService.saveUser(user);
						successNum++;
					} else {
						failureMsg.append("<br/>登录名 " + user.getLoginName() + " 已存在; ");
						failureNum++;
					}
				} catch (ConstraintViolationException ex) {
					failureMsg.append("<br/>登录名 " + user.getLoginName() + " 导入失败：");
					List<String> messageList = BeanValidators.extractPropertyAndMessageAsList(ex, ": ");
					for (String message : messageList) {
						failureMsg.append(message + "; ");
						failureNum++;
					}
				} catch (Exception ex) {
					failureMsg.append("<br/>登录名 " + user.getLoginName() + " 导入失败：" + ex.getMessage());
				}
			}
			if (failureNum > 0) {
				failureMsg.insert(0, "，失败 " + failureNum + " 条用户，导入信息如下：");
			}
			addMessage(redirectAttributes, "已成功导入 " + successNum + " 条用户" + failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入用户失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + adminPath + "/sys/user/list?repage";
	}

	/**
	 * 下载导入用户数据模板
	 * @param response
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("sys:user:view")
	@RequestMapping(value = "import/template")
	public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
			String fileName = "用户数据导入模板.xlsx";
			List<User> list = Lists.newArrayList();
			list.add(UserUtils.getUser());
			new ExportExcel("用户数据", User.class, 2).setDataList(list).write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + adminPath + "/sys/user/list?repage";
	}

	/**
	 * 验证登录名是否有效
	 * @param oldLoginName
	 * @param loginName
	 * @return
	 */
	@ResponseBody
	@RequiresPermissions("sys:user:edit")
	@RequestMapping(value = "checkLoginName")
	public String checkLoginName(String oldLoginName, String loginName) {
		if (loginName != null && loginName.equals(oldLoginName)) {
			return "true";
		} else if (loginName != null && !loginName.equals("")) {
			if (systemService.getUserByLoginName(loginName) == null)
				return "true";
		} else if (loginName == null || loginName.equals("")) {
			return "true";
		}
		return "false";
	}

	/**
	 * 用户信息显示及保存
	 * @param user
	 * @param model
	 * @return
	 */
	@RequiresPermissions("user")
	@RequestMapping(value = "info")
	public String info(User user, HttpServletResponse response, Model model) {
		User currentUser = UserUtils.getUser();
		if (StringUtils.isNotBlank(user.getName())) {
			if (Global.isDemoMode()) {
				model.addAttribute("message", "演示模式，不允许操作！");
				return "modules/sys/userInfo";
			}
			currentUser.setEmail(user.getEmail());
			currentUser.setPhone(user.getPhone());
			currentUser.setMobile(user.getMobile());
			currentUser.setRemarks(user.getRemarks());
			currentUser.setPhoto(user.getPhoto());
			systemService.updateUserInfo(currentUser);
			model.addAttribute("message", "保存用户信息成功");
		}
		model.addAttribute("user", currentUser);
		model.addAttribute("Global", new Global());
		return "modules/sys/userInfo";
	}

	/**
	 * 返回用户信息
	 * @return
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "infoData")
	public User infoData() {
		return UserUtils.getUser();
	}

	/**
	 * 修改个人用户密码
	 * @param oldPassword
	 * @param newPassword
	 * @param model
	 * @return
	 */
	@RequiresPermissions("user")
	@RequestMapping(value = "modifyPwd")
	public String modifyPwd(String oldPassword, String newPassword, Model model) {
		User user = UserUtils.getUser();
		if (StringUtils.isNotBlank(oldPassword) && StringUtils.isNotBlank(newPassword)) {
			if (Global.isDemoMode()) {
				model.addAttribute("message", "演示模式，不允许操作！");
				return "modules/sys/userModifyPwd";
			}
			if (SystemService.validatePassword(oldPassword, user.getPassword())) {
				systemService.updatePasswordById(user.getId(), user.getLoginName(), newPassword);
				model.addAttribute("message", "修改密码成功");
			} else {
				model.addAttribute("message", "修改密码失败，旧密码错误");
			}
		}
		model.addAttribute("user", user);
		return "modules/sys/userModifyPwd";
	}

	/**
	 * 用户密码重置
	 * @param oldPassword
	 * @param newPassword
	 * @param model
	 * @return
	 */
	@RequiresPermissions("sys:user:edit")
	@RequestMapping(value = "resetPwd")
	public String resetPwd(User user, Model model, RedirectAttributes redirectAttributes) {
		// User user = UserUtils.getUser();
		/*
		 * ProcessResult result = new ProcessResult(); if(Global.isDemoMode()){
		 * result.setRetCode("999999"); result.setRetMsg("演示模式，不允许操作！");
		 * //model.addAttribute("message", "演示模式，不允许操作！"); //return
		 * "modules/sys/userModifyPwd"; }else{
		 * user.setPassword(SystemService.entryptPassword("888888")); //
		 * 重置密码时,默认密码为888888 systemService.saveUser(user);
		 * result.setRetCode("000000"); result.setRetMsg("密码重置成功！"); }
		 * model.addAttribute("user", user); return result;
		 */
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/sys/user/list?repage";
		} else {
			user.setPassword(SystemService.entryptPassword("888888")); // 重置密码时,默认密码为888888
			systemService.saveUser(user);
			addMessage(redirectAttributes, "用户密码重置成功");
		}
		return "redirect:" + adminPath + "/sys/user/list?repage";
	}

	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(@RequestParam(required = false) String officeId,
			HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		List<User> list = systemService.findUserByOfficeId(officeId);
		for (int i = 0; i < list.size(); i++) {
			User e = list.get(i);
			Map<String, Object> map = Maps.newHashMap();
			map.put("id", "u_" + e.getId());
			map.put("pId", officeId);
			map.put("name", StringUtils.replace(e.getName(), " ", ""));
			mapList.add(map);
		}
		return mapList;
	}

	public static String getName(String id, String parentId) {
		if (id.equals(parentId)) {

		}
		return "";
	}
	// @InitBinder
	// public void initBinder(WebDataBinder b) {
	// b.registerCustomEditor(List.class, "roleList", new
	// PropertyEditorSupport(){
	// @Autowired
	// private SystemService systemService;
	// @Override
	// public void setAsText(String text) throws IllegalArgumentException {
	// String[] ids = StringUtils.split(text, ",");
	// List<Role> roles = new ArrayList<Role>();
	// for (String id : ids) {
	// Role role = systemService.getRole(Long.valueOf(id));
	// roles.add(role);
	// }
	// setValue(roles);
	// }
	// @Override
	// public String getAsText() {
	// return Collections3.extractToString((List) getValue(), "id", ",");
	// }
	// });
	// }
}
