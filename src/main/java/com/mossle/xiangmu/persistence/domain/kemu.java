package com.mossle.xiangmu.persistence.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "kemu")
public class kemu implements java.io.Serializable {
    private static final long serialVersionUID = 0L;

    private String id;

    private String xmjc;
    private String xmjl;
    private String gys;
    private String hwmc;
    private String htze;
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

    @Column(name = "xmjc", length = 200)
    public String getxmjc() {
        return this.xmjc;
    }

    /**
     * @param
     *
     */
    public void setxmjc(String xmjc) {
        this.xmjc = xmjc;
    }
    @Column(name = "xmjl", length = 200)
    public String getxmjl() {
        return this.xmjl;
    }

    /**
     * @param
     *
     */
    public void setxmjl(String xmjl) {
        this.xmjl = xmjl;
    }


    @Column(name = "gys", length = 200)
    public String getgys() {
        return this.gys;
    }

    /**
     * @param
     *
     */
    public void setgys(String gys) {
        this.gys = gys;
    }


    @Column(name = "hwmc", length = 200)
    public String gethwmc() {
        return this.hwmc;
    }

    /**
     * @param
     *
     */
    public void sethwmc(String hwmc) {
        this.hwmc = hwmc;
    }


    @Column(name = "htze", length = 200)
    public String gethtze() {
        return this.htze;
    }

    /**
     * @param
     *
     */
    public void sethtze(String htze) {
        this.htze = htze;
    }
}
