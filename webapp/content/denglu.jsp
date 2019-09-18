<%@ page import="com.mossle.dengluuser.persistence.domain.denglu" %>
<%@ page import="com.tmy.model.OAuthUser" %>
<%@ page import="org.scribe.model.Verifier" %>
<%@ page import="org.scribe.model.Token" %>
<%@ page import="com.mossle.dengluuser.service.dengluservice" %>

<%@ page import="com.tmy.oauth.service.OAuthServices" %>
<%@ page import=" com.tmy.oauth.service.CustomOAuthService" %>
<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2019/9/16
  Time: 15:16
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<div id="login_container">这是装二维码的容器div</div>
<%--<%
    String code=request.getParameter("code");
   // dengluservice dengluuserRepository;
    dengluservice dengluuserRepository = new dengluservice();
   // OAuthServices oAuthServices;
    OAuthServices oAuthServices = new OAuthServices();
   //CustomOAuthService oAuthService;
  //  CustomOAuthService oAuthService = new CustomOAuthService();

CustomOAuthService oAuthService = oAuthServices.getOAuthService("weixin");
Token accessToken = oAuthService.getAccessToken(null, new Verifier(code));
OAuthUser oAuthInfo = oAuthService.getOAuthUser(accessToken);

    if(dengluuserRepository.findbyopenid(oAuthInfo.getoAuthId())!=null) {
        denglu denglu1 = new denglu();
        denglu1.setId("1");
        denglu1.setcode(code);
        denglu1.seto_auth_nichegn(oAuthInfo.getoAuthNichegn());
        denglu1.setopenid(oAuthInfo.getoAuthId());
        // dengluuserRepository.del(denglu1);
        dengluuserRepository.setcode(denglu1);
        System.out.println("=============="+dengluuserRepository.findbyopenid(oAuthInfo.getoAuthId()).getcode());
    }
    else
    {
        denglu denglu1 = new denglu("1",code,oAuthInfo.getoAuthNichegn(),"","",oAuthInfo.getoAuthId());
         /*   denglu1.setId("1");
            denglu1.setcode(code);
            denglu1.seto_auth_nichegn(oAuthInfo.getoAuthNichegn());
            denglu1.setopenid(oAuthInfo.getoAuthId());
            denglu1.se*/
        dengluuserRepository.save(denglu1);
    }
    //dengluuserRepository.save(dengluuser);
    System.out.println("-----------------"+dengluuserRepository.findBycode(code).getzhuce());
/*    if(("a").equals(dengluuserRepository.findBycode(code).getzhuce()))
    {
        String cc=java.net.URLEncoder.encode(dengluuserRepository.findBycode(code).getxingming(),"UTF-8");
        return "redirect:http://www.pgepc.cn:81/oa/index.jsp?code="+code;


    }else if(dengluuserRepository.findBycode(code).getxingming()!=null&&!("a").equals(dengluuserRepository.findBycode(code).getzhuce()))
    {
        return "success4";
    }


    model.addAttribute("oAuthInfo", oAuthInfo);

    return "register";*/
%>--%>

<script src="http://res.wx.qq.com/connect/zh_CN/htmledition/js/wxLogin.js"></script>
<script type="text/javascript">
    var obj = new WxLogin({
        id : "login_container",
        appid : "wx73c528e3dd138a7a",
        scope : "snsapi_login",
        redirect_uri : "http%3a%2f%2fwww.pgepc.cn",
        state : "",
        style : "black",
        href : ""
    });

</script>
</body>
</html>
