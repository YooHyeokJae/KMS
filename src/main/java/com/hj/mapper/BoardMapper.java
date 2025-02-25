package com.hj.mapper;

import com.hj.vo.BoardVo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface BoardMapper {
    List<BoardVo> getList(Map<String, Object> params);

    int getTotal();
}
