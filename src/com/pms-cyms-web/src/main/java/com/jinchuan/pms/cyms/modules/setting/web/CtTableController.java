/**
 * 
 */
package com.jinchuan.pms.cyms.modules.setting.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.jinchuan.pms.cyms.modules.setting.entity.CtTable;
import com.jinchuan.pms.cyms.modules.setting.entity.CtTableType;
import com.jinchuan.pms.cyms.modules.setting.enums.TableStatusEnum;
import com.jinchuan.pms.cyms.modules.setting.service.CtTableService;
import com.jinchuan.pms.cyms.modules.setting.service.CtTableTypeService;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.modules.sys.entity.SysBusiConfig;
import com.jinchuan.pms.pub.modules.sys.service.SysBusiConfigService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**  
* @ClassName: CtTableController  
* @Description: TODO(桌台设置)  
* @author 孙文  
* @date 2019年9月6日  
*    
*/
@Controller
@RequestMapping(value = "${adminPath}/setting/ctTable")
public class CtTableController {
	@Autowired
	private SysBusiConfigService sysBusiConfigService;
	@Autowired
	CtTableTypeService ctTableTypeService;
	@Autowired
	CtTableService ctTableService;

	@RequestMapping("toCtTableSetJsp")
	public String toCtTableSetJsp(HttpServletRequest request, HttpServletResponse response, Model model) {

		model.addAttribute("selectStoreId", "pmscy");
		return "modules/setting/tableset/ctTableList";
	}

	@RequiresPermissions("table:ctTable:view")
	@RequestMapping(value = { "getCtTableList", "" })
	public String getOfficeList(HttpServletRequest request, HttpServletResponse response, String storeId1, Model model,
			CtTable ctTable1) {
		String rentId = UserUtils.getUser().getRentId();
		if ("".equals(storeId1) || null == storeId1) {

			storeId1 = ctTable1.getStoreId();
		}

		List<SysBusiConfig> foorlList = sysBusiConfigService.getByType(storeId1, "floor", rentId);
		List<CtTableType> ctTableTypeList = ctTableTypeService.getListByStoreId(storeId1);

		ctTable1.setStoreId(storeId1);
		ctTable1.setRentId(rentId);

		List<CtTable> ctTableServiceList = ctTableService.findAllListWithName(ctTable1);

		model.addAttribute("foorlList", foorlList);
		model.addAttribute("ctTableTypeList", ctTableTypeList);
		model.addAttribute("ctTableServiceList", ctTableServiceList);
		model.addAttribute("selectStoreId", storeId1);

		return "modules/setting/tableset/ctTableList";
	}

	@RequestMapping(value = "getTablesByStoreId")
	@ResponseBody
	public ProcessResult getTablesByStoreId(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String rentId = UserUtils.getUser().getRentId();
			String storeId = request.getParameter("storeId");
			String status = request.getParameter("status");
			CtTable ctTable = new CtTable();
			ctTable.setRentId(rentId);
			ctTable.setStoreId(storeId);
			ctTable.setStatus(status);
			List<CtTable> ctTables = ctTableService.findList(ctTable);
			Map<String, Object> ret = new HashMap<String, Object>();
			ret.put("lists", ctTables);
			result.setRet(ret);
			result.setRetCode("000000");
			result.setRetMsg("操作成功");
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

	@RequestMapping(value = "getTablesByStoreIdAndStatus")
	@ResponseBody
	public ProcessResult getTablesByStoreIdAndStatus(HttpServletRequest request, HttpServletResponse response,
			Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String rentId = UserUtils.getUser().getRentId();
			String storeId = request.getParameter("storeId");
			CtTable ctTable = new CtTable();
			ctTable.setRentId(rentId);
			ctTable.setStoreId(storeId);
			ctTable.setStatus(TableStatusEnum.cleanEmpty.getCode());
			List<CtTable> ctTables = ctTableService.findList(ctTable);
			Map<String, Object> ret = new HashMap<String, Object>();
			ret.put("lists", ctTables);
			result.setRet(ret);
			result.setRetCode("000000");
			result.setRetMsg("操作成功");
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

	@RequestMapping("toAddCtTableForm") //跳转到新增桌台页面
	public String toAddCtTable(HttpServletRequest request, HttpServletResponse response, String storeId, Model model) {
		String rentId = UserUtils.getUser().getRentId();

		List<SysBusiConfig> foorlList = sysBusiConfigService.getByType(storeId, "floor", rentId);
		List<CtTableType> ctTableTypeList = ctTableTypeService.getListByStoreId(storeId);

		model.addAttribute("foorlList", foorlList);
		model.addAttribute("ctTableTypeList", ctTableTypeList);
		model.addAttribute("selectStoreId", storeId);

		return "modules/setting/tableset/ctTableForm";
	}

	@RequestMapping("toEditCtTableForm") //跳转到桌台编辑页面
	public String toEditCtTableForm(HttpServletRequest request, HttpServletResponse response, String storeId, String id,
			Model model) {
		String rentId = UserUtils.getUser().getRentId();

		List<SysBusiConfig> foorlList = sysBusiConfigService.getByType(storeId, "floor", rentId);
		List<CtTableType> ctTableTypeList = ctTableTypeService.getListByStoreId(storeId);
		CtTable ctTable = ctTableService.get(id);
		model.addAttribute("foorlList", foorlList);
		model.addAttribute("ctTableTypeList", ctTableTypeList);
		model.addAttribute("ctTable", ctTable);
		return "modules/setting/tableset/editCtTableForm";
	}

	@RequestMapping("toAddFloorForm") //跳转到新增经营区域页面
	public String toAddFloorForm(HttpServletRequest request, HttpServletResponse response, String storeId,
			Model model) {
		model.addAttribute("selectStoreId", storeId);

		return "modules/setting/tableset/addFloorForm";
	}

	@RequestMapping("toEditFloorForm") //跳转到编辑经营区域页面
	public String toEditFloorForm(HttpServletRequest request, HttpServletResponse response, String storeId,
			String floorKey, Model model) {
		SysBusiConfig sysBusiConfig = sysBusiConfigService.getByParamKey(floorKey, storeId, "floor");
		model.addAttribute("sysBusiConfig", sysBusiConfig);
		return "modules/setting/tableset/editFloorForm";
	}

	@RequestMapping("saveFloor") //新增经营区域
	@ResponseBody
	public ProcessResult saveFloorForm(HttpServletRequest request, HttpServletResponse response,
			SysBusiConfig sysBusiConfig) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			sysBusiConfigService.saveAutoKey(sysBusiConfig);
			result.setRetCode("000000");
		} catch (Exception e) {
			result.setRetMsg(e.getMessage());
		}

		return result;
	}

