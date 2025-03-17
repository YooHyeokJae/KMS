package com.hj.service;

import com.hj.mapper.EducationMapper;
import com.hj.vo.ActivityVo;
import com.hj.vo.DailyPlanVo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

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

    public List<DailyPlanVo> getAllDailyPlan() {
        return this.educationMapper.getAllDailyPlan();
    }
}
