package com.hj.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class CalendarVo {
    private int num;
    private String writerId;
    private String title;
    private LocalDateTime strDate;
    private LocalDateTime endDate;
    private String auth;
    private String delYn;
}
