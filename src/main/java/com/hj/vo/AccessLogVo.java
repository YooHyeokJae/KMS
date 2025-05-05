package com.hj.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class AccessLogVo {
    private int num;
    private String userId;
    private String ipAddress;
    private String pageUrl;
    private LocalDateTime accessTime;

    public AccessLogVo(){}

    public AccessLogVo(String userId, String ipAddress, String pageUrl) {
        this.userId = userId;
        this.ipAddress = ipAddress;
        this.pageUrl = pageUrl;
    }
}
