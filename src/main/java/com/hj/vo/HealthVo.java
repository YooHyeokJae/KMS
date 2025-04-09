package com.hj.vo;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class HealthVo {
    private int num;
    private String hospital;
    private int childNum;
    private LocalDate checkDate;
    private String checkResult;
    private String delYn;
    private LocalDateTime regDate;
    private LocalDateTime updDate;

    private String childName;
}
