package com.hj.vo;

import lombok.Data;

@Data
public class StatsVo {
    private String year;
    private int entryCnt;
    private int graduateCnt;
    private int teacherCnt;

    private String grade;
    private int studentCnt;
}
