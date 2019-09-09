<%@ page contentType="text/html;charset=GBK" %>
<%@ taglib uri="/WEB-INF/runqianDm.tld" prefix="dm" %>
<%@ page import="com.raq.olap.model.*" %>
<%@ page import="com.raq.web.view.web.*" %>
<%@ page import="com.raq.web.view.group.*" %>
<%@ page import="java.io.*" %>

<%
	String cp = request.getContextPath();
	
	String flag = request.getParameter("flag");
	
	// 利用Series对象生成GroupModelConfig对象
	if (false) { 
		// 把Series对象放到session中。
		com.raq.dm.Series series = null;
		SessionContext.setCurrSeries(session, series/*这里需要用户给定生成数据透视的序列*/);
		// 通过session中的Series对象生成GroupModelConfig对象，然后把GroupModelConfig对象也放到session中。
		GroupSaveUtil.open(request);
		
	// 把session中的GroupModelConfig对象保存到指定目录（这里指定为c:/example.par）。
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
		out.write("<script>alert('已经保存到\"c:/example.par\"目录下！');</script>");
		return;
		
	//把指定目录的数据透视文件打开，读到session中。
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
	// 把session中的GroupModelConfig导出到excel。
	window.submitFrame.location = '<%=cp%>/DMServlet?action=10&flag=group&d=' + new Date().getTime();
}
</script>
</head>
<body style="height: 100%; width: 100%; margin: 0; padding: 0; font-size:12px">
	<div style="margin:10">
		<a href="#" onclick='doSave()'>保存</a>&nbsp;&nbsp;
		<a href="#" onclick='doOpen()'>打开</a>&nbsp;&nbsp;
		<a href="#" onclick='saveAsExcel()'>导出EXCEL</a>&nbsp;&nbsp;
	</div>
	<!-- 标签类中会从session读取GroupModelConfig对象进行html显示 -->
 	<dm:group garName=""
	/>
	<div style="display:none"><iframe name='submitFrame' id="submitFrame" src="blank.html"></iframe></div>
</body>
</html>
