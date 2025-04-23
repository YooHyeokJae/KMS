<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<style>
    #attendance td{
        border: 1px solid black;
    }
    #diagonalCell{
        width: 100px;
        background: linear-gradient(-165deg, transparent 49%, #000 50%, transparent 52%);
    }
    .dayCell:hover{
        background-color: lightgray;
    }
    .dayCell{
        text-align: center;
    }
    .P{
        background-color: #A8E6CF;
    }
    .T{
        background-color: #FFF176;
    }
    .A{
        background-color: #FF8A80;
    }
    .L{
        background-color: #FFD180;
    }
    .E{
        background-color: #81D4FA;
    }
    .O{
        background-color: #FFFFFF;
    }
    .custom-tooltip{
        --bs-tooltip-max-width: 300px;
    }
    .text-left{
        text-align: left;
    }
</style>
<div class="container">
    <div class="d-flex justify-content-between">
        <h2 style="border-bottom: 2px solid #333; display: inline-block; padding: 5px 12px; border-radius: 10px;">
            <span style="color: #283593"><i class="bi bi-file-ruled"></i> 출석부</span>
        </h2>
    </div>

    <div class="row" style="min-height: 400px; margin-bottom: 10px;">
        <div class="col-3" style="border-right: 1px solid black">
            <ul class="list-group">
                <li class="list-group-item text-center" style="background-color: lightgray">교실</li>
                <c:forEach var="grade" items="${gradeVoList}" varStatus="stat">
                    <li class="list-group-item gradeList" data-num="${grade.num}">${grade.name}</li>
                </c:forEach>
            </ul>
        </div>
        <div class="col-9">
            <div class="row mb-2">
                <div class="col-4 d-flex align-items-center justify-content-start">
                    <i class="bi bi-exclamation-circle" data-bs-toggle="tooltip" data-bs-placement="right" data-bs-html="true" data-bs-custom-class="custom-tooltip"
                       data-bs-title="
                       <div class='text-left'>출석(P): 정상 출석<br>지각(T): 지정 시간 이후 등원<br>결석(A): 별도 사유 없이 미등원<br>공결(E): 사전 승인된 사유로 미등원<br>기타(O): 분류 외 사유</div>"></i>
                </div>
                <div class="col-4 d-flex align-items-center justify-content-center">
                        <input type="button" class="btn btn-light me-3" id="prevMonth" value="<" />
                        <span id="month">${month}</span>월
                        <input type="button" class="btn btn-light ms-3" id="nextMonth" value=">" />
                </div>
                <div class="col-4 d-flex align-items-center justify-content-end">
                    <c:if test="${sessionScope.loginUser.auth eq 'A'}">
                            <input type="button" id="allPresent" class="btn btn-outline-info" value="일괄 출석" disabled />
                            <input type="button" id="allAbsent" class="btn btn-outline-warning" value="일괄 결석" disabled />
                    </c:if>
                </div>
            </div>

            <div style="width: 100%; height: 370px; overflow-y: auto;">
                <table id="attendance" style="width: 100%">
                    <thead>
                        <tr>
                            <td id="diagonalCell"></td>
                            <c:forEach var="d" begin="1" end="31">
                                <td class="text-center" style="width: 30px;">${d}</td>
                            </c:forEach>
                        </tr>
                    </thead>
                    <tbody id="tbody"></tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<%-- 개별 출석 모달 --%>
<input type="hidden" id="attendanceBtn" data-bs-toggle="modal" data-bs-target="#attendanceModal" />
<div class="modal fade" id="attendanceModal" tabindex="-1" aria-labelledby="attendanceModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5 w-100" id="attendanceModalLabel">
                    <div class="row">
                        <div class="col-3"><span id="child" data-num=""></span></div>
                        <div class="col-9"><span id="date"></span></div>
                    </div>
                </h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>
                    <label for="present" class="me-1 form-check-label">출석</label>
                    <input type="radio" class="me-3 form-check-input" id="present" name="status" value="P" />
                    <label for="tardy" class="me-1 form-check-label">지각</label>
                    <input type="radio" class="me-3 form-check-input" id="tardy" name="status" value="T" />
                    <label for="leave" class="me-1 form-check-label">조퇴</label>
                    <input type="radio" class="me-3 form-check-input" id="leave" name="status" value="L" />
                    <label for="absent" class="me-1 form-check-label">결석</label>
                    <input type="radio" class="me-3 form-check-input" id="absent" name="status" value="A" />
                    <label for="excused" class="me-1 form-check-label">공결</label>
                    <input type="radio" class="me-3 form-check-input" id="excused" name="status" value="E" />
                    <label for="other" class="me-1 form-check-label">기타</label>
                    <input type="radio" class=" form-check-input" id="other" name="status" value="O" />
                </p>
                <p class="d-flex align-items-baseline">
                    <label for="note" class="me-2">비고</label>
                    <textarea id="note" rows="3" class="form-control" style="width: 90%; resize: none;" disabled></textarea>
                </p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                <button type="button" class="btn btn-primary" id="saveAttendance">저장</button>
            </div>
        </div>
    </div>
</div>

