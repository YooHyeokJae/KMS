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
<style>
    #attendance{
        table-layout: fixed;
        width: 100%;
        border-collapse: collapse;
        word-break: keep-all;
        white-space: normal;
    }
    #attendance td{
        border: 1px solid black;
    }
    #diagonalCell{
        width: 40px;
        background: linear-gradient(-147deg, transparent 49%, #000 50%, transparent 52%);
    }
    .monthCell{
        text-align: center;
    }
    .dayCell{
        width: 25px;
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
</style>
<body>
    <div class="container">
        <div class="text-end">
            <span class="small text-muted">최종수정일시: <span id="updDate">${fn:replace(childVo.updDate, 'T', ' ')}</span></span>
            <c:if test="${sessionScope.loginUser.auth eq 'A'}">
                <input type="button" class="btn btn-primary" id="modifyBtn" value="수정" />
                <input type="button" class="btn btn-primary" id="saveBtn" value="저장" style="display: none;" />
            </c:if>
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
                    <td id="childGraduateDate">${childVo.graduateDate}</td>
                </c:if>
                <td></td>
                <td></td>
            </tr>
            <tr></tr>
        </table>

        <div style="width: 100%; height: 200px; overflow: auto">
            <table id="attendance">
                <tr>
                    <td id="diagonalCell"></td>
                    <c:forEach var="d" begin="1" end="31">
                        <td class="dayCell">${d}</td>
                    </c:forEach>
                </tr>
                <c:forEach var="m" begin="1" end="12">
                    <tr>
                        <td class="monthCell">${m}월</td>
                        <c:forEach var="d" begin="1" end="31">
                            <td class="text-center" id="${m}-${d}"></td>
                        </c:forEach>
                    </tr>
                </c:forEach>
            </table>
        </div>
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
        let gradeName = grade.text();
        let birth = $('#childBirth');
        let entryDate = $('#childEntryDate');
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
                    if(result[i].name === gradeName){
                        inputGrade += ' selected '
                    }
                    inputGrade += '>' + result[i].name + '</option>'
                }
                inputGrade += '</select>'
                grade.html(inputGrade);
            }
        });
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
                let gradeName = $('option[name="grade"]:selected').text();
                $('#childGrade').html(gradeName);
                $('#childBirth').html(birth);
                $('#childEntryDate').html(entryDate);
                $('#updDate').text(response.replace('T', ' '));

                $('#saveBtn').css('display', 'none');
                $('#modifyBtn').css('display', 'inline');
                $('#thumbnail').css('pointer-events', 'none');

                window.opener.location.reload();
            }
        });
    });

    $(document).ready(function(){
        let attendanceVoList = ${attendanceVoList};
        for(let i=0; i<attendanceVoList.length; i++){
            let cellId = attendanceVoList[i].attDate[1] + '-' + attendanceVoList[i].attDate[2];
            let $cell = $('#'+cellId);
            $cell.text(attendanceVoList[i].status);
            $cell.addClass(attendanceVoList[i].status);
        }
    });
</script>
</html>
