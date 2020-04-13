package com.jinchuan.pms.cyms.modules.member.web;

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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.databind.JavaType;
import com.jinchuan.pms.cyms.modules.setting.entity.HtlStore;
import com.jinchuan.pms.cyms.modules.setting.service.HtlStoreService;
import com.jinchuan.pms.cyms.modules.utils.PmsFacadeUtils;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.exception.BusinessException;
import com.jinchuan.pms.pub.common.mapper.JsonMapper;
import com.jinchuan.pms.pub.common.utils.ObjectUtils;
import com.jinchuan.pms.pub.common.web.BaseController;

@Controller
@RequestMapping("${adminPath}/member/group")
public class CmGroupController extends BaseController {
	@Autowired
	private HtlStoreService htlStoreService;

	/**
	 * 
	 * @Title: getGroupListInit  
	 * @Description: 协议单位搜索初始化
	 * @param request
	 * @param response
	 * @param model
	 * @param redirectAttributes
	 * @return 
	 * String 
	 * @throws
	 */
	@RequestMapping(value = "getGroupListInit")
	public String getGroupListInit(HttpServletRequest request, HttpServletResponse response, Model model,
			RedirectAttributes redirectAttributes) {
		return "modules/common/common_groupList_select";
	}

	/**
	 * @Title: getGroupList  
	 * @Description: 协议单位搜索
	 * @param request
	 * @param response
	 * @param model
	 * @return ProcessResult 
	 * @throws
	 */
	@RequestMapping("getGroupList")
	@ResponseBody
	public ProcessResult getGroupList(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String storeId = request.getParameter("storeId");
			String queryValue = request.getParameter("queryValue");
			Map<String, String> paramMap = new HashMap<String, String>();
			HtlStore htlStore = htlStoreService.get(storeId);
			if (htlStore == null) {
				throw new BusinessException("分店不存在storeId=" + storeId);
			}
			String pmsRentId = htlStore.getPmsRentId();
			String pmsStoreId = htlStore.getPmsStoreId();
			paramMap.put("rentId", pmsRentId);
			paramMap.put("storeId", pmsStoreId);
			paramMap.put("queryValue", queryValue);
			String responseStr = PmsFacadeUtils.sendPostToPMS(PmsFacadeUtils.groupQueryUrl, paramMap);
			JavaType javaType = JsonMapper.getInstance().createCollectionType(List.class, Map.class);
			Map<String, Object> retMap = (Map<String, Object>) JsonMapper.getInstance().fromJson(responseStr,
					Map.class);// jsonString转list
			if ("000000".equals(retMap.get("retCode"))) {
				Map<String, Object> responseRet = (Map<String, Object>) retMap.get("ret");
				List<Map<String, Object>> groups = (List<Map<String, Object>>) responseRet.get("result");
				Map<String, Object> ret = new HashMap<String, Object>();
				ret.put("list", groups);
				result = new ProcessResult("000000", "操作成功", ret);
			} else {
				result.setRetMsg(ObjectUtils.toString(retMap.get("retMsg")));
			}
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}
}
