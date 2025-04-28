<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.js'></script>
<link href="https://fonts.googleapis.com/css2?family=Pacifico&display=swap" rel="stylesheet">
<style>
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
            <div class="bestBoard" style="height: 300px;">
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
            <hr>
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
                            <input type="button" value="ID/PW 찾기" class="btn btn-secondary ms-3" onclick="{alert('미구현\nindex.jsp[127]')}"/>
                        </div>
                    </form>
                </c:if>
                <c:if test="${sessionScope.loginUser ne null}">
                    <div>
                        <p>${sessionScope.loginUser.name}님 환영합니다.</p>
                        <input type="button" class="btn btn-primary" id="logout" value="logout" />
                    </div>
                </c:if>
            </div>
            <br>
            <div class="test_div mb-3" id="" style="height: 280px; overflow-y: auto;">
                <p> // index.jsp [140] 페이지 통계 화면 만들기 (금) </p>
                <p> // index.jsp [141] 설정 화면 만들기 (금) </p>
                <p> // index.jsp [142] 회원 가입 및 id/pw 찾기 -> 가입승인, 권한설정 (화)</p>
                <p> // index.jsp [143] 게시판 목록에 '앨범' 추가해서 관리자만 글 작성할수 있도록 (수) </p>
                <p> // index.jsp [144] 여기에는 뭘 넣을까? -> 교실별 일일 계획안 or 앨범게시판 랜덤 사진 (목) </p>
                <p> // index.jsp [145] 식단표 영역 옆에 날씨 위젯 + 오늘의 한마디(폰트 찾아보기) (목) </p>
            </div>

            <div class="d-flex" style="height: 220px;">
                <div id='calendar' style="width: 50%;"></div>
                <div style="width: 50%;">
                    <div>날씨 위젯</div>
                    <div class="text-center" style="font-family: Shadows Into Light, cursive, sans-serif;">
                        <p>오늘의 한마디</p>
                        <p>${todayQuote}</p>
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
            <form id="signupForm" action="<c:url value='/sign/signup'/>" method="post" onsubmit="return validateForm()">
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
                            <input type="password" class="form-control" id="uPw" name="uPw" required />
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
                        <label for="searchChild" class="col-sm-4 col-form-label">원생: </label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" id="searchChild" placeholder="원생 이름을 입력해주세요."/>
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

    function validateForm() {
        if (!dupChk) {
            alert('아이디 중복검사를 해주세요.');
            return false;
        }
        if (!relationChk) {
            alert('원생과의 관계를 입력해주세요.')
            return false;
        }
        alert('가입신청이 완료되었습니다.\n승인이 되면 입력해주신 연락처로 완료 문자가 발송됩니다.');
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

    $('#searchChild').on('input', function (event) {
        if($(this).val() === '')    return;
        $.ajax({
            url: '/sign/searchChild',
            contentType: 'application/json;charset=UTF-8',
            data: JSON.stringify({keyword: $(this).val()}),
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
    });

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
</script>

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
            datesSet: function (info) {
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