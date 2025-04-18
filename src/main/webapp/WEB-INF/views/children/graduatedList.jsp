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
    let childVoList = ${childVoList};
    let form = $('#openPopup');

    function popupChildInfo(event){
        window.open('', 'popup', 'width=600,height=400,scrollbars=yes');
        $('input[name="num"]').val($(event.currentTarget).children().eq(0).text());
        form.attr("action", "<c:url value="/children/info"/>");
        form.submit();
    }

    function drawCurPaging(page){
        let start = (page-1)*10;

        let $tbody = $('#tbody');
        let html = '';
        if(childVoList.length === 0){
            html += '<tr><td colspan="6" class="text-center">검색결과가 없습니다.</td></tr>';
            $tbody.html(html);
            return;
        }
        for(let i=start; i<start+10; i++) {
            if (i >= Math.ceil(childVoList.length)) continue;
            let num = childVoList[i].num ? childVoList[i].num : '';
            let name = childVoList[i].name ? childVoList[i].name : '';
            let birth = childVoList[i].birth ? String(childVoList[i].birth[0] ?? '').padStart(2, '0') + '-' + String(childVoList[i].birth[1] ?? '').padStart(2, '0') + '-' + String(childVoList[i].birth[2] ?? '').padStart(2, '0') : '';
            let entryDate = childVoList[i].entryDate ? String(childVoList[i].entryDate[0] ?? '').padStart(2, '0') + '-' + String(childVoList[i].entryDate[1] ?? '').padStart(2, '0') + '-' + String(childVoList[i].entryDate[2] ?? '').padStart(2, '0') : '';
            let graduateDate = childVoList[i].graduateDate ? String(childVoList[i].graduateDate[0] ?? '').padStart(2, '0') + '-' + String(childVoList[i].graduateDate[1] ?? '').padStart(2, '0') + '-' + String(childVoList[i].graduateDate[2] ?? '').padStart(2, '0') : '';
            let graduateReason = childVoList[i].graduateReason ? childVoList[i].graduateReason : '';

            html += '<tr class="text-center" onclick="popupChildInfo(event)">';
            html += '<td>' + num + '</td>';
            html += '<td>' + name + '</td>';
            html += '<td>' + birth + '</td>';
            html += '<td>' + entryDate + '</td>';
            html += '<td>' + graduateDate + '</td>';
            html += '<td>' + graduateReason + '</td>';
            html += '</tr>';
        }
        $tbody.html(html);
        drawPagingArea(page);
        $('#totalCnt').text(childVoList.length);
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
            if(i > Math.ceil(childVoList.length/10)) {
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