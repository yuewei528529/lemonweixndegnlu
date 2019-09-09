<%@page contentType="text/html;charset=UTF-8" %>
<%@include file="/taglibs.jsp" %>
<%pageContext.setAttribute("currentHeader", "bpm-workspace");%>
<%pageContext.setAttribute("currentMenu", "bpm-process");%>
<!doctype html>
<html lang="en">

<head>
    <%@include file="/common/meta.jsp" %>
    <title><spring:message code="demo.demo.input.title" text="编辑"/></title>
    <%@include file="/common/s3.jsp" %>

    <!-- bootbsss  ox -->
    <script type="text/javascript" src="${cdnPrefix}/bootbox/bootbox.min.js"></script>
    <link href="${cdnPrefix}/public/mossle-xform/0.0.11/styles/xform.css" rel="stylesheet">
    <script type="text/javascript" src="${cdnPrefix}/public/mossle-xform/0.0.11/xform-all.js"></script>

    <link type="text/css" rel="stylesheet" href="${cdnPrefix}/public/mossle-userpicker/3.0/userpicker.css">
    <script type="text/javascript" src="${cdnPrefix}/public/mossle-userpicker/3.0/userpicker.js"></script>

    <link type="text/css" rel="stylesheet" href="${cdnPrefix}/public/webuploader/0.1.5/webuploader.css">
    <script type="text/javascript" src="${cdnPrefix}/public/webuploader/0.1.5/webuploader.js"></script>

    <style type="text/css">
        .xf-handler {
            cursor: auto;
        }
    </style>

    <script type="text/javascript">

        document.onmousedown = function (e) {
        };
        document.onmousemove = function (e) {
        };
        document.onmouseup = function (e) {
        };
        document.ondblclick = function (e) {
        };

        var xform;

        $(function () {

            xform = new xf.Xform('xf-form-table');
            xform.render();

            if ($('#__gef_content__').val() != '') {
                xform.doImport($('#__gef_content__').val());
            }

            if ('${xform.jsonData}' != '') {
                xform.setValue(${xform.jsonData});
            }

            $("#xform").validate({
                submitHandler: function (form) {
                    bootbox.animate(false);
                    var box = bootbox.dialog('<div class="progress progress-striped active" style="margin:0px;"><div class="bar" style="width: 100%;"></div></div>');
                    form.submit();
                },
                errorClass: 'validate-error'
            });

            createUserPicker({
                multiple: true,
                searchUrl: '${tenantPrefix}/user/rs/s',
                treeUrl: '${tenantPrefix}/party/rs/tree-data?type=struct',
                childUrl: '${tenantPrefix}/party/rs/search-user'
            });

            setTimeout(function () {
                $('.datepicker').datepicker({
                    autoclose: true,
                    language: 'zh_CN',
                    format: 'yyyy-mm-dd'
                })
            }, 500);
        })
    </script>

    <script type="text/javascript"
            src="${cdnPrefix}/public/mossle-operation/0.0.4/TaskOperation.js?v=20190327-01"></script>
    <script type="text/javascript">
        ROOT_URL = '${tenantPrefix}';
        var taskOperation = new TaskOperation();
    </script>

</head>

<body>
<%@include file="/header/bpm-workspace3.jsp" %>

<div class="container">

    <!-- start of main -->
    <section id="m-main" class="col-md-12" style="padding-top:65px;">

        <form id="xform" method="post" action="${tenantPrefix}/operation/process-operation-startProcessInstance.do"
              class="xf-form" enctype="multipart/form-data">
            <input id="processDefinitionId" type="hidden" name="processDefinitionId"
                   value="${formDto.processDefinitionId}">
            <input id="bpmProcessId" type="hidden" name="bpmProcessId" value="${bpmProcessId}">
            <input id="autoCompleteFirstTask" type="hidden" name="autoCompleteFirstTask"
                   value="${formDto.autoCompleteFirstTask}">
            <input id="businessKey" type="hidden" name="businessKey" value="${businessKey}">
            <!--
