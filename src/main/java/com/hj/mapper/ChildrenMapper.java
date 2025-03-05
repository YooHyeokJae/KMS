package com.hj.mapper;

import com.hj.vo.ChildVo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface ChildrenMapper {
    int getTotal();

    List<ChildVo> getList(Map<String, Object> params);

    ChildVo getInfo(int num);

    void insertChild(ChildVo childVo);

    int getNextNum();

    void modifyChild(ChildVo childVo);
}
