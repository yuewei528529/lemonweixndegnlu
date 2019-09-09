<%@ page contentType="text/html;charset=GBK" %>
<%@ taglib uri="/WEB-INF/runqianDm.tld" prefix="dm" %>
<%
String needFixedHeader = request.getParameter("needFixedHeader");
if (!"no".equals(needFixedHeader)) needFixedHeader = "yes";
%>
<html>
<head>
<script>
</script>
</head>
<body style="border:0;height: 100%; width: 100%; margin: 0; padding: 0; font-size:12px; background-color:#EBF3FB;">
<dm:olap4Chart
	needFixedHeader="<%=needFixedHeader%>"
/>

</body>
</html>
