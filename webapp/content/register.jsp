<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"></meta>
<title>Insert title here</title>
</head>
<body>
请先注册，填写您的真实姓名(中文)，不得使用昵称！
<form action="../register" method="get">
  <input type="hidden" name="oAuthType" th:value="${oAuthInfo.oAuthType}"></input>
  <input type="hidden" name="oAuthId" th:value="${oAuthInfo.oAuthId}"></input>
  <input type="hidden" name="username" th:value="${oAuthInfo.user.username}"></input>
  <input type="text" name="name" ></input>
  <input type="submit" value="提交"></input>
</form>
</body>
</html>