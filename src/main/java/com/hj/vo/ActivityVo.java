package com.hj.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ActivityVo {
    private int num;
    private int planNum;
    private String activityTime;
    private String content;
    private String note;
    private LocalDateTime regDate;
    private LocalDateTime updDate;
}
