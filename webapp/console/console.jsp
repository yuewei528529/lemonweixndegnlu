<%@ page contentType="text/html;charset=GBK" %>
<%@ page import="com.runqian.serverconfig.*" %>
<%@ page import="java.io.*"%>
<%@ page import="com.runqian.report4.view.ReportConfigManagerImpl" %>
<%@ page import="com.runqian.report4.view.IReportConfigManager" %>

<html>
<head>
<LINK href="style.css" type=text/css rel=stylesheet>
</head>
<body background="../images/mainbg.gif">

<%
	String path = application.getRealPath( "/" );
	File file = new File( path );
	String s = file.getParentFile().getParentFile().getAbsolutePath() + File.separator + "启动报表服务器.bat";
	MemoryConfig mc = new MemoryConfig( s );
	String[] memory = mc.getMemory();
	String appmap = request.getContextPath();
	s = file.getParentFile().getParentFile().getAbsolutePath() + File.separator + "conf" + File.separator + "server.xml";
	ServerXmlConfig sxc = new ServerXmlConfig( s );
	String port = sxc.getPort();
	
	
	IReportConfigManager rcm=ReportConfigManagerImpl.getInstance();
	String configPath=application.getRealPath( "/WEB-INF/reportConfig.xml" );
	String cachedir = "";
	String license = "";
			
	try{
	 rcm.setInputStream(new FileInputStream(configPath));
	 cachedir=rcm.getInitParameter("cachedReportDir");
	 license=rcm.getInitParameter("license");
	}
	catch(Exception e){
		e.printStackTrace();
	}
  rcm.setInputStream(new FileInputStream(configPath));
	
  //WebXmlConfig wxc = new WebXmlConfig( application );
	//String cachedir = wxc.getCachDir();
	//String license = wxc.getLicense();
	String domain = sxc.getDomain();
%>

<table align=center bgcolor="white" height=100%><tr><td valign=top>

