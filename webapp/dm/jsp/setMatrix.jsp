<%@ page contentType="text/html;charset=GBK" %>
<%@ page import="com.raq.web.view.*" %>
<%@ page import="com.raq.web.view.web.*" %>
<%@ page import="com.raq.web.view.olap.*" %>
<%@ page import="com.raq.dm.*" %>
<%@ page import="com.raq.olap.mtx.*" %>
<%@ page import="com.raq.olap.model.*" %>
<%@ page import="com.raq.common.*" %>
<%@ page import="java.util.*" %>

<%
String cp = request.getContextPath();

HashMap infos = OlapMatrixAction.dealInfos(request);
Context ctx = SessionContext.getContext(session);
String olapId = request.getParameter("olapId");
String mtx = Unescape.unescape(WEBUtil.getRequestParameter(request, "mtx"));
if (mtx == null) {
	mtx = ((CubeModel)session.getAttribute(olapId)).getConfig().getMtxFile();
} 
try{
%>

<html>
<head>
<meta http-equiv=Content-Type content="text/html;charset=gb2312">
<title><%=olapId == null?"新建SOLAP-":"" %>设置分析矩阵</title>
<link rel="stylesheet" href="<%=cp%>/dm/css/style.css" type="text/css"/>
<script type='text/javascript' src='<%=cp %>/dm/jsroot/jquery/jquery.js'></script>
<script type='text/javascript' src='<%=cp %>/dm/jsroot/jquery/jquery.ui.all.js'></script>
<script type='text/javascript' src='<%=cp %>/dm/jsroot/jquery/jquery.layout.js'></script>
<script type='text/javascript' src='<%=cp %>/dm/jsroot/jquery/jquery.blockUI.js'></script>
<script type='text/javascript' src='<%=cp%>/DMServlet?action=<%=DMServlet.ACTION_READJS%>&file=%2Fcom%2Fraq%2Fweb%2Fview%2Fcommon.js'></script>

<script type='text/javascript' src='<%=cp%>/dm/jsroot/jquery/jsTree/lib/jquery.cookie.js'></script>
<script type='text/javascript' src='<%=cp%>/dm/jsroot/jquery/jsTree/lib/jquery.hotkeys.js'></script>
<script type='text/javascript' src='<%=cp%>/dm/jsroot/jquery/jsTree/lib/jquery.metadata.js'></script>
<script type='text/javascript' src='<%=cp%>/dm/jsroot/jquery/jsTree/jquery.tree.js'></script>
<script type='text/javascript' src='<%=cp%>/dm/jsroot/jquery/jsTree/plugins/jquery.tree.checkbox.js'></script>
<script type='text/javascript' src='<%=cp%>/dm/jsroot/jquery/jsTree/plugins/jquery.tree.contextmenu.js'></script>
<script type='text/javascript' src='<%=cp%>/dm/jsroot/jquery/jsTree/plugins/jquery.tree.cookie.js'></script>
<script type='text/javascript' src='<%=cp%>/dm/jsroot/jquery/jsTree/plugins/jquery.tree.hotkeys.js'></script>
<script type='text/javascript' src='<%=cp%>/dm/jsroot/jquery/jsTree/plugins/jquery.tree.metadata.js'></script>
<script type='text/javascript' src='<%=cp%>/dm/jsroot/jquery/jsTree/plugins/jquery.tree.themeroller.js'></script>
<script>
var moving=false;
var oddCheck = 0;
$(document).ready(function(){
	$("#layerDialog").dialog({close: function(event, ui) { $("select").each(function(){this.style.visibility='visible';document.body.style.overflow='auto';}); },autoOpen:false, width:310, maxWidth:310, minWidth:310, modal: true, overlay: { opacity: 0.1, background: "black" }});

	$("#mtxMeasureTree").tree({
		ui : {
			theme_name : "checkbox"
		}
		,plugins : { 
			checkbox : {
			}
		}
		,callback : {
			check : function(RULE,NODE,VALUE,TREE_OBJ) {
				oddCheck++;
				if (oddCheck%2 == 1) {
					return;
				}
				var hasChecked = $(NODE).children("a").hasClass("checked");
				if (hasChecked) setTimeout(function(){jQuery.tree.plugins.checkbox.uncheck(NODE);}, 10);
				else setTimeout(function(){jQuery.tree.plugins.checkbox.check(NODE);}, 10);
				return VALUE;
			},
			check_move : function(NODE, REF_NODE, TYPE, TREE_OBJ) {
				return false;
			}
		}
	});
	
	$("#mtxSliceTree").tree({
		ui : {
			theme_name : "checkbox"
		}
		,plugins : { 
			checkbox : {
			}
		}
		,callback : {
			check : function(RULE,NODE,VALUE,TREE_OBJ) {
				oddCheck++;
				if (oddCheck%2 == 1) {
					return;
				}
				var hasChecked = $(NODE).children("a").hasClass("checked");
				if (hasChecked) setTimeout(function(){jQuery.tree.plugins.checkbox.uncheck(NODE);}, 10);
				else setTimeout(function(){jQuery.tree.plugins.checkbox.check(NODE);}, 10);
				return VALUE;
			},
			check_move : function(NODE, REF_NODE, TYPE, TREE_OBJ) {
				return false;
			}
		}
	});
	
	$$("mtxMeasureTree").style.height = 395 - $$("H_table").rows.length * 23 + 'px';
	$$("mtxSliceTree").style.height = 395 - $$("H_table").rows.length * 23 + 'px';

});

function checkAll(check){
	var rows = $$("H_table").rows;
	for (var i=1; i<rows.length; i++) {
		rows[i].cells[1].childNodes[0].checked = check;
	}
}

function submitMtx() {
	var dimsInfo = "";
	var measures = "";
	var slice = "";
	
	var rows = $$('H_table').rows;
	var checkCount = 0;
	var tops = new Array();
	for (var i=1; i<rows.length; i++) {
		var cells = rows[i].cells;
		if (i > 1) dimsInfo += ";";
		dimsInfo += cells[0].innerHTML + ":";
		checkCount += (cells[1].childNodes[0].checked?1:0);
		dimsInfo += (cells[1].childNodes[0].checked?1:0) + ":";
		var top = cells[2].childNodes[0].value;
		if (top.split("_")[0] > cells[3].childNodes[0].selectedIndex + 1) {
			alert("维【" + cells[0].innerHTML + "】的底层不能高于顶点所在的层！");
			return;
		}
		dimsInfo += top + ":";
		tops[i-1] = top;
		var bottom = cells[3].childNodes[0].value;
		dimsInfo += bottom;
	}
	if (checkCount == 0) {
		alert("至少要选择一个维度！");
		return;
	}

	var sliceTree = $.tree.reference("#mtxSliceTree");
	var root = sliceTree.children(-1)[0];
	var dims = sliceTree.children(root);
	for (var i=0; i<dims.length; i++) {
		var arr = new Array;
		arr[0] = dims[i];
		getAllChildren(sliceTree, dims[i], arr);
		for (var j=0; j<arr.length; j++) {
			var text = sliceTree.get_text(arr[j]);
			var pos = $(arr[j]).attr('pos');
			if (tops[i] == pos) {
				if ($(arr[j]).children("a").hasClass("unchecked")) {
					var dimName = $(dims[i]).attr('dim');
					alert( "【"+ dimName + "】维顶点下未选择数据!" );
					return;
				}
			}
		}
		dims[i] = arr;
	}
	
	var sliceInfos = '';
	for (var i=0; i<dims.length; i++) {
		var arr = dims[i];
		for (var j=0; j<arr.length; j++) {
			var text = sliceTree.get_text(arr[j]);
			var status = 0;
			if ($(arr[j]).children("a").hasClass("checked")) {
				status = 1;
			} else if ($(arr[j]).children("a").hasClass("undetermined")) {
				status = 2;
			}
			if (sliceInfos != '') sliceInfos += ';';
			sliceInfos += $(arr[j]).attr('id').substring(5) + "," + status;
		}
	}
	
	var measTree = $.tree.reference("#mtxMeasureTree");
	root = measTree.children(-1)[0];
	var arr = new Array();
	getAllChildren(measTree, root, arr);
	var measInfos = '';
	for (var i=0; i<arr.length; i++) {
		if (measTree.children(arr[i]) == null || measTree.children(arr[i]).length == 0) {
			if (measInfos == '') measInfos = $(arr[i]).children("a").hasClass("checked")?"1":"0"; 
			else measInfos += "," + ($(arr[i]).children("a").hasClass("checked")?1:0); 
		}
	}
	if (measInfos.indexOf("1") == -1) {
		alert( "至少要选择一个测度!" );
		return;
	} 
	
	var olapId = "<%=olapId==null?"olap"+new Date().getTime():olapId %>";
//	alert(dims);
	$("#ajaxSubmitNode").load("<%=cp%>/DMServletAjax?d=" + new Date().getTime(), {olapId:olapId,action:<%=DMServlet.ACTION_OLAP_MTX%>,dims:dimsInfo,meas:measInfos,slice:sliceInfos,mtx:'<%=mtx %>'}, function(){
		opener.showOlap(olapId);
		window.close();
	});
}

function getAllChildren(tree, node, arr) {
	var subs = tree.children(node);
	for (var i=0; i<subs.length; i++) {
		arr[arr.length] = subs[i];
		getAllChildren(tree, subs[i], arr);
	}
}

</script>
</head>
<body style="font-size:12px;overflow:auto;margin:0px;" class='page_bg1' onload='' onunload=''>
<div id='ajaxSubmitNode' style='display:none'></div>
<div style='margin:10px;'>
	<table id='H_table' style='border-collapse:collapse;font-size:12px;' class='row_bg2' border=1 borderColor="#9FC1DB" cellspacing=0 cellpadding=0>
		<tr height='23px' align=center style='background-image:url("<%=cp %>/dm/images/tableHeader.gif");'>
			<td width='140px'>维名称</td>
			<td width='80px'><input onclick='checkAll(this.checked);' type='checkbox'>参与分析</td>
			<td width='200px'>顶点</td>
			<td width='80px'>底层</td>
		</tr>
		<%=infos.get("table").toString() %>
<!-- 
		<tr height='23px'>
			<td>地区</td>
			<td align=center><input type='checkbox'></td>
			<td><select style='width:100%;'><option>维全部</option><option>中国</option><option>美国</option></select></td>
			<td><select style='width:100%;'><option>国家</option><option>省份</option><option>城市</option></select></td>
		</tr>
 -->
	</table>
</div>

<div class='border1' style='width:241px;margin:0px 10px 8px 10px; overflow:auto;float:left;background-color:white;' id='mtxMeasureTree'>
	<%=infos.get("measureTree") %>
</div>

<div class='border1' style='width:241px;margin:0px 10px 8px 0px; overflow:auto;float:right;background-color:white;' id='mtxSliceTree'>
	<%=infos.get("sliceTree") %>
</div>

<div style='clear:both;border-bottom:1px solid #CEE2F9;margin:0 0 1px 0;padding:2px 0 0 0;font-size:1px;'></div>
<div style='height:30px;padding: 6px 0 3px 395px;background-color:#CEE2F9;'>
	<input type='button' onmouseover='this.style.cursor="hand"' style='background-image:url("<%=cp%>/dm/images/but_back_2.png");border:0px;width:51;height:22px;' onclick="submitMtx();" value='<%=olapId == null?"新建":"保存" %>'>
	<input type='button' onmouseover='this.style.cursor="hand"' style='background-image:url("<%=cp%>/dm/images/but_back_2.png");border:0px;width:51;height:22px;' onclick="window.close();" value='取消'>
</div>
</body>
</html>

<%
}catch(Exception e){
	e.printStackTrace();
}
%>
