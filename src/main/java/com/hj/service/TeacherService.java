package com.hj.service;

import com.hj.mapper.TeacherMapper;
import com.hj.vo.TeacherVo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class TeacherService {
    @Resource(name="teacherMapper")
    private TeacherMapper teacherMapper;

    public List<TeacherVo> getList() {
        return this.teacherMapper.getList();
    }

    public TeacherVo getInfo(String id) {
        return this.teacherMapper.getInfo(id);
    }

    public void insertTeacher(TeacherVo teacherVo) {
        this.teacherMapper.insertTeacher(teacherVo);
    }

    public int findById(String id) {
        return this.teacherMapper.findById(id);
    }

    public void modifyTeacher(TeacherVo teacherVo) {
        this.teacherMapper.modifyTeacher(teacherVo);
    }

    public void delete(Map<String, Object> params) {
        this.teacherMapper.delete(params);
    }

    public List<TeacherVo> searchByCond(Map<String, Object> params) {
        return this.teacherMapper.searchByCond(params);
    }
}
