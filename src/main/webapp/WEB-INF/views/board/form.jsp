<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<style>
    .trs:hover td{
        background-color: #cecfd1;
    }
</style>
<div class="container">
    <div class="d-flex justify-content-between">
        <h2 style="border-bottom: 2px solid #333; display: inline-block; padding: 5px 12px; border-radius: 10px;">
            <span style="color: #7798bb;"><i class="bi bi-file-ruled"></i> 양식</span>
        </h2>

        <div class="d-flex align-items-end justify-content-end mb-2">
            <c:if test="${sessionScope.loginUser.auth eq 'A' or sessionScope.loginUser.auth eq 'T'}">
                <input type="button" value="글작성" class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#uploadModal" />
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

    <table class="table">
        <thead>
            <tr class="table-primary text-center">
                <td width="5%">번호</td>
                <td width="*%">파일명</td>
                <td width="2%"></td>
                <td width="8%">작성자</td>
                <td width="8%">파일크기</td>
                <td width="15%">등록일</td>
            </tr>
        </thead>
        <tbody id="tbody"></tbody>
    </table>
    <div class="row">
        <div class="col-9">
            <nav id="pageNav" aria-label="Page navigation example" class="d-flex align-items-center">
                <ul class="pagination"></ul>
                <span class="ms-2 small text-muted">total count: <span id="totalCnt"></span>건</span>
            </nav>
        </div>
    </div>
</div>

<div class="modal fade" id="uploadModal" tabindex="-1" aria-labelledby="uploadModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="uploadModalLabel">양식 업로드</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form>
                <div class="modal-body">
                    <input type="button" class="btn btn-secondary" value="파일선택" onclick="openUploadFile()" />
                    <input type="file" id="uploadFiles" name="uploadFiles" style="display: none;" multiple />
                    <ul id="uploadFileList"></ul>
                </div>
                <div class="modal-footer">
                    <input type="button" class="btn btn-primary" id="upload" value="등록" />
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    let curPage = 1;
    let boardVoList = ${boardVoList};
    function openUploadFile(){
        $('#uploadFiles').click();
    }

    let dataTransfer = new DataTransfer();
    $('#uploadFiles').on('change', function(){
        let files = $(this)[0].files;
        let fileList = Array.from(dataTransfer.files);

        for(let i=0; i<files.length; i++){
            let exist = fileList.some(file => file.name === files[i].name && file.size === files[i].size);

            if (!exist) {
                dataTransfer.items.add(files[i]);
                let index = dataTransfer.files.length - 1;

                let li = '';
                li += '<li class="d-flex justify-content-between" data-index="' + index + '">';
                li += files[i].name;
                li += '<button class="remove-file" data-index="' + index + '">X</button>';
                li += '</li>';
                $('#uploadFileList').append(li);
            }
        }
        $('#uploadFiles').files = dataTransfer.files;
    });

    $(document).on('click', '.remove-file', function(){
        let index = $(this).data('index');
        dataTransfer.items.remove(index);
        $('#uploadFiles').files = dataTransfer.files;
        $(this).parent().remove();
    });

    $('#upload').on('click', function(){
        let formData = new FormData();
        for (let i = 0; i < dataTransfer.files.length; i++) {
            formData.append('files[]', dataTransfer.files[i]);
        }

        $.ajax({
            url: '/board/uploadForm',  // 서버의 파일 처리 URL
            type: 'post',
            data: formData,
            processData: false,
            contentType: false,
            success: function(response) {
                location.reload();
            }
        });
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
            let link = '/download/board/' + num;
            let writerName = boardVoList[i].writerName ? boardVoList[i].writerName : '';
            let fileSize = Math.ceil(boardVoList[i].fileSize / 1024 + 1);
            let regDate = boardVoList[i].regDate ? String(boardVoList[i].regDate[0] ?? '').padStart(2, '0') + '-' + String(boardVoList[i].regDate[1] ?? '').padStart(2, '0') + '-' + String(boardVoList[i].regDate[2] ?? '').padStart(2, '0') + ' ' + String(boardVoList[i].regDate[3] ?? '').padStart(2, '0') + ':' + String(boardVoList[i].regDate[4] ?? '').padStart(2, '0') + ':' + String(boardVoList[i].regDate[5] ?? '').padStart(2, '0') : '';

            html += '<tr class="trs">';
            html += '<td class="text-center">' + num + '</td>';
            html += '<td>' + title + '</td>';
            html += '<td class="text-center"><a href="' + link + '"/><i class="bi bi-download"></i></a></td>';
            html += '<td>' + writerName + '</td>';
            html += '<td class="text-center">' + fileSize + ' KB</td>';
            html += '<td class="text-center">' + regDate + '</td>';
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
            cat: 'form'
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