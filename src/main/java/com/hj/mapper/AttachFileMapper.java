package com.hj.mapper;

import com.hj.vo.AttachFileVo;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AttachFileMapper {
    void uploadFile(AttachFileVo attachFileVo);
}
