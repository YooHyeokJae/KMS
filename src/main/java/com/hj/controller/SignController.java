package com.hj.controller;

import com.hj.service.SignService;
import com.hj.vo.ChildVo;
import com.hj.vo.UserVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/sign")
public class SignController {
    Logger log = LoggerFactory.getLogger(SignController.class);

    @Resource(name="signService")
    private SignService signService;

    @PostMapping("/signup")
    public String signup(@RequestParam Map<String, Object> param) {
        log.info("signup");
        UserVo userVo = new UserVo();
        userVo.setId((String) param.get("uId"));
        userVo.setPassword((String) param.get("uPw"));
        userVo.setName((String) param.get("uName"));
        userVo.setTelNo((String) param.get("uTelNo"));
        userVo.setEmail((String) param.get("uEmail"));
        userVo.setChildNum(Integer.parseInt((String) param.get("uChildNum")));
        userVo.setRelation((String) param.get("relation"));
        log.info("userVo: {}", userVo);
        // userVo insert
        return "redirect:/";
    }

    @PostMapping("/dupChk")
    @ResponseBody
    public boolean dupChk(@RequestBody Map<String, Object> param) {
        String uId = (String) param.get("uId");
        UserVo userVo = this.signService.getUserByUserId(uId);
        return userVo == null;
    }

    @PostMapping("/searchChild")
    @ResponseBody
    public List<ChildVo> searchChild(@RequestBody Map<String, Object> params) {
        String keyword = (String) params.get("keyword");
        List<ChildVo> list = new ArrayList<>();
        list = this.signService.searchChild(keyword);
        return list;
    }

    @PostMapping("/login")
    public String login(HttpServletRequest request,
                        @RequestParam Map<String, Object> params) {
        log.info("params: {}", params);
        UserVo userVo = this.signService.login(params);
        if(userVo != null) {
            request.getSession().setAttribute("loginUser", userVo);
        }else{
            request.getSession().setAttribute("loginFailed", true);
        }
        return "redirect:/";
    }

    @PostMapping("/logout")
    @ResponseBody
    public String logout(HttpServletRequest request) {
        request.getSession().removeAttribute("loginUser");
        return "logout";
    }
}
