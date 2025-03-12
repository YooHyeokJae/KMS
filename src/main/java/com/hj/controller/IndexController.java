package com.hj.controller;

import com.hj.service.FoodService;
import com.hj.service.TestService;
import com.hj.vo.FoodVo;
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
import java.time.LocalDate;
import java.util.Collection;
import java.util.List;
import java.util.Map;

@Controller
public class IndexController {
    Logger log = LoggerFactory.getLogger(IndexController.class);

    @Resource(name="foodService")
    private FoodService foodService;

    @GetMapping("/")
    public String index(Model model){
        List<FoodVo> foodVoList = this.foodService.selectAll();
        model.addAttribute("foodVoList", foodVoList);
        return "index";
    }

    @GetMapping("/company")
    public String company(Model model){
        return "company";
    }

    @PostMapping("/test")
    public String test(HttpServletRequest request) throws ServletException, IOException {
        return "redirect:/";
    }
}
