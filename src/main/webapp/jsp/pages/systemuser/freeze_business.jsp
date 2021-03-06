<%--
  Created by IntelliJ IDEA.
  Author: 闫坤炜
  User: MrST
  Date: 2020/2/24
  Time: 17:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>

<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>数据列表</title>
    <meta name="keywords" content="">
    <meta name="description" content="">

    <link rel="shortcut icon" href="${pageContext.request.contextPath}/favicon.ico">
    <link href="${pageContext.request.contextPath}/css/bootstrap.min.css?v=3.3.6" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/font-awesome.css?v=4.4.0" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/animate.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css?v=4.1.0" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/plugins/footable/footable.core.css" rel="stylesheet">

</head>

<body class="gray-bg">
<div class="wrapper wrapper-content  animated fadeInRight">
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox ">
                <div class="ibox-title">
                    <h5>商户列表</h5>
                </div>
                <div class="ibox-content">

                    <!--数据表顶部查询 开始
                        该区域可以将来存放 各种控件
                    -->

                    <hr>
                    <!--数据表顶部查询 结束-->
                    <!--数据表开始-->
                    <div class="jqGrid_wrapper">
                        <table id="Tablebusiness" class="footable table table-stripped table-hover" data-page-size="8" data-filter=#filter>
                            <!--数据头 开始-->
                            <thead>
                            <tr>
                                <th>商户ID</th>
                                <th>商户登录名</th>
                                <th>商户冻结状态</th>
                            </tr>
                            </thead>
                            <!--数据头 结束-->
                            <!--数据体 开始-->
                            <tbody>
                            <c:forEach var="business" items="${requestScope.businessList}">
                                <tr class="gradeX" id= "business${business.businessId}">
                                    <td>${business.businessId}</td>
                                    <td>${business.businessUsername}</td>
                                    <td>
                                        <button class="btn btn-white" type="button" name = "resetBusiness"> 解冻账号
                                            <span class="BId" style="display: none">${business.businessId}</span>
                                        </button>

                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                            <!--数据体 结束-->
                            <!--数据分页 开始-->
                            <tfoot>
                            <tr>
                                <td colspan="5">
                                    <ul class="pagination pull-right"></ul>
                                </td>
                            </tr>
                            </tfoot>
                            <!--数据分页 结束-->
                        </table>
                    </div>
                    <p>&nbsp;</p>
                    <!--数据表结束-->
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 全局js -->
<script src="${pageContext.request.contextPath}/js/jquery.min.js?v=2.1.4"></script>
<script src="${pageContext.request.contextPath}/js/bootstrap.min.js?v=3.3.6"></script>
<script src="${pageContext.request.contextPath}/js/plugins/footable/footable.all.min.js"></script>


<!--
    &lt;!&ndash; Peity &ndash;&gt;
    <script src="../js/plugins/peity/jquery.peity.min.js"></script>
    &lt;!&ndash; jqGrid &ndash;&gt;
    <script src="../js/plugins/jqgrid/i18n/grid.locale-cn.js?0820"></script>
    <script src="../js/plugins/jqgrid/jquery.jqGrid.min.js?0820"></script>
-->


<!-- 自定义js -->
<script src="${pageContext.request.contextPath}/js/content.js?v=1.0.0"></script>
<script>
    $(document).ready(function () {
        $('.footable').footable();
        $('.footable2').footable();
    });

</script>
<script type="text/javascript">
    $(document).ready(function () {

        $('[name = "resetBusiness"]').click(function () {
            console.log("nihao");
            var tr = $(this).parent().parent();
            var businessId = $(this).find(".BId").html();
            var businessIsfreeze = false;
            var nowTr = "business" + businessId;
            console.log(businessId);
            console.log(businessIsfreeze);

            $.ajax({
                url: "${pageContext.request.contextPath}/BusinessController/freezeBusiness",
                type: "POST",
                data: "businessId="+businessId+"&businessIsfreeze="+businessIsfreeze,
                success: function (msg) {
                    console.log(msg.result);
                    if (msg.result == true) {
                        console.log("ban");
                        $("#Tablebusiness tr").remove("#"+nowTr);
                    }
                    alert(msg.msg);
                }
            });
        });
    });


</script>
</body>

</html>

