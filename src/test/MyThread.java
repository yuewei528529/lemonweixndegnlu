import org.junit.Test;

public class MyThread extends Thread {  //继承Thread

    MyThread(String name){

        super(name);

    }
    public MyThread(){}

//复写其中的run方法
@Test
    public void run() {

        for (int i = 1; i <= 20; i++) {
            try {
                sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println(Thread.currentThread().getName() + ",i=");


        }
    }}

