<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.js'></script>

<style>
    table td {
        border: 1px solid black;
    }
    .menu-table-title{

    }
    .menu-table-input{
        width: 80%;
        resize: none;
        border: none;
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
    .fc-insert-button{
        background-color: #28a745 !important;  /* 배경색 */
        border-color: #28a745 !important;  /* 배경색 */
        color: white !important;               /* 글자색 */
        border-radius: 5px !important;         /* 버튼 둥글게 */
        font-weight: bold !important;          /* 글자 굵게 */
        padding: 5px 10px !important;          /* 패딩 조정 */
    }
    .fc-download-button{
        background-color: #007bff !important;  /* 배경색 */
        border-color: #007bff !important;  /* 배경색 */
        color: white !important;               /* 글자색 */
        border-radius: 5px !important;         /* 버튼 둥글게 */
        font-weight: bold !important;          /* 글자 굵게 */
        padding: 5px 10px !important;          /* 패딩 조정 */
    }
</style>

<div class="container" id="calendarContainer">
    <input type="hidden" id="menuInsertBtn" data-bs-toggle="modal" data-bs-target="#foodModal" onclick="generateCalendar(currentDate.getFullYear(), currentDate.getMonth() + 1);" />
    <div id='calendar' style="margin-bottom: 20px;"></div>
</div>

<!-- Modal -->
<div class="modal fade" id="foodModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="foodModalLabel">식단표 수정</h1>
                <button type="button" class="btn-close" aria-label="Close" onclick="alertUnSave(event)"></button>
            </div>
            <div class="modal-body">
                <label for="yearMonth"></label>
                <input type="month" id="yearMonth" />
                <table>
                    <thead>
                        <tr class="text-center">
                            <th>일</th>
                            <th>월</th>
                            <th>화</th>
                            <th>수</th>
                            <th>목</th>
                            <th>금</th>
                            <th>토</th>
                        </tr>
                    </thead>
                    <tbody id="calendar-body"></tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="alertUnSave(event)">닫기</button>
                <button type="button" class="btn btn-primary" id="saveBtn">저장</button>
            </div>
        </div>
    </div>
</div>

<script>
    let calendar;
    let currentDate = new Date();
    let lastDayOfMonth = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0);
    let currentYearMonth;

    document.addEventListener('DOMContentLoaded', function() {
        let calendarEl = document.getElementById('calendar');
        calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            locale: 'ko',
            validRange: {
                end: lastDayOfMonth.toISOString().split('T')[0]
            },
            height: 'auto',
            headerToolbar: {
                left: 'prev,next today',
                center: 'title',
                right: 'insert download'
            },
            datesSet: function(info) {
                let currentYear = info.view.currentStart.toString().split(' ')[3];
                let currentMonth = info.view.currentStart.toString().split(' ')[1];
                currentYearMonth = currentYear + '년 ';
                switch(currentMonth){
                    case 'Jan': currentYearMonth += 1;    break;
                    case 'Feb': currentYearMonth += 2;    break;
                    case 'Mar': currentYearMonth += 3;    break;
                    case 'Apr': currentYearMonth += 4;    break;
                    case 'May': currentYearMonth += 5;    break;
                    case 'Jun': currentYearMonth += 6;    break;
                    case 'Jul': currentYearMonth += 7;    break;
                    case 'Aug': currentYearMonth += 8;    break;
                    case 'Sep': currentYearMonth += 9;    break;
                    case 'Oct': currentYearMonth += 10;   break;
                    case 'Nov': currentYearMonth += 11;   break;
                    case 'Dec': currentYearMonth += 12;   break;
                }
                $('.fc-toolbar-title').html('<span style="font-size: 40px; font-weight: bold; color: #418d15;">📅 ' + currentYearMonth + '월 식단표</span>');
            },
            customButtons:{
                insert:{
                    text: '식단표 입력',
                    click: function(){
                        $('#menuInsertBtn').click();
                    }
                },
                download: {
                    text: '다운로드',
                    click: function(){
                        downloadByExcel(currentYearMonth);
                    }
                }
            },
            dayCellDidMount: function(info) {
                let day = info.date.getDay(); // 0: 일요일, 6: 토요일
                if (day === 0) {
                    info.el.style.backgroundColor = "#fee8e8";
                }
                if (day === 6) {
                    info.el.style.backgroundColor = "#e8fefc";
                }
            },
            events:[
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
            eventContent: function(eventInfo) {
                return { html: eventInfo.event.extendedProps.customHtml }
            }
        });
        calendar.render();
    });
