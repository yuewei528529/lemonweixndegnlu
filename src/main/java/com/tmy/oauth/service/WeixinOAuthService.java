package com.tmy.oauth.service;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.scribe.builder.api.DefaultApi20;
import org.scribe.model.*;
import org.scribe.oauth.OAuth20ServiceImpl;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONPath;
import com.tmy.config.OAuthTypes;
import com.tmy.model.OAuthUser;
import com.tmy.model.User;

public class WeixinOAuthService extends OAuth20ServiceImpl implements CustomOAuthService {
    
    private final DefaultApi20 api;
    private final OAuthConfig config;
    private final String authorizationUrl;
    
    public WeixinOAuthService(DefaultApi20 api, OAuthConfig config) {
        super(api, config);
        this.api = api;
        this.config = config;
        this.authorizationUrl = getAuthorizationUrl(null);
    }

    @Override
    public Token getAccessToken(Token requestToken, Verifier verifier){
      OAuthRequest request = new OAuthRequest(api.getAccessTokenVerb(), api.getAccessTokenEndpoint());
      request.addQuerystringParameter("appid", config.getApiKey());
      request.addQuerystringParameter("secret", config.getApiSecret());
      request.addQuerystringParameter(OAuthConstants.CODE, verifier.getValue());
      
      if(config.hasScope()) request.addQuerystringParameter(OAuthConstants.SCOPE, config.getScope());
      Response response = request.send();
      String responceBody = response.getBody();
      Object result = JSON.parse(responceBody);
 
      
     // return temp;
      return new Token(JSONPath.eval(result, "$.access_token").toString(), "", responceBody);
    }


    
    @Override
    public OAuthUser getOAuthUser(Token accessToken) {
    	
        OAuthUser oAuthUser = new OAuthUser();
        oAuthUser.setoAuthType(getoAuthType());
        Object result = JSON.parse(accessToken.getRawResponse());
        oAuthUser.setoAuthId(JSONPath.eval(result, "$.openid").toString());
       
        
        HttpClient httpClient = new DefaultHttpClient();

        // get method
        HttpGet httpGet = new HttpGet("https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=wx8b76994cef15e869".replace("ACCESS_TOKEN", JSONPath.eval(result, "$.access_token").toString()));

        //response
        HttpResponse response1 = null;  
        try{
            response1 = httpClient.execute(httpGet);
        }catch (Exception e) {} 

        //get response into String
        String temp="";
        try{
            HttpEntity entity = response1.getEntity();
            temp=EntityUtils.toString(entity,"UTF-8");
            System.out.println("=========================="+temp);
        }catch (Exception e) {} 
        
        Object temp1 = JSON.parse(temp);
       
       String cc=JSONPath.eval(temp1, "$.nickname").toString();
       System.out.println("dddddddddddddddddddddddddddd"+cc);
      oAuthUser.setoAuthNichegn(cc);
       
       oAuthUser.setUser(new User());
        return oAuthUser;
    }

    @Override
    public String getoAuthType() {
        return OAuthTypes.WEIXIN;
    }

    @Override
    public String getAuthorizationUrl() {
        return authorizationUrl;
    }

}
