package com.hj.service;

import com.hj.mapper.ChildrenMapper;
import com.hj.vo.ActivityVo;
import com.hj.vo.ChildVo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class ChildrenService {
    @Resource(name="childrenMapper")
    private ChildrenMapper childrenMapper;

    public List<ChildVo> getList(Map<String, Object> params) {
        return this.childrenMapper.getList(params);
    }

    public ChildVo getInfo(int num) {
        return this.childrenMapper.getInfo(num);
    }

    public int getNextNum() {
        return this.childrenMapper.getNextNum();
    }

    public void insertChild(ChildVo childVo) {
        this.childrenMapper.insertChild(childVo);
    }

    public void modifyChild(ChildVo childVo) {
        this.childrenMapper.modifyChild(childVo);
    }

    public void insertChildBatch(List<ChildVo> childVoList) {
        this.childrenMapper.insertChildBatch(childVoList);
    }

    public List<ChildVo> searchChild(Map<String, String> params) {
        return this.childrenMapper.searchChild(params);
    }

    public void graduate(Map<String, Object> childVo) {
        this.childrenMapper.graduate(childVo);
    }

    public List<ChildVo> searchByCond(Map<String, Object> params) {
        return this.childrenMapper.searchByCond(params);
    }
}
