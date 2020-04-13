package com.jinchuan.pms.cyms.modules.order.web;

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

import com.jinchuan.pms.cyms.modules.order.entity.OrdTable;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.web.BaseController;
import com.jinchuan.pms.pub.modules.sys.entity.OrdOperateLog;
import com.jinchuan.pms.pub.modules.sys.service.OrdOperateLogService;

/**
 * 
 * 类名称：OrdOperateLogController   
 * 类描述：   
 * 创建人：Administrator
 * 创建时间：2019年9月12日 上午11:06:33   
 * 修改人：Administrator
 * 修改时间：2019年9月12日 上午11:06:33   
 * 修改备注：   
 * @version
 */
@Controller
@RequestMapping("${adminPath}/order/ordLog")
public class OrdOperateLogController extends BaseController {
	@Autowired
	public OrdOperateLogService ordOperateLogService; 
	
	/**
	 * 查询订单信息
	 * @Title: getOrdLogByOrdId
	 * @return_type: ProcessResult
	 */
	@RequestMapping("getOrdLogsByOrdId")
	@ResponseBody
	public ProcessResult getOrdLogsByOrdId(HttpServletRequest request, HttpServletResponse response, Model model) {
		ProcessResult result = new ProcessResult("999999", "操作失败");
		try {
			String orderId = request.getParameter("orderId");
			List<Map<String,String>> ordOperateLogs = ordOperateLogService.getOperateLogByOrdId(orderId);
			Map<String, Object> ret = new HashMap<String, Object>();
			ret.put("list", ordOperateLogs);
			result = new ProcessResult("000000", "操作成功", ret);
		} catch (Exception e) {
			result.setRetMsg(e.getMessage());
			e.printStackTrace();
		}
		return result;
	}
}
