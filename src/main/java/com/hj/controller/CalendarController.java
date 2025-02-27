package com.hj.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/calendar")
public class CalendarController {
    Logger log = LoggerFactory.getLogger(CalendarController.class);

    @GetMapping("/")
    public String calendar() {
        return "calendar/calendar";
    }
}
