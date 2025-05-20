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
    <div class="d-flex justify-content-between">
        <h2 style="border-bottom: 2px solid #333; display: inline-block; padding: 5px 12px; border-radius: 10px;">
            <span style="color: #0093aa"><i class="bi bi-backpack2"></i> 일일계획안</span>
        </h2>

        <div class="d-flex align-items-end justify-content-end mb-2">
            <c:if test="${sessionScope.loginUser.auth eq 'A' or sessionScope.loginUser.auth eq 'T'}">
                <input type="button" class="btn btn-info" value="등록" onclick="popupInsertForm(event)" />
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
                        <form id="condForm" method="post">
                            <div class="d-flex justify-content-between">
                                <table class="table">
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center row">
                                                <div class="col-3"><label for="num">계획번호</label></div>
                                                <div class="col-9"><input type="text" class="form-control" id="num" name="num" /></div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center row">
                                                <div class="col-3"><label for="activityDate">활동일</label></div>
                                                <div class="col-9"><input type="date" class="form-control" id="activityDate" name="activityDate" /></div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center row">
                                                <div class="col-3"><label for="instructorName">담당교사</label></div>
                                                <div class="col-9"><input type="text" class="form-control" id="instructorName" name="instructorName" /></div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center row">
                                                <div class="col-3"><label for="subject">주제</label></div>
                                                <div class="col-9"><input type="text" class="form-control" id="subject" name="subject" /></div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center row">
                                                <div class="col-3"></div>
                                                <div class="col-9"></div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center row">
                                                <div class="col-3"></div>
                                                <div class="col-9"></div>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                                <input type="button" class="btn btn-info ms-2" id="searchByCond" value="검색" />
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
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
            <tbody id="tbody"></tbody>
        </table>
    </div>
    <nav id="pageNav" aria-label="Page navigation example" class="d-flex align-items-center">
        <ul class="pagination"></ul>
        <span class="ms-2 small text-muted">total count: <span id="totalCnt"></span>건</span>
    </nav>
</div>

<form id="openPopup" target="popup" action="" method="post">
    <input type="hidden" name="num" value=""/>
</form>
<script>
    let curPage = 1;
    let dailyPlanVoList = ${dailyPlanVoList};

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

    function drawCurPaging(page){
        let start = (page-1)*10;

        let $tbody = $('#tbody');
        let html = '';
        $('#totalCnt').text(dailyPlanVoList.length);
        if(dailyPlanVoList.length === 0){
            html += '<tr><td colspan="7" class="text-center">검색결과가 없습니다.</td></tr>';
            $tbody.html(html);
            return;
        }

        for(let i=start; i<start+10; i++) {
            if (i >= Math.ceil(dailyPlanVoList.length)) continue;
            let num = dailyPlanVoList[i].num;
            let seq = dailyPlanVoList[i].seq ? dailyPlanVoList[i].seq : '';
            let activityDate = dailyPlanVoList[i].activityDate ? String(dailyPlanVoList[i].activityDate[0] ?? '').padStart(2, '0') + '-' + String(dailyPlanVoList[i].activityDate[1] ?? '').padStart(2, '0') + '-' + String(dailyPlanVoList[i].activityDate[2] ?? '').padStart(2, '0') : '';
            let instructorName = dailyPlanVoList[i].instructorName ? dailyPlanVoList[i].instructorName : '';
            let subject = dailyPlanVoList[i].subject ? dailyPlanVoList[i].subject : '';
            let regDate = dailyPlanVoList[i].regDate ? String(dailyPlanVoList[i].regDate[0] ?? '').padStart(2, '0') + '-' + String(dailyPlanVoList[i].regDate[1] ?? '').padStart(2, '0') + '-' + String(dailyPlanVoList[i].regDate[2] ?? '').padStart(2, '0') + ' ' + String(dailyPlanVoList[i].regDate[3] ?? '').padStart(2, '0') + ':' + String(dailyPlanVoList[i].regDate[4] ?? '').padStart(2, '0') + ':' + String(dailyPlanVoList[i].regDate[5] ?? '').padStart(2, '0') : '';
            let updDate = dailyPlanVoList[i].updDate ? String(dailyPlanVoList[i].updDate[0] ?? '').padStart(2, '0') + '-' + String(dailyPlanVoList[i].updDate[1] ?? '').padStart(2, '0') + '-' + String(dailyPlanVoList[i].updDate[2] ?? '').padStart(2, '0') + ' ' + String(dailyPlanVoList[i].updDate[3] ?? '').padStart(2, '0') + ':' + String(dailyPlanVoList[i].updDate[4] ?? '').padStart(2, '0') + ':' + String(dailyPlanVoList[i].updDate[5] ?? '').padStart(2, '0') : '';

            html += '<tr class="trs">';
            html += '<td class="text-center">' + num + '</td>';
            html += '<td class="text-center">' + seq + '</td>';
            html += '<td class="text-center">' + activityDate + '</td>';
            html += '<td>' + instructorName + '</td>';
            html += '<td>' + subject + '</td>';
            html += '<td class="text-center">' + regDate + '</td>';
            html += '<td class="text-center">' + updDate + '</td>';
            html += '</tr>';
        }
        $tbody.html(html);
        drawPagingArea(page);
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
            if(i > Math.ceil(dailyPlanVoList.length/10)) {
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

    // 검색필터
    $('#searchByCond').on('click', function () {
        let $form = $('#condForm')[0];
        let formData = new FormData($form);
        let data = {
            cat: 'dailyPlan'
        };

        for (let [key, value] of formData.entries()) {
            data[key] = value;
        }

        $.ajax({
            url: '/education/searchByCond',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function (result) {
                curPage = 1;
                dailyPlanVoList = result;
                drawCurPaging(curPage);
            }
        });
    });
</script>

