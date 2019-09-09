//****************针对第一种方式的具体js实现部分******************//
//****************所使用的数据是city.js******************//

/*根据id获取对象*/

var addrShow = document.getElementById('addr-show1');
var btn = document.getElementsByClassName('met1')[0];
var prov = jQuery('#prov1');
var city = jQuery('#city1');
var country = jQuery('#country1');


/*用于保存当前所选的省市区*/
var current = {
    prov: '',
    city: '',
    country: '' 
};

/*自动加载省份列表*/
(function showProv1() {
    
    var len = provice.length;
    for (var i = 0; i < len; i++) {
        var provOpt = document.createElement('option');
        provOpt.innerText = provice[i]['name'];
        provOpt.value = i;
        document.getElementById('prov1').appendChild(provOpt);
    }
})();

/*根据所选的省份来显示城市列表*/
function showCity1(obj) {
	document.getElementById('city1').options.length = 0;
    var val = obj.options[obj.selectedIndex].value;
    if (val != current.prov) {
        current.prov = val;
        addrShow.value = '';
       // btn.disabled = true;
    }
    //console.log(val);

    if (val != null) {
        city.length = 1;
        var cityLen = provice[val]["city"].length;

        for (var j = 0; j < cityLen; j++) {
            var cityOpt = document.createElement('option');
            cityOpt.innerText = provice[val]["city"][j].name;
            cityOpt.value = j;
            document.getElementById('city1').appendChild(cityOpt);
        }
        var countryOpt1 = document.createElement('option');            
        countryOpt1.innerText = $("#city1").find("option:selected").text();
        countryOpt1.value = -1;        
        $("#country1 option:selected").text($("#city1 option:selected").text())
    }
}

/*根据所选的城市来显示县区列表*/
function showCountry1(obj) {
	document.getElementById('country1').options.length = 0;
    var val = obj.options[obj.selectedIndex].value;
    current.city = val;
    if (val != null) {
        country.length = 1; //清空之前的内容只留第一个默认选项
        var countryLen = provice[current.prov]["city"][val].districtAndCounty.length;
        if(countryLen == 0){
        	document.getElementById('addr-show').value = provice[current.prov].name + '-' + provice[current.prov]["city"][current.city].name;
            return;
        }
        var countryOpt1 = document.createElement('option');            
        countryOpt1.innerText = provice[current.prov]["city"][val]["name"];
        countryOpt1.value = -1;        
        document.getElementById('country1').appendChild(countryOpt1); 
        for (var n = 0; n < countryLen; n++) {
        	
            var countryOpt = document.createElement('option');
       
           
            countryOpt.innerText = provice[current.prov]["city"][val].districtAndCounty[n];
            countryOpt.value = n;
            document.getElementById('country1').appendChild(countryOpt);
        }
        
    }
}

/*选择县区之后的处理函数*/
function selecCountry1(obj) {
    current.country = obj.options[obj.selectedIndex].value;
    if ((current.city != null) && (current.country != null)) {
       // btn.disabled = false;
    }
}

/*点击确定按钮显示用户所选的地址*/
function showAddr1() {
	//document.getElementById('addr-show1').value = provice[current.prov].name + '-' + provice[current.prov]["city"][current.city].name + '-' + provice[current.prov]["city"][current.city].districtAndCounty[current.country];
	document.getElementById('addr-show1').value =$("#prov1").find("option:selected").text()+ '-' +$("#city1").find("option:selected").text()+ '-' +$("#country1").find("option:selected").text();
	document.getElementById('daodadidian').value=document.getElementById('addr-show1').value;
}