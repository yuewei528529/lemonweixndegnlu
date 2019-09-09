/**
 * Ingrid : JQuery Datagrid Control
 *
 * Copyright (c) 2007 Matthew Knight (http://www.reconstrukt.com http://slu.sh)
 * Dual licensed under the MIT (http://www.opensource.org/licenses/mit-license.php) 
 * and GPL (http://www.opensource.org/licenses/gpl-license.php) licenses.
 *
 * @requires jQuery v1.2
 *
 * Revision: $Id: jquery.ingrid.js,v 1.00 2007/10/02 09:00:00 mknight Exp $
 * Version: .1
 *
 * Some notes... 
 * using dimensions plugin, the call to width() temporarily styles the element to 
 * have 0px padding, border, margin, measures width() -- then removes these inline styles.
 * This sometimes causes the element to BLINK - as all those margins/widths are updated!
 *
 * removed dependency on dimensions plugin
 *
 * need to support a "row selection" model - either single-select, or multi-select (checkboxes)
 *
 * need to implement loading JSON data
 *
 */

jQuery.fn.ingrid = function(o){

	var cfg = {
		height: 1000, 										// height of our datagrid (scrolling body area)
		width : 600,
		adjustWidth : 300,
		
		scrollT : 0,  // 当前纵向滚动位置
		scrollL : 0,  // 当前横向滚动位置
		
		savedStateLoad : false,					// when Ingrid is initialized, should it load data from a previously saved state?
		initialLoad : false,						// when Ingrid is initialized, should it load data immediately?

		colWidths: [225,225,225,225],		// width of each column
		minColWidth: 30,								// minimum column width
		headerHeight: 30,								// height of our header
		headerClass: 'grid-header-bg',	// header bg
		resizableCols: true,						// make columns resizable via drag + drop
		
		gridClass: 'datagrid',							// class of head & body
		rowClasses: [],
		colClasses: [],													// array of classes : i.e. ['','grid-col-2','','']
		rowHoverClass: 'grid-row-hover',				// hovering over a row? use this class
		rowSelection: true,											// allow row selection?
		rowSelectedClass: 'grid-row-sel',				// hovering over a row? use this class
		onRowSelect: function(tr, selected){},	// function to call when row is clicked
		
		/* sorting */
		sorting: true,
		colSortParams: [],								// value to pass as sort param when header clicked (i.e. '&sort=param') ex: ['col1','col2','col3','col4']
		sortAscParam: 'asc',							// param passed on ascending sort (i.e. '&dir=asc)
		sortDescParam: 'desc',						// param passed on ascending sort (i.e. '&dir=desc)
		sortedCol: 'col1',								// current data's sorted column (can be a key from 'colSortParams', or an int 0-n (for n columns)
		sortedColDir: 'desc',							// current data's sorted dorections
		sortDefaultDir: 'desc',						// on 1st click, sort tihs direction
		sortAscClass: 'grid-sort-asc',		// class for ascending sorted col
		sortDescClass: 'grid-sort-desc',	// class for descending sorted col
		sortNoneClass: 'grid-sort-none',	// ... not sorted? use this class
		groupCount:0, // group column should not sort
		
		/* paging */
		paging: false,											// create a paging toolbar
		pageNumber: 1,
		recordsPerPage: 0,
		totalRecords: 0,
		pageToolbarHeight: 25,
		pageToolbarClass: 'grid-page-toolbar',
		pageStartClass: 'grid-page-start',
		pagePrevClass: 'grid-page-prev',
		pageInfoClass: 'grid-page-info',
		pageInputClass: 'grid-page-input',
		pageNextClass: 'grid-page-next',
		pageEndClass: 'grid-page-end',
		pageLoadingClass: 'grid-page-loading',
		pageLoadingDoneClass: 'grid-page-loading-done',
		pageViewingRecordsInfoClass: 'grid-page-viewing-records-info',

		/* ajax stuff */
		url: 'remote.html',							// url to fetch data
		type: 'GET',										// 'POST' or 'GET'
		dataType: 'html',								// 'html' or 'json' - expected dataType returned
		extraParams: {},								// a map of extra params to send to the server 				
		loadingClass: 'grid-loading',		// loading modalmask div
		loadingHtml: '<div>&nbsp;</div>',			
		
		/* should seldom change */
		resizeHandleHtml: '',									// resize handle html + css
		resizeHandleClass: 'grid-col-resize',
		scrollbarW: scrollbarWidth(),									// width allocated for scrollbar
		columnIDAttr: '_colid',					// attribute name used to groups TDs in columns
		ingridIDPrefix: '_ingrid',			// prefix used to create unique IDs for Ingrid
		
		/* cookie, for saving state */
		cookieExpiresDays: 360,
		cookiePath: '/',
		
		/* not yet implemented */
		minHeight: 100,
		resizableGrid: true,
		dragDropCols: true,
		sortType: 'server|client|none'
		
	};
	jQuery.extend(cfg, o);
	
	var columnCache = new Array();
	var columnNum = 0;
	var selectTd4Group = null;
	var topDiv = $("#gridTopDiv")[0];
	var topTable = $("#gridTopDiv table")[0];
	var middleDiv = $("#gridMiddleDiv");
	var middleTable = null;
	if (middleDiv.length == 1) {
		middleDiv.find('tr').each(function(i){
			jQuery(this).css("height", "27px");
		});
		middleDiv = middleDiv[0];
		middleTable = $("#gridMiddleDiv table")[0];
	} else {
		middleDiv = null;
	}
	var bottomDiv = $("#gridBottomDiv")[0];
	var bottomTable = $("#gridBottomDiv table")[0];

	var colWidthCache = new Array();
	var tableWidth = 0;
	for (var i=0; i<cfg.colWidths.length; i++) {
		colWidthCache[i] = cfg.colWidths[i].replace("px", "");
		tableWidth += parseInt(colWidthCache[i]);
	}
	//alert(tableWidth);
	topTable.style.width = tableWidth + "px";
	if (middleTable) middleTable.style.width = tableWidth + "px";
	bottomTable.style.width = tableWidth + "px";

	var needAdjust = false;
	var adjustMiddle = function() {

		if (needAdjust) {
			var date20 = new Date();
			var firstTd = getFirstChild(middleDiv).rows[0].cells[0];

			var l=firstTd.offsetLeft;
			var parent = firstTd;
			while(parent=parent.offsetParent){
				l+=parent.offsetLeft;
			}

			//var elem = document.elementFromPoint(,);
			var tds = columnCache[0];
			if (tds == null) {
				tds = $("#gridBottomDiv").find("tr");
				for (var k=0; k<tds.length; k++) tds[k] = tds[k].cells[0];
				columnCache[0] = tds;
			}
			
			var o = document.elementFromPoint(l + 5, b[0].offsetTop + 2);
			
			while (o) {
				try {
					if (o.getAttribute("titles")) {
						var titles = o.getAttribute("titles").split(",");
						var ths = getFirstChild(middleDiv).rows[0].cells;
						for (var q=0; q<ths.length; q++) {
							if (titles[q] == null || titles[q] == '') {
								ths[q].innerHTML = "&nbsp;";
							} else {
								ths[q].innerHTML = titles[q];
							}
						}
						break;
					}
					o = o.parentNode;
				} catch(e){
					break;
				}
			}
			needAdjust = false;
			//alert(new Date().getTime() - date20.getTime());
		}
	}
	setInterval(function(){adjustMiddle();}, 100);
	
	
	date1 = new Date();
	var h = $("#gridTopDiv");
	h.width(cfg.width + "px");
	// initialize columns
	h.find('th').each(function(i){
		columnNum = i+1;
		// init width
		jQuery(this).width(cfg.colWidths[i]);
		jQuery(this).css("font-size", "13px");
		jQuery(this).css("font-weight", "normal");
//		jQuery(this).css("nowrap", "true");
		
		
		// put column text in a div, make unselectable
		var col_label = jQuery('<div />')
										.html(jQuery(this).html())
										.css({float: 'left', display: 'block'})
										.css('-moz-user-select', 'none')
										.css('-khtml-user-select', 'none')
										.css('user-select', 'none')
										.css('width', rqBrowser.IE?'60%':'60%')
										.css('overflow', 'hidden')
										.attr('unselectable', 'on');

		// column sorting?
		if (cfg.sorting && this.innerHTML.indexOf('统计') == -1/* && i >= cfg.groupCount*/) {
			
			var key = cfg.colSortParams[i] ? cfg.colSortParams[i] : i;
			// is this column the default sorted column?
			var cls = (key == cfg.sortedCol || i == cfg.sortedCol) ? 
									( cfg.sortedColDir == cfg.sortAscParam ? cfg.sortAscClass : cfg.sortDescClass ) :
									( cfg.sortNoneClass );

			col_label.addClass(cls).click(function(){
				var dir = col_label.hasClass(cfg.sortNoneClass) ? 
										cfg.sortDefaultDir : ( col_label.hasClass(cfg.sortAscClass) ? cfg.sortDescParam : cfg.sortAscParam );

				var params = { sort : key, dir : dir };					
				/*if (p) jQuery.extend(params, { page : p.getPage() } );  xingjl removed! remove pagination */
				
				g.load( params, function(){						
					var cls = col_label.hasClass(cfg.sortNoneClass) ? 
											( cfg.sortDefaultDir == cfg.sortAscParam ? cfg.sortAscClass : cfg.sortDescClass ) :
											( col_label.hasClass(cfg.sortAscClass) ? cfg.sortDescClass : cfg.sortAscClass );

					g.getHeaders(function(col){
						col.find('div:first').addClass(cfg.sortNoneClass).removeClass(cfg.sortAscClass).removeClass(cfg.sortDescClass);
					});
					col_label.removeClass(cfg.sortAscClass).removeClass(cfg.sortDescClass).addClass(cls).removeClass(cfg.sortNoneClass);

				});
			});
		} else {
			col_label.css("padding", "3px 0 0 16px");
		}
		
		// replace contents of <th>
		jQuery(this).html(col_label);
		
		// bind an event to easily resize columns
		jQuery(this).bind('resizeColumn', {col_num : i}, function(e, w){
			var tableWidth = 0;
			colWidthCache[i] = w;
			for (var j=0; j<colWidthCache.length; j++) {
				tableWidth += parseInt(colWidthCache[j]);
			}
			topTable.style.width = tableWidth + "px";
			if (middleTable) middleTable.style.width = tableWidth + "px";
			bottomTable.style.width = tableWidth + "px";

			if ((w + "").indexOf('px') == -1) w = w + "px"; 
			jQuery(this).width(w);
			row.find("td")[i].style.width=w;
			var middle = $("#gridMiddleDiv");
			if (middle.length > 0) {
				middle.find("th")[i].style.width=w;
			}
		});
		
		// append resize handle?
		if (cfg.resizableCols) {
			// make column headers resizable
			//alert(cfg.resizeHandleHtml);
			var handle = jQuery('<div />').html(cfg.resizeHandleHtml == '' ? '-' : cfg.resizeHandleHtml).addClass(cfg.resizeHandleClass);
			handle.bind('mousedown', function(e){
				// start resize drag
				var th 		= jQuery(this).parent();
				var left  = e.clientX;
				z.resizeStart(th, left);
			});
			jQuery(this).append(handle);
		}
	});
	
	// create body table. surround body with container div for scrolling
	// setting width on first row keeps it from "blinking"
	date2 = new Date();
//	var b = jQuery('<div id="gridBottomDiv" />').html( jQuery('<table cellpadding="0" cellspacing="0" style="border-collapse:collapse;"></table>').html( this.find('tbody') ).width( h.width() ).addClass(cfg.gridClass) // 2500row, 13second
	var b = $("#gridBottomDiv");
	b.css('overflow', 'auto');
	b.height(cfg.height + "px");
	b.width(cfg.width + "px");
	b.scroll(function(){
		if (middleDiv){
			needAdjust = true;
			if (this.offsetHeight >= this.scrollHeight) {
				middleDiv.style.width = cfg.width + "px";
			} else {
				middleDiv.style.width = cfg.width - cfg.scrollbarW + "px";
			} 
			middleDiv.scrollLeft = this.scrollLeft;
		}
		
		if (this.offsetHeight >= this.scrollHeight) {
			topDiv.style.width = cfg.width + "px";
		} else {
			topDiv.style.width = cfg.width - cfg.scrollbarW + "px";
		}
		topDiv.scrollLeft = this.scrollLeft;
		
		cfg.scrollL = this.scrollLeft;
		cfg.scrollT = this.scrollTop;
	});

	date9 = new Date();
	var row = b.find('tr:first')
	jQuery(row).find('td').each(function(i){
		jQuery(this).width( cfg.colWidths[i] );
	});

	date3 = new Date();
	b.find('table').dblclick(function(e){
/*		if (window.event) e = window.event; 
		var thisTd = e.srcElement? e.srcElement : e.target; 
		while (thisTd.tagName!=null && 'TD' != thisTd.tagName.toUpperCase()) thisTd = thisTd.parentNode;
		if (thisTd.getAttribute("f") != null) {
			refreshGroupTable({cid:thisTd.cid,action:'5',groupAction:'flex'});
		}
*/	}).click(function(e){
/*		if (window.event) e = window.event; 
		var thisTd = e.srcElement? e.srcElement : e.target; 
		while (thisTd.tagName!=null && 'TD' != thisTd.tagName.toUpperCase()) thisTd = thisTd.parentNode;
		if(thisTd && thisTd.tagName && 'TD' == thisTd.tagName.toUpperCase()) {
			if (selectTd4Group) selectTd4Group.style.backgroundColor = '#FFFFFF';
			thisTd.style.backgroundColor = '#E2E4F1';
			selectTd4Group = thisTd;
		}
*/	}).bind("contextmenu",function(e){
/*		if (window.event) e = window.event; 
		var thisTd = e.srcElement? e.srcElement : e.target; 
		while (thisTd.tagName!=null && 'TD' != thisTd.tagName.toUpperCase()) thisTd = thisTd.parentNode;
		if (selectTd4Group) selectTd4Group.style.backgroundColor = '#FFFFFF';
		thisTd.style.backgroundColor = '#E2E4F1';
		selectTd4Group = thisTd;

		if (!thisTd || !thisTd.cid) return;

		var menus = new Array();
		var events = new Array();
		menus.push("设置风格");
		events.push(function(){
			var modifyStyle = function(style) {
				refreshGroupTable({action:5,groupAction:'style',cid:thisTd.cid,value:style});
			};
			$('#styleDialog').dialog('open');
			initCellStyle(thisTd, thisTd.format, modifyStyle);			
		});
		showContextMenu(e.clientX, e.clientY, menus, events, this);

		return false;
*/	});
	date4 = new Date();

	var bg = $("#gridMiddleDiv").width(cfg.width);
	if (bg.length > 0) {
		bg = bg[0];
	} else {
		bg = "";
	}
	jQuery(bg).find('th').each(function(i){
		jQuery(this).width( cfg.colWidths[i] )							
		jQuery(this).css("font-size", "13px");
	});
	date5 = new Date();
	
	// resizable cols?
	// if so create a vertical resize divider, with unique ID
	//
	if (cfg.resizableCols) {
		var z_sel = 'vertical-resize-divider' + new Date().getTime();
		var z	= jQuery('<div id="' + z_sel + '"></div>')
						.css({
							backgroundColor: '#ababab', 
							height: (cfg.headerHeight + cfg.height + ($("#gridMiddleDiv").length>0?25:0) + "px"), /*xingjl 中间table的高度*/
							width: '4px',
							position: 'absolute',
							zIndex: '10',
							display: 'block'
						})
						.extend({
							resizeStart : function(th, eventX){
								// this is fired onmousedown of the column's resize handle 						
								var pos	= th.offset();
								var adjust = (adjustTop?adjustTop:0);
								jQuery(this).show().css({
									top: pos.top-adjust + "px",
									left: eventX - cfg.adjustWidth + "px",
									height : (cfg.headerHeight + cfg.height + ($("#gridMiddleDiv").length>0?25:0) + "px")
								})
								// when resizing, bind some listeners for mousemove & mouseup events
								jQuery('body').bind('mousemove', {col : th}, function(e){		
									// on mousemove, move the vertical-resize-divider
									var th 		= e.data.col;
									var pos		= th.offset();
									var col_w	= e.clientX - pos.left;
									// make sure cursor isn't trying to make column smaller than minimum
									if (col_w > cfg.minColWidth) {
										jQuery('#' + z_sel).css('left', e.clientX - cfg.adjustWidth + "px");										
									}																		
								})
								jQuery('body').bind('mouseup', {col : th}, function(e){
									// on mouseup, 
									// 1.) unbind resize listener events from body
									// 2.) hide the vertical-resize-divider
									// 3.) trigger the resize event on the column
									jQuery(this).unbind('mousemove').unbind('mouseup');
									jQuery('#' + z_sel).hide();
									var th 		= e.data.col;
									var pos		= th.offset();
									var col_w	= e.clientX - pos.left;
									
									var allTh = getChildNodes(th[0].parentNode);
									for (var i=0; i<allTh.length; i++) {
										if (allTh[i] == th[0]) {
											if (col_w > cfg.minColWidth) {
												th.trigger('resizeColumn', [col_w]);
												//alert("column " + i + " width is " + col_w);
												refreshGroupTable({col:i, width:col_w, action:'5', groupAction:'width'});
											} else {
												th.trigger('resizeColumn', [cfg.minColWidth]);
												//alert("column " + i + " width is " + cfg.minColWidth);
												refreshGroupTable({col:i, width:cfg.minColWidth, action:'5', groupAction:'width'});
											}
										}
									}
								})
							}
						});
	}

	date6 = new Date();

	var g = $("#table1_div").extend({
		h : h,
		b : b
	});
	if (cfg.resizableCols) {
		g.append(z.hide()).extend({ z : z });
	}

	var modalmask = jQuery('<div />').html(cfg.loadingHtml).addClass(cfg.loadingClass).css({
		position: 'absolute',		
		zIndex: '1000'
	}).appendTo(g).hide();

	date7 = new Date();
	// create methods on our grid object
	g.extend({
		load : function(params, cb) {
			h.find('th').each(function(i){
				if (i==params.sort) {
					var text = getFirstChild(this).innerText;
					if (!text) text = getFirstChild(this).textContent;
					refreshGroupTable({orderField:text, order:params.dir, action:'5', groupAction:'order'});
				}
			});
		}
	});
	
	date8 = new Date();

	var resize = function(height, width, adjustWidth){
		cfg.height = height;
		cfg.width = width;
		cfg.adjustWidth = adjustWidth;
		var topDiv = $("#gridTopDiv")[0];
		var middleDiv = $("#gridMiddleDiv");
		if (middleDiv.length == 1) middleDiv = middleDiv[0];
		else middleDiv = null;
		var bottomDiv = $("#gridBottomDiv")[0];
		if (middleDiv) {
			if (bottomDiv.offsetHeight >= bottomDiv.scrollHeight) {
				middleDiv.style.width = width + "px";
			} else {
				middleDiv.style.width = width - cfg.scrollbarW + "px";
			} 
		}
	
		bottomDiv.style.height = height + "px";
		bottomDiv.style.width = width + "px";
		
		if (bottomDiv.offsetHeight >= bottomDiv.scrollHeight) {
			topDiv.style.width = width + "px";
		} else {
			topDiv.style.width = width - cfg.scrollbarW + "px";
		} 
	};

	this.extend({
		resize : resize,
		cfg : cfg
	});
	
	b[0].scrollLeft = cfg.scrollL;
	b[0].scrollTop = cfg.scrollT;
	
	date10 = new Date();

/*
	alert("1_" + (date8.getTime()-date7.getTime()));
	alert("2_" + (date7.getTime()-date6.getTime()));
	alert("3_" + (date6.getTime()-date5.getTime()));
	alert("4_" + (date5.getTime()-date4.getTime()));
	alert("5_" + (date4.getTime()-date3.getTime()));
	alert("6_" + (date3.getTime()-date2.getTime()));
	alert("7_" + (date2.getTime()-date1.getTime()));
	alert("8_" + (date3.getTime()-date9.getTime()));
	alert("9_" + (date10.getTime()-date8.getTime()));
*/
	return this;

};



