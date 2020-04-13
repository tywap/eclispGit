/**
 * 
 */
package com.jinchuan.pms.cyms.modules.reserve.web;

import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Date;
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

import com.fasterxml.jackson.databind.JavaType;
import com.jinchuan.pms.cyms.modules.accounting.enums.OrdTableEnum;
import com.jinchuan.pms.cyms.modules.marcebter.entity.CtFoodSpecial;
import com.jinchuan.pms.cyms.modules.marcebter.service.CtFoodSpecialService;
import com.jinchuan.pms.cyms.modules.order.enums.OrdStatusEnum;
import com.jinchuan.pms.cyms.modules.order.enums.TitleEnum;
import com.jinchuan.pms.cyms.modules.report.enums.ReportEnums;
import com.jinchuan.pms.cyms.modules.reserve.dao.OrdReserveDao;
import com.jinchuan.pms.cyms.modules.reserve.entity.OrdReserve;
import com.jinchuan.pms.cyms.modules.reserve.entity.OrdReserveConsumeItem;
import com.jinchuan.pms.cyms.modules.reserve.entity.OrdUnionReserve;
import com.jinchuan.pms.cyms.modules.reserve.entity.OrdUnionReserveDetail;
import com.jinchuan.pms.cyms.modules.reserve.enums.ReservesStatusEnum;
import com.jinchuan.pms.cyms.modules.reserve.service.OrdReserveConsumeItemService;
import com.jinchuan.pms.cyms.modules.reserve.service.ReserveService;
import com.jinchuan.pms.cyms.modules.setting.entity.CtFood;
import com.jinchuan.pms.cyms.modules.setting.entity.CtFoodCfg;
import com.jinchuan.pms.cyms.modules.setting.entity.CtTable;
import com.jinchuan.pms.cyms.modules.setting.entity.CtTableType;
import com.jinchuan.pms.cyms.modules.setting.service.CtFoodCfgService;
import com.jinchuan.pms.cyms.modules.setting.service.CtFoodService;
import com.jinchuan.pms.cyms.modules.setting.service.CtTableService;
import com.jinchuan.pms.cyms.modules.setting.service.CtTableTypeService;
import com.jinchuan.pms.cyms.modules.setting.service.SourceChannelService;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.exception.BusinessException;
import com.jinchuan.pms.pub.common.mapper.JsonMapper;
import com.jinchuan.pms.pub.common.utils.DateUtils;
import com.jinchuan.pms.pub.common.utils.ObjectUtils;
import com.jinchuan.pms.pub.common.utils.SequenceUtils;
import com.jinchuan.pms.pub.common.utils.money.Money;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.entity.SysBusiConfig;
import com.jinchuan.pms.pub.modules.sys.enums.SysConfigTypeEnum;
import com.jinchuan.pms.pub.modules.sys.service.SysBusiConfigService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * @ClassName: ReserveController
 * @Description: (预定管理)
 * @author 孙文
 * @date 2019年9月20日
 * 
 */
@Controller
@RequestMapping(value = "${adminPath}/reserve")
public class ReserveController extends BaseController {

	@Autowired
	private SysBusiConfigService sysBusiConfigService;
	@Autowired
	private SourceChannelService sourceChannelService;
	@Autowired
	CtTableTypeService ctTableTypeService;
	@Autowired
	ReserveService reserveService;
	@Autowired
	CtTableService ctTableService;
	@Autowired
	OrdReserveDao ordReserveDao;
	@Autowired
	CtFoodSpecialService ctFoodSpecialService;
	@Autowired
	private CtFoodService ctFoodService;
	@Autowired
	private OrdReserveConsumeItemService ordReserveConsumeItemService;
	@Autowired
	private CtFoodCfgService ctFoodCfgService;

	@RequestMapping(value = { "toReserveListJsp", "" })
	public String toReserveListJsp(HttpServletRequest request, HttpServletResponse response, Model model,
			OrdReserve ordReserve) {
		String rentId = UserUtils.getUser().getRentId();
		String storeType = UserUtils.getStore().getType();

		if ("3".equals(storeType) || "4".equals(storeType) || "5".equals(storeType)) {
			ordReserve.setStoreId(UserUtils.getStoreId());
		}

		if (null == ordReserve.getStatus() || "".equals(ordReserve.getStatus())) {
			ordReserve.setStatus("effectiveOrd");
		}
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("type", SysConfigTypeEnum.source.getType());
		paramMap.put("typeParam", "check_visiable='1'");
		paramMap.put("rentId", rentId);
		List<SysBusiConfig> sourceList = sourceChannelService.getSource(paramMap); // 客源
		List<CtTableType> tableTypeList = ctTableTypeService.getListByStoreId(ordReserve.getStoreId());
		ordReserve.setRentId(rentId);
		List<OrdReserve> ordReserveList = reserveService.getOrdReserveList(ordReserve);
		int ordCount = 0;
		String oldOrderId = null;
		for (OrdReserve o : ordReserveList) {
			String orderId = o.getOrderId();
			if (!orderId.equals(oldOrderId)) {
				ordCount++;
				oldOrderId = orderId;
			}
			int num = reserveService.getOrderNum(orderId, ordReserveList);
			o.setOrderNum(num);
			o.setStatus(OrdStatusEnum.getByCode(o.getStatus()).getName());
		}
		model.addAttribute("sourceList", sourceList);
		model.addAttribute("ordReserveList", ordReserveList);
		model.addAttribute("ordReserve", ordReserve);
		model.addAttribute("tableTypeList", tableTypeList);
		return "modules/reserve/reserveList";

	}

