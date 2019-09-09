/**
	json格式的网格数据结构
	{
		rowHeight : [25, 25],	//行高
		colWidth : [80, 80, 80],//列宽
		topH : 1,				//上表头行数
		topFix : 1,				//是否固定上表头. 0/1
		leftH : 1,				//左表头行数
		leftFix : 0,			//是否固定左表头. 0/1
		css : ["color:red", "color:blue;font-size:13px"],		// 公用样式定义，cell里面的css指定该数组的下标。
		newCss : 1,           // 插入的行和列单元格的样式，没有就不设置
		// 二维数组定义数据，[行数][列数]，每个元素为一个单元格的定义。非主格的合并格要留出位置来。
		// 单元格定义：{v:真实值, disV:显示值, style:该单元格特有的风格, css:公用样式的下表, editStyle:编辑风格定义, rowSpan:行跨度, colSpan:列跨度, f:显示格式（format）}
		data : [
				[{v:"1", style:"", css:2}, {v:"1", style:"", css:2}, {v:"1", style:"", css:2}], 
				[{v:"1", style:"", css:2}, {v:"1", style:"", css:2}, {v:"1", style:"", css:2}]
			   ]
	}
**/ 
var userAgent = navigator.userAgent.toLowerCase();
var browser = {
	IE : userAgent.indexOf('msie') >= 0,
	FF : userAgent.indexOf('firefox') >= 0,
	SF : userAgent.indexOf('webkit') >= 0, //safari
	OP : userAgent.indexOf('opera') >= 0
}
var raqGrid = {
	div : null,
	json : null,
	div1 : null, //左上
	div2 : null, //右上
	div3 : null, //左下
	div4 : null, //右下
	selectCells : new Array(),
	start : null, //开始选择的点
	selectHint : null, //选择单元格时表示选择区域的div
	sizeDiv : null,  //改变行高,列宽的div
	sizeTD : null, //要改变行高,列宽的TD
	sizeBegin : false, //是否正在拖拽。
	newCss : null,
	titleCss : null,
	copyTD : null, // 复制的TD，目前仅支持一个单元格
	cache : {
		cmTD : null,
		tds : new Array(),
		tds1 : new Array(),
		tds2 : new Array(),
		tds3 : new Array(),
		tds4 : new Array(),
		selectedTds : new Array()
	},
	init : function(div, json, w, h) {
		this.div = $$(div);
		this.json = eval(json);
		var firstRow = new Array(1 + this.json.data[0].length);
		
		// add headers data
		firstRow[0] = {css:this.json.css.length,v:'&nbsp;'};
		for (var i=1; i<firstRow.length; i++) {
			firstRow[i] = {css:(this.json.css.length + 1), disV:chars[i]};
		}
		this.json.data = new Array(firstRow).concat(this.json.data);
		for (var i=1; i<this.json.data.length; i++) {
			this.json.data[i] = new Array({css:(this.json.css.length + 1), disV:i}).concat(this.json.data[i]);
			for (var j=1; j<this.json.data[i].length; j++) {
				if (this.json.data[i][j]) this.json.data[i][j].id = chars[j] + i;
			}
		}
		this.json.rowHeight = new Array("25").concat(this.json.rowHeight);
		this.json.colWidth = new Array("40").concat(this.json.colWidth);
		this.newCss=(this.json.newCss==null?null:("commonCss"+this.json.newCss));
		
		// generate dom objects
		this.generate();

/*
		var tds = this.cache.tds;
		for (var i=0; i<tds.length; i++) {
			var td = tds[i];
			if (!td) continue;
			td.childNodes[0].style.width = td.offsetWidth - 4 + "px";
		}
*/
		this.adjustSize(w, h);
	},
	
	generate : function() {
		this.div.innerHTML = "";
		
		// add css node、the four parts of data table、select hint div.
		this.div.appendChild(this.getCsss());
		var table = document.createElement("table");
		table.cellspacing = 0;
		table.cellpadding = 0;
		table.style.borderCollapse = 'collapse';
		var tr = table.insertRow(-1);
		var td = tr.insertCell(-1);
		td.style.padding = 0;
		td.appendChild(this.getDiv1());
		td = tr.insertCell(-1);
		td.align = 'left';
		td.style.padding = 0;
		td.appendChild(this.getDiv2());
		tr = table.insertRow(-1);
		td = tr.insertCell(-1);
		td.style.padding = 0;
		td.appendChild(this.getDiv3());
		td.style.verticalAlign = 'top';
		td = tr.insertCell(-1);
		td.align = 'left';
		td.style.verticalAlign = 'top';
		td.style.padding = 0;
		td.appendChild(this.getDiv4());
		this.div.appendChild(table);
		
		this.selectHint = document.createElement("div");
		this.selectHint.style.display = 'none';
		this.selectHint.style.position = 'absolute';
		this.selectHint.style.zIndex = '10000';
		this.selectHint.style.backgroundColor = 'transparent';
		this.selectHint.style.border = '1px dotted black';
		if (browser.FF) this.selectHint.style.MozUserSelect = 'none';
		else this.selectHint.onselectstart=function(){return false;};
		this.selectHint.id = 'selectHint';
		this.selectHint.style.fontSize='1px';
		this.div.appendChild(this.selectHint);
		
		this.sizeDiv = document.createElement("div");
		this.sizeDiv.style.display = 'none';
		this.sizeDiv.style.position = 'absolute';
		this.sizeDiv.style.zIndex = '10000';
		this.sizeDiv.style.backgroundColor = 'transparent';
		this.sizeDiv.id = 'changeSizeDiv';
		this.sizeDiv.style.fontSize='1px';
		this.div.appendChild(this.sizeDiv);

		var styleDialog = document.createElement("div");
		styleDialog.style.display = 'none';
		styleDialog.id = 'styleDialog';
		styleDialog.innerHTML = styleHtml;
		document.body.appendChild(styleDialog);
		window.frames[ "colorFrame" ].document.write( colorFrameStr );
		window.frames[ "colorFrame" ].document.close();
		Popup(styleDialog);

		/* register events */
		// forbid selection
		if (browser.FF) this.div.style.MozUserSelect = 'none'; 
		else this.div.onselectstart=function(){return false;};
		
		var et = this.div4.childNodes[0];
		
		addEvent(document.body, "mousemove",this.mousemove);
		addEvent(document.body, "mouseup",this.mouseup);
		addEvent(this.div, "mousedown",function(e){ // 开始选择
			if (raqGrid.sizeBegin) return; 
			var src = e.target?e.target:e.srcElement;
			src = getParent(src, "TD");
			if (!src) return;
			if (e.button == 2 && src && src.style && src.style.backgroundColor != '') return;
			if (src.childNodes[0] == raqGrid.div1 || src.childNodes[0] == raqGrid.div2 || src.childNodes[0] == raqGrid.div3 || src.childNodes[0] == raqGrid.div4) return;
			raqGrid.start = [e.clientX, e.clientY];
			raqGrid.drawSelectHint(e.clientX, e.clientY, e.clientX, e.clientY, e.ctrlKey, true);
		});
		addEvent(this.sizeDiv, "mousedown",function(e){ // 开始改变行高，列宽。
			raqGrid.sizeBegin = true;
		});

		var keyupFunc = function(e){
			if (e.ctrlKey && e.keyCode != 17) {
				if (e.keyCode == 67) { // C
					raqGrid.doCopy();
				} else if(e.keyCode == 86) { // V
					raqGrid.doPasty();
				}
				return;
			}
			if ($$("contextMenu") && $$("contextMenu").style.display == 'block') {
				if (e.keyCode == 67) {  // C
					raqGrid.doCopy();
				} else if(e.keyCode == 80) { // P
					raqGrid.doPasty();
				} else if(e.keyCode == 84) { // T
					raqGrid.setStyle(raqGrid.cache.cmTD);
				} else if(e.keyCode == 82) { // R
					raqGrid.insertRow(raqGrid.cache.cmTD);
				} else if(e.keyCode == 65) { // A
					raqGrid.appendRow(raqGrid.cache.cmTD);
				} else if(e.keyCode == 68) { // D
					raqGrid.deleteRow(raqGrid.cache.cmTD);
				} else if(e.keyCode == 76) { // L
					raqGrid.insertCol(raqGrid.cache.cmTD);
				} else if(e.keyCode == 90) { // Z
					raqGrid.appendCol(raqGrid.cache.cmTD);
				} else if(e.keyCode == 83) { // S
					raqGrid.deleteCol(raqGrid.cache.cmTD);
				} else {
					return;
				}
				$$("contextMenu").style.display = 'none';
			}
		};
		if (browser.IE) {
			addEvent(this.div, "keyup", keyupFunc);
		} else {
			window.onkeydown=keyupFunc;
		}
		addEvent(this.div, "contextmenu", function(e){
			e.cancelBubble=true;
			// 检查区域，不同的区域显示不同的右键菜单。
			var src = e.target?e.target:e.srcElement;
			var x = e.clientX;
			var y = e.clientY;
			var td = getParent(src, "TD");
			if (td == null) return;
			raqGrid.cache.cmTD = td;
			var tr = getParent(td, "TR");
			var table = getParent(tr, "TABLE");
			var menus = new Array();
			var funcs = new Array();
			if (table ) {
				// TODO ,检测选中情况, 判断是否可以"复制"、"粘贴"。
				if (td.style.backgroundColor=='yellow') {
					menus.push("复制（C）");
					funcs.push(function(){
						raqGrid.doCopy();
					});
					//if (getClipboard() != null) {
						menus.push("粘贴（P）");
						funcs.push(function(){
							raqGrid.doPasty();
						});
					//}
					menus.push("风格（T）");
					funcs.push(function(){
						raqGrid.setStyle(td);
					});
						
					
				}
				if (table.parentNode == raqGrid.div4) {
					menus.push(1, "插入行（R）", "追加行（A）", "删除行（D）", "插入列（L）", "追加列（Z）", "删除列（S）");
					funcs.push(null);
					funcs.push(function(){
						raqGrid.insertRow(td);
					});
					funcs.push(function(){
						raqGrid.appendRow(td);
					});
					funcs.push(function(){
						raqGrid.deleteRow(td);
					});
					funcs.push(function(){
						raqGrid.insertCol(td);
					});
					funcs.push(function(){
						raqGrid.appendCol(td);
					});
					funcs.push(function(){
						raqGrid.deleteCol(td);
					});
				}
			
				if (menus.length > 0) showContextMenu(x, y, menus, funcs);	
			} else {
				showContextMenu(x, y, null, null);
			}
			
			return false;
		});
		
		addEvent(this.div4, "scroll", function() {
			raqGrid.div2.scrollLeft = raqGrid.div4.scrollLeft;
			raqGrid.div3.scrollTop = raqGrid.div4.scrollTop;
			raqGrid.start = null;
		});
	},
	
	// lets rows, column in the right position. makes divs at fit size. 
	adjustSize : function(w, h) {
		var div = raqGrid.div;
		var div1 = raqGrid.div1;
		var div2 = raqGrid.div2;
		var div3 = raqGrid.div3;
		var div4 = raqGrid.div4;
		var tb1 = div1.childNodes[0];
		var tb2 = div2.childNodes[0];
		var tb3 = div3.childNodes[0];
		var tb4 = div4.childNodes[0];

		w = ((w > (tb1.offsetWidth + 50)) ? w : (tb1.offsetWidth + 50));
		h = ((h > (tb1.offsetHeight + 50)) ? h : (tb1.offsetHeight + 50));
		var wHead = div1.offsetWidth;
		var hHead = div1.offsetHeight;
		var wBody = w - wHead;
		var hBody = h - hHead;
		
		//var tb4w = tb4.offsetWidth;
		//tb4.style.minWidth = tb4w + "px";

		if (hBody > tb4.offsetHeight) div2.style.width = wBody + "px";
		else div2.style.width = wBody - window.scrollWidth + "px";
		div4.style.width = wBody + "px";
		
		if (wBody > tb4.offsetWidth) div3.style.height = hBody + "px";
		else div3.style.height = hBody - window.scrollWidth + "px";
		div4.style.height = hBody + "px";

		div.style.width = w + "px";
		div.style.height = h + "px";
		
		//table4.style.width = tb4w + "px";
	},
	
	getCsss : function() {
		var style = document.createElement("style");
		var styles = "";
		var s = this.json.css;
		if (s != null) {
			for (var i=0; i<s.length; i++) {
				styles += ".commonCss" + i + "{" + s[i] + "}";
			}
		}
		s = (s?s.length:0);
		styles += ".commonCss" + s + "{background-color:#999999;}"; //最左上格子的样式
		styles += ".commonCss" + (s + 1) + "{font-size:13px;background-color:#bbbbbb;text-align:center;}"; //最上、最左格子的样式,最上的格子编号为A,B,C...,最左格子编号为1,2,3...
		this.titleCss = "commonCss" + (s + 1);
		style.type="text/css";
		if(style.styleSheet){
		    style.styleSheet.cssText=styles;
		} else{
		    styles = document.createTextNode(styles);
		    style.appendChild(styles);
		}
		return style;
	},

	getDiv1 : function() {
		this.div1 = document.createElement("div");
		this.div1.style.overflow = 'hidden';
		var row = this.json.topH;
		var col = this.json.leftH;
		this.div1.appendChild(this.getTable(0, row, 0, col));
		return this.div1;
	},

	getDiv2 : function() {
		this.div2 = document.createElement("div");
		this.div2.style.overflow = 'hidden';
		var row = this.json.topH;
		var col = this.json.leftH + 1;
		this.div2.appendChild(this.getTable(0, row, col, this.json.data[0].length-1));
		return this.div2;
	},

	getDiv3 : function() {
		this.div3 = document.createElement("div");
		this.div3.style.overflow = 'hidden';
		var row = this.json.topH + 1;
		var col = this.json.leftH;
		this.div3.appendChild(this.getTable(row, this.json.data.length-1, 0, col));
		return this.div3;
	},

	getDiv4 : function() {
		this.div4 = document.createElement("div");
		this.div4.style.overflowX = 'auto';
		this.div4.style.overflowY = 'auto';
		var row = this.json.topH + 1;
		var col = this.json.leftH + 1;
		this.div4.appendChild(this.getTable(row, this.json.data.length-1, col, this.json.data[0].length-1));
		return this.div4;
	},
	
	// TODO 当两行完全合并时，也就是说有一个tr下面没任何一个td的情况下，表格就会出现空隙。
	getTable : function(r1, r2, c1, c2) {
		var table = document.createElement("table");
		table.cellspacing = 0;
		table.cellpadding = 0;
		table.style.borderCollapse = 'collapse';
		table.style.tableLayout = 'fixed';
		table.border = '1px';
		if (browser.FF) {
			if (r1 == 0 && c1 == 0) {
				table.style.borderBottom = '0px';
			} else if (r1 == 0 && c1 != 0) {
				table.style.borderBottom = '0px';
				table.style.borderLeft = '0px';
			} else if (r1 != 0 && c1 == 0) {
	
			} else {
				table.style.borderLeft = '0px';
			}
		}
		var colGroup = document.createElement("COLGROUP");
		var tw = 0;
		for (var j=c1; j<=c2; j++) {
			var colJ = document.createElement("COL");
			colJ.style.width = this.json.colWidth[j] + 'px';
			tw += parseInt(this.json.colWidth[j]);
			colGroup.appendChild(colJ);
		}
		if (browser.FF) table.width = tw + 2 + 'px';
		table.appendChild(colGroup);
		for (var i=r1; i<=r2; i++) {
			var row = table.insertRow(-1);
			row.style.height = this.json.rowHeight[i] + "px";
			for (var j=c1; j<=c2; j++) {
				var d = this.json.data[i][j];
				if (isEmpty(d)) continue; 
				var td = row.insertCell(-1);
				// addToCache
				raqGrid.cache.tds.push(td);
				if (r1 == 0 && c1 == 0) raqGrid.cache.tds1.push(td);
				else if (r1 == 0 && c1 != 0) raqGrid.cache.tds2.push(td);
				else if (r1 != 0 && c1 == 0) raqGrid.cache.tds3.push(td);
				else if (r1 != 0 && c1 != 0) raqGrid.cache.tds4.push(td);
				td.style.verticalAlign = 'top';
				if (d.f) td.f = d.f;
				td.innerHTML = (d.disV?d.disV:(d.v?d.v:""));
				td.style.overflow = 'hidden'; // firefox enlarge problem.
				if (d.id) td.id = d.id;
				td.col = j-c1;
				if (d.rowSpan) {
					td.rowSpan = d.rowSpan;
				}
				if (d.colSpan) td.colSpan = d.colSpan;
				td.nowrap = false;

				if (d.css != null && d.css >= 0) td.className = "commonCss" + d.css;
			}
		}
		return table;
	},

	getWidth : function(begin, colSpan) {
		var w = 0;
		for (var i=begin; i<begin+colSpan; i++) {
			w += parseInt(this.json.colWidth[i]);
		}
		return w;
	},
	
	getHeight : function(begin, rowSpan) {
		var h = 0;
		for (var i=begin; i<begin+rowSpan; i++) {
			h += parseInt(this.json.rowHeight[i]);
		}
		return h;
	},
	
	mousemove : function(e) {
		if (raqGrid.start != null) { // 已开始选择
			raqGrid.drawSelectHint(raqGrid.start[0], raqGrid.start[1], e.clientX, e.clientY, e.ctrlKey, false);
		}

		if (raqGrid.sizeBegin) { // 已开始改变列宽，行高。
			if (raqGrid.sizeDiv.style.cursor == 'col-resize') {
				raqGrid.sizeDiv.style.left = e.clientX - 11 + "px";
				if (e.clientX < getPos(raqGrid.sizeTD)[0] + 10) {
					raqGrid.sizeMouseup(e);
				}
			} else {
				raqGrid.sizeDiv.style.top = e.clientY - 11 + "px";
				if (e.clientY < getPos(raqGrid.sizeTD)[1] + 10) {
					raqGrid.sizeMouseup(e);
				}
			}
		} else { // 检查鼠标已经移动到了“改变列宽，行高”的区域。
			var src = e.target?e.target:e.srcElement;
			var td = getParent(src, "TD");
			if (!td) {
				//raqGrid.sizeDiv.style.display = 'none';
				return;
			}
			raqGrid.sizeTD = td;
			var tdPos = getPos(td);
			var tr = getParent(td, "TR");
			var table = getParent(tr, "TABLE");
			var currDiv = getParent(table, "TABLE").parentNode;
			if (currDiv == raqGrid.div2 || (currDiv == raqGrid.div1 && td != tr.cells[0])) {
				if (tr == table.rows[0]) {
					if (e.clientX >= (tdPos[0] + tdPos[2] - 2) && e.clientX <= (tdPos[0] + tdPos[2])) {
						raqGrid.sizeDiv.style.width = '21px';
						raqGrid.sizeDiv.style.height = td.offsetHeight + "px";
						raqGrid.sizeDiv.style.top = tdPos[1] + "px";
						raqGrid.sizeDiv.style.left = tdPos[0] + tdPos[2] - 11 + "px";
						var tmpDiv = document.createElement("div");
						tmpDiv.style.width = browser.IE?"10px":"11px";
						tmpDiv.style.height = td.offsetHeight + "px";
						tmpDiv.style.borderRight = '1px solid #000000';
						raqGrid.sizeDiv.innerHTML = '';
						raqGrid.sizeDiv.appendChild(tmpDiv);
						raqGrid.sizeDiv.style.cursor = 'col-resize';
						raqGrid.sizeDiv.style.display = 'block';
					} else {
						raqGrid.sizeDiv.style.display = 'none';
					}
				};
			}
			if (currDiv == raqGrid.div3 || (currDiv == raqGrid.div1 && tr != table.rows[0])) {
				if (td == tr.cells[0]) {
					if (e.clientY >= (tdPos[1] + tdPos[3] - 3) && e.clientY <= (tdPos[1] + tdPos[3])) {
						raqGrid.sizeDiv.style.height = '21px';
						raqGrid.sizeDiv.style.width = td.offsetWidth + "px";
						raqGrid.sizeDiv.style.top = tdPos[1] + tdPos[3] - 11 + "px";
						raqGrid.sizeDiv.style.left = tdPos[0] + "px";
						var tmpDiv = document.createElement("div");
						tmpDiv.style.height = browser.IE?"10px":"11px";
						tmpDiv.style.width = td.offsetWidth + "px";
						tmpDiv.style.borderBottom = '1px solid #000000';
						raqGrid.sizeDiv.innerHTML = '';
						raqGrid.sizeDiv.appendChild(tmpDiv);
						raqGrid.sizeDiv.style.cursor = 'row-resize';
						raqGrid.sizeDiv.style.display = 'block';
					} else {
						raqGrid.sizeDiv.style.display = 'none';
					}
				}
			}
		}
	},

	mouseup : function(e) {
		// 结束选择
		if (raqGrid.start != null) {
			raqGrid.drawSelectHint(raqGrid.start[0], raqGrid.start[1], e.clientX, e.clientY, e.ctrlKey, true);
			raqGrid.start = null;
			raqGrid.selectHint.style.display = "none";
		}

		// 结束改变行高、列宽
		if (raqGrid.sizeBegin) {
			raqGrid.sizeBegin = false;
			raqGrid.sizeDiv.style.display = 'none';
			var pos = getPos(raqGrid.sizeTD);
			var width = e.clientX - pos[0];
			if (width < 10) width = 10;
			var height = e.clientY - pos[1];
			if (height < 10) height = 10;
			var cells = raqGrid.div1.childNodes[0].rows[0].cells;
			for (var i=0; i<cells.length; i++) {
				if (cells[i] == raqGrid.sizeTD) {
					var tmp = raqGrid.div1.childNodes[0].childNodes[0].childNodes[i].offsetWidth - width; 
					raqGrid.div1.childNodes[0].childNodes[0].childNodes[i].style.width = width + "px";
					raqGrid.div3.childNodes[0].childNodes[0].childNodes[i].style.width = width + "px";
					//raqGrid.div1.childNodes[0].width = raqGrid.div1.childNodes[0].offsetWidth - tmp + "px";
					//raqGrid.div3.childNodes[0].width = raqGrid.div3.childNodes[0].offsetWidth - tmp + "px";
				}
			}
			
			cells = raqGrid.div2.childNodes[0].rows[0].cells;
			for (var i=0; i<cells.length; i++) {
				if (cells[i] == raqGrid.sizeTD) {
					var tmp = raqGrid.div2.childNodes[0].childNodes[0].childNodes[i].offsetWidth - width; 
					raqGrid.div2.childNodes[0].childNodes[0].childNodes[i].style.width = width + "px";
					raqGrid.div4.childNodes[0].childNodes[0].childNodes[i].style.width = width + "px";
					//raqGrid.div2.childNodes[0].width = raqGrid.div2.childNodes[0].offsetWidth - tmp + "px";
					//raqGrid.div4.childNodes[0].width = raqGrid.div4.childNodes[0].offsetWidth - tmp + "px";
				}
			}
			
			var rows = raqGrid.div1.childNodes[0].rows;
			for (var i=1; i<rows.length; i++) {
				if (rows[i].cells[0] == raqGrid.sizeTD) {
					raqGrid.div1.childNodes[0].rows[i].style.height = height + "px";
					raqGrid.div2.childNodes[0].rows[i].style.height = height + "px";
				}
			}
			
			rows = raqGrid.div3.childNodes[0].rows;
			for (var i=0; i<rows.length; i++) {
				if (rows[i].cells[0] == raqGrid.sizeTD) {
					raqGrid.div3.childNodes[0].rows[i].style.height = height + "px";
					raqGrid.div4.childNodes[0].rows[i].style.height = height + "px";
				}
			}
		}
	},
	
	drawSelectHint : function(x1, y1, x2, y2, ctrl, colorUpTd){
		var top = (y1>y2?y2:y1);
		var left = (x1>x2?x2:x1);
		var bottom = (y1>y2?y1:y2);
		var right = (x1>x2?x1:x2);
		raqGrid.selectHint.style.left = left + "px";
		raqGrid.selectHint.style.top = top + "px";
		raqGrid.selectHint.style.width = right-left + "px";
		raqGrid.selectHint.style.height = bottom-top + "px";
		if (x1 == x2 && y1 == y2) this.selectHint.style.border = '0px dotted black';
		else this.selectHint.style.border = '1px dotted black';
		raqGrid.selectHint.style.display = "block";
		
		if (!colorUpTd) return;
/*
		if (!ctrl) {
			for (var i=0; i<raqGrid.cache.selectedTds.length; i++) {
				raqGrid.cache.selectedTds[i].style.backgroundColor='';
			}
			raqGrid.cache.selectedTds = new Array();
		}
		var cornerTd = raqGrid.div1.childNodes[0].rows[0].cells[0];
		for (var i=top; i<=bottom + 3; i=i+3) {
			if (i > bottom) i = bottom;
			//var tmpI = 0;
			for (var j=left; j<=right + 20; j=j+20) {
				if (j > right) j = right;
				var src = document.elementFromPoint(j, i);
				var td = getParent(src, "TD");
				if (td != null && td != cornerTd && td.className != raqGrid.titleCss) {
					if (td.childNodes[0] == raqGrid.div1 || td.childNodes[0] == raqGrid.div2 || td.childNodes[0] == raqGrid.div3 || td.childNodes[0] == raqGrid.div4) continue;
					raqGrid.cache.selectedTds.push(td);
					td.style.backgroundColor='yellow';
					
					//var pos = getPos(td);
					//var tmpJ = pos[0] + pos[2] + 1;
					//if (tmpJ > j + 1) j = tmpJ;
					//if (tmpI > pos[1] + pos[3]) tmpI = pos[1] + pos[3]+ 1;
				}
				if (j == right) break;
			}
			if (i == bottom) break;
			//if (i + 1 < tmpI) i = tmpI;
		}
*/

		var d1 = new Date();
		var tds = raqGrid.cache.tds;//raqGrid.div.getElementsByTagName("TD"); //TODO 这里每次查找所有td，每次计算位置，比较位置，应该比较耗时，如果发现慢，就缓存起来。
		//var posCache = ca
		var hintPos = getPos(raqGrid.selectHint);
		for (var i=0; i<tds.length; i++) {
			var td = tds[i];
			if (td == null || i == 0 || td.className == raqGrid.titleCss) continue;
			var b = posCompare(getPos(td),hintPos);
			if (b) {
				td.style.backgroundColor='yellow';
			} else {
				if (!ctrl) td.style.backgroundColor='';
			}
		}
		if (new Date().getTime() - d1.getTime() > 500) alert(new Date().getTime() - d1.getTime());

	},
	
	doCopy : function() {
		var copys = raqGrid.getSelectTDs();
		var status = raqGrid.selectTDsStatus(copys);

		if (status < 4) {
			setClipboard(raqGrid.getSelectTDsStr(copys));
			//window.clipboardData.setData('text', raqGrid.getSelectTDsStr(copys));
		} else if(status == 4) {
			alert("不能复制非矩形区域单元格。");
		} else {
			alert("不能复制不同表头的单元格。");
		}
	},
	
	doPasty : function() {
		var copys = raqGrid.getSelectTDs();

		var txt = getClipboard();//window.clipboardData.getData('text');
		var copyRows = txt.split(browser.IE?"\r\n":"\n");
		copyRows.pop();
		var col = 0;
		var row = copyRows.length;
		for (var i=0; i<row; i++) {
			copyRows[i] = copyRows[i].split("\t");
			if (col < copyRows[i].length) col = copyRows[i].length;
		}
		var firstRow = copys[0].id.row();
		var firstCol = copys[0].id.col();
		var rows = new Array(row);
		for (var i=0; i<row; i++) {
			rows[i] = firstRow + i;
		}
		var cols = new Array(col);
		for (var i=0; i<chars.length; i++) {
			if (chars[i] == firstCol) {
				firstCol = i;
				break;
			}
		}
		for (var i=0; i<col; i++) {
			cols[i] = chars[firstCol + i];
		}
		var tds = new Array(row);
		for (var i=0; i<row; i++) {
			tds[i] = new Array(col);
			for (var j=0; j<col; j++) {
				var td = $$(cols[j]+rows[i]);
				if (td == null) {
					alert("1、被粘贴的矩形区域内不能有合并格。\r\n2、需要增加更多行或列才能粘贴。");
					return;
				}
				tds[i][j] = td;
			}
		}

		for (var i=0; i<row; i++) {
			for (var j=0; j<col; j++) {
				tds[i][j].innerHTML = copyRows[i][j]?copyRows[i][j]:"";
			}
		}
		
		
/*
		if (copys.length == 1) {
			if (raqGrid.copyTD) copys[0].innerHTML = raqGrid.copyTD.innerHTML;
			else copys[0].innerHTML = window.clipboardData.getData('text');
		} else if(copys.length > 1) {
			alert("不支持向多个单元格粘贴。");
		}
*/
	},
	
	getSelectTDs : function() {
		var copys = new Array();
		var tds = this.div1.getElementsByTagName("TD");
		for (var i=0; i<tds.length; i++) {
			if (tds[i].style.backgroundColor == 'yellow') {
				copys.push(tds[i]);
			}
		}
		tds = this.div2.getElementsByTagName("TD");
		for (var i=0; i<tds.length; i++) {
			if (tds[i].style.backgroundColor == 'yellow') {
				copys.push(tds[i]);
			}
		}
		tds = this.div3.getElementsByTagName("TD");
		for (var i=0; i<tds.length; i++) {
			if (tds[i].style.backgroundColor == 'yellow') {
				copys.push(tds[i]);
			}
		}
		tds = this.div4.getElementsByTagName("TD");
		for (var i=0; i<tds.length; i++) {
			if (tds[i].style.backgroundColor == 'yellow') {
				copys.push(tds[i]);
			}
		}
		return copys;
	},
	
	/**
	 * return 1:one single cell;   2:one combined cell;   3:many cells in a rect area;   4:many cells in disordered area;   5:in different tables.
	 */
	selectTDsStatus : function(tds) {
		var rowStart, rowEnd, colStart, colEnd, cellNum=0;
		var parentDiv;
		for (var i=0; i<tds.length; i++) {
			if (parentDiv == null) parentDiv = getParent(tds[i], "DIV");
			else if (parentDiv != getParent(tds[i], "DIV")) return 5;
			var idRow = tds[i].id.row();
			var idCol = tds[i].id.col();
			var rowSpan = tds[i].rowSpan;
			var colSpan = tds[i].colSpan;
			var idColEnd = idCol;
			if (colSpan > 1) {
				for (var j=0; j<chars.length; j++) {
					if (chars[j] == idCol) {
						idColEnd = chars[j + colSpan - 1];
						break;
					}
				}
			}

			if (tds.length == 1) {
				if (rowSpan == 1 && colSpan == 1) return 1;
				else return 2;
			}
			
			if (rowStart == null || rowStart > idRow) rowStart = idRow;
			if (rowEnd == null || rowEnd < idRow + rowSpan - 1) rowEnd = idRow + rowSpan - 1;
			if (colStart == null || colStart > idCol) colStart = idCol;
			if (colEnd == null || colEnd < idColEnd) colEnd = idColEnd;

			cellNum += rowSpan * colSpan;
		}

		var col = 0;
		for (var j=0; j<chars.length; j++) {
			if (chars[j] >= colStart) {
				col++;
			}
			if (chars[j] == colEnd) break;
		}
		return ((rowEnd - rowStart + 1) * col == cellNum) ? 3 : 4;
	},
	
	getSelectTDsStr : function(tds) {
		var rowStart, rowEnd, colStart, colEnd;
		for (var i=0; i<tds.length; i++) {
			var idRow = tds[i].id.row();
			var idCol = tds[i].id.col();
			var rowSpan = tds[i].rowSpan;
			var colSpan = tds[i].colSpan;
			var idColEnd = idCol;
			if (colSpan > 1) {
				for (var j=0; j<chars.length; j++) {
					if (chars[j] == idCol) {
						idColEnd = chars[j + colSpan - 1];
						break;
					}
				}
			}

			if (rowStart == null || rowStart > idRow) rowStart = idRow;
			if (rowEnd == null || rowEnd < idRow + rowSpan - 1) rowEnd = idRow + rowSpan - 1;
			if (colStart == null || colStart > idCol) colStart = idCol;
			if (colEnd == null || colEnd < idColEnd) colEnd = idColEnd;

		}

		var col = 0;
		for (var j=0; j<chars.length; j++) {
			if (chars[j] >= colStart) {
				col++;
			}
			if (chars[j] == colEnd) break;
		}
		var row = rowEnd-rowStart + 1;
		var items = new Array(row);
		for (var i=0; i<row; i++) {
			items[i] = new Array(col);
		}
		for (var i=0; i<tds.length; i++) {
			var idRow = tds[i].id.row();
			var idCol = tds[i].id.col();
			var colNum = 0;
			for (var j=0; j<chars.length; j++) {
				if (chars[j] == idCol) break;
				if (chars[j] >= colStart) {
					colNum++;
				}
			}
			items[idRow-rowStart][colNum] = tds[i].innerHTML;
		}
		var str = '';
		for (var i=0; i<row; i++) {
			for (var j=0; j<col; j++) {
				if (items[i][j]) str += items[i][j];
				if (j != col-1) str += "\t";
			}
			str += "\r\n"; //最后一行也需要一个回车。
		}
		return str;
	},
	
	setStyle : function(td) {
		$$('styleDialog').show();
		initCellStyle( td, td.f, function(result){
			var items = result.split("|");
			td.style.fontFamily = items[0];
			td.style.fontSize = items[1];
			td.style.color = "#" + items[2];
			td.style.fontWeight = (items[3] == "1" ? 'bold' : 'normal');
			td.style.fontStyle = (items[4] == "1" ? 'italic' : 'normal');
			td.style.textDecoration = (items[5] == "1" ? 'underline' : 'none');
			td.style.textAlign = (items[6] == '208' ? "left" : (items[6] == '209' ? "center" : "right"));
			td.f = '';
			if (items[7] && items[7] != 'null') td.f = items[7];
			//td.style.border = '2px solid red';
			$$('styleDialog').hide();
		});
	},
	
	insertRow : function(td){
		var table = getParent(td, "TABLE");
		var rows = table.rows;
		var cols = this.div2.childNodes[0].rows[0].cells;
		var colIds = new Array();
		for (var i=0; i<cols.length; i++) {
			colIds[i] = cols[i].innerHTML;
		}
		var rowId = td.id.row();
		for (var i=0; i<rows.length; i++) {
			if (rows[i] == td.parentNode) {
				insertRow(table, i, rowId, colIds, 25, this.newCss?[this.newCss]:null);
				var table3 = this.div3.childNodes[0];
				cols = this.div1.childNodes[0].rows[0].cells;
				colIds = new Array();
				for (var j=0; j<cols.length; j++) {
					colIds[j] = cols[j].innerHTML;
				}
				insertRow(table3, i, rowId, colIds, 25, this.newCss?[this.titleCss, this.newCss]:[this.titleCss], true);
				return;
			}
		}
	},

	appendRow : function(td){
		var cols = this.div2.childNodes[0].rows[0].cells;
		var colIds = new Array();
		for (var i=0; i<cols.length; i++) {
			colIds[i] = cols[i].innerHTML;
		}
		var rows = this.div3.childNodes[0].rows;
		var rowId = parseInt(rows[rows.length-1].cells[0].innerHTML) + 1;
		var table = getParent(td, "TABLE");
		insertRow(table, -1, rowId, colIds, 25, this.newCss?[this.newCss]:null);
		var table3 = this.div3.childNodes[0];
		cols = this.div1.childNodes[0].rows[0].cells;
		var colIds = new Array();
		for (var i=0; i<cols.length; i++) {
			colIds[i] = cols[i].innerHTML;
		}
		insertRow(table3, -1, rowId, colIds, 25, this.newCss?[this.titleCss, this.newCss]:[this.titleCss], true);
	},

	deleteRow : function(td){
		var table = getParent(td, "TABLE");
		var rows = table.rows;
		var rowId = td.id.row();
		for (var i=0; i<rows.length; i++) {
			if (rows[i] == td.parentNode) {
				deleteRow(table, i, rowId);
				var table3 = this.div3.childNodes[0];
				deleteRow(table3, i, rowId, true);
				return;
			}
		}
	},

	insertCol : function(td){
		var table = getParent(td, "TABLE");
		var table2 = this.div2.childNodes[0];
		var first = table2.rows[0].cells[0].innerHTML;
		var colNum = 0;
		var col = td.id.col();
		for (var i=0; i<chars.length; i++) {
			if (chars[i] > first && chars[i] <= col) {
				colNum ++;
			}
			if (chars[i] > col) break;
		}
		//alert(colNum);
		insertCol(table, colNum, col, 80, this.newCss?[this.newCss]:null);
		insertCol(table2, colNum, col, 80, this.newCss?[this.titleCss, this.newCss]:[this.titleCss], true);
	},

	appendCol : function(td){
		var table = getParent(td, "TABLE");
		var table2 = this.div2.childNodes[0];
		var last = table2.rows[0].cells[table2.rows[0].cells.length - 1].innerHTML;
		//alert(last);
		for (var i=0; i<chars.length; i++) {
			if (last == chars[i]) {
				last = chars[i+1];
				break;
			}
		}
		insertCol(table, -1, last, 80, this.newCss?[this.newCss]:null);
		insertCol(table2, -1, last, 80, this.newCss?[this.titleCss, this.newCss]:[this.titleCss], true);
	},
	
	deleteCol : function(td){
		var table = getParent(td, "TABLE");
		var table2 = this.div2.childNodes[0];
		var first = table2.rows[0].cells[0].innerHTML;
		var colNum = 0;
		var col = td.id.col();
		for (var i=0; i<chars.length; i++) {
			if (chars[i] > first && chars[i] <= col) {
				colNum ++;
			}
			if (chars[i] > col) break;
		}
		deleteCol(table, colNum, col);
		var table2 = this.div2.childNodes[0];
		deleteCol(table2, colNum, col, true);
	},
	
	// id 形如“A1”，“B18”等。
	getTdById : function(id){
	}
	
	// 以下方法和网格数据无关，仅为一些工具方法。
	
};

