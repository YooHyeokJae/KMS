<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
  .nav > ul .nav-link {
    display: inline-grid;
    text-align: center;
  }
  .nav-item-box {
    border-radius: 5px;
    background-color: #f5c679;
    list-style: none;
    padding: 0;
    margin: 8px 0 0;
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
   #totalSearch:focus {
     outline: none;
     box-shadow: none;
     border-bottom: 3px solid #de999f; /* 포커스 시에도 밑줄 유지 */
   }

</style>
<div class="container">
  <div class="row">
    <div class="col-2 d-flex align-items-center" style="height: 100px">
      <a href="${pageContext.request.contextPath}/" class="d-flex justify-content-center" ><img alt="logo" src="${pageContext.request.contextPath}/resources/images/logo.png" style="width: 60%;"></a>
    </div>
    <div class="col-6 d-flex align-items-center position-relative" style="height: 100px;">
      <label for="totalSearch"></label>
      <input type="text"
             class="form-control h5 p-2"
             id="totalSearch"
             placeholder="검색어를 입력하세요."
             style="background-color: #fbe7e8; outline: none; border: none; border-bottom: 3px solid #de999f;" />
      <button type="button"
              class="btn position-absolute top-50 translate-middle-y"
              id="totalSearchBtn"
              style="right: 15px; font-size: 1.2em; margin-top: -5px;">
        <i class="bi bi-search"></i>
      </button>
    </div>
    <div class="col-4 d-flex align-items-center" style="height: 100px">
      <c:if test="${sessionScope.loginUser ne null}">
        <div class="row w-100 h-100 d-flex align-items-center">
          <div class="col-8">
            <p class="mb-0">${sessionScope.loginUser.name}님 환영합니다.</p>
          </div>
          <div class="col-4">
            <input type="button" class="btn btn-primary" id="logout" value="logout" />
          </div>
        </div>
      </c:if>
      <c:if test="${sessionScope.loginUser eq null}">
        <form action="<c:url value="/sign/login"/>" method="post" style="height: 25px;">
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
    <nav class="nav" style="position: absolute; z-index: 2; background-color: transparent;">
      <ul>
        <li class="nav-link">
          <a href="#">유치원</a>
          <div class="nav-item-box">
            <p class="nav-item"><a href="<c:url value="/company"/>">소개</a></p>
            <p class="nav-item"><a href="<c:url value="/teacher/list"/>">교원</a></p>
            <p class="nav-item"><a href="<c:url value="/children/list"/>">원생</a></p>
            <p class="nav-item"><a href="<c:url value="/children/graduatedList"/>">졸업생</a></p>
          </div>
        </li>
        <li class="nav-link">
          <a href="#">교육</a>
          <div class="nav-item-box">
            <p class="nav-item"><a href="<c:url value="/education/attendance/"/>">출석</a></p>
            <p class="nav-item"><a href="<c:url value="/education/dailyPlan/"/>">일일 계획안</a></p>
            <p class="nav-item"><a href="<c:url value="/education/activityRecord/"/>">활동기록</a></p>
            <p class="nav-item"><a href="<c:url value="/education/counsel/"/>">상담</a></p>
            <p class="nav-item"><a href="<c:url value="/education/healthCheck/"/>">건강검진</a></p>
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
            <p class="nav-item"><a href="${pageContext.request.contextPath}/food/">식단표</a></p>
            <p class="nav-item"><a href="${pageContext.request.contextPath}/board/form">양식</a></p>
          </div>
        </li>
        <li class="nav-link">
          <a href="#">통계</a>
          <div class="nav-item-box">
            <p class="nav-item"><a href="${pageContext.request.contextPath}/statistics/education">교육 통계</a></p>
            <p class="nav-item"><a href="${pageContext.request.contextPath}/statistics/page">페이지 통계</a></p>
          </div>
        </li>
        <li class="nav-link">
          <a href="#">설정</a>
          <div class="nav-item-box">
            <p class="nav-item"><a href="${pageContext.request.contextPath}/setting/">설정</a></p>
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