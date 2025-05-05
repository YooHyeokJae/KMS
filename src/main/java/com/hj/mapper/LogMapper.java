package com.hj.mapper;

import com.hj.vo.AccessLogVo;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LogMapper {
    void insertLog(AccessLogVo accessLogVo);
}