function ShowObj(o, prefix){
   if (prefix == null) prefix = '';
   var result = '';
   
   for(p in o){
      if(typeof(o[p]) == 'object'){
          result += ShowObj(o[p], prefix + "." + p) + '\n'
      }else{
          result += prefix + '.' + p + ':' + o[p] + '\n'
      }
	 }
   return result;
}

function ingridGetPos(o){ // 得到一个元素相对于body的top,left以及目前宽度、高度
	var a=new Array()
	var t=o.offsetTop;
	var l=o.offsetLeft;
	var w=o.offsetWidth;
	var h=o.offsetHeight;
	while(o=o.offsetParent){
		t+=o.offsetTop;
		l+=o.offsetLeft;
	}
	a[0]=t;a[1]=l;a[2]=w;a[3]=h
	return a;
}

function ingridInnerObj(o,e){ // 判断事件是否发生在一个对象所在的区域内。
	var a=ingridGetPos(o)
	var adjust = (adjustTop?adjustTop:0);
	if(e.clientX>a[1]&&e.clientX<(a[1]+a[2])&&e.clientY>(a[0]-adjust)&&e.clientY<(a[0]+a[3]-adjust)){//如果e坐标在o的范围之内
	     if(e.clientY<(a[0]+a[3]/2))//如果e坐标在o的上半部
	         return 1;
	     else
	         return 2;//如果e坐标在o的下半部
	} else
	     return 0;//如果e坐标在o的范围之外
}

function scrollbarWidth() {
    var div = $('<div style="width:50px;height:50px;overflow:hidden;position:absolute;top:-200px;left:-200px;"><div style="height:100px;"></div>');
    // Append our div, do our calculation and then remove it
    $('body').append(div);
    var w1 = $('div', div).innerWidth();
    div.css('overflow-y', 'scroll');
    var w2 = $('div', div).innerWidth();
    $(div).remove();
    return (w1 - w2);
}