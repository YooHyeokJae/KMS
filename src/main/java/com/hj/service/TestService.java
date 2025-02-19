package com.hj.service;

import com.hj.mapper.TestMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class TestService {

    @Autowired
    TestMapper loginMapper;

    public String test(int keyCd) {
        return loginMapper.test(keyCd);
    }
}
