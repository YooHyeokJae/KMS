<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.js'></script>
<link href="https://fonts.googleapis.com/css2?family=Pacifico&display=swap" rel="stylesheet">
<style>
    @import url(//fonts.googleapis.com/earlyaccess/nanumpenscript.css);
    .nanumpenscript * {
        font-family: 'Nanum Pen Script', cursive;
        font-size: 25px;
    }

    .no-events-message{
        height: 80px;
        display: flex;
        justify-content: center;
        text-align: center;
    }
    .fc-event-main {
        width: 100%;
        min-height: 110px;
        display: flex;
        align-items: center;
        justify-content: center;
        text-align: center;
    }
    #calendar{
        width: 50%;
        justify-self: center;
    }
    .trs:hover td{
        background-color: lightgray;
    }
</style>
<div class="container">
    <div class="row" style="min-height: 700px">
        <div class="col-8">
            <div id="carouselIndicators" class="carousel slide" data-bs-ride="carousel" style="height: 350px;">
                <div class="carousel-indicators">
                    <button type="button" data-bs-target="#carouselIndicators" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
                    <button type="button" data-bs-target="#carouselIndicators" data-bs-slide-to="1" aria-label="Slide 2"></button>
                    <button type="button" data-bs-target="#carouselIndicators" data-bs-slide-to="2" aria-label="Slide 3"></button>
                </div>
                <div class="carousel-inner">
                    <div class="carousel-item active">
                        <img src="${pageContext.request.contextPath}/resources/images/carousel.png" class="d-block w-100" alt="carouselImage1">
                    </div>
                    <div class="carousel-item">
                        <img src="${pageContext.request.contextPath}/resources/images/carousel.png" class="d-block w-100" alt="carouselImage2">
                    </div>
                    <div class="carousel-item">
                        <img src="${pageContext.request.contextPath}/resources/images/carousel.png" class="d-block w-100" alt="carouselImage3">
                    </div>
                </div>
                <button class="carousel-control-prev" type="button" data-bs-target="#carouselIndicators" data-bs-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Previous</span>
                </button>
                <button class="carousel-control-next" type="button" data-bs-target="#carouselIndicators" data-bs-slide="next">
                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Next</span>
                </button>
            </div>
            <br>
            <div class="bestBoard" style="height: 330px;">
                <h2 style="border-bottom: 2px solid #333; display: inline-block; padding: 5px 12px; border-radius: 10px;">
                    <span>🔥</span> <span style="color: #ff6b6b;">인기글</span>
                </h2>

                <div class="bestBoardNavHeader d-flex justify-content-between">
                    <ul class="nav nav-tabs">
                        <li class="nav-item">
                            <a class="nav-link bestBoardTab active" href="#" data-text="notice" style="color: black;">공지사항</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link bestBoardTab" href="#" data-text="free" style="color: black;">자유게시판</a>
                        </li>
                    </ul>
                    <div class="d-flex align-items-center">
                        <label for="orderByDate" class="form-check-label me-1">최신순</label><input type="radio" class="form-check-input me-3" id="orderByDate" name="order" value="date" checked>
                        <label for="orderByView" class="form-check-label me-1">조회순</label><input type="radio" class="form-check-input me-3" id="orderByView" name="order" value="view">
                        <label for="orderByLike" class="form-check-label me-1">추천순</label><input type="radio" class="form-check-input me-3" id="orderByLike" name="order" value="like">
                    </div>
                </div>

                <table class="table">
                    <thead class="table-info text-center">
                        <tr>
                            <th width="*">제목</th>
                            <th width="10%">작성자</th>
                            <th width="15%">작성일</th>
                            <th width="8%">조회수</th>
                            <th width="8%">추천수</th>
                        </tr>
                    </thead>
                    <tbody id="bestBoardTbl">
                        <c:forEach var="boardVo" items="${boardVoList}" varStatus="stat">
                            <tr class="trs" data-num="${boardVo.num}">
                                <td>${boardVo.title}</td>
                                <td class="text-center">${boardVo.writerName}</td>
                                <td class="text-center">${fn:split(boardVo.regDate, 'T')[0]}</td>
                                <td class="text-center">${boardVo.viewCnt}</td>
                                <td class="text-center">${boardVo.likeCnt}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="col-4">
            <div id="userInfo" style="min-height: 150px;">
                <c:if test="${sessionScope.loginUser eq null}">
                    <form action="<c:url value="/sign/login"/>" method="post">
                        <div class="d-flex mb-3" style="height: 90px;">
                            <div>
                                <div class="mb-3 d-flex align-items-center">
                                    <label for="userId" class="form-label mb-0 me-2" style="width: 100px;">아이디: </label>
                                    <input type="text" class="form-control" id="userId" name="userId" />
                                </div>
                                <div class="mb-3 d-flex align-items-center">
                                    <label for="userPw" class="form-label mb-0 me-2" style="width: 100px;">비밀번호: </label>
                                    <input type="password" class="form-control" id="userPw" name="userPw" />
                                </div>
                            </div>
                            <div class="ms-3 h-100">
                                <input type="submit" value="로그인" class="btn btn-primary h-100" />
                            </div>
                        </div>
                        <div class="d-flex justify-content-end">
                            <input type="button" value="회원가입" class="btn btn-secondary ms-3" data-bs-toggle="modal" data-bs-target="#signupModal" />
                            <input type="button" value="ID 찾기" class="btn btn-secondary ms-3" data-bs-toggle="modal" data-bs-target="#searchIdPwModal" />
                        </div>
                    </form>
                </c:if>
                <c:if test="${sessionScope.loginUser ne null}">
                    <div class="row text-center">
                        <div class="col-6">
                            <img src="/upload/${sessionScope.loginUser.profilePath}" alt="childProfile" style="width:150px; height: auto; border-radius: 50%;"/>
                        </div>
                        <div class="col-6">
                            <p>${sessionScope.loginUser.nickname}님 환영합니다.</p>
                            <a href="<c:url value="/setting/"/>" class="btn btn-primary" id="changeInfo">정보수정</a>
                            <input type="button" class="btn btn-secondary" id="logout" value="logout" />
                        </div>
                    </div>
                </c:if>
            </div>
            <br>
            <div class="mb-3" id="" style="height: 280px;">
                <div class="d-flex justify-content-end">
                    <a href="<c:url value="/board/album"/>" class="btn btn-outline-light" style="color: black;">더보기</a>
                </div>
                <div id="albumCarouselIndicators" class="carousel slide" data-bs-ride="carousel" data-bs-interval="8000">
                    <div class="carousel-indicators">
                        <c:forEach var="albumVo" items="${albumVoList}" varStatus="stat">
                            <button type="button" data-bs-target="#albumCarouselIndicators" data-bs-slide-to="${stat.index}" <c:if test="${stat.index eq 1}"> class="active" </c:if>aria-current="true" aria-label="Slide ${stat.index}"></button>
                        </c:forEach>
                    </div>
                    <div class="carousel-inner" style="height: 230px; background-color: #b3b4b5;">
                        <c:forEach var="albumVo" items="${albumVoList}" varStatus="stat">
                            <div class="carousel-item <c:if test="${stat.index eq 0}"> active </c:if>">
                                <img src="/upload/${albumVo.fileName}" class="d-block h-100 mx-auto" alt="album${stat.count}" style="object-fit: cover;">
                            </div>
                        </c:forEach>
                    </div>
                    <button class="carousel-control-prev" type="button" data-bs-target="#albumCarouselIndicators" data-bs-slide="prev">
                        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                        <span class="visually-hidden">Previous</span>
                    </button>
                    <button class="carousel-control-next" type="button" data-bs-target="#albumCarouselIndicators" data-bs-slide="next">
                        <span class="carousel-control-next-icon" aria-hidden="true"></span>
                        <span class="visually-hidden">Next</span>
                    </button>
                </div>
            </div>

            <div class="d-flex" style="height: 220px;">
                <div id='calendar' style="width: 50%;"></div>
                <div style="width: 50%;">
                    <div class="row mt-2" style="height: 80px;">
                        <div class="col-6" style="height: 80px;">
                            <p class="d-flex align-items-center justify-content-end" style="font-size: 4em;">
                                <c:if test="${weather.PTY eq 0 and weather.SKY eq 1}"><i class="bi bi-sun"></i></c:if>
                                <c:if test="${weather.PTY eq 0 and weather.SKY eq 3}"><i class="bi bi-cloud-sun"></i></c:if>
                                <c:if test="${weather.PTY eq 0 and weather.SKY eq 4}"><i class="bi bi-clouds-fill"></i></c:if>
                                <c:if test="${weather.PTY eq 1}"><i class="bi bi-cloud-rain"></i></c:if>
                                <c:if test="${weather.PTY eq 2}"><i class="bi bi-cloud-sleet"></i></c:if>
                                <c:if test="${weather.PTY eq 3}"><i class="bi bi-cloud-snow"></i></c:if>
                                <c:if test="${weather.PTY eq 4}"><i class="bi bi-cloud-rain-heavy"></i></c:if>
                                <c:if test="${weather.error}">www.data.go.kr</c:if>
                            </p>
                        </div>
                        <div class="col-6" style="height: 80px;">
                            <p>온도: <span>${weather.TMP}</span>&#8451;</p>
                            <p>풍속: <span>${weather.WSD}</span>m/s</p>
                        </div>
                    </div>
                    <div class="text-center nanumpenscript">
                        <span>오늘의 한마디</span><br>
                        <span>${todayQuote}</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- 회원가입 폼 --%>
