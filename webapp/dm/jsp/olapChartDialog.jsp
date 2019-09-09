<%@ page contentType="text/html;charset=GBK" %>
<%@ page import="com.raq.ide.common.*" %>
<%@ page import="com.raq.olap.model.*" %>
<%@ page import="com.raq.web.view.*" %>
<%@ page import="java.util.*" %>

<%
try{

String cp = request.getContextPath();
String olapId = request.getParameter("olapId");
CubeModel model = (CubeModel)session.getAttribute(olapId);
BaseConfig conf = model.getConfig();
%>

<html>
<head>
<title>交叉分析统计图管理</title>
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

function addChart(){
	newWindow4Chart = window.open ("<%=cp%>/dm/jsp/olapChartConfig.jsp?olapId=<%=olapId%>", "newWindow4Chart", "height=470, width=530, toolbar= no, menubar=no, scrollbars=yes, resizable=no, location=no, status=no,top=" + (screen.height - 470)/2 + ",left=" + (screen.width - 530)/2);
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
	$("#ajaxSubmitNode").load("<%=cp%>/DMServletAjax?d=" + new Date().getTime(), {olapId:'<%=olapId%>',action:<%=DMServlet.ACTION_OLAP_CHART%>,chartAction:"remove",removes:removes}, function(){
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
	
	newWindow4Chart = window.open ("<%=cp%>/dm/jsp/olapChartConfig.jsp?olapId=<%=olapId%>&chartName=" + chartName, "newWindow4Chart", "height=470, width=530, toolbar= no, menubar=no, scrollbars=yes, resizable=no, location=no, status=no,top=" + (screen.height - 470)/2 + ",left=" + (screen.width - 530)/2);
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
	newWindow4Chart = window.open ("<%=cp%>/dm/jsp/olapChartPreview.jsp?olapId=<%=olapId%>&chartName=" + chartName, "newWindow4Chart", "height=650, width=930, toolbar= no, menubar=no, scrollbars=yes, resizable=no, location=no, status=no,top=" + (screen.height - 650)/2 + ",left=" + (screen.width - 930)/2 + "");
	blockUI();
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
	newWindow4Chart = window.open ("<%=cp%>/dm/jsp/previewFlexChart.jsp?olapId=<%=olapId%>&chartName=" + chartName, "newWindow4Chart", "height=630, width=840, toolbar= no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no,top=" + (screen.height - 630)/2 + ",left=" + (screen.width - 840)/2 + "");
	blockUI();
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
<body style="font-size:12px;overflow:hidden;margin:0px;padding:0px;" class='page_bg1' onunload='try{opener.top.unBlockUI();opener.top.isOpen4PHG=false;opener.top.focus();}catch(e){}'>
<div id='ajaxSubmitNode' style='display:none'></div>
<div style='margin:10px 10px 0 10px;width:300px;height:195px;'>
	<div style='width:220px;height:190px;float:left;'>
		<select multiple id='charts' style='width:100%;height:100%;font-size:12px;'>
		<%
		Map charts = conf.getCharts();
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
	<div style='width:80px;height:190px;float:left;'>
		<div><input type='button' onmouseover='this.style.cursor="hand"' style='margin:0 0 5px 10px;background-image:url("<%=cp%>/dm/images/but_back_2.png");border:0px;width:51px;height:22px;' onclick="addChart();" value='增加'></div>
		<div><input type='button' onmouseover='this.style.cursor="hand"' style='margin:0 0 5px 10px;background-image:url("<%=cp%>/dm/images/but_back_2.png");border:0px;width:51px;height:22px;' onclick="removeChart();" value='删除'></div>
		<div><input type='button' onmouseover='this.style.cursor="hand"' style='margin:0 0 5px 10px;background-image:url("<%=cp%>/dm/images/but_back_2.png");border:0px;width:51px;height:22px;' onclick="configChart();" value='设置'></div>
		<div><input type='button' onmouseover='this.style.cursor="hand"' style='margin:0 0 30px 10px;background-image:url("<%=cp%>/dm/images/but_back_2.png");border:0px;width:51px;height:22px;' onclick="showChart();" value='预览'></div>
		<!-- <div><input type='button' onmouseover='this.style.cursor="hand"' style='margin:0 0 30 10;background-image:url("<%=cp%>/dm/images/but_back_2.png");border:0px;width:51px;height:22px;' onclick="showFlashChart();" value='FLASH'></div> -->
	</div>
	<div style='clear:both;'></div>
</div>

<div style='border-bottom:1px solid #CEE2F9;margin:0 0 1px 0;font-size:1px;'></div>
<div style='height:25px;padding: 6px 0 3px 230px;background-color:#CEE2F9;'>
	<input type='button' onmouseover='this.style.cursor="hand"' style='margin:0 0 0 10px;background-image:url("<%=cp%>/dm/images/but_back_2.png");border:0px;width:51px;height:22px;' onclick="window.close();" value='关闭'>
</div>


</body>
</html>

<%
}catch(Exception e){
	e.printStackTrace();
}
%>
