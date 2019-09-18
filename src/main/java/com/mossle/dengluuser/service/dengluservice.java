package com.mossle.dengluuser.service;

import com.mossle.dengluuser.persistence.domain.denglu;
import com.mossle.dengluuser.persistence.manager.Denglumanager;
import com.mossle.xiangmu.persistence.domain.zijin;
import com.mossle.xiangmu.persistence.manager.zijinmanager;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class dengluservice {
    private Denglumanager denglumanager;


    @Resource
    public void setdenglumanager(Denglumanager denglumanager) {
        this.denglumanager = denglumanager;
    }




    public denglu findbyopenid(String cc){
        return denglumanager.findUniqueBy("openid", cc);
    }

    public void setcode(denglu cc){

        denglu cc1= (denglu) denglumanager.getSession().get(denglu.class,"1");
        cc1.setcode(cc.getcode());
        denglumanager.getSession().update(cc1);

        denglumanager.getSession().beginTransaction().commit();


    }
    public void del(denglu cc){
        denglumanager.remove(cc);
    }
    public void save(denglu cc) {

        denglumanager.getSession().save(cc);

        denglumanager.getSession().beginTransaction().commit();
    }


    public denglu findBycode(String cc) {
        return  denglumanager.findUniqueBy("code",cc);
    }


    public denglu existsByxingming(String cc) {
        return  denglumanager.findUniqueBy("xingming",cc);
    }

    public void setxingming(denglu cc){
          denglumanager.update(cc);
    }
    }

