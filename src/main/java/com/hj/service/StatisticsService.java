package com.hj.service;

import com.hj.mapper.StatisticsMapper;
import com.hj.vo.StatsVo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class StatisticsService {

    @Resource(name="statisticsMapper")
    private StatisticsMapper statisticsMapper;

    public List<StatsVo> getEntryStats(Map<String, Object> params) {
        return this.statisticsMapper.getEntryStats(params);
    }

    public List<StatsVo> getTeacherStats(Map<String, Object> params) {
        return this.statisticsMapper.getTeacherStats(params);
    }

    public List<StatsVo> getStudentStats() {
        return this.statisticsMapper.getStudentStats();
    }
}
