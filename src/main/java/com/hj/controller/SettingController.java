package com.hj.controller;

import com.hj.service.SettingService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;

@Controller
@RequestMapping("/setting")
public class SettingController {
    Logger log = LoggerFactory.getLogger(SettingController.class);

    @Resource(name="settingService")
    private SettingService settingService;

    @GetMapping("/")
    public String setting(Model model) {
        return "setting/setting";
    }
}
