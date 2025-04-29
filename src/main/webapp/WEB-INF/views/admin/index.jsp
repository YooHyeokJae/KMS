<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<style>
    .nav-link.tab{
        color: black;
    }
    .nav-link.tab.active{
        color: white;
        background-color: #0d6efd;
    }
</style>

<div class="container">
    <div class="d-flex justify-content-between">
        <h2 style="border-bottom: 2px solid #333; display: inline-block; padding: 5px 12px; border-radius: 10px;">
            <span style="color: #f18f3f;"><i class="bi bi-person-gear"></i> 관리자</span>
        </h2>
    </div>

    <ul class="nav nav-tabs">
        <li class="nav-item" style="width: 15%;">
            <a class="nav-link tab active" data-gubun="user" href="#">유저 목록</a>
        </li>
        <li class="nav-item" style="width: 15%;">
            <a class="nav-link tab" data-gubun="waiting" href="#">가입 신청 현황</a>
        </li>
    </ul>
    <div id="userList">
<%--    검색필터    --%>
        <div class="mt-1 mb-2">
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
                                                    <div class="col-3"><label for="uId">아이디</label></div>
                                                    <div class="col-9"><input type="text" class="form-control" id="uId" name="uId" /></div>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center row">
                                                    <div class="col-3"><label for="uName">이름</label></div>
                                                    <div class="col-9"><input type="text" class="form-control" id="uName" name="uName" /></div>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center row" style="height: 37px;">
                                                    <div class="col-3">권한</div>
                                                    <div class="col-9">
                                                        <label for="allAuth">모두</label><input type="radio" id="allAuth" name="uAuth" value="all" checked>
                                                        <label for="T">교원</label><input type="radio" id="T" name="uAuth" value="T">
                                                        <label for="P">학부모</label><input type="radio" id="P" name="uAuth" value="P">
                                                        <label for="W">승인대기</label><input type="radio" id="W" name="uAuth" value="W">
                                                        <label for="A">관리자</label><input type="radio" id="A" name="uAuth" value="A">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center row">
                                                    <div class="col-3"><label for="uEmail">이메일</label></div>
                                                    <div class="col-9"><input type="text" class="form-control" id="uEmail" name="uEmail" /></div>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center row">
                                                    <div class="col-3"><label for="uTelNo">전화번호</label></div>
                                                    <div class="col-9"><input type="text" class="form-control" id="uTelNo" name="uTelNo" /></div>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center row">
                                                    <div class="col-3"><label for="uChildName">원생 명</label></div>
                                                    <div class="col-9"><input type="text" class="form-control" id="uChildName" name="uChildName" /></div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center row" style="height: 37px;">
                                                    <div class="col-3">관계</div>
                                                    <div class="col-9">
                                                        <label for="allRelation">모두</label><input type="radio" id="allRelation" name="uRelation" value="all" checked>
                                                        <label for="F">부</label><input type="radio" id="F" name="uRelation" value="F">
                                                        <label for="M">모</label><input type="radio" id="M" name="uRelation" value="M">
                                                    </div>
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

        <div style="min-height: 430px;">
            <table class="table">
                <thead class="text-center">
                    <tr>
                        <th width="4%">번호</th>
                        <th width="10%">아이디</th>
                        <th width="8%">이름</th>
                        <th width="20%">이메일</th>
                        <th width="10%">전화번호</th>
                        <th width="8%">원생</th>
                        <th width="7%">관계</th>
                        <th width="7%">권한</th>
                        <th width="13%">최초등록일</th>
                        <th width="13%">최종수정일</th>
                    </tr>
                </thead>
                <tbody id="tbody"></tbody>
            </table>
        </div>
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
    const authCode = {
        "A": "관리자",
        "T": "교원",
        "P": "보호자",
        "W": "승인대기",
        "B": "정지",
        "": ""
    }
    const relationCode = {
        "F": "부",
        "M": "모",
        "": ""
    }
</script>

