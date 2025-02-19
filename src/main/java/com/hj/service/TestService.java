package com.hj.service;

import com.hj.mapper.TestMapper;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class TestService {

    @Resource(name="testMapper")
    TestMapper testMapper;

    public String test(int keyCd) {
        return testMapper.test(keyCd);
    }
}
