package com.hj.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class UserVo {
    private String id;
    private String password;
    private String name;
    private String auth;
    private String email;
    private String telNo;
    private int childNum;
    private String relation;
    private String delYn;
    private LocalDateTime regDate;
    private LocalDateTime updDate;

    private String childName;
}
