package com.hj.controller;

import com.hj.service.ChildrenService;
import com.hj.service.EducationService;
import com.hj.vo.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/education")
public class EducationController {
    Logger log = LoggerFactory.getLogger(EducationController.class);

    @Resource(name="educationService")
    private EducationService educationService;
    @Resource(name="childrenService")
    private ChildrenService childrenService;

    @GetMapping("/dailyPlan")
    public String dailyPlan(Model model,
                            @RequestParam(defaultValue="1") int page,
                            @RequestParam(defaultValue="10") int count) {
        int totalCnt = this.educationService.getTotalCntDailyPlan();
        int pageBlock = 10;
        int pageStart = ((page-1) / pageBlock) * pageBlock + 1;
        model.addAttribute("currentPage", page);
        model.addAttribute("pageStart", pageStart);
        model.addAttribute("pageBlock", pageBlock);
        int start = (page-1)*count;
        Map<String, Object> params = new HashMap<>();
        params.put("start", start);
        params.put("count", count);
        List<DailyPlanVo> dailyPlanVoList = this.educationService.getAllDailyPlan(params);
        model.addAttribute("count", count);
        model.addAttribute("totalCnt", totalCnt);
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

    @PostMapping("/searchTeacher")
    @ResponseBody
    public List<TeacherVo> searchTeacher(@RequestBody String keyword) {
        return this.educationService.searchTeacherByName(keyword);
    }

    @PostMapping("/dailyPlan/info")
    public String info(Model model,
                       @RequestBody String data) {
        String num = data.split("=")[1];
        DailyPlanVo dailyPlanVo = this.educationService.getDailyPlanByNum(num);
        List<ActivityVo> activityVoList = this.educationService.getActivitiesByPlanNum(num);
        dailyPlanVo.setActivitiyVoList(activityVoList);
        model.addAttribute("dailyPlanVo", dailyPlanVo);
        log.info("dailyPlanVo: {}", dailyPlanVo);
        return "dailyPlan/popup/info";
    }

    @PostMapping("/dailyPlan/modifyData")
    @ResponseBody
    public String modifyData(@RequestBody Map<String, String> params) {
        int dailyPlanNum = Integer.parseInt(params.get("num"));
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
            if(!timeList.get(i).isEmpty() || !contentList.get(i).isEmpty() || !noteList.get(i).isEmpty()){
                ActivityVo activityVo = new ActivityVo();
                activityVo.setNum(activityNum + i);
                activityVo.setPlanNum(dailyPlanNum);
                activityVo.setActivityTime(timeList.get(i));
                activityVo.setContent(contentList.get(i));
                activityVo.setNote(noteList.get(i));
                activityVoList.add(activityVo);
            }
        }
        dailyPlanVo.setActivitiyVoList(activityVoList);

        this.educationService.modifyDailyPlan(dailyPlanVo);
        return "success";
    }

    @GetMapping("/activityRecord")
    public String activity(Model model,
                           @RequestParam(defaultValue="1") int page,
                           @RequestParam(defaultValue="10") int count) {

        int totalCnt = this.educationService.getTotalCntRecord();
        int pageBlock = 10;
        int pageStart = ((page-1) / pageBlock) * pageBlock + 1;
        model.addAttribute("currentPage", page);
        model.addAttribute("pageStart", pageStart);
        model.addAttribute("pageBlock", pageBlock);
        int start = (page-1)*count;
        Map<String, Object> params = new HashMap<>();
        params.put("start", start);
        params.put("count", count);
        List<ActivityRecordVo> recordVoList = this.educationService.getAllActivityRecord(params);
        model.addAttribute("count", count);
        model.addAttribute("totalCnt", totalCnt);
        model.addAttribute("recordVoList", recordVoList);
        return "activityRecord/list";
    }

    @GetMapping("/recordInsert")
    public String recordInsert() {
        return "activityRecord/insert";
    }

    @PostMapping("/searchChild")
    @ResponseBody
    public List<ChildVo> searchChild(@RequestBody Map<String, String> params) {
        return this.childrenService.searchChild(params);
    }

    @PostMapping("/searchPlan")
    @ResponseBody
    public List<DailyPlanVo> searchPlan(@RequestBody Map<String, String> params) {
        return this.educationService.searchPlan(params);
    }

    @PostMapping("/getActivityList")
    @ResponseBody
    public List<ActivityVo> getActivityList(@RequestBody Map<String, String> params) {
        return this.educationService.getActivitiesByPlanNum(params.get("num"));
    }

    @PostMapping("/insertRecord")
    @ResponseBody
    public String insertRecord(@RequestBody Map<String, Object> params) {
        int nextNum = this.educationService.getNextActivityRecordNum();

        @SuppressWarnings("unchecked")  // src/main/webapp/WEB-INF/views/activityRecord/insert.jsp >> childList
        List<String> childList = (List<String>) params.get("childList");
        @SuppressWarnings("unchecked")  // src/main/webapp/WEB-INF/views/activityRecord/insert.jsp >> activityRecords
        Map<String, String> activityRecords = (Map<String, String>) params.get("activityRecords");

        ActivityRecordVo activityRecordVo = new ActivityRecordVo();
        for(String child : childList){
            activityRecordVo.setChildNum(Integer.parseInt(child));

            for(String key : activityRecords.keySet()){
                int activityNum = Integer.parseInt(key);
                activityRecordVo.setActivityNum(activityNum);
                activityRecordVo.setRecord(activityRecords.get(key));
                if(!"".equals(activityRecordVo.getRecord())){
                    activityRecordVo.setNum(nextNum++);
                    this.educationService.insertRecord(activityRecordVo);
                }
            }
        }

        return "success";
    }

    @GetMapping("/counsel")
    public String counsel() {
        return "counsel/list";
    }
}
