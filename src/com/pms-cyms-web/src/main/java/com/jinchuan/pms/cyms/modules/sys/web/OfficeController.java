/**
 *
 */
package com.jinchuan.pms.cyms.modules.sys.web;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;
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

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.jinchuan.pms.pub.common.config.Global;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.persistence.Page;
import com.jinchuan.pms.pub.common.utils.StringUtils;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.entity.Office;
import com.jinchuan.pms.pub.modules.sys.entity.PubShift;
import com.jinchuan.pms.pub.modules.sys.entity.User;
import com.jinchuan.pms.pub.modules.sys.service.AreaService;
import com.jinchuan.pms.pub.modules.sys.service.OfficeService;
import com.jinchuan.pms.pub.modules.sys.service.PubShiftService;
import com.jinchuan.pms.pub.modules.sys.utils.DictUtils;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 机构Controller
 * @author ThinkGem
 * @version 2013-5-15
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/office")
public class OfficeController extends BaseController {
	@Autowired
	private OfficeService officeService;
	@Autowired
	private PubShiftService pubShiftService;
	@Autowired
	AreaService areaService;

	@ModelAttribute("office")
	public Office get(@RequestParam(required = false) String id) {
		if (StringUtils.isNotBlank(id)) {
			return officeService.get(id);
		} else {
			return new Office();
		}
	}

	@RequiresPermissions("sys:office:view")
	@RequestMapping(value = { "" })
	public String index(Office office, Model model) {
		// model.addAttribute("list", officeService.findAll());
		model.addAttribute("rentId", UserUtils.getUser().getRentId());
		office = officeService.get(UserUtils.getUser().getCompany().getId());
		model.addAttribute("pId", office.getId());
		return "modules/sys/officeIndex";
	}

	@RequiresPermissions("sys:office:view")
	@RequestMapping(value = { "list" })
	public String list(Office office, HttpServletRequest request, HttpServletResponse response, Model model) {
		List<Office> offices = officeService.findList(office);
		model.addAttribute("list", offices);
		model.addAttribute("rentId", UserUtils.getUser().getRentId());
		model.addAttribute("tabPageId", request.getParameter("tabPageId"));
		return "modules/sys/officeList";
	}

	/**
	 *  查询分店list
	 * @param office
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = { "branchList" })
	public String branchList(Office office, HttpServletRequest request, HttpServletResponse response, Model model) {
		office.setRentId(UserUtils.getUser().getRentId());
		// 当查询所有数据的时候判断数据权限
		office.setAuthorityStoreId(UserUtils.getStoreCacheStr());
		List<Office> officeList = officeService.getOfficeListAll(office);
		office.setType(Office.OFFICE_TYPE_STORE);
		Page<Office> page = officeService.findPage(new Page<Office>(request, response), office);
		model.addAttribute("page", page);
		model.addAttribute("officeList", officeList);
		return "modules/sys/branchOfficeList";

	}

	/**
	 * 根据城市Id获取酒店名称
	 * @param storeId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "queryHotel")
	@ResponseBody
	public List<Map<String, String>> queryHotel(String areaId, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		// 权限
		String authorityStoreId = UserUtils.getStoreCacheStr();
		List<Map<String, String>> hotelMap = officeService.findHotelList(Office.OFFICE_TYPE_STORE,
				UserUtils.getUser().getRentId(), areaId, authorityStoreId);
		return hotelMap;
	}

	/**
	 * 根据酒店Id,查询数据
	 * @param storeId
	 * @param model
	 * @return
	 * @throws ParseException 
	 */
	@RequestMapping(value = "queryHotelDate")
	@ResponseBody
	public List<Office> queryHotelDate(String areaId, String strTime, String endTime, HttpServletRequest request,
			HttpServletResponse response, Model model) throws ParseException {
		// Office hotelListDate = null;
		List<Office> officeList = new ArrayList<Office>();
		// 权限
		String authorityStoreId = UserUtils.getStoreCacheStr();
		List<Map<String, String>> hotelMap = officeService.findHotelList(Office.OFFICE_TYPE_STORE,
				UserUtils.getUser().getRentId(), areaId, authorityStoreId);
		for (Map<String, String> map : hotelMap) {
			if (strTime != null && strTime != "" && endTime != null && endTime != "") {
				Office office = new Office();
				office.setRentId(UserUtils.getUser().getRentId());
				office.setId(map.get("id"));
				office = officeService.get(office);
				officeList.add(office);
			}
		}

		return officeList;
	}

