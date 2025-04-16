package com.hj.vo;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class TeacherVo {
    private String id;
    private String name;
    private String profileImage;
    private LocalDate birth;
    private String major;
    private String grade;
    private String delYn;
    private LocalDate entryDate;
    private LocalDate delDate;
    private LocalDateTime regDate;
    private LocalDateTime updDate;
}
