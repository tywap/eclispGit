package com.jinchuan.pms.cyms.modules.ota.web;

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
import com.jinchuan.pms.cyms.modules.ota.enums.AppCfgEnum;
import com.jinchuan.pms.cyms.modules.setting.entity.CtTable;
import com.jinchuan.pms.pub.common.config.ProcessResult;
import com.jinchuan.pms.pub.common.mapper.JsonMapper;
import com.jinchuan.pms.pub.common.utils.DateUtils;
import com.jinchuan.pms.pub.common.utils.SysBusiConfigUtils;
import com.jinchuan.pms.pub.modules.sys.entity.SysBusiConfig;
import com.jinchuan.pms.pub.modules.sys.service.SysBusiConfigService;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

@Controller
@RequestMapping("${adminPath}/ota/appCfg")
public class OtaAppCfgrController {
	@Autowired
	private SysBusiConfigService sysBusiConfigService;
	
	@RequestMapping("list")
	public String list(HttpServletRequest request, HttpServletResponse response, String storeId1, Model model,
			CtTable ctTable1) {
		List<SysBusiConfig> busitils = SysBusiConfigUtils.getSysBusiConfigList("appMenu", "1");
		model.addAttribute("busitils", busitils);
		
		List<SysBusiConfig> list = SysBusiConfigUtils.getSysBusiConfigList("appCfg", "1");
		model.addAttribute("syslist", list);
		if(storeId1!=null){
			String rentId = UserUtils.getUser().getRentId();
			if ("".equals(storeId1) || null == storeId1) {
				storeId1 = ctTable1.getStoreId();
			}
			ctTable1.setStoreId(storeId1);
			ctTable1.setRentId(rentId);
			SysBusiConfig sysBusiConfig = new SysBusiConfig();
			sysBusiConfig.setRentId(rentId);
			sysBusiConfig.setType("printer");
			sysBusiConfig.setStoreId(storeId1);

			List<SysBusiConfig> sysbusilist = sysBusiConfigService.foodTypeList(sysBusiConfig);
			model.addAttribute("sysbusilist", sysbusilist);
			model.addAttribute("selectStoreId", storeId1);
		}
		return "modules/ota/AppCfgSame";
	}
	@RequestMapping(value = "save")
	@ResponseBody
	public ProcessResult save( Model model,HttpServletRequest request, HttpServletResponse response){
		ProcessResult result = new ProcessResult("999999", "操作失败");
		String rentId = UserUtils.getUser().getRentId();
		String map = request.getParameter("map");
		JavaType javaType = JsonMapper.getInstance().createCollectionType(List.class, Map.class);
		List<Map<String, Object>> cardTypeLevels = (List<Map<String, Object>>) JsonMapper.getInstance()
				.fromJson(map, javaType);// jsonString转list
		List<SysBusiConfig> list = SysBusiConfigUtils.getSysBusiConfigList("appCfg", "1");
		for (Map<String, Object> map2 : cardTypeLevels) {
			String status=map2.get("status").toString();//启用APP点餐
			String standbyMinute=map2.get("standbyMinute").toString();//设置时长
			String menus=map2.get("menus").toString();//自定义底部菜单
			String printername=map2.get("printername").toString();//设置打印机
			if(status!=null){
				int i=0;//判断是否做了修改
				for (SysBusiConfig s : list) {
					if(s.getName()==AppCfgEnum.status.getName()&&s.getParamValue()==status){
						SysBusiConfig sys=printinsert();
						sys=printupdate(s);
						sysBusiConfigService.update(sys);
						i++;
					}
				}
				if(i==0){
					SysBusiConfig sys=printinsert();
					sys.setName(AppCfgEnum.status.getName());
					sys.setStoreId(map2.get("storeId").toString());
					sys.setRentId(rentId);
					sys.setParamValue(status);
					sys.setParamKey(AppCfgEnum.status.getCode());
					sysBusiConfigService.insert(sys);
				}
			} 
			if(standbyMinute!=null){
				int i=0;
				for (SysBusiConfig s : list) {
					if(s.getName()==AppCfgEnum.standbyMinute.getName()&&s.getParamValue()==standbyMinute){
						SysBusiConfig sys=printinsert();
						sys=printupdate(s);
						sysBusiConfigService.update(sys);
						i++;
					}
				}
				if(i==0){
					SysBusiConfig sys=printinsert();
					sys.setName(AppCfgEnum.standbyMinute.getName());
					sys.setStoreId(map2.get("storeId").toString());
					sys.setRentId(rentId);
					sys.setParamValue(standbyMinute);
					sys.setParamKey(AppCfgEnum.standbyMinute.getCode());
					sysBusiConfigService.insert(sys);
				}
			} 
			if(menus!=null){
				String[] name=menus.split(",");
				for (int i = 0; i < name.length; i++) {
					int j=0;
					for (SysBusiConfig s : list) {
						if(s.getName()==AppCfgEnum.menus.getName()&&s.getParamValue()==name[i]){//判断是否有值 做新增与修改
							SysBusiConfig sys=printinsert();
							sys=printupdate(s);
							sysBusiConfigService.update(sys);
							j++;
						}
					}
					if(j==0){
						SysBusiConfig sys=printinsert();
						sys.setName(AppCfgEnum.menus.getName());
						sys.setStoreId(map2.get("storeId").toString());
						sys.setRentId(rentId);
						sys.setParamValue(name[i]);
						sys.setParamKey(AppCfgEnum.menus.getCode());
						sysBusiConfigService.insert(sys);
					}
					j=0;
				}
				
			} 
			if(printername!=null){
				int i=0;
				for (SysBusiConfig s : list) {
					if(s.getName()==AppCfgEnum.printer.getName()&&s.getParamValue()==printername){
						SysBusiConfig sys=printinsert();
						sys=printupdate(s);
						sysBusiConfigService.update(sys);
					}
				}
				if(i==0){
					SysBusiConfig sys=printinsert();
					sys.setName(AppCfgEnum.printer.getName());
					sys.setStoreId(map2.get("storeId").toString());
					sys.setRentId(rentId);
					sys.setParamValue(printername);
					sys.setParamKey(AppCfgEnum.printer.getCode());
					sys.setParamKey("printer");
					sysBusiConfigService.insert(sys);
				}
			}
			
		}
		return result;
	}
	
	public SysBusiConfig printupdate(SysBusiConfig s){
		SysBusiConfig sys=new SysBusiConfig();
		sys.setId(s.getId());
		sys.setParamKey(s.getParamKey());
		sys.setParamValue(s.getParamValue());
		sys.setName(s.getName());
		sys.setType(s.getType());
		sys.setStatus(s.getStatus());
		sys.setSort(s.getSort());
		sys.setStoreId(s.getStoreId());
		sys.setDelFlag(s.getDelFlag());
		return s;
	}
	
	public SysBusiConfig printinsert(){
		SysBusiConfig sys=new SysBusiConfig();
		sys.setStatus("1");
		sys.setType("appCfg");
		sys.setDelFlag("0"); 
		sys.preInsert();
		/*sys.setParamKey(sys.getId());*/
		return sys;
	}
}
