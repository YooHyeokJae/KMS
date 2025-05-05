package com.hj.service;

import com.hj.mapper.LogMapper;
import com.hj.vo.AccessLogVo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class LogService {
    @Resource(name="logMapper")
    private LogMapper logMapper;

    public void insertLog(AccessLogVo accessLogVo) {
        this.logMapper.insertLog(accessLogVo);
    }
}
