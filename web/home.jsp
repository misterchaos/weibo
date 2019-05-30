<%--
  Created by IntelliJ IDEA.
  User: Misterchaos
  Date: 2019/5/27
  Time: 21:48
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="host" value="localhost:8080/weibo"/>
<html>
<head>
    <meta charset="utf-8">
    <title>${user.name}的个人主页</title>
    <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/static/img/icon.ico"/>
    <link rel="stylesheet" href="http:${pageContext.request.contextPath}/static/css/index.css">
    <!--BEGIN——发送请求脚本-->
    <script language="javascript" type="text/javascript" src="${pageContext.request.contextPath}/static/js/ajax.js"></script>
    <!--END——发送请求脚本-->
    <script>
        loadMyTweet(1);
        //加载我的微博
        function loadMyTweet(page) {
            var url = "http://${host}/weibo/tweet";
            var request = {
                method: "tweet.do",
                user_id: "${sessionScope.login.id}",
                page: page
            };
            alert("正在加载您的微博，请稍后...");
            postRequest(url, request, function (result) {
                var tweets = result.data;
                //加载之前先将之前的清空
                document.getElementById('tweet-box-content').innerHTML = '';
                for (var i = 0; i < tweets.length - 1; i++) {
                    addMomentBlockHtml(tweets[i]);
                }
            });
        }

        //插入一条用户的微博
        function addMomentBlockHtml(tweet) {
            document.getElementById("tweet-box-content").innerHTML += getWeiboHtml(tweet);
        }

        //产生一条微博的html代码
        function getWeiboHtml(tweet) {
            var time = new Date(tweet.time).toLocaleString();
            var html = '           <div id="' + tweet.id + '" class="info-detail-block" style="margin-left: 20px;margin-bottom:0px;">\n' +
                '                        <label for="tweet-content" style="    margin-bottom: -47px;">\n' +
                '                            <div class="info-detail-block" >               \n' +
                '                                <div class="user-box" style="border-bottom: 1px solid #ccc;width:100%;">\n' +
                '                                    <div class="user-photo">\n' +
                '                                        <img src="${pageContext.request.contextPath}/upload/photo/' + tweet.user_photo + '" alt=w"用户头像" class="my-photo">\n' +
                '                                    </div>\n' +
                '                                    <div onclick="addMomentDetailHtml(\'' + tweet.id + '\')" class="user-info" style="height: fit-content;margin-bottom: 11px;">\n' +
                '                                        <h3 class="my-name" style="color: #333">' + tweet.user_name + ' 发布于 ' + time + ' [分类：' + tweet.sort + ']</h3>\n' +
                '                                        <div style="word-break: break-all;white-space: normal;    max-width: 70%">' + tweet.content + '</div>\n' +
                '                                    </div>\n' +
                '                                    <button id="' + tweet.id + 'love" data-love="' + tweet.love + '" ' +
                '                                       onclick="loveMoment(\'' + tweet.id + '\',' + tweet.love + ')" style="float: left;height: 30px;"  class="button" \n' +
                '                                            contenteditable="false">点赞\(' + tweet.love + '\)\n' +
                '                                    </button>\n' +
                '                                    <button id="' + tweet.id + 'remark" data-remark="' + tweet.remark + '" ' +
                '                                       onclick="remarkMoment(\'' + tweet.id + '\',' + tweet.remark + ')" style="float: left;height: 30px;"  class="button" \n' +
                '                                            contenteditable="false">评论\(' + tweet.remark + '\)\n' +
                '                                    </button>\n' +
                '                                    <button onclick="dev()" style="float: left;height: 30px;"  class="button" \n' +
                '                                            contenteditable="false">转发\(' + tweet.share + '\)\n' +
                '                                    </button>\n' +
                '                                    <button onclick="" style="float: left;height: 30px;"  class="button" \n' +
                '                                            contenteditable="false">浏览量\(' + tweet.view + '\)\n' +
                '                                    </button>\n';

            var visitorArea =
                '                                </div>\n' +
                '                            </div>\n' +
                '                        </label>\n' +
                '                    </div>';
            var ownerArea =
                '                                    <button onclick="deleteMoment(\'' + tweet.id + '\')" style="float: left;margin-left: 210px;height: 30px;"  \n' +
                '                                            class="button" contenteditable="false">删除\n' +
                '                                    </button>\n' +
                '                                </div>\n' +
                '                            </div>\n' +
                '                        </label>\n' +
                '                    </div>';
            if (tweet.owner_id ===${sessionScope.login.id}) {
                return html + ownerArea;
            } else {
                return html + visitorArea;
            }
        }

    </script>
