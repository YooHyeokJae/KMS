package com.hj.service;

import com.hj.mapper.UserMapper;
import com.hj.vo.UserVo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class UserService {

    @Resource(name="userMapper")
    private UserMapper userMapper;

    public List<UserVo> getList(Map<String, Object> params) {
        List<UserVo> result = new ArrayList<>();
        String gubun = params.get("gubun").toString();
        if("user".equals(gubun)){
            result = this.userMapper.getUserList(params);
        }else if("waiting".equals(gubun)){
            result = this.userMapper.getWaitingList(params);
        }
        return result;
    }

    public void changeAuth(Map<String, Object> params) {
        this.userMapper.changeAuth(params);
    }

    public List<UserVo> searchId(Map<String, Object> params) {
        return this.userMapper.searchId(params);
    }

    public List<UserVo> searchPw(Map<String, Object> params) {
        return this.userMapper.searchPw(params);
    }
}
