package com.hj.controller;

import com.hj.service.TestService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import javax.annotation.Resource;

@Controller
public class IndexController {

    Logger log = LoggerFactory.getLogger(IndexController.class);

    @Resource(name="testService")
    private TestService testService;

    @GetMapping("/")
    public String index(Model model){
        log.info("index");
        int keyCd = 1;
        String test = testService.test(keyCd);
        log.debug("test: {}", test);
        model.addAttribute("test", test);
        return "index";
    }
}
