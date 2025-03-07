<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<div class="container">
    <c:if test="${sessionScope.loginUser.auth eq 'A'}">
        <a href="#" onclick="insertChild()">원생 등록</a>
        <a href="#" data-bs-toggle="modal" data-bs-target="#insertModal">일괄 등록</a>
    </c:if>
    <table id="listTable" class="table table-striped table-hover">
        <thead>
        <tr class="table-warning">
            <th>원생번호</th>
            <th>이름</th>
            <th>생년월일</th>
            <th>학급</th>
            <th>입학일</th>
            <th>졸업여부</th>
            <th>최초등록일</th>
            <th>최종수정일</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="childVo" items="${childVoList}" varStatus="stat">
            <tr onclick="popupChildInfo(event)">
                <td>${childVo.num}</td>
                <td>${childVo.name}</td>
                <td>${childVo.birth}</td>
                <td>${childVo.grade}</td>
                <td>${childVo.entryDate}</td>
                <td>${childVo.graduated}</td>
                <td>${childVo.regDate}</td>
                <td>${childVo.updDate}</td>
            </tr>
        </c:forEach>
        <c:if test="${childVoList.size() eq 0}">
            <tr><td colspan="8">등록된 원생이 없습니다.</td></tr>
        </c:if>
        </tbody>
    </table>
    <nav aria-label="Page navigation example" class="d-flex align-items-center">
        <ul class="pagination">
            <li class="page-item"><a class="page-link <c:if test="${pageStart eq 1}">disabled</c:if>" href="<c:url value="/children/list?page=${pageStart-1}"/>">이전</a></li>
            <c:forEach var="i" begin="0" end="${pageBlock-1}">
                <li class="page-item<c:if test="${pageStart + i eq currentPage}"> active</c:if><c:if test="${pageStart + i - 1 gt totalCnt/count}"> disabled</c:if>"><a class="page-link text-center" href="<c:url value="/children/list?page=${pageStart + i}"/>" style="min-width: 60px;">${pageStart + i}</a></li>
            </c:forEach>
            <li class="page-item"><a class="page-link<c:if test="${pageStart + pageBlock - 1 gt totalCnt/count}"> disabled</c:if>" href="<c:url value="/children/list?page=${pageStart+pageBlock}"/>">다음</a></li>
        </ul>
        <span class="ms-2 small text-muted">total count: ${totalCnt}건</span>
    </nav>
</div>

<form id="openPopup" target="popup" action="" method="post">
    <input type="hidden" name="num" value=""/>
</form>

<div class="modal fade" id="insertModal" tabindex="-1" aria-labelledby="insertModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form action="<c:url value="/children/insertBatch"/>" method="post" enctype="multipart/form-data">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="insertModalLabel">원생 일괄 등록</h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="file" name="file" accept=".xls,.xlsx" value="파일 선택"/>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                    <button type="submit" class="btn btn-primary">등록</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    let form = $('#openPopup');

    function popupChildInfo(event){
        window.open('', 'popup', 'width=600,height=400,scrollbars=yes');
        $('input[name="num"]').val($(event.currentTarget).children().eq(0).text());
        form.attr("action", "<c:url value="/children/info"/>");
        form.submit();
    }

    function insertChild(){
        window.open('', 'popup', 'width=600,height=400,scrollbars=yes');
        form.attr("action", "<c:url value="/children/insertWindow"/>");
        form.submit();
    }
</script>