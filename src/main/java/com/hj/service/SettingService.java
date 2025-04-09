package com.hj.service;

import com.hj.mapper.SettingMapper;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class SettingService {

    @Resource(name="settingMapper")
    private SettingMapper settingMapper;
}
