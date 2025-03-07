<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<div class="container">
    <c:if test="${sessionScope.loginUser.auth eq 'A'}">
        <a href="#">교원 등록</a>
    </c:if>
    <table id="listTable" class="table table-striped table-hover">
        <thead>
            <tr class="table-warning">
                <th>교원번호</th>
                <th>이름</th>
                <th>생년월일</th>
                <th>전공</th>
                <th>학급</th>
                <th>퇴직여부</th>
                <th>최초등록일</th>
                <th>최종수정일</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="teacherVo" items="${teacherVoList}" varStatus="stat">
               <tr onclick="popupTeacherInfo(event)">
                   <td>${teacherVo.id}</td>
                   <td>${teacherVo.name}</td>
                   <td>${teacherVo.birth}</td>
                   <td>${teacherVo.major}</td>
                   <td>${teacherVo.grade}</td>
                   <td>${teacherVo.delYn}</td>
                   <td>${teacherVo.regDate}</td>
                   <td>${teacherVo.updDate}</td>
               </tr>
            </c:forEach>
            <c:if test="${teacherVoList.size() eq 0}">
                <tr><td colspan="8">등록된 교사가 없습니다.</td></tr>
            </c:if>
        </tbody>
    </table>
    <nav aria-label="Page navigation example" class="d-flex align-items-center">
        <ul class="pagination">
            <li class="page-item"><a class="page-link <c:if test="${pageStart eq 1}">disabled</c:if>" href="<c:url value="/teacher/list?page=${pageStart-1}"/>">이전</a></li>
            <c:forEach var="i" begin="0" end="${pageBlock-1}">
                <li class="page-item<c:if test="${pageStart + i eq currentPage}"> active</c:if><c:if test="${pageStart + i - 1 gt totalCnt/count}"> disabled</c:if>"><a class="page-link text-center" href="<c:url value="/teacher/list?page=${pageStart + i}"/>" style="min-width: 60px;">${pageStart + i}</a></li>
            </c:forEach>
            <li class="page-item"><a class="page-link<c:if test="${pageStart + pageBlock - 1 gt totalCnt/count}"> disabled</c:if>" href="<c:url value="/teacher/list?page=${pageStart+pageBlock}"/>">다음</a></li>
        </ul>
        <span class="ms-2 small text-muted">total count: ${totalCnt}건</span>
    </nav>
</div>

<form id="openPopup" target="popup" action="<c:url value="/teacher/info"/>" method="post">
    <input type="hidden" name="id" value=""/>
</form>
<script>
    function popupTeacherInfo(event){
        window.open('', 'popup', 'width=600,height=400,scrollbars=yes');
        $('input[name="id"]').val($(event.currentTarget).children().eq(0).text());
        $('#openPopup').submit();
    }
</script>