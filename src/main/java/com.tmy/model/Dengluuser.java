package com.tmy.model;


import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Dengluuser {
    

    private Integer id;
   @Id
   private String openid;
    private String code;
    
    private String oAuthNichegn;
    
    private String xingming;
    private String zhuce;
    public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }
    public String getcode() {
        return code;
    }
    public void setcode(String code) {
        this.code = code;
    }
    public String getoAuthNichegn() {
        return oAuthNichegn;
    }
    public void setoAuthNichegn(String oAuthNichegn) {
        this.oAuthNichegn = oAuthNichegn;
    }
    public String getxingming() {
        return xingming;
    }
    public void setxingming(String xingming) {
        this.xingming = xingming;
    }
    public String getzhuce() {
        return zhuce;
    }
    public void setzhuce(String zhuce) {
        this.zhuce = zhuce;
    }
    public String getopenid() {
        return openid;
    }
    public void setopenid(String openid) {
        this.openid = openid;
    }
}
