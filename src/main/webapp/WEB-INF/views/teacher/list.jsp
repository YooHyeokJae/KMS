<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<div class="container">
    <div class="d-flex justify-content-between">
        <h2 style="border-bottom: 2px solid #333; display: inline-block; padding: 5px 12px; border-radius: 10px;">
            <span style="color: #000000"><i class="bi bi-person-fill"></i> 교원</span>
        </h2>

        <div class="d-flex align-items-end justify-content-end mb-1">
            <c:if test="${sessionScope.loginUser.auth eq 'A'}">
                <a href="#" class="btn btn-outline-primary ms-2" onclick="insertTeacher()">교원 등록</a>
            </c:if>
        </div>
    </div>

    <div style="min-height: 430px">
        <table id="listTable" class="table table-striped table-hover">
            <thead>
                <tr class="table-warning text-center">
                    <th width="16%">교원번호</th>
                    <th width="10%">이름</th>
                    <th width="10%">생년월일</th>
                    <th width="10%">전공</th>
                    <th width="7%">학급</th>
                    <th width="8%">퇴직여부</th>
                    <th width="13%">퇴직일</th>
                    <th width="13%">최초등록일</th>
                    <th width="13%">최종수정일</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="teacherVo" items="${teacherVoList}" varStatus="stat">
                   <tr class="text-center" onclick="popupTeacherInfo(event)">
                       <td>${teacherVo.id}</td>
                       <td>${teacherVo.name}</td>
                       <td>${teacherVo.birth}</td>
                       <td>${teacherVo.major}</td>
                       <td>${teacherVo.grade}</td>
                       <td>${teacherVo.delYn}</td>
                       <td>${teacherVo.delDate}</td>
                       <td>${fn:replace(teacherVo.regDate, 'T', ' ')}</td>
                       <td>${fn:replace(teacherVo.updDate, 'T', ' ')}</td>
                   </tr>
                </c:forEach>
                <c:if test="${teacherVoList.size() eq 0}">
                    <tr><td colspan="8">등록된 교사가 없습니다.</td></tr>
                </c:if>
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

<form id="openPopup" target="popup" method="post">
    <input type="hidden" name="id" value=""/>
</form>
<script>
    let form = $('#openPopup');

    function popupTeacherInfo(event){
        window.open('', 'popup', 'width=800,height=400,scrollbars=yes');
        form.attr("action", "<c:url value="/teacher/info"/>");
        $('input[name="id"]').val($(event.currentTarget).children().eq(0).text());
        form.submit();
    }

    function insertTeacher(){
        window.open('', 'popup', 'width=800,height=400,scrollbars=yes');
        form.attr("action", "<c:url value="/teacher/insertWindow"/>");
        form.submit();
    }
</script>