	@RequestMapping(value = "choseShift")
	public String choseShift(String storeId, Model model) {
		// 获取班次信息
		List<PubShift> shiftList = pubShiftService.queryStoreShift(storeId, UserUtils.getUser().getRentId());
		model.addAttribute("shiftList", shiftList);
		model.addAttribute("storeId", storeId);
		model.addAttribute("username", UserUtils.getUser().getLoginName());
		model.addAttribute("password", UserUtils.getUser().getPassword());
		model.addAttribute("url", Global.getConfig("cyms.url"));
		model.addAttribute("logoutUrl", Global.getConfig("business.logout.url"));
		return "modules/sys/choseShiftForm";
	}

	@RequestMapping(value = "getPubShiftData")
	@ResponseBody
	public PubShift getPubShiftData(String shiftId, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		PubShift pubShift = pubShiftService.get(shiftId);
		return pubShift;
	}

	@RequiresPermissions("sys:office:view")
	@RequestMapping(value = "form")
	public String form(Office office, Model model) {
		User user = UserUtils.getUser();
		if (office.getParent() == null || office.getParent().getId() == null) {
			office.setParent(user.getOffice());
		}
		office.setParent(officeService.get(office.getParent().getId()));
		// List<SysBusiConfig> sysbusilist =
		// SysBusiConfigUtils.getSysBusiConfigList("wxBrand", "1");
		if (office.getArea() == null && user.getOffice() != null) {
			office.setArea(user.getOffice().getArea());
		}
		// 自动获取排序号
		if (StringUtils.isBlank(office.getId()) && office.getParent() != null) {
			int size = 0;
			List<Office> list = officeService.findAllOffice();
			for (int i = 0; i < list.size(); i++) {
				Office e = list.get(i);
				if (e.getParent() != null && e.getParent().getId() != null
						&& e.getParent().getId().equals(office.getParent().getId())) {
					size++;
				}
			}
			office.setCode(office.getParent().getCode()
					+ StringUtils.leftPad(String.valueOf(size > 0 ? size + 1 : 1), 3, "0"));
		}
		// model.addAttribute("sysbusilist", sysbusilist);
		model.addAttribute("office", office);
		return "modules/sys/officeForm";
	}

