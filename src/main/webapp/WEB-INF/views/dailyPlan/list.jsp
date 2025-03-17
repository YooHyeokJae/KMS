<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<style>
    table, th, td{
        border: 1px solid black;
    }
</style>
<div class="container">
    <input type="button" class="btn btn-primary" value="등록" onclick="popupInsertForm(event)" />

    <table>
        <thead>
            <tr>
                <th>번호</th>
                <th>차시</th>
                <th>활동일</th>
                <th>담당교사</th>
                <th>최초등록일</th>
                <th>최종수정일</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="dailyPlanVo" items="${dailyPlanVoList}" varStatus="stat">
                <tr>
                    <td>${dailyPlanVo.num}</td>
                    <td>${dailyPlanVo.seq}</td>
                    <td>${dailyPlanVo.activityDate}</td>
                    <td>${dailyPlanVo.teacherId}</td>
                    <td>${dailyPlanVo.regDate}</td>
                    <td>${dailyPlanVo.updDate}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<form id="openPopup" target="popup" action="<c:url value="/education/dailyPlan/insert"/>" method="post">
    <input type="hidden" name="id" value=""/>
</form>
<script>
    function popupInsertForm(event){
        window.open('', 'popup', 'width=1000,height=600,scrollbars=yes');
        $('#openPopup').submit();
    }
</script>

