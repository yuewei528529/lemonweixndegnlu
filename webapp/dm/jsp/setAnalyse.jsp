<%@ page contentType="text/html;charset=GBK" %>
<%@ page import="com.raq.web.view.tag.*" %>
<%@ page import="com.raq.olap.model.*" %>
<%@ page import="com.raq.web.view.*" %>
<%@ page import="com.raq.ide.common.*" %>
<%@ page import="java.util.*" %>

<%
String cp = request.getContextPath();

String olapId = request.getParameter("olapId");
CubeModel cm = (CubeModel)session.getAttribute(olapId);
BaseConfig cmc = cm.getConfig();
DimensionDefine dds[] = cmc.getDimensionDefine();
AggregateDefine[] ads = cmc.getAggregateDefine();
AnalyzeDefine[] analyzes = cmc.getAnalyzeDefine();
try{
%>

<html>
<head>
<title>设置分析项</title>
<link rel="stylesheet" href="<%=cp%>/dm/css/style.css" type="text/css"/>
<script type='text/javascript' src='<%=cp %>/dm/jsroot/jquery/jquery.js'></script>
<script type='text/javascript' src='<%=cp %>/dm/jsroot/jquery/jquery.ui.all.js'></script>
<script type='text/javascript' src='<%=cp %>/dm/jsroot/jquery/jquery.layout.js'></script>
<script type='text/javascript' src='<%=cp %>/dm/jsroot/jquery/jquery.blockUI.js'></script>
<script type='text/javascript' src='<%=cp%>/DMServlet?action=<%=DMServlet.ACTION_READJS%>&file=%2Fcom%2Fraq%2Fweb%2Fview%2Fcommon.js'></script>
<script>
$(document).ready(function(){
	$("#layerDialog").dialog({close: function(event, ui) { $("select").each(function(){this.style.visibility='visible';document.body.style.overflow='auto';}); },autoOpen:false, width:310, maxWidth:310, minWidth:310, modal: true, overlay: { opacity: 0.1, background: "black" }});
});

var status = 0; // 0:不需要刷新;   1:只刷新右侧内容;    2:全部刷新;

var ddSelect = "<select style='width:100%;' onchange='getFirstChild(getChildNodes(this.parentNode.parentNode)[5]).layers=\"\";'>";
var dds = new Array();
<%
	for (int i=0; i<dds.length; i++) {
		%>
		dds[<%=i%>] = new Array();
		dds[<%=i%>][0] = '<%=dds[i].getColName()%>';
		ddSelect += "<option value='<%=dds[i].getColName()%>'><%=dds[i].getColName()%></option>";
		<%
		PivotLayer[] pls = dds[i].getOrderedPivotLayers();
		if (pls == null) {
			Series h = dds[i].getOriginalHSeries();
			Section allCols = new Section(h.getLevelInfo());
			for (int j = 0; j < allCols.size(); j++) {
				%>
				dds[<%=i%>][<%=j+1%>] = '<%=allCols.get(j)%>';
				<%
			}
		} else {
			for (int j=0; j<pls.length; j++) {
				if (pls[j].isDisplay()) {
					%>
					dds[<%=i%>][<%=j+1%>] = '<%=pls[j].getName()%>';
					<%
					
				}
			}
		}
	}
%>
ddSelect += "</select>";

function getLayerSelect(dimName) {
	var tmp = "<select style='width:100%;'>";
	for (var i=0; i<dds.length; i++) {
		if (dds[i][0] == dimName) {
			for (var j=1; j<dds[i].length; j++){
				if (dds[i][j] != null) {
					tmp += "<option value='" + dds[i][j] + "'>" + dds[i][j] + "</option>";
				}
			}
		}
	}
	tmp += "</select>";
	return tmp;
}

var adSelect = "<select style='width:100%;'>";
var ads = new Array();
<%
	for (int i=0; i<ads.length; i++) {
		%>
		ads[<%=i%>] = '<%=ads[i].getTitle()%>';
		adSelect += "<option value='<%=ads[i].getTitle()%>'><%=ads[i].getTitle()%></option>";
		<%
	}
%>
adSelect += "</select>";

//var typeSelect = "<select style='width:100%;'><option value='1'>同比</option><option value='2'>占比</option><option value='3'>累计</option><option value='4'>排名</option></select>";
var typeSelect = "<input style='width:150px;' type='text'>";
var expSelect = "<select style='width:60px;' onchange='expChanged(this);'>";
<%
	Iterator iter = AnalyzeDefine.defaults.keySet().iterator();
	while (iter.hasNext()) {
		String name = iter.next().toString();
		String value = AnalyzeDefine.defaults.get(name).toString();
		%>
		expSelect += "<option value='<%=value%>'><%=name%></option>";
		<%
	}
%>
expSelect += "</select>";

function expChanged(node) {
	getFirstChild(getChildNodes(node.parentNode.parentNode)[3]).value = node.value;
}

var analyzes = new Array();
<%
	if (analyzes!=null) {
		for (int i=0; i<analyzes.length; i++) {
			AnalyzeDefine analyze = analyzes[i];
			%>
			analyzes[<%=i%>] = new Array();
			analyzes[<%=i%>][0] = '<%=analyze.getTitle()%>';
			analyzes[<%=i%>][1] = '<%=analyze.getDimensionDefine().getColName()%>';
			analyzes[<%=i%>][2] = '<%=analyze.getAggregateDefine().getTitle()%>';
			analyzes[<%=i%>][3] = '<%=analyze.getExp()%>';
			analyzes[<%=i%>][4] = new Array();
			<%
			String[] bases = analyze.getBaseLayer();
			String[] ranges = analyze.getRangeLayer();
			for (int j=0; j<bases.length; j++) {
				%>
				analyzes[<%=i%>][4][<%=j%>] = '<%=bases[j]+"_"+ranges[j]%>';
				<%
			}
		}
	}
%>

function initAnalyse(){
	for (var i=0; i<analyzes.length; i++) {
		addRow(analyzes[i]);
	} 
}

function addRow(analyze) {
	var row = $("#H_table")[0].insertRow(-1);
	row.style.height = '24px';
	
	var td = row.insertCell(-1);
	td.innerHTML = "<input type='text' style='width:100%;border:0px'>";
	if (analyze != null) getFirstChild(td).value = analyze[0];
	else getFirstChild(td).value = getNewName();
	
	td = row.insertCell(-1);
	td.innerHTML = ddSelect;
	if (analyze != null) getFirstChild(td).value = analyze[1];
	
	td = row.insertCell(-1);
	td.innerHTML = adSelect;
	if (analyze != null) getFirstChild(td).value = analyze[2];
	
	td = row.insertCell(-1);
	td.innerHTML = typeSelect;
	if (analyze != null) getFirstChild(td).value = analyze[3];
	
	td = row.insertCell(-1);
	td.innerHTML = expSelect;
	if (analyze != null) getFirstChild(td).value = analyze[3];
	expChanged(getFirstChild(td));

/*	
	td = row.insertCell(-1);
	td.innerHTML = "<input type='checkbox'>";
	td.align = 'center';
	if (analyze != null) getFirstChild(td).checked = analyze[4];
*/
	
	td = row.insertCell(-1);
	td.innerHTML = "<button onclick='setLayers(this);' class='border1' style='width:100%;height:90%;background-color:#EEF1F6;margin:1;background-image:url(\"<%=cp %>/dm/images/m_slice.gif\");background-repeat:no-repeat;background-position:center center;'>&nbsp;</button>";
	if (analyze != null) getFirstChild(td).layers = analyze[4].join(",");
	
	td = row.insertCell(-1);
	td.innerHTML = "<button onclick='this.parentNode.parentNode.parentNode.removeChild(this.parentNode.parentNode);' class='border1' style='width:100%;height:90%;background-color:#EEF1F6;margin:1;background-image:url(\"<%=cp %>/dm/images/m_pmtdelete.gif\");background-position:center center;'>&nbsp;</button>";
	
}

function getNewName(){
	var names = $("#H_table input[@type=text]");
	for (var i=1; i<1000; i++){
		var tmp = "analyze" + i;
		var exist = false;
		for (var j=0; j<names.length; j++) {
			if (names[j].value == tmp) {
				exist = true;
				break;
			}
		}
		if (!exist) return tmp;
	}
}

var currSelect;
var currLayerNode;
function setLayers(node) {
	var rows = $("#layerTable")[0].rows;
	for (var i=rows.length-1; i>=1; i--) rows[i].parentNode.removeChild(rows[i]);
	$("select").each(function(){this.style.visibility='hidden';});
	document.body.style.overflow='hidden';
	$("#layerDialog").dialog("open");
	var select = getLayerSelect(getFirstChild(getChildNodes(node.parentNode.parentNode)[1]).value);
	currSelect = select;
	currLayerNode = node;
	if (node.layers != null) {
		var ls = node.layers.split(",");
		for (var i=0; i<ls.length; i++) {
			if (ls[i] != ""){
				var tmp = ls[i].split("_");
				addLayer(tmp[0], tmp[1], select);
			}
		}
	}
}

function addLayer(base, range, select) {
	var tr = $('#layerTable')[0].insertRow(-1);
	tr.style.height='20px';
	//tr.id = "id_" + comQuery.maxId;

	var td = tr.insertCell(-1);
	td.innerHTML = select;
	getFirstChild(td).value=base;
	
	td = tr.insertCell(-1);
	td.innerHTML = select.replace("<select style='width:100%;'><option","<select style='width:100%;'><option value='全部'>全部</option><option");
	getFirstChild(td).value=range;

	td = tr.insertCell(-1);
	td.align='center';
	td.innerHTML = "<button onclick='this.parentNode.parentNode.parentNode.removeChild(this.parentNode.parentNode);' class='border1' style='width:100%;height:90%;background-color:#EEF1F6;margin:1;background-image:url(\"<%=cp %>/dm/images/m_pmtdelete.gif\");background-position:center center;'>&nbsp;</button>";
}

/*
检查：
	1、空的分析层和跨度层
	2、分析层是否比跨度层小。
*/
function submitLayers() {
	var inputs = $("#layerTable select");
	var result="";
	var bases = ",";
	for (var i=0; i<inputs.length; i=i+2) {
		var base = inputs[i];
		var range = inputs[i+1];
		if (base.value == '' || range.value == '') {
			alert('请选择分析层和跨度层！');
			return;
		}
		if (range.selectedIndex >= base.selectedIndex + 1) {
			alert('第' + (i/2 + 1) + '行跨度层应该大于分析层');
			return;
		}
		if (bases.indexOf("," + base.value + ",") >= 0) {
			alert('分析层名称不允许重复：' + base.value);
			return;
		}
		bases += base.value + ",";
		if (i > 0) result += ",";
		result += base.value + '_' + range.value;
	}
	currLayerNode.layers = result;
	$("#layerDialog").dialog("close");
}

function submitAnalyzes(){
	var names = $("#H_table input[@type=text]");
	for (var j=0; j<names.length; j++) {
		if (jQuery.trim(names[j].value) == "") {
			alert("标题不能为空！");
			return;
		}
	}
	var rows = $("#H_table")[0].rows;
	var result = '';
	for (var i=1; i<rows.length; i++) {
		if (result != '') result += "_;_";
		result += jQuery.trim(getFirstChild(getChildNodes(rows[i])[0]).value);
		result += ";" + getFirstChild(getChildNodes(rows[i])[1]).value;
		result += ";" + getFirstChild(getChildNodes(rows[i])[2]).value;
		result += ";" + getFirstChild(getChildNodes(rows[i])[3]).value;
		//result += ";" + (getFirstChild(getChildNodes(rows[i])[4]).checked?1:0);
		var layers = getFirstChild(getChildNodes(rows[i])[5]).layers
		result += ";" + (layers==null?"":layers);
	}

	$("#ajaxSubmitNode").load("<%=cp%>/DMServletAjax?d=" + new Date().getTime(), {action:<%=DMServlet.ACTION_OLAPANALYZE %>,analyzes:result,olapId:'<%=olapId%>'}, function(){opener.olap_slice();window.close();});
	
}
</script>
</head>
<body style="font-size:12px;overflow:auto" class='page_bg1' onload='initAnalyse();' onunload='try{opener.top.unBlockUI();opener.top.isOpen4PHG=false;opener.top.focus();}catch(e){}'>
<div id='ajaxSubmitNode' style='display:none'></div>
<div style='display:none'>
	<div id='layerDialog' class='flora' title='分析层和跨度层定义' style='font-size:12px'>
		<div style='height:120;overflow-x:hidden;overflow-y:auto;margin:0 0 5px 0;'>
			<table id='layerTable' style='border-collapse:collapse;width:100%;font-size:12px;border:1px solid #ddd;' cellspacing='0' cellpadding='0'>
				<tr height='25px'><th width='100px'>分析层</th><th width='100px'>跨度层</th><th width='33px'>操作</th></tr>
			</table>
		</div>
		<center>
			<button dojoType='dijit.form.Button' onclick='addLayer(null, null, currSelect);' style='font-size:12px'>增加</button>&nbsp;&nbsp;
			<button dojoType='dijit.form.Button' onclick='submitLayers();' style='font-size:12px'>确定</button>&nbsp;&nbsp;
			<button dojoType='dijit.form.Button' onclick='$("#layerDialog").dialog("close");' style='font-size:12px'>取消</button>
		</center>
	</div>

	<div id='measureDialog' title='定义分析' style='font-size:12px'>
		<div style='overflow-x:hidden;overflow-y:auto;margin:0 0 5px 0;'>
			类型　&nbsp;&nbsp;<input type='radio' name='measureType'>循环型&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='radio' name='measureType'>聚合型
		</div>
		<div style='overflow-x:hidden;overflow-y:auto;margin:0 0 5px 0;'>
			标题　&nbsp;&nbsp;<input type='text'>
		</div>
		<div style='overflow-x:hidden;overflow-y:auto;margin:0 0 5px 0;'>
			维名称&nbsp;&nbsp;<select></select>
		</div>
		<div style='overflow-x:hidden;overflow-y:auto;margin:0 0 5px 0;'>
			计算式&nbsp;&nbsp;<select></select>
		</div>
		<div style='overflow-x:hidden;overflow-y:auto;margin:0 0 5px 0;'>
			<div style='float:left;'>分析层和参考层定义</div><div style='float:right;'><img src='images/add.gif' onclick='addLayer(null, null, currSelect);'/></div><div style='clear:both;'></div>
		</div>
		<div style='height:120;overflow-x:hidden;overflow-y:auto;margin:0 0 5px 0;'>
			<table id='layerTable' style='border-collapse:collapse;width:100%;font-size:12px;border:1px solid #ddd;' cellspacing='0' cellpadding='0'>
				<tr height='25px'><th width='100px'>分析层</th><th width='100px'>跨度层</th><th width='33px'>操作</th></tr>
			</table>
		</div>
		<center>
			<button dojoType='dijit.form.Button' onclick='submitLayers();' style='font-size:12px'>确定</button>&nbsp;&nbsp;
			<button dojoType='dijit.form.Button' onclick='$("#layerDialog").dialog("close");' style='font-size:12px'>取消</button>
		</center>
	</div>

</div>

<table style="font-size:12px" cellspacing=15>
	<tr>
		<td valign='top'>
			<div style='width:100%;height:100%;border-bottom:0;' class='border1'>
				<div style='float:left;margin:8 0 0 5;height:20;'>分析</div>
				<div style='float:right;margin:4px 4px 0 0;'><input style='background-image:url("<%=cp %>/dm/images/but_over_32.gif");height:21px;width:32px;background-repeat:no-repeat;' type='button' value='增加' onclick='addRow();'></div>
			</div>
			<div style='clear:both;' class='header_bg2'>
				<table id='H_table' style='border-collapse:collapse;font-size:12px;' class='row_bg2' border=1 borderColor="#9FC1DB" cellspacing=0 cellpadding=0>
					<tr height=24 align=center style='background-image:url("<%=cp %>/dm/images/olap_head_bg.png");'>
						<td width='60px'>标题</td>
						<td width='60px'>维</td>
						<td width='120px'>测度</td>
						<td colspan='2' width='210px'>计算式</td>
						<td width='45px'>定义层</td>
						<td width='35px'>删除</td>
					</tr>
					<!-- 
					<tr height=24>
						<td><input type='text' style='width:100%;border:0px'></td>
						<td><select style='width:100%;'><option>维</option></select></td>
						<td><select style='width:100%;'><option>测度</option></select></td>
						<td><select style='width:100%;'><option>同比</option><option>占比</option><option>累计</option><option>排名</option></select></td>
						<td align='center'><input type='checkbox'></td>
						<td><button onclick='' class='border1' style='width:100%;height:90%;background-color:#EEF1F6;margin:1;background-image:url("<%=cp %>/dm/images/m_slice.gif");background-repeat:no-repeat;background-position:center center;'>&nbsp;</button></td>
						<td><button onclick='' class='border1' style='width:100%;height:90%;background-color:#EEF1F6;margin:1;background-image:url("<%=cp %>/dm/images/m_pmtdelete.gif");background-position:center center;'>&nbsp;</button></td>
					</tr>
					-->
				</table>
			</div>
		</td>
	</tr>
</table>
<div style='padding:0 0 0 14;'>
	<input type='button' onmouseover='this.style.cursor="hand"' style='background-image:url("<%=cp%>/dm/images/olap_phg_submit.gif");border:0px;width:160;height:23px;' onclick="submitAnalyzes();" value='完成设置，打开交叉分析'>
</div>
</body>
</html>

<%
}catch(Exception e){
	e.printStackTrace();
}
%>
