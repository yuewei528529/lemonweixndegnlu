package com.mossle.xiangmu.persistence.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "zijinsq")
public class zijinsq implements java.io.Serializable {
    private static final long serialVersionUID = 0L;


    private String riqi;
    private String jinji;
    private String xmjl;
    private String gys;
    private String hetongje;
    private String yifu;
    private String yifubl;
    private String shenqje;
    private String shenqbl;
    private String zhiftj;
    private String shiyou;
    private String fileupload;
    //@Id
   /* @Column(name = "ASSINGEE_")
    public String getASSINGEE_() {
        return this.ASSINGEE_;
    }

    *//**
     * @param
     *//*
    public void setASSINGEE_(String ASSINGEE_) {
        this.ASSINGEE_ = ASSINGEE_;
    }*/
    @Id
    @Column(name = "riqi")
    public String getriqi() {
        return this.riqi;
    }

    /**
     * @param
     */
    public void setriqi(String riqi) {
        this.riqi = riqi;
    }

    @Column(name = "jinji")
    public String getjinji() {
        return this.jinji;
    }

    /**
     * @param
     */
    public void setjinji(String jinji) {
        this.jinji = jinji;
    }

    @Column(name = "xmjl")
    public String getxmjl() {
        return this.xmjl;
    }

    /**
     * @param
     */
    public void setxmjl(String xmjl) {
        this.xmjl = xmjl;
    }

    @Column(name = "gys")
    public String getgys() {
        return this.gys;
    }

    /**
     * @param
     */
    public void setgys(String gys) {
        this.gys = gys;
    }

    @Column(name = "hetongje")
    public String gethetongje() {
        return this.hetongje;
    }

    /**
     * @param
     */
    public void sethetongje(String hetongje) {
        this.hetongje = hetongje;
    }

    @Column(name = "yifu")
    public String getyifu() {
        return this.yifu;
    }

    /**
     * @param
     */
    public void setyifu(String yifu) {
        this.yifu = yifu;
    }

    @Column(name = "yifubl")
    public String getyifubl() {
        return this.yifubl;
    }

    /**
     * @param
     */
    public void setyifubl(String yifubl) {
        this.yifubl = yifubl;
    }

    @Column(name = "shenqje")
    public String getshenqje() {
        return this.shenqje;
    }

    /**
     * @param
     */
    public void setshenqje(String shenqje) {
        this.shenqje = shenqje;
    }

    @Column(name = "shenqbl")
    public String getshenqbl() {
        return this.shenqbl;
    }

    /**
     * @param
     */
    public void setshenqbl(String shenqbl) {
        this.shenqbl = shenqbl;
    }


    @Column(name = "zhiftj")
    public String getzhiftj() {
        return this.zhiftj;
    }

    /**
     * @param
     */
    public void setzhiftj(String zhiftj) {
        this.zhiftj = zhiftj;
    }



    @Column(name = "shiyou")
    public String getshiyou() {
        return this.shiyou;
    }

    /**
     * @param
     */
    public void setshiyou(String shiyou) {
        this.shiyou = shiyou;
    }

    @Column(name = "fileupload")
    public String getfileupload() {
        return this.fileupload;
    }

    /**
     * @param
     */
    public void setfileupload(String fileupload) {
        this.fileupload = fileupload;
    }



}