<script>
    let curPage = 1;
    let userVoList;

    function getListAjax(gubun){
        let $form = $('#condForm')[0];
        let formData = new FormData($form);
        let data = {
            gubun: gubun
        };

        for (let [key, value] of formData.entries()) {
            data[key] = value;
        }

        $.ajax({
            url: '/admin/getUserList',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function(result){
                userVoList = result;
                drawCurPaging(curPage);
            }
        });
    }

    function drawCurPaging(page){
        let start = (page-1)*10;
        if(start >= Math.ceil(userVoList.length)) {
            page = --curPage;
            start = (page-1)*10;
        }

        let $tbody = $('#tbody');
        let tbody = '';
        $('#totalCnt').text(userVoList.length);
        if(userVoList.length === 0){
            tbody += '<tr><td colspan="10" class="text-center">검색결과가 없습니다.</td></tr>';
            $tbody.html(tbody);
            return;
        }
        for(let i=start; i<start+10; i++){
            if(i >= Math.ceil(userVoList.length)) continue;
            let id = userVoList[i].id === null ? '' : userVoList[i].id;
            let name = userVoList[i].name === null ? '' : userVoList[i].name;
            let email = userVoList[i].email === null ? '' : userVoList[i].email;
            let telNo = userVoList[i].telNo === null ? '' : userVoList[i].telNo;
            let childName = userVoList[i].childName === null ? '' : userVoList[i].childName;
            let relation = userVoList[i].relation === null ? '' : userVoList[i].relation;
            let auth = userVoList[i].auth === null ? '' : userVoList[i].auth;
            let regDate = String(userVoList[i].regDate[0]).padStart(2, '0') + '-' + String(userVoList[i].regDate[1]).padStart(2, '0') + '-' + String(userVoList[i].regDate[2]).padStart(2, '0') + ' ' + String(userVoList[i].regDate[3]).padStart(2, '0') + ':' + String(userVoList[i].regDate[4]).padStart(2, '0') + ':' + String(userVoList[i].regDate[5]).padStart(2, '0');
            let updDate = String(userVoList[i].updDate[0]).padStart(2, '0') + '-' + String(userVoList[i].updDate[1]).padStart(2, '0') + '-' + String(userVoList[i].updDate[2]).padStart(2, '0') + ' ' + String(userVoList[i].updDate[3]).padStart(2, '0') + ':' + String(userVoList[i].updDate[4]).padStart(2, '0') + ':' + String(userVoList[i].updDate[5]).padStart(2, '0');

            tbody += '<tr>';
            tbody += '<td class="text-center">' + (i+1) + '</td>';
            tbody += '<td>' + id + '</td>';
            tbody += '<td>' + name + '</td>';
            tbody += '<td>' + email + '</td>';
            tbody += '<td class="text-center">' + telNo + '</td>';
            tbody += '<td>' + childName + '</td>';
            tbody += '<td class="text-center">' + relationCode[relation] + '</td>';
            tbody += '<td class="text-center"><select class="authSelect">';
            for (const key in authCode) {
                if (authCode.hasOwnProperty(key)) {
                    tbody += '<option value="' + key + '"';
                    if(auth === key)    tbody += ' selected'
                    tbody += '>' + authCode[key] + '</option>';
                }
            }
            tbody += '</select></td>';
            tbody += '<td class="text-center">' + regDate + '</td>';
            tbody += '<td class="text-center">' + updDate + '</td>';
            tbody += '</tr>';
        }
        $tbody.html(tbody);
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
            if(i > Math.ceil(userVoList.length/10)) {
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

    $(document).ready(function(){
        getListAjax('user');
    });

    $('.tab').on('click', function(event){
        event.preventDefault();
        $('.tab').removeClass('active');
        $(this).addClass('active');

        curPage = 1;
        $('#condForm')[0].reset();

        let gubun = $(this)[0].dataset.gubun;
        getListAjax(gubun);
    });

    $('#searchByCond').on('click', function(){
        curPage = 1;
        let gubun = $('.active')[0].dataset.gubun;
        getListAjax(gubun);
    });

    let savedAuth;
    $(document).on('focus', '.authSelect', function(){
        savedAuth = $(this).val();
    });

    $(document).on('change', '.authSelect', function(){
        let id = $(this).parent().parent().children().eq(1).text();
        let auth = $(this).val();
        if(!confirm(id + '의 권한을 ' + authCode[auth] + '로 바꾸시겠습니까?')){
            this.value = savedAuth;
            return;
        }

        let data = {
            id: id,
            auth: auth
        }

        $.ajax({
            url: '/admin/changeAuth',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function(result){
                console.log(result);
                let gubun = $('.active')[0].dataset.gubun;
                getListAjax(gubun);
            }
        });
    });


</script>
