<%@ page contentType="text/html;charset=GBK" %>
<%@ page import="com.raq.web.view.group.*" %>
<%@ page import="com.raq.web.view.*" %>

<%
try{

String cp = request.getContextPath();
%>

<html>
<head>
<title>‘§¿¿Õ≥º∆Õº</title>
<link rel="stylesheet" href="<%=cp%>/dm/css/style.css" type="text/css"/>
<script type='text/javascript' src='<%=cp %>/dm/jsroot/jquery/jquery.js'></script>
<script type='text/javascript' src='<%=cp %>/dm/jsroot/jquery/jquery.ui.all.js'></script>
<script type='text/javascript' src='<%=cp %>/dm/jsroot/jquery/jquery.layout.js'></script>
<script type='text/javascript' src='<%=cp %>/dm/jsroot/jquery/jquery.blockUI.js'></script>
<script type='text/javascript' src='<%=cp%>/DMServlet?action=<%=DMServlet.ACTION_READJS%>&file=%2Fcom%2Fraq%2Fdm%2Fview%2Fcommon.js'></script>
<script>
$(document).ready(function(){
//	$("#G_revolve_div").dialog({close: function(event, ui) { setTimeout(function(){document.body.style.overflow='auto';},10); },autoOpen:false, width:290, maxWidth:290, minWidth:290, modal: true, overlay: { opacity: 0.1, background: "black" }});
});
window.$$ = function(id){return document.getElementById(id)};

</script>
</head>
<body style="font-size:12px;overflow:auto" class='page_bg1'>
<div id='ajaxSubmitNode' style='display:none'></div>
<%=GroupChartAction.generateHtml(request, request.getParameter("chartName")) %>
</body>
</html>

<%
}catch(Exception e){
	out.write(e.getMessage());
	e.printStackTrace();
}
%>
