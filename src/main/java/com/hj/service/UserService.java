package com.hj.service;

import com.hj.mapper.UserMapper;
import com.hj.util.PasswordEncoder;
import com.hj.vo.UserVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class UserService {
    Logger log = LoggerFactory.getLogger(UserService.class);

    @Resource(name="userMapper")
    private UserMapper userMapper;
    @Resource(name="signService")
    private SignService signService;

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

    public String changeInfo(Map<String, Object> params, HttpSession session) {
        String curPw = params.get("curPw").toString();
        UserVo loginUser = (UserVo) session.getAttribute("loginUser");

        if(PasswordEncoder.matches(curPw, loginUser.getPassword())){
            // 1. 비밀번호 암호화
            String plainPassword = params.get("userPw").toString();
            log.info("{}", plainPassword);
            if(!"".equals(plainPassword)){
                String encryptedPassword = PasswordEncoder.hashPassword(plainPassword);
                params.put("userPw", encryptedPassword);
            }

            // 2. 정보 수정
            this.userMapper.changeInfo(params);

            // 3. session 정보 업데이트
            UserVo userVo = this.signService.login(params);
            session.setAttribute("loginUser", userVo);

            return "success";
        }else {
            return "wrongPw";
        }

    }
}
