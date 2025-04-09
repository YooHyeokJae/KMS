package com.hj.service;

import com.hj.mapper.StatisticsMapper;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class StatisticsService {

    @Resource(name="statisticsMapper")
    private StatisticsMapper statisticsMapper;
}
