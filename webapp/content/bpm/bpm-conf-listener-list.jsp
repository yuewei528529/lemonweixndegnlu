<%@page contentType="text/html;charset=UTF-8"%>
<%@include file="/taglibs.jsp"%>
<%pageContext.setAttribute("currentHeader", "bpm-console");%>
<%pageContext.setAttribute("currentMenu", "bpm-category");%>
<!doctype html>
<html lang="en">

  <head>
    <%@include file="/common/meta.jsp"%>
    <title><spring:message code="dev.bpm-confener.list.title" text="列表"/></title>
    <%@include file="/common/s3.jsp"%>
    <script type="text/javascript">
var config = {
    id: 'bpm-confenerGrid',
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
	gridFormId: 'bpm-confenerGridForm',
	exportUrl: 'bpm-confener-export.do'
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
    <%@include file="/header/bpm-console.jsp"%>

    <div class="row-fluid">
	  <%@include file="/menu/bpm-console.jsp"%>

	  <!-- start of main -->
      <section id="m-main" class="col-md-10" style="padding-top:65px;">


<div class="panel panel-default">
  <div class="panel-heading">
	<i class="glyphicon glyphicon-list"></i>
    返回
	<div class="pull-right ctrl">
	  <a class="btn btn-default btn-xs"><i id="bpm-confenerSearchIcon" class="glyphicon glyphicon-chevron-up"></i></a>
    </div>
  </div>
  <div class="panel-body">

			<a class="btn btn-default" href="bpm-conf-node-list.do?bpmConfBaseId=${bpmConfBaseId}">返回</a>

		</div>
	  </div>

<div class="panel panel-default">
  <div class="panel-heading">
	<i class="glyphicon glyphicon-list"></i>
    添加
	<div class="pull-right ctrl">
	  <a class="btn btn-default btn-xs"><i id="bpm-confenerSearchIcon" class="glyphicon glyphicon-chevron-up"></i></a>
    </div>
  </div>
  <div class="panel-body">

		  <form name="bpmCategoryForm" method="post" action="bpm-conf-listener-save.do" class="form-inline">
			<input type="hidden" name="bpmConfNodeId" value="${param.bpmConfNodeId}">
		    <label for="value">监听器:</label>
		    <input type="text" id="value" name="value" value="" class="form-control" style="width:600px;">
		    <label for="type">类型</label>
			<select name="type" class="form-control">
			  <option value="0">开始</option>
			  <option value="1">结束</option>
			  <option value="2">经过</option>
			  <option value="3">创建</option>
			  <option value="4">分配</option>
			  <option value="5">完成</option>
			  <option value="6">删除</option>
			</select>
			<button class="btn btn-default" onclick="document.bpmCategoryForm.submit()">提交</button>
		  </form>

		</div>
	  </div>
<%--
      <div style="margin-bottom: 20px;">
	    <div class="pull-left btn-group" role="group">
		  <button class="btn btn-default a-insert" onclick="location.href='bpm-confener-input.do'">新建</button>
		  <button class="btn btn-default a-remove" onclick="table.removeAll()">删除</button>
		  <button class="btn btn-default a-export" onclick="table.exportExcel()">导出</button>
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
--%>

<form id="bpm-confenerGridForm" name="bpm-confenerGridForm" method='post' action="bpm-confener-remove.do" class="m-form-blank">
      <div class="panel panel-default">
        <div class="panel-heading">
		  <i class="glyphicon glyphicon-list"></i>
		  <spring:message code="scope-info.scope-info.list.title" text="列表"/>
		</div>


    <input type="hidden" name="bpmConfNodeId" value="${param.bpmConfNodeId}">
    <table id="bpmCategoryGrid" class="table table-hover">
      <thead>
        <tr>
          <!--
          <th width="10" style="text-indent:0px;text-align:center;"><input type="checkbox" name="checkAll" onchange="toggleSelectedItems(this.checked)"></th>
          -->
          <!--
          <th class="sorting" name="id"><spring:message code="user.bpmCategory.list.id" text="编号"/></th>
          -->
          <th class="sorting" name="name"><spring:message code="user.bpmCategory.list.name" text="名称"/></th>
          <th class="sorting" name="priority">类型</th>
          <th class="sorting" name="priority">状态</th>
          <th width="100">&nbsp;</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach items="${bpmConfListeners}" var="item">
        <tr>
          <!--
          <td><input type="checkbox" class="selectedItem a-check" name="selectedItem" value="${item.id}"></td>
          -->
          <!--
          <td>${item.id}</td>
          -->
          <td><div title="${item.value}" style="width: 600px;overflow: hidden;white-space: nowrap;text-overflow: ellipsis;">${item.value}</div></td>
          <td>
            <c:choose>
              <c:when test="${item.type == 0}">开始</c:when>
              <c:when test="${item.type == 1}">结束</c:when>
              <c:when test="${item.type == 2}">经过</c:when>
              <c:when test="${item.type == 3}">创建</c:when>
              <c:when test="${item.type == 4}">分配</c:when>
              <c:when test="${item.type == 5}">完成</c:when>
              <c:when test="${item.type == 6}">删除</c:when>
              <c:when test="${item.type == 11}">通过</c:when>
              <c:when test="${item.type == 12}">驳回</c:when>
              <c:when test="${item.type == 21}">草稿</c:when>
              <c:when test="${item.type == 22}">发起</c:when>
              <c:when test="${item.type == 23}">完成</c:when>
              <c:when test="${item.type == 24}">终止</c:when>
            </c:choose>
          </td>
          <td>${item.status == 0 ? '默认' : ''}</td>
          <td>
		    <a href="bpm-conf-listener-remove.do?id=${item.id}&bpmConfNodeId=${param.bpmConfNodeId}">删除</a>
          </td>
        </tr>
        </c:forEach>
      </tbody>
    </table>


      </div>
</form>
<%--
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
--%>
      <div class="m-spacer"></div>

      </section>
	  <!-- end of main -->
	</div>

  </body>

</html>

