<%@ page contentType="text/html;charset=GBK" %>
<%@ page import="com.raq.web.view.tag.*" %>
<%@ page import="com.raq.web.view.olap.*" %>
<%@ page import="com.raq.web.view.*" %>
<%@ page import="com.raq.web.view.web.*" %>
<%@ page import="com.raq.olap.model.*" %>
<%@ page import="com.raq.ide.common.*" %>
<%@ page import="com.raq.dm.*" %>
<%@ page import="java.util.*" %>

<%
String cp = request.getContextPath();

String olapId = request.getParameter("olapId");
CubeModel cm = (CubeModel)session.getAttribute(olapId);
BaseConfig cmc = cm.getConfig();
DimensionDefine dds[] = cmc.getUsedDims();
boolean isWindow = !("0".equals(request.getParameter("window")));
try{
%>

<html>
<head>
<title>维层隐藏</title>
<link rel="stylesheet" href="<%=cp%>/dm/css/style.css" type="text/css"/>
<script type='text/javascript' src='<%=cp %>/dm/jsroot/jquery/jquery.js'></script>
<script type='text/javascript' src='<%=cp %>/dm/jsroot/jquery/jquery.ui.all.js'></script>
<script type='text/javascript' src='<%=cp %>/dm/jsroot/jquery/jquery.layout.js'></script>
<script type='text/javascript' src='<%=cp %>/dm/jsroot/jquery/jquery.blockUI.js'></script>
<script type='text/javascript' src='<%=cp%>/DMServlet?action=<%=DMServlet.ACTION_READJS%>&file=%2Fcom%2Fraq%2Fweb%2Fview%2Fcommon.js'></script>
<script>
$(document).ready(function(){
	$("#G_revolve_div").dialog({close: function(event, ui) { setTimeout(function(){document.body.style.overflow='auto';},10); },autoOpen:false, width:200, maxWidth:200, minWidth:200, modal: true, overlay: { opacity: 0.1, background: "black" }});
});

var status = 0; // 0:不需要刷新;   1:只刷新右侧内容;    2:全部刷新;

var revolveNode;
function revolve(node) {
	revolveNode = getFirstChild(node.parentNode.parentNode);
	node = revolveNode;
	
	srcG = node.innerHTML;
	var fs = node.getAttribute('fields').split(";");
	var s = '';
	for (var i=0; i<fs.length; i++) {
		var tmp = fs[i].split(",");
		//s += "<div style='margin:2px;' class='border1'><div style='float:left'><input" + (tmp[1]==1?" checked":"") + " type='checkbox' value='" + tmp[0] + "'>" + tmp[0] + "</div><div style='float:right'><img onclick='shiftField(this, false);' src='<%=cp %>/dm/images/m_shiftdown.gif'></img>&nbsp;<img onclick='shiftField(this, true);' src='<%=cp %>/dm/images/m_shiftup.gif'></img></div><div style='clear:both'></div></div>";
		s += "<div style='margin:2px;' class='border1'><div style='float:left'><input" + (tmp[1]==1?" checked":"") + " type='checkbox' value='" + tmp[0] + "'>" + tmp[0] + "</div><div style='clear:both'></div></div>";
	}
	$('#G_revolve_fields')[0].innerHTML = s;
	<%if(isWindow){%>document.body.style.overflow='hidden';<%}%>
	$('#G_revolve_div').dialog('open');
}

function shiftField(node, isUp) {
	node = node.parentNode.parentNode;
	var p = node.parentNode;
	var pChilds = getChildNodes(p);
	for (var i=0; i<pChilds.length; i++){
		var tmp = pChilds[i];
		if (node == tmp) {
			if (isUp && i > 0) {
				tmp = pChilds[i-1]
				p.removeChild(node);
				p.insertBefore(node, tmp);
				break;
			} else if(!isUp && i != pChilds.length-1) {
				if (i == pChilds.length-2){
					p.removeChild(node);
					p.appendChild(node);
				} else {
					node = pChilds[i];
					p.removeChild(node);
					tmp = pChilds[i+1];
					p.insertBefore(node, tmp);
				}
				break;
			}
		}
	}
}
function revolveSubmit() {
	var node = $('#G_revolve_fields')[0];
	var fields = '';
	var childs = getChildNodes(node);
	for (var i=0; i<childs.length; i++) {
		var child = getFirstChild(getFirstChild(childs[i]));
		if (fields != '') fields += ";";
		fields += child.value + "," + (child.checked?1:0);
	} 
	
	if (revolveNode.getAttribute('fields') != fields) {
		status = 2;
		revolveNode.setAttribute('fields', fields);
	}
	
	$('#G_revolve_div').dialog('close');
}

function submitDims(){
	var fields = '';
	var rows = $("#H_table")[0].rows;
	for (var i=1; i<rows.length; i++) {
		var row = rows[i];
		if (i > 1) {
			fields += '_';
		}
		fields += getFirstChild(row).getAttribute('fields');
	}

	$("#ajaxSubmitNode").load("<%=cp%>/DMServletAjax?d=" + new Date().getTime(), {action:<%=DMServlet.ACTION_OLAPDIMENSION%>,fields:fields,olapId:'<%=olapId%>'}, function(){opener.location.reload();window.close();});
}
</script>
</head>
<body style="font-size:12px;overflow:hidden;margin:0px;" class='page_bg1'<%if(isWindow){%> onunload='try{opener.top.unBlockUI();opener.top.isOpen4PHG=false;opener.top.focus();}catch(e){}'<%}%>>

<div style='width:100%;height:100%;overflow:hidden;'>

<div id='ajaxSubmitNode' style='display:none'></div>
<div style='display:none'>
	<div id='G_revolve_div' title='设置显隐' style='font-size:12px;'>
		<div id='G_revolve_fields'>
			<!-- 
			<div style='margin:2px;border:1px #93bee2 solid'>
				<div style='float:left'><input checked type='checkbox' value='22'>22</div>
				<div style='float:right'><img onclick='shiftField(this, false);' src='<%=cp %>/dm/images/m_shiftdown.gif'></img>&nbsp;<img onclick='shiftField(this, true);' src='<%=cp %>/dm/images/m_shiftup.gif'></img></div>
				<div style='clear:both'></div>
			</div>
			-->
		</div>
		<br>
		<div style='float:right;'>
			<input type='button' onmouseover='this.style.cursor="hand"' style='background-image:url("<%=cp%>/dm/images/but_back_2.png");border:0px;width:51;height:22px;' onclick="revolveSubmit();" value='确定'>&nbsp;
			<input type='button' onmouseover='this.style.cursor="hand"' style='background-image:url("<%=cp%>/dm/images/but_back_2.png");border:0px;width:51;height:22px;' onclick="$('#G_revolve_div').dialog('close');" value='取消'>
		</div>
	</div>
</div>
<div style='margin:10px;height:240px;overflow:auto;'>
<table style="font-size:12px;">
	<tr>
		<td valign='top'>
			<div class='header_bg2'>
				<div style='clear:both;' class='header_bg2'>
					<table id='H_table' style='border-collapse:collapse;font-size:12px;' class='row_bg2' border=1 borderColor="#9FC1DB" cellspacing=0 cellpadding=0>
						<tr height='23px' align=center style='background-image:url("<%=cp %>/dm/images/tableHeader.gif");'>
							<td width='285px'>维名称</td>
							<td width='35px'>显隐</td>
							<td style='display:none' width='35px'>选出</td>
						</tr>
						<%
						for (int i=0; i<dds.length; i++) {
							DimensionDefine dd = dds[i];
							String ls = null;
		
							Series h = dd.getOriginalHSeries();
							Section allCols = new Section(h.getLevelInfo());
							
							PivotLayer layers[] = dd.getOrderedPivotLayers();
							if (layers == null) {
								for (int j = 0; j < allCols.size(); j++) {
									if (ls == null) ls = allCols.get(j) + "," + 1;
									else ls += ";" + allCols.get(j) + "," + 1;
								}
							} else {
								for (int j = 0; j < layers.length; j++) {
									if (ls == null) ls = layers[j].getName() + "," + (layers[j].isDisplay()?1:0);
									else ls += ";" + layers[j].getName() + "," + (layers[j].isDisplay()?1:0);
									if (layers[j].getName().equals(dd.getBottom())) break;
								}
	//							for (int j = 0; j < allCols.size(); j++) {
	//								if (ls == null) ls = allCols.get(j) + "," + 0;
	//								else ls += ";" + allCols.get(j) + "," + 0;
	//							}
							}
							//System.out.println(ls);
							String tmpName = dd.getColName();
						%>
							<tr height=25>
								<td style='border-right:0px;' fields='<%=ls%>'><%=tmpName%></td>
								<td style='border-left:0px;border-right:0px;' align='center'><button onclick='revolve(this);' class='border1' style='background-color:#EEF1F6;margin:1;width:100%;height:90%;background-image:url("<%=cp %>/dm/images/m_pmtrvs.gif");background-position:center center;'>&nbsp;</button></td>
								<td style='display:none;border-left:0px;' align='center'><input<%=dd.isUsed()?" checked":""%> type='checkbox'></td>
							</tr>
						<%}%>
					</table>
				</div>
			</div>
		</td>
	</tr>
</table>
</div>

<div style='clear:both;border-bottom:1px solid #CEE2F9;margin:0 0 1px 0;padding:2px 0 0 0;font-size:1px;'></div>
<div style='height:50px;padding: 6px 0 3px 225px;background-color:#CEE2F9;'>
	<input type='button' onmouseover='this.style.cursor="hand"' style='background-image:url("<%=cp%>/dm/images/but_back_2.png");border:0px;width:51;height:22px;' onclick="submitDims();" value='保存'>
	<input type='button' onmouseover='this.style.cursor="hand"' style='background-image:url("<%=cp%>/dm/images/but_back_2.png");border:0px;width:51;height:22px;' onclick="window.close();" value='取消'>
</div>

</div>

</body>
</html>

<%
}catch(Exception e){
	e.printStackTrace();
}
%>
