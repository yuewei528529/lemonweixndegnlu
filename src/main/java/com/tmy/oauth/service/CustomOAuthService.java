package com.tmy.oauth.service;

import org.scribe.model.Token;
import org.scribe.oauth.OAuthService;

import com.tmy.model.OAuthUser;

public interface CustomOAuthService extends OAuthService{
    
    String getoAuthType();
    String getAuthorizationUrl();
    OAuthUser getOAuthUser(Token accessToken);

}
