package com.hj.mapper;

import com.hj.vo.AlbumVo;
import com.hj.vo.BoardVo;
import com.hj.vo.ReplyVo;
import org.apache.ibatis.annotations.Mapper;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Mapper
public interface BoardMapper {
    List<BoardVo> getList(Map<String, Object> params);

    int getNextNum();

    void insertBoard(BoardVo boardVo);

    void viewBoard(int num);

    BoardVo getBoardByNum(int num);

    void insertReply(ReplyVo replyVo);

    List<ReplyVo> getReplyListByBoardNum(int boardNum);

    BoardVo getPrev(BoardVo boardVo);
    
    BoardVo getNext(BoardVo boardVo);

    void modifyBoard(Map<String, Object> params);

    void deleteBoard(int num);

    List<BoardVo> getBestByDateOrViewOrLike(Map<String, Object> params);

    String checkLike(Map<String, Object> params);

    void insertHistory(Map<String, Object> params);

    void pressLike(Map<String, Object> params);

    void deleteHistory(Map<String, Object> params);

    void unPressLike(Map<String, Object> params);

    String getLikeCnt(Map<String, Object> params);

    List<BoardVo> searchByCond(Map<String, Object> params);

    String todayQuote();

    void insertAlbum(AlbumVo albumVo);

    int getLastAlbumNum();

    List<AlbumVo> getAlbum(Map<String, Object> params);
}