<div class="modal fade" id="signupModal" tabindex="-1" aria-labelledby="signupModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="signupModalLabel">회원 가입</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form id="signupForm" action="<c:url value='/sign/signup'/>" method="post" onsubmit="return validateSignForm()">
                <div class="modal-body">
                    <div class="row mb-3">
                        <label for="uId" class="col-sm-4 col-form-label">아이디: </label>
                        <div class="col-sm-8" style="display: flex;">
                            <input type="text" class="form-control" style="width: 67%; margin-right: 9px;" id="uId" name="uId" required />
                            <input type="button" id="dupChk" class="btn btn-info" value="중복검사" />
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label for="uPw" class="col-sm-4 col-form-label">비밀번호: </label>
                        <div class="col-sm-8">
                            <input type="password" class="form-control" id="uPw" name="uPw" placeholder="영어와 숫자를 조합한 4자 이상" required />
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label for="uPwChk" class="col-sm-4 col-form-label">비밀번호 확인: </label>
                        <div class="col-sm-8">
                            <input type="password" class="form-control" id="uPwChk" required />
                            <div id="pwAlert" style="font-size: small; display: flex; justify-content: flex-end;"></div>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label for="uName" class="col-sm-4 col-form-label">이름: </label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" id="uName" name="uName" required />
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label for="uTelNo" class="col-sm-4 col-form-label">연락처: </label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" id="uTelNo" name="uTelNo" required />
                        </div>
                    </div>
                    <div class="row mb-3">
                        <label for="uEmail" class="col-sm-4 col-form-label">이메일: </label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" id="uEmail" name="uEmail" />
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-sm-4">
                            <label for="searchChild" class="">원생: </label>
                            <div class="d-flex align-items-center">
                                <label for="teacherChkBox" style="font-size: 11px;">교원 회원가입</label>
                                <input type="checkbox" class="form-check ms-2" id="teacherChkBox" />
                            </div>
                        </div>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" id="searchChild" placeholder="원생 이름을 입력해주세요."/>
                            <input type="text" class="form-control d-none" id="teacherId" placeholder="발급받은 교원 ID를 입력해주세요."/>
                        </div>
                    </div>
                    <div class="mb-3">
                        <table class="table">
                            <thead>
                            <tr class="text-center">
                                <th>번호</th>
                                <th>학급</th>
                                <th>이름</th>
                                <th>생년월일</th>
                                <th colspan="2">관계</th>
                            </tr>
                            </thead>
                            <tbody id="childList"></tbody>
                        </table>
                        <input type="hidden" name="uChildNum" />
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                    <button type="submit" class="btn btn-primary">가입하기</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%-- Id 찾기 모달 --%>
<div class="modal fade" id="searchIdPwModal" tabindex="-1" aria-labelledby="searchIdPwModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="searchIdPwModalLabel">ID 찾기</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="row d-flex align-items-center mb-2">
                        <div class="col-3"><label for="searchByChildName">원생 명</label></div>
                        <div class="col-9"><input type="text" class="form-control idSearchParam" id="searchByChildName" /></div>
                    </div>
                    <div class="row d-flex align-items-center mb-2">
                        <div class="col-3"><label for="searchByChildBirth">원생 생일</label></div>
                        <div class="col-9"><input type="date" class="form-control idSearchParam" id="searchByChildBirth" /></div>
                    </div>
                    <div class="row d-flex align-items-center mb-2">
                        <div class="col-3"><label for="searchByTelNo">전화번호</label></div>
                        <div class="col-9"><input type="text" class="form-control idSearchParam" id="searchByTelNo" /></div>
                    </div>
                    <div class="row">
                        <div class="col-10 row" id="idResult"></div>
                        <div class="col-2 d-flex justify-content-end">
                            <input type="button" class="btn btn-primary" id="searchId" value="찾기" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- Id 찾기/정보수정--%>
