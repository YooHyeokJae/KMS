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
            <tbody id="tbody"></tbody>
        </table>
    </div>
    <nav id="pageNav" aria-label="Page navigation example" class="d-flex align-items-center">
        <ul class="pagination"></ul>
        <span class="ms-2 small text-muted">total count: <span id="totalCnt"></span>건</span>
    </nav>
</div>

<script>
    let curPage = 1;
    let recordVoList = ${recordVoList};

    function drawCurPaging(page){
        let start = (page-1)*10;

        let $tbody = $('#tbody');
        let html = '';
        if(recordVoList.length === 0){
            html += '<tr><td colspan="5" class="text-center">검색결과가 없습니다.</td></tr>';
            $tbody.html(html);
            return;
        }

        for(let i=start; i<start+10; i++) {
            if (i >= Math.ceil(recordVoList.length)) continue;
            let num = recordVoList[i].num;
            let childName = recordVoList[i].childName ? recordVoList[i].childName : '';
            let activityDate = recordVoList[i].activityDate ? String(recordVoList[i].activityDate[0] ?? '').padStart(2, '0') + '-' + String(recordVoList[i].activityDate[1] ?? '').padStart(2, '0') + '-' + String(recordVoList[i].activityDate[2] ?? '').padStart(2, '0') : '';
            let activityContent = recordVoList[i].activityContent ? recordVoList[i].activityContent : '';
            let record = recordVoList[i].record ? recordVoList[i].record : '';

            html += '<tr class="trs">';
            html += '<td class="text-center">' + num + '</td>';
            html += '<td class="text-center">' + childName + '</td>';
            html += '<td class="text-center">' + activityDate + '</td>';
            html += '<td>' + activityContent + '</td>';
            html += '<td>' + record + '</td>';
            html += '</tr>';
        }
        $tbody.html(html);
        drawPagingArea(page);
        $('#totalCnt').text(recordVoList.length);
    }

    function drawPagingArea(page) {
        let start = Math.floor((page - 1) / 10) * 10 + 1;
        let $pagination = $('.pagination');
        let lastBlock = false;
        let html = '';
        html += '<li class="page-item';
        if(page < 11)   html += ' disabled';
        html += '"><a class="page-link prev" href="#">이전</a></li>';
        for(let i=start; i<start+10; i++){
            html += '<li class="page-item';
            if(String(page) === String(i))  html += ' active';
            if(i > Math.ceil(recordVoList.length/10)) {
                html += ' disabled';
                lastBlock = true;
            }
            html += '"><a class="page-link text-center" href="#" style="min-width: 60px;">' + i + '</a></li>';
        }
        html += '<li class="page-item';
        if(lastBlock)   html += ' disabled';
        html += '"><a class="page-link next" href="#">다음</a></li>';
        $pagination.html(html);
    }

    $(document).on('click', '.page-link', function(event){
        event.preventDefault();
        if($(this).hasClass('prev')){
            curPage = Math.floor(((curPage - 1) / 10) - 1) * 10 + 10;
        }else if($(this).hasClass('next')){
            curPage = Math.floor(((curPage - 1) / 10) + 1) * 10 + 1;
        }else{
            curPage = $(this).text();
        }
        drawCurPaging(curPage);
    });

    $(document).ready(function () {
        drawCurPaging(curPage);
    });
</script>