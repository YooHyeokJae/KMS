package com.hj.controller;

import com.hj.service.BoardService;
import com.hj.service.FoodService;
import com.hj.service.TestService;
import com.hj.util.Utils;
import com.hj.vo.AlbumVo;
import com.hj.vo.BoardVo;
import com.hj.vo.FoodVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;

@Controller
public class IndexController {
    Logger log = LoggerFactory.getLogger(IndexController.class);

    @Resource(name="testService")
    private TestService testService;
    @Resource(name="foodService")
    private FoodService foodService;
    @Resource(name="boardService")
    private BoardService boardService;

    @GetMapping("/")
    public String index(Model model) throws Exception {
        Map<String, Object> ipInfo = Utils.getIpInfo();
        String loc = ipInfo.get("loc").toString();
        String nx = loc.split(",")[0].split("\\.")[0];
        String ny = loc.split(",")[1].split("\\.")[0];
        Map<String, Object> weather = Utils.getWeather(nx, ny);
        model.addAttribute("weather", weather);

        List<FoodVo> foodVoList = this.foodService.selectAll();
        model.addAttribute("foodVoList", foodVoList);

        Map<String, Object> params = new HashMap<>();
        params.put("category", "notice");
        params.put("count", 5);
        params.put("order", "date");
        List<BoardVo> boardVoList = this.boardService.getBestByDateOrViewOrLike(params);
        model.addAttribute("boardVoList", boardVoList);

        int lastNum = this.boardService.getLastAlbumNum();
        int cnt = 10;
        List<AlbumVo> albumVoList = this.boardService.getAlbum(lastNum, cnt);
        model.addAttribute("albumVoList", albumVoList);

        String todayQuote = this.boardService.todayQuote();
        model.addAttribute("todayQuote", todayQuote);
        return "index";
    }

    @GetMapping("/company")
    public String company(Model model){
        return "company";
    }

    @GetMapping("/test")
    public String test(Model model) {

        return null;
    }
}
