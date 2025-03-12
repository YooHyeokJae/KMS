package com.hj.service;

import com.hj.mapper.FoodMapper;
import com.hj.vo.FoodVo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class FoodService {
    @Resource(name="foodMapper")
    private FoodMapper foodMapper;

    public List<FoodVo> selectAll() {
        return this.foodMapper.selectAll();
    }

    public void update(FoodVo foodVo) {
        FoodVo savedFoodVo = this.foodMapper.select(foodVo);
        if(savedFoodVo == null && !foodVo.getMeal().isEmpty()){
            this.foodMapper.insert(foodVo);
        }else{
            this.foodMapper.update(foodVo);
        }
    }

    public List<FoodVo> selectByYearMonth(String yearMonth) {
        return this.foodMapper.selectByYearMonth(yearMonth);
    }
}