</head>

<body style="margin: unset">
<!--BEGIN——用户信息窗口-->

<div id="${sessionScope.login.id}info" class="info-detail-box" onclick="enterClick('update-user')" style="display: inline-block">
       
    <div class="info-outline">
        <div class="info-head-photo">
            <img id="user-preview" style="height: 100px;width: 100px"
                 src="${pageContext.request.contextPath}/upload/photo/${sessionScope.login.photo}"
                 class="info-head-img"
                 onclick="document.getElementById('user-photo-input').click()" alt="用户头像">
            <form id="user-photo" method="post" enctype="multipart/form-data">
                <input type="file" name="file" id="user-photo-input"
                       accept="image/gif,image/jpeg,image/jpg,image/png,image/svg"
                       oninput="imgPreview(document.getElementById('user-photo-input'),'user-preview')"
                       style="display: none">
            </form>
        </div>
    </div>
    <div class="info-detail">
        <div class="info-detail-block">
            <div class="info-detail-item" contenteditable="false">昵称:${sessionScope.login.name}</div>
        </div>
        <div class="info-detail-block">
            <div class="info-detail-item">个性签名:${sessionScope.login.signature}</div>
        </div>
        <div class="info-detail-block">
            <div class="info-detail-item">微博账号:${sessionScope.login.weiboId}</div>
        </div>
        <div class="info-detail-block">
            <div class="info-detail-item">性别:${sessionScope.login.gender}</div>
        </div>
        <div class="info-detail-block">
            <div class="info-detail-item">地区:${sessionScope.login.location}</div>
        </div>
    </div>
</div>
</div>
<!--END——用户信息窗口-->
<!--BEGIN——查看我的微博窗口-->
<div id="tweet-box" data-page="1" class="info-box" >
    <div class="info-box-head">   
        <div class="info-box-title">       
            <div class="info-box-title-box"><a class="info-box-title-text">微博</a></div>
            <button onclick="loadMyTweet(++document.getElementById('tweet-box').dataset.page)"
                    class="button" contenteditable="false">下页
            </button>
            <button onclick="loadMyTweet(--document.getElementById('tweet-box').dataset.page<1?
                    ++document.getElementById('tweet-box').dataset.page:document.getElementById('tweet-box').dataset.page)"
                    class="button" contenteditable="false">上页
            </button>
        </div>
    </div>
    <div id="${sessionScope.login.id}info" class="info-detail-box">
        <div id="tweet-box-content" class="info-detail" style="max-width: unset">
        </div>
    </div>
</div>
<!--END——查看我的微博窗口-->
</body>

<style>
    .info-box{
        display: inline-block;
        width: 70%;
        height: 100%;
        overflow: scroll;
    }
    .info-detail{
        float: left;
        height: fit-content;
        width: fit-content;
        max-width: 200px;
    }
    .info-detail-box {
        overflow: scroll;
        position: relative;
        margin-bottom: 0px;
        margin-right: 0px;
        margin-top: 80px;
        min-height: 682px;
        height: fit-content;
        border: solid;
        width: fit-content;
    }
    .info-outline {
        float: left;
        height: fit-content;
        width: 100%;
    }

    .info-detail-item {
        height: 50px;
        font-size: 25px;
        padding-left: 62px;
        text-align: left;
        position: absolute;
        width: fit-content;
    }

    .info-detail-block {
        float: left;
        height: fit-content;
        width: fit-content;
        margin-bottom: 35px;
    }
</style>
</html>