<div align="center"><span class="大标题_红">报表服务器配置</span></div>
<p>
<table width=720 cellSpacing=4 cellpadding=0 align=center class=labelFont>
	<form id=form1 method=post action="saveConfig.jsp">
	<tr>
		<td>最小内存</td>
		<td><input id=minMem name=minMem class=inputFont value="<%=memory[0]%>" style="width:260px">MB</td>
		<td>最大内存</td>
		<td><input id=maxMem name=maxMem class=inputFont value="<%=memory[1]%>" style="width:260px">MB</td>
	</tr>
	<tr>
		<td>应用名</td>
		<td><input id=appmap name=appmap class=inputFont value="<%=appmap%>" style="width:260px"></td>
		<td>端口号</td>
		<td><input id=port name=port class=inputFont value="<%=port%>" style="width:260px"></td>
	</tr>
	<tr>
		<td>报表缓存目录</td>
		<td colspan=3><input id=cachedir name=cachedir class=inputFont value="<%=cachedir%>" style="width:260px">(为绝对路径，如没有设置则采用系统临时目录)</td>
	</tr>
	<tr>
		<td>授权文件名</td>
		<td colspan=3><input id=license name=license class=inputFont value="<%=license%>" style="width:260px">(此文件必须放在../WEB-INF/classes目录中)</td>
	</tr>
	<tr>
		<td>国际域名</td>
		<td colspan=3><input id=domain name=domain class=inputFont value="<%=domain%>" style="width:260px">(没有国际域名则为localhost)</td>
	</tr>
	<input type=hidden id=webds name=webds >
	<input type=hidden id=serverds name=serverds>
	</form>
	<tr><td width=100% colspan=4>
		<fieldset>
		<legend>数据源配置</legend>
			<br>
			<TABLE id=dss align=center cellSpacing=0 cellPadding=3 width="660" border=1 class=tableStyle style="BORDER-COLLAPSE: collapse">
			  <TR>
			    <TH width=220 class=tableHeaderStyle>数据源名称</TH>
			    <TH width=220 class=tableHeaderStyle>数据库类型</TH>
			    <TH class=tableHeaderStyle>数据库编码</TH>
			  </TR>
			  <TR style="display:none">
			    <TD align=center onclick="setCurrRow( this )" class=tableStyle></TD>
			    <TD align=center class=tableStyle></TD>
			    <TD align=center class=tableStyle></TD>
			  </TR>
			</TABLE>
			
			<TABLE align=center cellSpacing=0 cellPadding=0 border=0 width=660 style="padding-top:8px">
			  <TR align=center>
				<td width=60><img src="../images/add.gif" style="cursor:pointer" onclick="myOk( '1' )"></td>
				<td width=60><img src="../images/del.gif" style="cursor:pointer" onclick="del()"></td>
				<td width=60><img src="../images/modify.gif" style="cursor:pointer" onclick="myOk( '2' )"></td>
				<td>&nbsp;</td>
			  </TR>
			</TABLE>
			<table id=inputArea border=0 cellspacing=3 cellpadding=0 align=center width=660 class=labelFont style="padding-top:5px">
				<tr><td colspan=2>
					数据源名<input id=dsName class=inputFont style="width:120px">(如不是第一个数据源，应与报表设计时的数据源名一致)&nbsp;&nbsp;&nbsp;&nbsp;
					数据库类型<select id=dbType class=inputFont style="width:95px" onchange="dbTypeChanged( value )">
						<option value=ORACLE>Oracle</option>
						<option value=SQLSVR>SQL Server</option>
						<option value=SYBASE>Sybase</option>
						<option value=DB2>DB2</option>
						<option value=MYSQL>MySql</option>
						<option value=INFMIX>Infmix</option>
						<option value=ACCESS>Access</option>
					</select>
				</td></tr>
				<tr><td colspan=2>
					数据库编码<select id=dbEncode class=inputFont style="width:65px">
						<option value=GBK>GBK</option>
						<option value=gb2312>gb2312</option>
						<option value=iso-8859-1>iso-8859-1</option>
					</select>&nbsp;&nbsp;
					转换SQL编码<input type=checkbox id=trans>&nbsp;&nbsp;
					用户名<input id=user class=inputFont style="width:55px">&nbsp;&nbsp;
					密码<input type=password id=pwd style="width:50px">&nbsp;&nbsp;
					驱动程序<input id=driverClass class=inputFont style="width:155px" value="oracle.jdbc.driver.OracleDriver">
				</td></tr>
				<tr><td>
					数据源URL<input id=url class=inputFont style="width:250px">
					(例：<span id=example style="color:blue">jdbc:oracle:thin:@数据库服务器IP地址:1521:数据库名</span>)
				</td></tr>
			</table>
			
		</fieldset>
	</td></tr>		
	<tr><td>
		<img src="../images/saveconfig.gif" style="cursor:pointer" onclick="save()">
	</td></tr>
</table>

</td></tr></table>

<script language=javascript src="util.js">
</script>

