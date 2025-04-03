package com.hj.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class CounselVo {
    private int num;
    private String category;
    private String instructorId;
    private LocalDateTime counselDate;
    private int childNum;
    private String counselNote;
    private LocalDateTime regDate;
    private LocalDateTime updDate;

    private String instructorName;
    private String childName;
}
