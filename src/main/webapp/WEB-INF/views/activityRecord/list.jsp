<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<style>
    .trs:hover td{
        background-color: lightgray;
    }
</style>

<div class="container">
    <div class="d-flex justify-content-between">
        <h2 style="border-bottom: 2px solid #333; display: inline-block; padding: 5px 12px; border-radius: 10px;">
            <span style="color: #aa5500"><i class="bi bi-balloon-heart"></i> 활동기록</span>
        </h2>

        <div class="d-flex align-items-end justify-content-end mb-2">
            <c:if test="${sessionScope.loginUser.auth eq 'A'}">
                <a href="<c:url value="/education/recordInsert"/>" class="btn btn-info">등록</a>
            </c:if>
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

    <div style="min-height: 430px;">
        <table class="table">
            <thead>
                <tr class="table-primary text-center">
                    <th width="5%">번호</th>
                    <th width="10%">이름</th>
                    <th width="10%">날짜</th>
                    <th width="20%">활동</th>
                    <th width="*">기록</th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${recordVoList.size() == 0}">
                    <tr class="trs"><td colspan="5" class="text-center">등록된 활동기록이 없습니다.</td></tr>
                </c:if>
                <c:forEach var="recordVo" items="${recordVoList}" varStatus="stat">
                    <tr class="trs">
                        <td class="text-center">${recordVo.num}</td>
                        <td class="text-center">${recordVo.childName}</td>
                        <td class="text-center">${fn:substring(recordVo.activityDate, 0, 10)}</td>
                        <td>${recordVo.activityContent}</td>
                        <td>${recordVo.record}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
    <nav aria-label="Page navigation example" class="d-flex align-items-center">
        <ul class="pagination">
            <li class="page-item"><a class="page-link <c:if test="${pageStart eq 1}">disabled</c:if>" href="<c:url value="/teacher/list?page=${pageStart-1}"/>">이전</a></li>
            <c:forEach var="i" begin="0" end="${pageBlock-1}">
                <li class="page-item<c:if test="${pageStart + i eq currentPage}"> active</c:if><c:if test="${pageStart + i - 1 >= totalCnt/count}"> disabled</c:if>"><a class="page-link text-center" href="<c:url value="/teacher/list?page=${pageStart + i}"/>" style="min-width: 60px;">${pageStart + i}</a></li>
            </c:forEach>
            <li class="page-item"><a class="page-link<c:if test="${pageStart + pageBlock - 1 >= totalCnt/count}"> disabled</c:if>" href="<c:url value="/teacher/list?page=${pageStart+pageBlock}"/>">다음</a></li>
        </ul>
        <span class="ms-2 small text-muted">total count: ${totalCnt}건</span>
    </nav>
</div>