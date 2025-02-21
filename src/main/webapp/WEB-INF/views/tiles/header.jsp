<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
  .search_icon {
    <%--background-image: url('<c:url value="/resources/images/search_icon.png"/>');--%>
    background-size: contain;
    background-repeat: no-repeat;
  }
  .nav > ul .nav-link {
    display: inline-grid;
  }
  .nav-item-box {
    list-style: none;
    padding: 0;
    margin: 0;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);

    /* 처음에는 보이지 않도록 설정 */
    opacity: 0;
    visibility: hidden;
    max-height: 0;
    overflow: hidden;

    /* 애니메이션 효과 */
    transition: max-height 0.4s ease-in-out, opacity 0.4s ease-in-out, visibility 0.4s;
  }
  .nav:hover .nav-item-box {
    opacity: 1;
    visibility: visible;
    max-height: 200px;
  }
  .nav-link {
    min-width: 120px;
  }
</style>
<div class="container">
  <div class="row">
    <div class="col-2" style="height: 100px">
      <a href="${pageContext.request.contextPath}/" class="test_text">Logo</a>
    </div>
    <div class="col-10" style="height: 100px">
      <label for="totalSearch"><input type="text" id="totalSearch" placeholder="검색어를 입력하세요."/></label>
      <input type="button" class="search_icon" style="width: 30px;" />
    </div>
  </div>
</div>
<div class="row" style="background-color: #fabf62; height: 60px">
  <div class="col-2"></div>
  <div class="col-8">
    <nav class="nav" style="position: absolute; z-index: 999; background-color: #fabf62;">
      <ul>
        <li class="nav-link">
          <a href="#">유치원</a>
          <div class="nav-item-box">
            <p class="nav-item"><a href="#">소개</a></p>
            <p class="nav-item"><a href="#">교원</a></p>
            <p class="nav-item"><a href="#">졸업생</a></p>
          </div>
        </li>
        <li class="nav-link">
          <a href="#">원생</a>
          <div class="nav-item-box">
            <p class="nav-item"><a href="#">원생 등록</a></p>
            <p class="nav-item"><a href="#">원생 목록</a></p>
            <p class="nav-item"><a href="#">원생 수정</a></p>
            <p class="nav-item"><a href="#">원생 삭제</a></p>
          </div>
        </li>
        <li class="nav-link">
          <a href="#">학사</a>
          <div class="nav-item-box">
            <p class="nav-item"><a href="#">학사 관리</a></p>
          </div>
        </li>
        <li class="nav-link">
          <a href="#">게시판</a>
          <div class="nav-item-box">
            <p class="nav-item"><a href="#">공지사항</a></p>
            <p class="nav-item"><a href="#">자유게시판</a></p>
          </div>
        </li>
        <li class="nav-link">
          <a href="#">자료실</a>
          <div class="nav-item-box">
            <p class="nav-item"><a href="#">학사일정</a></p>
            <p class="nav-item"><a href="#">식단표</a></p>
            <p class="nav-item"><a href="#">양식</a></p>
          </div>
        </li>
        <li class="nav-link">
          <a href="#">통계</a>
          <div class="nav-item-box">
            <p class="nav-item"><a href="#">접속자 통계</a></p>
          </div>
        </li>
        <li class="nav-link">
          <a href="#">설정</a>
          <div class="nav-item-box">
            <p class="nav-item"><a href="#">설정</a></p>
            <p class="nav-item"><a href="#">관리자 페이지</a></p>
          </div>
        </li>
      </ul>
    </nav>
  </div>
  <div class="col-2"></div>
</div>