	@RequestMapping("editFloor") //编辑经营区域
	@ResponseBody
	public ProcessResult editFloorForm(HttpServletRequest request, HttpServletResponse response,
			SysBusiConfig sysBusiConfig) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			sysBusiConfigService.save(sysBusiConfig);
			result.setRetCode("000000");
		} catch (Exception e) {
			result.setRetMsg(e.getMessage());
		}

		return result;
	}

	@RequestMapping("saveTable") //新增桌台
	@ResponseBody
	public ProcessResult saveTable(HttpServletRequest request, HttpServletResponse response, CtTable ctTable) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		List<CtTable> ctTable1 = ctTableService.selectByNoAndName(ctTable);
		if (ctTable1.size() > 0) {

			result.setRetMsg("本酒店该桌台编号或者名称已经存在，请重新输入！");
		} else {

			ctTable.setStatus(TableStatusEnum.cleanEmpty.getCode());
			try {
				ctTableService.save(ctTable);
				result.setRetCode("000000");
			} catch (Exception e) {
				result.setRetMsg(e.getMessage());
			}

		}

		return result;
	}

	@RequestMapping("editTable") //编辑桌台
	@ResponseBody
	public ProcessResult editTable(HttpServletRequest request, HttpServletResponse response, CtTable ctTable) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		List<CtTable> ctTable1 = ctTableService.selectByNoAndName(ctTable);
		if (ctTable1.size() <= 1) {
			try {
				ctTable.setOrderId(ctTable1.get(0).getOrderId());
				ctTable.setStatus(ctTable1.get(0).getStatus());
				ctTableService.save(ctTable);
				result.setRetCode("000000");
			} catch (Exception e) {
				result.setRetMsg(e.getMessage());
			}
		} else {
			result.setRetMsg("桌台编号或者名称重复！");
		}
		return result;
	}

	@RequestMapping("deleteCtTable") //删除桌台
	@ResponseBody
	public ProcessResult deleteCtTable(HttpServletRequest request, HttpServletResponse response, String id) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			ctTableService.deleteCtTableById(id);
			result.setRetCode("000000");
		} catch (Exception e) {
			result.setRetMsg(e.getMessage());
		}

		return result;
	}

	@RequestMapping("deleteFloor") //删除区域
	@ResponseBody
	public ProcessResult deleteFloor(HttpServletRequest request, HttpServletResponse response, String floorId) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		SysBusiConfig sysBusiConfig = sysBusiConfigService.get(floorId);
		sysBusiConfig.setDelFlag("1");

		try {
			CtTable ctTable = new CtTable();
			ctTable.setFloor(floorId);
			//查询该区域下是否有桌台
			List<CtTable> tableList = ctTableService.findList(ctTable);
			if (tableList != null && tableList.size() > 0) {
				result.setRetCode("111111");
			} else {
				sysBusiConfigService.update(sysBusiConfig);
				result.setRetCode("000000");
			}
		} catch (Exception e) {
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

	@RequestMapping("selectByTypeId") //根据经营区域查询对应的桌型
	@ResponseBody
	public List<CtTable> selectByTypeId(HttpServletRequest request, HttpServletResponse response, String floorId,
			RedirectAttributes redirectAttributes) {

		String rentId = UserUtils.getUser().getRentId();
		CtTable ctTable = new CtTable();
		ctTable.setFloor(floorId);
		ctTable.setRentId(rentId);
		List<CtTable> ctTableTypeList = ctTableService.selectByTypeId(ctTable);

		return ctTableTypeList;
	}

	@RequestMapping("selectByStoreId") //查询空房
	@ResponseBody
	public List<CtTable> selectByTypeIdAndStoreId(HttpServletRequest request, HttpServletResponse response) {

		String tableNos = request.getParameter("tableNos");
		String[] s = tableNos.split(",");
		String storeId = request.getParameter("storeId");
		List<CtTable> ctTableTypeList = ctTableService.selectByTypeIdAndStoreId("", storeId, s);

		return ctTableTypeList;
	}
}
