<%@page contentType="text/html;charset=UTF-8"%>
<%@include file="/taglibs.jsp"%>
<%pageContext.setAttribute("currentHeader", "audit");%>
<%pageContext.setAttribute("currentMenu", "audit");%>
<!doctype html>
<html lang="en">

  <head>
    <%@include file="/common/meta.jsp"%>
    <title><spring:message code="dev.audit-base.list.title" text="列表"/></title>
    <%@include file="/common/s3.jsp"%>
    <script type="text/javascript">
var config = {
    id: 'audit-baseGrid',
    pageNo: ${page.pageNo},
    pageSize: ${page.pageSize},
    totalCount: ${page.totalCount},
    resultSize: ${page.resultSize},
    pageCount: ${page.pageCount},
    orderBy: '${page.orderBy == null ? "" : page.orderBy}',
    asc: ${page.asc},
    params: {
        'filter_LIKES_name': '${param.filter_LIKES_name}'
    },
	selectedItemClass: 'selectedItem',
	gridFormId: 'audit-baseGridForm',
	exportUrl: 'audit-base-export.do'
};

var table;

$(function() {
	table = new Table(config);
    table.configPagination('.m-pagination');
    table.configPageInfo('.m-page-info');
    table.configPageSize('.m-page-size');
});
    </script>
  </head>

  <body>
    <%@include file="/header/audit.jsp"%>

    <div class="row-fluid">
	  <%@include file="/menu/audit.jsp"%>

	  <!-- start of main -->
      <section id="m-main" class="col-md-10" style="padding-top:65px;">

<div class="panel panel-default">
  <div class="panel-heading">
	<i class="glyphicon glyphicon-list"></i>
    查询
	<div class="pull-right ctrl">
	  <a class="btn btn-default btn-xs"><i id="audit-baseSearchIcon" class="glyphicon glyphicon-chevron-up"></i></a>
    </div>
  </div>
  <div class="panel-body">

		  <form name="audit-baseForm" method="post" action="audit-base-list.do" class="form-inline">
		    <label for="audit-base_name"><spring:message code='audit-base.audit-base.list.search.name' text='名称'/>:</label>
		    <input type="text" id="audit-base_name" name="filter_LIKES_name" value="${param.filter_LIKES_name}" class="form-control">
			<button class="btn btn-default a-search" onclick="document.audit-baseForm.submit()">查询</button>&nbsp;
		  </form>

		</div>
	  </div>

      <div style="margin-bottom: 20px;">
	    <div class="pull-left btn-group" role="group">
		<%--
		  <button class="btn btn-default a-insert" onclick="location.href='audit-base-input.do'">新建</button>
		  <button class="btn btn-default a-remove" onclick="table.removeAll()">删除</button>
		  <button class="btn btn-default a-export" onclick="table.exportExcel()">导出</button>
		  --%>
		</div>

		<div class="pull-right">
		  每页显示
		  <select class="m-page-size form-control" style="display:inline;width:auto;">
		    <option value="10">10</option>
		    <option value="20">20</option>
		    <option value="50">50</option>
		  </select>
		  条
        </div>

	    <div class="clearfix"></div>
	  </div>

<form id="audit-baseGridForm" name="audit-baseGridForm" method='post' action="audit-base-remove.do" class="m-form-blank">
      <div class="panel panel-default">
        <div class="panel-heading">
		  <i class="glyphicon glyphicon-list"></i>
		  <spring:message code="scope-info.scope-info.list.title" text="列表"/>
		</div>

  <table id="auditBaseGrid" class="table table-hover">
    <thead>
      <tr>
        <th width="10" class="table-check"><input type="checkbox" name="checkAll" onchange="toggleSelectedItems(this.checked)"></th>
        <th class="sorting" name="name">用户</th>
        <th class="sorting" name="name">操作</th>
        <th class="sorting" name="name">资源</th>
        <th class="sorting" name="name">应用</th>
        <th class="sorting" name="name">结果</th>
        <th class="sorting" name="name">时间</th>
        <th class="sorting" name="name">客户端IP</th>
        <th class="sorting" name="name">服务端IP</th>
        <th width="80">&nbsp;</th>
      </tr>
    </thead>

    <tbody>
      <c:forEach items="${page.result}" var="item">
      <tr>
        <td><input type="checkbox" class="selectedItem a-check" name="selectedItem" value="${item.id}"></td>
        <td><tags:user userId="${item.user}"/></td>
        <td>${item.action}</td>
        <td>${item.resourceType}#${item.resourceId}</td>
        <td>${item.application}</td>
        <td>${item.result}</td>
        <td>${item.auditTime}</td>
        <td>${item.client}</td>
        <td>${item.server}</td>
        <td>
		  &nbsp;
		  <!--
          <a href="audit-base-input.do?id=${item.id}" class="a-update"><spring:message code="core.list.edit" text="编辑"/></a>
		  -->
        </td>
      </tr>
      </c:forEach>
    </tbody>
  </table>


      </div>
</form>

	  <div>
	    <div class="m-page-info pull-left">
		  共100条记录 显示1到10条记录
		</div>

		<div class="btn-group m-pagination pull-right">
		  <button class="btn btn-default">&lt;</button>
		  <button class="btn btn-default">1</button>
		  <button class="btn btn-default">&gt;</button>
		</div>

	    <div class="clearfix"></div>
      </div>

      <div class="m-spacer"></div>

      </section>
	  <!-- end of main -->
	</div>

  </body>

</html>

