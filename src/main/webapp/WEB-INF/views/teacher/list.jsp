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

    <div class="mb-2">
        <div class="accordion" id="filterAccordion">
            <div class="accordion-item">
                <p class="accordion-header">
                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne" style="padding: 8px;">검색필터</button>
                </p>
                <div id="collapseOne" class="accordion-collapse collapse" data-bs-parent="#filterAccordion">
                    <div class="pb-2 pt-2 ps-2 pe-2">
                    <%-- 검색필터 --%>
                        <form id="condForm" method="post">
                            <div class="d-flex justify-content-between">
                                <table class="table">
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center row">
                                                <div class="col-3"><label for="id">교원번호</label></div>
                                                <div class="col-9"><input type="text" class="form-control" id="id" name="id" /></div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center row">
                                                <div class="col-3"><label for="name">이름</label></div>
                                                <div class="col-9"><input type="text" class="form-control" id="name" name="name" /></div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center row">
                                                <div class="col-3"><label for="birth">생년월일</label></div>
                                                <div class="col-9"><input type="date" class="form-control" id="birth" name="birth" /></div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center row">
                                                <div class="col-3"><span>퇴직여부</span></div>
                                                <div class="col-9 d-flex align-items-center" style="height: 37px;">
                                                    <label for="status_all">모두</label><input type="radio" class="form-select-button ms-1 me-3" id="status_all" name="delYn" value="all" checked />
                                                    <label for="status_n">재직</label><input type="radio" class="form-check ms-1 me-3" id="status_n" name="delYn" value="N" />
                                                    <label for="status_y">퇴직</label><input type="radio" class="form-check ms-1 me-3" id="status_y" name="delYn" value="Y" />
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center row">
                                                <div class="col-3"><label for="major">전공</label></div>
                                                <div class="col-9"><input type="text" class="form-control" id="major" name="major" /></div>
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
<%--                     검색필터 --%>
                    </div>
                </div>
            </div>
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
            <tbody id="tbody"></tbody>
        </table>
    </div>
    <nav id="pageNav" aria-label="Page navigation example" class="d-flex align-items-center">
        <ul class="pagination"></ul>
        <span class="ms-2 small text-muted">total count: <span id="totalCnt"></span>건</span>
    </nav>
</div>

<form id="openPopup" target="popup" method="post">
    <input type="hidden" id="infoId" name="id" value=""/>
</form>
<script>
    let curPage = 1;
    let teacherVoList = ${teacherVoList};
    let form = $('#openPopup');

    function popupTeacherInfo(event){
        window.open('', 'popup', 'width=800,height=400,scrollbars=yes');
        form.attr("action", "<c:url value="/teacher/info"/>");
        $('#infoId').val($(event.currentTarget).children().eq(0).text());
        form.submit();
    }

    function insertTeacher(){
        window.open('', 'popup', 'width=800,height=400,scrollbars=yes');
        form.attr("action", "<c:url value="/teacher/insertWindow"/>");
        form.submit();
    }

    function drawCurPaging(page){
        let start = (page-1)*10;

        let $tbody = $('#tbody');
        let html = '';
        $('#totalCnt').text(teacherVoList.length);
        if(teacherVoList.length === 0){
            html += '<tr><td colspan="9" class="text-center">검색결과가 없습니다.</td></tr>';
            $tbody.html(html);
            return;
        }
        for(let i=start; i<start+10; i++){
            if(i >= Math.ceil(teacherVoList.length)) continue;
            let id = teacherVoList[i].id ? teacherVoList[i].id : '';
            let name = teacherVoList[i].name ? teacherVoList[i].name : '';
            let birth = teacherVoList[i].birth ? String(teacherVoList[i].birth[0] ?? '').padStart(2, '0') + '-' + String(teacherVoList[i].birth[1] ?? '').padStart(2, '0') + '-' + String(teacherVoList[i].birth[2] ?? '').padStart(2, '0') : '';
            let major = teacherVoList[i].major ? teacherVoList[i].major : '';
            let grade = teacherVoList[i].grade ? teacherVoList[i].grade : '';
            let delYn = teacherVoList[i].delYn ? teacherVoList[i].delYn : '';
            let delDate = teacherVoList[i].delDate ? String(teacherVoList[i].delDate[0] ?? '').padStart(2, '0') + '-' + String(teacherVoList[i].delDate[1] ?? '').padStart(2, '0') + '-' + String(teacherVoList[i].delDate[2] ?? '').padStart(2, '0') : '';
            let regDate = teacherVoList[i].regDate ? String(teacherVoList[i].regDate[0] ?? '').padStart(2, '0') + '-' + String(teacherVoList[i].regDate[1] ?? '').padStart(2, '0') + '-' + String(teacherVoList[i].regDate[2] ?? '').padStart(2, '0') + ' ' + String(teacherVoList[i].regDate[3] ?? '').padStart(2, '0') + ':' + String(teacherVoList[i].regDate[4] ?? '').padStart(2, '0') + ':' + String(teacherVoList[i].regDate[5] ?? '').padStart(2, '0') : '';
            let updDate = teacherVoList[i].updDate ? String(teacherVoList[i].updDate[0] ?? '').padStart(2, '0') + '-' + String(teacherVoList[i].updDate[1] ?? '').padStart(2, '0') + '-' + String(teacherVoList[i].updDate[2] ?? '').padStart(2, '0') + ' ' + String(teacherVoList[i].updDate[3] ?? '').padStart(2, '0') + ':' + String(teacherVoList[i].updDate[4] ?? '').padStart(2, '0') + ':' + String(teacherVoList[i].updDate[5] ?? '').padStart(2, '0') : '';

            html += '<tr class="text-center">';
            html += '<td>' + id + '</td>';
            html += '<td>' + name + '</td>';
            html += '<td>' + birth + '</td>';
            html += '<td>' + major + '</td>';
            html += '<td>' + grade + '</td>';
            html += '<td>' + delYn + '</td>';
            html += '<td>' + delDate + '</td>';
            html += '<td>' + regDate + '</td>';
            html += '<td>' + updDate + '</td>';
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
            if(i > Math.ceil(teacherVoList.length/10)) {
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
        let data = {};

        for (let [key, value] of formData.entries()) {
            data[key] = value;
        }

        $.ajax({
            url: '/teacher/searchByCond',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function (result) {
                curPage = 1;
                teacherVoList = result;
                drawCurPaging(curPage);
            }
        });
    });
</script>