<%@ page contentType="text/html;charset=GBK" %>
<%@ taglib uri="/WEB-INF/runqianDm.tld" prefix="dm" %>
<%
	session.removeAttribute(request.getParameter("olapId"));
	session.removeAttribute(request.getParameter("pajId"));
%>