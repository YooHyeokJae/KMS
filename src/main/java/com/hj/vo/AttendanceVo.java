package com.hj.vo;

import lombok.Data;

import java.time.LocalDate;

@Data
public class AttendanceVo {
    private int num;
    private int childNum;
    private LocalDate attDate;
    private String status;
    private String note;

    private String childName;
}
