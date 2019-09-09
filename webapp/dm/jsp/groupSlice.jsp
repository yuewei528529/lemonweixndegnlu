<%@ page contentType="text/html;charset=GBK" %>
<%@ taglib uri="/WEB-INF/runqianDm.tld" prefix="dm" %>
<%@ page import="com.raq.dm.view.olap.*" %>
<html>
<head>
<title>数据集切片</title>
</head>
<body style='margin:0;padding:0;background-image:url("<%=request.getContextPath()%>/dm/images/open_save.gif");background-repeat:no-repeat;font-size:12px' onunload='try{opener.unBlockUI();opener.isOpen4Slice=false;opener.focus();}catch(e){}'>
<%
	String cp = request.getContextPath();

	String name = request.getParameter( "name" );
	String isLayer = request.getParameter( "isLayer" );
	if( isLayer == null ) isLayer = "0";
%>
<div style='margin:45 0 10 0;background-color:#E9F2FC;border-bottom:1 solid #BEBFC1;'>
	<div style='margin: 0 0 10 40;'><br>
		<span style="font-size:12px">产生的层组名&nbsp;&nbsp;</span><input type=text id=newName style="width:80px;height:20">
		<input style='width:48px;height:25;border:0px;background-image:url("<%=request.getContextPath()%>/dm/images/btn_bg.png")' type=button value=确定 onclick="group_slice(<%="1".equals( isLayer )?"true":"false" %>);">
	</div>
</div>
<div style='margin:10;height:350;overflow:auto;'>
<%
	if( isLayer == null ) isLayer = "0";
	GroupSliceTree tree = new GroupSliceTree( name, "1".equals( isLayer ), request );
	out.println( tree.generateHtml() );
%>
</div>

<script language=javascript>
	function sliceSuccess( name ) {
		if (<%="1".equals( isLayer )?"true":"false" %>) {
			opener.insertHRow( name, opener.slice_node.fields );
		} else {
			opener.insertGRow( name, opener.slice_node.fields );
		}
		window.close();
	}
	
	function sliceError( data, ioArgs ) {
		alert( data.message );
	}
</script>
	
</body>
</html>
