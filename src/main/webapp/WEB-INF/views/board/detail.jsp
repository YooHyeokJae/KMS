<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<div class="container">
    <div class="text-end">
        <a href="<c:url value="/board/list?cat=${boardVo.category}"/>" class="btn btn-secondary">목록</a>
        <c:if test="${boardVo.writerId eq sessionScope.loginUser.id}"><a href="<c:url value="/board/modify?num="/>${boardVo.num}" class="btn btn-warning" >수정</a></c:if>
        <c:if test="${boardVo.writerId eq sessionScope.loginUser.id}"><a href="<c:url value="/board/delete?num="/>${boardVo.num}" class="btn btn-danger" onclick="deleteChk()" >삭제</a></c:if>
    </div>
    <br>
    <div class="row">
        <div class="col-5 offset-1">
            <span>${boardVo.title}</span>
        </div>
        <div class="col-2"><span>${boardVo.regDate}</span></div>
        <div class="col-2"><span>${boardVo.updDate}</span></div>
        <div class="col-1">
            <span>${boardVo.viewCnt}</span>
            <span>${boardVo.likeCnt}</span>
        </div>
        <div class="col-1"></div>
    </div>
    <hr>
    <div class="row" style="min-height: 200px;">
        <div class="offset-1 col-11">
            ${boardVo.content}
        </div>
    </div>
    <hr>
    <div class="row">
        <div class="offset-1 col-10">
            <div class="input-group mb-3">
                <input type="text" class="form-control" id="reply" placeholder="댓글을 입력하세요." aria-label="reply" aria-describedby="replyInsertBtn" />
                <input type="hidden" id="boardNum" value="${boardVo.num}" />
                <input type="hidden" id="writerId" value="${sessionScope.loginUser.id}" />
                <input type="button" class="btn btn-outline-secondary" id="replyInsertBtn" value="등록" />
            </div>
        </div>
        <div class="col-1"></div>
    </div>

    <div class="row">
        <div class="offset-1 col-10">
            <table class="table">
                <thead>
                    <tr class="text-center">
                        <th width="10%">작성자</th>
                        <th width="*">내용</th>
                        <th width="20%">작성일</th>
                        <th width="5%"></th>
                    </tr>
                </thead>
                <tbody>
                    <c:if test="${replyVoList.size() eq 0}">
                        <tr><td class="text-center" colspan="4">등록된 댓글이 없습니다.</td></tr>
                    </c:if>
                    <c:forEach var="replyVo" items="${replyVoList}" varStatus="stat">
                        <tr>
                            <td>${replyVo.writerName}</td>
                            <td>${replyVo.content}</td>
                            <td class="text-center">${replyVo.regDate}</td>
                            <td class="text-center"><c:if test="${replyVo.writerId eq sessionScope.loginUser.id}"><a href="#">x</a></c:if></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        <div class="col-1"></div>
    </div>
    <hr>
    <div class="row">
        <div class="offset-1 col-10">
            <p>
                <c:if test="${next ne null}">다음글: <a href="<c:url value="/board/detail?num=${next.num}"/>">${next.title}</a></c:if>
            </p>
            <p>
                <c:if test="${prev ne null}">이전글: <a href="<c:url value="/board/detail?num=${prev.num}"/>">${prev.title}</a></c:if>
            </p>
        </div>
        <div class="col-1"></div>
    </div>
</div>

<script>
    function deleteChk(){
        if(!confirm('정말 삭제하시겠습니까?')){
            event.preventDefault();
        }
    }
    $('#replyInsertBtn').on('click', function(){
        let data = {
            content: $('#reply').val(),
            boardNum: $('#boardNum').val(),
            writerId: $('#writerId').val()
        };
        if(data.writerId == null){
            alert('로그인이 필요합니다.');
            return;
        }
        if(data.content != null){
            $.ajax({
                url: '/board/insertReply',
                contentType: 'application/json;charset=utf-8',
                data: JSON.stringify(data),
                type: 'post',
                success: function(result){
                    if(result === 'success'){
                        location.reload();
                    }
                }
            });
        }
    });
</script>