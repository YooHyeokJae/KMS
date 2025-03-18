<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<style>
    .trs:hover td{
        background-color: #cecfd1;
    }
</style>
<div class="container">
    <h2>
        <c:if test="${category eq 'notice'}">공지사항</c:if>
        <c:if test="${category eq 'free'}">자유게시판</c:if>
    </h2>
    <div>검색필터</div>
    <div style="min-height: 430px">
        <table class="table">
            <thead>
                <tr class="table-primary text-center">
                    <td width="5%">번호</td>
                    <td width="*">제목</td>
                    <td width="10%">작성자</td>
                    <td width="15%">등록일</td>
                    <td width="8%">조회수</td>
                    <td width="8%">추천수</td>
                </tr>
            </thead>
            <tbody>
                <c:if test="${boardVoList.size() eq 0}">
                    <tr class="text-center"><td colspan="6">등록된 게시글이 없습니다.</td></tr>
                </c:if>
                <c:forEach var="vo" items="${boardVoList}" varStatus="stat">
                    <tr class="trs">
                        <td class="text-center">${vo.num}</td>
                        <td>${vo.title}</td>
                        <td>${vo.writerId}</td>
                        <td class="text-center">${fn:replace(vo.regDate, 'T', ' ')}</td>
                        <td class="text-center">${vo.viewCnt}</td>
                        <td class="text-center">${vo.likeCnt}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
    <div class="row">
        <div class="col-9">
            <nav aria-label="Page navigation example" class="d-flex align-items-center">
                <ul class="pagination">
                    <li class="page-item"><a class="page-link <c:if test="${pageStart eq 1}">disabled</c:if>" href="<c:url value="/board/list?cat=${category}&page=${pageStart-1}"/>">이전</a></li>
                    <c:forEach var="i" begin="0" end="${pageBlock-1}">
                        <li class="page-item<c:if test="${pageStart + i eq currentPage}"> active</c:if><c:if test="${pageStart + i - 1 gt totalCnt/count}"> disabled</c:if>"><a class="page-link text-center" href="<c:url value="/board/list?cat=${category}&page=${pageStart + i}"/>" style="min-width: 60px;">${pageStart + i}</a></li>
                    </c:forEach>
                    <li class="page-item"><a class="page-link<c:if test="${pageStart + pageBlock - 1 gt totalCnt/count}"> disabled</c:if>" href="<c:url value="/board/list?cat=${category}&page=${pageStart+pageBlock}"/>">다음</a></li>
                </ul>
                <span class="ms-2 small text-muted">total count: ${totalCnt}건</span>
            </nav>
        </div>
        <div class="col-3 text-end">
            <a href="<c:url value="/board/insert"/>" class="btn btn-primary" onclick="loginChk()">글작성</a>
        </div>
    </div>
</div>

<script>
    let isLogin = ${not empty sessionScope.loginUser ? true : false};
    function loginChk(){
        if(!isLogin){
            alert('로그인이 필요합니다.');
            event.preventDefault();
        }
    }

    $('.trs').on('click', function(){
        let num = $(this).children().eq(0).text();
        location.href = "/board/detail?num="+num;
    });
</script>