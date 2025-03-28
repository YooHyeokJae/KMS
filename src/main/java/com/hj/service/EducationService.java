package com.hj.service;

import com.hj.mapper.EducationMapper;
import com.hj.vo.ActivityRecordVo;
import com.hj.vo.ActivityVo;
import com.hj.vo.DailyPlanVo;
import com.hj.vo.TeacherVo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class EducationService {
    @Resource(name="educationMapper")
    private EducationMapper educationMapper;

    public int getNextDailyPlanNum() {
        return this.educationMapper.getNextDailyPlanNum();
    }

    public int getNextActivityNum() {
        return this.educationMapper.getNextActivityNum();
    }

    public void insertDailyPlan(DailyPlanVo dailyPlanVo) {
        this.educationMapper.insertDailyPlan(dailyPlanVo);
        List<ActivityVo> activitiyVoList = dailyPlanVo.getActivitiyVoList();
        for(ActivityVo activityVo : activitiyVoList) {
            this.educationMapper.insertActivity(activityVo);
        }
    }

    public List<DailyPlanVo> getAllDailyPlan(Map<String, Object> params) {
        return this.educationMapper.getAllDailyPlan(params);
    }

    public List<TeacherVo> searchTeacherByName(String keyword) {
        return this.educationMapper.searchTeacherByName(keyword);
    }

    public int getTotalCntDailyPlan() {
        return this.educationMapper.getTotalCntDailyPlan();
    }

    public DailyPlanVo getDailyPlanByNum(String num) {
        return this.educationMapper.getDailyPlanByNum(num);
    }

    public List<ActivityVo> getActivitiesByPlanNum(String num) {
        return this.educationMapper.getActivitiesByPlanNum(num);
    }

    public void modifyDailyPlan(DailyPlanVo dailyPlanVo) {
        this.educationMapper.deleteActivity(dailyPlanVo.getNum());
        this.educationMapper.modifyDailyPlan(dailyPlanVo);
        List<ActivityVo> activitiyVoList = dailyPlanVo.getActivitiyVoList();
        for(ActivityVo activityVo : activitiyVoList) {
            this.educationMapper.insertActivity(activityVo);
        }
    }

    public List<DailyPlanVo> searchPlan(Map<String, String> params) {
        return this.educationMapper.searchPlan(params);
    }

    public int getNextActivityRecordNum() {
        return this.educationMapper.getNextActivityRecordNum();
    }

    public void insertRecord(ActivityRecordVo activityRecordVo) {
        this.educationMapper.insertRecord(activityRecordVo);
    }

    public List<ActivityRecordVo> getAllActivityRecord(Map<String, Object> params) {
        return this.educationMapper.getAllActivityRecord(params);
    }

    public int getTotalCntRecord() {
        return this.educationMapper.getTotalCntRecord();
    }
}
