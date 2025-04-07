package com.hj.controller;

import com.hj.service.AttachFileService;
import com.hj.service.ChildrenService;
import com.hj.util.Utils;
import com.hj.vo.AttachFileVo;
import com.hj.vo.ChildVo;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import java.io.IOException;
import java.io.InputStream;
import java.text.ParseException;
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

        int totalCnt = this.childrenService.getTotal("N");
        int pageBlock = 10;
        int pageStart = ((page-1) / pageBlock) * pageBlock + 1;
        model.addAttribute("currentPage", page);
        model.addAttribute("pageStart", pageStart);
        model.addAttribute("pageBlock", pageBlock);
        int start = (page-1)*count;
        Map<String, Object> params = new HashMap<>();
        params.put("start", start);
        params.put("count", count);
        params.put("graduated", "N");
        List<ChildVo> childVoList = this.childrenService.getList(params);
        model.addAttribute("count", count);
        model.addAttribute("totalCnt", totalCnt);
        model.addAttribute("childVoList", childVoList);
        return "children/list";
    }

    @GetMapping("/graduatedList")
    public String graduatedList(Model model,
                                @RequestParam(defaultValue="1") int page,
                                @RequestParam(defaultValue="10") int count){
        int totalCnt = this.childrenService.getTotal("Y");
        int pageBlock = 10;
        int pageStart = ((page-1) / pageBlock) * pageBlock + 1;
        model.addAttribute("currentPage", page);
        model.addAttribute("pageStart", pageStart);
        model.addAttribute("pageBlock", pageBlock);
        int start = (page-1)*count;
        Map<String, Object> params = new HashMap<>();
        params.put("start", start);
        params.put("count", count);
        params.put("graduated", "Y");
        List<ChildVo> childVoList = this.childrenService.getList(params);
        model.addAttribute("count", count);
        model.addAttribute("totalCnt", totalCnt);
        model.addAttribute("childVoList", childVoList);
        return "children/graduatedList";
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
        int num = this.childrenService.getNextNum();
        // 원생 객체 저장
        ChildVo childVo = new ChildVo();
        childVo.setNum(num);
        childVo.setName(name);
        childVo.setBirth(LocalDate.parse(birth));
        childVo.setEntryDate(LocalDate.parse(entryDate));
        childVo.setGrade(grade);
        this.childrenService.insertChild(childVo);

        // 파일 업로드
        if(profileImage != null){
            // db에 파일 정보 저장
            this.attachFileService.uploadFile(profileImage, "child/"+num);
        }
        return "redirect:/children/list";
    }

    @PostMapping("/modify")
    @ResponseBody
    public String modify(@RequestParam String num,
                         @RequestParam(required = false) MultipartFile profileImage,
                         @RequestParam String name,
                         @RequestParam String grade,
                         @RequestParam String birth,
                         @RequestParam String entryDate) {
        ChildVo childVo = new ChildVo();
        childVo.setNum(Integer.parseInt(num));
        childVo.setName(name);
        childVo.setBirth(LocalDate.parse(birth));
        childVo.setEntryDate(LocalDate.parse(entryDate));
        childVo.setGrade(grade);
        this.childrenService.modifyChild(childVo);

        if(profileImage != null){
            List<AttachFileVo> attachFileVoList = this.attachFileService.findByGlobalCode("child/"+num);
            if(!attachFileVoList.isEmpty()){
                this.attachFileService.deleteByGlobalCode("child/"+num);
            }
            this.attachFileService.uploadFile(profileImage, "child/"+num);
        }
        return "success";
    }

    @PostMapping("/insertBatch")
    public String insertBatch(@RequestParam MultipartFile file){
        List<ChildVo> childVoList = new ArrayList<>();
        int startNum = this.childrenService.getNextNum();
        try {
            InputStream inputStream = file.getInputStream();
            Workbook workbook = new XSSFWorkbook(inputStream);
            Sheet sheet = workbook.getSheetAt(0);

            for (int i=2; i<=sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if(row == null) continue;
                Cell numCell = row.getCell(0);
                Cell nameCell = row.getCell(1);
                Cell birthCell = row.getCell(2);
                Cell entryDateCell = row.getCell(3);
                Cell gradeCell = row.getCell(4);

                ChildVo childVo = new ChildVo();
                childVo.setNum(startNum + (i-2));
                childVo.setName(Utils.getCellValueAsString(nameCell));
                childVo.setBirth(LocalDate.parse(Utils.getCellValueAsString(birthCell)));
                childVo.setEntryDate(LocalDate.parse(Utils.getCellValueAsString(entryDateCell)));
                childVo.setGrade(Utils.getCellValueAsString(gradeCell));

                childVoList.add(childVo);
            }

            workbook.close();
        } catch (IOException e) {
            log.error(e.getMessage());
        }

        this.childrenService.insertChildBatch(childVoList);
        return "redirect:/children/list";
    }
}