var chars = new Array('','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','AA','AB','AC','AD','AE','AF','AG','AH','AI','AJ','AK','AL','AM','AN','AO','AP','AQ','AR','AS','AT','AU','AV','AW','AX','AY','AZ');

function $$(id) {
	return document.getElementById(id);
}

String.prototype.trim = function(){
    return this.replace(/(^\s*)|(\s*$)/g, "");
}

// 为形如“A1”，“AB13”类似的id分别提供行列信息。
String.prototype.col = function(){
	for (var i=0; i<this.length; i++) {
		if (!isNaN(parseInt(this.charAt(i)))) return this.substring(0, i);
	}
	return this;
}
String.prototype.row = function(){
	for (var i=0; i<this.length; i++) {
		if (!isNaN(parseInt(this.charAt(i)))) return parseInt(this.substring(i));
	}
	return this;
}

function isEmpty(o) {
	return (o == null || o == '');
}

function getPos(o){ // 得到一个元素相对于body的top,left以及目前宽度、高度
	var a=new Array()
	var l=0;
	var t=0;
	var w=o.offsetWidth;
	var h=o.offsetHeight;
	if (o !== null) {
		l = o.offsetLeft;
		t = o.offsetTop;
		
		var offsetParent = o.offsetParent;
		var parentNode = o.parentNode;
		
		while (offsetParent !== null) {
			l += offsetParent.offsetLeft;
			t += offsetParent.offsetTop;
			
			if (offsetParent != document.body && offsetParent != document.documentElement) {
			    l -= offsetParent.scrollLeft;
			    t -= offsetParent.scrollTop;
			}
			//next lines are necessary to support FireFox problem with offsetParent
			if (browser.FF) {
				while (offsetParent != parentNode && parentNode !== null) {
					l -= parentNode.scrollLeft;
					t -= parentNode.scrollTop;
					parentNode = parentNode.parentNode;
				}
			}
			parentNode = offsetParent.parentNode;
			offsetParent = offsetParent.offsetParent;
		}
	}
	a[0]=l;a[1]=t;a[2]=w;a[3]=h
	return a;
}

