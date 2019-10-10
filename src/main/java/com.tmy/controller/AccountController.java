package com.tmy.controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import com.alibaba.fastjson.JSONPath;
import com.mossle.dengluuser.persistence.domain.denglu;
import com.mossle.dengluuser.persistence.manager.Denglumanager;
import com.mossle.dengluuser.service.dengluservice;
import com.tmy.model.OAuthUser;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;

import org.scribe.model.Token;
import org.scribe.model.Verifier;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;


import com.tmy.model.Dengluuser;

import com.tmy.oauth.service.CustomOAuthService;
import com.tmy.oauth.service.OAuthServices;


import net.sf.json.JSONArray;

@Controller
public class AccountController {
    
    public static final Logger logger = LoggerFactory.getLogger(AccountController.class);

    @Autowired OAuthServices oAuthServices;
 /*   @Autowired OauthUserRepository oauthUserRepository;
    @Autowired UserRepository userRepository;*/
    @Autowired dengluservice dengluuserRepository;
    @Autowired
    Denglumanager ff;
    @RequestMapping(value = { "login11"}, method=RequestMethod.GET)
    public String showLogin(@RequestParam(value = "code", required = false) String code, Model model, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
     /*   Cookie cookie = new Cookie("name_test","value_test");//创建新cookie
        cookie.setMaxAge(5 * 60);// 设置存在时间为5分钟
        cookie.setPath("/");//设置作用域
        response.addCookie(cookie);
        HttpClient httpClient = new DefaultHttpClient();

*//*        // get method*//*
        HttpGet httpGet = new HttpGet("https://www.baidu.com");

        //response
        HttpResponse response1 = null;
        try{
            response1 = httpClient.execute(httpGet);
        }catch (Exception e) {}

        //get response into String
        String temp="";
        try{
            HttpEntity entity = response1.getEntity();
            temp= EntityUtils.toString(entity,"UTF-8");
            System.out.println("=========================="+temp);
        }catch (Exception e) {}*/



       // model.addAttribute("oAuthServices", oAuthServices.getAllOAuthServices());
/*    	if(code==null)
    	{
    		 return "denglu";
    	}*/
    	CustomOAuthService oAuthService = oAuthServices.getOAuthService("weixin");
        Token accessToken = oAuthService.getAccessToken(null, new Verifier(code));
        OAuthUser oAuthInfo = oAuthService.getOAuthUser(accessToken);
        
      // System.out.println("-----------------"+oAuthInfo.getoAuthId());
/*        OAuthUser oAuthUser = oauthUserRepository.findByOAuthTypeAndOAuthId(oAuthInfo.getoAuthType(),
                oAuthInfo.getoAuthId());*/
        
 
        if(dengluuserRepository.findbyopenid(oAuthInfo.getoAuthId())!=null) {
           denglu denglu1 = new denglu();
            denglu1.setId("1");
            denglu1.setcode(code);
            denglu1.seto_auth_nichegn(oAuthInfo.getoAuthNichegn());
            denglu1.setopenid(oAuthInfo.getoAuthId());
           // dengluuserRepository.del(denglu1);
            //denglu denglu2 = new denglu();
           // denglu  denglu2=  dengluuserRepository.findbyopenid(oAuthInfo.getoAuthId());
            ff.batchUpdate("update denglu set code  = ? where openid = ?",code ,oAuthInfo.getoAuthId());
           // dengluuserRepository.findbyopenid(oAuthInfo.getoAuthId()).setcode(code);
           // System.out.println("=============="+dengluuserRepository.findbyopenid(oAuthInfo.getoAuthId()).getcode());
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
        if(("a").equals(dengluuserRepository.findBycode(code).getzhuce()))
        		{

        	String cc=java.net.URLEncoder.encode(dengluuserRepository.findBycode(code).getxingming(),"UTF-8");
        //    return "redirect:http://www.pgepc.cn:8081/lemon_war_exploded/common/login.jsp?code="+code;
            return "redirect:http://www.pgepc.cn/pinggao-1.0/common/login.jsp?code="+code;
        	 
        }else if(dengluuserRepository.findBycode(code).getxingming().isEmpty())
        {
            request.getSession().setAttribute("code",code);
        	return "/register";
        }


        return "success3";
        
       
      /*  request.setAttribute("qq", "ww");
        String cc=java.net.URLEncoder.encode(oAuthUser.getUser().getUsername(),"UTF-8");
       // return "redirect:http://www.pgepc.cn:81/oa?username="+cc;
       // request.getRequestDispatcher("http://localhost:8081/bvv/1.jsp").forward(request,response);
        
        return "redirect:https://www.hao123.com/";*/
    }


    @RequestMapping("chazhao")
    @ResponseBody
    public Object input2(@RequestParam(value = "code", required = false)String code) {

        return dengluuserRepository.findBycode(code).getxingming();

    }


   /* @RequestMapping(value = "/oauth/{type}/callback", method=RequestMethod.GET)
    public String claaback(@RequestParam(value = "code", required = true) String code,
            @PathVariable(value = "type") String type,
            HttpServletRequest request, Model model){
        CustomOAuthService oAuthService = oAuthServices.getOAuthService(type);
        Token accessToken = oAuthService.getAccessToken(null, new Verifier(code));
        OAuthUser oAuthInfo = oAuthService.getOAuthUser(accessToken);
        
        OAuthUser oAuthUser = oauthUserRepository.findByOAuthTypeAndOAuthId(oAuthInfo.getoAuthType(), 
                oAuthInfo.getoAuthId());
        if(oAuthUser == null){
            model.addAttribute("oAuthInfo", oAuthInfo);
            return "register";
        }
        request.getSession().setAttribute("oauthUser", oAuthUser);
        return "redirect:http://localhost:8085/oa";
    }*/
    
    @RequestMapping(value = "/register", method=RequestMethod.GET)
    public String register(/*Model model, User user,
            @RequestParam(value = "oAuthType", required = false, defaultValue = "") String oAuthType,
            @RequestParam(value = "oAuthId", required = true, defaultValue = "") String oAuthId,*/
    		Model model,HttpServletRequest request){
        request.getSession().getAttribute("code");
    	String name=request.getParameter("name");
    	 /*System.out.println("pppppppppppppppppppppp"+request.getAttribute("oAuthNichegn"));
        OAuthUser oAuthInfo = new OAuthUser();
        oAuthInfo.setoAuthId(oAuthId);
        oAuthInfo.setoAuthType(oAuthType);
        oAuthInfo.setoAuthNichegn(request.getSession().getAttribute("oAuthNichegn").toString());
       if(userRepository.findByUsername(user.getUsername()) != null){
            model.addAttribute("errorMessage", "用户名已存在");
            model.addAttribute("oAuthInfo", oAuthInfo);
            return "register";
        }*/
    	//System.out.println("xxxxxxxxxxxxxxxxxxx"+oAuthId);
    	//System.out.println("pppppppppppppppppppppp"+dengluuserRepository.findByxingming(name).getopenid());
        ff.batchUpdate("update denglu set xingming  = ? where code = ?",name ,request.getSession().getAttribute("code"));
/*        if(dengluuserRepository.existsByxingming(name)==null)
        {
        //	System.out.println("zzzzzzzzzzzzzzzzzzzzz"+dengluuserRepository.findByopenid(oAuthId).getoAuthNichegn());

        	dengluuserRepository.existsByxingming(name).setxingming(name);
             return "success3";  
        }*/
        return "success3";
        	
       /* user = userRepository.save(user);
        OAuthUser oAuthUser = oauthUserRepository.findByOAuthTypeAndOAuthId(oAuthType, oAuthId);
        if(oAuthUser == null){
            oAuthInfo.setUser(user);
            oAuthUser = oauthUserRepository.save(oAuthInfo);
        }
        request.getSession().setAttribute("oauthUser", oAuthUser);
        return "redirect:/success";*/
    }
  
/*    @RequestMapping(value = "/success", method=RequestMethod.GET)
    @ResponseBody
    public Object success(HttpServletRequest request,@RequestParam(value = "code", required = true) String code){
    	List<Dengluuser> cc;
    	Dengluuser ff=dengluuserRepository.findBycode(code);
    	//dengluuserRepository.setcode2(code);
    	JSONArray jsonArray = JSONArray.fromObject(ff);
    	    String result = jsonArray.get(0).toString();
        return "qq("+result+")"  ;
        
    }*/
    

}