<input id="taskId" type="hidden" name="taskId" value="${taskId}">
-->
            <div id="xf-form-table"></div>


            <br>
            <br>
            <br>
            <br>
        </form>

    </section>
    <!-- end of main -->

    <form id="f" action="form-template-save.do" method="post" style="display:none;">
        <textarea id="__gef_content__" name="content">${xform.content}</textarea>
    </form>


    <div class="navbar navbar-default navbar-fixed-bottom">
        <div class="container-fluid">
            <div class="text-center" style="padding-top:8px;">

                <c:forEach var="item" items="${buttons}">
                    <button id="${item.name}" type="button" class="btn btn-default"
                            onclick="taskOperation.${item.name}()">${item.label}</button>
                </c:forEach>

            </div>
        </div>
    </div>
    <script type="text/javascript">
        /*      $.ajax(
                   document.getElementsByName("initiator")[0].onclick = function (e) {
                       alert(1);

               });*/
        /*    (function myfunc() {
                 document.getElementsByName("initiator")[0].onclick = function (e) {
                     alert(1);

                 }
             })();*/

        /*    ccc[0].addEventListener("click",function(){
                alert(1);
            },false);*/
        $.ajax({
            url: "http://localhost:8083/lemon_war_exploded/zijin/xmjc",
            type: "get",
            success: function (data) {
                $("input[name='hetongje']").attr("readonly","readonly");
                $("input[name='yifu']").attr("readonly","readonly");
                $("input[name='yifubl']").attr("readonly","readonly");
                /*                document.getElementsByName("initiator")[0].onchange = function (e) {
                                    for($("select[name='xmjl']").val() == data[i].xmjc) {

                                        nameOpt1 += "<option value='" + data[i].gys + "' >" + data[i].gys + "</option>"
                                        $("select[name='gys']").html(nameOpt1);
                                    }


                                };*/
                /* $("input[name='initiator']")*/

                //data = JSON.parse(data);
                /*    document.getElementsByName("gys")[0].onclick = function (e) {
                        alert(1);

                    }*/
                var nameOpt = "<option value='' selected='selected'>--请选择--</option>";
                for (var i = 0; i < data.length; i++) {

                    nameOpt += "<option value='" + data[i].xmjc + "' >" + data[i].xmjc + "</option>"

                }
                var nameOpt1 = "<option value='' selected='selected'>--请选择--</option>";
                for (var i = 0; i < data.length; i++) {

                    nameOpt1 += "<option value='" + data[i].gys + "' >" + data[i].gys + "</option>"

                }
                $("select[name='xmjl']").html(nameOpt);

            },
            error: function () {
            }
        });
        $(function () {
            var nameOpt = "<option value='' selected='selected'>--请选择--</option>";
            nameOpt += "<option value='" + "紧急"+ "' >" + "紧急" + "</option>";
            nameOpt += "<option value='" + "一般"+ "' >" + "一般" + "</option>";

            $("select[name='jinji']").html(nameOpt);


            document.getElementsByName("xmjl")[0].onchange = function (e) {
                $.ajax({
                    url: "http://localhost:8083/lemon_war_exploded/zijin/gys",
                    type: "get",
                    data: {xmjc: $("select[name='xmjl']").val()},
                    success: function (data) {

                        var nameOpt = "<option value='' selected='selected'>--请选择--</option>";
                        for (var i = 0; i < data.length; i++) {

                            if (data[i].xmjc == $("select[name='xmjl']").val()) {
                                nameOpt += "<option value='" + data[i].gys + "' >" + data[i].gys + "</option>"
                            }
                        }
                        $("select[name='gys']").html(nameOpt);
                    },
                    error: function () {
                    }
                });

            };
            document.getElementsByName("gys")[0].onchange = function (e) {
                $.ajax({
                    url: "http://localhost:8083/lemon_war_exploded/zijin/htze",
                    type: "get",
                    data: {xmjc: $("select[name='xmjl']").val(), gys: $("select[name='gys']").val()},
                    success: function (data) {

                        var nameOpt=0;
                        var nameOpt1=0;
                        for (var i = 0; i < data.length; i++) {
                            if (isNaN(parseFloat(data[i].htze))) {
                                data[i].htze = 0;
                            }
                            if (isNaN(parseFloat(data[i].yif))) {
                                data[i].yif = 0;
                            }

                            nameOpt += parseFloat(data[i].htze);
                            nameOpt1 += parseFloat(data[i].yif);

                        }
                        $("input[name='hetongje']").val(nameOpt);
                        $("input[name='yifu']").val(nameOpt1);
                        $("input[name='yifubl']").val(nameOpt1/nameOpt*100+"%");

                    },
                    error: function () {
                    }
                });

            };
            document.getElementsByName("shenqje")[0].onchange = function (e) {
                $("input[name='shenqbl']").val($("input[name='shenqje']").val()/$("input[name='hetongje']").val()*100+"%");

            }
            document.getElementsByName("shenqbl")[0].onchange = function (e) {

                $("input[name='shenqje']").val(parseFloat($("input[name='shenqbl']").val())*$("input[name='hetongje']").val()/100);

            }

        });

    </script>
    <script type="text/javascript">
        $("select[name='gys']").bind("on", function () {
            /*              $.ajax({
                              url:"http://localhost:8083/lemon_war_exploded/zijin/gys",
                              type:"get",
                              data:{xmjc:$("select[name='xmjl']")},
                              success: function(data){
                                  //data = JSON.parse(data);
                                  var nameOpt = "<option value='' selected='selected'>--请选择--</option>";
                                  for(var i=0;i<data.length;i++) {

                                      nameOpt+="<option value='"+data[i].gys+"' >"+data[i].gys+"</option>"

                                  }
                                  alert(nameOpt);
                                  $("select[name='gys']").html(nameOpt);
                              },
                              error: function(){}
                          });*/
            alert("ddddd");
        });

    </script>
</body>

</html>
