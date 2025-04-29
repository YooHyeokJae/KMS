package com.hj.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.hj.service.UserService;
import com.hj.vo.UserVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdminController {
    Logger log = LoggerFactory.getLogger(AdminController.class);

    @Resource(name="userService")
    private UserService userService;

    @GetMapping("/")
    public String page(){
        return "admin/index";
    }

    @PostMapping(value = "/getUserList", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String getUserList(@RequestBody Map<String, Object> params){
        List<UserVo> userVoList = this.userService.getList(params);
        try {
            ObjectMapper mapper = new ObjectMapper();
            mapper.registerModule(new JavaTimeModule());
            return mapper.writeValueAsString(userVoList);
        } catch(Exception e){
            log.error("{}", e.getMessage());
            return null;
        }
    }

    @PostMapping("/changeAuth")
    @ResponseBody
    public String changeAuth(@RequestBody Map<String, Object> params){
        this.userService.changeAuth(params);
        // 문자 API
        return "success";
    }
}
