package com.jinchuan.pms.cyms.modules.print.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.Assert;
import org.springframework.web.bind.annotation.RequestMapping;

import com.jinchuan.pms.cyms.modules.print.service.PrintFactory;
import com.jinchuan.pms.cyms.modules.print.service.PrintInterface;
import com.jinchuan.pms.pub.common.utils.StringUtils;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

@Controller
@RequestMapping(value = "${adminPath}/print")
// 暂行
public class PrintControllerTmp {
	@Autowired
	PrintFactory printFactory;

	private PrintInterface getConfig(Model model) {
		// String type=Global.getConfig("printLocation");
		String type = UserUtils.getPrintTypeName();
		Assert.isTrue(StringUtils.isNotEmpty(type));
		PrintInterface printService = printFactory.get(type.trim());
		printService.setModel(model);
		return printService;
	}

	// 打印收款单
	@RequestMapping(value = { "printDeposit" })
	public String printDeposit(String ordId, HttpServletRequest request, HttpServletResponse response, Model model) {
		return getConfig(model).printDeposit(ordId);
	}

	// 打印结账单
	@RequestMapping(value = { "printCheckOut" })
	public String printCheckOut(String ordId, HttpServletRequest request, HttpServletResponse response, Model model) {
		return getConfig(model).printCheckOut(ordId);
	}
	
	// 非住客帐销售单
	@RequestMapping(value = { "printOrdShopping" })
	public String printOrdShopping(String ordId, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		return getConfig(model).printOrdShopping(ordId);
	}

	// 打印预定单
	@RequestMapping(value = { "printReserve" })
	public String printReserveBill(String reserveId, HttpServletRequest request, HttpServletResponse response,
			Model model) {
		return getConfig(model).printReserveBill(reserveId);
	}

	// 打印备用金上缴/下放
	@RequestMapping(value = { "printSpareFund" })
	public String printSpareFund(String ordSpareFundIds, String sequence, String operateType,
			HttpServletRequest request, HttpServletResponse response, Model model) {
		return getConfig(model).printSpareFund(ordSpareFundIds, sequence, operateType);
	}

	// 交接班打印
	@RequestMapping(value = { "printOrdCashBox" })
	public String printOrdCashBox(String shiftId, String sequence, String operateType, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		return getConfig(model).printOrdCashBox(shiftId, sequence, operateType);
	}
}
