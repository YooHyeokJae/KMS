<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<style>
    .trs:hover td{
        background-color: #cecfd1;
    }
</style>
<div class="container">
    <div class="d-flex justify-content-between">
        <h2 style="border-bottom: 2px solid #333; display: inline-block; padding: 5px 12px; border-radius: 10px;">
            <span>
                <c:if test="${category eq 'notice'}">
                    <i class="bi bi-card-checklist"></i> 공지사항
                </c:if>
                <c:if test="${category eq 'free'}">
                    <i class="bi bi-card-text"></i> 자유게시판
                </c:if>
            </span>
        </h2>

        <div class="d-flex align-items-end justify-content-end mb-2">
            <a href="<c:url value="/board/insert"/>" class="btn btn-outline-primary" onclick="loginChk()">글작성</a>
        </div>
    </div>

    <div class="mb-2">
        <div class="accordion" id="filterAccordion">
            <div class="accordion-item">
                <p class="accordion-header">
                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne" style="padding: 8px;">검색필터</button>
                </p>
                <div id="collapseOne" class="accordion-collapse collapse" data-bs-parent="#filterAccordion">
                    <div class="pb-2 pt-2 ps-2 pe-2">
                        필터내용
                    </div>
                </div>
            </div>
        </div>
    </div>

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
                        <td>${vo.writerName}</td>
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
                        <li class="page-item<c:if test="${pageStart + i eq currentPage}"> active</c:if><c:if test="${pageStart + i - 1 >= totalCnt/count}"> disabled</c:if>"><a class="page-link text-center" href="<c:url value="/board/list?cat=${category}&page=${pageStart + i}"/>" style="min-width: 60px;">${pageStart + i}</a></li>
                    </c:forEach>
                    <li class="page-item"><a class="page-link<c:if test="${pageStart + pageBlock - 1 >= totalCnt/count}"> disabled</c:if>" href="<c:url value="/board/list?cat=${category}&page=${pageStart+pageBlock}"/>">다음</a></li>
                </ul>
                <span class="ms-2 small text-muted">total count: ${totalCnt}건</span>
            </nav>
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