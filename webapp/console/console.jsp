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
	String s = file.getParentFile().getParentFile().getAbsolutePath() + File.separator + "�������������.bat";
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

<div align="center"><span class="�����_��">�������������</span></div>
<p>
<table width=720 cellSpacing=4 cellpadding=0 align=center class=labelFont>
	<form id=form1 method=post action="saveConfig.jsp">
	<tr>
		<td>��С�ڴ�</td>
		<td><input id=minMem name=minMem class=inputFont value="<%=memory[0]%>" style="width:260px">MB</td>
		<td>����ڴ�</td>
		<td><input id=maxMem name=maxMem class=inputFont value="<%=memory[1]%>" style="width:260px">MB</td>
	</tr>
	<tr>
		<td>Ӧ����</td>
		<td><input id=appmap name=appmap class=inputFont value="<%=appmap%>" style="width:260px"></td>
		<td>�˿ں�</td>
		<td><input id=port name=port class=inputFont value="<%=port%>" style="width:260px"></td>
	</tr>
	<tr>
		<td>������Ŀ¼</td>
		<td colspan=3><input id=cachedir name=cachedir class=inputFont value="<%=cachedir%>" style="width:260px">(Ϊ����·������û�����������ϵͳ��ʱĿ¼)</td>
	</tr>
	<tr>
		<td>��Ȩ�ļ���</td>
		<td colspan=3><input id=license name=license class=inputFont value="<%=license%>" style="width:260px">(���ļ��������../WEB-INF/classesĿ¼��)</td>
	</tr>
	<tr>
		<td>��������</td>
		<td colspan=3><input id=domain name=domain class=inputFont value="<%=domain%>" style="width:260px">(û�й���������Ϊlocalhost)</td>
	</tr>
	<input type=hidden id=webds name=webds >
	<input type=hidden id=serverds name=serverds>
	</form>
	<tr><td width=100% colspan=4>
		<fieldset>
		<legend>����Դ����</legend>
			<br>
			<TABLE id=dss align=center cellSpacing=0 cellPadding=3 width="660" border=1 class=tableStyle style="BORDER-COLLAPSE: collapse">
			  <TR>
			    <TH width=220 class=tableHeaderStyle>����Դ����</TH>
			    <TH width=220 class=tableHeaderStyle>���ݿ�����</TH>
			    <TH class=tableHeaderStyle>���ݿ����</TH>
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
					����Դ��<input id=dsName class=inputFont style="width:120px">(�粻�ǵ�һ������Դ��Ӧ�뱨�����ʱ������Դ��һ��)&nbsp;&nbsp;&nbsp;&nbsp;
					���ݿ�����<select id=dbType class=inputFont style="width:95px" onchange="dbTypeChanged( value )">
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
					���ݿ����<select id=dbEncode class=inputFont style="width:65px">
						<option value=GBK>GBK</option>
						<option value=gb2312>gb2312</option>
						<option value=iso-8859-1>iso-8859-1</option>
					</select>&nbsp;&nbsp;
					ת��SQL����<input type=checkbox id=trans>&nbsp;&nbsp;
					�û���<input id=user class=inputFont style="width:55px">&nbsp;&nbsp;
					����<input type=password id=pwd style="width:50px">&nbsp;&nbsp;
					��������<input id=driverClass class=inputFont style="width:155px" value="oracle.jdbc.driver.OracleDriver">
				</td></tr>
				<tr><td>
					����ԴURL<input id=url class=inputFont style="width:250px">
					(����<span id=example style="color:blue">jdbc:oracle:thin:@���ݿ������IP��ַ:1521:���ݿ���</span>)
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
	var examples = new Array( "jdbc:oracle:thin:@���ݿ������IP��ַ:1521:���ݿ���", 
							  "jdbc:JTurbo://���ݿ������IP��ַ/���ݿ���",
							  "jdbc:sybase:Tds:���ݿ������IP��ַ:2048/���ݿ���",
							  "jdbc:Db2:���ݿ���",
							  "jdbc:mysql://���ݿ������IP��ַ:3306/���ݿ���",
							  "jdbc:informix-sqli://���ݿ������IP��ַ:1526/���ݿ���",
							  "jdbc:odbc:����ԴODBC��" );
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
		
		//�����һ��
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
		
		//����ڶ���
		var newcol1 = newRowStyle.insertCell();
		while( newRowStyle.cells.length == 1 ) newcol1 = newRowStyle.insertCell();
		var newColStyle1 = colStyle1.cloneNode( 0 );
		newColStyle1.innerText = dbType;
		newcol1.replaceNode( newColStyle1 );
		
		//���������
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
			alert( "����������Դ����" );
			return;
		}
		if( isEmpty( user.value ) ) {
			alert( "�������û�����" );
			return;
		}
		if( isEmpty( driverClass.value ) ) {
			alert( "��������������" );
			return;
		}
		if( isEmpty( url.value ) ) {
			alert( "����������Դurl��" );
			return;
		}
		var transSql = "0";
		if( trans.checked ) transSql = "1";
		if( action == "1" ) {
			insertDs( dsName.value, dbType.value, dbEncode.value, transSql, user.value, pwd.value, driverClass.value, url.value );
		}
		else {
			if( currCell == null ) {
				alert( "���ȵ������Դ��ѡ��һ������Դ���޸�" );
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
			alert( "����Դ" + oldDs + "���޸�!" );
		}
	}
	
	function del() {
		if( currCell == null ) {
			alert( "���ȵ������Դ��ѡ��һ������Դ��" );
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
			alert( "�������������ʹ�õ�����ڴ�" );
			return;
		}
		if( isEmpty( form1.port.value ) ) form1.port.value = "80";
		if( isEmpty( form1.appmap.value ) ) {
			alert( "������Ӧ����" );
			return;
		}
		if( isEmpty( form1.license.value ) ) {
			alert( "��������Ȩ�ļ���" );
			return;
		}
		if( isEmpty( form1.domain.value ) ) {
			alert( "�������������" );
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
