package com.hj.controller;

import com.hj.service.BoardService;
import com.hj.service.FoodService;
import com.hj.service.TestService;
import com.hj.vo.BoardVo;
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
import java.util.*;

@Controller
public class IndexController {
    Logger log = LoggerFactory.getLogger(IndexController.class);

    @Resource(name="foodService")
    private FoodService foodService;
    @Resource(name="boardService")
    private BoardService boardService;

    @GetMapping("/")
    public String index(Model model){
        List<FoodVo> foodVoList = this.foodService.selectAll();
        model.addAttribute("foodVoList", foodVoList);

        Map<String, Object> params = new HashMap<>();
        params.put("category", "notice");
        params.put("count", 5);
        params.put("order", "date");
        List<BoardVo> boardVoList = this.boardService.getBestByDateOrViewOrLike(params);
        model.addAttribute("boardVoList", boardVoList);
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
