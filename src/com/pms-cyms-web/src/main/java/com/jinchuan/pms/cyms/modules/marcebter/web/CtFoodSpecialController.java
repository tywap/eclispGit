package com.jinchuan.pms.cyms.modules.marcebter.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.databind.JavaType;
import com.jinchuan.pms.cyms.modules.marcebter.entity.CtFoodSpecial;
import com.jinchuan.pms.cyms.modules.marcebter.service.CtFoodSpecialService;
import com.jinchuan.pms.cyms.modules.setting.entity.CtFood;
import com.jinchuan.pms.cyms.modules.setting.entity.CtFoodType;
import com.jinchuan.pms.cyms.modules.setting.service.CtFoodService;
import com.jinchuan.pms.cyms.modules.setting.service.CtFoodTypeService;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.mapper.JsonMapper;
import com.jinchuan.pms.pub.common.utils.StringUtils;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.entity.SysBusiConfig;
import com.jinchuan.pms.pub.modules.sys.service.SysBusiConfigService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * 菜品设置
 *@author LiLingJie
 *@Description
 *@Date 2019年9月10日 下午6:11:47
 */
@Controller
@RequestMapping(value = "${adminPath}/marcebter/ctfoodSpecial")
public class CtFoodSpecialController extends BaseController {

	@Autowired
	CtFoodTypeService dishesService;
	@Autowired
	CtFoodService ctFoodService;
	@Autowired
	SysBusiConfigService sysBusiConfigService;
	@Autowired
	CtFoodSpecialService ctFoodSpecialService;
	@ModelAttribute
	public CtFood get(@RequestParam(required = false) String id) {
		CtFood entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = ctFoodService.get(id);
		}
		if (entity == null) {
			entity = new CtFood();
		}
		return entity;
	}

	/**
	 * 菜品设置列表
	 */
	@RequestMapping(value = "List")
	public String list(CtFoodSpecial ctFoodSpecial, HttpServletRequest request, HttpServletResponse response, Model model) {
		String rentid = UserUtils.getUser().getRentId();
		String storeId = ctFoodSpecial.getStoreId();
		ctFoodSpecial.setRentId(rentid);
		model.addAttribute("storeId", storeId);
		try {
			if (storeId == null) {
				return "modules/marcebter/ctFoodSpecialList";
			} else {
				List<CtFoodSpecial> list = ctFoodSpecialService.queryctfood(ctFoodSpecial);
				model.addAttribute("list", list);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "modules/marcebter/ctFoodSpecialList";
//		return "modules/room/enmontPrint/printAccount";
	}

	/**
	 * 菜品详情
	 */
	@RequestMapping(value = "form")
	public String form(HttpServletRequest request, HttpServletResponse response, CtFood ctFood, Model model) {
		String id=request.getParameter("id");
		String rentid = UserUtils.getUser().getRentId();
		String storeId = request.getParameter("storeId");
		if(id!=null){
			CtFoodSpecial ctFoodSpecial=new CtFoodSpecial();
			ctFoodSpecial.setId(id);
			ctFoodSpecial.setRentId(rentid);
			CtFoodSpecial list = ctFoodSpecialService.cftGet(ctFoodSpecial);
			model.addAttribute("cfFoodSpecial", list);
		}
		model.addAttribute("storeId", storeId);
		return "modules/marcebter/ctFoodSpecialForm";
	}

	/**
	 * 菜品选择列表
	 */
	@RequestMapping(value = "select")
	public String select(CtFood ctFood, HttpServletRequest request, HttpServletResponse response, Model model) {
		String rentid = UserUtils.getUser().getRentId();
		String name =request.getParameter("foodName");
		SysBusiConfig sysBusiConfig=new SysBusiConfig();
		sysBusiConfig.setRentId(rentid);
		sysBusiConfig.setType("foodMainType");
		ctFood.setRentId(rentid);
		List<SysBusiConfig> list = sysBusiConfigService.findList(sysBusiConfig);
		CtFoodType ctFoodType=new CtFoodType();
		ctFoodType.setRentId(rentid);
		ctFoodType.setName(name);
		List<CtFoodType> dishesTypeList = dishesService.getLittleType(ctFoodType);
		List<CtFood> maplist = ctFoodService.getcommoditList(ctFood);
		model.addAttribute("maplist", maplist);
		model.addAttribute("dishesTypeList", dishesTypeList);
		model.addAttribute("bigTypeList", list);
		return "modules/marcebter/ctFoodSpecialSelect";
	}

	/**
	 * 查询菜品
	 */
	@RequestMapping(value = "ctFoodspecial")
	@ResponseBody
	public ProcessResult saveBig(CtFood ctFood, Model model, RedirectAttributes redirectAttributes) {
		ProcessResult result = new ProcessResult("000000", "操作成功");
		List<CtFood> list=new  ArrayList<CtFood>();
		try {
			if(StringUtils.isNotBlank(ctFood.getId())){
				String[] moldId= ctFood.getId().split(",");
				for (int i = 0; i < moldId.length; i++) {
					CtFood ct= ctFoodService.get(moldId[i]);
					list.add(ct);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetCode("999999");
			result.setRetMsg("操作失败");
			return result;
		}
		result.setList(list);
		return result;
	}
	/**
	 * 保存特价菜
	 */
	@RequestMapping(value = "save")
	@ResponseBody
	public ProcessResult save(CtFoodSpecial ctFoodSpecial, Model model, RedirectAttributes redirectAttributes,
			HttpServletRequest request, HttpServletResponse response){
		ProcessResult result = new ProcessResult("999999", "操作失败");
		String array=request.getParameter("array");
		String mktInfo=request.getParameter("mktInfo");
		JavaType javaType = JsonMapper.getInstance().createCollectionType(List.class, Map.class);
		List<Map<String, Object>> cardTypeLevels = (List<Map<String, Object>>) JsonMapper.getInstance()
				.fromJson(array, javaType);// jsonString转list
		CtFoodSpecial cftmap=(CtFoodSpecial)JsonMapper.getInstance().fromJson(mktInfo, CtFoodSpecial.class);
		try {
			if(cardTypeLevels.size()>0){
				for (Map<String, Object> map : cardTypeLevels) {
					CtFoodSpecial ct=new CtFoodSpecial();
					if(StringUtils.isNotBlank(cftmap.getId())){
						ct = ctFoodSpecialService.get(cftmap);
					}
					ct.setStoreId(cftmap.getStoreId());
					ct.setFoodId(map.get("foodId").toString());
					ct.setPrice(map.get("price").toString());
					ct.setAndValue(cftmap.getAndValue());
					ct.setAndType(cftmap.getAndType());
					ct.setEffectiveDate(cftmap.getEffectiveDate());
					ct.setExpireDate(cftmap.getExpireDate());
					ct.setIsSinglePoint(cftmap.getIsSinglePoint());
					ct.setIsCoupon(cftmap.getIsCoupon());
					ct.setIsMaxBuyCount(cftmap.getIsMaxBuyCount());
					ct.setMaxBuyCount(cftmap.getMaxBuyCount());
					ct.setMaxBuyCount(cftmap.getMaxBuyCount());
					ct.setIsMaxSellCount(cftmap.getIsMaxSellCount());
					ct.setMaxSellCount(cftmap.getMaxSellCount());
					ct.setIsDiscount(cftmap.getIsDiscount());
					/*ct.setStatus("0");*/
					ctFoodSpecialService.save(ct);
				}
				result.setRetCode("000000");
				result.setRetMsg("操作成功");
			}else{
				result.setRetCode("999999");
				result.setRetMsg("请选择特价菜品");
			}
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}
	
	@RequestMapping(value = "delete")
	@ResponseBody
	public ProcessResult delete(CtFoodSpecial ctFoodSpecial,Model model, RedirectAttributes redirectAttributes,
			HttpServletRequest request, HttpServletResponse response){
		ProcessResult result = new ProcessResult("999999", "操作失败");
		String rentid = UserUtils.getUser().getRentId();
		if(StringUtils.isNotBlank(ctFoodSpecial.getId())){
			ctFoodSpecialService.deleteTableTypeById(ctFoodSpecial.getId());
			result.setRetCode("000000");
			result.setRetMsg("删除成功");
		}else{
			String ctfid=request.getParameter("ctfid");
			String[] list = ctfid.split(",");
			for (String foodId : list) {
				/*ctFoodSpecialService.deleteTableTypeById(foodId);*/
				CtFoodSpecial ct=new CtFoodSpecial();
				ct.setId(foodId);
				ct.setRentId(rentid);
				ctFoodSpecialService.delete(ct);
			}
			result.setRetCode("000000");
			result.setRetMsg("删除成功");
		}
		return result;
	}
}
