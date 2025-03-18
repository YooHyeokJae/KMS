<%--
  Created by IntelliJ IDEA.
  User: yhj43
  Date: 25. 3. 13.
  Time: 오전 10:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<html>
<head>
    <title>일일 계획안</title>
    <style>
        @media print {
            /* 불필요한 요소 숨기기 */
            .no-print {
                display: none;
            }

            /* 페이지가 인쇄될 때 제목을 숨길 수 있도록 설정 */
            body {
                font-family: Arial, sans-serif;
            }
        }
        table{
            background-color: #e9ecef;
        }
        table th:nth-child(1),
        table th:nth-child(3),
        table td:nth-child(1) {
            width: 15%;
        }
        th{
            text-align: center;
        }
        td, th{
            border: 1px solid black;
        }
        .auto-resize{
            overflow: hidden;
            resize: none;
        }
        .form-control{
            border: none;
        }
        #addRowBtn{
            border: none;
        }
        .instElem:hover{
            background-color: #d3d4d6;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2 class="text-center">일일 교육 계획안</h2>
        <div class="row">
            <div class="col-2">
                <button class="btn btn-light no-print" id="printBtn" style="font-size: 1.5em;" onclick="window.print()"><i class="bi bi-printer"></i></button>
            </div>
            <div class="col-10 text-end">
                <span class="small text-muted">
                    <span>최초 작성일: </span>
                    <span>${fn:replace(dailyPlanVo.regDate, 'T', ' ')}</span>
                    <br>
                    <span>최종 수정일: </span>
                    <span>${fn:replace(dailyPlanVo.updDate, 'T', ' ')}</span>
                </span>
            </div>
        </div>
        <table style="width: inherit">
            <tr>
                <th><label for="activityDate">실시일자</label></th>
                <td><input type="date" class="form-control data" id="activityDate" value="${dailyPlanVo.activityDate}" disabled /></td>
                <th><label for="activitySeq">실시차시</label></th>
                <td><input type="text" class="form-control data" id="activitySeq" value="${dailyPlanVo.seq}" disabled /></td>
            </tr>
            <tr>
                <th><label for="instructorName">지도교사</label></th>
                <td>
                    <div style="display: flex;">
                        <input type="text" class="form-control" id="instructorName" value="${dailyPlanVo.instructorName}" disabled />
                        <input type="hidden" class="data" id="instructor" value="${dailyPlanVo.teacherId}" />
                        <button class="btn btn-light" id="searchTeacherBtn" data-bs-toggle="modal" data-bs-target="#searchTeacherModal" style="display: none;" onclick="openModal()"><i class="bi bi-search"></i></button>
                    </div>
                </td>
                <th><label for="location">활동장소</label></th>
                <td><input type="text" class="form-control data" id="location" value="${dailyPlanVo.location}" disabled /></td>
            </tr>
            <tr>
                <th><label for="target">대상</label></th>
                <td><input type="text" class="form-control data" id="target" value="${dailyPlanVo.target}" disabled /></td>
                <th><label for="grade">학급/반</label></th>
                <td><input type="text" class="form-control data" id="grade" value="${dailyPlanVo.grade}" disabled /></td>
            </tr>
            <tr>
                <th><label for="subject">주제</label></th>
                <td colspan="3"><textarea class="form-control data auto-resize" id="subject" rows="1" disabled>${dailyPlanVo.subject}</textarea></td>
            </tr>
            <tr>
                <th><label for="goals">활동목표</label></th>
                <td colspan="3"><textarea class="form-control data auto-resize" id="goals" rows="1" disabled>${dailyPlanVo.goals}</textarea></td>
            </tr>
            <tr>
                <th><label for="materials">준비자료</label></th>
                <td colspan="3"><textarea class="form-control data auto-resize" id="materials" rows="1" disabled>${dailyPlanVo.materials}</textarea></td>
            </tr>
        </table>
        <table id="activityTable" style="width: inherit">
            <tr>
                <th>활동시간</th>
                <th width="*">활동내용</th>
                <th width="10%">비고</th>
            </tr>
            <c:forEach var="activityVo" items="${dailyPlanVo.activitiyVoList}" varStatus="stat">
                <tr class="activities">
                    <td><input type="text" class="form-control data" id="time_${stat.count}" value="${activityVo.activityTime}" disabled /></td>
                    <td><textarea class="form-control data auto-resize" id="content_${stat.count}" rows="1" disabled>${activityVo.content}</textarea></td>
                    <td><textarea class="form-control data auto-resize" id="note_${stat.count}" rows="1" disabled>${activityVo.note}</textarea></td>
                </tr>
            </c:forEach>
            <tr style="display: none" id="addBtnRow"><td colspan="3"><input type="button" class="btn btn-outline-info w-100" id="addRowBtn" value="+" /></td></tr>
        </table>

        <div class="text-end" style="margin-top: 10px;">
            <input type="button" class="btn btn-outline-primary no-print" id="modifyBtn" value="수정" />
            <input type="button" class="btn btn-outline-success" id="saveBtn" value="저장" style="display: none" />
        </div>
    </div>

    <div class="modal fade" id="searchTeacherModal" tabindex="-1" aria-labelledby="searchTeacherModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="searchTeacherModalLabel">
                        <label for="keyword">교사 찾기</label>
                    </h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                    <div class="modal-body">
                        <input type="text" class="form-control" id="keyword" placeholder="이름을 입력하세요." style="border: 1px solid black" />
                        <hr>
                        <ul id="instructorList" style="height: 300px; overflow: auto"></ul>
                    </div>
            </div>
        </div>
    </div>
</body>

<script>
    function autoResizeTextarea(textarea) {
        textarea.style.height = 'auto';
        textarea.style.height = (textarea.scrollHeight) + 'px';
    }

    $(document).on('input', '.auto-resize', function () {
        autoResizeTextarea(this);
    });

    $('#addRowBtn').on('click', function () {
        let count = $('.activities').length;
        let html = '';
        html += '<tr class="activities">';
        html += '<td><input type="text" class="form-control data" id="time_'+(count+1)+'"/></td>';
        html += '<td><textarea class="form-control data auto-resize" id="content_'+(count+1)+'" rows="1"></textarea></td>';
        html += '<td><textarea class="form-control data auto-resize" id="note_'+(count+1)+'" rows="1"></textarea></td>';
        html += '</tr>';

        $('#activityTable tr:last').before(html);
    });

    $('#modifyBtn').on('click', function(){
        if(confirm('수정하시겠습니까?')){
            $('#addBtnRow').css('display', 'contents');
            $('#searchTeacherBtn').css('display', 'inline');
            $('.data').removeAttr('disabled');
            $('#modifyBtn').css('display', 'none');
            $('#printBtn').css('display', 'none');
            $('#saveBtn').css('display', 'inline');
        }
    });

    $('#saveBtn').on('click', function(){
        if(confirm('저장하시겠습니까?')){
            let formData = {};
            $('.data').each(function() {
                let id = $(this).attr('id');
                formData[id] = $(this).val();
            });
            formData['num'] = ${dailyPlanVo.num}

            $.ajax({
                url: '/education/dailyPlan/modifyData',
                contentType: 'application/json;charset=utf-8',
                data: JSON.stringify(formData),
                type: 'post',
                success: function(){
                    $('#addBtnRow').css('display', 'none');
                    $('#searchTeacherBtn').css('display', 'none');
                    $('.data').attr('disabled', 'true');
                    $('#modifyBtn').css('display', 'inline');
                    $('#printBtn').css('display', 'inline');
                    $('#saveBtn').css('display', 'none');
                    window.opener.location.reload();
                }
            });
        }
    });
</script>

<script>
    let $keyword = $('#keyword');
    function openModal(){
        let keyword = $('#instructorName').val();
        if(keyword !== null && keyword !== ''){
            $keyword.val(keyword);
            searchTeacherAjax();
        }
    }
    $('#searchTeacherModal').on('shown.bs.modal', function () {
        $('#keyword').focus();
    });

    function searchTeacherAjax(){
        $('#instructorList').html('');
        let keyword = $keyword.val();
        if(keyword !== null && keyword !== ''){
            $.ajax({
                url: '/education/searchTeacher',
                contentType: 'application/json;charset=utf-8',
                data: keyword,
                type: 'post',
                success: function(result){
                    for(let i=0; i<result.length; i++){
                        let html = '<li class="instElem" data-id="' + result[i].id + '">' + result[i].name + '</li>';
                        $('#instructorList').append(html);
                    }
                }
            });
        }
    }

    $keyword.on('input', function(){
        searchTeacherAjax();
    });

    $(document).on('dblclick', '.instElem', function(){
        let id = $(this)[0].dataset.id;
        let name = $(this).text();
        $('#instructor').val(id);
        $('#instructorName').val(name);
        $('#searchTeacherModal').modal('hide');
    })
</script>
</html>

