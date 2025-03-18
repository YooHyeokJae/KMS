package com.hj.mapper;

import com.hj.vo.ActivityVo;
import com.hj.vo.DailyPlanVo;
import com.hj.vo.TeacherVo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface EducationMapper {
    int getNextDailyPlanNum();

    int getNextActivityNum();

    void insertDailyPlan(DailyPlanVo dailyPlanVo);

    void modifyDailyPlan(DailyPlanVo dailyPlanVo);

    void deleteActivity(int num);

    void insertActivity(ActivityVo activityVo);

    List<DailyPlanVo> getAllDailyPlan(Map<String, Object> params);

    List<TeacherVo> searchTeacherByName(String keyword);

    int getTotalCntDailyPlan();

    DailyPlanVo getDailyPlanByNum(String num);

    List<ActivityVo> getActivitiesByPlanNum(String num);
}
