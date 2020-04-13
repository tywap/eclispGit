
package com.jinchuan.pms.cyms.modules.diagarm.web;

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
import org.springframework.web.bind.annotation.ResponseBody;

import com.jinchuan.pms.cyms.modules.diagarm.entity.DiagramInfo;
import com.jinchuan.pms.cyms.modules.setting.entity.CtTable;
import com.jinchuan.pms.cyms.modules.setting.entity.CtTableType;
import com.jinchuan.pms.cyms.modules.setting.enums.TableStatusEnum;
import com.jinchuan.pms.cyms.modules.setting.service.CtTableService;
import com.jinchuan.pms.cyms.modules.setting.service.CtTableTypeService;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.utils.CacheUtils;
import com.jinchuan.pms.pub.common.utils.StringUtils;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.entity.Office;
import com.jinchuan.pms.pub.modules.sys.entity.SysBusiConfig;
import com.jinchuan.pms.pub.modules.sys.enums.SysConfigTypeEnum;
import com.jinchuan.pms.pub.modules.sys.service.SysBusiConfigService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 房态图Controller
 * 
 * @author LYC
 * @version 2017-09-15
 */
@Controller
@RequestMapping(value = "${adminPath}/diagram")
public class DiagramController extends BaseController {

	@Autowired
	private SysBusiConfigService sysBusiConfigService;
	@Autowired
	private CtTableService ctTableService;
	@Autowired
	private CtTableTypeService ctTableTypeService;

	@RequestMapping(value = "indexLeft")
	public String indexLeft(HttpServletRequest request, HttpServletResponse response, Model model) {
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("type", SysConfigTypeEnum.diagramSetting.getType());
		List<SysBusiConfig> configList = sysBusiConfigService.getByType(paramMap);

		paramMap = new HashMap<String, String>();
		paramMap.put("type", SysConfigTypeEnum.roomType.getType());
		paramMap.put("storeId", UserUtils.getStoreId());
		List<SysBusiConfig> roomType = sysBusiConfigService.getByType(paramMap); // 房型List

		paramMap = new HashMap<String, String>();
		paramMap.put("type", SysConfigTypeEnum.roomFeature.getType());
		List<SysBusiConfig> roomFeature = sysBusiConfigService.getByType(paramMap); // 房征List

		paramMap = new HashMap<String, String>();
		paramMap.put("type", SysConfigTypeEnum.building.getType());
		paramMap.put("storeId", UserUtils.getStoreId());
		List<SysBusiConfig> building = sysBusiConfigService.getByType(paramMap); // 楼栋List

		paramMap.put("type", SysConfigTypeEnum.floor.getType());
		List<SysBusiConfig> floor = sysBusiConfigService.getByType(paramMap); // 楼层List

		List<Office> offices = UserUtils.getHotelList();// 用户可访问的酒店
		// 餐台状态
		List<Map<String, String>> tableStatus = TableStatusEnum.getList();// 台态

		model.addAttribute("offices", offices);
		model.addAttribute("tableStatus", tableStatus);
		model.addAttribute("floorList", floor);
		model.addAttribute("buildingList", building);
		model.addAttribute("roomFeatureList", roomFeature);
		model.addAttribute("roomTypeList", roomType);
		Map<String, String> settings = new HashMap<String, String>();
		for (SysBusiConfig sys : configList) {
			settings.put(sys.getParamKey(), sys.getParamValue());
		}
		model.addAttribute("settings", settings);
		return "modules/diagram/indexLeft";
	}

