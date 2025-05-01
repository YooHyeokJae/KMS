package com.hj.vo;

import lombok.Data;

@Data
public class AlbumVo {
    private int num;
    private String originalFileName;
    private String fileName;
    private String description;
    private long fileSize;

    public AlbumVo(){}

    public AlbumVo(String originalFileName, String filename, String description, long fileSize) {
        this.originalFileName = originalFileName;
        this.fileName = filename;
        this.description = description;
        this.fileSize = fileSize;
    }
}
