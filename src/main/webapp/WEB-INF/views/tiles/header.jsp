<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
  .search_icon {
    background-image: url('<c:url value="/resources/images/search_icon.png"/>');
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
    <div class="col-6" style="height: 100px">
      <label for="totalSearch"><input type="text" id="totalSearch" placeholder="검색어를 입력하세요."/></label>
      <input type="button" class="search_icon" style="width: 30px;" />
    </div>
    <div class="col-4" style="height: 100px">
      <c:if test="${sessionScope.loginUser ne null}">
        <p>${sessionScope.loginUser.name}님 환영합니다.</p>
        <input type="button" class="btn btn-primary" id="logout" value="logout" />
      </c:if>
      <c:if test="${sessionScope.loginUser eq null}">
        <form action="<c:url value="/sign/login"/>" method="post">
          <div class="mb-3 d-flex align-items-center">
            <label for="headerId" class="form-label me-2" ></label>
            <input type="text" class="form-control" id="headerId" name="userId" placeholder="userID" />
            <label for="headerPw" class="form-label me-2" ></label>
            <input type="password" class="form-control" id="headerPw" name="userPw" placeholder="password" />
            <input type="submit" class="btn btn-primary ms-2" value="login" />
          </div>
        </form>
      </c:if>
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
            <p class="nav-item"><a href="<c:url value="/teacher/list"/>">교원</a></p>
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
            <p class="nav-item"><a href="<c:url value="/board/list?cat=notice"/>">공지사항</a></p>
            <p class="nav-item"><a href="<c:url value="/board/list?cat=free"/>">자유게시판</a></p>
          </div>
        </li>
        <li class="nav-link">
          <a href="#">자료실</a>
          <div class="nav-item-box">
            <p class="nav-item"><a href="${pageContext.request.contextPath}/calendar/">학사일정</a></p>
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
          </div>
        </li>
      </ul>
    </nav>
  </div>
  <div class="col-2"></div>
</div>


<script>
  $(document).on('click', '#logout', function(){
    $.ajax({
      url: '/sign/logout',
      type: 'post',
      success: function(result){
        if(result === 'logout'){
          location.href = '/';
        }
      }
    })
  });
</script>