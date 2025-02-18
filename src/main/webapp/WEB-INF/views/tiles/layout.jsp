<%--
  Created by IntelliJ IDEA.
  User: yhj43
  Date: 2025-02-10
  Time: 오전 10:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<html>
<head>
  <meta charset="UTF-8">
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
  .nav-item-box {
    list-style: none;
    padding: 0;
    margin: 0;
    box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);

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
    max-height: 200px; /* 충분히 큰 값 설정 */
  }
  .nav-link {
    min-width: 120px;
  }
</style>
<body>
<script>
  $(function(){

  })
</script>
<div class="header">
  <tiles:insertAttribute name="header" />
</div>
<div class="main-layout">
  <tiles:insertAttribute name="body" />
</div>
<div class="footer">
  <tiles:insertAttribute name="footer" />
</div>
</body>
</html>
