package com.hj.vo;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;

@Data
public class ChildVo {
    private int num;
    private String name;
    private Date birth;
    private Date entryDate;
    private LocalDateTime regDate;
    private LocalDateTime updDate;
    private String graduated;
    private String grade;

    private String profilePath;
}
