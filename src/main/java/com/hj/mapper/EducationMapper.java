package com.hj.mapper;

import com.hj.vo.ActivityVo;
import com.hj.vo.DailyPlanVo;
import com.hj.vo.TeacherVo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface EducationMapper {
    int getNextDailyPlanNum();

    int getNextActivityNum();

    void insertDailyPlan(DailyPlanVo dailyPlanVo);

    void insertActivity(ActivityVo activityVo);

    List<DailyPlanVo> getAllDailyPlan();

    List<TeacherVo> searchTeacherByName(String keyword);
}
