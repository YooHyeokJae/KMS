package com.hj.service;

import com.hj.controller.ChildrenController;
import com.hj.mapper.AttachFileMapper;
import com.hj.vo.AttachFileVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@Service
public class AttachFileService {
    Logger log = LoggerFactory.getLogger(AttachFileService.class);

    @Resource(name="attachFileMapper")
    private AttachFileMapper attachFileMapper;

//    private final String fileDir = "/upload/"; // 윈도우용
    private final String fileDir = "/home/pi/upload/"; // 리눅스용

    public void uploadFile(MultipartFile multipartFile, String globalCode) {
        String ext = multipartFile.getOriginalFilename().substring(multipartFile.getOriginalFilename().lastIndexOf("."));
        String storedFileName = UUID.randomUUID() + ext;
        try {
            multipartFile.transferTo(new File(storedFileName));

            AttachFileVo attachFileVo = new AttachFileVo();
            attachFileVo.setGlobalCode(globalCode);
            attachFileVo.setStoredFileName(fileDir + storedFileName);
            attachFileVo.setOriginalFileName(multipartFile.getOriginalFilename());
            attachFileVo.setExtension(ext);
            attachFileVo.setContentType(multipartFile.getContentType());
            attachFileVo.setFileSize(multipartFile.getSize());
            this.attachFileMapper.uploadFile(attachFileVo);
        } catch (IOException e) {
            log.error(e.getMessage());
        }
    }

    public List<AttachFileVo> findByGlobalCode(String globalCode) {
        return this.attachFileMapper.findByGlobalCode(globalCode);
    }

    public void deleteByGlobalCode(String globalCode) {
        this.attachFileMapper.deleteByGlobalCode(globalCode);
    }
}
