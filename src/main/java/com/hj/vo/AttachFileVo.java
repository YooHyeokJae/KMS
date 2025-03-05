package com.hj.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class AttachFileVo {
    private int num;
    private String globalCode;
    private String OriginalFileName;
    private String StoredFileName;
    private String extension;
    private String contentType;
    private long fileSize;
    private LocalDateTime regDate;
    private String delYn;
}
