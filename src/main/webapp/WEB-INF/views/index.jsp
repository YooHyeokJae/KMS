<%--
  Created by IntelliJ IDEA.
  User: yhj43
  Date: 2025-02-10
  Time: 오전 10:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<html>
<head>
    <title>유치원 통합 관리 시스템</title>
</head>
<style>
    div {
        border: 1px solid black;
    }
    .search_icon {
        background-image: url('<c:url value="/resources/images/search_icon.png"/>');
        background-size: contain;
        background-repeat: no-repeat;
    }
    .test_text {
        font-size: 3em;
        text-align: center;
    }
    .nav > ul .nav-link {
        display: inline-grid;
    }
    .nav-item {
        display: none;
    }
</style>
<body>
<script>
    $(function(){
        let $nav = $('#nav_cont');
        $nav.on('mouseover', function(){
            $('.nav-item').css('display', 'block');
        })
        $nav.on('mouseleave', function(){
            $('.nav-item').css('display', 'none');
        })
    })
</script>
<div class="header">
    <div class="container">
        <div class="row">
            <div class="col-2" style="height: 100px">
                <a href="${pageContext.request.contextPath}/" class="test_text">로고</a>
            </div>
            <div class="col-10" style="height: 100px">
                <label for="totalSearch"><input type="text" id="totalSearch" placeholder="검색어를 입력하세요."/></label>
                <input type="button" class="search_icon" style="width: 30px;" />
            </div>
        </div>
    </div>
    <div class="row" style="background-color: #fabf62">
        <div class="col-2" style="height: 100px"></div>
        <div class="col-8" style="height: 100px">
            <div id="nav_cont" class="container">
                <nav class="nav">
                    <ul>
                        <li class="nav-link">
                            <a href="#">교원</a>
                            <div>
                                <p class="nav-item"><a href="#">교원 등록</a></p>
                                <p class="nav-item"><a href="#">교원 목록</a></p>
                                <p class="nav-item"><a href="#">교원 수정</a></p>
                                <p class="nav-item"><a href="#">교원 삭제</a></p>
                            </div>
                        </li>
                        <li class="nav-link">
                            <a href="#">원생</a>
                            <div>
                                <p class="nav-item"><a href="#">원생 등록</a></p>
                                <p class="nav-item"><a href="#">원생 목록</a></p>
                                <p class="nav-item"><a href="#">원생 수정</a></p>
                                <p class="nav-item"><a href="#">원생 삭제</a></p>
                            </div>
                        </li>
                        <li class="nav-link">
                            <a href="#">학사</a>
                            <div>
                                <p class="nav-item"><a href="#">학사 관리</a></p>
                            </div>
                        </li>
                        <li class="nav-link">
                            <a href="#">게시판</a>
                            <div>
                                <p class="nav-item"><a href="#">공지사항</a></p>
                                <p class="nav-item"><a href="#">자유게시판</a></p>
                            </div>
                        </li>
                        <li class="nav-link">
                            <a href="#">자료실</a>
                            <div>
                                <p class="nav-item"><a href="#">학사일정</a></p>
                                <p class="nav-item"><a href="#">식단표</a></p>
                                <p class="nav-item"><a href="#">양식</a></p>
                            </div>
                        </li>
                        <li class="nav-link">
                            <a href="#">통계</a>
                            <div>
                                <p class="nav-item"><a href="#">접속자 통계</a></p>
                            </div>
                        </li>
                        <li class="nav-link">
                            <a href="#">설정</a>
                            <div>
                                <p class="nav-item"><a href="#">설정</a></p>
                            </div>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
        <div class="col-2" style="height: 100px"></div>
    </div>
</div>
<div class="main-layout">
    <div class="container">
        <div class="row">
            <div class="col-8" style="height: 800px"></div>
            <div class="col-4" style="height: 800px"></div>
        </div>
    </div>
</div>
<div class="footer" style="height: 200px">

</div>
</body>
</html>
