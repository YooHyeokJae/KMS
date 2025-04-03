<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<style>
    .trs:hover td {
        background-color: lightgray;
    }
    tr.selected td {
        background-color: #0d6efd;
        color: white;
    }
    .instructor:hover {
        background-color: lightgray;
    }
    .selected {
        background-color: blue;
        color: white;
    }
</style>
<div class="container">
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
        <div class="col-4" style="border-right: 1px solid black">
            <div style="height: 400px;">
                <table class="table mb-0">
                    <thead>
                        <tr class="table-info text-center">
                            <th width="15%">번호</th>
                            <th width="30%">상담유형</th>
                            <th width="20%">상담교사</th>
                            <th width="35%">상담일</th>
                        </tr>
                    </thead>
                </table>
                <div style="height: 90%; overflow-y: auto;">
                    <table class="table">
                        <tbody class="text-center" id="counselTbl">
                            <tr>
                                <td colspan="4">원생을 선택해주세요.</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div class="col-5">
            <div style="height: 400px; display: flex; flex-direction: column;">
                <div class="row d-flex align-items-center flex-grow-0">
                    <div class="col-2">
                        <label for="num">상담번호</label>
                    </div>
                    <div class="col-4">
                        <input type="text" class="form-control" id="num" disabled />
                    </div>
                    <div class="col-2">
                        <label for="category">상담유형</label>
                    </div>
                    <div class="col-4">
                        <input type="text" class="form-control data" id="category" disabled />
                    </div>
                </div>
                <div class="row d-flex align-items-center flex-grow-0">
                    <div class="col-2">
                        <label for="counselDate">상담일</label>
                    </div>
                    <div class="col-4">
                        <input type="date" class="form-control data" id="counselDate" disabled />
                    </div>
                    <div class="col-2">
                        <label for="instructorName">상담교사</label>
                    </div>
                    <div class="col-4 d-flex">
                        <input type="text" class="form-control data" id="instructorName" disabled />
                        <input type="hidden" class="data" id="instructorId" />
                        <button class="btn btn-light data" id="instructorSearch" data-bs-toggle="modal" data-bs-target="#searchInstructorModal" disabled>
                            <i class="bi bi-search"></i>
                        </button>
                    </div>
                </div>
                <div style="flex: 1;">
                    <div class="row" style="height: 100%;">
                        <div class="col-2">
                            <label for="counselNote">상담내용</label>
                        </div>
                        <div class="col-10" style="height: 100%;">
                            <textarea id="counselNote" class="form-control data" style="height: 100%; resize: none;" disabled></textarea>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-3"></div>
        <div class="col-4 text-end">
            <input type="button" class="btn btn-outline-primary" id="plusCounsel" value="new" />
        </div>
        <div class="col-5 text-end">
            <input type="button" class="btn btn-outline-warning" id="modCounsel" value="수정" disabled />
            <input type="button" class="btn btn-outline-success" id="saveCounsel" value="저장" disabled />
        </div>
    </div>
</div>

<!-- 교사 찾기 modal -->
<div class="modal fade" id="searchInstructorModal" tabindex="-1" aria-labelledby="searchInstructorModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="searchInstructorModalLabel">교사 찾기</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body row">
                <div class="col-2 d-flex align-items-center">
                    <label for="keyword">교사 명</label>
                </div>
                <div class="col-10">
                    <input type="text" class="form-control" id="keyword" />
                </div>

                <div class="mt-3 test_div" style="height: 200px; overflow-y: auto;">
                    <ul id="instructorList"></ul>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                <button type="button" class="btn btn-primary" id="selectInstructor">선택</button>
            </div>
        </div>
    </div>
</div>

