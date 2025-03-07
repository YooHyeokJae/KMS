package com.hj.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class BoardVo {
    private int num;
    private String category;
    private String title;
    private String content;
    private String writerId;
    private int viewCnt;
    private int likeCnt;
    private String delYn;
    private LocalDateTime regDate;
    private LocalDateTime updDate;

    private long fileSize;
}
