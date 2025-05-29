package com.hj.service;

import com.hj.mapper.StatisticsMapper;
import com.hj.vo.StatsVo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class StatisticsService {

    @Resource(name="statisticsMapper")
    private StatisticsMapper statisticsMapper;

    public List<StatsVo> getEntryStats(Map<String, Object> params) {
        return this.statisticsMapper.getEntryStats(params);
    }

    public List<StatsVo> getTeacherStats(Map<String, Object> params) {
        return this.statisticsMapper.getTeacherStats(params);
    }

    public List<StatsVo> getStudentStats() {
        return this.statisticsMapper.getStudentStats();
    }

    public List<StatsVo> getStatsByUser() {
        List<StatsVo> result = this.statisticsMapper.getStatsByUser();
        for(StatsVo vo:result){
            switch (vo.getGubun()){
                case "A": vo.setGubun("관리자");   break;
                case "F": vo.setGubun("부");   break;
                case "M": vo.setGubun("모");   break;
                case "T": vo.setGubun("교원");   break;
                case "W": vo.setGubun("미승인");   break;
            }
        }
        return result;
    }

    public List<StatsVo> getStatsByPageUrl(List<String> exceptionUrlList) {
        List<StatsVo> result = this.statisticsMapper.getStatsByPageUrl(exceptionUrlList);
        for(StatsVo vo : result) {
            switch (vo.getGubun()){
                case "/":                          vo.setGubun("메인화면"); break;
                case "/company":                   vo.setGubun("소개화면"); break;
                case "/teacher/list":              vo.setGubun("교원목록"); break;
                case "/children/list":             vo.setGubun("원생목록"); break;
                case "/children/graduatedList":    vo.setGubun("졸업생목록"); break;
                case "/education/attendance/":     vo.setGubun("출석"); break;
                case "/education/dailyPlan/":      vo.setGubun("일일계획안"); break;
                case "/education/activityRecord/": vo.setGubun("활동기록"); break;
                case "/education/counsel/":        vo.setGubun("상담기록"); break;
                case "/education/healthCheck/":    vo.setGubun("건강검진"); break;
                case "/board/list?cat=notice":     vo.setGubun("공지게시판"); break;
                case "/board/list?cat=free":       vo.setGubun("자유게시판"); break;
                case "/board/album":               vo.setGubun("앨범게시판"); break;
                case "/calendar/":                 vo.setGubun("일정"); break;
                case "/food/":                     vo.setGubun("식단표"); break;
                case "/board/form":                vo.setGubun("양식게시판"); break;
                case "/statistics/education":      vo.setGubun("교육통계"); break;
                case "/statistics/page":           vo.setGubun("접속통계"); break;
                case "/setting/":                  vo.setGubun("설정"); break;
                case "/admin/":                    vo.setGubun("관리자화면"); break;
            }
        }
        return result;
    }

    public List<StatsVo> getStatsByLogin(Map<String, Object> params) {
        return this.statisticsMapper.getStatsByLogin(params);
    }
}
