package com.hj.controller;

import com.hj.service.BoardService;
import com.hj.vo.BoardVo;
import com.hj.vo.TeacherVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/board")
public class BoardController {
    Logger log = LoggerFactory.getLogger(BoardController.class);

    @Resource
    private BoardService boardService;

    @GetMapping("/list")
    public String list(Model model,
                       @RequestParam String cat,
                       @RequestParam(defaultValue="1") int page,
                       @RequestParam(defaultValue="10") int count) {
        int totalCnt = this.boardService.getTotal();
        int pageBlock = 10;
        int pageStart = ((page-1) / pageBlock) * pageBlock + 1;
        model.addAttribute("currentPage", page);
        model.addAttribute("pageStart", pageStart);
        model.addAttribute("count", count);
        model.addAttribute("totalCnt", totalCnt);
        model.addAttribute("pageBlock", pageBlock);
        int start = (page-1)*count;
        Map<String, Object> params = new HashMap<>();
        params.put("start", start);
        params.put("count", count);
        params.put("cat", cat);
        List<BoardVo> boardVoList = this.boardService.getList(params);
        model.addAttribute("category", cat);
        model.addAttribute("boardVoList", boardVoList);
        return "board/list";
    }

    @GetMapping("/insert")
    public String insert(Model model){
        return "board/insert";
    }
}
