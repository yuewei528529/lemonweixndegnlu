package com.mossle.xiangmu.service;

import com.mossle.travel.persistence.manager.TravelRequestManager;
import com.mossle.travel.service.TravelBpmService;
import com.mossle.xiangmu.persistence.manager.zijinmanager;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;


@Service
public class zijinservice {
    private static Logger logger = LoggerFactory
            .getLogger(zijinservice.class);

    private zijinmanager zijin;


    public Object findbyid(long id){
        return zijin.getAll();
    }
    @Resource
    public void setzijinmanager(zijinmanager zijin) {
        this.zijin = zijin;
    }
}
