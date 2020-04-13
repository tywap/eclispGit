package com.jinchuan.pms.cyms.modules.accounting.web;

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

import com.jinchuan.pms.cyms.modules.accounting.enums.OrdTableEnum;
import com.jinchuan.pms.cyms.modules.order.entity.OrdTable;
import com.jinchuan.pms.cyms.modules.order.enums.OrdStatusEnum;
import com.jinchuan.pms.cyms.modules.order.service.OrdRoomListService;
import com.jinchuan.pms.cyms.modules.order.service.OrdTableService;
import com.jinchuan.pms.cyms.modules.setting.entity.CtTableType;
import com.jinchuan.pms.cyms.modules.setting.entity.HtlStore;
import com.jinchuan.pms.cyms.modules.setting.service.CtTableTypeService;
import com.jinchuan.pms.cyms.modules.setting.service.HtlStoreService;
import com.jinchuan.pms.cyms.modules.setting.service.SourceChannelService;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.entity.SysBusiConfig;
import com.jinchuan.pms.pub.modules.sys.entity.User;
import com.jinchuan.pms.pub.modules.sys.enums.SysConfigTypeEnum;
import com.jinchuan.pms.pub.modules.sys.service.SystemService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 当日账单
 *@author LiLingJie
 *@Description
 *@Date 2019年10月23日 下午4:36:46
 */
@Controller
@RequestMapping(value = "${adminPath}/accounting/dayOrder")
public class DayOrderController extends BaseController {
	@Autowired
	private OrdTableService ordTableService;
	@Autowired
	private CtTableTypeService ctTableTypeService;
	@Autowired
	private SourceChannelService sourceChannelService;
	@Autowired
	private HtlStoreService htlStoreService;
	@Autowired
	private SystemService systemService;
	@Autowired
	private OrdRoomListService ordRoomListService;

	/**
	 * 
	 * @Title: list  
	 * 当日账单列表
	 * @throws
	 */
	@RequestMapping(value = "list")
	public String list(OrdTable ordTable, HttpServletRequest request, HttpServletResponse response, Model model) {
		String storeId = ordTable.getStoreId();
		String rentId = UserUtils.getUser().getRentId();
		HtlStore store = new HtlStore();
		List<OrdTable> ordList = new ArrayList<OrdTable>();
		try {
			if (storeId == null) {
				String storeType = UserUtils.getStore().getType();
				if ("3".equals(storeType) || "4".equals(storeType) || "5".equals(storeType)) {
					storeId = UserUtils.getStoreId();
				}
			}
			ordTable.setStoreId(storeId);
			store = htlStoreService.get(storeId);
			String date = "";//账务日期
			if (storeId == null || storeId.equals("")) {
				date = UserUtils.getAccountDate(rentId);
				return "modules/account/dayAccounting/dayOrder";
			} else {
				date = UserUtils.getAccountDate(storeId);
			}
			ordTable.setCreateAccountDate(date);

			ordList = ordTableService.ordTableList(ordTable);
			for (OrdTable ordTable2 : ordList) {
				ordTable2.setStatus(OrdStatusEnum.getByCode(ordTable2.getStatus()).getMessage());
				ordTable2.setUseType(OrdTableEnum.getByCode(ordTable2.getUseType()).getMessage());
			}
			User user = new User();
			user.setRentId(UserUtils.getUser().getRentId());
			user.setIsSalesman("1");
			List<User> users = systemService.findSalesmanList(user);
			Map<String, String> paramMap = new HashMap<String, String>();
			paramMap.put("type", SysConfigTypeEnum.source.getType());
			paramMap.put("typeParam", "check_visiable='1'");
			paramMap.put("rentId", rentId);
			paramMap.put("storeId", storeId);
			List<SysBusiConfig> sourceList = sourceChannelService.getSource(paramMap); // 客源
			List<CtTableType> ctTableTypeList = ctTableTypeService.getListByStoreId(storeId);
			model.addAttribute("sourceList", sourceList);
			model.addAttribute("ctTableTypeList", ctTableTypeList);
			model.addAttribute("ordList", ordList);
			model.addAttribute("salesmanList", users);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("selectStoreId", storeId);
		model.addAttribute("storeName", store.getStoreName());
		return "modules/account/dayAccounting/dayOrder";
	}

	/**
	 * 房单恢复
	 * @param id
	 * @param type
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "recover")
	@ResponseBody
	public Map<String, String> recover(String id, String type, HttpServletRequest request,
			HttpServletResponse response) {
		Map<String, String> reMap = new HashMap<String, String>();
		reMap.put("flag", "0");
		try {
			Map<String, String> validateMap = new HashMap<String, String>();
			validateMap.put("id", id);
			validateMap.put("type", type);
			validateMap.put("operatType", "checkOut");
			ordRoomListService.validate(validateMap);
			ordRoomListService.recover(id, type);
			reMap.put("flag", "1");
			reMap.put("msg", "恢复成功！");
		} catch (Exception e) {
			reMap.put("msg", e.getMessage());
			e.printStackTrace();
			return reMap;
		}
		return reMap;
	}

	/**
	 * px房单恢复
	 * @param id
	 * @param type
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "recoverCheckIn")
	@ResponseBody
	public Map<String, Object> recoverCheckIn(String id, String type, HttpServletRequest request,
			HttpServletResponse response) {
		Map<String, Object> reMap = new HashMap<String, Object>();
		reMap.put("flag", "0");
		try {
			Map<String, String> validateMap = new HashMap<String, String>();
			validateMap.put("id", id);
			validateMap.put("type", type);
			validateMap.put("operatType", "px");
			ordRoomListService.validate(validateMap);
			ordRoomListService.pxRecover(id, type);
			reMap.put("flag", "1");
			reMap.put("msg", "恢复成功！");
		} catch (Exception e) {
			reMap.put("msg", e.getMessage());
			e.printStackTrace();
			return reMap;
		}
		return reMap;
	}

}