	@RequestMapping("toAddReserveForm") // getListByStoreId
	public String toAddReserveForm(HttpServletRequest request, HttpServletResponse response, Model model,
			String storeId) {
		String rentId = UserUtils.getUser().getRentId();
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("type", SysConfigTypeEnum.source.getType());
		paramMap.put("typeParam", "check_visiable='1'");
		paramMap.put("rentId", rentId);
		paramMap.put("storeId", storeId);
		List<SysBusiConfig> sourceList = sourceChannelService.getSource(paramMap); // 客源

		if (!"".equals(storeId) && null != storeId) {
			List<CtTableType> ctTableTypeList = ctTableTypeService.getListByStoreId(storeId);
			model.addAttribute("ctTableTypeList", ctTableTypeList);
		}

		model.addAttribute("storeId", storeId);
		model.addAttribute("sourceList", sourceList);

		model.addAttribute("selectStoreId", storeId);

		return "modules/reserve/reserveAddForm";
	}

	@RequestMapping("toSimpleAddReserveForm") // 前台直接预定桌号
	public String toSimpleAddReserveForm(HttpServletRequest request, HttpServletResponse response, Model model,
			String storeId) {
		String rentId = UserUtils.getUser().getRentId();
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("type", SysConfigTypeEnum.source.getType());
		paramMap.put("typeParam", "check_visiable='1'");
		paramMap.put("rentId", rentId);
		paramMap.put("storeId", storeId);
		List<SysBusiConfig> sourceList = sourceChannelService.getSource(paramMap); // 客源
		model.addAttribute("useDate", DateUtils.getDate("yyyy-MM-dd"));
		model.addAttribute("storeId", storeId);
		model.addAttribute("sourceList", sourceList);

		return "modules/reserve/simpleReserveAddForm";
	}

