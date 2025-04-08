package com.hj.vo;

import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;

@Data
public class ChildVo {
    private int num;
    private String name;
    private LocalDate birth;
    private LocalDate entryDate;
    private LocalDate graduateDate;
    private LocalDateTime regDate;
    private LocalDateTime updDate;
    private String grade;
    private String graduated;
    private String graduateReason;

    private String profilePath;
}