<script>
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

    $(document).on('click', '.list-group-item', function(){
        if($(this).hasClass('noActive'))    return;

        if(insertingFlag){
            if(!confirm('저장하지 않은 정보는 사라질 수도 있습니다.')){
                return;
            }
        }
        insertingFlag = false;

        $('#modCounsel').attr('disabled', true);
        $('#saveCounsel').attr('disabled', true);

        $('.list-group-item').removeClass('active');
        $(this).addClass('active');
        $('#num').val('');
        $('.data').val('').attr('disabled', true);

        let data = {
            childNum: $(this)[0].id.replace('child_', '')
        }

        $.ajax({
            url: '/education/getCounselByChildNum',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function(result){
                if(result.length === 0) {
                    let html = '';
                    html += '<tr>';
                    html += '<td colSpan="4">해당 원생은 상담내역이 없습니다.</td>';
                    html += '</tr>';
                    $('#counselTbl').html(html)
                } else {
                    let html = '';
                    for(let i=0; i<result.length; i++){
                        html += '<tr class="trs">';
                        html += '<td width="15%">' + result[i].num + '</td>';
                        html += '<td width="30%">' + result[i].category + '</td>';
                        html += '<td width="20%">' + result[i].instructorName + '</td>';
                        html += '<td width="*">' + result[i].counselDate[0] + '-' + String(result[i].counselDate[1]).padStart(2, '0') + '-' + String(result[i].counselDate[2]).padStart(2, '0') + '</td>';
                        html += '</tr>';
                    }
                    $('#counselTbl').html(html)
                }
            }
        });
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
                let $childList = $('#childList');
                $childList.html('');
                if(result.length === 0){
                    $childList.html('<li class="list-group-item">검색 결과가 없습니다.</li>');
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

    let insertingFlag = false;
    $('.data').on('input', function(){
        insertingFlag = true;
    });

    $(document).on('click', '.trs', function(){
        if(insertingFlag){
            if(!confirm('저장하지 않은 정보는 사라질 수도 있습니다.')){
                return;
            }
        }
        insertingFlag = false;

        $('.trs').removeClass('selected');
        $(this).addClass('selected');

        $('#modCounsel').removeAttr('disabled');
        $('#saveCounsel').attr('disabled', true);
        $('.data').attr('disabled', true);

        let data = {
            num: $(this).children().eq(0).text()
        }

        $.ajax({
            url: '/education/getCounselByNum',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function(result){
                let formattedDate = result.counselDate[0] + '-' + String(result.counselDate[1]).padStart(2, '0') + '-' + String(result.counselDate[2]).padStart(2, '0')
                $('#num').val(result.num);
                $('#category').val(result.category);
                $('#counselDate').val(formattedDate);
                $('#instructorName').val(result.instructorName);
                $('#counselNote').val(result.counselNote);
            }
        })
    });

    $('#plusCounsel').on('click', function(){
        if($('.active').length === 0){
            alert('원생을 선택해주세요.');
            return;
        }

        $('#modCounsel').attr('disabled', true);
        $('.trs').removeClass('selected');

        $.ajax({
            url: '/education/counsel/nextNum',
            contentType: 'application/json;charset=utf-8',
            type: 'post',
            success: function(result){
                $('#num').val(result);
            }
        })

        let $dataElements = $('.data');
        $dataElements.removeAttr('disabled');
        $dataElements.val('');
        $('#saveCounsel').removeAttr('disabled');
    });

    $('#saveCounsel').on('click', function(){
        let data = {
            num: $('#num').val(),
            category: $('#category').val(),
            instructorId: $('#instructorId').val(),
            counselDate: $('#counselDate').val(),
            counselNote: $('#counselNote').val(),
            childNum: $('.active')[0].id.replace('child_', ''),
        }

        $.ajax({
            url: '/education/counsel/save',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function(result){
                if(result === 'insert'){
                    alert('등록되었습니다.');
                }else if(result === 'modify'){
                    alert('수정되었습니다.');
                }
                location.reload();
            }
        })
    });

    $('#modCounsel').on('click', function(){
        $(this).attr('disabled', true);
        $('#saveCounsel').removeAttr('disabled');

        $('.data').removeAttr('disabled');
    });
</script>

<script>
    let $keyword = $('#keyword');
    function searchInstructorList(){
        let $instructorList = $('#instructorList');
        $instructorList.html('');

        if($keyword.val() !== ''){
            $.ajax({
                url: '/education/searchTeacher',
                contentType: 'application/json;charset=utf-8',
                data: $keyword.val(),
                type: 'post',
                success: function(result){
                    for(let i=0; i<result.length; i++){
                        let instructorList = '';
                        instructorList += '<li class="instructor" id="instructor_' + result[i].id + '">';
                        instructorList += result[i].id + '_' + result[i].name
                        instructorList += '</li>';
                        $instructorList.append(instructorList);
                    }
                }
            });
        }
    }

    $('#instructorSearch').on('click', function(){
        $keyword.val($('#instructorName').val());
        searchInstructorList();
    });

    $keyword.on('input', function(){
        searchInstructorList();
    });

    $(document).on('click', '.instructor', function(){
        $('.instructor').removeClass('selected');
        $(this).addClass('selected');
    });

    $(document).on('dblclick', '.instructor', function(){
        selectInstructor();
    });

    $('#selectInstructor').on('click', function(){
        selectInstructor();
    });

    function selectInstructor(){
        let selected = $('li.selected').text();
        let instructorNum = selected.split('_')[0];
        let instructorName = selected.split('_')[1];
        $('#instructorId').val(instructorNum);
        $('#instructorName').val(instructorName);

        $('#searchInstructorModal').modal('hide');
    }
</script>