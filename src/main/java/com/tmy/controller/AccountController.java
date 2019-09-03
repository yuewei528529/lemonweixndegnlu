package com.tmy.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import org.scribe.model.Token;
import org.scribe.model.Verifier;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;


import com.tmy.model.Dengluuser;
import com.tmy.model.OAuthUser;
import com.tmy.oauth.service.CustomOAuthService;
import com.tmy.oauth.service.OAuthServices;
import com.tmy.repository.DengluuserRepository;
import com.tmy.repository.OauthUserRepository;
import com.tmy.repository.UserRepository;

import net.sf.json.JSONArray;

@Controller
public class AccountController {
    
    public static final Logger logger = LoggerFactory.getLogger(AccountController.class);
    
    @Autowired OAuthServices oAuthServices;
    @Autowired OauthUserRepository oauthUserRepository;
    @Autowired UserRepository userRepository;
    @Autowired DengluuserRepository dengluuserRepository;
    @RequestMapping(value = {"", "/login"}, method=RequestMethod.GET)
    public String showLogin(@RequestParam(value = "code", required = false) String code,Model model,HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException{
       // model.addAttribute("oAuthServices", oAuthServices.getAllOAuthServices());
    	if(code==null)
    	{
    		 return "denglu";
    	}
    	CustomOAuthService oAuthService = oAuthServices.getOAuthService("weixin");
        Token accessToken = oAuthService.getAccessToken(null, new Verifier(code));
        OAuthUser oAuthInfo = oAuthService.getOAuthUser(accessToken);
        
      // System.out.println("-----------------"+oAuthInfo.getoAuthId());
        OAuthUser oAuthUser = oauthUserRepository.findByOAuthTypeAndOAuthId(oAuthInfo.getoAuthType(), 
                oAuthInfo.getoAuthId());
        
 
        if(dengluuserRepository.existsByopenid(oAuthInfo.getoAuthId())) {
        	dengluuserRepository.setcode(code, oAuthInfo.getoAuthId());
        }
        else 
        {
            Dengluuser dengluuser = new Dengluuser();
            dengluuser.setId(1);
            dengluuser.setcode(code);
            dengluuser.setoAuthNichegn(oAuthInfo.getoAuthNichegn());
            dengluuser.setopenid(oAuthInfo.getoAuthId());
            dengluuserRepository.save(dengluuser);
        }
        //dengluuserRepository.save(dengluuser);
      System.out.println("-----------------"+dengluuserRepository.findBycode(code).getzhuce());
        if(("a").equals(dengluuserRepository.findBycode(code).getzhuce()))
        		{
        	String cc=java.net.URLEncoder.encode(dengluuserRepository.findBycode(code).getxingming(),"UTF-8");
            return "redirect:http://www.pgepc.cn:81/oa/index.jsp?code="+code;
        	
        	 
        }else if(dengluuserRepository.findBycode(code).getxingming()!=null&&!("a").equals(dengluuserRepository.findBycode(code).getzhuce()))
        {
        	return "success4";
        }
        		
        			
         model.addAttribute("oAuthInfo", oAuthInfo);
        	
        	return "register";
        
       
      /*  request.setAttribute("qq", "ww");
        String cc=java.net.URLEncoder.encode(oAuthUser.getUser().getUsername(),"UTF-8");
       // return "redirect:http://www.pgepc.cn:81/oa?username="+cc;
       // request.getRequestDispatcher("http://localhost:8081/bvv/1.jsp").forward(request,response);
        
        return "redirect:https://www.hao123.com/";*/
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
            @RequestParam(value = "oAuthType", required = false, defaultValue = "") String oAuthType,*/
            @RequestParam(value = "oAuthId", required = true, defaultValue = "") String oAuthId,
    		Model model,HttpServletRequest request){
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
    	System.out.println("xxxxxxxxxxxxxxxxxxx"+oAuthId);
    	//System.out.println("pppppppppppppppppppppp"+dengluuserRepository.findByxingming(name).getopenid());
        if(!dengluuserRepository.existsByxingming(name))
        {
        //	System.out.println("zzzzzzzzzzzzzzzzzzzzz"+dengluuserRepository.findByopenid(oAuthId).getoAuthNichegn());
        	dengluuserRepository.setxingming(name,oAuthId);
             return "success3";  
        }
        return "success2";
        	
       /* user = userRepository.save(user);
        OAuthUser oAuthUser = oauthUserRepository.findByOAuthTypeAndOAuthId(oAuthType, oAuthId);
        if(oAuthUser == null){
            oAuthInfo.setUser(user);
            oAuthUser = oauthUserRepository.save(oAuthInfo);
        }
        request.getSession().setAttribute("oauthUser", oAuthUser);
        return "redirect:/success";*/
    }
  
    @RequestMapping(value = "/success", method=RequestMethod.GET)
    @ResponseBody
    public Object success(HttpServletRequest request,@RequestParam(value = "code", required = true) String code){
    	List<Dengluuser> cc;
    	Dengluuser ff=dengluuserRepository.findBycode(code);
    	//dengluuserRepository.setcode2(code);
    	JSONArray jsonArray = JSONArray.fromObject(ff);
    	    String result = jsonArray.get(0).toString();
        return "qq("+result+")"  ;
        
    }
    

}
