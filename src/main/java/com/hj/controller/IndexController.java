package com.hj.controller;

import com.hj.service.TestService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Slf4j
@Controller
public class IndexController {

    @Autowired
    TestService loginService;

    @GetMapping("/")
    public String index(Model model){
        log.debug("index");
        int keyCd = 1;
        String test = loginService.test(keyCd);
        log.debug("test: {}", test);
        model.addAttribute("test", test);
        return "index";
    }
}
