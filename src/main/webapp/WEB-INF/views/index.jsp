<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<div class="container">
    <div class="row">
        <div class="col-8" style="height: 800px">
            <p>test: ${test}</p>
        </div>
        <div class="col-4" style="height: 800px">
            <form action="<c:url value="/login/"/>" method="post">
                <label for="userId">아이디: <input type="text" id="userId" /></label>
                <label for="passwd">비밀번호: <input type="password" id="passwd" /></label>
                <input type="submit" value="login" />
            </form>
        </div>
    </div>
</div>