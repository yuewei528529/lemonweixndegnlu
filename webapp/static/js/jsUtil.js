/**
 * jquery工具类
 * 
 * 1、获取项目上下文路径
 * 
 * 2、提示框loadTip（）
 * 
 * 3、获取GET的参数值
 * 
 * 4、提示确定
 * 
 * 5、删除左右两端的空格
 * 
 * 6、检查是否带有中文及全角字符
 * 
 * 7、判断是pc还是手机
 */


//获取项目上下文路径
/*
 * 1、http://localhost:8083/GzMavenSSM,其中GzMavenSSM就是上下文路径了，如果直接是根目录，则上下文路径为/  
 * 2、如同java中获取上下文路径的${pageContext.request.contextPath}

*/
function _getRootPath(){
    //获取当前网址，如： http://localhost:8083/GzMavenSSM/share/meun.jsp
    var curWwwPath=window.document.location.href;
    //获取主机地址之后的目录，如： GzMavenSSM/share/meun.jsp
    var pathName=window.document.location.pathname;
    var pos=curWwwPath.indexOf(pathName);
    //获取主机地址，如： http://localhost:8083
    var localhostPaht=curWwwPath.substring(0,pos);
    //获取带"/"的项目名，如：/GzMavenSSM
    var projectName=pathName.substring(0,pathName.substr(1).indexOf('/')+1);
    return(localhostPaht+projectName);
}


//提示框，比alert更友好，且可以自动关闭
/*
 * 原理：创建个节点，并给节点设置css属性进而显示出来，然后到时间后删除节点达到隐藏效果。
 */
/**
 * type类型，loading是有图片，text是纯文字
 * content是文字内容
 * background是背景色，默认黑色
 * second显示的秒数，默认2.5秒
 * width:提示的宽度,不写默认300
 */
function _loadTip(type,content,background,second,width){
	
	$("#loadTip").remove();//先清除下提示，如果在ajax中beforeSend执行后，立刻执行success会让第二个出现的_loadTip被第一个覆盖显示不了，这样加个先清除，在执行success的时候就吧beforeSend的提示清空了，就不会显示不了
	
	if($("#loadTip").length <= 0){/*loadTip是下一行生成的div的id值，没有的弹出时候再弹出*/
		
		switch(type){
			case 'load'://有loading图片，无文字
				$("body").append('<div id="loadTip"><img src="'+_getRootPath()+'/static/images/loading.gif" style="width:30px;height:30px;position:relative;top:0px;" /> </div>');/* _loadTip('load','','black','80');   	 */
			break;
			case 'loading'://有loading图片，有文字
				$("body").append('<div id="loadTip"><img src="'+_getRootPath()+'/static/images/loading.gif" style="width:30px;height:30px;position:relative;top:0px;left:-8px" /> </div>');/*这是弹出框的样式，在basic.css中设置的*/
			break;
			case 'ok'://对勾图片，无文字
				$("body").append('<div id="loadTip"><img src="'+_getRootPath()+'/static/images/right.png" style="width:30px;height:30px;position:relative;top:0px;" /> '+content+'</div>');/*这是弹出框的样式，在basic.css中设置的*/
			break;
			case 'oking'://对勾图片，有文字
				$("body").append('<div id="loadTip"><img src="'+_getRootPath()+'/static/images/right.png" style="width:30px;height:30px;position:relative;top:0px;left:-8px" /> '+content+'</div>');/*这是弹出框的样式，在basic.css中设置的*/
			break;
			
			case 'text'://纯文字
				$("body").append('<div id="loadTip">'+content+'</div>');/*这是弹出框的样式，在basic.css中设置的*/		
			break;
			
			case 'none'://隐藏提示框
				//上面已执行了$("#loadTip").remove();//清除下提示
			break;
			
		}
		if(!width) width=150;
		if(!background) background='black';//默认背景色是黑色
		
		$("#loadTip").css({			 
		 'background':background,
		 'opacity': '0.5',//透明
		 'border-radius':'9px',//圆角
		 'width':width,
		 'height':'60px',
		 'line-height':'60px',
		 'text-align':'center',
		 'color':'white',
		 'font-size':'15px',
		 'position':'relative',
		 'z-index':'9999999'
		 });
			  
		//居中显示 
	    var left = ($(window).width() - $("#loadTip").outerWidth())/2;   
		var top = ($(window).height() - $("#loadTip").outerHeight())/2 +$(document).scrollTop() -100;   
		 $("#loadTip").css({
			 'position':'absolute',
			 'top':top,
			 'left': left
		 });
	
		 //自动移出节点，也就不显示了。
		if(!second) second=1500;//不写则默认2.5秒后关闭提示框
		setTimeout(function(){
			//console.log(pageNumber);
			$("#loadTip").remove();
		}, Number(second))
	} 
}
 




//jquery获取url中get参数
//使用方法：例如http://localhost:33064/WebForm2.aspx?reurl=WebForm1 ，我们要获取reurl的值，可以这样写：var xx = getUrlParam('reurl'); 
function _getUrlParam(name) {
var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
var r = window.location.search.substr(1).match(reg);  //匹配目标参数
if (r != null) return unescape(r[2]); return null; //返回参数值
}




/**
 * 提示：是否确定删除
 * ===============
 * 直接将方法复制到要使用的地方即可
 */
//function _confirm(){
//	 var statu = confirm("确定删除吗");
//     if(!statu){
//         return;
//     }
//}


//删除左右两端的空格
String.prototype.trim = function () {
	return this.replace(/^\s\s*/, '' ).replace(/\s\s*$/, '' );
};


/**
 * 检查是否带有中文及全角字符
 * @param str : 需要检查的字符串
 * @returns 
 */
function _checkSBC(str){
	var re = /[^\x00-\xff]/g;//ASCII 编码不在0-255的字符,即非中文及全角字符
	return re.test(str);
}


/*
 * 判断终端是手机还是电脑
 * @returns 手机返回false，pc返回true
 */
function _phone_Or_Pc(){
	var sUserAgent = navigator.userAgent.toLowerCase();  
	var bIsIpad = sUserAgent.match(/ipad/i) == "ipad";  
	var bIsIphoneOs = sUserAgent.match(/iphone os/i) == "iphone os";  
	var bIsMidp = sUserAgent.match(/midp/i) == "midp";  
	var bIsUc7 = sUserAgent.match(/rv:1.2.3.4/i) == "rv:1.2.3.4";  
	var bIsUc = sUserAgent.match(/ucweb/i) == "ucweb";  
	var bIsAndroid = sUserAgent.match(/android/i) == "android";  
	var bIsCE = sUserAgent.match(/windows ce/i) == "windows ce";  
	var bIsWM = sUserAgent.match(/windows mobile/i) == "windows mobile";  
	if (bIsIpad || bIsIphoneOs || bIsMidp || bIsUc7 || bIsUc || bIsAndroid || bIsCE || bIsWM) {  
		return false; //手机 
	} else {  
	    return true; 
	}  
}


/**
 * 动态创建input
 * @param _n:input的名称
 * @param _v：input的value
 * @returns 
 
createInput:function (_n,_v){
	var inp = $("<input type=\"text\" name=\""+_n+"\" value=\""+_v+"\"/>");
	return inp;
},*/