function posCompare(pos1,pos2){ // 判断两个对象有重叠部分。
	var x1=pos1[0]; x2=pos1[0] + pos1[2]; x3=pos2[0]; x4=pos2[0] + pos2[2]; y1=pos1[1]; y2=pos1[1] + pos1[3]; y3=pos2[1]; y4=pos2[1] + pos2[3];
	if (x1>x4&&x2>x3) return false;
	if (x1<x4&&x2<x3) return false;
	if (y1>y4&&y2>y3) return false;
	if (y1<y4&&y2<y3) return false;
	return true;
	//return !((x1>x4&&x2>x3)||(x1<x4&&x2<x3)||(y1>y4&&y2>y3)||(y1<y4&&y2<y3));
}

/*if menu is equal to 1, then it's only a split*/
function showContextMenu(x, y, menus, events) {
	var div = $$("contextMenu");
	if (div == null) {
		div = document.createElement("div"); 
		div.id = 'contextMenu';
		document.body.appendChild(div);
	}
	div.innerHTML = '';
	if (menus == null) {
		div.style.display = 'none';
		return;
	}
	div.style.position = 'absolute';
	div.style.top = y+'px';
	div.style.left = x+'px';
	
	var objs = new Array(menus.length);
	
	for (var i=0; i<menus.length; i++) {
		var obj = document.createElement("div");
		div.appendChild(obj);
		if (menus[i] == 1) {
			obj.style.fontSize = '1px';
			obj.style.height = '1px';
			obj.style.backgroundColor = '#444444';
			obj.style.width = '88px';
			continue;
		}
		objs[i] = obj;
		obj.innerHTML = menus[i];
		addEvent(obj, 'click', events[i]);
		obj.style.margin = '2px';
		obj.style.width = '83px';
		obj.style.padding = '2px';
	}
	addEvent(div, 'click', function(){div.style.display='none';}); 
	addEvent(div, 'mousemove', function(e){
		var curr = e.target?e.target:e.srcElement;
		for (var i=0; i<objs.length; i++) {
			if (objs[i] == null) continue;
			if (objs[i] == curr) {
				objs[i].style.backgroundColor = '#bb8888';
			} else {
				objs[i].style.backgroundColor = '';
			}
		}
	}); 
	addEvent(raqGrid.div, 'mousedown', function(e){
		div.style.display = 'none';
	}); 
	div.style.border = '1px outset gray';
	div.style.backgroundColor = '#d1d1d1';
	div.style.fontSize = '12px';
	div.style.width = '90px';
	div.style.display = 'block';
}

