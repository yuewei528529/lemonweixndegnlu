<%@ page contentType="text/html;charset=GBK" %>
<%@ page import="com.raq.web.view.web.*" %>
<%@ page import="com.raq.web.view.*" %>
<%@ page import="java.util.*" %>

<%
	String cp = request.getContextPath();
	
	ExploreTree et = new ExploreTree(request);
	String olapId = request.getParameter("olapId");
	String pajId = request.getParameter("pajId");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html>
	<head>
		<title>��Ǭ����</title>
		<link rel="stylesheet" href="<%=cp%>/dm/css/style.css" type="text/css"/>
		<script type="text/javascript" src="<%=cp%>/dm/jsroot/jquery/jquery.js"></script>
		<script type="text/javascript" src="<%=cp%>/dm/jsroot/jquery/jquery.ui.all.js"></script>
		<script type="text/javascript" src="<%=cp%>/dm/jsroot/jquery/jquery.layout.js"></script>
		<script type="text/javascript" src="<%=cp%>/dm/jsroot/jquery/jquery.blockUI.js"></script>
		<script type='text/javascript' src='<%=cp%>/DMServlet?action=<%=DMServlet.ACTION_READJS%>&file=%2Fcom%2Fraq%2Fweb%2Fview%2Fio.js'></script>
		<script type='text/javascript' src='<%=cp%>/DMServlet?action=<%=DMServlet.ACTION_READJS%>&file=%2Fcom%2Fraq%2Fweb%2Fview%2Fcommon.js'></script>
		
		<script type="text/javascript">
			var beforeSelectNode; // ǰһ��ѡ�е����ڵ㡣ѡ������ʱ������ڵ���ʽ�������
			var operTypeNode; // ����ģʽ:group,olap
			var topLayout;
			var innerLayout;
			var currMainPageType = 0; // 0��������͸�Ӻͽ��������  1������͸�ӣ�  2���������
			var olapId; //��ҳ�����򿪵�olap������session�е�ID
			<%if (olapId != null){%>olapId='<%=olapId%>';<%}%>
			<%if (pajId != null){%>pajId='<%=pajId%>';<%}%>
			var contextPath = '<%=request.getContextPath()%>';
			var $$ = function( sid ) { return document.getElementById( sid ); };
			$(document).ready(function(){
		 		topLayout = $('body').layout({
		 			resizable: false
					, spacing_open:			7  // ALL panes
					, spacing_closed:			7 // ALL panes
		 			, north: {
						size: "69"
						, resizable : false
						, onopen : "innerLayout.resizeAll"
						, onclose : "innerLayout.resizeAll"
					}
				});

		 		innerLayout = $('#innerLayout').layout({
					center__paneSelector:	".uiLayoutRight" 
				,	west__paneSelector:		".uiLayoutLeft" 
				,	spacing_open:			7  // ALL panes
				,	spacing_closed:			7 // ALL panes
				});
				
				//document.onselectstart=function(event){return event.srcElement.tagName=='INPUT'}//����ѡ���ı�
				changeOpertype($("#operType_group")[0]);
				
				$("#pwdDialog").dialog({ autoOpen:false, width:290, height: 180, maxWidth:290, maxHeight:180, minWidth:290, minHeight:180, modal: true, overlay: { opacity: 0.1, background: "black" }});
				$("#expsDialog").dialog({ autoOpen:false, width:800, height: 400, maxWidth:800, maxHeight:400, minWidth:800, minHeight:400, modal: true, overlay: { opacity: 0.1, background: "black" }});
			});
			
			function showMain(jump){ // ����ȫ�ֱ�����beforeSelectNode��operTypeNode
				if (beforeSelectNode == null || operTypeNode == null) return;
				if (beforeSelectNode.getAttribute("type") == <%=ExploreTreeNode.TYPE_DATA_SUB_SERIES%>) {
					if (!jump) return;
					var ids = beforeSelectNode.getAttribute("nodeId").split(":");
					var pageName = "<%=cp%>/dm/jsp/groupSave.jsp?oper=openSeries&";
					if (operTypeNode.id.indexOf("olap") != -1) pageName = "<%=cp%>/dm/jsp/cubeAxisDefine.jsp?";
					canSave(0);
					$("#mainFrame")[0].src = pageName + "file=" + ids[0] + "&entry=" + ids[1] + "&d=" + new Date().getTime();
				} else if (beforeSelectNode.getAttribute("type") == <%=ExploreTreeNode.TYPE_CONSTANT%>) {
					var id = beforeSelectNode.id.replace('id_', '');
					et_t_ic($('#_img2_'+id)[0], $('#_div_'+id)[0]);
				} else if (beforeSelectNode.getAttribute("type") == <%=ExploreTreeNode.TYPE_CONSTANT_SUB%>) {
					if (!jump) return;
					var id = beforeSelectNode.getAttribute("nodeId");
					var pageName = "<%=cp%>/dm/jsp/groupSave.jsp?oper=openSeries&";
					if (operTypeNode.id.indexOf("olap") != -1) pageName = "<%=cp%>/dm/jsp/cubeAxisDefine.jsp?";
					canSave(0);
					$("#mainFrame")[0].src = pageName + "expName=" + id + "&d=" + new Date().getTime();					
				} else if (beforeSelectNode.getAttribute("type") == <%=ExploreTreeNode.TYPE_DATA%>) {
					var id = beforeSelectNode.id.replace('id_', '');
					et_t_ic($('#_img2_'+id)[0], $('#_div_'+id)[0]);
				} else if (beforeSelectNode.getAttribute("type") == <%=ExploreTreeNode.TYPE_DATA_SUB%>) {
					var id = beforeSelectNode.id.replace('id_', '');
					et_t_ic($('#_img2_'+id)[0], $('#_div_'+id)[0]);
				} else if (beforeSelectNode.getAttribute("type") == <%=ExploreTreeNode.TYPE_MATRIX%>) {
					var id = beforeSelectNode.id.replace('id_', '');
					et_t_ic($('#_img2_'+id)[0], $('#_div_'+id)[0]);
				} else if (beforeSelectNode.getAttribute("type") == <%=ExploreTreeNode.TYPE_MATRIX_SUB%>) {
					window.open("<%=cp%>/dm/jsp/setMatrix.jsp?mtx=" + escape(beforeSelectNode.innerHTML), "newWindow", "height=470, width=520, toolbar= no, menubar=no, scrollbars=no, resizable=no, location=no, status=no,left=" + (screen.width - 520)/2 + ",top=" + (screen.height - 470)/2);
				} else if (beforeSelectNode.getAttribute("type") == <%=ExploreTreeNode.TYPE_PARAM%>) {
					var id = beforeSelectNode.id.replace('id_', '');
					et_t_ic($('#_img2_'+id)[0], $('#_div_'+id)[0]);
				} else if (beforeSelectNode.getAttribute("type") == <%=ExploreTreeNode.TYPE_PARAM_SUB%>) {
					var id = beforeSelectNode.getAttribute("nodeId");
					$("#mainFrame")[0].src = "<%=cp%>/dm/jsp/param.jsp?paramName=" + id + "&d=" + new Date().getTime();
				} else if (beforeSelectNode.getAttribute("type") == <%=ExploreTreeNode.TYPE_OLAP%>) {
					var id = beforeSelectNode.id.replace('id_', '');
					et_t_ic($('#_img2_'+id)[0], $('#_div_'+id)[0]);
				} else if (beforeSelectNode.getAttribute("type") == <%=ExploreTreeNode.TYPE_OLAP_SUB%>) {
					//canSave(0);
					var id = beforeSelectNode.getAttribute("nodeId");
					clearSession();
					olapId = "olap" + (new Date().getTime());
					$("#mainFrame")[0].src = "<%=cp%>/dm/jsp/olapSave.jsp?oper=openCommonFile&fileName=" + id + "&d=" + new Date().getTime() + "&olapId=" + olapId;
				} else if (beforeSelectNode.getAttribute("type") == <%=ExploreTreeNode.TYPE_GROUP%>) {
					var id = beforeSelectNode.id.replace('id_', '');
					et_t_ic($('#_img2_'+id)[0], $('#_div_'+id)[0]);
				} else if (beforeSelectNode.getAttribute("type") == <%=ExploreTreeNode.TYPE_GROUP_SUB%>) {
					//canSave(0);
					var id = beforeSelectNode.getAttribute("nodeId");
					pajId = "paj" + (new Date().getTime());
					$("#mainFrame")[0].src = "<%=cp%>/dm/jsp/groupSave.jsp?oper=openCommonFile&fileName=" + id + "&d=" + new Date().getTime() + "&pajId=" + pajId;
				}
			}

			/****************��***************/
			function initTree() {
				$('.treeLabel').click(function(){
					if (beforeSelectNode) {
						beforeSelectNode.style.backgroundImage = '';
					}
					this.style.backgroundImage='url("<%=cp%>/dm/images/tree_but_back.gif")';
					beforeSelectNode = this;
					showMain(false);
				}).mouseover(function(){
					this.style.cursor = 'pointer';
					this.style.color = '#FF0000';
				}).mouseout(function(){
					this.style.color = '#000000';
				});
			}
			function et_t_ic(img, div) { // ���ڵ�չ������£������
				if (img.src.indexOf('treenode_close.gif') >= 0) {
					img.src = img.src.replace('treenode_close.gif', 'treenode_open.gif');
					if (div) div.style.display = 'none';
				} else if (img.src.indexOf('treenode_open.gif') >= 0) {
					img.src = img.src.replace('treenode_open.gif', 'treenode_close.gif');
					if (div) div.style.display = 'block';
				}
			}
			
			function blockUI() {
				$.blockUI({
					message:'<img src="<%=cp%>/dm/images/loading.gif" /><span style="font-size:12px">���Ե�...</span>',
					css: { 
				        width:          '120px',
				        top:            '10', 
				        left:          	'90%', 
				        textAlign:      'left', 
				        border:         '1px solid #aaa'
					},
				    overlayCSS:  { 
				        opacity:        '0.2' 
				    },
				    fadeOut:  100,
				    centerX: false,
				    centerY: false
				});
			}

			var isOpen4PHG = false;
			function blockUI2() {
				$.blockUI({
					message:'',
					css: { 
				        width:          '0px',
				        top:            '10', 
				        left:          	'90%', 
				        textAlign:      'left', 
				        border:         '0px solid #aaa'
					},
				    overlayCSS:  { 
				        opacity:        '0.0' 
				    },
				    fadeOut:  100,
				    centerX: false,
				    centerY: false
				});
				isOpen4PHG = true;
				//window.blur();
			}

			function unBlockUI() {
				//if (true) return;
				$.unblockUI();
				isOpen4PHG = false;
			}
			
			function changeOpertype(node) {
				operTypeNode = node;
				showMain(true);
			}
			function doSave(me) {
				if (me.disabled || currMainPageType == 0) return;
				if (currMainPageType == 2) top.mainFrame.saveOlap();
				else top.mainFrame.saveGroup();
			}
			
			function doOpen(flag) {
				if (flag == 2) openOlap();
				else openGroup();
				//canSave(0);
			}
			
			function recalculate() {
				if (beforeSelectNode!=null && beforeSelectNode.getAttribute("type") == <%=ExploreTreeNode.TYPE_CONSTANT_SUB%>) {
					top.blockUI();
					$("#notExistNode").load("<%=cp%>/DMServletAjax?d=" + new Date().getTime(), {action:7,name:beforeSelectNode.nodeId}, function(){});
					top.unBlockUI();
					alert('���¼��㳣���ɹ���');
				} else {
					alert("����ѡ��һ��������");
				}
			}
			function modifyPwd(){
				$('#oldPwd')[0].value='';
				$('#newPwd1')[0].value='';
				$('#newPwd2')[0].value='';
				$('#pwdDialog').dialog('open');
			}
			function submitNewPwd() {
				var old = $('#oldPwd')[0].value;
				var new1 = $('#newPwd1')[0].value;
				var new2 = $('#newPwd2')[0].value;
				if (new1 != new2) {
					alert(new1 + "��������������벻һ�£�" + new2);
					return;
				}
				top.blockUI();
				$("#notExistNode").load("<%=cp%>/DMServletAjax?d=" + new Date().getTime(), {action:8,old:old,'new':new1}, function(){});
				top.unBlockUI();
			}
			
			function canSave(type) {
				currMainPageType = type;
				$("#saveButton")[0].disabled=(type == 0);
				$("#saveExcel")[0].disabled=(type == 0);
			}
			
			function doSaveExcel() {
				if (currMainPageType == 2) top.mainFrame.saveOlapAsExcel();
				else top.mainFrame.saveGroupAsExcel();
			}
			
			function setOlapAxis() {
				window.open ("<%=cp%>/dm/jsp/define.jsp", "newwindow", "height=400, width=650, toolbar= no, menubar=no, scrollbars=no, resizable=no, location=no, status=no,top=100,left=300");
			}
			function checkModelDialog() {
				if(isOpen4PHG){
					try {window.mainFrame.newWindow.focus();} catch(e) {}
				}
			}
			function resiezeTree(){
				$(".uiLayoutTree")[0].style.height=(document.body.offsetHeight - 110) + "px";
			}
			
			function afterOpenGroup(pajId, name){
				$("#mainFrame")[0].src='<%=cp%>/dm/jsp/group.jsp?pajId=' + pajId;
				if (name) refreshCurrName(name);
			}
			
			function afterOpenOlap(olapId, name){
				$("#mainFrame")[0].src='<%=cp%>/dm/jsp/olap.jsp?olapId=' + olapId + '&window=0';
				if (name) refreshCurrName(name);
			}
			
			var currName = "";
			function refreshCurrName(name) {
				currName = name;
				$('#currFileName')[0].innerHTML = name;
			}
			
			function logout(){
				$("#notExistNode").load("<%=cp%>/DMServletAjax?d=" + new Date().getTime(), {action:100}, function(){});
			}
			
			function showOlap(id) {
				olapId = id;
				$$("mainFrame").src = "<%=cp%>/dm/jsp/olap.jsp?olapId=" + id;
			}
		</script>
	</head>
	<body style="height: 100%; width: 100%; margin:0; padding:0; font-size:12px" onfocus='checkModelDialog();' onbeforeunload='logout();clearSession();'>
		<div><iframe name="execFrame" id="execFrame" height="100" width="100"></iframe></div>
		<div id="notExistNode" style="display:none"></div>
		<div style="display:none;">
			<div id="pwdDialog" title="�޸�����" style="font-size:12px">
				<center>
					�������룺<input id="oldPwd" type="password"><br>
					�������룺<input id="newPwd1" type="password"><br>
					�������룺<input id="newPwd2" type="password"><br><br><br>
					<input style='width:48px;height:25px;border:0px;background-image:url("<%=request.getContextPath()%>/dm/images/btn_bg.png")' type=button value=�ύ onclick="submitNewPwd();">
					<input style='width:48px;height:25px;border:0px;background-image:url("<%=request.getContextPath()%>/dm/images/btn_bg.png")' type=button value=ȡ�� onclick="$('#pwdDialog').dialog('close')">
				</center>
			</div>
			<div id='expsDialog' title='�������' style='font-size:12px'>
				<div style='width:770px;height:250px;overflow:auto;'>
					<table id='expTable' cellspacing='1px' cellpadding='1px' border='1px' style='width:710px;border: 1px solid #ccc; border-collapse: collapse;table-layout:fixed;'>
						<tr>
							<td style='width:170px;height:28px;' align='center'>�������ʽ</td>
							<td style='width:140px;' align='center'>����</td>
							<td style='width:90px;' align='center'>��/б/�»���</td>
							<td style='width:60px;' align='center'>��ɫ</td>
							<td style='width:70px;' align='center'>������ɫ</td>
							<td style='width:130px;' align='center'>ʾ������</td>
							<td style='width:50px;' align='center'>ɾ��</td>
						</tr>
					</table>
				</div>
				<div id='expParams' style='width:770px;height:60px;overflow:auto;margin:10px 0 0 0'>���ò�����<a href='#'>��ǰ��ֵ(x)</a>&nbsp;&nbsp;<a href='#'>���۶�-���-����ֵ(x1)</a>&nbsp;&nbsp;<a href='#'>���۶�-���-����ֵ(x1)</a>&nbsp;&nbsp;<a href='#'>���۶�-���-����ֵ(x1)</a><br>����������<a href='#'>���۶�-���-����ֵ(x1)</a>&nbsp;&nbsp;<a href='#'>���۶�-���-����ֵ(x1)</a>&nbsp;&nbsp;<a href='#'>���۶�-���-����ֵ(x1)</a>&nbsp;&nbsp;<a href='#'>���۶�-���-����ֵ(x1)</a></div>
				<center>
					<div id=colorListDiv style='position:absolute;display:none;border:1px solid #C0C0C0'></div>
					<input style='width:48px;height:25px;border:0px;background-image:url("<%=request.getContextPath()%>/dm/images/btn_bg.png")' type=button value=���� onclick='addExp();'>
					<input style='width:48px;height:25px;border:0px;background-image:url("<%=request.getContextPath()%>/dm/images/btn_bg.png")' type=button value=ȷ�� onclick='submitExps();'>
					<input style='width:48px;height:25px;border:0px;background-image:url("<%=request.getContextPath()%>/dm/images/btn_bg.png")' type=button value=ȡ�� onclick="$('#expsDialog').dialog('close')">
				</center>
			</div>
		</div>
		
		<div class="ui-layout-north" style="border:0;background-image:url('<%=cp%>/dm/images/top.gif');background-repeat:no-repeat;overflow:hidden;background-color:#B7D5F1">
			<div style='position:absolute;right:7px;top:40px;width:540px;height:29px;'>
				<div style='float:left;overflow:hidden;margin:10px 10px 0 0;width:100px;' id='currFileName'></div>
				<div style='float:right;width:355px;height:29px;background-image:url("<%=cp%>/dm/images/top_mid.gif")'>
					<div style='width:100%;height:22px;margin:7px 0 0 0;'>
						<span onmouseout='this.style.backgroundImage="";' onmouseover='this.style.backgroundImage="url(\"<%=cp%>/dm/images/but_over_80.gif\")";' style='background-repeat:no-repeat;cursor:pointer;height:24px;margin:2px 3px 1px 5px;padding:2px 3px 1px 5px;' id="openButton1" title='���Ѵ��ڵġ�����͸�ӡ��ļ���' onclick="doOpen(1);">������͸��</span>
						<span onmouseout='this.style.backgroundImage="";' onmouseover='this.style.backgroundImage="url(\"<%=cp%>/dm/images/but_over_80.gif\")";' style='background-repeat:no-repeat;cursor:pointer;height:24px;margin:2px 3px 1px 5px;padding:2px 3px 1px 5px;' id="openButton2" title='���Ѵ��ڵġ�����������ļ���' onclick="doOpen(2);">�򿪽������</span>
						<span onmouseout='this.style.backgroundImage="";' onmouseover='this.style.backgroundImage="url(\"<%=cp%>/dm/images/but_over_32.gif\")";' style='background-repeat:no-repeat;cursor:pointer;height:24px;margin:2px 3px 1px 5px;padding:2px 3px 1px 5px;' disabled id="saveButton" title='�ѵ�ǰ�ġ�����͸�ӡ����浽�������ļ��С�' onclick="doSave(this);">����</span>
						<!--
						<span onmouseout='this.style.backgroundImage="";' onmouseover='this.style.backgroundImage="url(\"<%=cp%>/dm/images/but_over_68.gif\")";' style='background-repeat:no-repeat;cursor:pointer;height:24px;margin:2 3 1 5;padding:2 3 1 5;' title='���Դ򿪡��ر�������ļ���ֻ�д򿪵�������ļ��еġ������������������Ż���ʾ�����ڵ��С�' onclick="chooseSpace();">���������</span>
						 -->
						<span onmouseout='this.style.backgroundImage="";' onmouseover='this.style.backgroundImage="url(\"<%=cp%>/dm/images/but_over_62.gif\")";' style='background-repeat:no-repeat;cursor:pointer;height:24px;margin:2px 3px 1px 5px;padding:2px 3px 1px 5px;' disabled id="saveExcel" onclick="doSaveExcel();">����EXCEL</span>
					</div>
				</div>
				<div style='float:right;width:6px;height:29px;background-image:url("<%=cp%>/dm/images/top_left.gif")'></div>
			</div>
			<div style='position:absolute;;top:48px;right:10px;cursor:pointer;height:16px;width:16px;background-image:url("<%=cp%>/dm/images/hide_top.gif");' onclick="topLayout.close('north');">&nbsp;</div>
			<div style='position:absolute;width:7px;top:0;right:0;height:69px;background-image:url("<%=cp%>/dm/images/top_right.gif")'></div>
			<div onmouseout='this.style.backgroundImage="";' onmouseover='this.style.backgroundImage="url(\"<%=cp%>/dm/images/but_over.gif\")";' style='z-index:100;position:absolute;width:70px;top:0;right:10px;height:16px;cursor:pointer;'>
				<div style='float:left;width:16px;height:16px;background-image:url("<%=cp%>/dm/images/modify_pw.gif");background-repeat:no-repeat;'></div>
				<div style='float:left;padding:2px 1px 0 4px;' onclick="modifyPwd();">�޸�����</div>
				<!-- 
				<div style='float:left;padding:2px 1px 0 4px;' onclick="$('#expsDialog').dialog('open');initExps('x4 < 100000:����_GB2312<p>1<p>1<p>1<p>-16776961<p>-3355444 ;����<p>1<p>1<p>1<p>-65536<p>-3342388', '���۶�-���-����ֵ(x1),���۶�-���-����ֵ(x1),���۶�-���-����ֵ(x1),���۶�-���-����ֵ(x1),���۶�-���-����ֵ(x1),���۶�-���-����ֵ(x1),���۶�-���-����ֵ(x1),���۶�-���-����ֵ(x1),���۶�-���-����ֵ(x1)');">�����������</div>
				-->
			</div>
		</div>

		<div style="width:100%;border:0px;" id="innerLayout" class="ui-layout-center">
			<div style="width:100%;border:0;" class="uiLayoutLeft" onresize='resiezeTree();'>
				<div style='width:100%;height:27px;background-image:url("<%=cp%>/dm/images/but_back_back.png");'>
					<div style='float:left;width:49%;height:27px;background-image:url("<%=cp%>/dm/images/but_back.png");'><table style='width:100%;height:100%;'><tr><td align='center'><span id="operType_group" onclick="changeOpertype(this);" title='ѡ�е����ݿ齫���С�����͸�ӡ���' onmouseout='this.style.backgroundImage="";' onmouseover='this.style.backgroundImage="url(\"<%=cp%>/dm/images/but_over_72.gif\")";' style='background-repeat:no-repeat;cursor:pointer;height:20px;padding:4px 10px 2px 10px;font-size:12px;'>&nbsp;</span></td></tr></table></div>
					<div style='float:right;width:50%;height:27px;background-image:url("<%=cp%>/dm/images/but_back.png");'><table style='width:100%;height:100%;'><tr><td align='center'><span id="operType_olap"" style='background-repeat:no-repeat;height:20;padding:4px 10px 2px 10px;font-size:12px;'>&nbsp;</span></td></tr></table></div>
				</div>
				<div style="width:100%;" class="uiLayoutTree page_bg2"><%=et.generateHtml()%></div>
			</div>
	
			<iframe id="mainFrame"<%if (olapId != null){%> src="<%="olap.jsp?olapId=" + olapId%>"<%}else if (pajId != null) {%> src="<%="group.jsp?pajId=" + pajId%>"<%} else {%> src="blank.jsp"<%}%> name="mainFrame" class="uiLayoutRight" style="padding:0px;border:0px"
				frameborder="0" scrolling="auto"
				>adsaf</iframe>
		</div>
		<div style="display:none"><iframe name="clearFrame" id="clearFrame" height="100px" width="100px" /></div>
	</body>
</html>


