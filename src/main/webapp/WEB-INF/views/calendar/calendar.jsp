<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.js'></script>
<style>
    #calendarContainer{
        min-height: 700px;
        display: flex;
        transition: all 0.3s ease; /* 애니메이션을 위해 transition 적용 */
    }
    #calendar {
        flex: 1;  /* 캘린더가 초기에는 화면을 꽉 채우도록 설정 */
        transition: flex 0.3s ease;  /* 캘린더 크기가 줄어들 때 애니메이션 */
    }
    #eventList {
        width: 0;
        background: #f9f9f9;
        overflow: hidden;
        transition: width 0.3s ease;
    }
    #eventList.visible {
        width: 300px; /* 패널이 보일 때 width가 300px로 늘어남 */
    }
    .fc-toolbar-title{
        color: #be40ba;
    }
</style>
<div class="container" id="calendarContainer">
    <div id='calendar'></div>

    <div id="eventList">
        <h3 style="display: flex; justify-content: space-between">
            <span id="selectedDay" style="margin-left: 10px;"></span>
            <a class="btn btn-light" id="closeBtn" style="margin-right: 10px;">X</a>
        </h3>
        <ul id="eventItems"></ul>
    </div>
</div>

<!-- 일정 추가 모달 -->
<input type="hidden" id="newEventBtn" data-bs-toggle="modal" data-bs-target="#newEventModal" />
<div class="modal fade" id="newEventModal" tabindex="-1" aria-labelledby="newEventModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="newEventModalLabel">새 일정</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="writerId" value="${sessionScope.loginUser.id}" />
                <input type="text" class="eventElement" id="newEventTitle" />
                <input type="date" class="eventElement" id="newEventStrDate" />
                <input type="date" class="eventElement" id="newEventEndDate" />
                <c:if test="${sessionScope.loginUser.auth eq 'A' or sessionScope.loginUser.auth eq 'T'}">
                    <input type="radio" id="all" name="gubun" value="ALL" checked><label for="all">전체일정</label>
                    <input type="radio" id="personal" name="gubun" value="PERSONAL"><label for="personal">개인일정</label>
                </c:if>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" onclick="eventModalReset()">닫기</button>
                <button type="button" class="btn btn-primary" id="addEvent">추가</button>
            </div>
        </div>
    </div>
</div>

<!-- 일정 수정 모달 -->
<input type="hidden" id="modEventBtn" data-bs-toggle="modal" data-bs-target="#modEventModal" />
<div class="modal fade" id="modEventModal" tabindex="-1" aria-labelledby="modEventModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="modEventModalLabel">일정 수정</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="writerId" value="${sessionScope.loginUser.id}" />
                <input type="text" class="eventElement" id="modEventTitle" value="" />
                <input type="date" class="eventElement" id="modEventStrDate" value="" />
                <input type="date" class="eventElement" id="modEventEndDate" value="" />
                <c:if test="${sessionScope.loginUser.auth eq 'A' or sessionScope.loginUser.auth eq 'T'}">
                    <input type="radio" id="all_mod" name="gubun_mod" value="ALL"><label for="all_mod">전체일정</label>
                    <input type="radio" id="personal_mod" name="gubun_mod" value="PERSONAL"><label for="personal_mod">개인일정</label>
                </c:if>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" onclick="eventModalReset()">닫기</button>
                <button type="button" class="btn btn-danger" id="delEvent">삭제</button>
                <button type="button" class="btn btn-primary" id="modEvent">수정</button>
            </div>
        </div>
    </div>
</div>

