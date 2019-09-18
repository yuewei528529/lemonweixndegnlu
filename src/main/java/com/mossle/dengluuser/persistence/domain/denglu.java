package com.mossle.dengluuser.persistence.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "dengluuser")
public class denglu implements java.io.Serializable {
    private static final long serialVersionUID = 60777L;

    private String id;

    private String code;
    private String o_auth_nichegn;
    private String xingming;
    private String zhuce;
    private String openid;

    public denglu(){}

    public denglu(String id, String code, String o_auth_nichegn, String xingming, String zhuce, String openid) {
        this.id = id;
        this.code = code;
        this.o_auth_nichegn = o_auth_nichegn;
        this.xingming = xingming;
        this.zhuce = zhuce;
        this.openid = openid;
    }

    @Id
    @Column(name = "id", unique = true, nullable = false)
    public String getId() {
        return this.id;
    }

    /**
     * @param id
     *            null.
     */
    public void setId(String id) {
        this.id = id;
    }
    @Column(name = "code", length = 200)
    public String getcode() {
        return this.code;
    }

    /**
     * @param
     *
     */
    public void setcode(String code) {
        this.code = code;
    }

    @Column(name = "o_auth_nichegn", length = 200)
    public String geto_auth_nichegn() {
        return this.o_auth_nichegn;
    }

    /**
     * @param
     *
     */
    public void seto_auth_nichegn(String o_auth_nichegn) {
        this.o_auth_nichegn = o_auth_nichegn;
    }

    @Column(name = "xingming", length = 200)
    public String getxingming() {
        return this.xingming;
    }

    /**
     * @param
     *
     */
    public void setxingming(String xingming) {
        this.xingming = xingming;
    }


    @Column(name = "zhuce", length = 200)
    public String getzhuce() {
        return this.zhuce;
    }

    /**
     * @param
     *
     */
    public void setzhuce(String zhuce) {
        this.zhuce = zhuce;
    }


    @Column(name = "openid", length = 200)
    public String getopenid() {
        return this.openid;
    }

    /**
     * @param
     *
     */
    public void setopenid(String openid) {
        this.openid = openid;
    }
}
