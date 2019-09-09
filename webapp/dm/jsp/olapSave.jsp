<%@ page  contentType="text/html; charset=GBK"%>
<%@ page import="com.raq.web.view.olap.OlapSaveUtil" %>
<%@ page import="com.raq.web.view.tag.*" %>
<%@ page import="com.raq.web.view.*" %>
<%@ page import="java.io.*" %>
<% 
String cp = request.getContextPath();

String records = OlapSaveUtil.getFiles(request);
String all[] = records.split(",");
%>

<html>
<%if ("beforeSave".equals(request.getParameter("oper"))){
	if (session.getAttribute(request.getParameter("olapId")) != null) {
%>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="Content-Type" content="text/html; charset=GBK">
	<head>
		<title>保存交叉分析</title>
		<link rel="stylesheet" href="<%=cp%>/dm/css/style.css" type="text/css"/>
		<script language="javascript">
		function checkSave(){
			var newName = document.getElementById("newName").value;
			if (newName.length == 0) {
				alert("名称不能为空！");
				return;
			}
			<%
			for (int i=0; i<all.length; i++) {
				if (all[i].length() > 0) {
				%>	
					if ('<%=all[i]%>' == newName) {
						alert("名称重复了！");
						return;
					}
				<%
				}
			}
			%>			
			window.returnValue=newName;
	      	window.close();
		}
		
		function update(name) {
			if (confirm("确定要覆盖已存在的OLAP文件：" + "\"" + name + "\"？")) {
				window.returnValue=name;
		      	window.close();
			}
		}
		</script>
	</head>
	<body onload='if (window.dialogArguments && window.dialogArguments.indexOf(".maj")>0) document.getElementById("newName").value = window.dialogArguments.replace(".maj", "");' style='margin:0;padding:0;overflow:hidden;font-size:12px'>
		<div style='margin:10px;'><input type="text" id="newName" size=40></div>
		<div style='margin:10px;height:313px;overflow-x:hidden;overflow-y:auto;'>
		<%if (records.length() > 0) { %>
		以下为已存在的文件，选择其中一个可以覆盖保存！<br>
			<%
			for (int i=0; i<all.length; i++) {
				if (all[i].length() > 0) {
				%>	
					<div style='height:16;margin:8px 0 0 0;border-bottom:1px solid #DCF1FF;'>&nbsp;<a onclick="update('<%=all[i]%>');" style="cursor:pointer"><%=all[i]%></a></div>
				<%
				}
			}
			%>			
		<%} %>
		</div>

		<div style='border-bottom:1px solid #CEE2F9;margin:0 0 1px 0;font-size:1px;'></div>
		<div style='height:25px;padding: 6px 0 3px 444px;background-color:#CEE2F9;'>
			<input type='button' onmouseover='this.style.cursor="hand"' style='margin:0 0 0 10px;background-image:url("<%=cp%>/dm/images/but_back_2.png");border:0px;width:51px;height:22px;font-size:12px;' onclick="checkSave();" value='保存'>
		</div>

	</body>

<%
	} else {
%>
	<script language="javascript">
	window.close();
	</script>
<%	
	}
} else if ("save".equals(request.getParameter("oper"))){%>

	<%
		boolean success = OlapSaveUtil.save(request, request.getParameter("name"), request.getParameter("olapId"));
	%>
		<script>alert("保存<%=success?"成功":"失败"%>！");</script>
<%
} else if ("open".equals(request.getParameter("oper"))){%>
	<head>
		<title>打开交叉分析</title>
		<link rel="stylesheet" href="<%=cp%>/dm/css/style.css" type="text/css"/>
		<script language="javascript">
		function openOlap(paramsValue){
	      	window.returnValue=paramsValue;
	      	window.close();
		}
		function remove(name, count) {
			if (confirm("确定要删除记录：\"" + name + "\"")) {
				doRemove(name);	
				var rows = document.getElementById("records").rows;
				for (var i=0; i<rows.length; i++) {
					if (rows[i].id == "row_" + count) {
						document.getElementById("records").deleteRow(i);
						return;
					}
				}
			}
		}

      function doRemove(name) {
		document.getElementById("removeIframe").src = "<%=cp%>/dm/jsp/olapSave.jsp?oper=remove&cub=" + name;
      }
		</script>		
	</head>
	<body style='margin:0;padding:0;overflow:auto;'>
		<%if (records.length() > 0) { %>
		<table id="records" border='1px' cellspacing='0' cellpadding='1px' style="border:1px solid #CCCCCC;font-size:12px;width:100%;border-collapse:collapse;">
			<tr style='height:23px;background-image:url("<%=cp %>/dm/images/tableHeader.gif")'>
				<td style='border:1px solid #CCCCCC;' align='center'>文件名称</td>
				<td style='border:1px solid #CCCCCC;' align='center'>操作</td>
			</tr>
		<%
		int count = 0;
		for (int i=0; i<all.length; i++) {
			if (all[i].length() > 0) {
				count ++;
			%>
			<tr id="row_<%=i%>" height='23px'>
				<td style='border:1px solid #CCCCCC;'>&nbsp;<a onclick="openOlap('<%=all[i] %>')" style="cursor:pointer"><%=all[i] %></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td style='border:1px solid #CCCCCC;'>&nbsp;<a onclick="openOlap('<%=all[i] %>')" style="cursor:pointer;color:#03507B">打开</a>&nbsp;&nbsp;<a onclick="remove('<%=all[i] %>', <%=i%>);" style="cursor:pointer;color:#FF0000;">删除</a></td>
			</tr>
			<%
			}
		}
		%>
		</table>
		<%} else {%>
			<div style='height:150px;background-image:url("<%=cp %>/dm/images/save_open_header.png");background-repeat:repeat-x;'></div>
			<center>
				<table><tr><td><img src='<%=cp %>/dm/images/warn.png'></td>
				<td valign=middle style='font-size:14px;'>没有可打开的文件！</td></tr></table>
			</center>
		<%}%>
		<div style="display:none"><iframe id="removeIframe"></iframe></div>
	</body>
<%} else if ("openFile".equals(request.getParameter("oper"))){%>
	<%
	OlapSaveUtil.open(request, request.getParameter("fileName"), request.getParameter("olapId"), null, false);
	%>
	<script>try{top.afterOpenOlap('<%=request.getParameter("olapId")%>','<%=request.getParameter("fileName")%>.maj');}catch(e){alert('顶层页面缺少afterOpenOlap(olapId)函数!');}</script>
<%} else if ("openCommonFile".equals(request.getParameter("oper"))){%>
	<%
	String fileName = request.getParameter("fileName");
	if (!fileName.endsWith(".maj")) fileName += ".maj";
	OlapSaveUtil.open(request, new File(DMServlet.olapHome + "/" + fileName), request.getParameter("olapId"), null, false);
	%>
	<script>try{top.afterOpenOlap('<%=request.getParameter("olapId")%>','<%=fileName%>');}catch(e){alert('顶层页面缺少afterOpenOlap(olapId)函数!');}</script>
<%} else if ("remove".equals(request.getParameter("oper"))){%>
	<%
		OlapSaveUtil.remove(request, request.getParameter("cub"));
	%>
<%} %>
</html>