function addEvent(obj, evtName, evt) {
	if (browser.IE) obj.attachEvent("on" + evtName, evt);
	else obj.addEventListener(evtName,evt,false);
}

function removeEvent(obj, evtName, evt) {
	if (browser.IE) obj.dettachEvent("on" + evtName, evt);
	else obj.removeEventListener(evtName,evt,false);
}

// get ancestor by tagName
function getParent(obj, tagName){
	if (obj.tagName == tagName) return obj;
	var parent = obj;
	while (parent != null) {
		parent = parent.parentNode;
		if (parent && parent.tagName && parent.tagName == tagName) return parent;
	}
}

// get table row,column number. if needs, may add more other infos.
function getTableInfo(t){
	var col = 0;
	if (t.rows.length > 1) {
		var row = t.rows[0];
		for (var i=0; i<row.cells.length; i++) {
			col += row.cells[i].colSpan;
		}
	}
	return [t.rows.length, col];
}

// insert a Row with Height to a Table. considering combination cells.
function insertRow(t, r, rowId, colIds, h, css, adjustTitle){
	// 要调整列标题1，2，3，4......
	if (adjustTitle) {
		if (r == -1) adjustTitle = parseInt(t.rows[t.rows.length-1].cells[0].innerHTML) + 1;
		else adjustTitle = parseInt(t.rows[r].cells[0].innerHTML);
	}
	
	var iCol = getTableInfo(t)[1];
	var colNums = new Array();
	if (r >= 0) {
		for (var i=0; i<t.rows.length; i++) { // TODO up-to-down finding is slower than down-to-up.
			var row = t.rows[i];
			for (var j=0; j<row.cells.length; j++) {
				var cell = row.cells[j];
				if (i < r) {
					if (i + cell.rowSpan > r) {
						iCol = iCol - cell.colSpan;
						if (cell.id) {
							var start = cell.id.col();
							for(var k=0; k<colIds.length; k++) {
								if (colIds[k] == start) {
									for (var l=0; l<cell.colSpan; l++) colIds[k + l] = '';
									break;
								} 
							}
							cell.rowSpan = cell.rowSpan + 1;
						}
					}
				} else {
					if (cell.id && cell.id.row() >= rowId) {
						cell.id = cell.id.col() + (cell.id.row() + 1);
					}
				}
			} 
		}
	}
	
	var currRow = t.insertRow(r);
	currRow.style.height = h + "px";
	for (var i=0; i<colIds.length; i++) {
		if (colIds[i] != '') {
			var cell = currRow.insertCell(-1);
			raqGrid.cache.tds.push(cell);
			if (adjustTitle) raqGrid.cache.tds3.push(cell);
			else raqGrid.cache.tds4.push(cell);
			//cell.innerHTML = '<div style="overflow:hidden;width:100%;height:100%;"></div>';
			cell.innerHTML = '&nbsp;'
			if (colIds[i] != '&nbsp;') cell.id = colIds[i] + rowId;
			cell.col = i;
			if (css) {
				if (css[i]) cell.className = css[i];
				else cell.className = css[css.length-1];
			}
		}
	}
	
	if (adjustTitle) {
		if (r == -1) {
			var cell = t.rows[t.rows.length-1].cells[0];
			cell.innerHTML = adjustTitle;
		}else {
			for (var i=r; i<t.rows.length; i++) {
				var cell = t.rows[i].cells[0];
				cell.innerHTML = adjustTitle;
				adjustTitle++;
			}
		}
	}
	
	// IE's bug, if row is 0, the old table's first row's first cell's style has problem.
	if (browser.IE && r == 0) { 
		//t.moveRow(1, 0);
		//t.moveRow(0, 1);
	}

	// FF's bug, some time's the td's border will disappeared.
	if (browser.FF && r != 0) {
		insertRow(t, 0, h, css);
		t.deleteRow(0);
	}

}

