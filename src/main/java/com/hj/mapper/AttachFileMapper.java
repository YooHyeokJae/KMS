package com.hj.mapper;

import com.hj.vo.AttachFileVo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface AttachFileMapper {
    void uploadFile(AttachFileVo attachFileVo);

    List<AttachFileVo> findByGlobalCode(String globalCode);

    void deleteByGlobalCode(String globalCode);
}
