<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<div class="container">
    <div class="d-flex justify-content-between">
        <h2 style="border-bottom: 2px solid #333; display: inline-block; padding: 5px 12px; border-radius: 10px;">
            <span style="color: #065F46;"><img alt="" src="${pageContext.request.contextPath}/resources/images/syringe.png" style="height: 40px;" /> 건강검진</span>
        </h2>

        <div class="mb-2 d-flex align-items-end">
            <input type="button" class="btn btn-outline-primary ms-2" id="addBtn" value="추가" disabled />
            <input type="button" class="btn btn-outline-danger ms-2" id="delBtn" value="삭제" disabled />
            <input type="button" class="btn btn-outline-success ms-2" id="saveBtn" value="저장" disabled />
        </div>
    </div>

    <div class="row" style="min-height: 400px; margin-bottom: 10px;">
        <div class="col-3" style="display: flex; flex-direction: column; border-right: 1px solid black;">
            <div class="row flex-grow-0">
                <div class="col-10">
                    <div class="row d-flex align-items-center">
                        <div class="col-4">
                            <label for="childName">이름</label>
                        </div>
                        <div class="col-8">
                            <input type="text" class="form-control" id="childName" />
                        </div>
                    </div>
                    <div class="row d-flex align-items-center">
                        <div class="col-4">
                            <label for="childGrade">학급/반</label>
                        </div>
                        <div class="col-8">
                            <input type="text" class="form-control" id="childGrade" />
                        </div>
                    </div>
                    <div class="row d-flex align-items-center">
                        <div class="col-4">
                            <label for="childBirth">생년월일</label>
                        </div>
                        <div class="col-8">
                            <input type="text" class="form-control" id="childBirth" placeholder="YYYY-MM-DD"/>
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
            <div style="flex: 1; max-height: 250px; overflow-y: auto;">
                <ul class="list-group" id="childList">
                    <li class="list-group-item noActive">검색 결과가 없습니다.</li>
                </ul>
            </div>
        </div>
        <div class="col-9" style="border-right: 1px solid black">
            <div style="height: 400px;">
                <table class="table mb-0">
                    <thead>
                        <tr class="table-success text-center">
                            <th width="4%" class="checkAll"><label for="checkAll"></label><input type="checkbox" class="mb-1" id="checkAll" /></th>
                            <th width="5%">번호</th>
                            <th width="28%">검진병원</th>
                            <th width="17%">검진일</th>
                            <th width="*%">검진결과</th>
                        </tr>
                    </thead>
                </table>
                <div style="height: 90%; overflow-y: auto;">
                    <table class="table">
                        <tbody class="text-center" id="tbody">
                            <tr>
                                <td colspan="4">원생을 선택해주세요.</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    let insertingFlag = false;

    $('#childBirth').on('input', function(event) {
        if (event.originalEvent.inputType === 'deleteContentBackward' ) {
            if($(this).val().length === 4 || $(this).val().length === 7){
                $(this).val($(this).val().substring(0, $(this).val().length-1))
            }
        }
        else{
            if(isNaN(event.originalEvent.data) || $(this).val().length > 10){
                $(this).val($(this).val().substring(0, $(this).val().length-1))
            }
            if($(this).val().length === 4 || $(this).val().length === 7){
                $(this).val($(this).val() + '-');
            }
        }
    });

    $('#childSearch').on('click', function(){
        let data = {
            name: $('#childName').val(),
            grade: $('#childGrade').val(),
            birth: $('#childBirth').val()
        }

        $.ajax({
            url: '/education/searchChild',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function(result){
                $('#addBtn').attr('disabled', true);
                $('#delBtn').attr('disabled', true);
                $('#saveBtn').attr('disabled', true);

                let $childList = $('#childList');
                $childList.html('');
                if(result.length === 0){
                    $childList.html('<li class="list-group-item noActive">검색 결과가 없습니다.</li>');
                }
                for(let i=0; i<result.length; i++){
                    let lis = '';
                    lis += '<li class="list-group-item" id="child_' + result[i].num + '">';
                    lis += result[i].name + '(' + result[i].birth + ') - ' + result[i].grade;
                    lis += '</li>';
                    $childList.append(lis);
                }
            }
        });
    });

    $(document).on('click', '.list-group-item', function() {
        if ($(this).hasClass('noActive')) return;

        if (insertingFlag) {
            if (!confirm('저장하지 않은 정보는 사라질 수도 있습니다.')) {
                return;
            }
        }
        deleteList = [];
        insertingFlag = false;

        $('.list-group-item').removeClass('active');
        $(this).addClass('active');

        $('#addBtn').removeAttr('disabled');
        $('#delBtn').removeAttr('disabled');
        $('#saveBtn').removeAttr('disabled');

        let data = {
            childNum: $(this)[0].id.replace('child_', '')
        }
        getHealthListByChildNum(data)
    });

    function getHealthListByChildNum(data){
        $.ajax({
            url: '/education/getHealthListByChildNum',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function(result){
                if(result.length === 0) {
                    let html = '';
                    html += '<tr>';
                    html += '<td colSpan="5">해당 원생은 검진내역이 없습니다.</td>';
                    html += '</tr>';
                    $('#tbody').html(html)
                } else {
                    let html = '';
                    for(let i=0; i<result.length; i++){
                        html += '<tr class="trs">';
                        html += '<td width="4%" class="checkOne">' + '<div class="d-flex align-items-center justify-content-center" style="height: 38px;"><input type="checkbox" class="check" /></div>' + '</td>';
                        html += '<td width="5%"><div class="d-flex align-items-center justify-content-center" style="height: 38px;">' + result[i].num + '</div></td>';
                        html += '<td width="28%">';
                        html += '<input type="text" class="form-control data" value="' + result[i].hospital + '" />';
                        html += '</td>';
                        html += '<td width="17%">';
                        html += '<input type="date" class="form-control data" value="' + result[i].checkDate[0] + '-' + String(result[i].checkDate[1]).padStart(2, '0') + '-' + String(result[i].checkDate[2]).padStart(2, '0') + '" />';
                        html += '</td>';
                        html += '<td width="*%">';
                        html += '<input type="text" class="form-control data" value="' + result[i].checkResult + '" />';
                        html += '</td>';
                        html += '</tr>';
                    }
                    $('#tbody').html(html);
                    confirmAllCheck();
                }
            }
        });
    }

    $('#addBtn').on('click', function(){
        let $tbody = $('#tbody');
        let html = '';
        html += '<tr class="trs">';
        html += '<td width="4%" class="checkOne">' + '<div class="d-flex align-items-center justify-content-center" style="height: 38px;"><input type="checkbox" class="check" /></div>' + '</td>';
        html += '<td width="5%">' + '</td>';
        html += '<td width="28%">' + '<input type="text" class="form-control data" placeholder="병원명" />' + '</td>';
        html += '<td width="17">' + '<input type="date" class="form-control data" />' + '</td>';
        html += '<td width="*">' + '<input type="text" class="form-control data" placeholder="검진기록" />' + '</td>';
        html += '</tr>';
        if(!$tbody.children().eq(0).hasClass('trs')){
            $tbody.html('');
        }
        $tbody.append(html);
        confirmAllCheck();
    });

    $(document).on('change', '.data', function(){
        insertingFlag = true;
    });

    $('.checkAll').on('click', function(event){
        let $checkAll = $('#checkAll');
        let stat = $checkAll.is(':checked');
        if(!$(event.target).is('input[type="checkbox"]')){
            stat = !stat;
            $checkAll.prop('checked', stat);
        }
        $('.check').prop('checked', stat);
    });

    $(document).on('click', '.checkOne', function(event){
        let $checkBox = $(this).children().eq(0).children().eq(0);
        let stat = $checkBox.is(':checked');
        if(!$(event.target).is('input[type="checkbox"]')){
            $checkBox.prop('checked', !stat);
        }
        confirmAllCheck();
    });

    function confirmAllCheck(){
        let $checkAll = $('#checkAll');
        let $checkBoxes = $('.check');
        if($checkBoxes.length === 0){
            $checkAll.prop('checked', false);
            return;
        }
        for(let i=0; i<$checkBoxes.length; i++){
            if(!$checkBoxes[i].checked){
                $checkAll.prop('checked', false);
                return;
            }
            $checkAll.prop('checked', true);
        }
    }

    let deleteList = [];
    $('#delBtn').on('click', function(){
        let $checked = $('.check:checked');
        if($checked.length === 0){
            alert('삭제할 요소를 선택해주세요.');
            return;
        }
        insertingFlag = true;
        let $trs = $checked.parent().parent().parent();
        let num = $trs.children().eq(1).children().eq(0).text();
        if(num !== ''){
            deleteList.push(num);
        }
        $trs.remove();
        confirmAllCheck();
    });

    $('#saveBtn').on('click', function(){
        let $checked = $('.check:checked');
        if($checked.length === 0){
            alert('저장할 요소를 선택해주세요.');
            return;
        }

        // deleteList, 추가된 데이터들
        let data = {
            childNum: $('.active')[0].id.replace('child_', ''),
            deleteList: deleteList,
            insertList: []
        }

        let $trs = $checked.parent().parent().parent();
        $trs.each(function(index, element){
            let $tr = $(element);
            let insertElem = {
                hospital: $tr.children().eq(2).children().eq(0).val(),
                checkDate: $tr.children().eq(3).children().eq(0).val(),
                checkResult: $tr.children().eq(4).children().eq(0).val()
            }

            if($tr.children().eq(1).html() !== ''){
                insertElem['num'] = $tr.children().eq(1).children().eq(0).text();
            }

            data.insertList.push(insertElem);
        });

        $.ajax({
            url: '/education/saveHealthCheck',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function(result){
                getHealthListByChildNum({
                    childNum: result
                });

                insertingFlag = false;
                deleteList = [];
                alert('저장되었습니다.');
            }
        });
    });
</script>