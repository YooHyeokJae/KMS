package com.hj.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.hj.service.AttachFileService;
import com.hj.service.BoardService;
import com.hj.vo.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/board")
public class BoardController {
    Logger log = LoggerFactory.getLogger(BoardController.class);

    @Resource(name="boardService")
    private BoardService boardService;
    @Resource(name="attachFileService")
    private AttachFileService attachFileService;

    @GetMapping("/list")
    public String list(Model model,
                       @RequestParam String cat) {
        Map<String, Object> params = new HashMap<>();
        params.put("cat", cat);
        List<BoardVo> boardVoList = this.boardService.getList(params);
        try {
            ObjectMapper mapper = new ObjectMapper();
            mapper.registerModule(new JavaTimeModule());
            String boardVoListJson = mapper.writeValueAsString(boardVoList);
            model.addAttribute("boardVoList", boardVoListJson);
        } catch(Exception e){
            log.error("{}", e.getMessage());
        }
        model.addAttribute("category", cat);
        return "board/list";
    }

    @GetMapping("/insert")
    public String insert(){
        return "board/insert";
    }

    @PostMapping("/insert")
    public String insert(@ModelAttribute BoardVo boardVo){
        boardVo.setNum(this.boardService.getNextNum());
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

    @GetMapping("/form")
    public String form(Model model) {
        String cat = "form";
        Map<String, Object> params = new HashMap<>();
        params.put("cat", cat);
        List<BoardVo> boardVoList = this.boardService.getList(params);
        model.addAttribute("category", cat);
        try {
            ObjectMapper mapper = new ObjectMapper();
            mapper.registerModule(new JavaTimeModule());
            String boardVoListJson = mapper.writeValueAsString(boardVoList);
            model.addAttribute("boardVoList", boardVoListJson);
        } catch(Exception e){
            log.error("{}", e.getMessage());
        }
        return "board/form";
    }

    @PostMapping("/uploadForm")
    @ResponseBody
    public String uploadForm(HttpSession session,
                             @RequestParam("files[]") MultipartFile[] files){
        UserVo userVo = (UserVo) session.getAttribute("loginUser");
        int startNum = this.boardService.getNextNum();
        for(MultipartFile file : files){
            BoardVo boardVo = new BoardVo();
            boardVo.setNum(startNum++);
            boardVo.setCategory("form");
            boardVo.setTitle(file.getOriginalFilename());
            boardVo.setWriterId(userVo.getId());

            this.attachFileService.uploadFile(file, "board/" + boardVo.getNum());
            this.boardService.insertBoard(boardVo);
        }
        return "success";
    }

    @PostMapping("/getBest")
    @ResponseBody
    private List<BoardVo> getBest(@RequestBody Map<String, Object> params){
        return this.boardService.getBestByDateOrViewOrLike(params);
    }

    @PostMapping("/pressLike")
    @ResponseBody
    public String pressLike(@RequestBody Map<String, Object> params){
        return this.boardService.pressLike(params);
    }

    @PostMapping("/unPressLike")
    @ResponseBody
    public String unPressLike(@RequestBody Map<String, Object> params){
        return this.boardService.unPressLike(params);
    }

    @PostMapping(value = "/searchByCond", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String searchByCond(@RequestBody Map<String, Object> params) {
        List<BoardVo> boardVoList = this.boardService.searchByCond(params);
        try {
            ObjectMapper mapper = new ObjectMapper();
            mapper.registerModule(new JavaTimeModule());
            return mapper.writeValueAsString(boardVoList);
        } catch(Exception e){
            log.error("{}", e.getMessage());
            return null;
        }
    }
}
