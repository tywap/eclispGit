package com.jinchuan.pms.cyms.modules.sys.web;

import java.io.File;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

import com.alibaba.fastjson.JSON;
import com.jinchuan.pms.pub.common.config.Global;
import com.jinchuan.pms.pub.common.mapper.JsonMapper;
import com.jinchuan.pms.pub.common.utils.FtpUtils;
import com.jinchuan.pms.pub.common.utils.QiniuUitls;

/**
 * 
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value = "${adminPath}/upload")
public class FileUploadController {
	private Logger log = LoggerFactory.getLogger(FileUploadController.class);
	private SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");

	/**
	 * 加载上传界面
	 * @Title: fileUploadInit  
	 * @param @param request
	 * @param @param response
	 * @param @param modelMap
	 * @param @return 
	 * @return String 
	 * @throws
	 */
	@RequestMapping("fileUploadInit")
	public String fileUploadInit(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) {
		return "modules/sys/fileUpload";
	}

	/**
	 * 提交from请求（其中文件请求上ftp）
	 * @Title: fileUpload  
	 * @param @param request
	 * @param @param response
	 * @param @param modelMap
	 * @param @return 
	 * @return String 
	 * @throws
	 */
	@RequestMapping("fileUpload")
	public String fileUpload(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) {
		log.info("开始上传文件");
		int pre = (int) System.currentTimeMillis();
		String fileDir = request.getParameter("fileDir");
		String filePath = "";
		try {
			fileDir = new SimpleDateFormat("yyyyMMdd").format(new Date());
			// 创建一个通用的多部分解析器
			CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver(
					request.getSession().getServletContext());
			// 判断 request 是否有文件上传,即多部分请求
			if (multipartResolver.isMultipart(request)) {
				// 转换成多部分request
				MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;
				// 取得request中的所有文件名
				Iterator<String> iter = multiRequest.getFileNames();
				while (iter.hasNext()) {
					// 取得上传文件
					MultipartFile file = multiRequest.getFile(iter.next());
					if (file != null) {
						// 取得当前上传文件的文件名称
						String originalFilename = file.getOriginalFilename();
						// 如果名称不为“”,说明该文件存在，否则说明该文件不存在
						if (originalFilename.trim() != "") {
							InputStream in = file.getInputStream();
							String filePathTemp = "/" + fileDir;
							originalFilename = sdf.format(new Date()) + "-" + originalFilename;
							log.info("filePathTemp={},originalFilename={}", filePathTemp, originalFilename);
							boolean flag = FtpUtils.uploadFile(filePathTemp, originalFilename, in);
							if (flag) {
								filePath = Global.getConfig("ftp.basePath") + filePathTemp + "/" + originalFilename;
							} else {
								log.info("上传失败!");
							}
						}
					}
				}
			} else {
				log.info("未找到上传数据!");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		int finaltime = (int) System.currentTimeMillis();
		log.info("耗时{}", finaltime - pre);
		modelMap.put("filePath", filePath);
		log.info("完成上传文件");
		return "modules/sys/fileUpload";
	}

	/**
	 * 上传文件至本地
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("fileUpload2")
	public String fileUpload2(HttpServletRequest request, HttpServletResponse response) {
		try {
			// 创建一个通用的多部分解析器
			CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver(
					request.getSession().getServletContext());
			// 判断 request 是否有文件上传,即多部分请求
			if (multipartResolver.isMultipart(request)) {
				// 转换成多部分request
				MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;
				// 取得request中的所有文件名
				Iterator<String> iter = multiRequest.getFileNames();
				while (iter.hasNext()) {
					// 记录上传过程起始时的时间，用来计算上传时间
					int pre = (int) System.currentTimeMillis();
					// 取得上传文件
					MultipartFile file = multiRequest.getFile(iter.next());
					if (file != null) {
						// 取得当前上传文件的文件名称
						String myFileName = file.getOriginalFilename();
						// 如果名称不为“”,说明该文件存在，否则说明该文件不存在
						if (myFileName.trim() != "") {
							log.info("myFileName{}", myFileName);
							// 重命名上传后的文件名
							String fileName = file.getOriginalFilename();
							String filePath = "E:\\apache-tomcat-7.0.61\\temp\\";
							// 定义上传路径
							String path = filePath + fileName;
							File localFile = new File(path);
							file.transferTo(localFile);
						}
					}
					// 记录上传该文件后的时间
					int finaltime = (int) System.currentTimeMillis();
					log.info("耗时{}", finaltime - pre);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}

	/**
	 * 提交多文件from请求（其中文件请求上七牛云）
	 * @Title: fileUpload  
	 * @param @param request
	 * @param @param response
	 * @param @param modelMap
	 * @param @return 
	 * @return String 
	 * @throws
	 */
	@RequestMapping("fileUpload3")
	public String fileUpload3(@RequestParam("fileName") MultipartFile[] files, HttpServletRequest request,
			HttpServletResponse response, ModelMap modelMap) {
		log.info("开始上传文件");
		int pre = (int) System.currentTimeMillis();
		List<Map<String, String>> filePaths = new ArrayList<Map<String, String>>();
		try {
			log.info("files.length=", files.length);
			for (MultipartFile file : files) {
				if (file != null && file.getSize() > 0) {
					String fileName = file.getOriginalFilename();
					log.info("上传文件={}", fileName);
					String filePath = QiniuUitls.upload(file.getBytes());
					Map<String, String> map = new HashMap<String, String>();
					map.put("fileName", fileName.substring(0, fileName.lastIndexOf(".")));
					map.put("filePath", filePath);
					filePaths.add(map);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		String filePath = JSON.toJSONString(filePaths);
		log.info("完成上传文件，filePath={}", filePath);
		modelMap.put("filePath", filePath);
		int finaltime = (int) System.currentTimeMillis();
		log.info("耗时{}", finaltime - pre);
		return "modules/sys/fileUpload";
	}

	/**
	 * 加载ftp上的文件
	 * 
	 * @param filename
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping("fileDownload")
	public void fileDownload(String filename, HttpServletRequest request, HttpServletResponse response) {
		try {
			log.debug("开始文件下载");
			String filePath = request.getParameter("filePath");
			log.info("filePath={}", filePath);
			if (filePath != null && filePath != "" && filePath.contains(".") && filePath.contains("/")) {
				String filePathDir = filePath.substring(0, filePath.lastIndexOf("/") + 1);
				String fileName = filePath.substring(filePath.lastIndexOf("/") + 1, filePath.length());
				log.info("服务器路径：{}，文件名：{}", filePathDir, fileName);
				InputStream is = FtpUtils.downloadFile2(filePathDir, fileName);
				response.setContentType("image/jpeg");
				response.setHeader("Content-Disposition", "attachment;filename=" + fileName);
				OutputStream writer = response.getOutputStream();
				byte[] buf = new byte[1024];
				int len = 0;
				while ((len = is.read(buf)) != -1) {
					writer.write(buf, 0, len);
				}
				is.close();
			}
			log.debug("完成文件下载");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 提交富文本请求（其中文件请求上ftp） 
	 * @Title: editorFileUpload  
	 * @param @param request
	 * @param @param response
	 * @param @param modelMap 
	 * @return void 
	 * @throws
	 */
	@RequestMapping("editorFileUpload")
	public void editorFileUpload(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) {
		int pre = (int) System.currentTimeMillis();
		String filePath = "";
		String fileDir = new SimpleDateFormat("yyyyMMdd").format(new Date());
		try {
			CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver(
					request.getSession().getServletContext());// 创建一个通用的多部分解析器
			if (multipartResolver.isMultipart(request)) {
				// 判断 request 是否有文件上传,即多部分请求
				MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;// 转换成多部分request
				Iterator<String> iter = multiRequest.getFileNames();// 取得request中的所有文件名
				String originalFileName = "";
				String newFileName = "";
				long size = 0;
				while (iter.hasNext()) {
					MultipartFile file = multiRequest.getFile(iter.next());// 取得上传文件
					size = file.getSize();
					if (file != null) {
						originalFileName = file.getOriginalFilename();// 取得当前上传文件的文件名称
						if (originalFileName.trim() != "") {
							InputStream in = file.getInputStream();// 如果名称不为“”,说明该文件存在，否则说明该文件不存在
							String filePathTemp = "/" + fileDir;
							newFileName = sdf.format(new Date()) + "-" + originalFileName;
							boolean flag = FtpUtils.uploadFile(filePathTemp, newFileName, in);
							if (flag) {
								filePath = Global.getConfig("ftp.basePath") + filePathTemp + "/" + newFileName;
							}
						}
					}
				}

				String type = originalFileName.substring(originalFileName.indexOf("."), originalFileName.length());
				modelMap.put("state", "SUCCESS");
				modelMap.put("original", originalFileName);
				modelMap.put("size", size);
				modelMap.put("title", newFileName);
				modelMap.put("type", type);
				modelMap.put("url", "LoadFtpFile.do?filePath=" + filePath);
			} else {
				modelMap.put("state", "false");
				modelMap.put("info", "未找到上传数据!");
			}

			String jsonStr = JsonMapper.toJsonString(modelMap);
			response.getWriter().write(jsonStr);

			int finaltime = (int) System.currentTimeMillis();
			log.info("耗时{}", finaltime - pre);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
