<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<style>
    .scroll-top-btn {
        position: fixed;
        bottom: 40px;
        right: 40px;
        display: none; /* 초반에는 숨김 */
        padding: 12px 16px;
        font-size: 20px;
        border: none;
        border-radius: 50%;
        background-color: #333;
        color: white;
        cursor: pointer;
        box-shadow: 0 2px 8px rgba(0,0,0,0.3);
        z-index: 1000;
        transition: opacity 0.3s;
    }

    .scroll-top-btn.show {
        display: block;
    }

    .image-box {
        width: 300px;
        height: 200px;
        overflow: hidden;
        align-items: center;
        border: 1px solid #ccc;
        border-radius: 6px;
        background-color: #f9f9f9;
    }

    .image-box img {
        width: 100%;
        height: 100%;
        object-fit: cover; /* 핵심 속성 */
    }

</style>
<div class="container">
    <div class="d-flex justify-content-between">
        <h2 style="border-bottom: 2px solid #333; display: inline-block; padding: 5px 12px; border-radius: 10px;">
            <span style="color: #3a92bf"><i class="bi bi-images"></i> 앨범</span>
        </h2>

        <div class="d-flex align-items-end justify-content-end mb-1">
            <c:if test="${sessionScope.loginUser.auth eq 'A' or sessionScope.loginUser.auth eq 'T'}">
                <input type="file" id="insertAlbum" style="display: none;" accept="image/*" multiple />
                <input type="button" class="btn btn-outline-primary ms-2" value="사진 등록" onclick="{$('#insertAlbum').click()}"/>
            </c:if>
        </div>
    </div>

    <div id="albumList"></div>
</div>

<%-- 앨범 등록 모달 --%>
<div class="modal fade" id="insertAlbumModal" tabindex="-1" aria-labelledby="insertAlbumModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="insertAlbumModalLabel">앨범 등록</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <table id="insertTbl" class="table"></table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                <button type="button" class="btn btn-primary" id="uploadBtn">업로드</button>
            </div>
        </div>
    </div>
</div>

<%-- 이미지 확대 modal --%>
<div class="modal fade" id="detailModal" tabindex="-1" aria-labelledby="detailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="detailModalLabel"></h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="detailImage"></div>
        </div>
    </div>
</div>

<%-- 이미지 insert --%>
<script>
    let fileList = [];

    $('#insertAlbum').on('change', function(event){
        fileList = [];
        let files = event.target.files;
        let loadedCount = 0;
        let previewHtml = '';

        if (files.length === 0) return;

        for (let i = 0; i < files.length; i++) {
            let reader = new FileReader();
            const file = files[i];

            reader.onload = function(e) {
                fileList.push({ file: file, src: e.target.result });

                previewHtml += '<tr>';
                previewHtml += '    <td class="image-box"><img src="' + e.target.result + '" alt="미리보기"></td>';
                previewHtml += '    <td><textarea class="form-control" name="description" rows="7" style="resize: none;"></textarea></td>';
                previewHtml += '    <td style="width: 36px;">';
                previewHtml += '        <input type="button" class="btn btn-light arrowUp" value="↑" />';
                previewHtml += '        <input type="button" class="btn btn-light arrowDown" value="↓" />';
                previewHtml += '    </td>';
                previewHtml += '</tr>';

                loadedCount++;
                if (loadedCount === files.length) {
                    $('#insertTbl').html(previewHtml);
                    $('#insertAlbumModal').modal('show');
                }
            };
            reader.readAsDataURL(files[i]);
        }
    });

    // 위로 이동
    $(document).on('click', '.arrowUp', function () {
        const row = $(this).closest('tr');
        row.prev().before(row);
    });

    // 아래로 이동
    $(document).on('click', '.arrowDown', function () {
        const row = $(this).closest('tr');
        row.next().after(row);
    });

    $('#uploadBtn').on('click', function(){
        let formData = new FormData();

        $('#insertTbl tr').each(function(){
            const imgSrc = $(this).find('img').attr('src');
            const description = $(this).find('textarea').val();

            const match = fileList.find(f => f.src === imgSrc);
            if (match) {
                formData.append('files', match.file);
                formData.append('descriptions', description);
            }
        });

        $.ajax({
            url: '/board/insertAlbum',
            contentType: false,
            processData: false,
            data: formData,
            type: 'post',
            success: function(result){
                console.log(result);
                location.reload();
            }
        });

    });
</script>

<%-- 상단으로 가는 버튼 --%>
<button id="scrollTopBtn" class="scroll-top-btn">↑</button>
<script>
    $(document).ready(function () {
        const $scrollTopBtn = $('#scrollTopBtn');

        // 스크롤 이벤트
        $(window).on('scroll', function () {
            if (window.scrollY > 300) {
                $scrollTopBtn.addClass('show');
            } else {
                $scrollTopBtn.removeClass('show');
            }
        });

        // 클릭 시 부드럽게 상단 이동
        $scrollTopBtn.on('click', function () {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
    });


</script>

<%-- 무한 스크롤 --%>
<script>
    let lastScroll = 0;
    let lastNum = Number('${lastNum}');

    $(document).ready(function(){
        getData(6);
    });

    $(document).scroll(function(){
        let currentScroll = $(window).scrollTop();
        let documentHeight = $(document).height();

        if(currentScroll > lastScroll && currentScroll >= documentHeight - 800){
            getData(3);
        }
        lastScroll = currentScroll;
    });

    function getData(count){
        let $albumList = $('#albumList');

        let data = {
            lastNum: lastNum,
            cnt: count
        }

        $.ajax({
            url: '/board/getAlbumData',
            contentType: 'application/json;charset=utf-8',
            data: JSON.stringify(data),
            type: 'post',
            success: function(result){
                if(result.length > 0){
                    let html = '';
                    html += '<div class="d-flex justify-content-between mb-1">';
                    for(let i=0; i<result.length; i++){
                        html += '<div class="d-flex align-items-center justify-content-center album" data-desc="' + result[i].description + '" style="border: 1px solid black; width: 33%; height: 300px;">';
                        html += '<img src="/upload/' + result[i].fileName + '" alt="' + result[i].num + '" style="width: 100%; height: 100%; object-fit: cover;"/>';
                        html += '</div>';
                        if((i+1)%3 === 0){
                            html += '</div><div class="d-flex justify-content-between mb-1">';
                        }
                        lastNum = result[i].num;
                    }
                    html += '</div>';
                    $albumList.append(html);
                }
            }
        });
    }
</script>

<%-- 이미지 클릭 시 --%>
<script>
    $(document).on('click', '.album', function(){
        $('#detailModalLabel').text($(this)[0].dataset.desc)
        let clone = $(this).children().eq(0).clone();
        $('#detailImage').html(clone);
        $('#detailModal').modal('show');
    });
</script>