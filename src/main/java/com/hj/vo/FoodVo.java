package com.hj.vo;

import lombok.Data;

import java.time.LocalDate;

@Data
public class FoodVo {
    private LocalDate mealDate;
    private String meal;
}
