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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<html>
<head>
    <title>일일 계획안</title>
    <style>
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
    </style>
</head>
<body>
    <div class="container">
        <h2 class="text-center">일일 교육 계획안</h2>
        <div class="text-end">
            <span class="small text-muted">
                <span>최초 작성일: </span>
                <span>****-**-** **:**:**</span>
                <br>
                <span>최종 수정일: </span>
                <span>****-**-** **:**:**</span>
            </span>
        </div>
        <table style="width: inherit">
            <tr>
                <th><label for="activityDate">실시일자</label></th>
                <td><input type="date" class="form-control data" id="activityDate" /></td>
                <th><label for="activitySeq">실시차시</label></th>
                <td><input type="text" class="form-control data" id="activitySeq" /></td>
            </tr>
            <tr>
                <th><label for="instructor">지도교사</label></th>
                <td><input type="text" class="form-control data" id="instructor" /></td>
                <th><label for="location">활동장소</label></th>
                <td><input type="text" class="form-control data" id="location" /></td>
            </tr>
            <tr>
                <th><label for="target">대상</label></th>
                <td><input type="text" class="form-control data" id="target" /></td>
                <th><label for="grade">학급/반</label></th>
                <td><input type="text" class="form-control data" id="grade" /></td>
            </tr>
            <tr>
                <th><label for="subject">주제</label></th>
                <td colspan="3"><textarea class="form-control data auto-resize" id="subject" rows="1"></textarea></td>
            </tr>
            <tr>
                <th><label for="goals">활동목표</label></th>
                <td colspan="3"><textarea class="form-control data auto-resize" id="goals" rows="1"></textarea></td>
            </tr>
            <tr>
                <th><label for="materials">준비자료</label></th>
                <td colspan="3"><textarea class="form-control data auto-resize" id="materials" rows="1"></textarea></td>
            </tr>
        </table>
        <table id="activityTable" style="width: inherit">
            <tr>
                <th>활동시간</th>
                <th width="*">활동내용</th>
                <th width="10%">비고</th>
            </tr>
            <tr class="activities">
                <td><input type="text" class="form-control data" id="time_1" /></td>
                <td><textarea class="form-control data auto-resize" id="content_1" rows="1"></textarea></td>
                <td><textarea class="form-control data auto-resize" id="note_1" rows="1"></textarea></td>
            </tr>
            <tr><td colspan="3"><input type="button" class="btn btn-outline-info w-100" id="addRowBtn" value="+" /></td></tr>
        </table>

        <div class="text-end" style="margin-top: 10px;">
            <input type="button" class="btn btn-outline-danger" id="resetBtn" value="초기화" />
            <input type="button" class="btn btn-outline-primary" id="insertBtn" value="등록" />
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

    $('#resetBtn').on('click', function(){
        if(confirm('입력한 내용을 초기화 하시겠습니까?')){
            $('.data').val('')
        }
    });

    $('#insertBtn').on('click', function(){
        if(confirm('등록하시겠습니까?')){
            let formData = {};
            $('.data').each(function() {
                let id = $(this).attr('id');
                formData[id] = $(this).val();
            });

            $.ajax({
                url: '/education/dailyPlan/insertData',
                contentType: 'application/json;charset=utf-8',
                data: JSON.stringify(formData),
                type: 'post',
                success: function(result){
                    window.opener.location.reload();
                    window.close();
                }
            });
        }
    });
</script>

</html>

