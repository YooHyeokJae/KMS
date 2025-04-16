package com.hj.mapper;

import com.hj.vo.TeacherVo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface TeacherMapper {
    List<TeacherVo> getList(Map<String, Object> params);

    int getTotal();

    TeacherVo getInfo(String id);

    void insertTeacher(TeacherVo teacherVo);

    int findById(String id);

    void modifyTeacher(TeacherVo teacherVo);

    void delete(Map<String, Object> params);
}
