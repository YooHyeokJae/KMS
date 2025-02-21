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

    @GetMapping("/")
    public String index(Model model){
        log.info("index");
        return "index";
    }
}
