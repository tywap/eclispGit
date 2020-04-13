package com.jinchuan.pms.cyms.modules.sys.web;

import java.util.Collection;
import java.util.List;

import javax.annotation.Resource;

import org.apache.shiro.session.Session;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.collect.Lists;
import com.jinchuan.pms.cyms.modules.setting.entity.CtTable;
import com.jinchuan.pms.cyms.modules.setting.service.CtTableService;
import com.jinchuan.pms.pub.common.security.shiro.session.SessionDAO;
import com.jinchuan.pms.pub.common.utils.CacheUtils;
import com.jinchuan.pms.pub.modules.sys.entity.User;
import com.jinchuan.pms.pub.modules.sys.utils.UserUtils;

@Controller
@RequestMapping(value = "${adminPath}/pubAccountDate")
public class PubAccountDateController {
	private Logger log = LoggerFactory.getLogger(PubAccountDateController.class);
	@Resource
	private SessionDAO cacheSessionDAO;
	@Autowired
	private CtTableService ctTableService;

	@RequestMapping("")
	@ResponseBody
	public boolean updateCache(String rentId, String storeId, String newTime) {
		try {
			log.info("更新账务日期,门店号:" + storeId + ",更新日期:" + newTime);
			CacheUtils.put(UserUtils.USER_SYSDATE + storeId, newTime);
			CtTable ctTable = new CtTable();
			List<CtTable> tables = ctTableService.findList(ctTable);
			for (CtTable table : tables) {
				CacheUtils.remove("roomsInfo_" + table.getId());
			}
			log.info("刷新状态,门店号:" + storeId + ",更新日期:" + newTime);
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	@RequestMapping("lockUser")
	@ResponseBody
	public boolean lockUser(String storeId, String rentId) {
		try {
			List<User> userList = UserUtils.getUserByCompany(storeId, rentId);
			List<String> userIds = Lists.newArrayList();
			userList.stream().forEach(user -> userIds.add(user.getId()));
			Collection<Session> sessions = cacheSessionDAO.getSessionByUserId(userIds);
			for (Session session : sessions) {
				session.stop();
			}
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

}
