<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<style>
    .select {
        color: white;
        background-color: #4368df;
    }

    /* 드래그 방지 */
    li {
        -webkit-user-select:none;
        -moz-user-select:none;
        -ms-user-select:none;
        user-select:none;
    }
</style>

<div class="container">
    <div class="row">
        <div class="col-4">
            <div class="row">
                <div class="col-10">
                    <div class="row">
                        <div class="col-2 d-flex align-items-center">
                            <label for="grade">학급</label>
                        </div>
                        <div class="col-10">
                            <input type="text" class="form-control" id="grade" style="margin-left: 10px;" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-2 d-flex align-items-center">
                            <label for="childName">이름</label>
                        </div>
                        <div class="col-10">
                            <input type="text" class="form-control" id="childName" style="margin-left: 10px;" />
                        </div>
                    </div>
                </div>
                <div class="col-2">
                    <button class="btn btn-light" id="childSearch" style="height: 100%;">
                        <i class="bi bi-search"></i>
                    </button>
                </div>
            </div>
            <hr>
            <div style="height: 165px; border: 1px solid black; overflow: auto">
                <ul id="candidateBox"></ul>
            </div>
            <div class="text-center">
                <button class="btn btn-outline-dark" id="unselectBtn">
                    <i class="bi bi-chevron-double-up"></i>
                </button>
                <button class="btn btn-outline-dark" id="selectBtn">
                    <i class="bi bi-chevron-double-down"></i>
                </button>
            </div>
            <div style="height: 165px; border: 1px solid black; overflow: auto">
                <ul id="selectedBox"></ul>
            </div>
        </div>

        <div class="col-8" style="border-left: 1px solid lightgray">
            <div class="row">
                <div class="col-11">
                    <div class="row">
                        <div class="col-2 d-flex align-items-center">
                            <label for="activityDate">활동일</label>
                        </div>
                        <div class="col-10">
                            <input type="date" class="form-control" id="activityDate" style="margin-left: 10px;" />
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-2 d-flex align-items-center">
                            <label for="instructor">담당교사</label>
                        </div>
                        <div class="col-10">
                            <input type="text" class="form-control" id="instructor" style="margin-left: 10px;" />
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-2 d-flex align-items-center">
                            <label for="subject">주제</label>
                        </div>
                        <div class="col-10">
                            <input type="text" class="form-control" id="subject" style="margin-left: 10px;" />
                        </div>
                    </div>
                </div>
                <div class="col-1">
                    <button class="btn btn-light" id="planSearch" style="height: 100%;">
                        <i class="bi bi-search"></i>
                    </button>
                </div>
            </div>

            <hr>
            <div class="row">
                <div class="col-2 d-flex align-items-center">
                    <label for="plan">계획안</label>
                </div>
                <div class="col-10 d-flex">
                    <select id="plan" class="form-control">
                        <option>계획안을 선택하세요.</option>
                    </select>
                    <input type="button" class="btn btn-info ms-2" id="planInfo" value="정보" disabled />
                </div>
            </div>
            <hr>
            <div>
                <table class="table">
                    <thead>
                        <tr class="table-light">
                            <td width="40%">활동</td>
                            <td width="60%">기록</td>
                        </tr>
                    </thead>
                    <tbody id="tbody"></tbody>
                </table>
            </div>
        </div>
    </div>
    <br>
    <div class="text-end">
        <input type="button" class="btn btn-danger" id="back" value="뒤로가기" />
        <input type="button" class="btn btn-success" id="register" value="등록" />
    </div>
</div>

<form id="openPopup" target="popup" action="" method="post">
    <input type="hidden" name="num" value=""/>
</form>

