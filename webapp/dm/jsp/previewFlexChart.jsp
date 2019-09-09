<%@ page contentType="text/html;charset=GBK" %>
<%@ page import="com.raq.web.view.olap.*" %>
<%@ page import="com.raq.web.view.group.*" %>
<%@ page import="com.raq.web.view.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*" %>
<%
try{
String cp = request.getContextPath();

String chartName = request.getParameter("chartName");
String olapId = request.getParameter("olapId");;
String xml = null;
if (olapId != null) {
	xml = OlapChartAction.generateXml(request, olapId, chartName);
} else {
	xml = GroupChartAction.generateXml(request, chartName);
}
String xmlId = "chartXml";// + new Date().getTime();
session.setAttribute(xmlId, xml);
String prefix = "http://" + request.getLocalAddr() + ":" + request.getLocalPort() + cp;
prefix = cp;
String url = prefix + "/DMServlet?action=30&xmlId=" + xmlId + "&d=" + new Date().getTime();
url = URLEncoder.encode(url);
%>

<html>
<head>
<title>‘§¿¿FLASHÕ≥º∆Õº</title>
<link rel="stylesheet" href="<%=cp%>/dm/css/style.css" type="text/css"/>
<script type='text/javascript' src='<%=cp %>/dm/jsroot/jquery/jquery.js'></script>
<script type='text/javascript' src='<%=cp %>/dm/jsroot/jquery/jquery.ui.all.js'></script>
<script type='text/javascript' src='<%=cp %>/dm/jsroot/jquery/jquery.layout.js'></script>
<script type='text/javascript' src='<%=cp %>/dm/jsroot/jquery/jquery.blockUI.js'></script>
<script type='text/javascript' src='<%=cp%>/DMServlet?action=<%=DMServlet.ACTION_READJS%>&file=%2Fcom%2Fraq%2Fweb%2Fview%2Fcommon.js'></script>
<script>
$(document).ready(function(){
//	$("#G_revolve_div").dialog({close: function(event, ui) { setTimeout(function(){document.body.style.overflow='auto';},10); },autoOpen:false, width:290, maxWidth:290, minWidth:290, modal: true, overlay: { opacity: 0.1, background: "black" }});
});
window.$$ = function(id){return document.getElementById(id)};

function resizeFlex() {
	document.getElementById("flexObject").myshow(document.body.offsetWidth-50,document.body.offsetHeight-70);
}
</script>
</head>
<body style="font-size:12px;overflow:auto" onresize="resizeFlex();" class='page_bg1' onunload='try{opener.unBlockUI();opener.isOpen4Chart=false;opener.focus();}catch(e){}'>
<div id='ajaxSubmitNode' style='display:none'></div>
<object id='flexObject' classid='clsid:d27cdb6e-ae6d-11cf-96b8-444553540000' codebase='http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab' width='100%' height='100%'>
	<param value='<%=prefix %>/dm/DataFlex.swf' name='movie'/>
	<param name='FlashVars' value='param1=<%=url %>'/>
	<embed src='<%=prefix %>/dm/DataFlex.swf?param1=<%=url %>' quality='high' pluginspage='http://www.macromedia.com/go/getflashplayer' type='application/x-shockwave-flash' width='100%' height='100%'>
	</embed>
</object>
</body>
</html>

<%
}catch(Exception e){
	e.printStackTrace();
}
%>
