<%--
  Created by IntelliJ IDEA.
  User: yhj43
  Date: 25. 2. 24.
  Time: 오후 1:16
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
    <title>교사정보</title>
</head>
<body>
    <div class="container">
        <div class="text-end">
            <span class="small text-muted">최종수정일시: <span id="updDate">${fn:replace(teacherVo.updDate, 'T', ' ')}</span></span>
            <input type="button" class="btn btn-outline-danger" id="delBtn" value="퇴직" />
            <input type="button" class="btn btn-primary" id="modifyBtn" value="수정" />
            <input type="button" class="btn btn-primary" id="saveBtn" value="저장" style="display: none;" />
        </div>
        <table class="table table-primary">
            <tr>
                <td rowspan="3" width="20%">
                    <c:if test="${teacherVo.profileImage eq null}"><img src="${pageContext.request.contextPath}/resources/images/profile/default.jpg" alt="증명사진" id="thumbnail" style="width: 120px; height: auto; pointer-events: none;" onclick="selectImage()" ></c:if>
                    <c:if test="${teacherVo.profileImage ne null}"><img src="${teacherVo.profileImage}" alt="증명사진" id="thumbnail" style="width: 120px; height: auto; pointer-events: none;" onclick="selectImage()" ></c:if>
                    <input type="file" id="profileImage" style="display: none" />
                </td>
                <td width="16%">교원번호</td>
                <td width="28%" id="teacherId">${teacherVo.id}</td>
                <td width="15%">이름</td>
                <td width="21%" id="teacherName">${teacherVo.name}</td>
            </tr>
            <tr>
                <td>학급</td>
                <td id="teacherGrade">${teacherVo.grade}</td>
                <td>전공</td>
                <td id="teacherMajor">${teacherVo.major}</td>
            </tr>
            <tr>
                <td>생년월일</td>
                <td id="teacherBirth">${teacherVo.birth}</td>
                <td>임용일</td>
                <td id="teacherEntryDate">${teacherVo.entryDate}</td>
            </tr>
            <tr>
            </tr>
        </table>
    </div>
</body>
<script>
    let $profileImage = $('#profileImage');

    function selectImage(){
        $profileImage.click();
    }

    $profileImage.on('change', function(event){
        let reader = new FileReader();
        reader.onload = function(e) {
            $('#thumbnail').attr('src', e.target.result);
        };
        reader.readAsDataURL(event.target.files[0]);
    });

    $('#modifyBtn').on('click', function(){
        $(this).css('display', 'none');
        $('#saveBtn').css('display', 'inline');
        $('#thumbnail').css('pointer-events', 'auto');

        let name = $('#teacherName');
        let grade = $('#teacherGrade');
        let major = $('#teacherMajor');
        let birth = $('#teacherBirth');
        let entryDate = $('#teacherEntryDate');
        let inputName = '<input type="text" class="form-control" style="width: 100%;" id="name" value="' + name.text() + '"/>'
        let inputGrade = ''
        $.ajax({
            url: '/education/getGradeList',
            contentType: 'application/json;charset=utf-8',
            type: 'post',
            success: function(result){
                inputGrade += '<select id="grade" class="form-select">'
                inputGrade += '<option value=""></option>'
                for(let i=0; i<result.length; i++){
                    inputGrade += '<option name="grade" value="' + result[i].num + '"';
                    if(result[i].name === grade.text()){
                        inputGrade += ' selected '
                    }
                    inputGrade += '>' + result[i].name + '</option>'
                }
                inputGrade += '</select>'
                grade.html(inputGrade);
            }
        });
        let inputMajor = '<input type="text" class="form-control" style="width: 100%;" id="major" value="' + major.text() + '"/>'
        let inputBirth = '<input type="date" class="form-control" style="width: 100%;" id="birth" value="' + birth.text() + '"/>'
        let inputEntryDate = '<input type="date" class="form-control" style="width: 100%;" id="entryDate" value="' + entryDate.text() + '"/>'
        name.html(inputName);
        major.html(inputMajor);
        birth.html(inputBirth);
        entryDate.html(inputEntryDate);
    });

    $('#saveBtn').on('click', function(){
        let name = $('#name').val();
        let grade = $('#grade').val();
        let major = $('#major').val();
        let birth = $('#birth').val();
        let entryDate = $('#entryDate').val();

        let formData = new FormData();
        formData.append("id", "${teacherVo.id}");
        formData.append("profileImage", $profileImage[0].files[0]);
        formData.append("name", name);
        formData.append("grade", grade);
        formData.append("major", major);
        formData.append("birth", birth);
        formData.append("entryDate", entryDate);

        $.ajax({
            url: '/teacher/modify',
            processData: false,
            contentType: false,
            data: formData,
            type: 'post',
            success: function(response) {
                // 성공 시 처리
                $('#teacherName').html(name);
                let gradeName = $('option[name="grade"]:selected').text();
                console.log(gradeName);
                $('#teacherGrade').html(gradeName);
                $('#teacherMajor').html(major);
                $('#teacherBirth').html(birth);
                $('#teacherEntryDate').html(entryDate);
                $('#updDate').text(response.replace('T', ' '));

                $('#saveBtn').css('display', 'none');
                $('#modifyBtn').css('display', 'inline');
                $('#thumbnail').css('pointer-events', 'none');

                window.opener.location.reload();
            }
        });
    });

    $('#delBtn').on('click', function(){
        if(confirm('퇴직처리 하시겠습니까?')){
            let data = {
                id: '${teacherVo.id}'
            }

            $.ajax({
                url: '/teacher/delete',
                contentType: 'application/json;charset=utf-8',
                data: JSON.stringify(data),
                type: 'post',
                success: function(result){
                    alert('퇴직처리 되었습니다.');
                    window.close();
                    window.opener.location.reload();
                }
            });
        }
    });
</script>
</html>
