package com.hj.controller;

import com.hj.service.TeacherService;
import com.hj.vo.TeacherVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/teacher")
public class TeacherController {
    Logger log = LoggerFactory.getLogger(TeacherController.class);

    @Resource(name="teacherService")
    private TeacherService teacherService;

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
}
