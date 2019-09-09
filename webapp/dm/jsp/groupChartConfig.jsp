<%@ page contentType="text/html;charset=GBK" %>
<%@ page import="com.raq.web.view.tag.*" %>
<%@ page import="com.raq.web.view.group.*" %>
<%@ page import="com.raq.web.view.*" %>
<%@ page import="com.raq.web.view.web.*" %>
<%@ page import="com.raq.olap.model.*" %>
<%@ page import="com.raq.olap.chart.*" %>
<%@ page import="com.raq.ide.chart.edit.*" %>
<%@ page import="com.raq.ide.chart.report4.*" %>
<%@ page import="com.raq.ide.common.*" %>
<%@ page import="java.util.*" %>

<%
try{

String cp = request.getContextPath();
String pajId = request.getParameter("pajId");
Object o = session.getAttribute(pajId);
if (o == null || !(o instanceof GroupModel)) {
	out.write("未找到数据透视文件");
	return;
}
GroupModelConfig gmc = ((GroupModel)o).getGroupModelConfig();

String chartName = request.getParameter("chartName");
GroupChart4Report4 c = null;
if (chartName != null) {
	Map charts = gmc.getCharts();
	if (charts != null) {
		Iterator iter = charts.keySet().iterator();
		while (iter.hasNext()) {
			String name = iter.next().toString();
			if (name.equals(chartName)) {
				c = (GroupChart4Report4)charts.get(name);
			}
		}
	}
}
String typeName = null;
if (c != null) {
	typeName = c.getType();
}

String[] types = null;
if (BaseConfig.CHART_REPORT4) types = Report4GraphConfig.getTypes();
else types = OlapChartConfigs.getChartNames();
int selectIndex = -1;
for (int i=0; i<types.length; i++) {
	if (types[i].equals(typeName)) {
		selectIndex = i;
	}
}

if (c == null) c = new GroupChart4Report4(); 

Vector v = ChartDialog4Group.getFields(gmc, null);
%>

<html>
<head>
<title>数据透视统计图设置</title>
<link rel="stylesheet" href="<%=cp%>/dm/css/style.css" type="text/css"/>
<script type='text/javascript' src='<%=cp %>/dm/jsroot/jquery/jquery.js'></script>
<script type='text/javascript' src='<%=cp %>/dm/jsroot/jquery/jquery.ui.all.js'></script>
<script type='text/javascript' src='<%=cp %>/dm/jsroot/jquery/jquery.layout.js'></script>
<script type='text/javascript' src='<%=cp %>/dm/jsroot/jquery/jquery.blockUI.js'></script>
<script type='text/javascript' src='<%=cp%>/DMServlet?action=<%=DMServlet.ACTION_READJS%>&file=%2Fcom%2Fraq%2Fdm%2Fview%2Fcommon.js'></script>
<script>
$(document).ready(function(){
//	$("#G_revolve_div").dialog({close: function(event, ui) { setTimeout(function(){document.body.style.overflow='auto';},10); },autoOpen:false, width:290, maxWidth:290, minWidth:290, modal: true, overlay: { opacity: 0.1, background: "black" }});
});
window.$$ = function(id){return document.getElementById(id)};
function changeSgType(type) {
	if (type == 1) {
		$$('stat1').disabled = false;
		$$('enumFields').disabled = false;
		$$('seriesField').disabled = true;
		$$('valueField').disabled = true;
		$$('stat2').disabled = true;
	} else {
		$$('stat1').disabled = true;
		$$('enumFields').disabled = true;
		$$('seriesField').disabled = false;
		$$('valueField').disabled = false;
		$$('stat2').disabled = false;
	}
}

function changeStat1(){
	var enumFields = $$('enumFields');
	for (var i=0; i<enumFields.options.length; i++) {
		if (enumFields.options[i].selected) {
			$$("stat1").value = getFieldInfo(enumFields.options[i].value, null, 5);
			return;
		}
	}
}

function changeEnumFields(){
	var stat = $$("stat1").value;
	var enumFields = $$('enumFields');
	for (var i=0; i<enumFields.options.length; i++) {
		var option = enumFields.options[i];
		if (option.selected) {
			var field = getFieldInfo(option.value, null, 3);
			option.value = getFieldInfo(field, stat, 1);
			option.text = getFieldInfo(field, stat, 2);
			option.selected = true;
		}
	}
}

/**
 * @param field
 * @param operType 
 * 		1:成绩 		-> ~.sum(成绩)     
 * 		2:成绩 		-> 成绩(求和)      
 * 		3:~.sum(成绩)-> 成绩     
 * 		4:成绩(求和) 	-> 成绩
 * 		5:~.sum(成绩)-> sum
 * 		6:成绩(求和) 	-> sum
 * 		7:~.sum(成绩)-> 成绩(求和)
 */
function getFieldInfo(field, stat, operType) {
	if (operType == 1) {
		return "~." + stat + "(" + field + ")";
	}
	if (operType == 2) {
		if ("sum" == stat) stat = "求和";
		if ("max" == stat) stat = "最大";
		if ("min" == stat) stat = "最小";
		if ("avg" == stat) stat = "平均";
		if ("count" == stat) stat = "计数";
		
		return field + "(" + stat + ")";
	}
	if (operType == 3) {
		return field.substring(field.indexOf("(") + 1, field.length - 1);
	}
	if (operType == 4) {
		return field.substring(0, field.indexOf("("));
	}
	if (operType == 5) {
		return field.substring(2, field.indexOf("("));
	}
	if (operType == 6) {
		if (field.indexOf("求和") >= 0) return "sum";
		if (field.indexOf("最大") >= 0) return "max";
		if (field.indexOf("最小") >= 0) return "min";
		if (field.indexOf("平均") >= 0) return "avg";
		if (field.indexOf("计数") >= 0) return "count";
	}
	if (operType == 7) {
		return getFieldInfo(getFieldInfo(field, null, 3), getFieldInfo(field, null, 5), 2);
	}
	if (operType == 8) {
		return getFieldInfo(getFieldInfo(field, null, 3), getFieldInfo(field, null, 5), 9);
	}
	if (operType == 9) {
		if ("sum" == stat) stat = "求和";
		if ("max" == stat) stat = "最大";
		if ("min" == stat) stat = "最小";
		if ("avg" == stat) stat = "平均";
		if ("count" == stat) stat = "计数";
		
		return field + "_" + stat;
	}
	return field;
}

function saveChart(){
	var chartName = $$("chartName").value;
	if (chartName == '') {
		alert("统计图名称不能为空");
		return;
	}
	var cateField = $$("cateField").value;
	var typeName = $$("chart").value;
	var sgType = $$("sgType1").checked ? 1 : 2;
	var enumFields = "";
	var seriesField = "";
	var seriesValue = "";
	if (sgType == 1) {
		var fields = $$('enumFields');
		for (var i=0; i<fields.options.length; i++) {
			var option = fields.options[i];
			if (option.selected) {
				if (option.value.indexOf(cateField) >= 0) {
					alert("枚举“系列字段”中不能包含“分类字段”");
					return;
				}
				if (enumFields != '') enumFields += ';';
				enumFields += option.value;
			}
		}
	} else {
		seriesField = $$("seriesField").value;
		if (seriesField == cateField) {
			alert("分组“系列字段”不能与“分类字段”相同");
			return;
		}
		seriesValue = $$("valueField").value;
		if (seriesValue == seriesField) {
			alert("分组“系列字段”不能与“值字段”相同");
			return;
		}
		if (seriesValue == cateField) {
			alert("分组“值字段”不能与“分类字段”相同");
			return;
		}
		seriesValue = getFieldInfo(seriesValue, $$("stat2").value, 1);
	}

	$("#ajaxSubmitNode").load("<%=cp%>/DMServletAjax?d=" + new Date().getTime(), {action:<%=DMServlet.ACTION_GROUP_CHART%>,pajId:"<%=pajId%>",chartAction:"config",oldName:"<%=chartName==null?"":chartName%>",newName:chartName,cateField:cateField,typeName:typeName,sgType:sgType,enumFields:enumFields,seriesField:seriesField,seriesValue:seriesValue}, function(){opener.changeName("<%=chartName==null?"":chartName%>",chartName);window.close();});
}
</script>
</head>
<body onload="changeStat1();" style="font-size:12px;overflow:auto" class='page_bg1' onunload='try{opener.unBlockUI();opener.isOpen4Chart=false;opener.focus();}catch(e){}'>
<div id='ajaxSubmitNode' style='display:none'></div>
<div style='width:500px;'>
	<div style='width:490px;float:left;'>
		统计图名称
		<input type='text' style='width:410px;' id='chartName' value='<%=chartName==null?"":chartName %>'>
	</div>
</div>

<div style='clear:both;height:1px;font-size:1pt;'>&nbsp;</div>

<div style='margin:10px 0 0 0;width:500px;'>
	<div style='width:250px;float:left;'>
		分类字段　
		<select id='cateField' style='width:158px;'>
			<%
			String cateField = null;
			if (c != null) cateField = c.getCate();
			for (int i=0; i<v.size(); i++) {
			%>
			<option <%=v.get(i).toString().equals(cateField)?"selected ":""%>value='<%=v.get(i).toString()%>'><%=v.get(i).toString()%></option>
			<%
			}
			%>
		</select>
	</div>
	<div style='width:250px;float:left;'>
		统计图
		<select id='chart' style='width:185px;'>
			<%if (selectIndex == -1 && typeName != null){ %>
			<option value='<%=typeName%>'><%=typeName%></option>
			<%}
			for (int i=0; i<types.length; i++) {
			%>
			<option <%=(selectIndex>=0 && selectIndex==i)?"selected ":""%>value='<%=types[i]%>'><%=types[i]%></option>
			<%
			}
			%>
		</select>
	</div>
</div>

<div style='clear:both;height:1px;font-size:1pt;'>&nbsp;</div>

<%
%>
<div style='margin:10px 0 0 0;width:500px;'>
	<div style='width:250px;float:left;'>
		<input type='radio' name='sgType' id='sgType1'<%=(c.isEnums())?" checked":""%> onclick='changeSgType(1)'>枚举系列
	</div>
	<div style='width:250px;float:left;'>
		<input type='radio' name='sgType' id='sgType2'<%=(!c.isEnums())?" checked":""%> onclick='changeSgType(2)'>分组系列
	</div>
</div>

<div style='width:500px;'>
	<div style='border:1px solid #999;width:230px;height:200px;float:left;margin:0 20px 0 0;'>
		<div style='margin:5px;'>
			系列字段（可多选）&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<select<%=(!c.isEnums())?" disabled":"" %> id='stat1' onchange='changeEnumFields();'>
				<option value='sum'>求和</option>
				<option value='max'>最大</option>
				<option value='min'>最小</option>
				<option value='avg'>平均</option>
				<option value='count'>计数</option>
			</select>
		</div>
		<div style='margin:5px;'>
			<select multiple style='width:212px;height:160px;'<%=(!c.isEnums())?" disabled":"" %> id='enumFields' onchange='changeStat1();'>
				<%
				for (int i=0; i<v.size(); i++) {
					String currName = v.get(i).toString();
					String value = ChartDialog4Group.getFieldInfo(currName, "sum", 1);
					String disp = ChartDialog4Group.getFieldInfo(currName, "sum", 2);
					String selected = "";
	        		for (int k=0; k<c.getFields().size(); k++) {
						if (c.getFields().get(k).toString().indexOf(currName) >= 0) {
							value = c.getFields().get(k).toString();
							disp = ChartDialog4Group.getFieldInfo(value, null, 7);
							selected = " selected";
							break;
						}
	        		}
/*					if (esg != null) {
		        		for (int k=0; k<esg.count(); k++) {
		        			EnumSeriesItem esi = esg.get(k);
		        			String name = esi.getItem();
							String exp = esi.getValues()[0].getValue().toString();
							if (currName.equals(name)) {
								value = exp;
								disp = ChartDialog4Group.getFieldInfo(exp, null, 7);
								selected = " selected";
							}
		        		}
					}
*/				%>
				<option<%=selected%> value='<%=value%>'><%=disp%></option>
				<%
				}
				%>
			</select>
		</div>
	</div>
	<div style='border:1px solid #999;width:230px;height:200px;float:left;'>
		<div style='margin:30 20 20 20;'>
			系列字段
			<select<%=(c.isEnums())?" disabled":"" %> id='seriesField' style='width:100px;'>
				<%
				for (int i=0; i<v.size(); i++) {
				%>
				<option<%=(!c.isEnums()) && v.get(i).toString().equals(c.getSeries())?" selected":""%> value='<%=v.get(i).toString()%>'><%=v.get(i).toString()%></option>
				<%
				}
				%>
			</select>
		</div>
		<%
		String valueField = c.getValueField() == null ? null: ChartDialog4Group.getFieldInfo(c.getValueField(), null, 3);
		String stat = c.getStat();
		%>
		<div style='margin:20px;'>
			值字段　
			<select<%=(c.isEnums())?" disabled":"" %> id='valueField' style='width:100px;'>
				<%
				for (int i=0; i<v.size(); i++) {
				%>
				<option<%=v.get(i).toString().equals(valueField)?" selected":"" %> value='<%=v.get(i).toString()%>'><%=v.get(i).toString()%></option>
				<%
				}
				%>
			</select>
		</div>
		<div style='margin:20px;'>
			统计方式
			<select<%=(c.isEnums())?" disabled":"" %> id='stat2' style='width:100px;'>
				<option<%="sum".equals(stat)?" selected":"" %> value='sum'>求和</option>
				<option<%="max".equals(stat)?" selected":"" %> value='max'>最大</option>
				<option<%="min".equals(stat)?" selected":"" %> value='min'>最小</option>
				<option<%="avg".equals(stat)?" selected":"" %> value='avg'>平均</option>
				<option<%="count".equals(stat)?" selected":"" %> value='count'>计数</option>
			</select>
		</div>
	</div>
</div>

<div style='clear:both;height:1px;font-size:1pt;'>&nbsp;</div>

<div style='width:460px;algin:center;margin:10px 0 0 0'>
	<input type='button' onmouseover='this.style.cursor="hand"' style='background-image:url("<%=cp%>/dm/images/olap_phg_submit.gif");border:0px;width:70;height:23px;' onclick="saveChart();" value='保存设置'>
	&nbsp;&nbsp;<input type='button' onmouseover='this.style.cursor="hand"' style='background-image:url("<%=cp%>/dm/images/olap_phg_submit.gif");border:0px;width:40;height:23px;' onclick="window.close();" value='取消'>
</div>
</body>
</html>

<%
}catch(Exception e){
	e.printStackTrace();
}
%>
