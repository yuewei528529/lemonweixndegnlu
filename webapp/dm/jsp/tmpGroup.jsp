<%@ page contentType="text/html;charset=GBK" %>
<%@ taglib uri="/WEB-INF/runqianDm.tld" prefix="dm" %>
<%@ page import="com.raq.olap.model.*" %>
<%@ page import="com.raq.web.view.web.*" %>
<%@ page import="com.raq.web.view.group.*" %>
<%@ page import="java.io.*" %>

<%
	String cp = request.getContextPath();
	
	String flag = request.getParameter("flag");
	
	// ����Series��������GroupModelConfig����
	if (false) { 
		// ��Series����ŵ�session�С�
		com.raq.dm.Series series = null;
		SessionContext.setCurrSeries(session, series/*������Ҫ�û�������������͸�ӵ�����*/);
		// ͨ��session�е�Series��������GroupModelConfig����Ȼ���GroupModelConfig����Ҳ�ŵ�session�С�
		GroupSaveUtil.open(request);
		
	// ��session�е�GroupModelConfig���󱣴浽ָ��Ŀ¼������ָ��Ϊc:/example.par����
	} else if ("save".equals(flag)) {
		Object o = session.getAttribute(GroupAction.GROUP_SAVE_PATH);
		if (o != null) {
			GroupModel model = (GroupModel)o;
			try {
				FileOutputStream f = new FileOutputStream("c:/example.par");
				ObjectOutputStream s = new ObjectOutputStream(f);
				s.writeObject(model.getGroupModelConfig());
				s.flush();
				s.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		out.write("<script>alert('�Ѿ����浽\"c:/example.par\"Ŀ¼�£�');</script>");
		return;
		
	//��ָ��Ŀ¼������͸���ļ��򿪣�����session�С�
	} else {
		try {
			ObjectInputStream ois = new ObjectInputStream( new FileInputStream( "c:/example.par" ) );
			GroupModelConfig pmc = (GroupModelConfig)ois.readObject();
			session.setAttribute(GroupAction.GROUP_SAVE_PATH, new GroupModel( pmc ) {
				public void dataChanged() {
				}
			});
			ois.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

%>

<html>
<head>
<script>
function doSave(){
	document.getElementById("submitFrame").src = "<%=cp%>/tmpGroup.jsp?flag=save";
}
function doOpen(){
	window.location.href='<%=cp%>/tmpGroup.jsp?flag=open';
}
function saveAsExcel(){
	// ��session�е�GroupModelConfig������excel��
	window.submitFrame.location = '<%=cp%>/DMServlet?action=10&flag=group&d=' + new Date().getTime();
}
</script>
</head>
<body style="height: 100%; width: 100%; margin: 0; padding: 0; font-size:12px">
	<div style="margin:10">
		<a href="#" onclick='doSave()'>����</a>&nbsp;&nbsp;
		<a href="#" onclick='doOpen()'>��</a>&nbsp;&nbsp;
		<a href="#" onclick='saveAsExcel()'>����EXCEL</a>&nbsp;&nbsp;
	</div>
	<!-- ��ǩ���л��session��ȡGroupModelConfig�������html��ʾ -->
 	<dm:group garName=""
	/>
	<div style="display:none"><iframe name='submitFrame' id="submitFrame" src="blank.html"></iframe></div>
</body>
</html>
