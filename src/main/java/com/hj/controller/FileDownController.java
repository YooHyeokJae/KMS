package com.hj.controller;

import com.hj.service.AttachFileService;
import com.hj.vo.AttachFileVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;

@Controller
@RequestMapping("/download")
public class FileDownController {
    Logger log = LoggerFactory.getLogger(FileDownController.class);

    @Resource(name="attachFileService")
    AttachFileService attachFileService;

    @GetMapping("/board/{num}")
    public ResponseEntity<FileSystemResource> downloadFile(@PathVariable String num) throws UnsupportedEncodingException {
        List<AttachFileVo> attachFileVoList = this.attachFileService.findByGlobalCode("board/" + num);
        File file = new File(attachFileVoList.get(0).getStoredFileName());

        if (!file.exists()) {
            return ResponseEntity.notFound().build();  // 파일이 존재하지 않으면 404
        }
        // FileSystemResource를 사용해 파일을 응답으로 반환
        FileSystemResource resource = new FileSystemResource(file);

        String encodedFileName = URLEncoder.encode(attachFileVoList.get(0).getOriginalFileName(), "UTF-8").replaceAll("\\+", "%20");

        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_OCTET_STREAM)
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodedFileName)
                .body(resource);  // 파일을 다운로드 응답으로 반환
    }
}
