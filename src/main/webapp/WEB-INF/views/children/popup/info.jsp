<%--
  Created by IntelliJ IDEA.
  User: yhj43
  Date: 25. 2. 24.
  Time: 오후 1:16
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<html>
<head>
    <title>원생정보</title>
</head>
<body>
    <div class="container">
        <div class="text-end">
            <span class="small text-muted">최종수정일시: ${childVo.updDate}</span>
            <input type="button" class="btn btn-primary" value="수정" />
        </div>
        <table class="table table-primary">
            <tr>
                <td rowspan="3" width="26%">
                    <c:if test="${childVo.profilePath eq null}"><img src="${pageContext.request.contextPath}/resources/images/profile/default.jpg" alt="증명사진" style="width: 120px; height: auto;"></c:if>
                    <c:if test="${childVo.profilePath ne null}"><img src="${childVo.profilePath}" alt="증명사진" style="width: 120px; height: auto;"></c:if>
                </td>
                <td width="16%">원생번호</td>
                <td width="21%">${childVo.num}</td>
                <td width="16%">이름</td>
                <td width="21%">${childVo.name}</td>
            </tr>
            <tr>
                <td>학급</td>
                <td>${childVo.grade}</td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td>입학일</td>
                <td>${fn:substring(childVo.entryDate, 0, 10)}</td>
                <td></td>
                <td></td>
            </tr>
            <tr>
            </tr>
        </table>
    </div>
</body>
</html>
