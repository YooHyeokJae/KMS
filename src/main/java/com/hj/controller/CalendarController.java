package com.hj.controller;

import com.hj.service.CalendarService;
import com.hj.vo.CalendarVo;
import com.hj.vo.UserVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/calendar")
public class CalendarController {
    Logger log = LoggerFactory.getLogger(CalendarController.class);

    @Resource(name="calendarService")
    private CalendarService calendarService;

    @GetMapping("/")
    public String calendar(Model model,
                           HttpSession session) {
        UserVo userVo = (UserVo) session.getAttribute("loginUser");
        Map<String, Object> params = new HashMap<>();
        if(userVo != null) {
            params.put("id", userVo.getId());
        }
        List<CalendarVo> eventList = this.calendarService.getEvents(params);
        model.addAttribute("eventList", eventList);
        return "calendar/calendar";
    }

    @PostMapping("/getEvents")
    @ResponseBody
    public List<CalendarVo> getEvents(HttpSession session,
                            @RequestBody Map<String, Object> params){
        UserVo userVo = (UserVo) session.getAttribute("loginUser");
        params.put("id", userVo.getId());
        return this.calendarService.getEvents(params);
    }

    @PostMapping("/addEvent")
    @ResponseBody
    public String addEvent(@RequestBody Map<String, Object> params) {
        this.calendarService.addEvent(params);
        return "success";
    }
}
