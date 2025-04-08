package com.hj.mapper;

import com.hj.vo.ActivityVo;
import com.hj.vo.ChildVo;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface ChildrenMapper {
    int getTotal(String graduated);

    List<ChildVo> getList(Map<String, Object> params);

    ChildVo getInfo(int num);

    void insertChild(ChildVo childVo);

    int getNextNum();

    void modifyChild(ChildVo childVo);

    void insertChildBatch(@Param("childVoList") List<ChildVo> childVoList);

    List<ChildVo> searchChild(Map<String, String> params);

    void graduate(Map<String, Object> childVo);
}
