<%@ page contentType="text/html;charset=GBK"%>
<%@ taglib uri="/WEB-INF/runqianDm.tld" prefix="dm" %>
<%
	String path = request.getContextPath();
%>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html>
	<head>
		<title>集算器即时报表</title>

	<script>
	// 打开paj后，返回pajId，用户决定如何显示打开的paj。
	function afterOpenGroup(pajId){
		window.location.href = "<%=path%>/rqweb/showPaj.jsp?pajId=" + pajId;
	}
	</script>
</head>
<body style="height: 100%; width: 100%; margin: 0; padding: 0; font-size:13px">
	<div style="margin:10px;">
		<a href='javascript:saveGroup()'>保存</a>&nbsp;&nbsp;
		<a href='javascript:openGroup();'>打开</a>&nbsp;&nbsp;
		<a href='javascript:saveGroupAsExcel()'>导出EXCEL</a>&nbsp;&nbsp;
	</div>
	<!-- 标签类中会从session读取GroupModelConfig对象进行html显示 -->
 	<dm:group
 		chartType="html"
 	/>
</body>
</html>