	@RequestMapping("saveReserve")
	@ResponseBody
	public ProcessResult saveReserve(HttpServletRequest request, HttpServletResponse response) {
		ProcessResult result = new ProcessResult("999999", "操作失败");

		String params = request.getParameter("params");
		String params1 = request.getParameter("list");
		String paymentFundJson = request.getParameter("paymentFundJson");// 支付方式
		OrdUnionReserve ordUnionReserve = JsonMapper.getInstance().fromJson(params, OrdUnionReserve.class);
		JavaType javaType = JsonMapper.getInstance().createCollectionType(List.class, OrdUnionReserveDetail.class);
		List<OrdUnionReserveDetail> consumeTypes = (List<OrdUnionReserveDetail>) JsonMapper.getInstance()
				.fromJson(params1, javaType);// jsonString转list

		JavaType javaType1 = JsonMapper.getInstance().createCollectionType(List.class, Map.class);
		List<Map<String, Object>> paymentFunds = (List<Map<String, Object>>) JsonMapper.getInstance()
				.fromJson(paymentFundJson, javaType1);// jsonString转list
		String subject = TitleEnum.PRE_DEPOSIT.getMessage();
		String rentId = UserUtils.getUser().getRentId();
		String storeId = UserUtils.getStoreId();
		String transactionId = SequenceUtils.getSeq("account_sequence");
		String ip = getIpAddress(request);
		try {
			ordUnionReserve.setStatus(ReservesStatusEnum.stayOpenIn.getCode());
			reserveService.saveReserve(ordUnionReserve, consumeTypes);

			reserveService.saveDepositAmount(ip, rentId, storeId, ordUnionReserve.getId(), transactionId, subject,
					paymentFunds, ordUnionReserve);
			result.setRetCode("000000");
			result.setRetMsg("type=0&reserveId=" + ordUnionReserve.getId() + "&accountSequence=" + transactionId);
		} catch (Exception e) {

			result.setRetMsg(e.getMessage());
		}

		return result;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping("saveSimpleReserve")
	@ResponseBody
	public ProcessResult saveSimpleReserve(HttpServletRequest request, HttpServletResponse response) {
		ProcessResult result = new ProcessResult("999999", "操作失败");

		String params = request.getParameter("params");
		String tableId = request.getParameter("tableId");
		String personCount = request.getParameter("personCount");
		OrdUnionReserve ordUnionReserve = JsonMapper.getInstance().fromJson(params, OrdUnionReserve.class);
		CtTable ctTable = new CtTable();
		ctTable.setId(tableId);
		CtTable ctTable1 = ctTableService.getById(ctTable);
		OrdUnionReserveDetail ordUnionReserveDetail = new OrdUnionReserveDetail();
		ordUnionReserveDetail.setFloorId(ctTable1.getFloor());
		ordUnionReserveDetail.setTableType(ctTable1.getTypeId());
		ordUnionReserveDetail.setQuantity(1);
		ordUnionReserveDetail.setPersonCount(Integer.parseInt(personCount));
		OrdReserve ordReserve = new OrdReserve();
		ordReserve.setTableId(tableId);
		ordReserve.setTableNo(ctTable1.getNo());
		String paymentFundJson = request.getParameter("paymentFundJson");// 支付方式
		JavaType javaType1 = JsonMapper.getInstance().createCollectionType(List.class, Map.class);
		List<Map<String, Object>> paymentFunds = (List<Map<String, Object>>) JsonMapper.getInstance()
				.fromJson(paymentFundJson, javaType1);// jsonString转list
		String subject = TitleEnum.PRE_DEPOSIT.getMessage();
		String rentId = UserUtils.getUser().getRentId();
		String storeId = UserUtils.getStoreId();
		String transactionId = SequenceUtils.getSeq("account_sequence");
		String ip = getIpAddress(request);
		try {
			reserveService.saveSimpleReserve(ordUnionReserve, ordUnionReserveDetail, ordReserve);

			reserveService.saveDepositAmount(ip, rentId, storeId, ordUnionReserve.getId(), transactionId, subject,
					paymentFunds, ordUnionReserve);
			result.setRetCode("000000");
			/* result.setRetMsg(ctTable1.getOrderId()); */
			result.setRetMsg("type=0&reserveId=" + ordUnionReserve.getId() + "&accountSequence=" + transactionId);
		} catch (Exception e) {

			result.setRetMsg(e.getMessage());
		}

		return result;
	}

	@RequestMapping("toEditReserveForm") // 编辑预定单
	public String toEditReserveForm(HttpServletRequest request, HttpServletResponse response, Model model, String id,
			String storeId) {
		String rentId = UserUtils.getUser().getRentId();
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("type", SysConfigTypeEnum.source.getType());
		paramMap.put("typeParam", "check_visiable='1'");
		paramMap.put("rentId", rentId);
		paramMap.put("storeId", storeId);
		List<SysBusiConfig> sourceList = sourceChannelService.getSource(paramMap); // 客源
		OrdUnionReserve ordUnionReserve = reserveService.selectById(id, storeId);
		List<OrdUnionReserveDetail> ordUnionReserveDetail = reserveService.selectByUnionReserveId(id, storeId);
		model.addAttribute("ordUnionReserve", ordUnionReserve);
		model.addAttribute("ordUnionReserveDetail", ordUnionReserveDetail);
		List<CtTableType> ctTableTypeList = ctTableTypeService.getListByStoreId(storeId);
		model.addAttribute("ctTableTypeList", ctTableTypeList);
		List<SysBusiConfig> foorlList = sysBusiConfigService.getByType(storeId, "floor", rentId);
		model.addAttribute("foorlList", foorlList);
		model.addAttribute("storeId", storeId);
		model.addAttribute("sourceList", sourceList);

		return "modules/reserve/editReserveForm";
	}

	@RequestMapping("editReserve")
	@ResponseBody
	public ProcessResult editReserve(HttpServletRequest request, HttpServletResponse response) {
		ProcessResult result = new ProcessResult("999999", "操作失败");

		String params = request.getParameter("params");
		String params1 = request.getParameter("list");
		OrdUnionReserve ordUnionReserve = JsonMapper.getInstance().fromJson(params, OrdUnionReserve.class);
		JavaType javaType = JsonMapper.getInstance().createCollectionType(List.class, OrdUnionReserveDetail.class);
		List<OrdUnionReserveDetail> consumeTypes = (List<OrdUnionReserveDetail>) JsonMapper.getInstance()
				.fromJson(params1, javaType);// jsonString转list

		try {
			reserveService.editReserve(ordUnionReserve, consumeTypes);
			result.setRetCode("000000");
		} catch (Exception e) {

			result.setRetMsg(e.getMessage());
		}

		return result;
	}

	@RequestMapping("cancelReserve") // cancelReserve取消预定
	@ResponseBody
	public ProcessResult cancelReserve(HttpServletRequest request, HttpServletResponse response) {
		ProcessResult result = new ProcessResult("999999", "操作失败");

		String id = request.getParameter("id");
		String storeId = request.getParameter("storeId");

		try {
			reserveService.cancelReserve(id, storeId);
			result.setRetCode("000000");
		} catch (Exception e) {
			result.setRetMsg(e.getMessage());
		}

		return result;
	}

	@RequestMapping("orderBranchReserveForm") // 跳转分台页面
	public String orderBranchReserveForm(HttpServletRequest request, HttpServletResponse response, Model model,
			String id) {
		String rentId = UserUtils.getUser().getRentId();
		OrdUnionReserve ordUnionReserve = reserveService.selectById(id, "");
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("type", SysConfigTypeEnum.source.getType());
		paramMap.put("typeParam", "check_visiable='1'");
		paramMap.put("rentId", rentId);
		paramMap.put("storeId", ordUnionReserve.getStoreId());
		List<SysBusiConfig> sourceList = sourceChannelService.getSource(paramMap); // 客源

		List<OrdUnionReserveDetail> ordUnionReserveDetail = reserveService.selectByUnionReserveId(id,
				ordUnionReserve.getStoreId());
		for (int i = 0; i < ordUnionReserveDetail.size(); i++) {

			List<OrdReserve> list = ordReserveDao.selectByUnionReserveId(id, ordUnionReserveDetail.get(i).getId(),
					ordUnionReserve.getStoreId());
			ordUnionReserveDetail.get(i).setReserveList(list);
		}

		model.addAttribute("ordUnionReserve", ordUnionReserve);
		model.addAttribute("ordUnionReserveDetail", ordUnionReserveDetail);

		List<CtTableType> ctTableTypeList = ctTableTypeService.getListByStoreId(ordUnionReserve.getStoreId());

		model.addAttribute("ctTableTypeList", ctTableTypeList);
		/*
		 * List<SysBusiConfig> foorlList =
		 * sysBusiConfigService.getByType(storeId, "floor", rentId);
		 * model.addAttribute("foorlList", foorlList);
		 */
		model.addAttribute("storeId", ordUnionReserve.getStoreId());
		model.addAttribute("sourceList", sourceList);

		return "modules/reserve/orderBranchReserveForm";
	}

	@RequestMapping("toChoseTableNoForm")
	public String toChoseTableNoForm(HttpServletRequest request, HttpServletResponse response, Model model,
			String tableType, String storeId, String roomNo, String reserveId) {

		String[] roomN = roomNo.split(",");
		List<CtTable> ctTableList = ctTableService.selectByTypeIdAndStoreId(tableType, storeId, roomN);

		model.addAttribute("ctTableList", ctTableList);
		model.addAttribute("reserveId", reserveId);

		return "modules/reserve/choseTableNoForm";
	}

	@RequestMapping("reserveSetTableNo") // 预定分台
	@ResponseBody
	public ProcessResult reserveSetTableNo(HttpServletRequest request, HttpServletResponse response) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		String params1 = request.getParameter("list");
		JavaType javaType = JsonMapper.getInstance().createCollectionType(List.class, OrdReserve.class);
		List<OrdReserve> consumeTypes = (List<OrdReserve>) JsonMapper.getInstance().fromJson(params1, javaType);// jsonString转list
		try {
			for (OrdReserve ordReserve : consumeTypes) {
				reserveService.reserveSetTableNo(ordReserve);
			}
			result.setRetCode("000000");
		} catch (Exception e) {
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

	@RequestMapping("cleanTableNo") // 一键清空
	@ResponseBody
	public ProcessResult cleanTableNo(HttpServletRequest request, HttpServletResponse response) {
		ProcessResult result = new ProcessResult("999999", "操作失败");

		String reserveId = request.getParameter("ordReserveId");
		String storeId = request.getParameter("storeId");
		try {

			reserveService.cleanTableNo(reserveId, storeId);
			result.setRetCode("000000");
		} catch (Exception e) {

			result.setRetMsg(e.getMessage());
		}
		return result;
	}

	@RequestMapping("toReserveDepositForm") // 跳转订金管理页面
	public String toReserveDepositForm(HttpServletRequest request, HttpServletResponse response, Model model, String id,
			String reserveAmount) {
		OrdUnionReserve ordUnionReserve = reserveService.selectById(id, "");

		List<OrdUnionReserveDetail> ordUnionReserveDetail = reserveService.selectByUnionReserveId(id,
				ordUnionReserve.getStoreId());

		model.addAttribute("ordUnionReserve", ordUnionReserve);
		model.addAttribute("ordUnionReserveDetail", ordUnionReserveDetail);
		model.addAttribute("reserveAmount", reserveAmount);
		model.addAttribute("storeId", ordUnionReserve.getStoreId());

		return "modules/reserve/reserveDepositForm";
	}

	/**
	 * 修改定金信息
	 * 
	 * @param ordUnionReserve
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveDepositAmount")
	@ResponseBody
	public ProcessResult saveDepositAmount(HttpServletRequest request, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		String paymentFundJson = request.getParameter("paymentFundJson");// 支付方式
		String ordReserveId = request.getParameter("ordReserveId");
		OrdUnionReserve ordUnionReserve = reserveService.selectById(ordReserveId, "");
		JavaType javaType = JsonMapper.getInstance().createCollectionType(List.class, Map.class);
		List<Map<String, Object>> paymentFunds = (List<Map<String, Object>>) JsonMapper.getInstance()
				.fromJson(paymentFundJson, javaType);// jsonString转list
		// 第三方支付
		String subject = TitleEnum.PRE_DEPOSIT.getMessage();
		String rentId = UserUtils.getUser().getRentId();
		String storeId = UserUtils.getStoreId();
		String transactionId = SequenceUtils.getSeq("account_sequence");
		String ip = getIpAddress(request);
		try {

			result = reserveService.saveDepositAmount(ip, rentId, storeId, ordUnionReserve.getId(), transactionId,
					subject, paymentFunds, ordUnionReserve);
		} catch (Exception e) {
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

	@RequestMapping("toOrderPartCheckInForm") // 跳转到入住页面
	public String toOrderPartCheckInForm(HttpServletRequest request, HttpServletResponse response, Model model,
			String id) {
		OrdUnionReserve ordUnionReserve = reserveService.selectById(id, "");

		List<OrdUnionReserveDetail> ordUnionReserveDetail = reserveService.selectByUnionReserveId(id,
				ordUnionReserve.getStoreId());
		for (int i = 0; i < ordUnionReserveDetail.size(); i++) {

			List<OrdReserve> list = ordReserveDao.selectByUnionReserveId(id, ordUnionReserveDetail.get(i).getId(),
					ordUnionReserve.getStoreId());
			ordUnionReserveDetail.get(i).setReserveList(list);
		}

		model.addAttribute("ordUnionReserve", ordUnionReserve);
		model.addAttribute("ordUnionReserveDetail", ordUnionReserveDetail);

		model.addAttribute("storeId", ordUnionReserve.getStoreId());

		return "modules/reserve/orderPartCheckIn";
	}

	/**
	 * 预订转入住
	 * @Title: reserveCheckIn
	 * @return_type: ProcessResult
	 */
	@RequestMapping("reserveCheckIn")
	@ResponseBody
	public ProcessResult reserveCheckIn(HttpServletRequest request, HttpServletResponse response) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String unionReserveId = request.getParameter("unionReserveId");
			String reserves = request.getParameter("reserves");
			JavaType javaType = JsonMapper.getInstance().createCollectionType(List.class, OrdReserve.class);
			List<OrdReserve> ordReserves = (List<OrdReserve>) JsonMapper.getInstance().fromJson(reserves, javaType);// jsonString转list
			reserveService.toCheckIn(unionReserveId, ordReserves);
			result = new ProcessResult("000000", "操作成功");
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

	/**
	 * 预订单详情
	 * @Title: ordReserveDetails  
	 * @throws
	 */
	@RequestMapping("ordReserveDetails")
	public String ordReserveDetails(HttpServletRequest request, HttpServletResponse response, Model model,
			String reserveId, String storeId, String depositAmount, String tableCount) {
		String judge = request.getParameter("judge");
		try {
			String rentId = UserUtils.getUser().getRentId();
			OrdReserve ordReserve = new OrdReserve();
			ordReserve.setRentId(rentId);
			ordReserve.setStoreId(storeId);
			ordReserve.setUnionReserveId(reserveId);
			ordReserve = reserveService.getOrdReserveDetails(ordReserve);
			if (ordReserve != null) {
				ordReserve.setSourceName(sysBusiConfigService.get(ordReserve.getSource()).getName());
				ordReserve.setUseType(OrdTableEnum.getName(ordReserve.getUseType()));
				ordReserve.setUseLevelName(ReportEnums.getName(ordReserve.getUseLevel().toString()));
			} else {
				throw new BusinessException("无该台号订单信息:" + reserveId);
			}
			if(depositAmount==null){
				OrdReserve ord=new OrdReserve();
				ord.setId(ordReserve.getId());
				ord.setRentId(rentId);
				List<OrdReserve> ordReserveList = reserveService.getOrdReserveList(ord);
				for (OrdReserve ordReserve2 : ordReserveList) {
					depositAmount=ordReserve2.getDepositAmount().toString();
				}
			}
			if(storeId==null){
				storeId=ordReserve.getStoreId();
			}
			if(tableCount==null){
				tableCount=ordReserve.getOrderNum().toString();
			}
			String id = ordReserveDao.getId(reserveId);
			model.addAttribute("id", id);
			model.addAttribute("depositAmount", depositAmount);//订金
			model.addAttribute("ordReserve", ordReserve);
			model.addAttribute("reserveId", reserveId);
			model.addAttribute("storeId", storeId);//餐厅ID
			model.addAttribute("judge",judge);//判断是否需要显示按钮
			model.addAttribute("tableCount", tableCount);//台数
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "modules/reserve/ordReserveDetails";
	}

	/**
	 * 预订单已点菜品
	 * @Title: reserveHaveDotFood  
	 * @throws
	 */
	@RequestMapping("reserveHaveDotFood")
	public String reserveHaveDotFood(HttpServletRequest request, HttpServletResponse response, Model model,
			String reserveId, String storeId, String depositAmount, String tableCount, String id) {
		try {
			String judge = request.getParameter("judge");
			int totalCount = 0;// 菜品数量
			Money totalConsume = new Money();// 消费金额
			Money totalRateAmount = new Money();// 折扣
			Money accountsDue = new Money();// 应收款
			String rentId = UserUtils.getUser().getRentId();
			List<Map<String, Object>> list = ordReserveConsumeItemService.getReserveConsume(id, rentId);
			for (Map<String, Object> map : list) {
				totalCount += Double.valueOf(ObjectUtils.toString(map.get("count"))).intValue();
				totalConsume.addTo(new Money(map.get("count")).multiply(new Money(map.get("price")).getAmount()));
				totalRateAmount.addTo(new Money(map.get("rateAmount")));
				accountsDue.addTo(new Money(map.get("amount")));
				map.put("rateAmount", new Money(map.get("rateAmount")));
				map.put("amount", new Money(map.get("amount")));
			}
			model.addAttribute("judge", judge);
			model.addAttribute("totalCount", totalCount);
			model.addAttribute("totalConsume", totalConsume);
			model.addAttribute("totalRateAmount", totalRateAmount);
			model.addAttribute("totalAmount", totalConsume);
			model.addAttribute("theTotalPayment", depositAmount);
			model.addAttribute("accountsDue", accountsDue);
			model.addAttribute("ordReserve", list);
			model.addAttribute("reserveId", reserveId);
			model.addAttribute("storeId", storeId);
			model.addAttribute("id", id);
			model.addAttribute("tableCount", tableCount);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "modules/reserve/reserveHaveDotFood";
	}

	/**
	 * 提前点餐
	 * @Title: reserveAheadOrderFood  
	 * @return String 
	 * @throws
	 */
	@RequestMapping("reserveAheadOrderFood")
	public String reserveAheadOrderFood(HttpServletRequest request, HttpServletResponse response, Model model) {
		String storeId = request.getParameter("storeId");
		String reserveId = request.getParameter("reserveId");// 预订单Id
		String id = request.getParameter("id");
		try {
			OrdUnionReserve ordUnionReserve = reserveService.selectById(reserveId, storeId);
			OrdReserve ordReserve = ordReserveDao.get(id);
			Map<String, Object> tableTotal = new HashMap<String, Object>();
			if (ordUnionReserve != null) {
				ordUnionReserve.setSource(sysBusiConfigService.get(ordUnionReserve.getSource()).getName());
				ordUnionReserve.setUseLevelName(ReportEnums.getName(ordUnionReserve.getUseLevel().toString()));
				ordUnionReserve.setUseType(OrdTableEnum.getName(ordUnionReserve.getUseType()));
				tableTotal = reserveService.getTotalUseNumber(reserveId, storeId);
				model.addAttribute("useNum", tableTotal.get("personCount"));
				model.addAttribute("tableNum", tableTotal.get("quantity"));
			}
			model.addAttribute("storeId", storeId);
			model.addAttribute("reserveId", reserveId);
			model.addAttribute("id", id);
			model.addAttribute("tableNo", ordReserve.getTableNo());
			model.addAttribute("ordReserve", ordReserve);
			model.addAttribute("ordUnionReserve", ordUnionReserve);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "modules/reserve/reserveAheadOrderFood";
	}

	/**
	 * @Title: reserveAheadOrderFoodSave  
	 * @Description: 提前点菜提交
	 * @param request
	 * @param response
	 * @param model
	 * @return ProcessResult 
	 * @throws
	 */
	@RequestMapping("reserveAheadOrderFoodSave")
	@ResponseBody
	public ProcessResult reserveAheadOrderFoodSave(HttpServletRequest request, HttpServletResponse response,
			Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String storeId = request.getParameter("storeId");
			String id = request.getParameter("id");
			String foodId = request.getParameter("foodId");
			String cookValues = request.getParameter("cookValues");
			String cookValuesTemp = request.getParameter("cookValuesTemp");
			String status = request.getParameter("status");// 1为特价菜
			if (status == null) {
				status = "0";
			}
			String specialId = request.getParameter("specialId");
			OrdReserve ordTable = ordReserveDao.get(id);
			if (ordTable == null) {
				throw new BusinessException("预订单不存在reserveId=" + id);
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
			// 保存预订单消费明细
			OrdReserveConsumeItem ordReserveConsumeItem = new OrdReserveConsumeItem();
			ordReserveConsumeItem.setStoreId(storeId);
			ordReserveConsumeItem.setReserveId(id);
			ordReserveConsumeItem.setFeeId(foodId);
			ordReserveConsumeItem.setCount(count);
			ordReserveConsumeItem.setPrice(price);
			ordReserveConsumeItem.setRate(costRate);
			ordReserveConsumeItem.setTitleEnum(TitleEnum.RESTAURANT_FEE.getCode());
			ordReserveConsumeItem.setCookValues(cookValues);
			ordReserveConsumeItem.setCookValuesTemp(cookValuesTemp);
			ordReserveConsumeItem.setStatus("0");
			ordReserveConsumeItemService.save(ordReserveConsumeItem);
			Map<String, Object> ret = new HashMap<String, Object>();
			result = new ProcessResult("000000", "操作成功", ret);
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

	/**
	 * 预订菜品状态
	 * @Title: foodStatus  
	 * @throws
	 */
	@RequestMapping("foodStatus")
	public String foodStatus(HttpServletRequest request, HttpServletResponse response, Model model) {
		String type = request.getParameter("type");
		String[] foodId = request.getParameter("foodId").split(",");
		String foodName = request.getParameter("foodName");
		String tableNo = request.getParameter("tableNo");
		try {
			foodName = URLDecoder.decode(foodName, "UTF-8");
			String status = "";
			model.addAttribute("type", type);
			model.addAttribute("foodName", foodName);
			model.addAttribute("foodId", request.getParameter("foodId"));
			model.addAttribute("foodSize", foodId.length);
			model.addAttribute("tableNo", tableNo);
			if (type.equals("5")) {
				return "modules/reserve/reserveChargeback";
			}
			if (type.equals("6")) {
				String subtotal = request.getParameter("subtotal");
				model.addAttribute("subtotalAmount", subtotal);
				return "modules/reserve/reserveDiscount";
			}
			if (type.equals("7")) {
				String subtotal = request.getParameter("subtotal");
				model.addAttribute("subtotalAmount", subtotal);
				return "modules/reserve/reservePresented";
			}
			model.addAttribute("status", status);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "modules/order/ordStatus";
	}

	/**
	 * @Title: getReserveConsume  
	 * @Description:预订单消费明细
	 * @param request
	 * @param response
	 * @param model
	 * @return ProcessResult 
	 * @throws
	 */
	@RequestMapping("getReserveConsume")
	@ResponseBody
	public ProcessResult getReserveConsume(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String reserveId = request.getParameter("reserveId");
			String rentId = UserUtils.getUser().getRentId();
			List<Map<String, Object>> list = ordReserveConsumeItemService.getReserveConsume(reserveId, rentId);
			Map<String, Object> ret = new HashMap<String, Object>();
			ret.put("list", list);
			result = new ProcessResult("000000", "操作成功", ret);
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

	/**
	 * @Title: reservePassFood  
	 * @Description:预订传菜
	 * @param request
	 * @param response
	 * @param model
	 * @return ProcessResult 
	 * @throws
	 */
	@RequestMapping("reservePassFood")
	@ResponseBody
	public ProcessResult reservePassFood(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		String storeId = request.getParameter("storeId");
		String foods = request.getParameter("foods");
		String tableNo = request.getParameter("tableNo");
		String useNum = request.getParameter("useNum");
		String reserveId = request.getParameter("reserveId");
		try {
			JavaType javaType = JsonMapper.getInstance().createCollectionType(List.class, Map.class);
			List<Map<String, Object>> selectFoodList = (List<Map<String, Object>>) JsonMapper.getInstance()
					.fromJson(foods, javaType);// jsonString转list
			for (Map<String, Object> map : selectFoodList) {
				ordReserveConsumeItemService.updateStatus(map, reserveId, storeId, tableNo);
			}
			Map<String, Object> printMap = new HashMap<String, Object>();
			List<SysBusiConfig> printerList = sysBusiConfigService.getByType(storeId,
					SysConfigTypeEnum.foodPrinter.getType());
			for (SysBusiConfig sysBusiConfig : printerList) {
				Map<String, Object> ipPortsPrint = new HashMap<>();
				ipPortsPrint.put("dateTime", DateUtils.formatDate(new Date(), "yyyy-MM-dd HH:mm:ss"));
				ipPortsPrint.put("titleName", "预订单传菜");
				ipPortsPrint.put("no", tableNo);
				ipPortsPrint.put("num", useNum);
				ipPortsPrint.put("printName", sysBusiConfig.getParamKey());
				ipPortsPrint.put("remarks", "");
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
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

	/**
	 * 
	 * @Title: reserveChargeback  
	 * 预订菜品退单
	 * @throws
	 */
	@RequestMapping("reserveChargeback")
	@ResponseBody
	public ProcessResult reserveChargeback(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String[] foodId = request.getParameter("foodId").split(",");
			String[] foodName = request.getParameter("foodName").split(",");
			String remarks = request.getParameter("remarks");
			String cause = request.getParameter("cause");
			String tableNo = request.getParameter("tableNo");
			for (int i = 0; i < foodId.length; i++) {
				String id = foodId[i];
				String name = foodName[i];
				OrdReserveConsumeItem reserve = ordReserveConsumeItemService.get(id);
				ordReserveConsumeItemService.saveReserveChargeback(reserve, name, remarks, cause, tableNo);
			}
			result = new ProcessResult("000000", "操作成功");
		} catch (Exception e) {
			e.printStackTrace();
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
		String foodId = request.getParameter("foodId");
		String type = request.getParameter("type");
		String tableNo = request.getParameter("tableNo");
		if (foodId == null) {
			throw new BusinessException("请选择菜品");
		}
		model.addAttribute("storeId", storeId);
		model.addAttribute("tableNo", tableNo);
		model.addAttribute("foodId", foodId);
		List<CtFoodCfg> foodCfgList = new ArrayList<>();// 关联类别
		String[] foodIds = foodId.split(",");
		CtFood ctFood = new CtFood();
		if (type.equals("1")) {
			if (foodIds.length == 1) {
				OrdReserveConsumeItem list = ordReserveConsumeItemService.get(foodId);
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
			return "modules/reserve/reserveFoodModus";
		} else {
			OrdReserveConsumeItem list = ordReserveConsumeItemService.get(foodId);
			CtFoodCfg foodCfg = new CtFoodCfg();
			foodCfg.setFoodId(list.getFeeId());
			foodCfgList = ctFoodCfgService.findList(foodCfg);
			ctFood = ctFoodService.get(list.getFeeId());
			model.addAttribute("ctFood", ctFood);
		}
		model.addAttribute("foodCfgList", foodCfgList);
		return "modules/reserve/reserveAddFood";
	}

	/**
	 * @Title: saveFoodModus  
	 *  保存预订菜品做法
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
			String tableNo = request.getParameter("tableNo");// 预订台号
			for (int i = 0; i < foodId.length; i++) {
				OrdReserveConsumeItem reserve = ordReserveConsumeItemService.get(foodId[i]);
				reserve.setCookValues(cookValues);
				reserve.setCookValuesTemp(cookValuesTemp);
				ordReserveConsumeItemService.savaFoodModus(reserve, tableNo);
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
			String tableNo = request.getParameter("tableNo");
			for (int i = 0; i < foodId.length; i++) {
				String id = foodId[i];
				String name = foodName[i];
				OrdReserveConsumeItem reserve = ordReserveConsumeItemService.get(id);
				reserve.setRate(new Money(rate));
				reserve.setRemarks(remarks);
				ordReserveConsumeItemService.updateDiscount(reserve, name, cause, tableNo);
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
			String tableNo = request.getParameter("tableNo");
			for (int i = 0; i < foodId.length; i++) {
				String id = foodId[i];
				String name = foodName[i];
				OrdReserveConsumeItem reserve = ordReserveConsumeItemService.get(id);
				reserve.setPrice(new Money("0"));
				reserve.setRemarks(remarks + "【赠送】");
				ordReserveConsumeItemService.updatePresent(reserve, name, cause, tableNo);
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
		String reserveId = request.getParameter("orderId");// 单号id
		model.addAttribute("tableNo", tableNo);
		model.addAttribute("consume", consume);
		model.addAttribute("proceeds", proceeds);
		model.addAttribute("reserveId", reserveId);
		model.addAttribute("storeId", storeId);
		return "modules/reserve/reserveChangeTable";
	}

}
