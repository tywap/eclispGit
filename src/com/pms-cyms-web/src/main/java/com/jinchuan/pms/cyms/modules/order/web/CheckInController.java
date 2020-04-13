package com.jinchuan.pms.cyms.modules.order.web;

import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.time.DateFormatUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.JavaType;
import com.jinchuan.pms.cyms.modules.marcebter.entity.CtFoodSpecial;
import com.jinchuan.pms.cyms.modules.marcebter.service.CtFoodSpecialService;
import com.jinchuan.pms.cyms.modules.order.entity.OrdTable;
import com.jinchuan.pms.cyms.modules.order.entity.OrdTableConsumeItem;
import com.jinchuan.pms.cyms.modules.order.enums.OrdStatusEnum;
import com.jinchuan.pms.cyms.modules.order.enums.OrdTableConsumeItemEnum;
import com.jinchuan.pms.cyms.modules.order.enums.TitleEnum;
import com.jinchuan.pms.cyms.modules.order.service.CheckInService;
import com.jinchuan.pms.cyms.modules.order.service.OrdTableConsumeItemService;
import com.jinchuan.pms.cyms.modules.order.service.OrdTableService;
import com.jinchuan.pms.cyms.modules.reserve.entity.OrdUnionReserve;
import com.jinchuan.pms.cyms.modules.reserve.service.ReserveService;
import com.jinchuan.pms.cyms.modules.setting.entity.CtFood;
import com.jinchuan.pms.cyms.modules.setting.entity.CtFoodCfg;
import com.jinchuan.pms.cyms.modules.setting.entity.CtTable;
import com.jinchuan.pms.cyms.modules.setting.enums.TableStatusEnum;
import com.jinchuan.pms.cyms.modules.setting.service.CtFoodCfgService;
import com.jinchuan.pms.cyms.modules.setting.service.CtFoodService;
import com.jinchuan.pms.cyms.modules.setting.service.CtTableService;
import com.jinchuan.pms.cyms.modules.setting.service.SourceChannelService;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.exception.BusinessException;
import com.jinchuan.pms.pub.common.mapper.JsonMapper;
import com.jinchuan.pms.pub.common.utils.DateUtils;
import com.jinchuan.pms.pub.common.utils.ObjectUtils;
import com.jinchuan.pms.pub.common.utils.money.Money;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.entity.SysBusiConfig;
import com.jinchuan.pms.pub.modules.sys.enums.SysConfigTypeEnum;
import com.jinchuan.pms.pub.modules.sys.service.SysBusiConfigService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

@Controller
@RequestMapping("${adminPath}/order/checkIn")
public class CheckInController extends BaseController {
	@Autowired
	private SourceChannelService sourceChannelService;
	@Autowired
	private CheckInService checkInService;
	@Autowired
	private OrdTableService ordTableService;
	@Autowired
	private CtFoodService ctFoodService;
	@Autowired
	private OrdTableConsumeItemService ordTableConsumeItemService;
	@Autowired
	private SysBusiConfigService sysBusiConfigService;
	@Autowired
	private CtTableService ctTableService;
	@Autowired
	private CtFoodCfgService ctFoodCfgService;
	@Autowired
	CtFoodSpecialService ctFoodSpecialService;
	@Autowired
	ReserveService reserveService;

	/**
	 * @Title: checkInInit  
	 * @Description: 开台初始化
	 * @param request
	 * @param response
	 * @param model
	 * @return String 
	 * @throws
	 */
	@RequestMapping("checkInInit")
	public String checkInInit(HttpServletRequest request, HttpServletResponse response, Model model) {
		String rentId = UserUtils.getUser().getRentId();
		String storeId = request.getParameter("storeId");
		String tableId = request.getParameter("tableId");
		String reserveId = request.getParameter("reserveId");// 预订单号
		String tableType = request.getParameter("tableType");// 预订转开台台号类型
		String id = request.getParameter("id");
		Map<String, String> paramMap = new HashMap<String, String>();
		OrdUnionReserve ordUnionReserve = new OrdUnionReserve();
		paramMap.put("type", SysConfigTypeEnum.source.getType());
		paramMap.put("typeParam", "check_visiable='1'");
		paramMap.put("rentId", rentId);
		paramMap.put("storeId", storeId);
		List<SysBusiConfig> sourceList = sourceChannelService.getSource(paramMap); // 客源
		if (reserveId != null && !"".equals(reserveId)) {
			ordUnionReserve = reserveService.selectById(reserveId, storeId);
			String useNumber = reserveService.getuseNumber(reserveId, storeId, tableType);
			ordUnionReserve.setUseNumber(Double.valueOf(useNumber).intValue());
		}
		model.addAttribute("storeId", storeId);
		model.addAttribute("tableId", tableId);
		model.addAttribute("sourceList", sourceList);
		model.addAttribute("ordUnionReserve", ordUnionReserve);
		model.addAttribute("id", id);
		model.addAttribute("tableType", tableType);
		model.addAttribute("status", TableStatusEnum.cleanEmpty.getCode());
		return "modules/order/checkIn";
	}

