package com.hj.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ActivityRecordVo {
    private int num;
    private int childNum;
    private int activityNum;
    private String record;
    private LocalDateTime regDate;
    private LocalDateTime updDate;

    private String childName;
    private LocalDateTime activityDate;
    private String activityContent;
}
