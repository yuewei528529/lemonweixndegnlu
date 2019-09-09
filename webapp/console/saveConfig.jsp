<%@ page contentType="text/html;charset=GBK" %>
<%@ page import="com.runqian.serverconfig.*" %>
<%@ page import="com.runqian.report4.view.ReportConfigManagerImpl" %>
<%@ page import="com.runqian.report4.view.IReportConfigManager" %>
<%@ page import="java.io.*" %>

<html>
<head>
<LINK href="style.css" type=text/css rel=stylesheet>
</head>
<body>

<table align=center class=labelFont><tr><td>
<%
	request.setCharacterEncoding( "GBK" );
	String path = application.getRealPath( "/" );
	File file = new File( path );
	String s = file.getParentFile().getParentFile().getAbsolutePath() + File.separator + "启动报表服务器.bat";
	MemoryConfig mc = new MemoryConfig( s );
	String appmap = request.getContextPath();
	s = file.getParentFile().getParentFile().getAbsolutePath() + File.separator + "conf" + File.separator + "server.xml";
	ServerXmlConfig sxc = new ServerXmlConfig( s );
	WebXmlConfig wxc = new WebXmlConfig( application );
	IReportConfigManager rcm=ReportConfigManagerImpl.getInstance();
	String minMem = request.getParameter( "minMem" );
	String maxMem = request.getParameter( "maxMem" );
	mc.setMemory( minMem.trim(), maxMem.trim() );
	String appname = request.getParameter( "appmap" );
	appname = appname.trim();
	if( appname.length() > 0 && !appname.startsWith( "/" ) ) appname = "/" + appname;
	String port = request.getParameter( "port" );
	String license = request.getParameter( "license" );
	String cachedir = request.getParameter( "cachedir" );
	String webds = request.getParameter( "webds" );
	String serverds = request.getParameter( "serverds" );
	String domain = request.getParameter( "domain" );
	sxc.setDomain( domain );
	sxc.setPort( port.trim() );
	//wxc.setCachDir( cachedir.trim() );
	//wxc.setLicense( license.trim() );
	//wxc.setDS( webds.trim() );
	sxc.setDSConfig( appmap, serverds.trim() );
	sxc.setAppmap( appmap, appname );
	
	try{
		String configPath=application.getRealPath( "/WEB-INF/reportConfig.xml" );
		rcm.setInputStream(new FileInputStream(configPath));
		rcm.setParameterValue("license",license.trim());
		rcm.setParameterValue("cachedReportDir",cachedir.trim());
		rcm.setParameterValue("dataSource",webds.trim());
		rcm.write(configPath);
	}
	catch(Exception e){
		e.printStackTrace();
	}
		
	wxc.write();
	sxc.write();
	out.println( "服务器配置已保存，请重新启动服务器以使新的配置生效<p>" );
	out.println( "管理页面的URL为：http://" + request.getServerName() + ":" + port + appname + "/console/console.jsp" );
%>
</td></tr></table>

