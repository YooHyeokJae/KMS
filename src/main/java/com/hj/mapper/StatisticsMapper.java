package com.hj.mapper;

import com.hj.vo.StatsVo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface StatisticsMapper {
    List<StatsVo> getEntryStats(Map<String, Object> params);

    List<StatsVo> getTeacherStats(Map<String, Object> params);

    List<StatsVo> getStudentStats();

    List<StatsVo> getStatsByUser();

    List<StatsVo> getStatsByPageUrl();

    List<StatsVo> getStatsByLogin(Map<String, Object> params);
}