<script>
    $('#searchByTelNo').on('input', function(event){
        if (event.originalEvent.inputType === 'deleteContentBackward' ) {
            if($(this).val().length === 3 || $(this).val().length === 8){
                $(this).val($(this).val().substring(0, $(this).val().length-1))
            }
        }
        else{
            if(isNaN(event.originalEvent.data) || $(this).val().length > 13){
                $(this).val($(this).val().substring(0, $(this).val().length-1))
            }
            if($(this).val().length === 3 || $(this).val().length === 8){
                $(this).val($(this).val() + '-');
            }
        }
    });

    $('#searchId').on('click', function(){
        $('.idSearchParam').each(function(){
            if($(this).val() === ""){
                alert('정보를 입력해주세요.');
                return false;
            }
        });

        let data = {
            childName: $('#searchByChildName').val(),
            childBirth: $('#searchByChildBirth').val(),
            telNo: $('#searchByTelNo').val()
        }

        $.ajax({
            url: '/sign/searchId',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function(result){
                let html = '';
                if(result.length !== 0){
                    html += '<div class="col-5"><span>검색 결과: </span></div><div class="col-7">';
                    for(let i=0; i<result.length; i++){
                        html += '<span>' + result[i].id + '</span><br>';
                    }
                    html += '</div>';
                    html += '<span style="color: red;">비밀번호가 생각나지 않는 경우 관리자에게<br>문의하시면 임시 비밀번호를 발급해드립니다.<br>로그인 후 반드시 비밀번호를 변경해주세요.</span>';
                }else{
                    html += '<span style="color: red;">일치하는 정보가 없습니다.</span>';
                }
                $('#idResult').html(html);
            }
        });
    });

    $('#searchIdPwModal').on('hidden.bs.modal', function () {
        $('.idSearchParam').val('');
        $('.pwSearchParam').val('');
        $('#idResult').html('');
        $('#pwResult').html('');
    });


