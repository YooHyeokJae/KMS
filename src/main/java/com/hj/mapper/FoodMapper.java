package com.hj.mapper;

import com.hj.vo.FoodVo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface FoodMapper {
    List<FoodVo> selectAll();

    FoodVo select(FoodVo foodVo);

    void insert(FoodVo foodVo);

    void update(FoodVo foodVo);

    List<FoodVo> selectByYearMonth(String yearMonth);
}
