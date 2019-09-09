<%@ page contentType="text/html;charset=GBK" %>
<%@ page import="com.raq.olap.model.*" %>
<%@ page import="com.raq.olap.chart.*" %>
<%@ page import="com.raq.ide.chart.edit.*" %>
<%@ page import="com.raq.ide.chart.control.*" %>
<%@ page import="com.raq.ide.chart.report4.*" %>
<%@ page import="com.raq.web.view.*" %>
<%@ page import="com.raq.web.view.olap.*" %>
<%@ page import="com.raq.ide.common.*" %>
<%@ page import="java.util.*" %>

<%
try{

String cp = request.getContextPath();
String olapId = request.getParameter("olapId");
CubeModel model = (CubeModel)session.getAttribute(olapId);
BaseConfig conf = model.getConfig();

String chartName = request.getParameter("chartName");
OlapChart4Report4 c = null;
if (chartName != null) {
	Map charts = conf.getCharts();
	if (charts != null) {
		Iterator iter = charts.keySet().iterator();
		while (iter.hasNext()) {
	String name = iter.next().toString();
	if (name.equals(chartName)) {
		c = (OlapChart4Report4)charts.get(name);
	}
		}
	}
}
String typeName = null;
String stat = "";
String cateInfo = null;
String enumInfo = null;
if (c != null) {
	typeName = c.getType();
	stat = c.getCedu();
	
	CubeGraphDimension cgd = c.getCate();
	cateInfo = cgd.getDimName() + "<_>" + (cgd.getRangeValue()==0?"":cgd.getRangeValue()+"") + "<_>" + (cgd.getRangeName()==null?"":cgd.getRangeName());
	
	cgd = c.getSeries();
	enumInfo = cgd.getDimName() + "<_>" + (cgd.getRangeValue()==0?"":cgd.getRangeValue()+"") + "<_>" + (cgd.getRangeName()==null?"":cgd.getRangeName());
}

String[] types = null;
if (BaseConfig.CHART_REPORT4) types = Report4GraphConfig.getTypes();
else types = OlapChartConfigs.getChartNames();
int selectIndex = -1;
for (int i=0; i<types.length; i++) {
	if (types[i].equals(typeName)) {
		selectIndex = i;
	}
}
%>

<html>
<head>
<title>交叉分析统计图预览</title>
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

/**
 * @param field
 * @param operType 
 * 		1:成绩 		-> ~.sum(成绩)     
 * 		2:成绩 		-> 成绩(求和)      
 * 		3:~.sum(成绩)-> 成绩     
 * 		4:成绩(求和) 	-> 成绩
 * 		5:~.sum(成绩)-> sum
 * 		6:成绩(求和) 	-> sum
 * 		7:~.sum(成绩)-> 成绩(求和)
 */
function getFieldInfo(field, stat, operType) {
	if (operType == 1) {
		return "~." + stat + "(" + field + ")";
	}
	if (operType == 2) {
		if ("sum" == stat) stat = "求和";
		if ("max" == stat) stat = "最大";
		if ("min" == stat) stat = "最小";
		if ("avg" == stat) stat = "平均";
		if ("count" == stat) stat = "计数";
		
		return field + "(" + stat + ")";
	}
	if (operType == 3) {
		return field.substring(field.indexOf("(") + 1, field.length - 1);
	}
	if (operType == 4) {
		return field.substring(0, field.indexOf("("));
	}
	if (operType == 5) {
		return field.substring(2, field.indexOf("("));
	}
	if (operType == 6) {
		if (field.indexOf("求和") >= 0) return "sum";
		if (field.indexOf("最大") >= 0) return "max";
		if (field.indexOf("最小") >= 0) return "min";
		if (field.indexOf("平均") >= 0) return "avg";
		if (field.indexOf("计数") >= 0) return "count";
	}
	if (operType == 7) {
		return getFieldInfo(getFieldInfo(field, null, 3), getFieldInfo(field, null, 5), 2);
	}
	if (operType == 8) {
		return getFieldInfo(getFieldInfo(field, null, 3), getFieldInfo(field, null, 5), 9);
	}
	if (operType == 9) {
		if ("sum" == stat) stat = "求和";
		if ("max" == stat) stat = "最大";
		if ("min" == stat) stat = "最小";
		if ("avg" == stat) stat = "平均";
		if ("count" == stat) stat = "计数";
		
		return field + "_" + stat;
	}
	return field;
}

function saveChart(){
	var chartName = $$("chartName").value;
	if (chartName == '') {
		alert("统计图名称不能为空");
		return;
	}
	if (!cateBak) {
		alert("请选择分类");
		return;
	} 
	if (!enumBak) {
		alert("请选择系列");
		return;
	}

	jQuery.post("<%=cp%>/DMServletAjax?d=" + new Date().getTime(), {olapId:'<%=olapId%>',action:<%=DMServlet.ACTION_OLAP_CHART%>,chartAction:"config",oldName:"<%=chartName==null?"":chartName%>",newName:chartName,cates:cateBak.getAttribute("info"),enums:enumBak.getAttribute("info"),cedu:$$('cedu').value,typeName:$$('chart').value,generateChart:1}, function(data){var div=$$("chartDiv");div.innerHTML=data;}, "txt");
}

function t_ic( obj, subdiv ) {  //tree_iconClick
   	var nodeValue = obj.attributes.getNamedItem( "nv" );
   	var oldnodevalue = nodeValue.value;
   	if( oldnodevalue == "0" || oldnodevalue == "2" )
      	subdiv.style.display = "";
   	if( oldnodevalue == "0" ) {
      	nodeValue.value = "1";
      	obj.src = obj.src.substring( 0, obj.src.indexOf( "plus.gif" ) ) + "minus.gif";
   	}
   	if( oldnodevalue == "2" ) {
      	nodeValue.value = "3";
      	obj.src = obj.src.substring( 0, obj.src.indexOf( "lastplus.gif" ) ) + "lastminus.gif";
   	}
   	if( oldnodevalue == "1" || oldnodevalue == "3" )
      	subdiv.style.display = "none";
   	if( oldnodevalue == "1" ) {
      	nodeValue.value = "0";
      	obj.src = obj.src.substring( 0, obj.src.indexOf( "minus.gif" ) ) + "plus.gif";
   	}
   	if( oldnodevalue == "3" ) {
      	nodeValue.value = "2";
      	obj.src = obj.src.substring( 0, obj.src.indexOf( "lastminus.gif" ) ) + "lastplus.gif";
   	}
}

var cateBak, enumBak;
function changeInfo(node, showChart) {
	var info = node.getAttribute("info");
	if (info == '<_><_>') return;
	var id = node.id;
	if (id.indexOf("cate") >= 0) {
		if (enumBak) {
			var dim1 = enumBak.getAttribute("info").substring(0, enumBak.getAttribute("info").indexOf("<_>"));
			var dim2 = node.getAttribute("info").substring(0, node.getAttribute("info").indexOf("<_>"));
			if (dim1 == dim2) return;
		}
		if (cateBak) cateBak.style.backgroundColor = "";
		node.style.backgroundColor = "#9DD3FF";
		cateBak = node;
		if (showChart) saveChart();
	} else {
		if (cateBak) {
			var dim1 = cateBak.getAttribute("info").substring(0, cateBak.getAttribute("info").indexOf("<_>"));
			var dim2 = node.getAttribute("info").substring(0, node.getAttribute("info").indexOf("<_>"));
			if (dim1 == dim2) return;
		}
		if (enumBak) enumBak.style.backgroundColor = "";
		node.style.backgroundColor = "#9DD3FF";
		enumBak = node;
		if (showChart) saveChart();
	}
}

function initTrees(){
	<%if(cateInfo != null){%>dealTree($$("cateTree"), "<%=cateInfo%>");<%}%>
	<%if(enumInfo != null){%>dealTree($$("enumTree"), "<%=enumInfo%>");<%}%>
}
function dealTree(div, info) {
	var trs = div.getElementsByTagName("TR");
	var selectTD;
	for (var i=0; i<trs.length; i++) {
		selectTD = trs[i].lastChild;
		if (selectTD.getAttribute("info") == info) break;
	}
	changeInfo(selectTD, false);
	var parentDiv = selectTD;
	while (parentDiv != div) {
		if (parentDiv.tagName == "DIV" && parentDiv.id && parentDiv.id.indexOf("_div_") == 0) {
			parentDiv.style.display = 'block';
		}
		parentDiv = parentDiv.parentNode;
	}
	selectTD.scrollIntoView(true);
}

function link(url){
	jQuery.post(url, {olapId:'<%=olapId%>'}, function(data){var div=$$("chartDiv");div.innerHTML=data;}, "txt");
}

</script>
</head>
<body onload='initTrees();' style="font-size:12px;overflow:hidden;margin:0px;padding:0px;" class='page_bg1' onunload='try{opener.unBlockUI();opener.isOpen4Chart=false;opener.focus();}catch(e){}'>
<div id='ajaxSubmitNode' style='display:none'></div>
<div style='margin:10px 8px 10px 10px;float:left;border:0px solid #CCCCCC;width:650px;height:630px;overflow:hidden;' id='chartDiv'>
	<%=OlapChartAction.generateHtml(request, olapId, chartName)%>
</div>

<div style='float:right;margin:10px 2px 0 0;'>
	<div style='width:240px;'>
		<div style='width:230px;float:left;display:none;'>
			统计图名称
			<input type='text' style='width:159px;' id='chartName' value='<%=chartName==null?"":chartName %>'>
		</div>
	</div>
	
	<div style='width:246px;'>
		<div id='cateTree' style='background-color:white;border:1px solid #7F9DB9;width:246px;height:263px;margin:0 10px 0 0;overflow:auto;'>
			<%=new SeriesSliceTree(conf, true, cp, request).generateHtml() %>
		</div>
		<div id='enumTree' style='background-color:white;border:1px solid #7F9DB9;width:246px;height:263px;overflow:auto;margin:20px 0 0 0;'>
			<%=new SeriesSliceTree(conf, false, cp, request).generateHtml() %>
		</div>
	</div>
	
	<div style='width:240px;margin:20 0 0 0;'>
		<div>
			统计测度　
			<select style='width:130px;' id='cedu' onchange='saveChart();'>
			<%
			Vector v = ChartDialog4Olap.getCeduFields(conf);
			for (int i=0; i<v.size(); i++) {
				%>
				<option<%=v.get(i).toString().equals(stat)?" selected":"" %> value='<%=v.get(i).toString() %>'><%=v.get(i).toString() %></option>
				<%
			}
			%>
			</select>
		</div>
		<div style='margin:20px 0 0 0;'>
			统计图类型
			<select style='width:130px;' id='chart' onchange='saveChart();'>
				<%if (selectIndex == -1 && typeName != null){ %>
				<option value='<%=typeName%>'><%=typeName%></option>
				<%}
				for (int i=0; i<types.length; i++) {
				%>
				<option <%=(selectIndex>=0 && selectIndex==i)?"selected ":""%>value='<%=types[i]%>'><%=types[i]%></option>
				<%
				}
				%>
			</select>
		</div>
	</div>
</div>
</body>
</html>

<%
}catch(Exception e){
	e.printStackTrace();
}
%>
