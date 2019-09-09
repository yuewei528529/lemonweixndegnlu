<%@ page  contentType="text/html; charset=GBK"%>
<%@ page import="com.raq.web.view.*" %>
<%
String cp = request.getContextPath();
%>
<html>
<head>
<link rel="stylesheet" href="<%=cp%>/dm/css/style.css" type="text/css"/>
<script type="text/javascript" src="<%=cp%>/dm/jsroot/jquery/jquery.js"></script>
<script type="text/javascript" src="<%=cp%>/dm/jsroot/jquery/jquery.ui.all.js"></script>
<script type="text/javascript" src="<%=cp%>/dm/jsroot/jquery/jquery.layout.js"></script>
<script type="text/javascript" src="<%=cp%>/dm/jsroot/jquery/jquery.blockUI.js"></script>
<script type='text/javascript' src='<%=cp%>/DMServlet?action=<%=DMServlet.ACTION_READJS%>&file=%2Fcom%2Fraq%2Fweb%2Fview%2Fcommon.js'></script>
<style>
#grid-div th{
	height:25px;padding:0 3 0 3;align:center;background-image:url('<%=cp%>/dm/images/listhead.gif');background-color:#EDEDED;font-size:12px;
}
#grid-div td{
	height:20px;padding:0 3 0 3;font-size:12px;
}
.tr_header {
	text-align:center; font-weight: bold; height:21px;
}
</style>
<script type="text/javascript">
	var hiddenTable = true;
	$(document).ready(function(){
		$("#selectFront,#selectAfter").mouseover(function(){
			$("#selectImg")[0].src = '<%=cp%>/dm/images/select_hover.png';
		}).mouseout(function(){
			$("#selectImg")[0].src = '<%=cp%>/dm/images/select.png';
		}).mousedown(function(){
			$("#selectImg")[0].src = '<%=cp%>/dm/images/select_down.png';
		}).mouseup(function(){
			//alert(3);
			hiddenTable = false;
			$("#selectImg")[0].src = '<%=cp%>/dm/images/select.png';
			$("#grid-div").slideToggle();
		});
		
		$().click(function(){
			//alert(2);
			if (hiddenTable) {
				$("#grid-div").slideUp();
			}
			hiddenTable = true;
		});
		
		$(".grid-div-tr").mouseover(function(){
			this.style.backgroundColor='#DDDDDD';
		}).mouseout(function(){
			this.style.backgroundColor='#FFFFFF';
		}).click(function(){
			var childs = getChildNodes(this);
			$("#paramUniqueId")[0].value = childs[0].innerHTML;
			var disp = '| ';
			for (var i=1; i<childs.length; i++) {
				disp += childs[i].innerHTML + ' | ';
			}
			$("#disp")[0].value = disp;
			$("#grid-div").slideUp();
		});
		
		var gridDiv = $("#grid-div");
		if (gridDiv.length > 0) {
			gridDiv = gridDiv[0];
			gridDiv.style.display = 'block';
			var width = getFirstChild(gridDiv).offsetWidth;
			$("#selectFront")[0].style.width = width-18 + 'px';
			$("#disp")[0].style.width = width-26 + 'px';
			$("#disp")[0].disabled = true;
			$("#selectDiv")[0].style.width = width + 'px';
			gridDiv.style.display = 'none';
			
		} 
	});
	function resetParam() {
		var value = "";
		var radio = $('input[@type=radio][@checked]');
		if (radio.length > 0) {
			value = radio[0].value;
		} else {
			var inputs = $("#paramUniqueId");
			if (inputs.length > 0) {
				if (inputs[0].onvalue != null) {
					if (inputs[0].checked) value = inputs[0].onvalue;
					else value = inputs[0].offvalue;
				} else value = inputs[0].value;
			} 
		}
		if ($("#conditionTable").length>0) {
			value = comQuery.genConditions();
		}
		top.blockUI();
		$("#notExistNode").load("<%=cp%>/DMServletAjax?d=" + new Date().getTime(), {action:9,name:'<%=request.getParameter("paramName")%>',value:value,isWhere:$("#conditionTable").length>0}, function(){});
		top.unBlockUI();
	}

	function insertContent(area, str){
	    var tclen = area.value.length;
	    area.focus();
	    if(typeof document.selection != "undefined") {
	        document.selection.createRange().text = str;  
	    } else {
	        area.value = area.value.substr(0,area.selectionStart)+str+area.value.substring(area.selectionStart,tclen);
	    }
	}
</script>
</head>
<body style="height: 100%; width: 100%; margin: 10px; padding: 10px; font-size:13px">
	<div id="notExistNode" style="display:none"></div>
	<%=EditStyleHtml.generateHtml(request, request.getParameter("paramName"))%>
	<div style='clear:both'><br><input style='width:48px;height:25;border:0px;background-image:url("<%=request.getContextPath()%>/dm/images/btn_bg.png")' type=button value=±£´æ onclick="resetParam();"></div>
</body>
</html>