	/**
	 * @Title: checkInCommit  
	 * @Description: 开台提交
	 * @param request
	 * @param response
	 * @param model
	 * @return ProcessResult 
	 * @throws
	 */
	@RequestMapping("checkInCommit")
	@ResponseBody
	public ProcessResult checkInCommit(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String params = request.getParameter("params");
			Map<String, String> map = (Map<String, String>) JsonMapper.fromJsonString(params, Map.class);
			Map<String, String> ret1 = checkInService.checkInCommit(map, "开台");
			Map<String, Object> ret = new HashMap<String, Object>();
			ret.put("tableId", map.get("tableId"));
			ret.put("tableNo", ret1.get("tableNo"));
			ret.put("orderId", ret1.get("orderId"));
			result = new ProcessResult("000000", "操作成功", ret);
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

	/**
	 * @Title: ordTableInit  
	 * @Description: 订单初始化初始化
	 * @param request
	 * @param response
	 * @param model
	 * @return String 
	 * @throws
	 */
	@RequestMapping("ordTableIndexInit")
	public String ordTableInit(HttpServletRequest request, HttpServletResponse response, Model model) {
		/*String rentId = UserUtils.getUser().getRentId();*/
		String storeId = request.getParameter("storeId");
		String tableId = request.getParameter("tableId");
		String tableNo = request.getParameter("tableNo");
		String orderId = request.getParameter("orderId");
		OrdTable ordTable = ordTableService.get(orderId);
		
		/*Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("type", SysConfigTypeEnum.source.getType());
		paramMap.put("typeParam", "check_visiable='1'");
		paramMap.put("rentId", rentId);
		paramMap.put("storeId", storeId);
		List<SysBusiConfig> sourceList = sourceChannelService.getSource(paramMap); // 客源
		*/
		if ("".equals(orderId) || orderId == null) {
			throw new BusinessException("无该台号订单信息：" + ordTable.getTableNo());
		}
		if (OrdStatusEnum.checkIn.getCode().equals(ordTable.getStatus())) {
			model.addAttribute("chuancaiBtn", "");
			model.addAttribute("jiqiBtn", "");
			model.addAttribute("jiajiBtn", "");
			model.addAttribute("jiaoqiBtn", "");
			model.addAttribute("tuidanBtn", "");
			model.addAttribute("cuicaiBtn", "");
			model.addAttribute("zuofaBtn", "");
			model.addAttribute("zhekouBtn", "");
			model.addAttribute("zengsongBtn", "");
			model.addAttribute("zhuantaiBtn", "");
			model.addAttribute("bingtaiBtn", "");
			model.addAttribute("ordDeposit", "");
			model.addAttribute("checkOutPartBtn", "");
			model.addAttribute("checkOutPXBtn", "");
			model.addAttribute("checkOutBtn", "");
			model.addAttribute("printBtn", "");
			model.addAttribute("ordDepositBtn", "");
		} else if (OrdStatusEnum.px.getCode().equals(ordTable.getStatus())) {
			model.addAttribute("chuancaiBtn", "disabled");
			model.addAttribute("jiqiBtn", "disabled");
			model.addAttribute("jiajiBtn", "disabled");
			model.addAttribute("jiaoqiBtn", "disabled");
			model.addAttribute("tuidanBtn", "disabled");
			model.addAttribute("cuicaiBtn", "disabled");
			model.addAttribute("zuofaBtn", "disabled");
			model.addAttribute("zhekouBtn", "disabled");
			model.addAttribute("zengsongBtn", "disabled");
			model.addAttribute("zhuantaiBtn", "disabled");
			model.addAttribute("bingtaiBtn", "disabled");
			model.addAttribute("ordDeposit", "disabled");
			model.addAttribute("checkOutPartBtn", "disabled");
			model.addAttribute("checkOutPXBtn", "disabled");
			model.addAttribute("ordDepositBtn", "disabled");
			model.addAttribute("checkOutBtn", "");
			model.addAttribute("printBtn", "");
		} else if (OrdStatusEnum.checkOut.getCode().equals(ordTable.getStatus())) {
			model.addAttribute("chuancaiBtn", "disabled");
			model.addAttribute("jiqiBtn", "disabled");
			model.addAttribute("jiajiBtn", "disabled");
			model.addAttribute("jiaoqiBtn", "disabled");
			model.addAttribute("tuidanBtn", "disabled");
			model.addAttribute("cuicaiBtn", "disabled");
			model.addAttribute("zuofaBtn", "disabled");
			model.addAttribute("zhekouBtn", "disabled");
			model.addAttribute("zengsongBtn", "disabled");
			model.addAttribute("zhuantaiBtn", "disabled");
			model.addAttribute("bingtaiBtn", "disabled");
			model.addAttribute("ordDeposit", "disabled");
			model.addAttribute("checkOutPartBtn", "disabled");
			model.addAttribute("checkOutPXBtn", "disabled");
			model.addAttribute("checkOutBtn", "disabled");
			model.addAttribute("ordDepositBtn", "disabled");
			model.addAttribute("printBtn", "");
		}
		if (storeId == null && tableId == null && tableNo == null) {
			model.addAttribute("storeId", ordTable.getStoreId());
			model.addAttribute("tableId", ordTable.getTableId());
			model.addAttribute("tableNo", ordTable.getTableNo());
		} else {
			CtTable ctTable = ctTableService.get(tableId);
			model.addAttribute("storeId", storeId);
			model.addAttribute("tableId", tableId);
			model.addAttribute("tableNo", ctTable.getNo() + "-" + ctTable.getName());
		}
		model.addAttribute("useTable", ordTable.getUseNum());
		model.addAttribute("orderId", orderId);
		return "modules/order/ordIndex";
	}

	/**
	 * @Title: addFood  
	 * @Description: 点菜初始化
	 * @param request
	 * @param response
	 * @param model
	 * @return String 
	 * @throws
	 */
	@RequestMapping("addFood")
	public String addFood(HttpServletRequest request, HttpServletResponse response, Model model) {
		String storeId = request.getParameter("storeId");
		String orderId = request.getParameter("orderId");
		String foodId = request.getParameter("foodId");
		model.addAttribute("storeId", storeId);
		model.addAttribute("orderId", orderId);
		model.addAttribute("foodId", foodId);
		List<CtFoodCfg> foodCfgList = new ArrayList<>();// 关联类别
		CtFoodCfg foodCfg = new CtFoodCfg();
		String[] foodIds = foodId.split(",");
		if (foodIds.length > 1) {
			List<String> foodName = new ArrayList<>();
			List<String> foodCode = new ArrayList<>();
			List<String> foodPrice = new ArrayList<>();
			for (int i = 0; i < foodIds.length; i++) {
				OrdTableConsumeItem list = ordTableConsumeItemService.get(foodIds[i]);
				CtFood ctFood = ctFoodService.get(list.getFeeId());
				foodName.add(ctFood.getName());
				foodCode.add(ctFood.getCode());
				foodPrice.add(ctFood.getPrice().getAmount().toString());
			}
			model.addAttribute("foodName", foodName);
			model.addAttribute("foodCode", foodCode);
			model.addAttribute("foodPrice", foodPrice);
			return "modules/order/ordFoodModus";
		} else {
			foodCfg.setFoodId(foodId);
			foodCfgList = ctFoodCfgService.findList(foodCfg);
			CtFood ctFood = ctFoodService.get(foodId);
			model.addAttribute("ctFood", ctFood);
		}
		model.addAttribute("foodCfgList", foodCfgList);
		return "modules/order/addFood";
	}

	/**
	 * @Title: addFoodCommit  
	 * @Description: 点菜提交
	 * @param request
	 * @param response
	 * @param model
	 * @return ProcessResult 
	 * @throws
	 */
	@RequestMapping("addFoodCommit")
	@ResponseBody
	public ProcessResult addFoodCommit(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String storeId = request.getParameter("storeId");
			String orderId = request.getParameter("orderId");
			String foodId = request.getParameter("foodId");
			String cookValues = request.getParameter("cookValues");
			String cookValuesTemp = request.getParameter("cookValuesTemp");
			String status = request.getParameter("status");// 1为特价菜
			if (status == null) {
				status = "0";
			}
			String specialId = request.getParameter("specialId");
			OrdTable ordTable = ordTableService.get(orderId);
			if (ordTable == null) {
				throw new BusinessException("订单不存在orderId=" + orderId);
			}
			if (!ordTable.getStatus().equals(OrdStatusEnum.checkIn.getCode())) {
				throw new BusinessException("该订单不允许再操作台号：" + ordTable.getTableNo());
			}
			Integer count = 1;
			Money price = new Money();
			Money costRate = new Money("100");
			if (status.equals("1")) {
				CtFoodSpecial ctFoodSpecial = new CtFoodSpecial();
				ctFoodSpecial.setId(specialId);
				ctFoodSpecial = ctFoodSpecialService.get(ctFoodSpecial);
				if (ctFoodSpecial == null) {
					throw new BusinessException("菜品不存在foodId=" + foodId);
				}
				price = new Money(ctFoodSpecial.getPrice());
			} else {
				CtFood ctFood = ctFoodService.get(foodId);
				if (ctFood == null) {
					throw new BusinessException("菜品不存在foodId=" + foodId);
				}
				price = new Money(ctFood.getPrice());
			}
			// 保存消费明细
			OrdTableConsumeItem ordTableConsumeItem = new OrdTableConsumeItem();
			ordTableConsumeItem.setStoreId(storeId);
			ordTableConsumeItem.setShiftId(UserUtils.getShiftByStroreId(storeId).getId());
			ordTableConsumeItem.setOrderId(orderId);
			ordTableConsumeItem.setChannel(ordTable.getChannel());
			ordTableConsumeItem.setSource(ordTable.getSource());
			ordTableConsumeItem.setSourceSubdivide(ordTable.getSourceSubdivide());
			ordTableConsumeItem.setUseType(ordTable.getUseType());
			ordTableConsumeItem.setTableId(ordTable.getTableId());
			ordTableConsumeItem.setTableNo(ordTable.getTableNo());
			ordTableConsumeItem.setFeeId(foodId);
			ordTableConsumeItem.setCount(count);
			ordTableConsumeItem.setPrice(price);
			ordTableConsumeItem.setRate(costRate);
			ordTableConsumeItem.setTitleEnum(TitleEnum.RESTAURANT_FEE.getCode());
			ordTableConsumeItem.setCookValues(cookValues);
			ordTableConsumeItem.setCookValuesTemp(cookValuesTemp);
			ordTableConsumeItem.setStatus("0");
			ordTableConsumeItem.setAuditStatus("1");
			ordTableConsumeItem.setCreateAccountDate(UserUtils.getAccountDate(storeId));
			ordTableConsumeItemService.save(ordTableConsumeItem);

			Map<String, Object> ret = new HashMap<String, Object>();
			result = new ProcessResult("000000", "操作成功", ret);
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

	/**
	 * 菜品状态
	 * @Title: foodStatus  
	 * @throws
	 */
	@RequestMapping("foodStatus")
	public String foodStatus(HttpServletRequest request, HttpServletResponse response, Model model) {
		String type = request.getParameter("type");
		String[] foodId = request.getParameter("foodId").split(",");
		String foodName = request.getParameter("foodName");
		try {
			foodName = URLDecoder.decode(foodName, "UTF-8");
			String status = "";
			model.addAttribute("type", type);
			model.addAttribute("foodName", foodName);
			model.addAttribute("foodId", request.getParameter("foodId"));
			model.addAttribute("foodSize", foodId.length);
			if (type.equals("5")) {
				return "modules/order/ordChargeback";
			}
			if (type.equals("6")) {
				String subtotal = request.getParameter("subtotal");
				model.addAttribute("subtotalAmount", subtotal);
				return "modules/order/ordDiscount";
			}
			if (type.equals("7")) {
				String subtotal = request.getParameter("subtotal");
				model.addAttribute("subtotalAmount", subtotal);
				return "modules/order/ordPresented";
			}
			if (type.equals("8")) {
				OrdTableConsumeItem ordTable = ordTableConsumeItemService.get(request.getParameter("foodId"));
				model.addAttribute("ordTable", ordTable);
				return "modules/order/ordFoodForm";
			}
			model.addAttribute("status", status);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "modules/order/ordStatus";
	}

	/**
	 * 
	 * @Title: foodStatusSub  
	 * 菜品状态提交
	 * @throws
	 */
	@RequestMapping("foodStatusSub")
	@ResponseBody
	public ProcessResult foodStatusSub(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		String type = request.getParameter("type");
		String storeId = request.getParameter("storeId");
		String orderId = request.getParameter("orderId");// 订单id
		String foods = request.getParameter("foods");
		OrdTable ordTable = ordTableService.get(orderId);
		try {
			JavaType javaType = JsonMapper.getInstance().createCollectionType(List.class, Map.class);
			List<Map<String, Object>> selectFoodList = (List<Map<String, Object>>) JsonMapper.getInstance()
					.fromJson(foods, javaType);// jsonString转list
			for (Map<String, Object> map : selectFoodList) {
				ordTableConsumeItemService.updateStatus(map, type);
			}
			Map<String, Object> printMap = new HashMap<String, Object>();
			List<SysBusiConfig> printerList = sysBusiConfigService.getByType(storeId,
					SysConfigTypeEnum.foodPrinter.getType());
			for (SysBusiConfig sysBusiConfig : printerList) {
				Map<String, Object> ipPortsPrint = new HashMap<>();
				ipPortsPrint.put("dateTime", DateUtils.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss"));
				ipPortsPrint.put("titleName", OrdTableConsumeItemEnum.getMessage1(type));
				ipPortsPrint.put("no", ordTable.getTableNo());
				ipPortsPrint.put("num", ordTable.getUseNum());
				ipPortsPrint.put("printName", sysBusiConfig.getParamKey());
				ipPortsPrint.put("remarks", ordTable.getRemarks());
				ipPortsPrint.put("foodItems", null);
				printMap.put(sysBusiConfig.getParamKey() + "," + sysBusiConfig.getName() + ":"
						+ sysBusiConfig.getParamValue(), ipPortsPrint);
			}

			for (Map<String, Object> ctFoodStore : selectFoodList) {
				if (ctFoodStore.get("printer") != null && !"".equals(ctFoodStore.get("printer"))) {
					String[] printerIds = ObjectUtils.toString(ctFoodStore.get("printer")).split(",");
					for (String string : printerIds) {
						SysBusiConfig printer = sysBusiConfigService.get(string);
						String ipPorts = printer.getParamKey() + "," + printer.getName() + ":"
								+ printer.getParamValue();
						Map<String, Object> ipPortsPrint = new HashMap<String, Object>();
						if (printMap.get(ipPorts) != null && !printMap.get(ipPorts).equals("")) {
							ipPortsPrint = (Map<String, Object>) printMap.get(ipPorts);
						}
						List<Map<String, Object>> foodItems = new ArrayList<Map<String, Object>>();
						if (ipPortsPrint.get("foodItems") != null && !ipPortsPrint.get("foodItems").equals("")) {
							foodItems = (List<Map<String, Object>>) ipPortsPrint.get("foodItems");
						}
						Map<String, Object> foodMap = new HashMap<>();
						foodMap.put("foodName", ctFoodStore.get("foodName"));
						foodMap.put("num", ctFoodStore.get("num"));
						foodMap.put("remarks", ctFoodStore.get("modus"));
						foodItems.add(foodMap);
						ipPortsPrint.put("foodItems", foodItems);
					}
				}
			}
			result = new ProcessResult("000000", "操作成功", printMap);
		} catch (Exception e) {
			e.printStackTrace();
			ordTableConsumeItemService.printerLog(e, ordTable);
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

	/**
	 * @Title: ordFoodModus  
	 *  菜品做法
	 * @throws
	 */
	@RequestMapping("ordFoodModus")
	public String ordFoodModus(HttpServletRequest request, HttpServletResponse response, Model model) {
		String storeId = request.getParameter("storeId");
		String orderId = request.getParameter("orderId");
		String foodId = request.getParameter("foodId");
		String type = request.getParameter("type");
		if (foodId == null) {
			throw new BusinessException("请选择菜品");
		}
		model.addAttribute("storeId", storeId);
		model.addAttribute("orderId", orderId);
		model.addAttribute("foodId", foodId);
		List<CtFoodCfg> foodCfgList = new ArrayList<>();// 关联类别
		String[] foodIds = foodId.split(",");
		CtFood ctFood = new CtFood();
		if (type.equals("1")) {
			if (foodIds.length == 1) {
				OrdTableConsumeItem list = ordTableConsumeItemService.get(foodId);
				if (list.getCookValues() != null && !list.getCookValues().equals("")) {
					String[] modusId = list.getCookValues().split(",");
					for (int i = 0; i < modusId.length; i++) {
						CtFoodCfg foodCfg = new CtFoodCfg();
						foodCfg.setValue(modusId[i]);
						foodCfgList.add(foodCfg);
					}
				}
				model.addAttribute("cookValuesTemp", list.getCookValuesTemp());
				ctFood = ctFoodService.get(list.getFeeId());
				model.addAttribute("ctFood", ctFood);
			}
			model.addAttribute("ctFood", ctFood);
			model.addAttribute("foodCfgList", foodCfgList);
			return "modules/order/ordFoodModus";
		} else {
			OrdTableConsumeItem list = ordTableConsumeItemService.get(foodId);
			CtFoodCfg foodCfg = new CtFoodCfg();
			foodCfg.setFoodId(list.getFeeId());
			foodCfgList = ctFoodCfgService.findList(foodCfg);
			ctFood = ctFoodService.get(list.getFeeId());
			model.addAttribute("ctFood", ctFood);
		}
		model.addAttribute("foodCfgList", foodCfgList);
		return "modules/order/addFood";
	}

	/**
	 * @Title: saveFoodModus  
	 *  保存菜品做法
	 * @throws
	 */
	@RequestMapping("saveFoodModus")
	@ResponseBody
	public ProcessResult saveFoodModus(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String[] foodId = request.getParameter("foodId").split(",");
			String cookValues = request.getParameter("cookValues");// 系统做法
			String cookValuesTemp = request.getParameter("cookValuesTemp");// 用户自定义做法
			for (int i = 0; i < foodId.length; i++) {
				OrdTableConsumeItem ordTable = ordTableConsumeItemService.get(foodId[i]);
				ordTable.setCookValues(cookValues);
				ordTable.setCookValuesTemp(cookValuesTemp);
				ordTableConsumeItemService.savaFoodModus(ordTable);
			}
			result = new ProcessResult("000000", "操作成功");
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

	/**
	 * 
	 * @Title: changeTable  
	 * 转台
	 * @throws
	 */
	@RequestMapping("changeTable")
	public String changeTable(HttpServletRequest request, HttpServletResponse response, Model model) {
		String tableNo = request.getParameter("tableNo");// 台号
		String storeId = request.getParameter("storeId");
		String xiaofei = request.getParameter("consume");// 消费
		double consume = Math.abs(Double.valueOf(xiaofei));
		String proceeds = request.getParameter("proceeds");// 收款
		String orderId = request.getParameter("orderId");// 订单id
		model.addAttribute("tableNo", tableNo);
		model.addAttribute("consume", consume);
		model.addAttribute("proceeds", proceeds);
		model.addAttribute("orderId", orderId);
		model.addAttribute("storeId", storeId);
		return "modules/order/changeTable";
	}

	/**
	 * 
	 * @Title: combineTable  
	 * 并台
	 * @throws
	 */
	@RequestMapping("combineTable")
	public String combineTable(HttpServletRequest request, HttpServletResponse response, Model model) {
		String tableNo = request.getParameter("tableNo");// 台号
		String storeId = request.getParameter("storeId");
		String xiaofei = request.getParameter("consume");// 消费
		double consume = Math.abs(Double.valueOf(xiaofei));
		String proceeds = request.getParameter("proceeds");// 收款
		String orderId = request.getParameter("orderId");// 订单id
		model.addAttribute("storeId", storeId);
		model.addAttribute("tableNo", tableNo);
		model.addAttribute("consume", consume);
		model.addAttribute("proceeds", proceeds);
		model.addAttribute("orderId", orderId);
		return "modules/order/combineTable";
	}

	/**
	 * 
	 * @Title: selectTable  
	 * 选择台号
	 * @throws
	 */
	@RequestMapping("selectTable")
	public String selectTable(CtTable ctTable, HttpServletRequest request, HttpServletResponse response, Model model) {
		String rentId = UserUtils.getUser().getRentId();
		SysBusiConfig sysBusiConfig = new SysBusiConfig();
		sysBusiConfig.setRentId(rentId);
		sysBusiConfig.setStoreId(ctTable.getStoreId());
		sysBusiConfig.setType(SysConfigTypeEnum.floor.getType());
		model.addAttribute("type", ctTable.getTypeId());
		model.addAttribute("storeId", ctTable.getStoreId());
		try {
			List<SysBusiConfig> foorlList = sysBusiConfigService.findStoreByWX(sysBusiConfig);
			ctTable.setRentId(rentId);
			if (ctTable.getTypeId().equals("0")) {
				ctTable.setStatus(TableStatusEnum.cleanEmpty.getCode());
			} else {
				ctTable.setStatus(OrdStatusEnum.checkIn.getCode());
			}
			List<CtTable> ctTableList = ctTableService.findAllTable(ctTable);
			model.addAttribute("foorlList", foorlList);
			model.addAttribute("ctTableList", ctTableList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "modules/order/ordSelectTable";
	}

	/**
	 * 
	 * @Title: saveChangeTable  
	 * 转台提交
	 * @throws
	 */
	@RequestMapping("saveChangeTable")
	@ResponseBody
	public ProcessResult saveChangeTable(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		String tableId = request.getParameter("tableId");// 新台号Id
		String tableName = request.getParameter("tableName");// 新台号名称
		String orderId = request.getParameter("orderId");// 订单Id
		String remarks = request.getParameter("remarks");
		try {
			OrdTable ordTable = ordTableService.get(orderId);
			// 原台号Id
			String yTableId = ordTable.getTableId();
			if (yTableId.equals(tableId)) {
				throw new BusinessException("请勿选择同一台号:" + tableName);
			}
			CtTable ctTable = ctTableService.get(tableId);
			if (!ctTable.getStatus().equals(TableStatusEnum.cleanEmpty.getCode())) {
				throw new BusinessException("台号:" + tableName + "已被占用请重新选择！");
			}
			ordTableService.saveChangeTable(ordTable, tableId, tableName, orderId, remarks, yTableId);
			result = new ProcessResult("000000", "操作成功");
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

	/**
	 * 
	 * @Title: saveCombineTable
	 * 并台提交
	 * @throws
	 */
	@RequestMapping("saveCombineTable")
	@ResponseBody
	public ProcessResult saveCombineTable(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		String xorderId = request.getParameter("xorderId");// 新台号订单Id
		String orderId = request.getParameter("orderId");// 原台号订单Id
		String xTableId = request.getParameter("xtableId");// 新台号Id
		String remarks = request.getParameter("remarks");
		try {
			OrdTable ordTable = ordTableService.get(orderId);
			String yTableId = ordTable.getTableId();// 原台号Id
			if (orderId.equals(xorderId)) {
				result = new ProcessResult("111111", "请勿选择同一台号！");
				return result;
			}
			ordTableService.saveCombineTable(ordTable, xorderId, orderId, remarks, yTableId, xTableId);
			result = new ProcessResult("000000", "操作成功");
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

	/**
	 * 
	 * @Title: ordChargeback  
	 * 菜品退单
	 * @throws
	 */
	@RequestMapping("ordChargeback")
	@ResponseBody
	public ProcessResult ordChargeback(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String[] foodId = request.getParameter("foodId").split(",");
			String[] foodName = request.getParameter("foodName").split(",");
			String remarks = request.getParameter("remarks");
			String cause = request.getParameter("cause");
			for (int i = 0; i < foodId.length; i++) {
				String id = foodId[i];
				String name = foodName[i];
				OrdTableConsumeItem ordTable = ordTableConsumeItemService.get(id);
				ordTableConsumeItemService.saveOrdChargeback(ordTable, name, remarks, cause);
			}
			result = new ProcessResult("000000", "操作成功");
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

	/**
	 * 
	 * @Title: ordDiscount
	 * 菜品打折
	 * @throws
	 */
	@RequestMapping("ordDiscount")
	@ResponseBody
	public ProcessResult ordDiscount(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String[] foodId = request.getParameter("foodId").split(",");
			String[] foodName = request.getParameter("foodName").split(",");
			String rate = request.getParameter("rate");// 折扣率
			String remarks = request.getParameter("remarks");
			String cause = request.getParameter("cause");
			for (int i = 0; i < foodId.length; i++) {
				String id = foodId[i];
				String name = foodName[i];
				OrdTableConsumeItem ordTable = ordTableConsumeItemService.get(id);
				ordTable.setRate(new Money(rate));
				ordTable.setRemarks(remarks);
				ordTableConsumeItemService.updateDiscount(ordTable, name, cause);
			}
			result = new ProcessResult("000000", "操作成功");
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

	/**
	 * 
	 * @Title: 
	 * 菜品赠送
	 * @throws
	 */
	@RequestMapping("ordPresent")
	@ResponseBody
	public ProcessResult ordPresent(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String[] foodId = request.getParameter("foodId").split(",");
			String[] foodName = request.getParameter("foodName").split(",");
			String remarks = request.getParameter("remarks");
			String cause = request.getParameter("cause");
			// JavaType javaType =
			// JsonMapper.getInstance().createCollectionType(List.class,
			// Map.class);
			// List<Map<String, Object>> selectFoodList = (List<Map<String,
			// Object>>) JsonMapper.getInstance()
			// .fromJson(foods, javaType);// jsonString转list
			for (int i = 0; i < foodId.length; i++) {
				String id = foodId[i];
				String name = foodName[i];
				OrdTableConsumeItem ordTable = ordTableConsumeItemService.get(id);
				ordTable.setPrice(new Money("0"));
				ordTable.setRemarks(remarks + "【赠送】");
				ordTableConsumeItemService.updatePresent(ordTable, name, cause);
			}
			result = new ProcessResult("000000", "操作成功");
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

	/**
	 * @Title: getSpecialFood  
	 *  获取特价菜品
	 * @throws
	 */
	@RequestMapping("getSpecialFood")
	@ResponseBody
	public ProcessResult getSpecialFood(CtFoodSpecial ctFoodSpecial, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			ctFoodSpecial.setEffectiveDate(DateUtils.formatDateTime(new Date()));
			String formatDate = DateFormatUtils.format(new Date(), "yyyy-MM-dd");
			ctFoodSpecial.setAndValue(String.valueOf(DateUtils.getWeekByDate(formatDate)));// 获取当前星期
			List<CtFoodSpecial> list = ctFoodSpecialService.queryctfood(ctFoodSpecial);
			result = new ProcessResult("000000", "操作成功", list);
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

	/**
	 * 菜品信息
	 * @Title: updateFoodForm  
	 * @throws
	 */
	@RequestMapping("updateFoodForm")
	public String updateFoodForm(HttpServletRequest request, HttpServletResponse response, Model model) {
		String ordId = request.getParameter("ordId");// 订单id
		try {
			OrdTableConsumeItem ordTable = ordTableConsumeItemService.getOrdFood(ordId);
			model.addAttribute("ordTable", ordTable);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "modules/order/ordFoodForm";
	}

	/**
	 * @Title: updateFood  
	 *  菜品编辑
	 * @throws
	 */
	@RequestMapping("updateFood")
	@ResponseBody
	public ProcessResult updateFood(OrdTableConsumeItem ordTableConsumeItem, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			OrdTableConsumeItem ordTableConsumeItem1 = ordTableConsumeItemService.get(ordTableConsumeItem.getId());
			ordTableConsumeItem1.setPrice(ordTableConsumeItem.getPrice());
			ordTableConsumeItem1.setCount(ordTableConsumeItem.getCount());
			ordTableConsumeItem1.setRemarks(ordTableConsumeItem.getRemarks());
			ordTableConsumeItem1.setFoodName(ordTableConsumeItem.getFoodName());
			ordTableConsumeItemService.updateFood(ordTableConsumeItem1);
			result = new ProcessResult("000000", "操作成功");
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}
}
