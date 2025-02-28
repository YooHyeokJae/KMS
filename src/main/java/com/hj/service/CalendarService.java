package com.hj.service;

import com.hj.mapper.CalendarMapper;
import com.hj.vo.CalendarVo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class CalendarService {
    @Resource(name="calendarMapper")
    private CalendarMapper calendarMapper;

    public List<CalendarVo> getEvents(Map<String, Object> params) {
        return this.calendarMapper.getEvents(params);
    }

    public void addEvent(Map<String, Object> params) {
        this.calendarMapper.addEvent(params);
    }
}
