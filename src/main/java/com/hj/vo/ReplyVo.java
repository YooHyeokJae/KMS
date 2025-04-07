package com.hj.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ReplyVo {
    private int num;
    private int boardNum;
    private String content;
    private String writerId;
    private LocalDateTime regDate;
    private String delYn;

    private String writerName;
}
