<%@ page contentType="text/html;charset=GBK" %>
<%@ page import="java.util.*" %>
<%@ page import="com.raq.web.view.web.*" %>
<%@ page import="com.raq.common.*" %>
<%
String cp = request.getContextPath();

String userId = request.getParameter("userId");
String pwd = request.getParameter("pwd");
String errorInfo = "";
if (userId != null && pwd != null) {
	
	ArrayList spaceNames = null;
	try {
		spaceNames = SessionContext.userLogin(request, userId, new MD5().getMD5ofStr(pwd));
		if (spaceNames.size() > 1) {
			response.sendRedirect(cp + "/dm/jsp/index.jsp?chooseSpace=yes");
	
			Object o = application.getAttribute("_SESSION_LIST_");
			if (o == null) {
				HashSet set = new HashSet();
				set.add(session);
				application.setAttribute("_SESSION_LIST_", set);
			} else {
				HashSet set = (HashSet)o;
				set.add(session);
			}
	
			return;
		} else {
			if (spaceNames.size() == 1) {
				SessionContext.openSpace(request, spaceNames.get(0).toString());
			}
			response.sendRedirect(cp + "/dm/jsp/index.jsp");
	
			Object o = application.getAttribute("_SESSION_LIST_");
			if (o == null) {
				HashSet set = new HashSet();
				set.add(session);
				application.setAttribute("_SESSION_LIST_", set);
			} else {
				HashSet set = (HashSet)o;
				set.add(session);
			}
	
			return;
		}
			
	} catch(Exception e) {
		e.printStackTrace();
		errorInfo = e.getMessage();
	}
	
}
%>
<html>
	<HEAD>
		<TITLE>
			��Ǭ����
		</TITLE>
		<STYLE>
		
        .border
        {
            BORDER-RIGHT: DimGray   1px solid;
            BORDER-TOP: DimGray   1px solid;
            BORDER-LEFT: DimGray   1px solid;
            BORDER-BOTTOM: DimGray   1px solid
        }
        .loginbottom
        {
        	font-size:12px;
        	color:white;
        }
        .loginbottom
        {
         	font-size:12px;
        	color:white;
        }
        .logintitle
        {
     	font-size:12px;
     	color:#696969;
        }
       .input
        {
          	width:150px;
			font-size:12px;
		    BORDER-RIGHT: #696969 1px solid;
		    BORDER-TOP: #696969 1px solid;
		    BORDER-LEFT: #696969 1px solid;
		    BORDER-BOTTOM: #696969 1px solid
		}
	</STYLE>
	<script language="javascript" type="text/javascript">
	if (top != window || window.location.href.indexOf('index.jsp') > 0) {
		top.location.href = '<%=cp%>/dm/jsp/login.jsp';
	}
	</script>
		<meta http-equiv="Pragma" content="no-cache" />
		<meta http-equiv="Expires" content="0" />
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
	</HEAD>
<body>
		<TABLE height=100% width=100% border=0 cellspacing=0 cellpadding=0>
			<TR>
				<TD valign=middle align=center>
					<TABLE border=0 cellspacing=0 cellpadding=0>
						<TR>
							<TD class=border>
								<TABLE border=0 cellspacing=0 cellpadding=0>

									<TR>
										<TD background=<%=cp%>/dm/images/login/space_bg.gif style="padding-top:40px;padding-left:0px;padding-right:0px;padding-bottom:10px">
											<TABLE>
												<TR>
													<TD>
														<img src="<%=cp%>/dm/images/login/mainpic.gif">
													</TD>
													
													<TD align=center valign=top>

														<TABLE border=0 cellspacing=0 cellpadding=0 style='font-size:12px'>
															<TR>
																<TD><img src="<%=cp%>/dm/images/login/logintop.gif"></TD>
															</tr>
															<TR height=150>
																<TD style='background:url(<%=cp%>/dm/images/login/longin_bg.gif) repeat' valign=middle align=center>
																<font color="#ff0000"><%=errorInfo %></font>
																<form method=post action="" target=_top id=loginForm name=loginForm >
																	<table style='font-size:12px'>
																		<tr height=40>
																			<td colspan=2 align=center>�û���¼</td>
																		</tr>
																		<tr>
																			<td align=right>�û���:</td>
																			<td><input type=text name=userId style="width:150px;height:20px;" value='<%=userId==null?"":userId %>'></td>
																		</tr>
																		<tr>
																			<td align=right>�ܡ���:</td>
																			<td><input type=password name=pwd style="width:150px;height:20px;"></td>
																		</tr>
																		<tr height=35>
																			<td colspan=2 align=center>
																				<span style="display:none"><input type="checkbox" value="ds" name="loginType" id="loginType" checked>���ݿ��û���½</span>
																				<input type=image src="<%=cp%>/dm/images/login/login.gif">
																			</td>
																		</tr>
																		<tr height=60>
																			<td colspan=2 align=center><!-- ��һ�ε�¼ʱ������Ϊ�գ��뼰ʱ�޸����룡--> </td>
																		</tr>
																	</table> 
																</form>
																</TD>																		
															<TR height=50>
																<TD background="<%=cp%>/dm/images/login/longinbot_bg.gif" valign=middle align=center class=loginbottom>
																	�������û���������&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�����½����
																	<BR />
																	<BR />
																</TD>
															</TR>
														</TABLE>
											</TABLE>
									<TR height=4>
										<TD background="<%=cp%>/dm/images/login/line.gif">
									<TR>
										<TD height=60 style="padding-top:10px;padding-left:50px;padding-right:50px;padding-bottom:10px;background-color:white" class=logintitle>
											�� ʾ �� ��ϵͳ��Ҫ������IE6.0���ϰ汾�������Ӧ��ʾģʽ 1024 * 768 �����Ϸֱ��ʣ�
											<BR>
											<BR>
								</TABLE>
					</TABLE>
		</TABLE>
</body>
</html>