function deleteRow(t, r, rowId, adjustTitle) {
	if (adjustTitle) {
		for (var j=t.rows.length-1; j>r; j--) {
			t.rows[j].cells[0].innerHTML = t.rows[j-1].cells[0].innerHTML;
		}
	}
	
	var h = t.rows[r].offsetHeight;
	var cells = new Array();
	var spanCells = new Array();
	for (var i=0; i<=r+1; i++) { // TODO up-to-down finding is slower than down-to-up.
		var row = t.rows[i];
		if (row == null) break;
		for (var j=0; j<row.cells.length; j++) {
			var cell = row.cells[j];
			
			if (i == r) {
				if (cell.rowSpan > 1) cells.push(cell);
				else continue;
			}
			if (i == r + 1) cells.push(cell);
			
			if (cell.rowSpan>1 && i<=r && r<i+cell.rowSpan) {
				if (browser.IE) cell.rowSpan = cell.rowSpan - 1;
				else spanCells.push(cell);
			}
		} 
	}
	
	

	// clear cache.	
	for (var i=0; i<t.rows[r].cells.length; i++) {
		var tmpCell = t.rows[r].cells[i];
		for (var j=0; j<raqGrid.cache.tds.length; j++) {
			if (tmpCell == raqGrid.cache.tds[j]) raqGrid.cache.tds[j] = null;
		}
		if (adjustTitle) {
			for (var j=0; j<raqGrid.cache.tds3.length; j++) {
				if (tmpCell == raqGrid.cache.tds3[j]) raqGrid.cache.tds3[j] = null;
			}
		} else {
			for (var j=0; j<raqGrid.cache.tds4.length; j++) {
				if (tmpCell == raqGrid.cache.tds4[j]) raqGrid.cache.tds4[j] = null;
			}
		}
	} 
	
	if (cells.length > 0) {
		var rowData = cells.sort(function(cell1, cell2){return cell1.id.col()<cell2.id.col()?-1:1});
		
		var row = t.insertRow(r);
		for (var j=0; j<rowData.length; j++) {
			row.appendChild(rowData[j]);
		}
		row.style.height = t.rows[r + 2].offsetHeight + "px";
		t.deleteRow(r + 2);
		t.deleteRow(r + 1);
	} else {
		t.deleteRow(r);
	}
	
	for (var i=r; i<t.rows.length; i++) {
		var cells = t.rows[i].cells;
		for (j=0; j<cells.length; j++) {
			if (cells[j].id && cells[j].id.row() > rowId) cells[j].id = cells[j].id.col() + (cells[j].id.row() - 1);
		}
	}

	if (!browser.IE) {
		for (var i=0; i<spanCells.length; i++) spanCells[i].rowSpan = spanCells[i].rowSpan - 1;
	}
}

