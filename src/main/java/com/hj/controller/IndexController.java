package com.hj.controller;

import com.hj.service.TestService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.Part;
import java.io.IOException;
import java.util.Collection;
import java.util.Map;

@Controller
public class IndexController {

    Logger log = LoggerFactory.getLogger(IndexController.class);

    @GetMapping("/")
    public String index(Model model){
        log.info("index");
        return "index";
    }

    @PostMapping("/test")
    public String test(HttpServletRequest request) throws ServletException, IOException {
        return "redirect:/";
    }
}
