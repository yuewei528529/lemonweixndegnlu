package com.tmy.oauth.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class OAuthServices {
    
    @Autowired List<CustomOAuthService> oAuthServiceDeractors;
    
    public CustomOAuthService getOAuthService(String type){
        Optional<CustomOAuthService> oAuthService = oAuthServiceDeractors.stream().filter(o -> o.getoAuthType().equals(type))
                .findFirst();
        if(oAuthService.isPresent()){
            return oAuthService.get();
        }
        return null;
    }
    
    public List<CustomOAuthService> getAllOAuthServices(){
        return oAuthServiceDeractors;
    }

}