function insertCol(t, c, cId, w, css, adjustTitle) {
	var group = t.childNodes[0];
	var colG = document.createElement("COL");
	colG.style.width = w + 'px';
	if (c == -1) group.appendChild(colG);
	else group.insertBefore(colG, group.childNodes[c]);

	var date1 = new Date();
	for(var i=0; i<t.rows.length; i++){
		var row = t.rows[i];
		var rowId = -1;
		if (row.cells.length > 0 && row.cells[0].id != '') {
			rowId = row.cells[0].id.row();
		}
		var iCol = -2;
		if (c >= 0) {
			var needAdd = true;
			for (var j=0; j<row.cells.length; j++) {
				var cell = row.cells[j];
				var start = cell.id.col();
				if (start == '') start = cell.innerHTML;
				var end = start;
				if (cell.colSpan>1) {
					for (var z=0; z<chars.length; z++) {
						if (start == chars[z]) {
							end = chars[z + cell.colSpan - 1];
						}
					}
				}
				if (cId == start) {
					iCld = j;
				}
				if (start < cId && cId <=end) {
					cell.colSpan = cell.colSpan + 1;
					needAdd = false;
				}
				if (start >= cId) {
					if (cell.id) {
						var currCol = cell.id.col();
						for (var z=0; z<chars.length; z++) {
							if (currCol == chars[z]) {
								cell.id = chars[z+1] + cell.id.row();
								break;
							}
						}
					}
					if (iCol == -2) iCol = j;
				}
			}
			if (!needAdd) continue;
		} else {
			iCol = c;
		}
		var cell = row.insertCell(iCol);
		if (rowId >= 0) cell.id = cId + rowId;
		//alert(rowId);
		raqGrid.cache.tds.push(cell);
		if (adjustTitle) raqGrid.cache.tds2.push(cell);
		else raqGrid.cache.tds4.push(cell);
		//cell.innerHTML = '<div style="overflow:hidden;width:100%;height:100%;"></div>';
		cell.innerHTML = '&nbsp;';
		if (c == -1) cell.col = group.childNodes.length - 1;
		else cell.col = c;
		if (css) {
			if (css[i]) cell.className = css[i];
			else cell.className = css[css.length-1];
		}
	}

	var date2 = new Date();
	//alert(date2.getTime()-date1.getTime());
	
	if (adjustTitle) {
		var cs = t.rows[0].cells;
		if (c == -1) {
			for (var i=0; i<chars.length; i++) {
				if (chars[i] == cs[cs.length-2].innerHTML) {
					cs[cs.length-1].innerHTML = chars[i+1];
					break;
				}
			} 
		} else {
			var begin = 0;
			for (var i=0; i<chars.length; i++) {
				if (chars[i] == cs[c + 1].innerHTML) {
					begin = i;
					break;
				}
			}
			
			for (var i=c; i<cs.length; i++) {
				cs[i].innerHTML = chars[begin];
				begin++;
			}
		}
	}
}

function deleteCol(t, c, cId, adjustTitle) {
	var group = t.childNodes[0];
	group.removeChild(group.childNodes[c]);
	
	for(var i=0; i<t.rows.length; i++){
		var row = t.rows[i];
		for (var j=row.cells.length-1; j>=0; j--) {
			var cell = row.cells[j];
			var start = cell.id.col();
			if (start == '') start = cell.innerHTML;
			var end = start;
			if (cell.colSpan>1) {
				for (var z=0; z<chars.length; z++) {
					if (start == chars[z]) {
						end = chars[z + cell.colSpan - 1];
					}
				}
			}
			if ( cId == start && cId == end ) {
				// clear cache.	
				var tmpCell = row.cells[j];
				for (var k=0; k<raqGrid.cache.tds.length; k++) {
					if (tmpCell == raqGrid.cache.tds[k]) raqGrid.cache.tds[k] = null;
				}
				if (adjustTitle) {
					for (var k=0; k<raqGrid.cache.tds2.length; k++) {
						if (tmpCell == raqGrid.cache.tds2[k]) raqGrid.cache.tds2[k] = null;
					}
				} else {
					for (var k=0; k<raqGrid.cache.tds4.length; k++) {
						if (tmpCell == raqGrid.cache.tds4[k]) raqGrid.cache.tds4[k] = null;
					}
				}

				row.deleteCell(j);

				continue;
			}
			if (start <= cId && cId <= end) {
				cell.colSpan = cell.colSpan - 1;
				continue;
			}
			if (start > cId && cell.id) {
				var currCol = cell.id.col();
				for (var z=0; z<chars.length; z++) {
					if (currCol == chars[z]) {
						cell.id = chars[z-1] + cell.id.row();
						break;
					}
				}
			}
		}
	}

	if (adjustTitle) {
		var cs = t.rows[0].cells;
		var begin = 0;
		if (cs.length > c) {
			for (var i=0; i<chars.length; i++) {
				if (chars[i] == cs[c].innerHTML) {
					begin = i-1;
					break;
				}
			}
			
			for (var i=c; i<cs.length; i++) {
				cs[i].innerHTML = chars[begin];
				begin++;
			}
		}
	}
}

function getScrollerWidth() {
	var scr = null;
	var inn = null;
	var wNoScroll = 0;
	var wScroll = 0;
	
	scr = document.createElement('div');
	scr.style.position = 'absolute';
	scr.style.top = '-1000px';
	scr.style.left = '-1000px';
	scr.style.width = '100px';
	scr.style.height = '50px';
	
	scr.style.overflow = 'hidden';
	inn = document.createElement('div');
	inn.style.height = '200px';
	scr.appendChild(inn);
	document.body.appendChild(scr);
	wNoScroll = inn.offsetWidth;
	scr.style.overflowY = 'scroll';
	wScroll = inn.offsetWidth;
	document.body.removeChild(document.body.lastChild);
	return (wNoScroll - wScroll);
}


/***********************************
******* begin set cell style  ******
***********************************/
function toggleColorList() {
	var list = $$( "colorList" );
	if( list.style.display == "none" ) list.style.display = "";
	else list.style.display = "none";
}
function colorSelected( colorCell ) {
	var color = colorCell.attributes.getNamedItem( "value" ).value;
	$$( "colorField" ).style.backgroundColor = color;
	$$( "colorList" ).style.display = "none";
	$$( "sampleText" ).style.color = color;
}
function toggleFontBold() {
	var cell = $$( "fontBold" );
	if( cell.value == "0" || cell.value == null ) {
		cell.value = "1";
		cell.style.backgroundColor = "#9966FF";
		$$( "sampleText" ).style.fontWeight = "bold";
	}
	else {
		cell.value = "0";
		cell.style.backgroundColor = "#c0c0c0";
		alert($$( "sampleText" ).innerHTML)
		$$( "sampleText" ).style.fontWeight = "normal";
	}
}
function toggleFontItalic() {
	var cell = $$( "fontItalic" );
	if( cell.value == "0" || cell.value == null ) {
		cell.value = "1";
		cell.style.backgroundColor = "#9966FF";
		$$( "sampleText" ).style.fontStyle = "italic";
	}
	else {
		cell.value = "0";
		cell.style.backgroundColor = "#c0c0c0";
		$$( "sampleText" ).style.fontStyle = "normal";
	}
}
function toggleFontUnderline() {
	var cell = $$( "fontUnderline" );
	if( cell.value == "0" || cell.value == null ) {
		cell.value = "1";
		cell.style.backgroundColor = "#9966FF";
		$$( "sampleText" ).style.textDecoration = "underline";
	}
	else {
		cell.value = "0";
		cell.style.backgroundColor = "#c0c0c0";
		$$( "sampleText" ).style.textDecoration = "none";
	}
}
function setAlign( cell ) {
	var alignLeft = $$( "alignLeft" );
	var alignCenter = $$( "alignCenter" );
	var alignRight = $$( "alignRight" );
	var align = "left";
	if( cell.id == "alignLeft" ) {
		alignLeft.style.backgroundColor = "#9966FF";
		alignCenter.style.backgroundColor = "#c0c0c0";
		alignRight.style.backgroundColor = "#c0c0c0";
		align = "left";
	}
	else if( cell.id == "alignCenter" ) {
		alignLeft.style.backgroundColor = "#c0c0c0";
		alignCenter.style.backgroundColor = "#9966FF";
		alignRight.style.backgroundColor = "#c0c0c0";
		align = "center";
	}
	else if( cell.id == "alignRight" ) {
		alignLeft.style.backgroundColor = "#c0c0c0";
		alignCenter.style.backgroundColor = "#c0c0c0";
		alignRight.style.backgroundColor = "#9966FF";
		align = "right";
	}
	$$( "sampleText" ).style.textAlign = align;
}
var shuzhi = [ "#0.00","#.00","#.#","#0.000","#.000","#,##0.00","#,###.00","#,###.#","#,##0.000","#,###.000" ];
var huobi = [ "￥#0.00","￥#.00","￥#.#","￥#0.000","￥#.000","￥#,##0.00","￥#,###.00","￥#,###.#","￥#,##0.000","￥#,###.000","$#0.00","$#.00","$#.#","$#0.000","$#.000","$#,##0.00","$#,###.00","$#,###.#","$#,##0.000","$#,###.000" ];
var riqi = [ "yyyy-MM-dd","yyyy年MM月dd日","yyyy/MM/dd","yy-MM-dd","yy年MM月dd日","yy/MM/dd" ];
var shijian = [ "HH:mm:ss","HH:mm:ssS","kk:mm:ss","kk:mm:ssS","hh:mm:ss","hh:mm:ssS","KK:mm:ss","KK:mm:ssS" ];
var rqsj = [ "yyyy-MM-dd HH:mm:ss","yyyy年MM月dd日 HH:mm:ss","yyyy/MM/dd HH:mm:ss","yy-MM-dd HH:mm:ss","yy年MM月dd日 HH:mm:ss","yy/MM/dd HH:mm:ss" ];
var fenshu = [ "#0.00%","#.00%","#.#%","#0.000%","#.000%","#,##0.00%","#,###.00%","#,###.#%","#,##0.000%","#,###.000%" ];
var kexue = [ "0.#E0","0.##E0","0.###E0","00.#E0","00.##E0","00.###E0","##0.#E0","##0.##E0","##0.###E0" ];
function changeFormatList( fmt ) {
	var list = shuzhi;
	switch( fmt ) {
		case "0": list = shuzhi; break;
		case "1": list = huobi; break;
		case "2": list = riqi; break;
		case "3": list = shijian; break;
		case "4": list = rqsj; break;
		case "5": list = fenshu; break;
		case "6": list = kexue; break;
	}
	var listBox = $$( "formatList" );
	listBox.options.length = 0;
	for( var i = 0; i< list.length; i++ ) {
		listBox.options.add( new Option( list[i], list[i], false, false ), listBox.options.length );
	}
}
var colorFrameStr = '<body topMargin=0 leftMargin=0 rightMargin=0 bottomMargin=0 style="overflow:hidden">' +
	'<table width=48 cellpadding=3 style="background-color:white">' +
	'<tr height=16><td style="background-color:#FF0000" value="#FF0000" onclick="parent.colorSelected(this)"></td></tr>' +
	'<tr height=16><td style="background-color:#FFFF00" value="#FFFF00" onclick="parent.colorSelected(this)"></td></tr>' +
	'<tr height=16><td style="background-color:#00FF00" value="#00FF00" onclick="parent.colorSelected(this)"></td></tr>' +
	'<tr height=16><td style="background-color:#00FFFF" value="#00FFFF" onclick="parent.colorSelected(this)"></td></tr>' +
	'<tr height=16><td style="background-color:#0000FF" value="#0000FF" onclick="parent.colorSelected(this)"></td></tr>' +
	'<tr height=16><td style="background-color:#FF00FF" value="#FF00FF" onclick="parent.colorSelected(this)"></td></tr>' +
	'<tr height=16><td style="background-color:#808080" value="#808080" onclick="parent.colorSelected(this)"></td></tr>' +
	'<tr height=16><td style="background-color:#800000" value="#800000" onclick="parent.colorSelected(this)"></td></tr>' +
	'<tr height=16><td style="background-color:#808000" value="#808000" onclick="parent.colorSelected(this)"></td></tr>' + 
	'<tr height=16><td style="background-color:#008000" value="#008000" onclick="parent.colorSelected(this)"></td></tr>' +
	'<tr height=16><td style="background-color:#008080" value="#008080" onclick="parent.colorSelected(this)"></td></tr>' +
	'<tr height=16><td style="background-color:#000080" value="#000080" onclick="parent.colorSelected(this)"></td></tr>' +
	'<tr height=16><td style="background-color:#800080" value="#800080" onclick="parent.colorSelected(this)"></td></tr>' +
	'<tr height=16><td style="background-color:#000000" value="#000000" onclick="parent.colorSelected(this)"></td></tr>' +
	'</table></body>';
