<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<div class="container">
    <div class="d-flex justify-content-between">
        <h2 style="border-bottom: 2px solid #333; display: inline-block; padding: 5px 12px; border-radius: 10px;">
            <span style="color: #000000"><i class="bi bi-person-heart"></i> 원생</span>
        </h2>

        <div class="d-flex align-items-end justify-content-end mb-1">
            <c:if test="${sessionScope.loginUser.auth eq 'A'}">
                <a href="#" class="btn btn-outline-primary ms-2" onclick="insertChild()">원생 등록</a>
                <a href="#" class="btn btn-outline-primary ms-2" data-bs-toggle="modal" data-bs-target="#insertModal">일괄 등록</a>
                <input type="button" class="btn btn-outline-success ms-2" id="graduateModalOpen" data-bs-toggle="modal" data-bs-target="#graduateModal" value="졸업처리" />
            </c:if>
        </div>
    </div>

    <div style="min-height: 430px">
        <table id="listTable" class="table table-striped table-hover">
            <thead>
            <tr class="table-warning text-center">
                <th class="checkAll">
                    <label for="checkAll"></label>
                    <input type="checkbox" id="checkAll" class="form-check checkAll">
                </th>
                <th>원생번호</th>
                <th>이름</th>
                <th>생년월일</th>
                <th>학급</th>
                <th>입학일</th>
                <th>졸업여부</th>
                <th>최초등록일</th>
                <th>최종수정일</th>
                <th></th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="childVo" items="${childVoList}" varStatus="stat">
                <tr class="text-center trs">
                    <td>
                        <label for="check_${stat.index}"></label>
                        <input type="checkbox" id="check_${stat.index}" class="form-check check"
                            data-num="${childVo.num}" data-name="${childVo.name}" data-birth="${childVo.birth}" data-grade="${childVo.grade}">
                    </td>
                    <td>${childVo.num}</td>
                    <td>${childVo.name}</td>
                    <td>${childVo.birth}</td>
                    <td>${childVo.grade}</td>
                    <td>${childVo.entryDate}</td>
                    <td>${childVo.graduated}</td>
                    <td>${fn:replace(childVo.regDate, 'T', ' ')}</td>
                    <td>${fn:replace(childVo.updDate, 'T', ' ')}</td>
                    <td><input type="button" class="childInfo" id="child_${childVo.num}" value="정보보기"></td>
                </tr>
            </c:forEach>
            <c:if test="${childVoList.size() eq 0}">
                <tr><td colspan="8" class="text-center">등록된 원생이 없습니다.</td></tr>
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

<div class="modal fade" id="graduateModal" data-bs-backdrop="static" tabindex="-1" aria-labelledby="graduateModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="graduateModalLabel">졸업 사유</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <table class="table">
                    <thead class="table-light">
                        <tr class="text-center">
                            <th width="10%">이름</th>
                            <th width="20%">생년월일</th>
                            <th width="10%">학급/반</th>
                            <th width="*">사유</th>
                        </tr>
                    </thead>
                    <tbody id="graduateList"></tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                <button type="button" class="btn btn-primary" id="graduateBtn">진행</button>
            </div>
        </div>
    </div>
</div>

<script>
    let form = $('#openPopup');

    function popupChildInfo(event){
        window.open('', 'popup', 'width=600,height=400,scrollbars=yes');
        let num = event.target.id.replace('child_', '');
        $('input[name="num"]').val(num);
        form.attr("action", "<c:url value="/children/info"/>");
        form.submit();
    }

    $('.childInfo').on('click', function(event){
        popupChildInfo(event);
    });

    function insertChild(){
        window.open('', 'popup', 'width=600,height=400,scrollbars=yes');
        form.attr("action", "<c:url value="/children/insertWindow"/>");
        form.submit();
    }

    $('.trs').on('click', function(event){
        if ($(event.target).is('input[type="checkbox"]') || $(event.target).is('input[type="button"]')) {
            return;
        }
        let flag = $(this).children().eq(0).children().eq(1).is(':checked');
        $(this).children().eq(0).children().eq(1).prop('checked', !flag);

        let $checkAll = $('#checkAll');
        let $checkBoxes = $('.check');
        for(let i=0; i<$checkBoxes.length; i++){
            if(!$checkBoxes[i].checked){
                $checkAll.prop('checked', false);
                return;
            }
            $checkAll.prop('checked', true);
        }
    });

    $('.checkAll').on('click', function(){
        let $checkAll = $('#checkAll');
        let stat = $checkAll.is(':checked');
        $checkAll.prop('checked', !stat);

        $('.check').prop('checked', !stat)
    });

    $('#graduateModalOpen').on('click', function(){
        let html = '';
        let selected = $('input[type="checkbox"]:checked');
        if(selected.length === 0){
            html = '<tr class="text-center"><td colspan="4">원생을 선택해주세요.</td></tr>';
            $('#graduateList').html(html);
        }
        for(let i=0; i<selected.length; i++){
            let num = selected[i].dataset.num;
            let name = selected[i].dataset.name;
            let birth = selected[i].dataset.birth;
            let grade = selected[i].dataset.grade;
            html += '<tr class="text-center">';
            html += '<td>' + name + '</td>';
            html += '<td>' + birth + '</td>';
            html += '<td>' + grade + '</td>';
            html += '<td>';
            html += '<input type="hidden" name="child[' + i + '].num" value="' + num + '" />';
            html += '<input type="text" class="form-control" name="child[' + i + '].reason" required >';
            html += '</td>';
            html += '</tr>';
            $('#graduateList').html(html);
        }
    });

    $('#graduateBtn').on('click', function(){
        let data = {child:[]}
        $('input[name^="child["]').each(function() {
            let name = $(this).attr('name');  // ex: child[0].num
            let value = $(this).val();

            // 인덱스와 필드 추출: "child[0].num" → index=0, key=num
            let match = name.match(/^child\[(\d+)\]\.(\w+)$/);
            if (match) {
                let index = parseInt(match[1]);
                let key = match[2];

                // 해당 인덱스 객체가 없으면 초기화
                if (!data.child[index]) data.child[index] = {};
                data.child[index][key] = value;
            }
        });
        console.log(data);

        $.ajax({
            url: '/children/graduate',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function(){
                alert('처리되었습니다.');
                location.reload();
            }
        });
    });
</script>
