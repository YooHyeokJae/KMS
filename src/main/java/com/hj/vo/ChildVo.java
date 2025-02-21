package com.hj.vo;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class ChildVo {
    private int num;
    private String name;
    private LocalDate birth;
    private LocalDateTime regDate;
    private LocalDateTime updDate;
    private String graduated;
    private String grade;
}