	@RequestMapping(value = "getSettingByStoreId")
	@ResponseBody
	public ProcessResult getSettingByStoreId(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String storeId = request.getParameter("storeId");
			// 楼栋设置
			Map<String, String> paramMap = new HashMap<String, String>();
			paramMap.put("type", SysConfigTypeEnum.building.getType());
			paramMap.put("storeId", storeId);
			List<SysBusiConfig> buildings = sysBusiConfigService.getByType(paramMap);
			// 楼层设置
			paramMap.put("type", SysConfigTypeEnum.floor.getType());
			List<SysBusiConfig> floors = sysBusiConfigService.getByType(paramMap);
			// 餐台类型
			List<CtTableType> tableTypes = ctTableTypeService.getListByStoreId(storeId);
			Map<String, Object> ret = new HashMap<String, Object>();
			ret.put("buildings", buildings);
			ret.put("floors", floors);
			ret.put("tableTypes", tableTypes);
			result.setRet(ret);
			result.setRetCode("000000");
			result.setRetMsg("操作成功");
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

	@RequestMapping(value = "indexRight")
	public String indexRight(HttpServletRequest request, HttpServletResponse response, Model model) {
		// 搜索条件
		String searchParam = request.getParameter("searchParam");
		String buildingSearch = request.getParameter("building");
		String floorSearch = request.getParameter("floor");
		String tableTypeSearch = request.getParameter("tableType");
		String tableStatusSearch = request.getParameter("tableStatus");
		String storeId = request.getParameter("storeId");
		String rentId = UserUtils.getUser().getRentId();
		// 查询房态图设置
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("type", SysConfigTypeEnum.diagramSetting.getType());
		List<SysBusiConfig> configList = sysBusiConfigService.getByType(paramMap);
		Map<String, String> settings = new HashMap<String, String>();
		for (SysBusiConfig sys : configList) {
			settings.put(sys.getParamKey(), sys.getParamValue());
		}
		// 状态计数map
		Map<String, Integer> statusCount = new HashMap<String, Integer>();
		for (TableStatusEnum e : TableStatusEnum.values()) {
			statusCount.put(e.getCode(), 0);
		}
		CtTable ctTable = new CtTable();
		ctTable.setRentId(rentId);
		ctTable.setStoreId(storeId);
		List<CtTable> ctTables = ctTableService.findList(ctTable);
		List<DiagramInfo> tableInfoList = new ArrayList<DiagramInfo>();
		for (CtTable table : ctTables) {
			try {
				if (buildingSearch != null && StringUtils.isNotEmpty(buildingSearch)
						&& !buildingSearch.equals(table.getBuilding())) {
					// 楼栋验证
					continue;
				}
				if (floorSearch != null && StringUtils.isNotEmpty(floorSearch)
						&& floorSearch.indexOf(table.getFloor() + ",") < 0) {
					// 楼层验证
					continue;
				}
				if (tableTypeSearch != null && StringUtils.isNotEmpty(tableTypeSearch)
						&& tableTypeSearch.indexOf(table.getTypeId().trim() + ",") < 0) {
					// 餐台类型验证
					continue;
				}
				if (tableStatusSearch != null && StringUtils.isNotEmpty(tableStatusSearch)
						&& tableStatusSearch.indexOf(table.getStatus().trim() + ",") < 0) {
					// 餐台状态验证
					continue;
				}
				DiagramInfo diaInfo = new DiagramInfo();
				if (CacheUtils.get("roomsInfo_" + table.getId()) != null) {
					diaInfo = (DiagramInfo) CacheUtils.get("roomsInfo_" + table.getId());
				} else {
					diaInfo.setFloor(table.getFloor());
					diaInfo.setBuilding(table.getBuilding());
					diaInfo.setTableId(table.getId());
					diaInfo.setTableNo(table.getNo());
					diaInfo.setTableName(table.getName());
					diaInfo.setTableTypeId(table.getTypeId());
					diaInfo.setTableStatus(table.getStatus());
					diaInfo.setColor(settings.get(table.getStatus()));
					diaInfo.setOrderId(table.getOrderId());
				}
				if (searchParam != null && StringUtils.isNotEmpty(searchParam)) { // 客人姓名/房号验证
					if ((diaInfo.getTableNo().indexOf(searchParam) <= -1
							&& (diaInfo.getNameAll() == null || diaInfo.getNameAll().indexOf(searchParam) <= -1))) {
						continue;
					}
				}
				tableInfoList.add(diaInfo);
				statusCount.put(table.getStatus(), statusCount.get(table.getStatus()) + 1);
				CacheUtils.put("roomsInfo_" + table.getId(), diaInfo);
			} catch (Exception e) {
				e.printStackTrace();
				DiagramInfo diaInfo = new DiagramInfo();
				diaInfo.setTableId(table.getId());
				diaInfo.setTableNo(table.getNo());
				diaInfo.setFloor(table.getFloor());
				diaInfo.setBuilding(table.getBuilding());
				tableInfoList.add(diaInfo);
				CacheUtils.put("roomsInfo_" + table.getId(), diaInfo);
			}
		}

		// 楼栋map，用于获取楼栋名称
		paramMap.put("type", SysConfigTypeEnum.floor.getType());
		paramMap.put("storeId", storeId);
		List<SysBusiConfig> floor = sysBusiConfigService.getByType(paramMap);
		Map<String, String> floorNameMap = new HashMap<String, String>();
		for (SysBusiConfig cfg : floor) {
			floorNameMap.put(cfg.getParamKey(), cfg.getName());
		}
		// 台型Map
		List<CtTableType> ctTableTypes = ctTableTypeService.getListByStoreId(storeId);
		Map<String, String> tableTypeMap = new HashMap<String, String>();
		for (CtTableType cfg : ctTableTypes) {
			tableTypeMap.put(cfg.getId(), cfg.getName());
		}
		model.addAttribute("settings", settings);
		model.addAttribute("floorList", floor);
		model.addAttribute("floorNameMap", floorNameMap);
		model.addAttribute("ctTableTypes", ctTableTypes);
		model.addAttribute("tableTypeMap", tableTypeMap);
		model.addAttribute("tableInfoList", tableInfoList);
		model.addAttribute("statusCount", statusCount);
		model.addAttribute("storeId", storeId);
		return "modules/diagram/indexRight";
	}

	@RequestMapping(value = "reflashRoom")
	@ResponseBody
	public DiagramInfo reflashRoom(String tableId, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		// 查询房态图设置
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("type", SysConfigTypeEnum.diagramSetting.getType());
		List<SysBusiConfig> configList = sysBusiConfigService.getByType(paramMap);
		Map<String, String> settings = new HashMap<String, String>();
		for (SysBusiConfig sys : configList) {
			settings.put(sys.getParamKey(), sys.getParamValue());
		}
		// 查询房态图信息
		CtTable table = ctTableService.get(tableId);
		DiagramInfo diaInfo = null;
		if (table != null && CacheUtils.get("roomsInfo_" + table.getId()) != null) {
			diaInfo = (DiagramInfo) CacheUtils.get("roomsInfo_" + table.getId());
			if (diaInfo != null) {
				String oldTableStatus = diaInfo.getTableStatus();
				diaInfo = new DiagramInfo();
				diaInfo.setTableOldStatus(oldTableStatus);
			} else {
				diaInfo = new DiagramInfo();
			}
			diaInfo.setFloor(table.getFloor());
			diaInfo.setBuilding(table.getBuilding());
			diaInfo.setTableId(table.getId());
			diaInfo.setTableNo(table.getNo());
			diaInfo.setTableName(table.getName());
			diaInfo.setTableTypeId(table.getTypeId());
			diaInfo.setTableStatus(table.getStatus());
			diaInfo.setColor(settings.get(table.getStatus()));
			diaInfo.setOrderId(table.getOrderId());
			CacheUtils.put("roomsInfo_" + table.getId(), diaInfo);
		}
		return diaInfo;
	}

	@RequestMapping(value = "validateRoomStatus")
	@ResponseBody
	public boolean validateRoomStatus(HttpServletRequest request, HttpServletResponse response, Model model) {
		boolean flag = false;
		try {
			String tableId = request.getParameter("tableId");
			String tableStatus = request.getParameter("tableStatus");
			CtTable ctTable = ctTableService.get(tableId);
			if (!ctTable.getStatus().equals(tableStatus)) {
				flag = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return flag;
	}

	/**
	 * 手工夜审
	 */
	@RequestMapping("excuteNight")
	@ResponseBody
	public String excuteNight(HttpServletRequest request, HttpServletResponse response) {
		try {
			// nightReportTest.insertNightReportNotify();

			// List<String> list=nightReportTest.getNotifyTmp();
			// for(String storeId:list)
			// nightReportTest.doNotify(storeId, "2019-03-03", "10000000001");
		} catch (Exception e) {
			e.printStackTrace();
			return e.getMessage();
		}
		return "夜审成功！";
	}

}