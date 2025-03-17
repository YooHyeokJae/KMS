package com.hj.vo;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class DailyPlanVo {
    private int num;
    private String seq;
    private LocalDate activityDate;
    private String teacherId;
    private String location;
    private String target;
    private String grade;
    private String subject;
    private String goals;
    private String materials;
    private LocalDateTime regDate;
    private LocalDateTime updDate;

    private List<ActivityVo> activitiyVoList;
}
