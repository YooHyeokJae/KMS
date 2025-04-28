package com.hj.service;

import com.hj.mapper.BoardMapper;
import com.hj.vo.BoardVo;
import com.hj.vo.ReplyVo;
import com.hj.vo.UserVo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class BoardService {
    @Resource
    private BoardMapper boardMapper;

    public List<BoardVo> getList(Map<String, Object> params) {
        return this.boardMapper.getList(params);
    }

    public int getNextNum() {
        return this.boardMapper.getNextNum();
    }

    public void insertBoard(BoardVo boardVo) {
        this.boardMapper.insertBoard(boardVo);
    }

    public void countView(int num,
                          HttpServletRequest request,
                          HttpServletResponse response){
        // 조회 수 중복 방지
        Cookie oldCookie = null;
        Cookie[] cookies = request.getCookies();
        UserVo userVo = (UserVo) request.getSession().getAttribute("loginUser");
        String loginUserId = "guest";
        if(userVo != null){
            loginUserId = userVo.getId();
        }
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("postView")) {
                    oldCookie = cookie;
                }
            }
        }
        if (oldCookie != null) {
            System.out.println(oldCookie.getValue());
            if (!oldCookie.getValue().contains("["+ loginUserId + "_" + num +"]")) {
                this.boardMapper.viewBoard(num);
                oldCookie.setValue(oldCookie.getValue() + "_[" + loginUserId + "_" + num + "]");
                oldCookie.setPath("/");
                oldCookie.setMaxAge(60 * 60 * 24);
                response.addCookie(oldCookie);
            }
        } else {
            this.boardMapper.viewBoard(num);
            Cookie newCookie = new Cookie("postView", "[" + loginUserId + "_" + num + "]");
            newCookie.setPath("/");
            newCookie.setMaxAge(60 * 60 * 24);
            response.addCookie(newCookie);
            System.out.println(newCookie);
        }
    }

    public BoardVo getBoardByNum(int num) {
        return this.boardMapper.getBoardByNum(num);
    }

    public void insertReply(ReplyVo replyVo) {
        this.boardMapper.insertReply(replyVo);
    }

    public List<ReplyVo> getReplyListByBoardNum(int boardNum) {
        return this.boardMapper.getReplyListByBoardNum(boardNum);
    }

    public BoardVo getPrev(BoardVo boardVo) {
        return this.boardMapper.getPrev(boardVo);
    }

    public BoardVo getNext(BoardVo boardVo) {
        return this.boardMapper.getNext(boardVo);
    }

    public void modifyBoard(Map<String, Object> params) {
        this.boardMapper.modifyBoard(params);
    }

    public void deleteBoard(int num) {
        this.boardMapper.deleteBoard(num);
    }

    public List<BoardVo> getBestByDateOrViewOrLike(Map<String, Object> params) {
        return this.boardMapper.getBestByDateOrViewOrLike(params);
    }

    public String pressLike(Map<String, Object> params) {
        String checkLike = this.boardMapper.checkLike(params);
        if(checkLike != null){
            return checkLike;
        }
        this.boardMapper.insertHistory(params);
        this.boardMapper.pressLike(params);
        return this.boardMapper.getLikeCnt(params);
    }

    public String unPressLike(Map<String, Object> params) {
        this.boardMapper.deleteHistory(params);
        this.boardMapper.unPressLike(params);
        return this.boardMapper.getLikeCnt(params);
    }

    public List<BoardVo> searchByCond(Map<String, Object> params) {
        return this.boardMapper.searchByCond(params);
    }

    public String todayQuote() {
        return this.boardMapper.todayQuote();
    }
}
