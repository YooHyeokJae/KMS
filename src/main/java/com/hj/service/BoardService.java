package com.hj.service;

import com.hj.mapper.BoardMapper;
import com.hj.vo.BoardVo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class BoardService {
    @Resource
    private BoardMapper boardMapper;

    public List<BoardVo> getList(Map<String, Object> params) {
        return this.boardMapper.getList(params);
    }

    public int getTotal() {
        return this.boardMapper.getTotal();
    }
}
