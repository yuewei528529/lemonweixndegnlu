<%@ page contentType="text/html;charset=GBK" %>
<%@ page import="com.raq.web.view.tag.*" %>
<%@ page import="com.raq.web.view.group.*" %>
<%@ page import="com.raq.web.view.*" %>
<%@ page import="com.raq.web.view.web.*" %>
<%@ page import="com.raq.olap.model.*" %>
<%@ page import="com.raq.ide.chart.edit.*" %>
<%@ page import="com.raq.ide.chart.report4.*" %>
<%@ page import="com.raq.ide.common.*" %>
<%@ page import="java.util.*" %>

<%
try{

String cp = request.getContextPath();
String pajId = request.getParameter("pajId");
Object o = session.getAttribute(pajId);
if (o == null || !(o instanceof GroupModel)) {
	out.write("未找到数据透视文件");
	return;
}
GroupModelConfig gmc = ((GroupModel)o).getGroupModelConfig();
%>

<html>
<head>
<title>数据透视统计图管理</title>
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

function addChart(){
	newWindow4Chart = window.open ("<%=cp%>/dm/jsp/groupChartConfig.jsp?pajId=<%=pajId%>", "newWindow4Chart", "height=400, width=530, toolbar= no, menubar=no, scrollbars=yes, resizable=no, location=no, status=no,top=400,left=400");
	blockUI();
}

function removeChart(){
	var removes = "";
	var charts = $$('charts');
	for (var i=0; i<charts.options.length; i++) {
		var option = charts.options[i];
		if (option.selected) {
			if (removes != "") removes += ";";
			removes += option.value;
		}
	}
	$("#ajaxSubmitNode").load("<%=cp%>/DMServletAjax?d=" + new Date().getTime(), {action:<%=DMServlet.ACTION_GROUP_CHART%>,chartAction:"remove",removes:removes,pajId:'<%=pajId%>'}, function(){
		for (var i=charts.options.length-1; i>=0; i--) {
			var option = charts.options[i];
			if (option.selected) {
				charts.removeChild(option);
			}
		}
	});
}

function configChart(){
	var chartName = null;
	var charts = $$('charts');
	for (var i=0; i<charts.options.length; i++) {
		var option = charts.options[i];
		if (option.selected) {
			if (chartName != null) {
				return;
			}
			chartName = option.value;
		}
	}
	if (chartName == null) return;
	newWindow4Chart = window.open ("<%=cp%>/dm/jsp/groupChartConfig.jsp?chartName=" + chartName + "&pajId=<%=pajId%>", "newWindow4Chart", "height=400, width=530, toolbar= no, menubar=no, scrollbars=yes, resizable=no, location=no, status=no,top=400,left=400");
	blockUI();
}

function showChart(){
	var chartName = null;
	var charts = $$('charts');
	for (var i=0; i<charts.options.length; i++) {
		var option = charts.options[i];
		if (option.selected) {
			if (chartName != null) {
				return;
			}
			chartName = option.value;
		}
	}
	if (chartName == null) return;
	window.open ("<%=cp%>/dm/jsp/groupChartPreview.jsp?chartName=" + chartName + "&pajId=<%=pajId%>", "n" + new Date().getTime(), 'height=630, width=840, toolbar= no, menubar=no, scrollbars=yes, location=no, status=no');
}

function showFlashChart() {
	var chartName = null;
	var charts = $$('charts');
	for (var i=0; i<charts.options.length; i++) {
		var option = charts.options[i];
		if (option.selected) {
			if (chartName != null) {
				return;
			}
			chartName = option.value;
		}
	}
	if (chartName == null) return;
	window.open ("<%=cp%>/dm/jsp/previewFlexChart.jsp?chartName=" + chartName + "&pajId=<%=pajId%>", "n" + new Date().getTime(), "height=630, width=840, toolbar= no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no,top=50,left=100");
}

var newWindow4Chart;
var isOpen4Chart = false;
function blockUI() {
	$.blockUI({
		message:'',
		css: { 
	        width:          '0px',
	        top:            '10', 
	        left:          	'90%', 
	        textAlign:      'left', 
	        border:         '0px solid #aaa'
		},
	    overlayCSS:  { 
	        opacity:        '0.0' 
	    },
	    fadeOut:  100,
	    centerX: false,
	    centerY: false
	});
	isOpen4Chart = true;
}

function unBlockUI() {
	$.unblockUI();
	isOpen4Chart = false;
}
function checkModelDialog() {
	if(isOpen4Chart){
		newWindow4Chart.focus();
	}
}

function changeName(oldName, newName){
	var os = $$('charts').options;
	if (oldName == "") {
		for (var i=0; i<os.length; i++) {
			os[i].selected = false;
		}
		var o = document.createElement("option");
		o.text = newName;
		o.value = newName;
		o.selected = true;
		os[os.length] = o;
	} else {
		for (var i=0; i<os.length; i++) {
			if (os[i].value == oldName) {
				os[i].value = newName;
				os[i].text = newName;
				os[i].selected = true;
				return;
			}
		}
	}
}

</script>
</head>
<body style="font-size:12px;overflow:auto" class='page_bg1' onunload='try{opener.top.unBlockUI();opener.top.isOpen4PHG=false;opener.top.focus();}catch(e){}'>
<div id='ajaxSubmitNode' style='display:none'></div>
<div style='margin:10px;width:300px;height:195px;'>
	<div style='width:200px;height:195px;float:left;'>
		<select multiple id='charts' style='width:100%;height:100%;font-size:12px;'>
		<%
		Map charts = gmc.getCharts();
		if (charts != null) {
			Iterator iter = charts.keySet().iterator();
			while (iter.hasNext()) {
				String name = iter.next().toString();
				%>
				<option<%=iter.hasNext()?"":" selected"%> value='<%=name%>'><%=name%></option>
				<%
			}
		}
		%>
		</select>
	</div>
	<div style='width:100px;height:190px;float:left;'>
		<div><input type='button' onmouseover='this.style.cursor="hand"' style='margin:0 0 5px 10px;background-image:url("<%=cp%>/dm/images/olap_phg_submit.gif");border:0px;width:50;height:23px;' onclick="addChart();" value='增加'></div>
		<div><input type='button' onmouseover='this.style.cursor="hand"' style='margin:0 0 5px 10px;background-image:url("<%=cp%>/dm/images/olap_phg_submit.gif");border:0px;width:50;height:23px;' onclick="removeChart();" value='删除'></div>
		<div><input type='button' onmouseover='this.style.cursor="hand"' style='margin:0 0 5px 10px;background-image:url("<%=cp%>/dm/images/olap_phg_submit.gif");border:0px;width:50;height:23px;' onclick="configChart();" value='设置'></div>
		<div><input type='button' onmouseover='this.style.cursor="hand"' style='margin:0 0 30px 10px;background-image:url("<%=cp%>/dm/images/olap_phg_submit.gif");border:0px;width:50;height:23px;' onclick="showChart();" value='预览'></div>
		<!-- <div><input type='button' onmouseover='this.style.cursor="hand"' style='margin:0 0 30 10;background-image:url("<%=cp%>/dm/images/olap_phg_submit.gif");border:0px;width:50;height:23px;' onclick="showFlashChart();" value='FLASH'></div> -->
		<div><input type='button' onmouseover='this.style.cursor="hand"' style='margin:0 0 0 10px;background-image:url("<%=cp%>/dm/images/olap_phg_submit.gif");border:0px;width:50;height:23px;' onclick="window.close();" value='关闭'></div>
	</div>
</div>

<div style='width:460px;algin:center;margin:20px 0 0 0'>
</div>
</body>
</html>

<%
}catch(Exception e){
	e.printStackTrace();
}
%>
