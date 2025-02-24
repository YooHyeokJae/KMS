package com.hj.service;

import com.hj.mapper.TeacherMapper;
import com.hj.vo.TeacherVo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class TeacherService {
    @Resource
    private TeacherMapper teacherMapper;

    public List<TeacherVo> getList(Map<String, Object> params) {
        return this.teacherMapper.getList(params);
    }

    public int getTotal() {
        return this.teacherMapper.getTotal();
    }

    public TeacherVo getInfo(String id) {
        return this.teacherMapper.getInfo(id);
    }
}