</script>

<%-- 로그인/회원가입 --%>
<script>
    <c:if test="${sessionScope.loginFailed ne null}">
        let loginFailed = '${sessionScope.loginFailed}';
        if(loginFailed === 'noUser'){
            alert('정보가 없습니다.');
        }else if(loginFailed === 'noApproval'){
            alert('관리자 승인 대기중입니다.');
        }
        <% session.removeAttribute("loginFailed"); %>
    </c:if>

    let dupChk = false;
    let relationChk = false;
    let $teacherChkBox = $('#teacherChkBox');

    function validateSignForm() {
        let $email = $('#uEmail').val();
        let emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        let $password = $('#uPw').val();
        let passwdRegex = /^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d!@#$%^&*()\-_=+{};:,<.>]{4,}$/;

        if (!dupChk) {
            alert('아이디 중복검사를 해주세요.');
            return false;
        }
        if (!passwdRegex.test($password)){
            alert('비밀번호는 영어와 숫자를 조합한 4자 이상이어야 합니다.');
            return false;
        }
        if (!emailRegex.test($email)){
            alert('이메일 형식이 올바르지 않습니다.');
            return false;
        }
        if (!relationChk && !$teacherChkBox[0].checked) {
            alert('원생과의 관계를 입력해주세요.')
            return false;
        }
        if($teacherChkBox[0].checked){
            console.log('asdasas');
            let data = {
                id: $('#teacherId').val(),
                delYn: 'all'
            }

            $.ajax({
                url: '/teacher/searchByCond',
                contentType: 'application/json;charset=utf-8',
                data: JSON.stringify(data),
                type: 'post',
                success: function(result){
                    console.log(result);
                    if(result.length < 1){
                        alert('등록되지 않은 교원번호입니다.');
                        return false;
                    }
                    $('#signUpForm').submit();
                    return true;
                }
            });
        }
        alert('가입신청이 완료되었습니다.\n관리자의 승인 후 로그인이 가능합니다.');
        return true;
    }

    $('#dupChk').on('click', function () {
        $.ajax({
            url: '/sign/dupChk',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify({uId: $('#uId').val()}),
            type: 'post',
            success(result) {
                if (result) {
                    dupChk = confirm('사용가능합니다.\n사용하시겠습니까?');
                } else {
                    alert('이미 사용중인 아이디입니다.');
                }
            }
        });
    });

    $('#uPwChk').on('input', function () {
        let $pwAlert = $('#pwAlert');
        if ($(this).val() !== $('#uPw').val()) {
            $pwAlert.text('비밀번호 불일치');
            $pwAlert.css('color', 'red');
        } else {
            $pwAlert.text('비밀번호 일치');
            $pwAlert.css('color', 'green');
        }
    });

    $('#uTelNo').on('input', function(event){
        if (event.originalEvent.inputType === 'deleteContentBackward' ) {
            if($(this).val().length === 3 || $(this).val().length === 8){
                $(this).val($(this).val().substring(0, $(this).val().length-1))
            }
        }
        else{
            if(isNaN(event.originalEvent.data) || $(this).val().length > 13){
                $(this).val($(this).val().substring(0, $(this).val().length-1))
            }
            if($(this).val().length === 3 || $(this).val().length === 8){
                $(this).val($(this).val() + '-');
            }
        }
    });

    let $searchChild = $('#searchChild');
    let isComposing = false;
    let lastKeyword = '';
    $searchChild.on('compositionstart', function(){
        isComposing = true;
    });

    $searchChild.on('compositionend', function(e){
        isComposing = false;
        const keyword = e.target.value.trim();
        if (keyword !== lastKeyword) {
            lastKeyword = keyword;
            fn_search(keyword);
        }
    });

    $searchChild.on('blur', function(e){
        const keyword = e.target.value.trim();
        if (keyword !== lastKeyword) {
            lastKeyword = keyword;
            fn_search(keyword);
        }
    });

    $searchChild.on('input', function (e) {
        if (!isComposing) {
            const keyword = e.target.value.trim();
            if (keyword !== lastKeyword) {
                lastKeyword = keyword;
                fn_search(keyword);
            }
        }
    });

    function fn_search(keyword){
        if(keyword === '')    return;

        $.ajax({
            url: '/sign/searchChild',
            contentType: 'application/json;charset=UTF-8',
            data: JSON.stringify({name: keyword, graduated: 'N'}),
            type: 'POST',
            success(result) {
                let listTbl = $('#childList');
                let html = '';
                for (let i = 0; i < result.length; i++) {
                    html += '<tr>';
                    html += '<td>' + result[i].num + '</td>';
                    html += '<td>' + result[i].grade + '</td>';
                    html += '<td>' + result[i].name + '</td>';
                    html += '<td>' + String(result[i].birth[0]).padStart(2, '0') + String(result[i].birth[1]).padStart(2, '0') + String(result[i].birth[2]).padStart(2, '0') + '</td>';
                    html += '<td>'
                    html += '<input type="radio" id="' + result[i].num + '_father" name="relation" class="relationRadio" value="F" /><label for="' + result[i].num + '_father">부</label>';
                    html += '</td>';
                    html += '<td>'
                    html += '<input type="radio" id="' + result[i].num + '_mother" name="relation" class="relationRadio" value="M" /><label for="' + result[i].num + '_mother">모</label>';
                    html += '</td>';
                    html += '</tr>';
                }
                listTbl.html(html);
            }
        });
    }

    $(document).on('click', '.relationRadio', function () {
        relationChk = true;
        $('input[name="uChildNum"]').val($(this)[0].id.split('_')[0]);
    })

    // 모달이 닫힐 때 폼 내용 초기화
    $('#signupModal').on('hidden.bs.modal', function () {
        dupChk = false;
        relationChk = false;
        $('#childList').html('');
        $('#pwAlert').text('');
        $('#signupForm')[0].reset();
    });

    $teacherChkBox.on('click', function(){
        let $teacherId = $('#teacherId');

        let flag = $(this)[0].checked;
        if(flag){
            $searchChild.prop('disabled', true).val('');
            $('#childList').html('');

            $searchChild.addClass('d-none');
            $teacherId.removeClass('d-none');
        }else{
            $('#searchChild').prop('disabled', false);
            $teacherId.val('');

            $teacherId.addClass('d-none');
            $searchChild.removeClass('d-none');
        }
    });
