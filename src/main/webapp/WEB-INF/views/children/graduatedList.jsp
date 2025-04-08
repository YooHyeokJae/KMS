<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<div class="container">
    <h2 style="border-bottom: 2px solid #333; display: inline-block; padding: 5px 12px; border-radius: 10px;">
        <span style="color: #000000"><i class="bi bi-person-hearts"></i> 졸업생</span>
    </h2>
    <div style="min-height: 430px">
        <table id="listTable" class="table table-striped table-hover">
            <thead>
            <tr class="table-warning text-center">
                <th>원생번호</th>
                <th>이름</th>
                <th>생년월일</th>
                <th>입학일</th>
                <th>졸업일</th>
                <th>졸업사유</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="childVo" items="${childVoList}" varStatus="stat">
                <tr class="text-center" onclick="popupChildInfo(event)">
                    <td width="10%">${childVo.num}</td>
                    <td width="*">${childVo.name}</td>
                    <td width="20%">${childVo.birth}</td>
                    <td width="20%">${childVo.entryDate}</td>
                    <td width="20%">${childVo.graduateDate}</td>
                    <td width="20%">${childVo.graduateReason}</td>
                </tr>
            </c:forEach>
            <c:if test="${childVoList.size() eq 0}">
                <tr><td colspan="8" class="text-center">졸업한 원생이 없습니다.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
    <nav aria-label="Page navigation example" class="d-flex align-items-center">
        <ul class="pagination">
            <li class="page-item"><a class="page-link <c:if test="${pageStart eq 1}">disabled</c:if>" href="<c:url value="/children/list?page=${pageStart-1}"/>">이전</a></li>
            <c:forEach var="i" begin="0" end="${pageBlock-1}">
                <li class="page-item<c:if test="${pageStart + i eq currentPage}"> active</c:if><c:if test="${pageStart + i - 1 >= totalCnt/count}"> disabled</c:if>"><a class="page-link text-center" href="<c:url value="/children/list?page=${pageStart + i}"/>" style="min-width: 60px;">${pageStart + i}</a></li>
            </c:forEach>
            <li class="page-item"><a class="page-link<c:if test="${pageStart + pageBlock - 1 >= totalCnt/count}"> disabled</c:if>" href="<c:url value="/children/list?page=${pageStart+pageBlock}"/>">다음</a></li>
        </ul>
        <span class="ms-2 small text-muted">total count: ${totalCnt}건</span>
    </nav>
</div>

<form id="openPopup" target="popup" action="" method="post">
    <input type="hidden" name="num" value=""/>
</form>

<script>
    let form = $('#openPopup');

    function popupChildInfo(event){
        window.open('', 'popup', 'width=600,height=400,scrollbars=yes');
        $('input[name="num"]').val($(event.currentTarget).children().eq(0).text());
        form.attr("action", "<c:url value="/children/info"/>");
        form.submit();
    }
</script>