</script>

<script>
    let foodVoList = [
        <c:forEach var="food" items="${foodVoList}">
        {
            mealDate: "${food.mealDate}",
            meal: "${food.meal}"
        },
        </c:forEach>
    ];

    let $yearMonth = $('#yearMonth');

    function generateCalendar(year, month) {
        unsaved = false;
        if(typeof(month) === 'number' && month < 10) month = '0' + month;
        $yearMonth.val(year + '-' + month);
        const $tbody = $("#calendar-body");
        $tbody.empty(); // 기존 내용 초기화

        const firstDay = new Date(year, month - 1, 1); // 이번 달의 1일
        const lastDay = new Date(year, month, 0); // 이번 달의 마지막 날

        const startDay = firstDay.getDay(); // 이번 달 1일의 요일 (0:일요일, 1:월요일 ...)
        const totalDays = lastDay.getDate(); // 이번 달의 총 날짜 수

        let $row = $("<tr>"); // 첫 번째 줄 생성
        let cellCount = 0;

        // 첫 번째 주의 빈칸 추가
        for (let i = 0; i < startDay; i++) {
            $row.append("<td></td>");
            cellCount++;
        }

        // 날짜 추가
        for (let day = 1; day <= totalDays; day++) {
            if(day < 10) day = '0' + day;
            let dateStr = $yearMonth.val() + '-' + day;
            $row.append('<td class="text-center"><span class="menu-table-title" style="font-weight: bold;">' + day + '</span><br><textarea class="menu-table-input" data-date="' + dateStr + '" rows="6" ></textarea></td>');
            cellCount++;

            // 한 줄이 끝나면 다음 줄 추가
            if (cellCount % 7 === 0) {
                $tbody.append($row);
                $row = $("<tr>"); // 새로운 줄 생성
            }
        }

        // 마지막 줄의 빈칸 추가
        while (cellCount % 7 !== 0) {
            $row.append("<td></td>");
            cellCount++;
        }

        $tbody.append($row); // 마지막 줄 추가

        foodVoList.forEach(food => {
            let date = food.mealDate;
            let meal = food.meal;
            let $textarea = $('textarea[data-date="' + date + '"]');
            $textarea.val(meal.replaceAll('<br>', '\n'));  // 해당 날짜의 textarea에 값 채우기
        });
    }

    $yearMonth.on('change', function(){
        let year = $(this).val().split('-')[0];
        let month = $(this).val().split('-')[1];
        generateCalendar(year, month);
    });

    let unsaved = false;
    $(document).on('input', 'textarea', function(){
        unsaved = true;
    });
    function alertUnSave(event){
        if(unsaved){
            if(!confirm('정말로 닫으시겠습니까? 저장되지 않은 내용은 삭제됩니다.')){
                event.preventDefault();
                return false;
            }
        }
        $('#foodModal').modal('hide');
    }

    $('#saveBtn').on('click', function(){
        let data = {};
        let menus = $('.menu-table-input');
        for(let i=0; i<menus.length; i++){
            let date = menus[i].dataset.date;
            data[date] = menus[i].value;
        }

        $.ajax({
            url: '/food/update',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function(result){
                $('#foodModal').modal('hide');
                location.reload();
            }
        });
    });
</script>

<script>
    function downloadByExcel(yearMonth){
        location.href = '/food/download?yearMonth='+yearMonth;
    }
</script>