</script>

<%-- 식단표 --%>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        let calendarEl = document.getElementById('calendar');
        let calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridDay',
            locale: 'ko',
            height: 'auto',
            headerToolbar: {
                left: 'prev',
                center: 'today',
                right: 'next'
            },
            dayHeaderFormat: { year: 'numeric', month: 'short', day: 'numeric' },
            events: [
                <c:forEach var="food" items="${foodVoList}" varStatus="stat">
                {
                    title: "",
                    customHtml: "${food.meal}",
                    start: "${fn:replace(food.mealDate, 'T', ' ')}",
                    end: "${fn:replace(food.mealDate, 'T', ' ')}",
                    allDay: true,
                    color: "transparent",
                    textColor: "#000000"
                },
                </c:forEach>
            ],
            eventContent: function (eventInfo) {
                return {html: eventInfo.event.extendedProps.customHtml }
            },
            datesSet: function () {
                setTimeout(() => {
                    let eventElements = document.querySelectorAll('.fc-event');
                    let existingMessage = document.querySelector('.no-events-message');

                    // 기존 메시지 삭제 (중복 방지)
                    if (existingMessage) {
                        existingMessage.remove();
                    }

                    // 이벤트가 없으면 메시지 추가
                    if (eventElements.length === 0) {
                        let noEventMessage = document.createElement('div');
                        noEventMessage.classList.add('no-events-message');
                        noEventMessage.innerText = '오늘은 식단을\n제공하지 않습니다.';
                        noEventMessage.style.backgroundColor = $('td[role="gridcell"]').css('backgroundColor');
                        document.querySelector('.fc-daygrid-body').appendChild(noEventMessage);
                    }
                }, 10);
            }
        });
        calendar.render();
    });
