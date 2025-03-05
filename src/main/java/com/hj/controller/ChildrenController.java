package com.hj.controller;

import com.hj.service.AttachFileService;
import com.hj.service.ChildrenService;
import com.hj.vo.ChildVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.Part;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.*;

@Controller
@RequestMapping("/children")
public class ChildrenController {
    Logger log = LoggerFactory.getLogger(ChildrenController.class);

    @Resource(name="childrenService")
    private ChildrenService childrenService;
    @Resource(name="attachFileService")
    private AttachFileService attachFileService;

    @GetMapping("/list")
    public String list(Model model,
                       @RequestParam(defaultValue="1") int page,
                       @RequestParam(defaultValue="10") int count) {

        int totalCnt = this.childrenService.getTotal();
        int pageBlock = 10;
        int pageStart = ((page-1) / pageBlock) * pageBlock + 1;
        model.addAttribute("currentPage", page);
        model.addAttribute("pageStart", pageStart);
        model.addAttribute("pageBlock", pageBlock);
        int start = (page-1)*count;
        Map<String, Object> params = new HashMap<>();
        params.put("start", start);
        params.put("count", count);
        List<ChildVo> childVoList = this.childrenService.getList(params);
        model.addAttribute("count", count);
        model.addAttribute("totalCnt", totalCnt);
        model.addAttribute("childVoList", childVoList);
        return "children/list";
    }

    @PostMapping("/info")
    public String childInfo(Model model, @RequestParam String num) {
        ChildVo childVo = this.childrenService.getInfo(Integer.parseInt(num));
        model.addAttribute("childVo", childVo);
        return "children/popup/info";
    }

    @PostMapping("/insertWindow")
    public String insertWindow(){
        return "children/popup/insert";
    }

    @PostMapping("/insert")
    public String insert(@RequestParam(required = false) MultipartFile profileImage,
                         @RequestParam String name,
                         @RequestParam String grade,
                         @RequestParam String birth,
                         @RequestParam String entryDate) throws ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        int num = this.childrenService.getNextNum();
        // 원생 객체 저장
        ChildVo childVo = new ChildVo();
        childVo.setNum(num);
        childVo.setName(name);
        childVo.setBirth(sdf.parse(birth));
        childVo.setEntryDate(sdf.parse(entryDate));
        childVo.setGrade(grade);
        this.childrenService.insertChild(childVo);

        // 파일 업로드
        if(profileImage != null){
            // db에 파일 정보 저장
            this.attachFileService.uploadFile(profileImage, String.valueOf(num));
        }
        return "redirect:/children/list";
    }
}
