package com.hj.controller;

import com.hj.service.BoardService;
import com.hj.vo.BoardVo;
import com.hj.vo.ReplyVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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
        int totalCnt = this.boardService.getTotal(cat);
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
    public String insert(){
        return "board/insert";
    }

    @PostMapping("/insert")
    public String insert(@ModelAttribute BoardVo boardVo){
        log.info("boardVo: {}", boardVo);
        this.boardService.insertBoard(boardVo);
        return "redirect:/board/list?cat="+boardVo.getCategory();
    }

    @GetMapping("/detail")
    public String detail(Model model,
                         @RequestParam int num,
                         HttpServletRequest request,
                         HttpServletResponse response) {
        this.boardService.countView(num, request, response);
        BoardVo boardVo = this.boardService.getBoardByNum(num);
        model.addAttribute("boardVo", boardVo);
        List<ReplyVo> replyVoList = this.boardService.getReplyListByBoardNum(num);
        model.addAttribute("replyVoList", replyVoList);
        BoardVo prev = this.boardService.getPrev(boardVo);
        BoardVo next = this.boardService.getNext(boardVo);
        log.info("prev: {}", prev);
        log.info("next: {}", next);
        model.addAttribute("prev", prev);
        model.addAttribute("next", next);
        return "board/detail";
    }

    @PostMapping("/insertReply")
    @ResponseBody
    public String insertReply(@RequestBody Map<String, Object> params){
        ReplyVo replyVo = new ReplyVo();
        replyVo.setBoardNum(Integer.parseInt((String) params.get("boardNum")));
        replyVo.setContent((String) params.get("content"));
        replyVo.setWriterId((String) params.get("writerId"));
        this.boardService.insertReply(replyVo);
        return "success";
    }

    @GetMapping("/modify")
    public String modify(Model model,
                         @RequestParam int num){
        BoardVo boardVo = this.boardService.getBoardByNum(num);
        model.addAttribute("boardVo", boardVo);
        return "board/modify";
    }

    @PostMapping("/modify")
    public String modifyPost(Model model,
                         @RequestParam Map<String, Object> params){
        this.boardService.modifyBoard(params);
        return "redirect:/board/detail?num="+params.get("num");
    }

    @GetMapping("/delete")
    public String delete(@RequestParam int num){
        BoardVo boardVo = this.boardService.getBoardByNum(num);
        this.boardService.deleteBoard(num);
        return "redirect:/board/list?cat="+boardVo.getCategory();
    }
}
