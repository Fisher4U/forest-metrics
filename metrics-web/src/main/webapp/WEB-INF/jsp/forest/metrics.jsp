<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/taglibs.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Forest管理后台</title>
    <!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <!-- Bootstrap 3.3.5 -->
    <link rel="stylesheet" href="/bootstrap/css/bootstrap.min.css">
    <!-- jvectormap -->
    <link rel="stylesheet" href="/plugins/jvectormap/jquery-jvectormap-1.2.2.css">
    <!-- Font Awesome -->
    <%--<link rel="stylesheet" href="/libs/css/font-awesome.min.css">--%>
    <%--<!-- Ionicons -->--%>
    <link rel="stylesheet" href="/libs/css/ionicons.min.css">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="//cdn.bootcss.com/font-awesome/4.5.0/css/font-awesome.css">
    <%--<!-- Ionicons -->--%>
    <%--<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css">--%>
    <!-- Theme style -->
    <link rel="stylesheet" href="/dist/css/AdminLTE.min.css">
    <!-- AdminLTE Skins. Choose a skin from the css/skins
         folder instead of downloading all of them to reduce the load. -->
    <link rel="stylesheet" href="/dist/css/skins/_all-skins.min.css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>

<body class="hold-transition skin-blue sidebar-mini">
<!-- Site wrapper -->
<div class="wrapper">
    <jsp:include page="../header.jsp"/>
    <jsp:include page="../siderbar.jsp"/>
    <div class="content-wrapper">
        <div class="box">
            <div id="container" class="col-md-12">
                <section class="content">
                    <div class="row">
                        <div class="col-xs-12">
                            <div class="box  box-default">
                                <div class="box-header with-border">
                                    <h3 class="box-title">监控列表</h3>
                                    <div class="box-tools pull-right">
                                    </div><!-- /.box-tools -->
                                </div>
                                <div class="box-body">
                                    <table id="table">
                                        <div id="toolbar">

                                            <div class="form-inline" role="form">
                                                <div class="form-group extend_query_choice">
                                                    <span>服务名:</span>
                                                    <select id="serviceName" class="form-control">
                                                        <c:forEach  var="name" items="${names}">
                                                            <option value="${name}">${name}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <button id="ok" type="submit" class=" form-control btn btn-default">查询</button>
                                            </div>

                                        </div>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
            </div>

        </div>
    </div>
    <jsp:include page="../footer.jsp"/>
    <jsp:include page="../control-siderbar.jsp"/>

    <div class="control-sidebar-bg"></div>
</div>

<!-- jQuery 2.2.0 -->
<script src="/plugins/jQuery/jQuery-2.2.0.min.js"></script>
<!-- Bootstrap 3.3.5 -->
<script src="/bootstrap/js/bootstrap.min.js"></script>
<!-- SlimScroll -->
<script src="/plugins/slimScroll/jquery.slimscroll.min.js"></script>
<!-- FastClick -->
<script src="/plugins/fastclick/fastclick.js"></script>
<!-- AdminLTE App -->
<script src="/dist/js/app.min.js"></script>

<script type="text/javascript" src="http://cdn.hcharts.cn/highcharts/highcharts.js"></script>

<!-- AdminLTE for demo purposes -->
<script src="/dist/js/demo.js"></script>
<%--<script src="/dist/js/pages/dashboard.js"></script>--%>
<jsp:include page="../common/script.jsp"/>
<script>

    $('#ok').click(function () {
        $('#table').bootstrapTable('refresh');
    });

    $(function () {
        window.initHandle = {
            // 编辑
            editModel: function (id) {
                $.ajax({
                    type: "post",
                    url: "/discovery/query",
                    data: {vuid: id},
                    dateType: "json",
                    success: function (json) {
                        var data = JSON.parse(json).data;
                        $("#uid").attr("readonly", true)
                        $("#edit").val(1);
                        if (data) {
                            $("#uid").val(data.uid);
                            $("#topSid").val(data.topSid);
                            $("#modal").modal('show');
                        }

                    }
                });
            },
            initTable: function () {
                $('#table').bootstrapTable('destroy');
                $('#table').bootstrapTable({
                    columns: [
                        {
                            field: '_id',
                            title: 'uri',
                            sortable: 'true',
                            visible: true,
                            align: 'center',
                            width: '15%'
                        },
                        {
                            field: 'count',
                            title: '请求数',
                            sortable: 'true',
                            visible: true,
                            align: 'center',
                            width: '15%'
                        },
                        {field: 'maxTime', title: 'maxTime(毫秒)', sortable: 'true', align: 'center', width: '15%'},
                        {field: 'minTime', title: 'minTime(毫秒)', sortable: 'true', align: 'center', width: '15%'},
                        {field: 'time', title: 'avgTime(毫秒)', sortable: 'true', align: 'center', width: '15%',
                            formatter:function (val, row,index) {
                                return (row.time/row.count).toFixed(2);
                            }
                        },
                        {
                            field: 'id',
                            title: '操作',
                            align: 'center',
                            width: '20%',
                        },
                    ],
                    cache: false,
                    striped: true,
                    showRefresh: true,
                    showToggle: true,
                    showColumns: true,
                    pagination: true,
                    pageList: [5, 10, 20, 30, 50],
                    search: true,
                    sidePagination: "client",
                    toolbar: '#toolbar',
                    url: '/metric/groupByUri',
                    queryParams: function queryParams(params) {   //设置查询参数
                        var param = {
                        };
                        return param;
                    }
                });

            }
        };

        // 初始化table
        initHandle.initTable();

        // 设置校验ui
        $('#form').validationEngine('attach', {
            promptPosition: 'centerRight',
            scroll: false
        });

    });


</script>

</body>
</html>
