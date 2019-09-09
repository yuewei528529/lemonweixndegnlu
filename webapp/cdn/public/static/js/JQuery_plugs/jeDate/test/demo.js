/**
 * jeDate  日期插件
 */
 
    //常规选择
    jeDate("#test04",{
    	theme:{bgcolor:"#00A1CB",pnColor:"#00CCFF"},//样式
        festival:true,
        minDate:"1900-01-01",              //最小日期
        maxDate:"2099-12-31",              //最大日期
        method:{
            choose:function (params) {
                
            }
        },
        format: "YYYY-MM-DD hh:mm:ss"
    });  
         