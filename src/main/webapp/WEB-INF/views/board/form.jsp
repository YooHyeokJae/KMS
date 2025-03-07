<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<style>
    .trs:hover td{
        background-color: #cecfd1;
    }
</style>
<div class="container">
    <h2>
        양식
    </h2>
    <div>검색필터</div>
    <table class="table">
        <thead>
            <tr class="table-primary text-center">
                <td width="5%">번호</td>
                <td width="*%">파일명</td>
                <td width="2%"></td>
                <td width="8%">작성자</td>
                <td width="8%">파일크기</td>
                <td width="15%">등록일</td>
            </tr>
        </thead>
        <tbody>
            <c:if test="${boardVoList.size() eq 0}">
                <tr class="text-center"><td colspan="6">등록된 게시글이 없습니다.</td></tr>
            </c:if>
            <c:forEach var="vo" items="${boardVoList}" varStatus="stat">
                <tr class="trs">
                    <td class="text-center">${vo.num}</td>
                    <td>${vo.title}</td>
                    <td class="text-center"><a href="<c:url value="/download/board/${vo.num}"/>"><i class="bi bi-download"></i></a></td>
                    <td>${vo.writerId}</td>
                    <td class="text-center"><fmt:formatNumber value="${vo.fileSize / 1024 + 1}" maxFractionDigits="0" /> KB</td>
                    <td class="text-center">${fn:substring(vo.regDate, 0, 10)}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    <div class="row">
        <div class="col-9">
            <nav aria-label="Page navigation example" class="d-flex align-items-center">
                <ul class="pagination">
                    <li class="page-item"><a class="page-link <c:if test="${pageStart eq 1}">disabled</c:if>" href="<c:url value="/board/list?cat=${category}&page=${pageStart-1}"/>">이전</a></li>
                    <c:forEach var="i" begin="0" end="${pageBlock-1}">
                        <li class="page-item<c:if test="${pageStart + i eq currentPage}"> active</c:if><c:if test="${pageStart + i - 1 gt totalCnt/count}"> disabled</c:if>"><a class="page-link text-center" href="<c:url value="/board/list?cat=${category}&page=${pageStart + i}"/>" style="min-width: 60px;">${pageStart + i}</a></li>
                    </c:forEach>
                    <li class="page-item"><a class="page-link<c:if test="${pageStart + pageBlock - 1 gt totalCnt/count}"> disabled</c:if>" href="<c:url value="/board/list?cat=${category}&page=${pageStart+pageBlock}"/>">다음</a></li>
                </ul>
                <span class="ms-2 small text-muted">total count: ${totalCnt}건</span>
            </nav>
        </div>
        <div class="col-3 text-end">
            <c:if test="${sessionScope.loginUser.auth eq 'A'}">
                <input type="button" value="글작성" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#uploadModal" />
            </c:if>
        </div>
    </div>
</div>

<div class="modal fade" id="uploadModal" tabindex="-1" aria-labelledby="uploadModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="uploadModalLabel">양식 업로드</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form>
                <div class="modal-body">
                    <input type="button" class="btn btn-secondary" value="파일선택" onclick="openUploadFile()" />
                    <input type="file" id="uploadFiles" name="uploadFiles" style="display: none;" multiple />
                    <ul id="uploadFileList"></ul>
                </div>
                <div class="modal-footer">
                    <input type="button" class="btn btn-primary" id="upload" value="등록" />
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function openUploadFile(){
        $('#uploadFiles').click();
    }

    let dataTransfer = new DataTransfer();
    $('#uploadFiles').on('change', function(){
        let files = $(this)[0].files;
        let fileList = Array.from(dataTransfer.files);

        for(let i=0; i<files.length; i++){
            let exist = fileList.some(file => file.name === files[i].name && file.size === files[i].size);

            if (!exist) {
                dataTransfer.items.add(files[i]);
                let index = dataTransfer.files.length - 1;

                let li = '';
                li += '<li class="d-flex justify-content-between" data-index="' + index + '">';
                li += files[i].name;
                li += '<button class="remove-file" data-index="' + index + '">X</button>';
                li += '</li>';
                $('#uploadFileList').append(li);
            }
        }
        $('#uploadFiles').files = dataTransfer.files;
    });

    $(document).on('click', '.remove-file', function(){
        let index = $(this).data('index');
        dataTransfer.items.remove(index);
        $('#uploadFiles').files = dataTransfer.files;
        $(this).parent().remove();
    });

    $('#upload').on('click', function(){
        let formData = new FormData();
        for (let i = 0; i < dataTransfer.files.length; i++) {
            formData.append('files[]', dataTransfer.files[i]);
        }

        $.ajax({
            url: '/board/uploadForm',  // 서버의 파일 처리 URL
            type: 'post',
            data: formData,
            processData: false,
            contentType: false,
            success: function(response) {
                location.reload();
            }
        });
    });
</script>