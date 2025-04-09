package com.hj.controller;

import com.hj.service.SignService;
import com.hj.service.StatisticsService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;

@Controller
@RequestMapping("/statistics")
public class StatisticsController {
    Logger log = LoggerFactory.getLogger(StatisticsController.class);

    @Resource(name="statisticsService")
    private StatisticsService statisticsService;

    @GetMapping("/")
    public String statistics(Model model) {
        return "statistics/statistics";
    }
}
