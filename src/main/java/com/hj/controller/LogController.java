package com.hj.controller;

import com.hj.service.LogService;
import com.hj.util.Utils;
import com.hj.vo.AccessLogVo;
import com.hj.vo.UserVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.util.Map;

@Controller
public class LogController implements HandlerInterceptor {
    Logger log = LoggerFactory.getLogger(LogController.class);

    @Resource(name="logService")
    private LogService logService;

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {
        Map<String, Object> ipInfo = Utils.getIpInfo();
        String ipAddress = ipInfo.get("ip").toString();
        String pageUrl = request.getRequestURI();

        HttpSession session = request.getSession(false);
        String userId = null;
        if (session != null) {
            UserVo userVo = (UserVo) session.getAttribute("loginUser");
            if (userVo != null) {
                userId = userVo.getId();
                AccessLogVo accessLogVo = new AccessLogVo(userId, ipAddress, pageUrl);
                log.info("accessLog: {}", accessLogVo);
                if("GET".equalsIgnoreCase(request.getMethod())) {
                    this.logService.insertLog(accessLogVo);
                }
            }
        }
        return true;
    }
}
