<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<style>
    <%--  ckEditor 경고 문구 안뜨도록  --%>
    #cke_notifications_area_content {
        display: none !important;
    }
</style>
<script src="${pageContext.request.contextPath}/resources/ckeditor/ckeditor.js"></script>
<div class="container">
    <form action="<c:url value="/board/modify"/>" method="post" >
        <input type="hidden" name="num" value="${boardVo.num}" />
        <div class="input-group">
            <div class="col-3" style="display: flex;">
                <div class="input-group">
                    <label class="input-group-text" for="category">구분</label>
                    <select class="form-select" id="category" name="category">
                        <option >-</option>
                        <option value="notice">공지사항</option>
                        <option value="free">자유게시판</option>
                    </select>
                </div>
            </div>

            <div class="col-9" style="display: flex;">
                <div class="input-group">
                    <label class="input-group-text" for="title">제목</label>
                    <input type="text" class="form-control" id="title" name="title" value="${boardVo.title}" />
                </div>
            </div>
        </div>

        <div class="input-group">
            <input type="hidden" name="writerId" value="${sessionScope.loginUser.id}" />
        </div>

        <div class="input-group">
            <label class="input-group-text" for="content">내용</label>
            <textarea class="form-control" name="content" id="content" rows="10" cols="80">${boardVo.content}</textarea>
        </div>

        <div class="text-end">
            <input type="button" class="btn btn-secondary" value="취소" onclick="cansel()" />
            <input type="submit" class="btn btn-primary" value="수정" />
        </div>
    </form>
</div>

<script>
    CKEDITOR.replace('content', {
        width: '95.4%'
    });

    function cansel(){
        history.back();
    }

    $('#category').val("${boardVo.category}");
</script>