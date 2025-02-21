package com.hj.mapper;

import com.hj.vo.ChildVo;
import com.hj.vo.UserVo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface SignMapper {
    List<ChildVo> searchChild(String keyword);

    UserVo getUserByUserId(String userId);

    UserVo login(Map<String,Object> map);
}
