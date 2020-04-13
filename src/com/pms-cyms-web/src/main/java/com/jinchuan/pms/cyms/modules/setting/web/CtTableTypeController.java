
package com.jinchuan.pms.cyms.modules.setting.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.jinchuan.pms.cyms.modules.setting.entity.CtTable;
import com.jinchuan.pms.cyms.modules.setting.entity.CtTableType;
import com.jinchuan.pms.cyms.modules.setting.entity.CtTableTypeStore;
import com.jinchuan.pms.cyms.modules.setting.service.CtTableService;
import com.jinchuan.pms.cyms.modules.setting.service.CtTableTypeService;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

/**
 * @ClassName: CtTableTypeController
 * @Description: TODO(桌型设置)
 * @author 孙文
 * @date 2019年9月3日
 * 
 */

@Controller
@RequestMapping(value = "${adminPath}/setting/tableTyple")
public class CtTableTypeController extends BaseController {

	@Autowired
	private CtTableTypeService ctTableTypeService;
	@Autowired
	CtTableService ctTableService;

	@RequiresPermissions("table:ctTableType:view")
	@RequestMapping(value = "list")
	public String toCtTableTypeList(HttpServletRequest request, HttpServletResponse response, Model model) {
		String rentId = UserUtils.getUser().getRentId();
		CtTableType ctTableType = new CtTableType();
		ctTableType.setRentId(rentId);
		List<CtTableType> ctTableTypeList = ctTableTypeService.findList(ctTableType);

		model.addAttribute("ctTableTypeList", ctTableTypeList);

		return "modules/setting/tableset/ctTableTypeList";
	}

	// 新增页面跳转
	@RequestMapping(value = "form")
	public String toCtTableTypeForm(HttpServletRequest request, HttpServletResponse response, Model model) {

		return "modules/setting/tableset/ctTableTypeForm";
	}

	// 跳转到编辑页面
	@RequestMapping(value = "toEditCtTableTypeForm")
	public String toEditCtTableTypeForm(String id, HttpServletResponse response, Model model) {

		CtTableType ctTableType = ctTableTypeService.get(id);
		List<CtTableTypeStore> storeList=ctTableTypeService.selectStoreByTableTypeId(id);
		model.addAttribute("storeList", storeList);
		model.addAttribute("ctTableType", ctTableType);
		
		return "modules/setting/tableset/editCtTableTypeForm";
	}

	@RequiresPermissions("table:ctTableType:edit")
	@RequestMapping(value = "save")
	@ResponseBody//新增台型
	public ProcessResult saveCtTableType(HttpServletRequest request, Model model, CtTableType ctTableType) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		String[] office = request.getParameterValues("storeId");
		CtTableType ctTableType1 = ctTableTypeService.selectByName(ctTableType);
		if (ctTableType1 == null) {

			try {
				ctTableTypeService.saveCtTbleType(ctTableType, office);
				result.setRetCode("000000");
			} catch (Exception e) {

				result.setRetMsg(e.getMessage());
			}

		} else {

			result.setRetMsg("台型名称重复！");
		}

		return result;
	}
	
	@RequestMapping(value = "edit")
	@ResponseBody//编辑台型
	public ProcessResult editCtTableType(HttpServletRequest request, Model model, CtTableType ctTableType) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		String[] office = request.getParameterValues("storeId");
		CtTableType ctTableType1 = ctTableTypeService.selectByName(ctTableType);
		if (ctTableType1==null||(ctTableType.getName().equals(ctTableType1.getName())&&ctTableType1.getId().equals(ctTableType.getId()))) {

			try {
				ctTableTypeService.editCtTbleType(ctTableType, office);
				result.setRetCode("000000");
			} catch (Exception e) {

				result.setRetMsg(e.getMessage());
			}

		} else {

			result.setRetMsg("台型名称重复，请重新输入！");
		}

		return result;
	}

	@RequestMapping(value = "delete")//删除台型
	@ResponseBody
	public ProcessResult deleteCtTableType(String id, HttpServletResponse response,
			HttpServletRequest request) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			CtTable ctTable = new CtTable();
			ctTable.setTypeId(id);
			//查询该区域下是否有桌台
			List<CtTable> tableList = ctTableService.findList(ctTable);
			if (tableList != null && tableList.size() > 0) {
				result.setRetCode("111111");
			} else {
				ctTableTypeService.deleteTableTypeById(id);
				result.setRetCode("000000");
			}
		} catch (Exception e) {
			e.printStackTrace();
			result.setRetMsg(e.getMessage());
		}
		return result;

	}

}
