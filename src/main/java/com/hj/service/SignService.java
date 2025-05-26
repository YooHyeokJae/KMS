package com.hj.service;

import com.hj.mapper.SignMapper;
import com.hj.util.PasswordEncoder;
import com.hj.vo.UserVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Map;

@Service
public class SignService {
    Logger log = LoggerFactory.getLogger(SignService.class);

    @Resource(name="signMapper")
    private SignMapper signMapper;

    public UserVo getUserByUserId(String userId) {
        return this.signMapper.getUserByUserId(userId);
    }

    public UserVo login(Map<String, Object> params) {
        UserVo userVo = this.getUserByUserId(params.get("userId").toString());
        if(userVo != null && PasswordEncoder.matches(params.get("userPw").toString(), userVo.getPassword())){
            return userVo;
        }
        return null;
    }

    public void insertUser(UserVo userVo) {
        // 비밀번호 암호화
        String plainPassword = userVo.getPassword();
        String encryptedPassword = PasswordEncoder.hashPassword(plainPassword);
        userVo.setPassword(encryptedPassword);

        this.signMapper.insertUser(userVo);
    }
}
