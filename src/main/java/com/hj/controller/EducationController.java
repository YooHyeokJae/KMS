package com.hj.controller;

import com.hj.service.EducationService;
import com.hj.vo.ActivityRecordVo;
import com.hj.vo.ActivityVo;
import com.hj.vo.DailyPlanVo;
import com.hj.vo.TeacherVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/education")
public class EducationController {
    Logger log = LoggerFactory.getLogger(EducationController.class);

    @Resource(name="educationService")
    private EducationService educationService;

    @GetMapping("/dailyPlan")
    public String dailyPlan(Model model) {
        List<DailyPlanVo> dailyPlanVoList = this.educationService.getAllDailyPlan();
        model.addAttribute("dailyPlanVoList", dailyPlanVoList);
        return "dailyPlan/list";
    }

    @PostMapping("/dailyPlan/insert")
    public String insert() {
        return "dailyPlan/popup/insertForm";
    }

    @PostMapping("/dailyPlan/insertData")
    @ResponseBody
    public String insertData(@RequestBody Map<String, String> params) {
        int dailyPlanNum = this.educationService.getNextDailyPlanNum();
        int activityNum = this.educationService.getNextActivityNum();

        DailyPlanVo dailyPlanVo = new DailyPlanVo();
        dailyPlanVo.setNum(dailyPlanNum);
        dailyPlanVo.setSeq(params.get("activitySeq"));
        dailyPlanVo.setActivityDate(LocalDate.parse(params.get("activityDate")));
        dailyPlanVo.setTeacherId(params.get("instructor"));
        dailyPlanVo.setLocation(params.get("location"));
        dailyPlanVo.setTarget(params.get("target"));
        dailyPlanVo.setGrade(params.get("grade"));
        dailyPlanVo.setSubject(params.get("subject"));
        dailyPlanVo.setGoals(params.get("goals"));
        dailyPlanVo.setMaterials(params.get("materials"));


        List<String> timeList = params.entrySet().stream().filter(entry -> entry.getKey().contains("time")).map(Map.Entry::getValue).collect(Collectors.toList());
        List<String> contentList = params.entrySet().stream().filter(entry -> entry.getKey().contains("content")).map(Map.Entry::getValue).collect(Collectors.toList());
        List<String> noteList = params.entrySet().stream().filter(entry -> entry.getKey().contains("note")).map(Map.Entry::getValue).collect(Collectors.toList());

        List<ActivityVo> activityVoList = new ArrayList<>();
        for(int i=0; i<timeList.size(); i++){
            ActivityVo activityVo = new ActivityVo();
            activityVo.setNum(activityNum + i);
            activityVo.setPlanNum(dailyPlanNum);
            activityVo.setActivityTime(timeList.get(i));
            activityVo.setContent(contentList.get(i));
            activityVo.setNote(noteList.get(i));
            activityVoList.add(activityVo);
        }
        dailyPlanVo.setActivitiyVoList(activityVoList);

        this.educationService.insertDailyPlan(dailyPlanVo);
        return "success";
    }

    @GetMapping("/activityRecord")
    public String activity() {
        return "activityRecord/list";
    }

    @GetMapping("/counsel")
    public String counsel() {
        return "counsel/list";
    }

    @PostMapping("/searchTeacher")
    @ResponseBody
    public List<TeacherVo> searchTeacher(@RequestBody String keyword) {
        return this.educationService.searchTeacherByName(keyword);
    }
}
