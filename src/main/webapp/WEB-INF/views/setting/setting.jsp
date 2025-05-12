<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<div class="container">
    <h2 style="border-bottom: 2px solid #333; display: inline-block; padding: 5px 12px; border-radius: 10px;">
        <span style="color: #6C757D"><i class="bi bi-gear"></i> 개인 설정</span>
    </h2>

    <div>

    </div>

    <h2 style="border-bottom: 2px solid #333; display: inline-block; padding: 5px 12px; border-radius: 10px;">
        <span style="color: #6C757D"><i class="bi bi-gear"></i> 개인정보 수정</span>
    </h2>

    <div>
        <div class="d-flex align-items-center">
            <label for="uName" style="width: 110px;">이름</label>
            <input type="text" class="form-control" id="uName" value="${sessionScope.loginUser.name}" />
        </div>
        <div class="d-flex align-items-center">
            <label for="uEmail" style="width: 110px;">이메일</label>
            <input type="text" class="form-control" id="uEmail" value="${sessionScope.loginUser.email}" />
        </div>
        <div class="d-flex align-items-center">
            <label for="uTelNo" style="width: 110px;">전화번호</label>
            <input type="text" class="form-control" id="uTelNo" value="${sessionScope.loginUser.telNo}" />
        </div>
        <div class="d-flex align-items-center">
            <label for="uPw" style="width: 110px;">비밀번호</label>
            <input type="password" class="form-control" id="uPw" value="" />
        </div>
        <div class="d-flex align-items-center">
            <label for="uPwChk" style="width: 110px;">비밀번호확인</label>
            <input type="password" class="form-control" id="uPwChk" value="" />
        </div>
    </div>

    <div class="mt-3 d-flex justify-content-end">
        <input type="button" class="btn btn-success" id="saveBtn" value="저장" />
    </div>

</div>

<script>
    let $uPwChk = $('#uPwChk');
    $uPwChk.on('input', function () {
        if ($(this).val() !== $('#uPw').val()) {
            $(this).css('border-color', 'red');
            $(this).css('box-shadow', '0 0 0 0.2rem rgba(255, 167, 69, 0.25)');
        } else {
            $(this).css('border-color', 'green');
            $(this).css('box-shadow', '0 0 0 0.2rem rgba(40, 167, 69, 0.25)');
        }
    });

    $uPwChk.on('blur', function () {
        $(this).css('border-color', '');
        $(this).css('box-shadow', '');
    });

    $('#uTelNo').on('input', function(event){
        if (event.originalEvent.inputType === 'deleteContentBackward' ) {
            if($(this).val().length === 3 || $(this).val().length === 8){
                $(this).val($(this).val().substring(0, $(this).val().length-1))
            }
        }
        else{
            if(isNaN(event.originalEvent.data) || $(this).val().length > 13){
                $(this).val($(this).val().substring(0, $(this).val().length-1))
            }
            if($(this).val().length === 3 || $(this).val().length === 8){
                $(this).val($(this).val() + '-');
            }
        }
    });
</script>

<script>
    $('#saveBtn').on('click', function(){
        const curPw = '${sessionScope.loginUser.password}';
        const input = prompt("정보를 수정하려면 현재 비밀번호를 입력하세요.");
        if(curPw === input){
            let data = {
                userId: '${sessionScope.loginUser.id}',
                uName: $('#uName').val(),
                uEmail: $('#uEmail').val(),
                uTelNo: $('#uTelNo').val(),
                userPw: $('#uPw').val()
            }

            $.ajax({
                url: '/sign/chagneInfo',
                contentType: 'application/json;charset=utf-8',
                data: JSON.stringify(data),
                type: 'post',
                success: function(result){
                    alert('정보 수정이 완료되었습니다.');
                    location.reload();
                }
            });
        }
    });
</script>