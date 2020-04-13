/**
 *
 */
package com.jinchuan.pms.cyms.modules.sys.web;

import com.jinchuan.pms.cyms.modules.order.service.OrdCashboxService;
import com.jinchuan.pms.pub.common.config.Global;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.exception.ValidationException;
import com.jinchuan.pms.pub.common.utils.StringUtils;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.entity.PubShift;
import com.jinchuan.pms.pub.modules.sys.entity.User;
import com.jinchuan.pms.pub.modules.sys.enums.OfficeTypeEnum;
import com.jinchuan.pms.pub.modules.sys.service.PubShiftService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallbackWithoutResult;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 班次Controller
 * @author LB
 * @version 2017-09-28
 */
@Controller
@RequestMapping(value = "${adminPath}/bc/pubShift")
public class PubShiftController extends BaseController {
	@Autowired
	private PubShiftService pubShiftService;
	@Autowired
	private OrdCashboxService ordCashboxService;
	@Resource
	private TransactionTemplate transactionTemplate;

	@ModelAttribute
	public PubShift get(@RequestParam(required = false) String id) {
		PubShift entity = null;
		if (StringUtils.isNotBlank(id)) {
			entity = pubShiftService.get(id);
		}
		if (entity == null) {
			entity = new PubShift();
		}
		return entity;
	}

	// 添加班次信息
	@RequiresPermissions("bc:pubShift:view")
	@RequestMapping(value = "add")
	@ResponseBody
	public ProcessResult add(PubShift pubShift, HttpServletRequest request, HttpServletResponse response, Model model) {

		return ProcessResult.SUCCESS;
	}

	// 查询所有班次信息
	@RequiresPermissions("bc:pubShift:view")
	@RequestMapping(value = { "list", "" })
	public String list(PubShift pubShift, HttpServletRequest request, HttpServletResponse response, Model model) {
		return "";
	}

	// 保存编辑的班次
	@RequiresPermissions("bc:pubShift:view")
	@RequestMapping(value = "saveShift")
	@ResponseBody
	public ProcessResult saveShift(PubShift pubShift, HttpServletRequest request, HttpServletResponse response,
			RedirectAttributes redirectAttributes) {
		return ProcessResult.SUCCESS;
	}

	// 编辑班次信息
	@RequiresPermissions("bc:pubShift:view")
	@RequestMapping(value = "updatebc")
	public String updatebc(PubShift pubShift, HttpServletRequest request, HttpServletResponse response, Model model) {
		// model.addAttribute("pubShift", pubShift);
		String id = request.getParameter("uid");

		pubShift.setId(id);
		PubShift pubS = pubShiftService.queryShift(id);
		model.addAttribute(pubS);
		return "modules/sys/shift/pubShiftUpdate";
	}

	@RequiresPermissions("bc:pubShift:view")
	@RequestMapping(value = "form")
	public String form(PubShift pubShift, Model model) {
		model.addAttribute("pubShift", pubShift);
		return "modules/sys/shift/pubShiftForm";
	}

	@RequiresPermissions("bc:pubShift:edit")
	@RequestMapping(value = "save")
	public String save(PubShift pubShift, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, pubShift)) {
			return form(pubShift, model);
		}
		addMessage(redirectAttributes, "保存班次成功");
		return "redirect:" + Global.getAdminPath() + "/sys/shift/pubShift/?repage";
	}

	@RequiresPermissions("bc:pubShift:edit")
	@RequestMapping(value = "delete")
	public String delete(PubShift pubShift, RedirectAttributes redirectAttributes) {
		pubShiftService.delete(pubShift);
		addMessage(redirectAttributes, "删除班次成功");
		return "redirect:" + Global.getAdminPath() + "/sys/shift/pubShift/?repage";
	}

	@RequiresPermissions("bc:pubShift:edit")
	@RequestMapping(value = "upbc")
	public String upbc(String bcid, String status, HttpServletRequest request, HttpServletResponse response,
			RedirectAttributes redirectAttributes) {
		return "";
	}

	/**
	 * @Title: queryRentType  
	 * @Description: 查询班次钱箱
	 * @param request
	 * @param response
	 * @return ProcessResult 
	 * @throws
	 */
	@RequestMapping(value = "query")
	@ResponseBody
	public ProcessResult queryRentType(HttpServletRequest request, HttpServletResponse response) {
		ProcessResult result = null;
		String loginName = request.getParameter("loginName");
		try {
			if (StringUtils.isEmpty(loginName)) {
				result = new ProcessResult(ProcessResult.FAILURE.getRetCode(), "参数输入有误");
				return result;
			}

			UserUtils.clearCache(new User("", loginName));
			User user = UserUtils.getByLoginName(loginName);
			if (user == null) {
				result = new ProcessResult(ProcessResult.FAILURE.getRetCode(), "用户不存在");
				return result;
			}

			List<PubShift> shiftList = new ArrayList<PubShift>();
			if (OfficeTypeEnum.STORE.getCode().equals(user.getCompany().getType())
					|| OfficeTypeEnum.HOTEL.getCode().equals(user.getCompany().getType())) {
				String storeId = user.getCompany().getId();
				shiftList = pubShiftService.queryStoreShift(storeId, user.getRentId());
				if (shiftList != null && shiftList.size() < 2) {
					final String storeStr = storeId;
					transactionTemplate.execute(new TransactionCallbackWithoutResult() {
						@Override
						protected void doInTransactionWithoutResult(TransactionStatus transactionStatus) {
							ordCashboxService.queryStoreShiftLogin(storeStr, user.getRentId());
						}
					});

					shiftList = pubShiftService.queryStoreShift(storeId, user.getRentId());
					if (shiftList.size() < 2) {
						throw new ValidationException("班次配置错误");
					}
				}
			}
			result = new ProcessResult("000000", "成功", shiftList);
		} catch (Exception e) {
			e.printStackTrace();
			result = new ProcessResult(ProcessResult.FAILURE.getRetCode(), "班次配置错误,请重新登录");
		}
		return result;
	}

	@RequestMapping("getshiftListByStoreId")
	@ResponseBody
	public ProcessResult getshiftListByStoreId(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String rentId = UserUtils.getUser().getRentId();
			String storeId = request.getParameter("storeId");
			List<PubShift> shiftList = pubShiftService.queryStoreShift(storeId, rentId);// 获取班次信息

			Map<String, Object> ret = new HashMap<String, Object>();
			ret.put("lists", shiftList);
			result = new ProcessResult("000000", "操作成功", ret);
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;
	}

}