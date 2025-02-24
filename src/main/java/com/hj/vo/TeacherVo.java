package com.hj.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class TeacherVo {
    private String id;
    private String name;
    private String birth;
    private String auth;
    private String grade;
    private String delYn;
    private LocalDateTime regDate;
    private LocalDateTime updDate;
}
