<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<style>
    .trs:hover td{
        background-color: #cecfd1;
    }
</style>
<div class="container">
    <div class="d-flex justify-content-between">
        <h2 style="border-bottom: 2px solid #333; display: inline-block; padding: 5px 12px; border-radius: 10px;">
            <span>
                <c:if test="${category eq 'notice'}">
                    <i class="bi bi-card-checklist"></i> 공지사항
                </c:if>
                <c:if test="${category eq 'free'}">
                    <i class="bi bi-card-text"></i> 자유게시판
                </c:if>
            </span>
        </h2>

        <div class="d-flex align-items-end justify-content-end mb-2">
            <a href="<c:url value="/board/insert"/>" class="btn btn-outline-primary" onclick="loginChk()">글작성</a>
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
                                                <div class="col-3"><label for="num">글번호</label></div>
                                                <div class="col-9"><input type="text" class="form-control" id="num" name="num" /></div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center row">
                                                <div class="col-3"><label for="title">제목</label></div>
                                                <div class="col-9"><input type="text" class="form-control" id="title" name="title" /></div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center row">
                                                <div class="col-3"><label for="regDate">작성일</label></div>
                                                <div class="col-9"><input type="date" class="form-control" id="regDate" name="regDate" /></div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center row">
                                                <div class="col-3"><label for="writerName">작성자</label></div>
                                                <div class="col-9"><input type="text" class="form-control" id="writerName" name="writerName" /></div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center row">
                                                <div class="col-3"><label for="content">내용</label></div>
                                                <div class="col-9"><input type="text" class="form-control" id="content" name="content" /></div>
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
            <thead>
                <tr class="table-primary text-center">
                    <td width="5%">번호</td>
                    <td width="*">제목</td>
                    <td width="10%">작성자</td>
                    <td width="15%">등록일</td>
                    <td width="8%">조회수</td>
                    <td width="8%">추천수</td>
                </tr>
            </thead>
            <tbody id="tbody"></tbody>
        </table>
    </div>
    <div class="row">
        <div class="col-9">
            <nav id="pageNav" aria-label="Page navigation example" class="d-flex align-items-center">
                <ul class="pagination"></ul>
                <span class="ms-2 small text-muted">total count: <span id="totalCnt"></span>건</span>
            </nav>
        </div>
    </div>
</div>

<script>
    let curPage = 1;
    let boardVoList = ${boardVoList};
    let isLogin = ${not empty sessionScope.loginUser ? true : false};
    function loginChk(){
        if(!isLogin){
            alert('로그인이 필요합니다.');
            event.preventDefault();
        }
    }

    $(document).on('click', '.trs', function(){
        let num = $(this).children().eq(0).text();
        location.href = "/board/detail?num="+num;
    });

    function drawCurPaging(page){
        let start = (page-1)*10;

        let $tbody = $('#tbody');
        let html = '';
        $('#totalCnt').text(boardVoList.length);
        if(boardVoList.length === 0){
            html += '<tr><td colspan="6" class="text-center">검색결과가 없습니다.</td></tr>';
            $tbody.html(html);
            return;
        }
        for(let i=start; i<start+10; i++){
            if(i >= Math.ceil(boardVoList.length)) continue;
            let num = boardVoList[i].num;
            let title = boardVoList[i].title ? boardVoList[i].title : '';
            let writerName = boardVoList[i].writerName ? boardVoList[i].writerName : '';
            let regDate = boardVoList[i].regDate ? String(boardVoList[i].regDate[0] ?? '').padStart(2, '0') + '-' + String(boardVoList[i].regDate[1] ?? '').padStart(2, '0') + '-' + String(boardVoList[i].regDate[2] ?? '').padStart(2, '0') + ' ' + String(boardVoList[i].regDate[3] ?? '').padStart(2, '0') + ':' + String(boardVoList[i].regDate[4] ?? '').padStart(2, '0') + ':' + String(boardVoList[i].regDate[5] ?? '').padStart(2, '0') : '';
            let viewCnt = boardVoList[i].viewCnt ? boardVoList[i].viewCnt : '0';
            let likeCnt = boardVoList[i].likeCnt ? boardVoList[i].likeCnt : '0';

            html += '<tr class="trs">';
            html += '<td class="text-center">' + num + '</td>';
            html += '<td>' + title + '</td>';
            html += '<td>' + writerName + '</td>';
            html += '<td class="text-center">' + regDate + '</td>';
            html += '<td class="text-center">' + viewCnt + '</td>';
            html += '<td class="text-center">' + likeCnt + '</td>';
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
            if(i > Math.ceil(boardVoList.length/10)) {
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
            cat: '${category}'
        };

        for (let [key, value] of formData.entries()) {
            data[key] = value;
        }

        $.ajax({
            url: '/board/searchByCond',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function (result) {
                curPage = 1;
                boardVoList = result;
                drawCurPaging(curPage);
            }
        });
    });
</script>