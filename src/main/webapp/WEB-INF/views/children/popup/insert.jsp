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
    <title>원생추가</title>
</head>
<body>
    <div class="container">
        <div class="text-end">
            <span class="small text-muted"></span>
            <input type="button" id="insertBtn" class="btn btn-primary" value="등록" />
        </div>
        <table class="table table-primary">
            <tr>
                <td rowspan="4" width="28%">
                    <img src="${pageContext.request.contextPath}/resources/images/profile/default.jpg" alt="증명사진" id="thumbnail" style="width: 120px; height: auto;" onclick="selectImage()">
                    <input type="file" id="profileImage" style="display: none" />
                </td>
                <td width="16%"><label for="num">원생번호</label></td>
                <td width="20%"><input type="text" class="form-control" style="width: 100%;" id="num" disabled/></td>
                <td width="16%"><label for="name">이름</label></td>
                <td width="20%"><input type="text" class="form-control" style="width: 100%;" id="name" /></td>
            </tr>
            <tr>
                <td><label for="grade">학급</label></td>
                <td><input type="text" class="form-control" id="grade" /></td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td><label for="birth">생년월일</label></td>
                <td colspan="3"><input type="date" class="form-control" id="birth" /></td>
            </tr>
            <tr>
                <td><label for="entryDate">입학일</label></td>
                <td colspan="3"><input type="date" class="form-control" id="entryDate" /></td>
            </tr>
        </table>
    </div>
</body>
<script>
    function selectImage(){
        $('#profileImage').click();
    }

    $('#profileImage').on('change', function(event){
        let reader = new FileReader();
        reader.onload = function(e) {
            $('#thumbnail').attr('src', e.target.result);
        };
        reader.readAsDataURL(event.target.files[0]);
    });

    $('#insertBtn').on('click', function(){
        let formData = new FormData();
        formData.append("profileImage", $('#profileImage')[0].files[0]);
        formData.append("name", $('#name').val());
        formData.append("grade", $('#grade').val());
        formData.append("birth", $('#birth').val());
        formData.append("entryDate", $('#entryDate').val());

        $.ajax({
            url: '/children/insert',
            processData: false,
            contentType: false,
            data: formData,
            type: 'post',
            success: function(response) {
                // 성공 시 처리
                window.close();
                window.opener.location.reload();
            }
        });
    });

</script>
</html>
