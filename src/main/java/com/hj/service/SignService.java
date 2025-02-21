package com.hj.service;

import com.hj.mapper.SignMapper;
import com.hj.vo.ChildVo;
import com.hj.vo.UserVo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class SignService {

    @Resource(name="signMapper")
    private SignMapper signMapper;

    public List<ChildVo> searchChild(String keyword) {
        return this.signMapper.searchChild(keyword);
    }

    public UserVo getUserByUserId(String userId) {
        return this.signMapper.getUserByUserId(userId);
    }

    public UserVo login(Map<String, Object> params) {
        return this.signMapper.login(params);
    }
}