	@RequiresPermissions("sys:office:edit")
	@ResponseBody
	@RequestMapping(value = "save")
	public ProcessResult save(Office office, Model model, RedirectAttributes redirectAttributes) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		if (Global.isDemoMode()) {
			result.setRetMsg("演示模式，不允许操作！");// (redirectAttributes,
											// "演示模式，不允许操作！");
			result.setRetCode("999999");
			return result;
		}
		if (!beanValidator(model, office)) {
			result.setRetCode("999999");
			result.setRetMsg("数据验证失败！");
			return result;
		}
		List<Office> officeList = officeService.findOfficeByRentId();
		for (Office o : officeList) {
			if (office.getName().equals(o.getName()) && !office.getId().equals(o.getId())) {
				result.setRetMsg("机构名称不能重复！");
				result.setRetCode("999999");
				return result;
			}
		}
		/***
		 * 2017-09-13  office 跟集团酒店绑定  
		 * 1、不需要机构级别 (全部设置为 1 一级)
		 */
		String hotelId = office.getId();
		office.setGrade("1");
		if ((office.getType().equals("3") || office.getType().equals("4")) && (hotelId == null || hotelId.equals(""))) {
			// 保存机构
			officeService.saveOffice(office);
			if (office.getChildDeptList() != null) {
				Office childOffice = null;
				for (String id : office.getChildDeptList()) {
					childOffice = new Office();
					childOffice.setName(DictUtils.getDictLabel(id, "sys_office_common", "未知"));
					childOffice.setParent(office);
					childOffice.setArea(office.getArea());
					childOffice.setType("2");
					childOffice.setGrade(String.valueOf(Integer.valueOf(office.getGrade()) + 1));
					childOffice.setUseable(Global.YES);
					officeService.save(childOffice);
				}
			}
			result.setRetMsg("保存机构成功！");
			result.setRetCode("000000");
		} else {
			// 保存机构
			officeService.saveOffice(office);
			if (office.getChildDeptList() != null) {
				Office childOffice = null;
				for (String id : office.getChildDeptList()) {
					childOffice = new Office();
					childOffice.setName(DictUtils.getDictLabel(id, "sys_office_common", "未知"));
					childOffice.setParent(office);
					childOffice.setArea(office.getArea());
					childOffice.setType("2");
					childOffice.setGrade(String.valueOf(Integer.valueOf(office.getGrade()) + 1));
					childOffice.setUseable(Global.YES);
					officeService.save(childOffice);
				}
			}
			result.setRetMsg("保存机构成功！");
			result.setRetCode("000000");
		}
		return result;
	}

	@RequiresPermissions("sys:office:edit")
	@RequestMapping(value = "delete")
	public String delete(Office office, RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/sys/office/list";
		}
		int num = 0;
		List<Office> officeList = officeService.findAll();
		for (Office o : officeList) {
			if (o.getParentId().equals(office.getId())) {
				num++;
			}
		}
		if (office.getType().equals("3") || office.getType().equals("4")) {
			addMessage(redirectAttributes, "禁止直接删除酒店，请联系客服进行操作！");
			return "redirect:" + adminPath + "/sys/office/list?id=" + UserUtils.getUser().getRentId() + "&parentIds=0";
		}
		if (num > 0) {
			addMessage(redirectAttributes, "删除机构失败, 请先删除机构下的所有子机构");
		} else {
			officeService.delete(office);
			addMessage(redirectAttributes, "删除机构成功");
		}
		return "redirect:" + adminPath + "/sys/office/list?id=" + UserUtils.getUser().getRentId() + "&parentIds=0";
	}

	/**
	 * 获取机构JSON数据。
	 * @param extId 排除的ID
	 * @param type	类型（1：公司；2：部门/小组/其它：3：用户）
	 * @param grade 显示级别
	 * @param response
	 * @return
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(@RequestParam(required = false) String extId,
			@RequestParam(required = false) String type, @RequestParam(required = false) Long grade,
			@RequestParam(required = false) Boolean isAll, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		UserUtils.removeCache(UserUtils.CACHE_OFFICE_LIST);
		List<Office> list = officeService.findList(isAll);
		for (int i = 0; i < list.size(); i++) {
			Office e = list.get(i);
			if ((StringUtils.isBlank(extId)
					|| (extId != null && !extId.equals(e.getId()) && e.getParentIds().indexOf("," + extId + ",") == -1))
					&& (type == null || (type != null && (type.equals("1") ? type.equals(e.getType()) : true)))
					&& (grade == null || (grade != null && Integer.parseInt(e.getGrade()) <= grade.intValue()))
					&& Global.YES.equals(e.getUseable())) {
				Map<String, Object> map = Maps.newHashMap();
				map.put("id", e.getId());
				map.put("pId", e.getParentId());
				map.put("pIds", e.getParentIds());
				map.put("name", e.getName());
				if (type != null && "3".equals(type)) {
					map.put("isParent", true);
				}
				mapList.add(map);
			}
		}
		return mapList;
	}

	/**
	 * 获取机构JSON数据。
	 * @param extId 排除的ID
	 * @param type	类型（1：公司；2：部门/小组/其它：3：用户）
	 * @param grade 显示级别
	 * @param response
	 * @return
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "editTreeData")
	public List<Map<String, Object>> editTreeData(@RequestParam(required = false) String extId,
			@RequestParam(required = false) String type, @RequestParam(required = false) Long grade,
			@RequestParam(required = false) Boolean isAll, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		List<Office> list = officeService.findAllOffice();
		for (int i = 0; i < list.size(); i++) {
			Office e = list.get(i);
			if ((StringUtils.isBlank(extId)
					|| (extId != null && !extId.equals(e.getId()) && e.getParentIds().indexOf("," + extId + ",") == -1))
					&& (type == null || (type != null && (type.equals("1") ? type.equals(e.getType()) : true)))
					&& (grade == null || (grade != null && Integer.parseInt(e.getGrade()) <= grade.intValue()))
					&& Global.YES.equals(e.getUseable())) {
				Map<String, Object> map = Maps.newHashMap();
				map.put("id", e.getId());
				map.put("pId", e.getParentId());
				map.put("pIds", e.getParentIds());
				map.put("name", e.getName());
				if (type != null && "3".equals(type)) {
					map.put("isParent", true);
				}
				mapList.add(map);
			}
		}
		return mapList;
	}

	@RequestMapping(value = "sysmap")
	public String sysmap(HttpServletRequest request, HttpServletResponse response, Model model)
			throws UnsupportedEncodingException {
		String addr = "";
		String city = request.getParameter("city");// new
													// String(request.getParameter("city").getBytes("ISO8859-1"),"UTF-8");//
		String address = request.getParameter("address"); // new
															// String(request.getParameter("address").getBytes("ISO8859-1"),"UTF-8");//
		city = URLDecoder.decode(city, "UTF-8");
		address = URLDecoder.decode(address, "UTF-8");
		if (city != null) {
			addr = city;
		}
		if (address != null) {
			addr = addr + address;
		}
		model.addAttribute("address", addr);
		return "modules/sys/sysmap";
	}

}
