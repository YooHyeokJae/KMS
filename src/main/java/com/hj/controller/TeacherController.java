package com.hj.controller;

import com.hj.service.AttachFileService;
import com.hj.service.EducationService;
import com.hj.service.TeacherService;
import com.hj.vo.AttachFileVo;
import com.hj.vo.ChildVo;
import com.hj.vo.GradeVo;
import com.hj.vo.TeacherVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import java.text.ParseException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping("/teacher")
public class TeacherController {
    Logger log = LoggerFactory.getLogger(TeacherController.class);

    @Resource(name="teacherService")
    private TeacherService teacherService;
    @Resource(name="attachFileService")
    private AttachFileService attachFileService;
    @Resource(name="educationService")
    private EducationService educationService;

    @GetMapping("/list")
    public String teacherList(Model model,
                              @RequestParam(defaultValue="1") int page,
                              @RequestParam(defaultValue="10") int count) {
        int totalCnt = this.teacherService.getTotal();
        int pageBlock = 10;
        int pageStart = ((page-1) / pageBlock) * pageBlock + 1;
        model.addAttribute("currentPage", page);
        model.addAttribute("pageStart", pageStart);
        model.addAttribute("pageBlock", pageBlock);
        int start = (page-1)*count;
        Map<String, Object> params = new HashMap<>();
        params.put("start", start);
        params.put("count", count);
        List<TeacherVo> teacherVoList = this.teacherService.getList(params);
        model.addAttribute("count", count);
        model.addAttribute("totalCnt", totalCnt);
        model.addAttribute("teacherVoList", teacherVoList);
        return "teacher/list";
    }

    @PostMapping("/info")
    public String teacherInfo(Model model, @RequestParam String id) {
        TeacherVo teacherVo = this.teacherService.getInfo(id);
        model.addAttribute("teacherVo", teacherVo);
        return "teacher/popup/info";
    }

    @PostMapping("/insertWindow")
    public String teacherInsertWindow(Model model) {
        List<GradeVo> gradeList = this.educationService.getGradeList();
        model.addAttribute("gradeList", gradeList);
        return "teacher/popup/insert";
    }

    @PostMapping("/insert")
    public String insert(@RequestParam(required = false) MultipartFile profileImage,
                         @RequestParam String name,
                         @RequestParam String grade,
                         @RequestParam String major,
                         @RequestParam String birth,
                         @RequestParam String entryDate) throws ParseException {
        String id = UUID.randomUUID().toString().substring(0, 20);
        while(this.teacherService.findById(id) > 0){
            id = UUID.randomUUID().toString().substring(0, 20);
        }
        // 교원 객체 저장
        TeacherVo teacherVo = new TeacherVo();
        teacherVo.setId(id);
        teacherVo.setName(name);
        teacherVo.setGrade(grade);
        teacherVo.setMajor(major);
        teacherVo.setBirth(LocalDate.parse(birth));
        teacherVo.setEntryDate(LocalDate.parse(entryDate));
        this.teacherService.insertTeacher(teacherVo);

        // 파일 업로드
        if(profileImage != null){
            // db에 파일 정보 저장
            this.attachFileService.uploadFile(profileImage, "teacher/"+id);
        }
        return "redirect:/teacher/list";
    }

    @PostMapping("/modify")
    @ResponseBody
    public String modify(@RequestParam String id,
                         @RequestParam(required = false) MultipartFile profileImage,
                         @RequestParam String name,
                         @RequestParam String grade,
                         @RequestParam String major,
                         @RequestParam String birth,
                         @RequestParam String entryDate) {
        LocalDateTime now = LocalDateTime.now();
        TeacherVo teacherVo = new TeacherVo();
        teacherVo.setId(id);
        teacherVo.setName(name);
        teacherVo.setGrade(grade);
        teacherVo.setMajor(major);
        teacherVo.setBirth(LocalDate.parse(birth));
        teacherVo.setEntryDate(LocalDate.parse(entryDate));
        this.teacherService.modifyTeacher(teacherVo);

        if(profileImage != null){
            List<AttachFileVo> attachFileVoList = this.attachFileService.findByGlobalCode("teacher/"+id);
            if(!attachFileVoList.isEmpty()){
                this.attachFileService.deleteByGlobalCode("teacher/"+id);
            }
            this.attachFileService.uploadFile(profileImage, "teacher/"+id);
        }
        return now.toString().substring(0, 19);
    }

    @PostMapping("/delete")
    @ResponseBody
    public String delete(@RequestBody Map<String, Object> params) {
        this.teacherService.delete(params);
        return "success";
    }
}