<script>
    const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
    const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl));

    function getAttendance(data){
        $('.dayCell').text('');
        $.ajax({
            url: '/education/getAttendanceByGrade',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function(result){
                for(let i=0; i<result.length; i++){
                    let cellId = result[i].childNum + '_' + result[i].attDate[2];
                    let $cell = $('#'+cellId);
                    $cell.text(result[i].status);
                    $cell.addClass(result[i].status);
                }
            }
        });
    }

    $('.gradeList').on('click', function(){
        $('#allPresent').removeAttr('disabled');
        $('#allAbsent').removeAttr('disabled');

        $('.gradeList').removeClass('active');
        $(this).addClass('active');

        let data = {
            month: $('#month').text(),
            graduated: 'N',
            grade: $(this)[0].dataset.num
        }

        $.ajax({
            url: '/children/searchByCond',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function(result){
                let html = '';
                for(let i=0; i<result.length; i++){
                    html += '<tr>';
                    html += '<td>' + result[i].name + '</td>'
                    for(let d=1; d<=31; d++){
                        html += '<td class="dayCell" id="' + result[i].num + '_' + d + '"></td>';
                    }
                    html += '</tr>';
                }
                $('#tbody').html(html);
                getAttendance(data);
            }
        });
    });

    $('#prevMonth').on('click', function(){
        let $month = $('#month');
        if(Number($month.text()) === 3) {
            return;
        } else if(Number($month.text()) === 1) {
            $month.text(Number(12));
        } else {
            $month.text(Number($month.text()) - 1);
        }

        let $active = $('.active');
        if($active.length === 0)   return;
        let gradeNum = $active[0].dataset.num;
        let data = {
            grade: gradeNum,
            month: $month.text()
        }
        getAttendance(data);
    });

    $('#nextMonth').on('click', function(){
        let $month = $('#month');
        if(Number($month.text()) === 2) {
            return;
        }else if(Number($month.text()) === 12) {
            $month.text(Number(1));
        }else{
            $month.text(Number($month.text()) + 1);
        }

        let $active = $('.active');
        if($active.length === 0)   return;
        let gradeNum = $active[0].dataset.num;
        let data = {
            grade: gradeNum,
            month: $month.text()
        }
        getAttendance(data);
    });

    $(document).on('click', '.dayCell', function(){
        if('${sessionScope.loginUser.auth}' !== 'A')    return;

        let $child = $('#child');
        $child[0].dataset.num = $(this)[0].id.split('_')[0];
        $child.text($(this).parent().children().eq(0).text());

        let year = new Date().getFullYear();
        let month = String($('#month').text()).padStart(2, '0');
        let date = String($(this)[0].id.split('_')[1]).padStart(2, '0');
        let day = new Date(year + '-' + month + '-' + date).getDay();
        const days = ['일', '월', '화', '수', '목', '금', '토'];
        $('#date').text(year + '-' + month + '-' + date + ' (' + days[day] + ')');

        let data = {
            childNum: $child[0].dataset.num,
            attDate: year + '-' + month + '-' + date,
        }

        $.ajax({
            url: '/education/getAttInfo',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function(result){
                let $note = $('#note');
                $note.prop('disabled', true).val(result.note);

                if(result.status === 'P')      $('#present').prop('checked', true);
                else if(result.status === 'T') $('#tardy').prop('checked', true);
                else if(result.status === 'L') $('#leave').prop('checked', true);
                else if(result.status === 'A') $('#absent').prop('checked', true);
                else if(result.status === 'E') $('#excused').prop('checked', true);
                else if(result.status === 'O') {
                    $('#other').prop('checked', true);
                    $note.prop('disabled', false);
                }
                else $('input[name="status"]').prop('checked', false);

                $('#attendanceBtn').click();
            }
        });
    });

    $('input[name="status"]').on('change', function(){
        if($(this).val() === 'O'){
            $('#note').prop('disabled', false);
        }else{
            $('#note').prop('disabled', true).val('');
        }
    });

    $('#saveAttendance').on('click', function(){
        let data = {
            childNum: $('#child')[0].dataset.num,
            date: $('#date').text().split(' ')[0],
            status: $('input[name="status"]:checked').val(),
            note: $('#note').val()
        }

        $.ajax({
            url: '/education/attProc',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function(result){
                result['grade'] = $('.active')[0].dataset.num;
                result['month'] = $('#month').text();
                getAttendance(result);
                $('#attendanceModal').modal('hide');
            }
        });
    })

    function allProc(data){
        data['date'] = new Date().toISOString().split('T')[0];
        data['grade'] = $('.active')[0].dataset.num;

        $.ajax({
            url: '/education/attAllProc',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function(result){
                result['month'] = $('#month').text();
                getAttendance(result);
            }
        });
    }

    $('#allPresent').on('click', function(){
        if(confirm('금일 모든 원생들을 출석처리 합니다.')){
            let data = {
                status: 'P'
            }
            allProc(data);
        }
    });

    $('#allAbsent').on('click', function(){
        if(confirm('금일 모든 원생들을 결석처리 합니다.')){
            let data = {
                status: 'A',
            }
            allProc(data);
        }
    });
</script>