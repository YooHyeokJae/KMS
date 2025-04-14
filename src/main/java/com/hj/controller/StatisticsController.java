package com.hj.controller;

import com.hj.service.StatisticsService;
import com.hj.vo.StatsVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.time.Year;
import java.util.*;

@Controller
@RequestMapping("/statistics")
public class StatisticsController {
    Logger log = LoggerFactory.getLogger(StatisticsController.class);

    @Resource(name="statisticsService")
    private StatisticsService statisticsService;

    @GetMapping("/education")
    public String education(Model model) {
        Map<String, Object> params = new HashMap<>();
        List<String> years = new ArrayList<>();
        int curYear = Year.now().getValue();
        for(int i=0; i<5; i++) {
            years.add(curYear - i + "");
        }
        params.put("years", years);

        List<StatsVo> entryStats = this.statisticsService.getEntryStats(params);
        model.addAttribute("entryStats", entryStats);
        List<StatsVo> teacherStats = this.statisticsService.getTeacherStats(params);
        model.addAttribute("teacherStats", teacherStats);
        List<StatsVo> studentStats = this.statisticsService.getStudentStats();
        model.addAttribute("studentStats", studentStats);
        return "statistics/education";
    }

    @PostMapping("/redrawChart")
    @ResponseBody
    public List<StatsVo> redrawChart(@RequestBody Map<String, Object> params) {
        int year = Integer.parseInt(params.get("year").toString());
        List<String> years = new ArrayList<>();
        int curYear = Year.now().getValue();
        for(int i=0; i<year; i++) {
            years.add(curYear - i + "");
        }
        params.put("years", years);

        if("entry".equals(params.get("chart"))) {
            return this.statisticsService.getEntryStats(params);
        }else if("teacher".equals(params.get("chart"))) {
            return this.statisticsService.getTeacherStats(params);
        }else{
            return null;
        }
    }

    @GetMapping("/page")
    public String statistics(Model model) {
        return "statistics/page";
    }
}
