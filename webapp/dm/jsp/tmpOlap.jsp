<%@ page contentType="text/html;charset=GBK" %>
<%@ taglib uri="/WEB-INF/runqianDm.tld" prefix="dm" %>
<%@ page import="com.raq.dm.model.*" %>
<%@ page import="com.raq.dm.view.web.*" %>
<%@ page import="com.raq.dm.view.tag.*" %>
<%@ page import="com.raq.dm.view.olap.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.raq.dm.analyze.*" %>

<%
	String cp = request.getContextPath();

	String flag = request.getParameter("flag");
	String olapId = request.getParameter("olapId");
	
	//��ָ��Ŀ¼�Ľ�������ļ��򿪣�����session�С�
	if (olapId == null || "open".equals(flag)) {
		if (olapId == null) olapId = "olap" + new Date().getTime();
		try {
			ObjectInputStream ois = new ObjectInputStream( new FileInputStream( "c:/example.xar" ) );
			BaseConfig pmc = (BaseConfig)ois.readObject();
			session.setAttribute(olapId, new CubeModel( pmc ) {
				public void dataChanged() {
				}
			});
			ois.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		response.sendRedirect(cp + "/dm/jsp/setDimension.jsp?olapId=" + olapId);
		return;
	}
	
	// ��session�е�CubeModelConfig���󱣴浽ָ��Ŀ¼������ָ��Ϊc:/example.xar����
	if ("save".equals(flag)) {
		Object o = session.getAttribute(olapId);
		if (o != null) {
			CubeModel model = (CubeModel)o;
			try {
				FileOutputStream f = new FileOutputStream("c:/example.xar");
				ObjectOutputStream s = new ObjectOutputStream(f);
				s.writeObject(model.getConfig());
				s.flush();
				s.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		out.write("<script>alert('�Ѿ����浽\"c:/example.xar\"Ŀ¼�£�');</script>");
		return;
		
	}

%>

<html>
<head>
<script>
function doSave(){
	document.getElementById("submitFrame").src = "<%=cp%>/dm/jsp/tmpOlap.jsp?flag=save&olapId=<%=olapId%>";
}
function doOpen(){
	window.location.href='<%=cp%>/dm/jsp/tmpOlap.jsp?flag=open';
}
function saveAsExcel(){
	// ��session�е�CubeModelConfig������excel��
	window.submitFrame.location = '<%=cp%>/DMServlet?action=10&flag=olap&d=' + new Date().getTime();
}
</script>
</head>
<body style="height: 100%; width: 100%; margin: 0; padding: 0; font-size:12px">
	<div style="margin:10">
		<a href="#" onclick='doSave()'>����</a>&nbsp;&nbsp;
		<a href="#" onclick='doOpen()'>��</a>&nbsp;&nbsp;
		<a href="#" onclick='saveAsExcel()'>����EXCEL</a>&nbsp;&nbsp;
	</div>
	<!-- ��ǩ���л��session��ȡCubeModelConfig�������html��ʾ -->
 	<dm:olap
	/>
	<div style="display:none"><iframe name="submitFrame" id="submitFrame"></iframe></div>
</body>
</html>
