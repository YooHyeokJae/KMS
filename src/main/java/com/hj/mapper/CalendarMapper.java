package com.hj.mapper;

import com.hj.vo.CalendarVo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface CalendarMapper {
    List<CalendarVo> getEvents(Map<String, Object> params);

    void addEvent(Map<String, Object> params);

    void modEvent(Map<String, Object> params);

    void delEvent(Map<String, Object> params);
}
