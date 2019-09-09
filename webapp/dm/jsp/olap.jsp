<%@ page contentType="text/html;charset=GBK" %>
<%@ taglib uri="/WEB-INF/runqianDm.tld" prefix="dm" %>
<%
String needFixedHeader = request.getParameter("needFixedHeader");
//if (!"yes".equals(needFixedHeader)) needFixedHeader = "no";
needFixedHeader = "yes";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<script>
</script>
</head>
<body style="border:0;height: 100%; width: 100%; margin: 0; padding: 0; font-size:12px; background-color:#EBF3FB;">
<dm:olap
	needFixedHeader="<%=needFixedHeader%>"
	needSetMtx="yes"
	filterStr=""
/>

</body>
</html>
