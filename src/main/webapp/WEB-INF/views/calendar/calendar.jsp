<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
</style>
<div class="container" id="calendarContainer">
    <div id='calendar'></div>

    <div id="eventList">
        <h3>
            <span id="selectedDay"></span>
            <span id="closeBtn">X</span>
        </h3>
        <ul id="eventItems">

        </ul>
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
                <input type="text" id="newEventTitle" />
                <input type="text" id="newEventDate" />

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                <button type="button" class="btn btn-primary" id="addEvent">추가</button>
            </div>
        </div>
    </div>
</div>

<script>
    let isPanelVisible = false;
    let calendar;

    document.addEventListener('DOMContentLoaded', function() {
        let calendarEl = document.getElementById('calendar');
        calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            locale: 'ko',
            height: '600px',
            headerToolbar: {
                left: 'prev,next today',
                center: '',
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
            dateClick: function(info){
                $('#selectedDay').text(info.dateStr);
                if (!isPanelVisible) {
                    $('#eventList').addClass('visible');
                    $('#calendarContainer').css('gap', '10px');
                    setTimeout(function(){
                        calendar.render();
                    }, 300);
                    isPanelVisible = true;
                }
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

    function openAddEventModal(){
        $('#newEventBtn').click();
    }

    $('#addEvent').on('click', function(){
        let newEventTitle = $('#newEventTitle').val();
        let newEventDate = $('#newEventDate').val();
        calendar.addEvent({
            title: newEventTitle,
            start: newEventDate,
            allDay: true
        });
        $('#newEventModal').modal('hide');
    });
</script>