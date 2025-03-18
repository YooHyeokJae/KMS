<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<style>
    .center {
        text-align: center;
    }

    .trs:hover td {
        background-color: lightgray;
    }
</style>
<div class="container">
    <div style="display: flex; justify-content: end; margin-bottom: 10px;">
        <input type="button" class="btn btn-primary" value="등록" onclick="popupInsertForm(event)" />
    </div>

    <div style="min-height: 430px">
        <table class="table">
            <thead class="table table-primary">
                <tr class="center">
                    <th width="5%">번호</th>
                    <th width="5%">차시</th>
                    <th width="10%">활동일</th>
                    <th width="8%">담당교사</th>
                    <th width="*">주제</th>
                    <th width="15%">최초등록일</th>
                    <th width="15%">최종수정일</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="dailyPlanVo" items="${dailyPlanVoList}" varStatus="stat">
                    <tr class="trs">
                        <td class="center">${dailyPlanVo.num}</td>
                        <td class="center">${dailyPlanVo.seq}</td>
                        <td class="center">${dailyPlanVo.activityDate}</td>
                        <td>${dailyPlanVo.instructorName}</td>
                        <td>${dailyPlanVo.subject}</td>
                        <td class="center">${fn:replace(dailyPlanVo.regDate, 'T', ' ')}</td>
                        <td class="center">${fn:replace(dailyPlanVo.updDate, 'T', ' ')}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <nav aria-label="Page navigation example" class="d-flex align-items-center">
        <ul class="pagination">
            <li class="page-item"><a class="page-link <c:if test="${pageStart eq 1}">disabled</c:if>" href="<c:url value="/education/dailyPlan?page=${pageStart-1}"/>">이전</a></li>
            <c:forEach var="i" begin="0" end="${pageBlock-1}">
                <li class="page-item<c:if test="${pageStart + i eq currentPage}"> active</c:if><c:if test="${pageStart + i - 1 gt totalCnt/count}"> disabled</c:if>"><a class="page-link text-center" href="<c:url value="/education/dailyPlan?page=${pageStart + i}"/>" style="min-width: 60px;">${pageStart + i}</a></li>
            </c:forEach>
            <li class="page-item"><a class="page-link<c:if test="${pageStart + pageBlock - 1 gt totalCnt/count}"> disabled</c:if>" href="<c:url value="/education/dailyPlan?page=${pageStart+pageBlock}"/>">다음</a></li>
        </ul>
        <span class="ms-2 small text-muted">total count: ${totalCnt}건</span>
    </nav>
</div>

<form id="openPopup" target="popup" action="" method="post">
    <input type="hidden" name="num" value=""/>
</form>
<script>
    function popupInsertForm(event){
        window.open('', 'popup', 'width=1000,height=600,scrollbars=yes');
        let $popup = $('#openPopup');
        $popup.attr('action', '<c:url value="/education/dailyPlan/insert"/>');
        $popup.submit();
    }

    $(document).on('click', '.trs', function(){
        window.open('', 'popup', 'width=1000,height=600,scrollbars=yes');
        let num = $(this).children().eq(0).text();
        $('input[name=num]').val(num);

        let $popup = $('#openPopup');
        $popup.attr('action', '<c:url value="/education/dailyPlan/info"/>');
        $popup.submit();
    });
</script>

