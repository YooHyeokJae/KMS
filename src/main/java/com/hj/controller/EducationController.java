package com.hj.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
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
    public String dailyPlan(Model model) {
        List<DailyPlanVo> dailyPlanVoList = this.educationService.getAllDailyPlan();
        try {
            ObjectMapper mapper = new ObjectMapper();
            mapper.registerModule(new JavaTimeModule());
            String dailyPlanVoListJson = mapper.writeValueAsString(dailyPlanVoList);
            model.addAttribute("dailyPlanVoList", dailyPlanVoListJson);
        } catch(Exception e){
            log.error("{}", e.getMessage());
        }
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
    public String activity(Model model) {
        List<ActivityRecordVo> recordVoList = this.educationService.getAllActivityRecord();
        try {
            ObjectMapper mapper = new ObjectMapper();
            mapper.registerModule(new JavaTimeModule());
            String recordVoListJson = mapper.writeValueAsString(recordVoList);
            model.addAttribute("recordVoList", recordVoListJson);
        } catch(Exception e){
            log.error("{}", e.getMessage());
        }
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

    @PostMapping("/getCounselByChildNum")
    @ResponseBody
    public List<CounselVo> getCounselByChildNum(@RequestBody Map<String, Object> params) {
        int childNum = Integer.parseInt(params.get("childNum").toString());
        return this.educationService.getAllCounselByChildNum(childNum);
    }

    @PostMapping("/getCounselByNum")
    @ResponseBody
    public CounselVo getCounselByNum(@RequestBody Map<String, Object> params) {
        int num = Integer.parseInt(params.get("num").toString());
        return this.educationService.getCounselByNum(num);
    }

    @PostMapping("/counsel/nextNum")
    @ResponseBody
    public int nextNum() {
        return this.educationService.getNextCounselNum();
    }

    @PostMapping("/counsel/save")
    @ResponseBody
    public String counselSave(@RequestBody Map<String, Object> params) {
        int num = Integer.parseInt(params.get("num").toString());
        if(this.educationService.getCounselByNum(num) == null) {
            this.educationService.insertCounsel(params);
            return "insert";
        } else {
            this.educationService.modifyCounsel(params);
            return "modify";
        }
    }

    @GetMapping("/healthCheck")
    public String graduate(){
        return "health/list";
    }

    @PostMapping("/getHealthListByChildNum")
    @ResponseBody
    public List<HealthVo> getHealthListByChildNum(@RequestBody Map<String, Object> params){
        return this.educationService.getHealthListByChildNum(params);
    }

    @PostMapping("/saveHealthCheck")
    @ResponseBody
    public String saveHealthCheck(@RequestBody Map<String, Object> params) {
        String childNum = params.get("childNum").toString();
        @SuppressWarnings("unchecked")  // src/main/webapp/WEB-INF/views/health/list.jsp >> deleteList
        List<String> deleteList = (List<String>) params.get("deleteList");
        @SuppressWarnings("unchecked")  // src/main/webapp/WEB-INF/views/health/list.jsp >> deleteList
        List<Map<String, Object>> insertList = (List<Map<String, Object>>) params.get("insertList");

        if(!deleteList.isEmpty()){
            for(String num: deleteList) {
                this.educationService.deleteHealthCheckByNum(Integer.parseInt(num));
            }
        }
        if(!insertList.isEmpty()){
            for(Map<String, Object> param: insertList){
                if(param.get("num") != null){
                    this.educationService.updateHealthCheckByNum(param);
                }else{
                    int nextNum = this.educationService.getNextHealthCheckNum();
                    param.put("num", nextNum);
                    param.put("childNum", childNum);
                    this.educationService.insertHealthCheckByNum(param);
                }
            }
        }
        return childNum;
    }

    @PostMapping("/getGradeList")
    @ResponseBody
    public List<GradeVo> getGradeList() {
        return this.educationService.getGradeList();
    }

    @PostMapping(value = "/searchByCond", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String searchByCond(@RequestBody Map<String, Object> params) {
        List<DailyPlanVo> dailyPlanVoList = new ArrayList<>();
        List<ActivityRecordVo> activityRecordVoList = new ArrayList<>();
        if("dailyPlan".equals(params.get("cat"))){
            dailyPlanVoList = this.educationService.searchDailyPlanByCond(params);
        } else if("record".equals(params.get("cat"))){
            activityRecordVoList = this.educationService.searchRecordByCond(params);
        }
        try {
            ObjectMapper mapper = new ObjectMapper();
            mapper.registerModule(new JavaTimeModule());
            if("dailyPlan".equals(params.get("cat"))){
                return mapper.writeValueAsString(dailyPlanVoList);
            } else if("record".equals(params.get("cat"))){
                return mapper.writeValueAsString(activityRecordVoList);
            } else{
                log.error("NoCategory");
                return null;
            }
        } catch(Exception e){
            log.error("{}", e.getMessage());
            return null;
        }
    }

    @GetMapping("/attendance")
    public String attendance(Model model){
        LocalDate today = LocalDate.now();
        model.addAttribute("month", today.getMonthValue());
        List<GradeVo> gradeVoList = this.educationService.getGradeList();
        model.addAttribute("gradeVoList", gradeVoList);
        return "attendance/list";
    }

    @PostMapping("/getAttendanceByGrade")
    @ResponseBody
    public List<AttendanceVo> getAttendanceByGrade(@RequestBody Map<String, Object> params) {
        return this.educationService.getAttendanceByGrade(params);
    }

    @PostMapping("/attProc")
    @ResponseBody
    public Map<String, Object> attProc(@RequestBody Map<String, Object> params){
        this.educationService.attProc(params);
        return params;
    }

    @PostMapping("/getAttInfo")
    @ResponseBody
    public AttendanceVo getAttInfo(@RequestBody Map<String, Object> params) {
        return this.educationService.getAttInfo(params);
    }

    @PostMapping("/attAllProc")
    @ResponseBody
    public Map<String, Object> attAllProc(@RequestBody Map<String, Object> searchParams) {
        searchParams.put("graduated", "N");
        List<ChildVo> childVoList = this.childrenService.searchByCond(searchParams);

        Map<String, Object> insertParams = new HashMap<>();
        insertParams.put("date", searchParams.get("date"));
        insertParams.put("status", searchParams.get("status"));
        for(ChildVo childVo: childVoList){
            insertParams.put("childNum", childVo.getNum());
            this.educationService.attProc(insertParams);
        }
        return searchParams;
    }
}
