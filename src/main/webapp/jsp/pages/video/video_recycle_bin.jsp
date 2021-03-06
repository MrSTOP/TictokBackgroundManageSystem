<%--
  Created by IntelliJ IDEA.
  Author: 闫坤炜
  User: MrST
  Date: 2020/2/27
  Time: 22:34
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
                    <h5>视频列表</h5>
                </div>
                <div class="ibox-content">


                    <hr>
                    <!--数据表顶部查询 结束-->
                    <!--数据表开始-->
                    <div class="jqGrid_wrapper">
                        <table class="footable table table-stripped table-hover" data-page-size="8" data-filter=#filter>
                            <!--数据头 开始-->
                            <thead>
                            <tr>
                                <th>序号</th>
                                <th>视频标题</th>
                                <th>上传时间</th>
                                <th>上传者</th>
                                <th>删除时间</th>
                                <th>还原</th>
                                <th>彻底删除</th>
                            </tr>
                            </thead>
                            <!--数据头 结束-->
                            <!--数据体 开始-->
                            <tbody>
                            <c:forEach var="video" items="${requestScope.recycleBinVideoList}">
                                <tr class="gradeX">
                                    <td class="videoId">${video.videoId}</td>
                                    <td>${video.videoTitle}</td>
                                    <td class="center">${video.videoDate.toLocaleString()}</td>
                                    <td class="center">${video.businessInfoLegalPerson}</td>
                                    <td class="center">${video.deleteVideoDate.toLocaleString()}</td>
                                    <td class="center"><button type="button" class="btn btn-primary recoverVideo" ${video.recoverable ? "" : "disabled='disabled'"}>还原</button></td>
                                    <td class="center"><button type="button" class="btn btn-danger deleteVideoPermanently">彻底删除</button></td>
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
    <script src="${pageContext.request.contextPath}/js/plugins/peity/jquery.peity.min.js"></script>
    &lt;!&ndash; jqGrid &ndash;&gt;
    <script src="${pageContext.request.contextPath}/js/plugins/jqgrid/i18n/grid.locale-cn.js?0820"></script>
    <script src="${pageContext.request.contextPath}/js/plugins/jqgrid/jquery.jqGrid.min.js?0820"></script>
-->


<!-- 自定义js -->
<script src="${pageContext.request.contextPath}/js/content.js?v=1.0.0"></script>
<script>
    $(document).ready(function () {
        $(".recoverVideo").on({"click": function () {
            var trElement = $(this).parent().parent();
            var videoId = $(trElement).children(".videoId").html();
                $.ajax({
                    url: "${pageContext.request.contextPath}/VideoController/recoverVideo",
                    type: "POST",
                    data: "videoId=" + videoId,
                    success: function (msg) {
                        if (msg.result == true) {
                            alert("还原成功");
                            trElement.remove();
                        } else {
                            alert("还原失败");
                        }
                    }
                });
            }});
        $(".deleteVideoPermanently").on({"click": function () {
                var trElement = $(this).parent().parent();
                var videoId = $(trElement).children(".videoId").html();
                $.ajax({
                    url: "${pageContext.request.contextPath}/VideoController/deleteVideoPermanently",
                    type: "POST",
                    data: "videoId=" + videoId,
                    success: function (msg) {
                        if (msg.result == true) {
                            alert("彻底删除成功");
                            trElement.remove();
                        } else {
                            alert("彻底删除失败");
                        }
                    }
                });
            }});
    });
</script>

</body>

</html>