<script language=javascript>
	var dbs = new Array( "ORACLE", "SQLSVR", "SYBASE", "DB2", "MYSQL", "INFMIX", "ACCESS" );
	var drivers = new Array( "oracle.jdbc.driver.OracleDriver",
							 "com.newatlanta.jturbo.driver.Driver",
							 "com.sybase.jdbc2.jdbc.SybDriver",
							 "COM.ibm.db2.jdbc.app.DB2Driver",
							 "com.mysql.jdbc.Driver",
							 "com.informix.jdbc.IfxDriver",
							 "sun.jdbc.odbc.JdbcOdbcDriver" );
	var examples = new Array( "jdbc:oracle:thin:@数据库服务器IP地址:1521:数据库名", 
							  "jdbc:JTurbo://数据库服务器IP地址/数据库名",
							  "jdbc:sybase:Tds:数据库服务器IP地址:2048/数据库名",
							  "jdbc:Db2:数据库名",
							  "jdbc:mysql://数据库服务器IP地址:3306/数据库名",
							  "jdbc:informix-sqli://数据库服务器IP地址:1526/数据库名",
							  "jdbc:odbc:数据源ODBC名" );
	function dbTypeChanged( value ) {
		for( var i = 0; i < dbs.length; i++ ) {
			if( value == dbs[i] ) {
				driverClass.value = drivers[i];
				example.innerHTML = examples[i];
				break;
			}
		}
	}
	
	var rowStyle = dss.rows[1].cloneNode( 0 );
	var colStyle0 = dss.rows[1].cells[0].cloneNode( 0 );
	var colStyle1 = dss.rows[1].cells[1].cloneNode( 0 );
	var colStyle2 = dss.rows[1].cells[2].cloneNode( 0 );
	function insertDs( dsName, dbType, dbEncode, trans, user, pwd, driver, url )
	{
		var newrow = dss.insertRow();
		var newRowStyle = rowStyle.cloneNode( 0 );
		newRowStyle.style.display = "";
		newrow.replaceNode( newRowStyle );
		
		//插入第一列
		var newcol0 = newRowStyle.insertCell();
		while( newRowStyle.cells.length == 0 ) newcol0 = newRowStyle.insertCell();
		var newColStyle0 = colStyle0.cloneNode( 0 );
		newColStyle0.innerText = dsName;
		newColStyle0.trans = trans;
		newColStyle0.user = user;
		newColStyle0.pwd = pwd;
		newColStyle0.driver = driver;
		newColStyle0.url = url;
		newcol0.replaceNode( newColStyle0 );
		
		//插入第二列
		var newcol1 = newRowStyle.insertCell();
		while( newRowStyle.cells.length == 1 ) newcol1 = newRowStyle.insertCell();
		var newColStyle1 = colStyle1.cloneNode( 0 );
		newColStyle1.innerText = dbType;
		newcol1.replaceNode( newColStyle1 );
		
		//插入第三列
		var newcol2 = newRowStyle.insertCell();
		while( newRowStyle.cells.length == 2 ) newcol2 = newRowStyle.insertCell();
		var newColStyle2 = colStyle2.cloneNode( 0 );
		newColStyle2.innerText = dbEncode;
		newcol2.replaceNode( newColStyle2 );
		
		setCurrRow( newColStyle0 );
	}
	
	var currCell = null;
	function setCurrRow( cell ) {
		if( cell == null ) return;
		if( currCell != null ) {
			currCell.style.color = "";
			currCell.style.backgroundColor = "";
		}
		cell.style.color = "red";
		cell.style.backgroundColor = "#eee8aa";
		currCell = cell;
		dsName.value = currCell.innerText;
		dbType.value = currCell.parentElement.cells[1].innerText;
		dbTypeChanged( dbType.value );
		dbEncode.value = currCell.parentElement.cells[2].innerText;
		if( currCell.trans == "1" ) trans.checked = true;
		else trans.checked = false;
		user.value = currCell.user;
		pwd.value = currCell.pwd;
		url.value = currCell.url;
	}
	
	function myOk( action ) {
		if( isEmpty( dsName.value ) ) {
			alert( "请输入数据源名！" );
			return;
		}
		if( isEmpty( user.value ) ) {
			alert( "请输入用户名！" );
			return;
		}
		if( isEmpty( driverClass.value ) ) {
			alert( "请输入驱动程序！" );
			return;
		}
		if( isEmpty( url.value ) ) {
			alert( "请输入数据源url！" );
			return;
		}
		var transSql = "0";
		if( trans.checked ) transSql = "1";
		if( action == "1" ) {
			insertDs( dsName.value, dbType.value, dbEncode.value, transSql, user.value, pwd.value, driverClass.value, url.value );
		}
		else {
			if( currCell == null ) {
				alert( "请先点击数据源名选择一个数据源来修改" );
				return;
			}
			var oldDs = currCell.innerText;
			currCell.innerText = dsName.value;
			currCell.parentElement.cells[1].innerText = dbType.value;
			currCell.parentElement.cells[2].innerText = dbEncode.value;
			currCell.trans = transSql;
			currCell.user = user.value;
			currCell.pwd = pwd.value;
			currCell.driver = driverClass.value;
			currCell.url = url.value;
			alert( "数据源" + oldDs + "已修改!" );
		}
	}
	
	function del() {
		if( currCell == null ) {
			alert( "请先点击数据源名选中一个数据源！" );
			return;
		}
		var rowIndex = currCell.parentElement.rowIndex;
		dss.deleteRow( rowIndex );
		if( dss.rows.length == rowIndex && rowIndex > 2 ) setCurrRow( dss.rows[ rowIndex - 1 ].cells[0] );
		else if( dss.rows.length > 2 ) setCurrRow( dss.rows[ rowIndex ].cells[0] );
		else currCell = null;
	}	
	
	function save() {
		if( isEmpty( form1.minMem.value ) ) form1.minMem.value = "64";
		if( isEmpty( form1.maxMem.value ) ) {
			alert( "请输入服务器可使用的最大内存" );
			return;
		}
		if( isEmpty( form1.port.value ) ) form1.port.value = "80";
		if( isEmpty( form1.appmap.value ) ) {
			alert( "请输入应用名" );
			return;
		}
		if( isEmpty( form1.license.value ) ) {
			alert( "请输入授权文件名" );
			return;
		}
		if( isEmpty( form1.domain.value ) ) {
			alert( "请输入国际域名" );
			return;
		}
		var webds = "", serverds = "";
		for( var i = 2; i < dss.rows.length; i++ ) {
			var row = dss.rows[i];
			if( webds.length > 0 ) webds += ";";
			if( serverds.length > 0 ) serverds += "|";
			webds += row.cells[0].innerText + "," + row.cells[1].innerText + "," + row.cells[2].innerText + "," + row.cells[0].trans;
			serverds += row.cells[0].innerText + "^" + row.cells[0].user + "^" + row.cells[0].pwd + "^" + row.cells[0].driver + "^" + row.cells[0].url;
		}
		form1.webds.value = webds;
		form1.serverds.value = serverds;
		form1.submit();
	}
	
	<%
		//DS[] webds = wxc.getDS();
		//for( int i = 0; i < webds.length; i++ ) {
		//	DSConfig dsc = sxc.getDSConfig( appmap, webds[i].jndi );
		//	if( dsc == null ) continue;
		//	out.println( "insertDs( '" + webds[i].jndi + "', '" + webds[i].type.toUpperCase() + "', '" + webds[i].encode + 
		//		"', '" + webds[i].transSql + "', '" + dsc.user + "', '" + dsc.pwd +"', '" + dsc.driver + 
		//		"', '" + dsc.url + "' );" );
		//}
		
	  String tmp=rcm.getInitParameter("dataSource");
		com.runqian.base4.util.ArgumentTokenizer at = new com.runqian.base4.util.ArgumentTokenizer( tmp, ';' );
		java.util.List al = new java.util.ArrayList();
		while( at.hasMoreTokens() ) {
			tmp = at.nextToken();
			com.runqian.base4.util.ArgumentTokenizer at1 = new com.runqian.base4.util.ArgumentTokenizer( tmp, ',' );
			if( at1.countTokens() < 3 ) continue;
			String jndi = at1.nextToken().trim();
			String type = at1.nextToken().trim();
			String encode = at1.nextToken().trim();
			String trans = "0";
			if( at1.hasMoreTokens() ) trans = at1.nextToken().trim();
			DS ds = new DS( jndi, type, encode, trans);
			al.add( ds );
		}
		DS[] webds = new DS[ al.size() ];
		for( int i = 0; i < al.size(); i++ ) webds[i] = ( DS ) al.get( i );
		for( int i = 0; i < webds.length; i++ ) {
			DSConfig dsc = sxc.getDSConfig( appmap, webds[i].jndi );
			if( dsc == null ) continue;
			out.println( "insertDs( '" + webds[i].jndi + "', '" + webds[i].type.toUpperCase() + "', '" + webds[i].encode + 
				"', '" + webds[i].transSql + "', '" + dsc.user + "', '" + dsc.pwd +"', '" + dsc.driver + 
				"', '" + dsc.url + "' );" );
		}
	%>
</script>

</body>
</html>
