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
        <div class="col-4 offset-1">
            <span><i class="bi bi-book-fill"></i> ${boardVo.title}</span>
        </div>
        <div class="col-1"><i class="bi bi-person-fill"></i> ${boardVo.writerName}</div>
        <div class="col-2"><span><i class="bi bi-clock"></i> ${boardVo.regDate}</span></div>
        <div class="col-2"><span><i class="bi bi-clock"></i> ${boardVo.updDate}</span></div>
        <div class="col-2">
            <span><i class="bi bi-eye"></i> ${boardVo.viewCnt}</span>
            <span>
                <button id="likeBtn" style="border: none; background-color: white;">
                    <i class="likeIcon bi bi-hand-thumbs-up"></i>
                    <span id="likeCnt">${boardVo.likeCnt}</span>
                </button>
            </span>
        </div>
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

    let $likeBtn = $('#likeBtn');
    $likeBtn.on('mouseover', function(){
        $('.likeIcon').removeClass('bi-hand-thumbs-up').addClass('bi-hand-thumbs-up-fill');
    });
    $likeBtn.on('mouseleave', function(){
        $('.likeIcon').removeClass('bi-hand-thumbs-up-fill').addClass('bi-hand-thumbs-up');
    });

    $likeBtn.on('click', function(){
        let data = {
            boardNum: '${boardVo.num}',
            userId: '${sessionScope.loginUser.id}'
        }

        if(data.userId === ''){
            alert('로그인 후 추천 가능합니다.');
            return;
        }

        $.ajax({
            url: '/board/pressLike',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function(result){
                if(!isNaN(result)){
                    $('#likeCnt').text(result);
                    alert('게시글을 추천하였습니다.');
                }
                else{
                    if(confirm(result + '에 게시글을 이미 추천하였습니다.\n추천을 취소하시겠습니까?')){
                        $.ajax({
                            url: '/board/unPressLike',
                            contentType: 'application/json;charset=utf-8',
                            data: JSON.stringify(data),
                            type: 'post',
                            success: function(result){
                                $('#likeCnt').text(result);
                                alert('게시글을 추천을 취소하였습니다.')
                            }
                        });
                    }
                }
            }
        });
    });

</script>