//window.frames[ "colorFrame" ].document.write( colorFrameStr );
//window.frames[ "colorFrame" ].document.close();

var setStyleCallBack = null;
function initCellStyle( cell, format, callBack ) {
	setStyleCallBack = callBack;
	if (browser.FF) cell.currentStyle = cell.style;
	var font = cell.currentStyle.fontFamily;
	var txt = $$( "sampleText" );
	$$( "fontList" ).value = font;
	txt.style.fontFamily = font;
	var size = cell.currentStyle.fontSize;
	$$( "fontSizeList" ).value = size;
	txt.style.fontSize = size;
	var color = cell.currentStyle.color;
	$$( "colorField" ).style.backgroundColor = color;
	txt.style.color = color;
	var b = cell.currentStyle.fontWeight;
	txt.style.fontWeight = b;
	var fb = $$( "fontBold" );
	if( b == 700 ) {
		fb.value = "1";
		fb.style.backgroundColor = "#9966FF";
	}
	else {
		fb.value = "0";
		fb.style.backgroundColor = "#c0c0c0";
	}
	var italic = cell.currentStyle.fontStyle;
	if( italic == null ) italic = "normal";
	txt.style.fontStyle = italic;
	var fi = $$( "fontItalic" );
	if( italic.toLowerCase() == "italic" ) {
		fi.value = "1";
		fi.style.backgroundColor = "#9966FF";
	}
	else {
		fi.value = "0";
		fi.style.backgroundColor = "#c0c0c0";
	}
	var under = cell.currentStyle.textDecoration;
	if( under == null ) under = "none";
	txt.style.textDecoration = under;
	var fu = $$( "fontUnderline" );
	if( under.toLowerCase() == "underline" ) {
		fu.value = "1";
		fu.style.backgroundColor = "#9966FF";
	}
	else {
		fu.value = "0";
		fu.style.backgroundColor = "#c0c0c0";
	}
	var align = cell.currentStyle.textAlign;
	if( align == null ) align = "left";
	align = align.toLowerCase();
	var alignCell = null;
	
	if( align == "left" || align == "" ) alignCell = $$( "alignLeft" );
	else if( align == "center" ) alignCell = $$( "alignCenter" );
	else if( align == "right" ) alignCell = $$( "alignRight" );
	setAlign( alignCell );
	$$( "formatBox" ).value = (format==null || format=="null")?"":format;
}
function getCellStyle() {
	var txt = $$( "sampleText" );
	if (browser.FF) txt.currentStyle = txt.style;
	var s = txt.currentStyle.fontFamily + "|";
	var size = txt.currentStyle.fontSize;
	//alert(txt.currentStyle.color);
	var color = new RGBColor(txt.currentStyle.color);
	s += size.substring( 0, size.length - 2 ) + "|" + color.toHex().substring( 1 ) + "|";
	if( txt.currentStyle.fontWeight == 700 ) s += "1|";
	else s += "0|";
	if( txt.currentStyle.fontStyle.toLowerCase() == "italic" ) s += "1|";
	else s += "0|";
	if( txt.currentStyle.textDecoration.toLowerCase() == "underline" ) s += "1|";
	else s += "0|";
	var align = txt.currentStyle.textAlign.toLowerCase();
	if( align == "left" ) s += "208|";
	else if( align == "center" ) s += "209|";
	else if( align == "right" ) s += "210|";
	s += $$( "formatBox" ).value;
	setStyleCallBack(s);
	return s;
}

var styleHtml = '<table cellspacing=7 style="width:100%">';
	styleHtml += '<tr><td><select id=fontList onchange="$$( \'sampleText\' ).style.fontFamily=value;" style="width:125px">';
		styleHtml += '<option value="宋体">宋体</option>';
		styleHtml += '<option value="黑体">黑体</option>';
		styleHtml += '<option value="楷体_GB2312">楷体_GB2312</option>';
		styleHtml += '<option value="仿宋_GB2312">仿宋_GB2312</option>';
		styleHtml += '<option value="隶书">隶书</option>';
		styleHtml += '<option value="幼圆">幼圆</option>';
		styleHtml += '<option value="新宋体">新宋体</option>';
		styleHtml += '<option value="华文楷体">华文楷体</option>';
		styleHtml += '<option value="华文行楷">华文行楷</option>';
		styleHtml += '<option value="Arial">Arial</option>';
		styleHtml += '<option value="Dialog">Dialog</option>';
		styleHtml += '<option value="System">System</option>';
		styleHtml += '<option value="Times New Roman">Times New Roman</option>';
	styleHtml += '</select></td><td><select id=fontSizeList onchange="$$( \'sampleText\' ).style.fontSize=value;" style="width:70px">';
		styleHtml += '<option value="8px">六号</option>';
		styleHtml += '<option value="9px">小五</option>';
		styleHtml += '<option value="11px">五号</option>';
		styleHtml += '<option value="12px">小四</option>';
		styleHtml += '<option value="14px">四号</option>';
		styleHtml += '<option value="15px">小三</option>';
		styleHtml += '<option value="16px">三号</option>';
		styleHtml += '<option value="18px">小二</option>';
		styleHtml += '<option value="22px">二号</option>';
		styleHtml += '<option value="24px">小一</option>';
		styleHtml += '<option value="26px">一号</option>';
		styleHtml += '<option value="36px">小初</option>';
		styleHtml += '<option value="42px">初号</option>';
	styleHtml += '</select></td><td>';
		styleHtml += '<table cellspacing=0 cellpadding=0>';
			styleHtml += '<tr><td><input type=text id=colorField readonly onclick="toggleColorList()" style="width:35px;height:20px;border-right:none"><img src="' + imgBase + 'dropdown.jpg" border=no onclick="toggleColorList()" style="vertical-align:text-bottom"></td></tr>';
			styleHtml += '<tr><td><div id=colorList style="position:absolute;display:none;border:1px solid #C0C0C0"><iframe id=colorFrame name=colorFrame style="width:50px;height:255px" frameborder=0></iframe></div></td></tr>';
		styleHtml += '</table>';
	styleHtml += '</td></tr>';
styleHtml += '</table>';
styleHtml += '<table cellspacing=7 style="width:100%">';
	styleHtml += '<tr><td valign=top>';
			styleHtml += '<table cellspacing=0 cellpadding=0><tr>';
				styleHtml += '<td id=fontBold style="background-color:#C0C0C0" onclick="toggleFontBold()"><img src="' + imgBase + 'font_bold.gif" border=no></td>';
				styleHtml += '<td id=fontItalic style="background-color:#C0C0C0" onclick="toggleFontItalic()"><img src="' + imgBase + 'font_italic.gif" border=no></td>';
				styleHtml += '<td id=fontUnderline style="background-color:#C0C0C0" onclick="toggleFontUnderline()"><img src="' + imgBase + 'font_underline.gif" border=no></td>';
			styleHtml += '</tr></table>';
		styleHtml += '</td>';
		styleHtml += '<td valign=top>';
			styleHtml += '<table cellspacing=0 cellpadding=0><tr>';
				styleHtml += '<td id=alignLeft style="background-color:#C0C0C0" onclick="setAlign(this)"><img src="' + imgBase + 'align_left.gif" border=no></td>';
				styleHtml += '<td id=alignCenter style="background-color:#C0C0C0" onclick="setAlign(this)"><img src="' + imgBase + 'align_center.gif" border=no></td>';
				styleHtml += '<td id=alignRight style="background-color:#C0C0C0" onclick="setAlign(this)"><img src="' + imgBase + 'align_right.gif" border=no></td>';
			styleHtml += '</tr></table>';
		styleHtml += '</td>';
		styleHtml += '<td id="sampleText" width=117 height=30 style="border:1px solid #c0c0c0;vertical-align:middle;text-align:center">示例</td>';
	styleHtml += '</tr>';
styleHtml += '</table>';
styleHtml += '<table cellspacing=7 style="width:100%">';
	styleHtml += '<tr><td style="font-size:14px">数据格式&nbsp;<input id=formatBox type=text style="width:202px"></td></tr>';
