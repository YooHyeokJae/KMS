package com.hj.mapper;

import com.hj.vo.ChildVo;
import com.hj.vo.UserVo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface SignMapper {
    UserVo getUserByUserId(String userId);

    void insertUser(UserVo userVo);
}