<script>
    $('#back').on('click', function(){
        history.back();
    });

    let selectedChildNum = [];

    let $candidateBox = $('#candidateBox');
    let $selectedBox = $('#selectedBox');

    if($candidateBox.html() === ''){
        let html = '<span style="height: 100%; margin-bottom: -20px; display: flex; justify-content: center; align-items: center; color: gray;">원생을 검색해주세요.</span>'
        $candidateBox.html(html);
    }
    if($selectedBox.html() === ''){
        let html = '<span style="height: 100%; margin-bottom: -20px; display: flex; justify-content: center; align-items: center; color: gray;">원생을 선택해주세요.</span>'
        $selectedBox.html(html);
    }

    $('#childSearch').on('click', function(){
        let $grade = $('#grade');
        let $childName = $('#childName');
        let data = {
            grade: $grade.val(),
            name: $childName.val()
        }

        $.ajax({
            url: '/education/searchChild',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function(result){
                let html = '';
                if(result.length !== 0){
                    for(let i=0; i<result.length; i++){
                        html += '<li class="candidate" data-num="' + result[i].num + '">';
                        html += result[i].name + '(' + result[i].birth + ')-' + result[i].grade;
                        html += '</li>';
                    }
                }else{
                    html = '<span style="height: 100%; margin-bottom: -20px; display: flex; justify-content: center; align-items: center; color: gray;">조건에 부합하는 원생이 없습니다.</span>'
                }
                $candidateBox.html(html);
            }
        })
    });

    $(document).on('click', 'li', function(){
        $('li').removeClass('select');
        $(this).addClass('select');
    });

    $(document).on('dblclick', '.candidate', function(){
        moveToSelectedBox();
    });

    $(document).on('click', '#selectBtn', function(){
        moveToSelectedBox();
    });

    $(document).on('dblclick', '.selected', function(){
        moveToUnselectedBox();
    });

    $(document).on('click', '#unselectBtn', function(){
        moveToUnselectedBox();
    });

    function moveToSelectedBox(){
        let $select = $('.select');

        if($selectedBox.children('li').length === 0){
            $selectedBox.empty();
        }
        let $selected = $('.selected');
        for(let i=0; i<$selected.length; i++){
            if($select[0].dataset.num === $selected[i].dataset.num) {
                alert('이미 선택되었습니다.');
                return;
            }
        }

        selectedChildNum.push($select[0].dataset.num);
        $selectedBox.append($select.clone().removeClass('candidate').addClass('selected'));
        $select.removeClass('select');
    }

    function moveToUnselectedBox(){
        let $select = $('.select');

        for(let i=0; i<selectedChildNum.length; i++){
            if(selectedChildNum[i] === $select[0].dataset.num){
                selectedChildNum.splice(i, 1);
            }
        }

        $select.remove();
        if($selectedBox.children('li').length === 0) {
            $selectedBox.html('<span style="height: 100%; margin-bottom: -20px; display: flex; justify-content: center; align-items: center; color: gray;">원생을 선택해주세요.</span>');
        }
    }
</script>

<script>
    $('#planSearch').on('click', function(){
        let data = {
            date: $('#activityDate').val(),
            instructor: $('#instructor').val(),
            subject: $('#subject').val()
        }

        $.ajax({
            url: '/education/searchPlan',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function(result){
                for(let i=0; i<result.length; i++){
                    let plan = '';
                    plan += '<option value="' + result[i].num + '">';
                    plan += result[i].activityDate[0] + '-' + result[i].activityDate[1] + '-' + result[i].activityDate[2];
                    plan += ' [' + result[i].grade + '] 계획안';
                    plan += '</option>';
                    $('#plan').append(plan);
                }
            }
        })
    });

    $('#planInfo').on('click', function(){
        window.open('', 'popup', 'width=1000,height=600,scrollbars=yes');
        let num = $('option:selected').val();
        $('input[name=num]').val(num);

        let $popup = $('#openPopup');
        $popup.attr('action', '<c:url value="/education/dailyPlan/info"/>');
        $popup.submit();
    });

    $('#plan').on('change', function(){
        $('#planInfo').removeAttr('disabled');
        let data = {
            num: $('option:selected').val()
        }

        $.ajax({
            url: '/education/getActivityList',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function(result){
                let $tbody = $('#tbody');
                $tbody.html('');
                for(let i=0; i<result.length; i++){
                    let activity = '';
                    activity += '<tr>';
                    activity += '<td>' + result[i].content + '</td>';
                    activity += '<td><textarea id="record_' + result[i].num + '" class="record form-control" style="width: 100%; resize: none;"></textarea></td>';
                    activity += '</tr>';
                    $tbody.append(activity);
                }
            }
        })
    });
</script>

<script>
    $('#register').on('click', function(){
        if(!confirm('등록하시겠습니까?'))   return;

        let data = {
            childList: selectedChildNum,
            activityRecords: {}
        }

        $('.record').each(function(){
            let activityNum = $(this).attr('id').replace('record_', '');
            data.activityRecords[activityNum] = $(this).val();
        });

        $.ajax({
            url: '/education/insertRecord',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function(result){
                location.href = '/education/activityRecord';
            }
        })
    });
</script>
