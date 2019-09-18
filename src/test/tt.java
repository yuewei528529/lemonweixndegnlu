import com.mossle.dengluuser.service.dengluservice;
import com.mossle.xiangmu.persistence.domain.kemu;
import com.mossle.xiangmu.persistence.manager.kemuManager;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@RunWith(SpringJUnit4ClassRunner.class)
//告诉junit spring配置文件
@ContextConfiguration({"classpath:spring/*"})

public class tt {

    @Resource
    private dengluservice bb;
    private static  kemuManager vv;
    private static String vvvv="ddddd";

    @Test
    public  void dd() {
        bb.findbyopenid("o9RBa1P5O0lZqTgvprTCrPiiakpk").setcode("ccc");


      /*  HashMap hMap = new HashMap();
        List<Object> list1 = new ArrayList<>();
        List<Object> list = new ArrayList<>();
        list1.add("ccccc");
        list1.add("gh");
        list1.add(vvvv);
        hMap.put("ad","");*/
      //  vv.findByIds("jj");
      /*  list.add( vv.find(
                "from kemu where id like ? and xmjl like ?", "%%"
                , "%%"));*/
        System.out.println("=========");
       ;
        //vv.findUnique("from kemu where leibie= ?", "p");
/*        ((kemu)vv.findUnique(
                "from kemu where id like ? and xmjl like ?", "%1%"
                , "%小%")).gethwmc();
        ((kemu)vv.find(
                "from kemu where id like ? and xmjl like ?", "%1%"
                , "%小%").get(3)).gethwmc();


System.out.println("========="+          vv.find(
        "from kemu ").get(3));*/
    }


}
