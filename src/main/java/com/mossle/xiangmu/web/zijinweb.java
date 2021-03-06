package com.mossle.xiangmu.web;

import com.mossle.xiangmu.persistence.manager.kemuManager;
import com.mossle.xiangmu.persistence.manager.zijinmanager;
import com.mossle.xiangmu.persistence.manager.zijinsqmanager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("zijin")
public class zijinweb {

    @Autowired
    private kemuManager cc;
    @Autowired
    private zijinsqmanager dd;
    private static List ccc;

    @RequestMapping("xmjc")
    @ResponseBody
    public Object input() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String name = auth.getName(); //主体名，即登录用户名
        System.out.println(name);//saysky 或 anonymousUser
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("records", "1000000");
        resultMap.put("page", "6");
        resultMap.put("total", "6");

        //return cc.find("  from kemu group by xmjc");
        resultMap.put("rows", cc.find(
                "  from kemu group by xmjc"));

        return resultMap;
    }
    @RequestMapping("zjsq")
    @ResponseBody
    public Object zjsq() {
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("records", "1000000");
        resultMap.put("page", "6");
        resultMap.put("total", "6");

        //return cc.find("  from kemu group by xmjc");
        resultMap.put("rows", dd.find(
                "  from zijinsq group by EXECUTION_ID_"));

        return resultMap;
    }

    @RequestMapping("gys")
    @ResponseBody
    public Object input2(String xmjc) {
        return cc.find(
                "  from kemu where xmjc like ? group by gys ", xmjc);

    }

    @RequestMapping("htze")
    @ResponseBody
    public Object input1(String xmjc, String gys) {
        return cc.find(
                "  from kemu where xmjc = ? and gys = ?", xmjc, gys);

    }



}