</script>

<%-- 게시판 --%>
<script>
    function getBestBoard(){
        let data = {
            category: $('.nav-link.active')[0].dataset.text,
            count: 5,
            order: $('input[name="order"]:checked').val()
        }

        $.ajax({
            url: '/board/getBest',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function(result){
                let $bestBoardTbl = $('#bestBoardTbl');
                $bestBoardTbl.html('');
                for(let i=0; i<result.length; i++){
                    let tr = '';
                    tr += '<tr class="trs" data-num="' + result[i].num + '">';
                    tr += '<td>' + result[i].title + '</td>';
                    tr += '<td class="text-center">' + result[i].writerName + '</td>';
                    tr += '<td class="text-center">' + result[i].regDate[0] + '-' + String(result[i].regDate[1] ?? '').padStart(2, '0') + '-' + String(result[i].regDate[2] ?? '').padStart(2, '0') + '</td>';
                    tr += '<td class="text-center">' + result[i].viewCnt + '</td>';
                    tr += '<td class="text-center">' + result[i].likeCnt + '</td>';
                    tr += '</tr>';
                    $bestBoardTbl.append(tr);
                }
            }
        });
    }

    $('.bestBoardTab').on('click', function(event){
        event.preventDefault();
        $('.bestBoardTab').removeClass('active');
        $(this).addClass('active');
        getBestBoard();
    });

    $('input[name="order"]').on('change', function(){
        getBestBoard();
    });

    $(document).on('click', '.trs', function(){
        location.href = 'board/detail?num=' + $(this)[0].dataset.num;
    });
</script>

<%-- 날씨 --%>
<script>
    let weather = '${weather}'
    console.log(weather);
</script>