<script>
    let isPanelVisible = false;
    let calendar;
    let eventId;

    document.addEventListener('DOMContentLoaded', function() {
        let calendarEl = document.getElementById('calendar');
        calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            locale: 'ko',
            height: '600px',
            headerToolbar: {
                left: 'prev,next today',
                center: 'title',
                right: 'addEvent dayGridMonth,dayGridWeek,dayGridDay'
            },
            customButtons: {
                addEvent: {  // 사용자 정의 버튼 추가
                    text: '일정 추가',
                    click: function() {
                        openAddEventModal();
                    }
                }
            },
            events:[
                <c:forEach var="event" items="${eventList}" varStatus="stat">
                {
                    id: "${event.num}",
                    title: "${event.title}",
                    start: "${fn:replace(event.strDate, 'T', ' ')}",
                    end: "${fn:replace(event.endDate, 'T', ' ')}",
                    allDay: true,
                    <c:if test="${event.gubun eq 'PERSONAL'}">color: "#d97ee7"</c:if>
                },
                </c:forEach>
            ],
            selectable: true,
            select: function(info){
                let endDate = new Date(info.endStr);
                endDate.setDate(endDate.getDate() - 1);
                $('#newEventStrDate').val(info.startStr);
                $('#newEventEndDate').val(endDate.toISOString().split('T')[0]);
            },
            dateClick: openEventList,
            eventClick: function (info){
                let event = info.event;
                eventId = event.id;
                let auth = '${sessionScope.loginUser.auth}';
                if(event.backgroundColor !== '#d97ee7'){
                    if(auth !== 'A' && auth !=='T'){
                        alert('권한이 없습니다.');
                        return false;
                    }
                }

                $('#modEventTitle').val(event.title);
                $('#modEventStrDate').val(formatDateToYMD(event.start));
                let endDate = new Date(event.end);
                endDate.setDate(endDate.getDate() - 1);
                $('#modEventEndDate').val(formatDateToYMD(endDate));
                if(event.backgroundColor === '#d97ee7'){
                    $('#personal_mod').prop('checked', true);
                }else{
                    $('#all_mod').prop('checked', true);
                }
                $('#modEventBtn').click();
            }
        });
        calendar.render();
    });

    $('#closeBtn').on('click', function(){
        $('#eventList').removeClass('visible');
        $('#calendarContainer').css('gap', '0');
        setTimeout(function(){
            calendar.render();
        }, 300);
        isPanelVisible = false;
    });

    function openEventList(info){
        let dateStr = info.dateStr ? info.dateStr : info.event.startStr;
        $.ajax({
            url: '/calendar/getEvents',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify({
                date: dateStr
            }),
            type: 'post',
            success: function(result){
                let str = '';
                for(let i=0; i<result.length; i++){
                    str += '<li>';
                    str += result[i].title;
                    str += '</li>';
                }
                $('#eventItems').html(str);
                $('#selectedDay').text(dateStr);
                if (!isPanelVisible) {
                    $('#eventList').addClass('visible');
                    $('#calendarContainer').css('gap', '10px');
                    setTimeout(function(){
                        calendar.render();
                    }, 300);
                    isPanelVisible = true;
                }
                $('#newEventStrDate').val(info.dateStr);
                $('#newEventEndDate').val(info.dateStr);
            }
        });
    }

    function openAddEventModal(){
        let writerId = $('#writerId').val();
        if(writerId === ''){
            alert('로그인이 필요합니다.');
            return;
        }
        $('#newEventBtn').click();
    }

    $('#addEvent').on('click', function(){
        let writerId = $('#writerId').val();
        let gubun = $('input[name="gubun"]:checked').val();
        let newEventTitle = $('#newEventTitle').val();
        let newEventStrDate = $('#newEventStrDate').val();
        let newEventEndDate = $('#newEventEndDate').val();
        let endDate = new Date(newEventEndDate);
        endDate.setDate(endDate.getDate()+1);
        let data = {
            writerId: writerId,
            gubun: gubun,
            title: newEventTitle,
            start: newEventStrDate,
            end: endDate.toISOString().split('T')[0],
            allDay: true
        }
        if(gubun === 'PERSONAL'){
            data.color = '#d97ee7'
        }
        $.ajax({
            url: '/calendar/addEvent',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function(result){
                calendar.addEvent(data);
                eventModalReset();
                $('#newEventModal').modal('hide');
            }
        })
    });

    function eventModalReset(){
        $('.eventElement').val('');
    }

    function formatDateToYMD(date) {
        const year = date.getFullYear();
        const month = ('0' + (date.getMonth() + 1)).slice(-2); // 월은 0부터 시작
        const day = ('0' + date.getDate()).slice(-2);
        return year + '-' + month + '-' + day;
    }

    $('#modEvent').on('click', function(){
        let $radio = $('input[name="gubun_mod"]:checked').val()
        let gubun = $radio ? $radio : 'PERSONAL';
        let title = $('#modEventTitle').val();
        let strDate = $('#modEventStrDate').val();
        let endDate = new Date($('#modEventEndDate').val());
        endDate.setDate(endDate.getDate()+1);
        let color = gubun === 'PERSONAL' ? '#d97ee7' : '';
        let data = {
            num: eventId,
            gubun: gubun,
            title: title,
            strDate: strDate,
            endDate: endDate.toISOString().split('T')[0],
            allDay: true
        }
        if(gubun === 'PERSONAL'){
            data.color = color
        }

        $.ajax({
            url: '/calendar/modEvent',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function(result){
                console.log(result);
                // 화면 바꾸기
                let event = calendar.getEventById(eventId);
                if(event){
                    console.log(strDate)
                    console.log(formatDateToYMD(endDate))
                    event.setProp('title', title);
                    event.setProp('color', color);
                    event.setStart(strDate);
                    event.setEnd(endDate);
                    event.setAllDay(true);

                    if (gubun === 'PERSONAL') {
                        event.setProp('backgroundColor', '#d97ee7');
                    } else {
                        event.setProp('backgroundColor', '');
                    }

                    $('#modEventModal').modal('hide');
                }
            }
        });
    });

    $('#delEvent').on('click', function(){
        let data = {
            num: eventId
        }

        $.ajax({
            url: '/calendar/delEvent',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function(result){
                console.log(result);
                let event = calendar.getEventById(eventId);
                if(event){
                    event.remove();
                    $('#modEventModal').modal('hide');
                }
            }
        });
    });
</script>