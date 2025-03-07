<%--
  Created by IntelliJ IDEA.
  User: yhj43
  Date: 2025-02-10
  Time: 오전 10:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<html>
<head>
  <meta charset="UTF-8">
  <title>유치원 통합 관리 시스템</title>
</head>
<style>
  /* ┌지울거┐ */
  .test_text {
    font-size: 3em;
    text-align: center;
  }
  /* └지울거┘ */
</style>
<body>
<div class="header" style="min-height: 200px;">
  <tiles:insertAttribute name="header" />
</div>
<div class="main-layout" style="min-height: 500px;">
  <tiles:insertAttribute name="body" />
</div>
<div class="footer" style="min-height: 100px; background-color: #b3b4b5">
  <tiles:insertAttribute name="footer" />
</div>
</body>
</html>
