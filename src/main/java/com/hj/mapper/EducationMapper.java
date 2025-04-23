package com.hj.mapper;

import com.hj.vo.*;
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

    List<DailyPlanVo> getAllDailyPlan();

    List<TeacherVo> searchTeacherByName(String keyword);

    int getTotalCntDailyPlan();

    DailyPlanVo getDailyPlanByNum(String num);

    List<ActivityVo> getActivitiesByPlanNum(String num);

    List<DailyPlanVo> searchPlan(Map<String, String> params);

    int getNextActivityRecordNum();

    void insertRecord(ActivityRecordVo activityRecordVo);

    List<ActivityRecordVo> getAllActivityRecord();

    int getNextCounselNum();

    List<CounselVo> getAllCounselByChildNum(int childNum);

    CounselVo getCounselByNum(int num);

    void insertCounsel(Map<String, Object> params);

    void modifyCounsel(Map<String, Object> params);

    List<HealthVo> getHealthListByChildNum(Map<String, Object> params);

    void deleteHealthCheckByNum(int num);

    int getNextHealthCheckNum();

    void insertHealthCheckByNum(Map<String, Object> param);

    void updateHealthCheckByNum(Map<String, Object> param);

    List<GradeVo> getGradeList();

    List<DailyPlanVo> searchDailyPlanByCond(Map<String, Object> params);

    List<ActivityRecordVo> searchRecordByCond(Map<String, Object> params);

    List<AttendanceVo> getAttendanceByGrade(Map<String, Object> params);

    int attCheck(Map<String, Object> params);

    void insertAttendance(Map<String, Object> params);

    void updateAttendance(Map<String, Object> params);

    AttendanceVo getAttInfo(Map<String, Object> params);

    List<AttendanceVo> getAttendanceByChildNum(int childNum);
}
