<%@ page contentType="text/html;charset=GBK"%>
<%@ taglib uri="/WEB-INF/runqianDm.tld" prefix="dm" %>
<%
	String path = request.getContextPath();
%>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html>
	<head>
		<title>��������ʱ����</title>

	<script>
	// ��paj�󣬷���pajId���û����������ʾ�򿪵�paj��
	function afterOpenGroup(pajId){
		window.location.href = "<%=path%>/rqweb/showPaj.jsp?pajId=" + pajId;
	}
	</script>
</head>
<body style="height: 100%; width: 100%; margin: 0; padding: 0; font-size:13px">
	<div style="margin:10px;">
		<a href='javascript:saveGroup()'>����</a>&nbsp;&nbsp;
		<a href='javascript:openGroup();'>��</a>&nbsp;&nbsp;
		<a href='javascript:saveGroupAsExcel()'>����EXCEL</a>&nbsp;&nbsp;
	</div>
	<!-- ��ǩ���л��session��ȡGroupModelConfig�������html��ʾ -->
 	<dm:group
 		chartType="html"
 	/>
</body>
</html>