styleHtml += '</table>';
styleHtml += '<table cellspacing=7 style="width:100%">';
	styleHtml += '<tr><td><select size=2 style="width:65px;height:160px" onclick="changeFormatList(value)">';
		styleHtml += '<option value="0">数值</option>';
		styleHtml += '<option value="1">货币</option>';
		styleHtml += '<option value="2">日期</option>';
		styleHtml += '<option value="3">时间</option>';
		styleHtml += '<option value="4">日期时间</option>';
		styleHtml += '<option value="5">分数</option>';
		styleHtml += '<option value="6">科学计数</option>';
		styleHtml += '</select>';
	styleHtml += '</td><td><select size=2 id=formatList style="width:190px;height:160px" onclick="$$(\'formatBox\').value = value">';
		styleHtml += '<option value="#0.00">#0.00</option>';
		styleHtml += '<option value="#.00">#.00</option>';
		styleHtml += '<option value="#.#">#.#</option>';
		styleHtml += '<option value="#0.000">#0.000</option>';
		styleHtml += '<option value="#.000">#.000</option>';
		styleHtml += '<option value="#,##0.00">#,##0.00</option>';
		styleHtml += '<option value="#,###.00">#,###.00</option>';
		styleHtml += '<option value="#,###.#">#,###.#</option>';
		styleHtml += '<option value="#,##0.000">#,##0.000</option>';
		styleHtml += '<option value="#,###.000">#,###.000</option>';
		styleHtml += '</select>';
	styleHtml += '</td></tr>';
styleHtml += '</table>';
styleHtml += '<center>';
	styleHtml += '<button onclick="getCellStyle();" style="font-size:12px">确定</button>&nbsp;&nbsp;';
	styleHtml += '<button onclick="parentNode.parentNode.hide();" style="font-size:12px">取消</button>';
styleHtml += '</center>';

/***********************************
******* end set cell style  ********
***********************************/

function Popup(div) {
	var overlay = document.createElement("div");
	overlay.style.position = 'absolute';
	overlay.style.display = 'none';
	overlay.style.zIndex = 9000;
	overlay.style.top = "0px";
	overlay.style.left = "0px";
	overlay.style.width = '100%';
	overlay.style.height = '100%';
	overlay.style.filter = 'alpha(opacity=40)';
	overlay.style.mozOpacity = '0.4';
	overlay.style.opacity = '0.4';
	overlay.style.backgroundColor = 'black';
	document.body.appendChild(overlay);
	
	var parent = document.createElement("div");
	parent.style.position = 'absolute';
	parent.style.display = 'none';
	parent.style.zIndex = 9001;
	parent.style.top = "200px";//(document.body.offsetHeight - 360)/2 + "px";
	parent.style.left = (document.body.offsetWidth - 290)/2 + "px";
	parent.style.width = '290px';
	parent.style.height = '360px';
	parent.style.border = '1px solid green';
	parent.style.fontSize = '13px';
	document.body.appendChild(parent);
	
	var head = document.createElement("div");
	head.style.width = '100%';
	head.style.height = '25px';
	head.innerHTML = '<div style="float:left;padding:5px 0 0 10px">设置风格</div><div style="float:right;width:40px;padding:5px 0 0 20px;"><a href="#" onclick="parentNode.parentNode.parentNode.childNodes[1].hide();" style="text-decoration:none">×</a></div>';
	//head.style.borderBottom = '1px solid green';
	head.style.backgroundColor = '#FF9900';
	parent.appendChild(head);

	div.style.display = 'block';
	div.style.width = '100%';
	div.style.height = '335px';
	div.style.backgroundColor = '#E6F7D4';
	parent.appendChild(div);
	
	div.show = function() {
		parent.style.display = 'block';
		overlay.style.display = 'block';
	};
	
	div.hide = function() {
		parent.style.display = 'none';
		overlay.style.display = 'none';
	}
}

/**
 * A class to parse color values
 * @author Stoyan Stefanov <sstoo@gmail.com>
 * @link   http://www.phpied.com/rgb-color-parser-in-javascript/
 * @license Use it if you like it
 */
function RGBColor(color_string)
{
    this.ok = false;

    // strip any leading #
    if (color_string.charAt(0) == '#') { // remove # if any
        color_string = color_string.substr(1,6);
    }

    color_string = color_string.replace(/ /g,'');
    color_string = color_string.toLowerCase();

    // array of color definition objects
    var color_defs = [
        {
            re: /^rgb\((\d{1,3}),\s*(\d{1,3}),\s*(\d{1,3})\)$/,
            example: ['rgb(123, 234, 45)', 'rgb(255,234,245)'],
            process: function (bits){
                return [
                    parseInt(bits[1]),
                    parseInt(bits[2]),
                    parseInt(bits[3])
                ];
            }
        },
        {
            re: /^(\w{2})(\w{2})(\w{2})$/,
            example: ['#00ff00', '336699'],
            process: function (bits){
                return [
                    parseInt(bits[1], 16),
                    parseInt(bits[2], 16),
                    parseInt(bits[3], 16)
                ];
            }
        },
        {
            re: /^(\w{1})(\w{1})(\w{1})$/,
            example: ['#fb0', 'f0f'],
            process: function (bits){
                return [
                    parseInt(bits[1] + bits[1], 16),
                    parseInt(bits[2] + bits[2], 16),
                    parseInt(bits[3] + bits[3], 16)
                ];
            }
        }
    ];

    // search through the definitions to find a match
    for (var i = 0; i < color_defs.length; i++) {
        var re = color_defs[i].re;
        var processor = color_defs[i].process;
        var bits = re.exec(color_string);
        if (bits) {
            channels = processor(bits);
            this.r = channels[0];
            this.g = channels[1];
            this.b = channels[2];
            this.ok = true;
        }

    }

    // validate/cleanup values
    this.r = (this.r < 0 || isNaN(this.r)) ? 0 : ((this.r > 255) ? 255 : this.r);
    this.g = (this.g < 0 || isNaN(this.g)) ? 0 : ((this.g > 255) ? 255 : this.g);
    this.b = (this.b < 0 || isNaN(this.b)) ? 0 : ((this.b > 255) ? 255 : this.b);

    // some getters
    this.toRGB = function () {
        return 'rgb(' + this.r + ', ' + this.g + ', ' + this.b + ')';
    }
    this.toHex = function () {
        var r = this.r.toString(16);
        var g = this.g.toString(16);
        var b = this.b.toString(16);
        if (r.length == 1) r = '0' + r;
        if (g.length == 1) g = '0' + g;
        if (b.length == 1) b = '0' + b;
        return '#' + r + g + b;
    }

    // help
    this.getHelpXML = function () {

        var examples = new Array();
        // add regexps
        for (var i = 0; i < color_defs.length; i++) {
            var example = color_defs[i].example;
            for (var j = 0; j < example.length; j++) {
                examples[examples.length] = example[j];
            }
        }
        // add type-in colors
        for (var sc in simple_colors) {
            examples[examples.length] = sc;
        }

        var xml = document.createElement('ul');
        xml.setAttribute('id', 'rgbcolor-examples');
        for (var i = 0; i < examples.length; i++) {
            try {
                var list_item = document.createElement('li');
                var list_color = new RGBColor(examples[i]);
                var example_div = document.createElement('div');
                example_div.style.cssText =
                        'margin: 3px; '
                        + 'border: 1px solid black; '
                        + 'background:' + list_color.toHex() + '; '
                        + 'color:' + list_color.toHex()
                ;
                example_div.appendChild(document.createTextNode('test'));
                var list_item_value = document.createTextNode(
                    ' ' + examples[i] + ' -> ' + list_color.toRGB() + ' -> ' + list_color.toHex()
                );
                list_item.appendChild(example_div);
                list_item.appendChild(list_item_value);
                xml.appendChild(list_item);

            } catch(e){}
        }
        return xml;

    }

}

function setClipboard(maintext) {
   if (window.clipboardData) {
      return (window.clipboardData.setData("Text", maintext));
   }
   else if (window.netscape) {
      netscape.security.PrivilegeManager.enablePrivilege('UniversalXPConnect');
      var clip = Components.classes['@mozilla.org/widget/clipboard;1'].createInstance(Components.interfaces.nsIClipboard);
      if (!clip) return;
      var trans = Components.classes['@mozilla.org/widget/transferable;1'].createInstance(Components.interfaces.nsITransferable);
      if (!trans) return;
      trans.addDataFlavor('text/unicode');
      var str = new Object();
      var len = new Object();
      var str = Components.classes["@mozilla.org/supports-string;1"].createInstance(Components.interfaces.nsISupportsString);
      var copytext=maintext;
      str.data=copytext;
      trans.setTransferData("text/unicode",str,copytext.length*2);
      var clipid=Components.interfaces.nsIClipboard;
      if (!clip) return false;
      clip.setData(trans,null,clipid.kGlobalClipboard);
      return true;
   }
   return false;
}


function getClipboard() {
   if (window.clipboardData) {
      return(window.clipboardData.getData('Text'));
   }
   else if (window.netscape) {
      netscape.security.PrivilegeManager.enablePrivilege('UniversalXPConnect');
      var clip = Components.classes['@mozilla.org/widget/clipboard;1'].createInstance(Components.interfaces.nsIClipboard);
      if (!clip) return;
      var trans = Components.classes['@mozilla.org/widget/transferable;1'].createInstance(Components.interfaces.nsITransferable);
      if (!trans) return;
      trans.addDataFlavor('text/unicode');
      clip.getData(trans,clip.kGlobalClipboard);
      var str = new Object();
      var len = new Object();
      try {
         trans.getTransferData('text/unicode',str,len);
      }
      catch(error) {
         return null;
      }
      if (str) {
         if (Components.interfaces.nsISupportsWString) str=str.value.QueryInterface(Components.interfaces.nsISupportsWString);
         else if (Components.interfaces.nsISupportsString) str=str.value.QueryInterface(Components.interfaces.nsISupportsString);
         else str = null;
      }
      if (str) {
         return(str.data.substring(0,len.value / 2));
      }
   }
   return null;
} 
