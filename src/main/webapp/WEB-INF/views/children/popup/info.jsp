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
    <title>원생정보</title>
</head>
<body>
    <div class="container">
        <div class="text-end">
            <span class="small text-muted">최종수정일시: ${childVo.updDate}</span>
            <input type="button" class="btn btn-primary" id="modifyBtn" value="수정" />
            <input type="button" class="btn btn-primary" id="saveBtn" value="저장" style="display: none;" />
        </div>
        <table class="table table-primary">
            <tr>
                <td rowspan="4" width="26%">
                    <c:if test="${childVo.profilePath eq null}"><img src="${pageContext.request.contextPath}/resources/images/profile/default.jpg" alt="증명사진" id="thumbnail" style="width: 120px; height: auto; pointer-events: none;" onclick="selectImage()" ></c:if>
                    <c:if test="${childVo.profilePath ne null}"><img src="${childVo.profilePath}" alt="증명사진" id="thumbnail" style="width: 120px; height: auto; pointer-events: none;" onclick="selectImage()" ></c:if>
                    <input type="file" id="profileImage" style="display: none" />
                </td>
                <td width="16%">원생번호</td>
                <td width="21%" id="childNum">${childVo.num}</td>
                <td width="16%">이름</td>
                <td width="21%" id="childName">${childVo.name}</td>
            </tr>
            <tr>
                <td>생일</td>
                <td colspan="3" id="childBirth">${fn:substring(childVo.birth, 0, 10)}</td>
            </tr>
            <tr>
                <td>입학일</td>
                <td colspan="3" id="childEntryDate">${fn:substring(childVo.entryDate, 0, 10)}</td>
            </tr>
            <tr>
                <c:if test="${childVo.graduated eq 'N'}">
                    <td>학급</td>
                    <td id="childGrade">${childVo.grade}</td>
                </c:if>
                <c:if test="${childVo.graduated eq 'Y'}">
                    <td>졸업일</td>
                    <td id="childGrade">${childVo.graduateDate}</td>
                </c:if>
                <td></td>
                <td></td>
            </tr>
            <tr>
            </tr>
        </table>
    </div>

    <div>
        출석현황/지각,조퇴 현황
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

        let name = $('#childName');
        let grade = $('#childGrade');
        let birth = $('#childBirth');
        let entryDate = $('#childEntryDate');
        let inputName = '<input type="text" class="form-control" style="width: 100%;" id="name" value="' + name.text() + '"/>'
        let inputGrade = '<input type="text" class="form-control" style="width: 100%;" id="grade" value="' + grade.text() + '"/>'
        let inputBirth = '<input type="date" class="form-control" style="width: 100%;" id="birth" value="' + birth.text() + '"/>'
        let inputEntryDate = '<input type="date" class="form-control" style="width: 100%;" id="entryDate" value="' + entryDate.text() + '"/>'
        name.html(inputName);
        grade.html(inputGrade);
        birth.html(inputBirth);
        entryDate.html(inputEntryDate);
    });

    $('#saveBtn').on('click', function(){
        let name = $('#name').val();
        let grade = $('#grade').val();
        let birth = $('#birth').val();
        let entryDate = $('#entryDate').val();

        let formData = new FormData();
        formData.append("num", "${childVo.num}");
        formData.append("profileImage", $profileImage[0].files[0]);
        formData.append("name", name);
        formData.append("grade", grade);
        formData.append("birth", birth);
        formData.append("entryDate", entryDate);

        $.ajax({
            url: '/children/modify',
            processData: false,
            contentType: false,
            data: formData,
            type: 'post',
            success: function(response) {
                // 성공 시 처리
                $('#childName').html(name);
                $('#childGrade').html(grade);
                $('#childBirth').html(birth);
                $('#childEntryDate').html(entryDate);

                $('#saveBtn').css('display', 'none');
                $('#modifyBtn').css('display', 'inline');
                $('#thumbnail').css('pointer-events', 'none');

                window.opener.location.reload();
            }
        });
    });
</script>
</html>
