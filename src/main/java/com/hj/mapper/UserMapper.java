package com.hj.mapper;

import com.hj.vo.UserVo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface UserMapper {
    List<UserVo> getUserList(Map<String, Object> params);

    List<UserVo> getWaitingList(Map<String, Object> params);

    void changeAuth(Map<String, Object> params);

    List<UserVo> searchId(Map<String, Object> params);

    List<UserVo> searchPw(Map<String, Object> params);

    void changeInfo(Map<String, Object> params);
}
