<%--
  ~ Copyright (c) 2019.  黄钰朝
  ~
  ~ Licensed under the Apache License, Version 2.0 (the "License");
  ~ you may not use this file except in compliance with the License.
  ~ You may obtain a copy of the License at
  ~
  ~      http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing, software
  ~ distributed under the License is distributed on an "AS IS" BASIS,
  ~ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  ~ See the License for the specific language governing permissions and
  ~ limitations under the License.
  --%>

<%--
  Created by IntelliJ IDEA.
  User: Misterchaos
  Date: 2019/5/1
  Time: 15:55
 To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="host" value="localhost:8080/weibo"/>
<%--设置主机名--%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>weibo</title>
    <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/static/img/icon.ico"/>
    <link rel="stylesheet" href="http:${pageContext.request.contextPath}/static/css/index.css">
    <!--BEGIN——发送请求脚本-->
    <script language="javascript" type="text/javascript"
            src="${pageContext.request.contextPath}/static/js/ajax.js"></script>
    <!--END——发送请求脚本-->
</head>
<body style="margin: 0px;">
<div class="page-body" style="background-color: #eee;">
    <img id="background" src="${pageContext.request.contextPath}/upload/photo/${login.chatBackground}"
         style="position: absolute;height: 100%;width: 100%">


    <!--BEGIN——菜单列表-->
    <div class="menu">
        <!--BEGIN——用户主页窗口-->
        <c:if test="${param.method=='home.do'}">
            <img id="user-preview" style="height: 100px;width: 100px;display: block;"
                 src="${pageContext.request.contextPath}/upload/photo/${requestScope.login.photo}"
                 alt="用户头像">
            <br>
            <h2 style="color:whitesmoke">昵称：${requestScope.login.name}</h2>
            <h2 style="color:whitesmoke">个性签名：${requestScope.login.signature}</h2>
            <h2 style="color:whitesmoke">微博账号：${requestScope.login.weiboId}</h2>
            <h2 style="color:whitesmoke">性别：${requestScope.login.gender}</h2>
            <h2 style="color:whitesmoke">地区：${requestScope.login.location}</h2>
            <h2 style="color:whitesmoke" onclick="showFollow('${requestScope.login.id}')">我的关注</h2>
            <h2 style="color:whitesmoke" onclick="showFans('${requestScope.login.id}')">我的粉丝</h2>

        </c:if>
        <!--END——用户主页窗口-->
        <!--BEGIN——登陆窗口-->
        <c:if test="${param.method!='home.do'}">
            <div class="menu-head">
                <div class="menu-head-photo">
                    <img src="${pageContext.request.contextPath}/upload/photo/${login.photo}"
                         class="menu-head-img"
                         onclick="showHome('${sessionScope.login.id}')">
                </div>
                <div class="menu-head-info">
                    <h3 class="menu-head-nickname">${login.name}</h3>
                </div>
            </div>
            <div class="menu-search">
                <i class="menu-search-icon"></i>
                <input id="keyword" type="text" placeholder="搜索用户" class="menu-search-bar"
                       oninput="enterClick('search')">
                <div id="search" onclick="searchUser()" class="search-button">搜索</div>
            </div>
            <div class="menu-option">
                <div class="menu-option-item">
                    <div id="tweet" onclick="showWindowOnLeft('tweet-list')" class="menu-option-button">微博</div>
                </div>
                <div class="menu-option-item">
                    <div id="chat" onclick="showWindowOnLeft('chat-list')" class="menu-option-button">私信</div>
                </div>
                <div class="menu-option-item">
                    <div id="friend" onclick="showWindowOnLeft('friend-list')" class="menu-option-button">好友</div>
                </div>
                <div class="menu-option-item">
                    <div id="setting" onclick="showWindowOnLeft('setting-list')" class="menu-option-button">设置</div>
                </div>

            </div>
            <!--BEGIN——功能列表-->
            <div id="menu-body" class="menu-body" data-window="tweet-list"
                 onload="document.getElementById('chat').click()">
                <div id="chat-list" style="display: none"></div>
                <div id="friend-list" style="display: none">
                    <button class="user-list-block-href" onmouseover="this.style.backgroundColor='#3A3F45'"
                            onmouseout="this.style.backgroundColor='#2e3238';"
                            onclick="document.getElementById('search').click()">
                        <div class="user-list-block">
                            <div class="user-box">
                                <div class="user-info">
                                    <h3 class="my-name">添加好友</h3>
                                    <p class="my-message">搜索并添加系统中的用户为好友</p>
                                </div>
                            </div>
                        </div>
                    </button>
                    <button class="user-list-block-href" onmouseover="this.style.backgroundColor='#3A3F45'"
                            onmouseout="this.style.backgroundColor='#2e3238';"
                            onclick="createChat()">
                        <div class="user-list-block">
                            <div class="user-box">
                                <div class="user-info">
                                    <h3 class="my-name">创建群聊</h3>
                                    <p class="my-message">创建一个群聊，邀请好友加入</p>
                                </div>
                            </div>
                        </div>
                    </button>
                    <button class="user-list-block-href" onmouseover="this.style.backgroundColor='#3A3F45'"
                            onmouseout="this.style.backgroundColor='#2e3238';"
                            onclick="joinChat()">
                        <div class="user-list-block">
                            <div class="user-box">
                                <div class="user-info">
                                    <h3 class="my-name">加入群聊</h3>
                                    <p class="my-message">通过群号加入一个群聊</p>
                                </div>
                            </div>
                        </div>
                    </button>
                </div>
                <div id="article-list" style="display: none"></div>
                <div id="tweet-list" style="display: block">
                    <button class="user-list-block-href" onmouseover="this.style.backgroundColor='#3A3F45'"
                            onmouseout="this.style.backgroundColor='#2e3238';"
                            onclick="showWindowOnRight('post-tweet-box')">
                        <div class="user-list-block">
                            <div class="user-box">
                                <div class="user-info">
                                    <h3 class="my-name">发微博</h3>
                                    <p class="my-message">发布一条自己的微博分享自己的动态</p>
                                </div>
                            </div>
                        </div>
                    </button>
                    <button class="user-list-block-href" onmouseover="this.style.backgroundColor='#3A3F45'"
                            onmouseout="this.style.backgroundColor='#2e3238';"
                            onclick="loadSelectWeibo()">
                        <div class="user-list-block">
                            <div class="user-box">
                                <div class="user-info">
                                    <h3 class="my-name">查看微博</h3>
                                    <p class="my-message">按照分类查看微博</p>
                                </div>
                            </div>
                        </div>
                    </button>
                    <button class="user-list-block-href" onmouseover="this.style.backgroundColor='#3A3F45'"
                            onmouseout="this.style.backgroundColor='#2e3238';"
                            onclick="loadMyTweet(document.getElementById('tweet-box').dataset.page)">
                        <div class="user-list-block">
                            <div class="user-box">
                                <div class="user-info">
                                    <h3 class="my-name">我的微博</h3>
                                    <p class="my-message">查看自己发布的微博</p>
                                </div>
                            </div>
                        </div>
                    </button>
                    <button class="user-list-block-href" onmouseover="this.style.backgroundColor='#3A3F45'"
                            onmouseout="this.style.backgroundColor='#2e3238';"
                            onclick="loadPhoto(document.getElementById('photo-box').dataset.page)">
                        <div class="user-list-block">
                            <div class="user-box">
                                <div class="user-info">
                                    <h3 class="my-name">微博相册</h3>
                                    <p class="my-message">查看自己微博中的照片</p>
                                </div>
                            </div>
                        </div>
                    </button>
                </div>
                <div id="setting-list" style="display: none">
                    <button class="user-list-block-href" onmouseover="this.style.backgroundColor='#3A3F45'"
                            onmouseout="this.style.backgroundColor='#2e3238';"
                            onclick="showWindowOnRight('user-info-box')">
                        <div class="user-list-block">
                            <div class="user-box">
                                <div class="user-info">
                                    <h3 class="my-name">更新个人信息</h3>
                                    <p class="my-message">更新昵称/头像/个性签名/...</p>
                                </div>
                            </div>
                        </div>
                    </button>
                    <button class="user-list-block-href" onmouseover="this.style.backgroundColor='#3A3F45'"
                            onmouseout="this.style.backgroundColor='#2e3238';"
                            onclick="updatePassword()">
                        <div class="user-list-block">
                            <div class="user-box">
                                <div class="user-info">
                                    <h3 class="my-name">更新登陆密码</h3>
                                    <p class="my-message">更新账户的登陆密码</p>
                                </div>
                            </div>
                        </div>
                    </button>
                    <button class="user-list-block-href" onmouseover="this.style.backgroundColor='#3A3F45'"
                            onmouseout="this.style.backgroundColor='#2e3238';"
                            onclick="document.getElementById('background-upload-input').click()">
                        <form id="background-upload" method="post" enctype="multipart/form-data">
                            <input type="file" name="file" id="background-upload-input"
                                   accept="image/gif,image/jpeg,image/jpg,image/png,image/svg"
                                   oninput="updateBackground()"
                                   style="display: none">
                        </form>
                        <div class="user-list-block">
                            <div class="user-box">
                                <div class="user-info">
                                    <h3 class="my-name">更换聊天背景</h3>
                                    <p class="my-message">上传一张自己的图片作为聊天窗口的背景图</p>
                                </div>
                            </div>
                        </div>
                    </button>
                    <button class="user-list-block-href" onmouseover="this.style.backgroundColor='#3A3F45'"
                            onmouseout="this.style.backgroundColor='#2e3238';"
                            onclick="logout()">
                        <div class="user-list-block">
                            <div class="user-box">
                                <div class="user-info">
                                    <h3 class="my-name">退出登陆</h3>
                                    <p class="my-message">注销当前账号在此浏览器上的登陆</p>
                                </div>
                            </div>
                        </div>
                    </button>

                </div>
            </div>
            <!--END——功能列表-->

        </c:if>
        <!--END——登陆窗口-->
    </div>
    <!--END——菜单列表-->

    <!--BEGIN——右边窗口-->
    <div id="right-page" data-window="news-box">

        <!--BEGIN——聊天窗口-->
        <div id="0" class="chat-box" style="display:none;background: transparent;">
            <div id="${param.chat_id}accept-message" class="chat-output-box" style="padding-top: 20px;">
                <div class="chat-output-content-left">       
                    <img src="${pageContext.request.contextPath}/upload/photo/系统.jpg" alt="头像"
                         class="chat-output-head-photo-left">     
                    <h4 class="chat-output-meta-left">系统账号</h4>
                    <div class="chat-output-bubble-left">
                        <pre class="chat-output-bubble-pre-left"></pre>
                    </div>
                </div>
            </div>
        </div>
        <!--END——聊天窗口-->
        <!--BEGIN——用户信息窗口-->
        <div id="user-info-box" class="info-box" style="display: none">
            <div class="info-box-head">   
                <div class="info-box-title">       
                    <div class="info-box-title-box"><a class="info-box-title-text">个人信息</a></div>

                    <button id="update-user" onclick="updateUserInfo()"
                            style="float: right" class="button" contenteditable="false">更新
                    </button>


                </div>
            </div>
            <div id="${login.id}info" class="info-detail-box" onclick="enterClick('update-user')">
                   
                <div class="info-outline">
                    <div class="info-head-photo">
                        <img id="user-preview"
                             src="${pageContext.request.contextPath}/upload/photo/${login.photo}"
                             class="info-head-img"
                             onclick="document.getElementById('user-photo-input').click()" alt="用户头像">
                        <form id="user-photo" method="post" enctype="multipart/form-data">
                            <input type="file" name="file" id="user-photo-input"
                                   accept="image/gif,image/jpeg,image/jpg,image/png,image/svg"
                                   oninput="imgPreview(document.getElementById('user-photo-input'),'user-preview')"
                                   style="display: none">
                        </form>
                    </div>
                    <div class="info-head-info">
                        <h3 class="info-head-nickname">${login.name}</h3>
                    </div>
                </div>
                <div class="info-detail">
                    <div class="info-detail-block">
                        <div class="info-detail-item" contenteditable="false">昵称:</div>
                        <div class="info-detail-value" id="name" contenteditable="true">${login.name}</div>
                    </div>
                    <div class="info-detail-block">
                        <div class="info-detail-item">个性签名:</div>
                        <div class="info-detail-value" id="signature"
                             contenteditable="true">${login.signature}</div>
                    </div>
                    <div class="info-detail-block">
                        <div class="info-detail-item">微博账号:</div>
                        <div class="info-detail-value" id="weibo_id"
                             contenteditable="true">${login.weiboId}</div>
                    </div>
                    <div class="info-detail-block">
                        <div class="info-detail-item">性别:</div>
                        <div class="info-detail-value" id="gender"
                             contenteditable="true">${login.gender}</div>
                    </div>
                    <div class="info-detail-block">
                        <div class="info-detail-item">地区:</div>
                        <div class="info-detail-value" id="location"
                             contenteditable="true">${login.location}</div>
                    </div>
                </div>
            </div>
        </div>
        <!--END——用户信息窗口-->
        <!--BEGIN——搜索结果列表窗口-->
        <div id="search-result-box" class="info-box" style="display: none"></div>
        <!--END——搜索结果列表窗口-->
        <!--BEGIN——发微博窗口-->
        <div id="post-tweet-box" class="info-box" style="display: none">
            <div class="info-box-head">   
                <div class="info-box-title">       
                    <div class="info-box-title-box"><a class="info-box-title-text">写微博</a></div>
                    <button id="post-tweet" onclick="postMoment()" style="float: right;
                   border: solid 1px;width: 72px;"
                            contenteditable="false">发布
                    </button>
                </div>
            </div>
            <div id="${login.id}info" class="info-detail-box">
                <div class="info-outline">
                    <div class="info-head-photo">
                        <img id="tweet-preview" src="${pageContext.request.contextPath}/upload/photo/upload.jpg"
                             class="info-head-img"
                             onclick="document.getElementById('tweet-photo-input').click()">
                        <form id="tweet-photo" method="post" enctype="multipart/form-data"></form>
                        <input type="file" name="file" id="tweet-photo-input"
                               accept="image/gif,image/jpeg,image/jpg,image/png,image/svg"
                               oninput="imgPreview(document.getElementById('tweet-photo-input'),'tweet-preview')"
                               style="display: none" multiple>
                    </div>
                    <div class="info-head-info">
                        <h3 class="info-head-nickname" style="font-size: 30px">单击左侧上传图片</h3>
                    </div>
                </div>
                <div class="info-detail">
                    <label for="select-sort"></label>
                    <select class="button" id="select-sort" style="margin-left: 48px;float: left">
                        <option value="篮球" name="sort">篮球</option>
                        <option value="动漫" name="sort">动漫</option>
                        <option value="明星" name="sort">明星</option>
                        <option value="数码" name="sort">数码</option>
                        <option value="媒体" name="sort">媒体</option>
                        <option value="美女" name="sort">美女</option>
                        <option value="搞笑" name="sort">搞笑</option>
                        <option value="音乐" name="sort">音乐</option>
                    </select>
                    <div class="info-detail-block" style="margin-left: 20px">
                        <label for="tweet-content"></label>
                        <textarea class="input-text-content" style="width: 70%" id="tweet-content" autofocus="autofocus"
                                  cols="100"
                                  contenteditable="true" onchange="enterClick('post-tweet')" placeholder="分享自己的动态..."
                                  required="required" maxlength="800" oninput="enterClick('post-tweet')"></textarea>
                    </div>
                </div>
            </div>
        </div>
        <!--END——发微博窗口-->
        <!--BEGIN——查看微博窗口-->
        <div id="news-box" data-page="1" class="info-box" style="display: block">
            <div class="info-box-head">   
                <div class="info-box-title">       
                    <div class="info-box-title-box"><a class="info-box-title-text">微博</a></div>
                    <button onclick="nextWeiboPage();loadSelectWeibo();"
                            class="button" contenteditable="false">下页
                    </button>
                    <button onclick="lastWeiboPage();loadSelectWeibo();"
                            class="button" contenteditable="false">上页
                    </button>
                    <select id="load-weibo" onchange="loadSelectWeibo()" class="button">
                        <option value="全部" name="sort">全部</option>
                        <option value="篮球" name="sort">篮球</option>
                        <option value="体育" name="sort">体育</option>
                        <option value="动漫" name="sort">动漫</option>
                        <option value="明星" name="sort">明星</option>
                        <option value="数码" name="sort">数码</option>
                        <option value="媒体" name="sort">媒体</option>
                        <option value="美女" name="sort">美女</option>
                        <option value="搞笑" name="sort">搞笑</option>
                        <option value="音乐" name="sort">音乐</option>
                    </select>
                </div>
            </div>
            <div id="${login.id}info" class="info-detail-box">
                <div id="news-box-content" class="info-detail">
                </div>
            </div>
        </div>
        <!--END——查看微博窗口-->
        <!--BEGIN——查看我的微博窗口-->
        <div id="tweet-box" data-page="1" class="info-box" style="display: none">
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
            <div id="${login.id}info" class="info-detail-box">
                <div id="tweet-box-content" class="info-detail">
                </div>
            </div>
        </div>
        <!--END——查看我的微博窗口-->
        <!--BEGIN——查看相册窗口-->
        <div id="photo-box" data-page="1" class="info-box" style="display: none">
            <div class="info-box-head">   
                <div class="info-box-title">       
                    <div class="info-box-title-box"><a class="info-box-title-text">微博相册</a></div>
                    <button onclick="loadPhoto(++document.getElementById('photo-box').dataset.page)"
                            class="button" contenteditable="false">下页
                    </button>
                    <button onclick="loadPhoto(--document.getElementById('photo-box').dataset.page<1?
                   ++document.getElementById('photo-box').dataset.page:document.getElementById('photo-box').dataset.page)"
                            class="button" contenteditable="false">上页
                    </button>
                </div>
            </div>
            <div id="${login.id}info" class="info-detail-box">
                <div id="photo-box-content" class="info-detail" style="margin-top: 50px;">
                </div>
            </div>
        </div>
        <!--END——查看相册窗口-->
        <!--BEGIN——查看微博详情窗口-->
        <div id="news-detail-box" class="info-box" style="display: none">
            <div class="info-box-head">   
                <div class="info-box-title">       
                    <div class="info-box-title-box"><a class="info-box-title-text">微博</a></div>
                    <button onclick="loadWeibo(document.getElementById('news-box').dataset.sort,document.getElementById('news-box').dataset.page)"
                            class="button" contenteditable="false">返回
                    </button>
                </div>
            </div>
            <div id="${login.id}info" class="info-detail-box">
                <div id="news-detail-box-content" class="info-detail">
                </div>
            </div>
        </div>

        <!--END——查看微博详情窗口-->

    </div>

    <!--END——右边窗口-->

</div>
<!--BEGIN——监听键盘-->
<script>
    function enterClick(button_id) {
        document.onkeydown = function (event) {
            var e = event || window.event || arguments.callee.caller.arguments[0];
            if (e && e.keyCode === 13) {
                event.cancelBubble = true;
                event.preventDefault();
                event.stopPropagation();
                document.getElementById(button_id).click();
            }
        };
    }
</script>
<!--END——监听键盘-->
<!--BEGIN——程序执行脚本-->
<script>
    //创建群聊
    function createChat() {
        var name = prompt("请输入群聊名称", "广工夸夸群");
        if (name == null) {
            return;
        }
        if (name === '') {
            alert("您没有设置群聊名称，将使用默认名称");
        }
        var number = prompt("请输入群号", "");
        if (number == null) {
            return;
        }
        if (number === '') {
            alert("群号不可为空，必须由6-20位数字组成");
            return;
        }

        var url = "http://${host}/weibo/chat?method=add.do";
        var request = JSON.stringify({
            owner_id: "${login.id}",
            name: name,
            number: number
        });
        ajaxJsonRequest(url, request, function (result) {
            if (result.status === "SUCCESS") {
                addChat(number);
            }
        })
    }

    //修改好友信息
    function updateFriend(id) {
        var alias = prompt("请输入好友昵称", "蔡徐坤");
        if (alias == null) {
            return;
        }
        if (alias === '') {
            alert("昵称不能为空");
            return;
        }
        var description = prompt("请输入好友描述", "灵魂篮球练习生");
        var url = "http://${host}/weibo/friend?method=update.do";
        var request = JSON.stringify({
            id: id,
            alias: alias,
            description: description
        });
        ajaxJsonRequest(url, request, function (result) {
            if (result.status === "SUCCESS") {
                loadFriendList();
            }
        })
    }

    //加入群聊
    function joinChat() {
        var number = prompt("请输入群号", "");
        if (number == null) {
            return;
        }
        if (number === '') {
            alert("群号不可为空");
            return;
        }
        var apply = prompt("请输入加群申请(加群申请会作为你的第一条私信发送到群聊中)", "");
        if (confirm("是否确定发送加群申请？")) {
            var url = "http://${host}/weibo/chat";
            var request = {
                method: "join.do",
                user_id: ${login.id},
                number: number,
                apply: apply
            };
            postRequest(url, request, function (result) {
                if (result.status === "SUCCESS") {
                    addChat(number);
                }
            });
        } else {

        }
    }

    //加载一个聊天
    function addChat(number) {
        var url = "http://${host}/weibo/chat";
        var request = {
            method: "get.do",
            user_id: ${login.id},
            number: number
        };
        postRequest(url, request, function (result) {
            var chat = result.data;
            if (result.status === "SUCCESS") {
                loadChatListOnMenu(chat);
                loadChatBox(chat);
                loadUnReadMessageInAChat(chat.id, 1);
            }
        });
    }

    //更新密码
    function updatePassword() {
        var old_password = prompt("请输入旧密码", "");
        if (old_password == null) {
            return;
        }
        var new_password = prompt("请输入新密码", "");
        if (new_password == null) {
            return;
        }
        if (new_password === '') {
            alert("密码必须为6-20位英文字母，数字或下划线组成");
            return;
        }
        var url = "http://${host}/weibo/user";
        var request = {
            method: "updatepassword.do",
            user_id: ${login.id},
            old_password: old_password,
            new_password: new_password
        };
        postRequest(url, request, function (result) {
        });
    }

    //注销登陆
    function logout() {
        if (confirm("是否确定要退出登陆？注销之后你需要重新登陆")) {
            var url = 'http://${host}/weibo/user';
            var request = {
                method: "logout.do",
                user_id: ${login.id},
            };
            alert("正在退出登陆，请稍后...");
            postRequest(url, request, function (result) {
                if (result.status === 'SUCCESS') {
                    window.location.href = '${pageContext.request.contextPath}/login.jsp';
                }
            });
        } else {

        }
    }

    //请求搜索用户结果
    function searchUser() {
        var name = document.getElementById("keyword").value;
        if (name === '') {
            alert("请在输入框输入用户的昵称进行搜索");
            document.getElementById('keyword').focus();
            return;
        }
        var url = "http://${host}/weibo/user";
        var request = {
            method: "list.do",
            name: name
        };
        postRequest(url, request, function (result) {
            var users = result.data;
            if (users.length == 0) {
                return;
            }
            loadSearchResult();
            for (var i = 0; i < users.length; i++) {
                addSearchUserResultHtml(users[i]);
            }
        })
    }

    //显示群成员
    function showChatMember(chat_id) {
        alert("正在加载聊天信息，请稍后...");
        var url = "http://${host}/weibo/chat";
        var request = {
            method: "member.do",
            chat_id: chat_id
        };
        postRequest(url, request, function (result) {
            var members = result.data;
            if (members.length === 0) {
                return;
            }
            loadChatInfoHead(chat_id);
            for (var i = 0; i < members.length; i++) {
                addMemberHtml(members[i]);
            }
        })
    }

    //显示我的关注
    function showFollow(user_id) {
        var url = "http://${host}/weibo/friend";
        var request = {
            method: "follow.do",
            user_id: user_id
        };
        postRequest(url, request, function (result) {
            var users = result.data;
            if (users.length === 0) {
                return;
            }
            loadFollow();
            for (var i = 0; i < users.length; i++) {
                addFollowHtml(users[i]);
            }
        })
    }


    //显示我的粉丝
    function showFans(user_id) {
        var url = "http://${host}/weibo/friend";
        var request = {
            method: "fans.do",
            user_id: user_id
        };
        postRequest(url, request, function (result) {
            var users = result.data;
            if (users.length === 0) {
                return;
            }
            loadFans();
            for (var i = 0; i < users.length; i++) {
                addFansHtml(users[i]);
            }
        })
    }

    //清除聊天记录
    function deleteChatMessage(chat_id) {
        var url = "http://${host}/weibo/message";
        var request = {
            method: "clear.do",
            chat_id: chat_id,
            user_id: "${login.id}"
        };
        postRequest(url, request, function (result) {
        })
    }

    //显示聊天窗口
    function showChatBox(chat_id) {
        showWindowOnRight(chat_id);

        var url = "http://${host}/weibo/message";
        var request = {
            method: "read.do",
            user_id: ${login.id},
            chat_id: chat_id
        };
        postRequest(url, request, function (result) {

        })
    }

    //加载聊天列表，并且每个聊天加载隐藏的聊天窗口
    function loadChatListAndBox() {
        var url = "http://${host}/weibo/chat";
        var request = {
            method: "list.do",
            id: "${login.id}"
        };
        postRequest(url, request, function (result) {
            var chats = result.data;
            console.log("查询到聊天窗口数量：" + chats.length);
            for (var i = 0; i < chats.length; i++) {
                loadChatListOnMenu(chats[i]);
                loadChatBox(chats[i]);
            }
            loadUnReadMessage(1);
        });
    }

    //加载加载好友列表
    function loadFriendList() {
        var url = "http://${host}/weibo/friend";
        var request = {
            method: "list.do",
            user_id: "${login.id}"
        };
        postRequest(url, request, function (result) {
            document.getElementById("friend-list").innerHTML = ' <button class="user-list-block-href" onmouseover="this.style.backgroundColor=\'#3A3F45\'"\n' +
                '                        onmouseout="this.style.backgroundColor=\'#2e3238\';"\n' +
                '                        onclick="document.getElementById(\'search\').click()">\n' +
                '                    <div class="user-list-block">\n' +
                '                        <div class="user-box">\n' +
                '                            <div class="user-info">\n' +
                '                                <h3 class="my-name">查找用户</h3>\n' +
                '                                <p class="my-message">通过昵称搜索系统中的用户</p>\n' +
                '                            </div>\n' +
                '                        </div>\n' +
                '                    </div>\n' +
                '                </button>\n' +
                '                <button class="user-list-block-href" onmouseover="this.style.backgroundColor=\'#3A3F45\'"\n' +
                '                        onmouseout="this.style.backgroundColor=\'#2e3238\';"\n' +
                '                        onclick="createChat()">\n' +
                '                    <div class="user-list-block">\n' +
                '                        <div class="user-box">\n' +
                '                            <div class="user-info">\n' +
                '                                <h3 class="my-name">创建群聊</h3>\n' +
                '                                <p class="my-message">创建一个群聊，邀请好友加入</p>\n' +
                '                            </div>\n' +
                '                        </div>\n' +
                '                    </div>\n' +
                '                </button>\n' +
                '                <button class="user-list-block-href" onmouseover="this.style.backgroundColor=\'#3A3F45\'"\n' +
                '                        onmouseout="this.style.backgroundColor=\'#2e3238\';"\n' +
                '                        onclick="joinChat()">\n' +
                '                    <div class="user-list-block">\n' +
                '                        <div class="user-box">\n' +
                '                            <div class="user-info">\n' +
                '                                <h3 class="my-name">加入群聊</h3>\n' +
                '                                <p class="my-message">通过群号加入一个群聊</p>\n' +
                '                            </div>\n' +
                '                        </div>\n' +
                '                    </div>\n' +
                '                </button>';
            var friends = result.data;
            for (var i = 0; i < friends.length; i++) {
                loadFriendOnMenu(friends[i]);
            }
        });
    }

    //加载未读私信
    function loadUnReadMessage(page) {
        var url = "http://${host}/weibo/message";
        var request = {
            method: "unread.do",
            user_id: "${login.id}",
            page: page
        };
        postRequest(url, request, function (result) {
            var messages = result.data;
            console.log("查询到未读私信 ： " + messages.length);

            for (var i = messages.length - 1; i >= 0; i--) {
                showMessage(messages[i]);
            }
        });
    }

    //加载一个聊天的未读私信
    function loadUnReadMessageInAChat(chat_id, page) {
        var url = "http://${host}/weibo/message";
        var request = {
            method: "unread.do",
            user_id: "${login.id}",
            chat_id: chat_id,
            page: page
        };
        postRequest(url, request, function (result) {
            var messages = result.data;
            console.log("查询到未读私信 ： " + messages.length);
            for (var i = messages.length - 1; i >= 0; i--) {
                showMessage(messages[i]);
            }
        });
    }

    //加载一个聊天中的所有私信
    function loadAllMessage(page, chat_id) {
        var url = "http://${host}/weibo/message";
        var request = {
            method: "list.do",
            user_id: "${login.id}",
            chat_id: chat_id,
            page: page,
        };
        postRequest(url, request, function (result) {
            document.getElementById(chat_id + "accept-message").innerHTML = '';
            var messages = result.data;
            for (var i = messages.length - 1; i >= 0; i--) {
                showMessage(messages[i]);
            }
        });
    }

    //加载微博
    function loadSelectWeibo() {
        var page = document.getElementById('news-box').dataset.page;
        var select = document.getElementById("load-weibo");
        var index = select.selectedIndex;
        var sort = select[index].value;
        if ("全部" === sort) {
            loadWeibo(null, page);
        } else {
            loadWeibo(sort, page);
        }
    }

    //加载微博动态
    function loadWeibo(sort, page) {
        var url = "http://${host}/weibo/tweet";
        var request = {
            method: "list.do",
            user_id: "${login.id}",
            page: page,
            sort: sort
        };
        alert("正在加载微博动态，请稍后...");
        postRequest(url, request, function (result) {
            var news = result.data;
            //加载之前先将之前的清空
            document.getElementById('news-box-content').innerHTML = '';
            for (var i = 0; i <= news.length - 1; i++) {
                addNewsBlockHtml(news[i]);
            }
        });
        showWindowOnRight('news-box');
    }

    //加载我的微博
    function loadMyTweet(page) {
        var url = "http://${host}/weibo/tweet";
        var request = {
            method: "tweet.do",
            user_id: "${login.id}",
            page: page
        };
        alert("正在加载您的微博，请稍后...");
        postRequest(url, request, function (result) {
            var tweets = result.data;
            //加载之前先将之前的清空
            document.getElementById('tweet-box-content').innerHTML = '';
            for (var i = 0; i < tweets.length; i++) {
                addMomentBlockHtml(tweets[i]);
            }
        });
        showWindowOnRight('tweet-box');
    }

    //查询微博图片
    function loadPhoto(page) {
        var url = 'http://${host}/weibo/tweet';
        var request = {
            method: "photo.do",
            user_id: ${login.id},
            page: page
        };
        alert("正在加载微博相册，请稍后...");
        postRequest(url, request, function (result) {
            var photos = result.data;
            //加载之前先将之前的清空
            document.getElementById('photo-box-content').innerHTML = '';
            for (var i = 0; i < photos.length; i++) {
                addPhotoHtml(photos[i]);
            }
        });
        showWindowOnRight('photo-box');
    }

    //删除微博
    function deleteMoment(tweet_id) {
        if (confirm("是否确定要删除这条微博？")) {
            var url = 'http://${host}/weibo/tweet';
            var request = {
                method: "delete.do",
                tweet_id: tweet_id
            };
            postRequest(url, request, function (result) {
            });
        } else {

        }
    }

    //删除微博评论
    function deleteRemark(remark_id, tweet_id) {
        if (confirm("是否确定要删除这条评论？")) {
            var url = 'http://${host}/weibo/remark';
            var request = {
                method: "delete.do",
                remark_id: remark_id
            };
            postRequest(url, request, function (result) {
                addMomentDetailHtml(tweet_id);
            });
        } else {

        }
    }

    //取消关注
    function deleteFriend(friend_id) {
        if (confirm("是否确定要取消关注？")) {
            var url = 'http://${host}/weibo/friend';
            var request = {
                method: "delete.do",
                user_id: ${login.id},
                friend_id: friend_id
            };
            alert("正在取消关注，请稍后...");
            postRequest(url, request, function (result) {
                loadFriendList();
            });
        } else {

        }
    }

    //冻结用户
    function freezeUser(user_id) {
        if (confirm("是否确定要冻结该用户？")) {
            var url = 'http://${host}/weibo/user';
            var request = {
                method: "freeze.do",
                user_id: user_id
            };
            postRequest(url, request, function (result) {
            });
        } else {

        }
    }

    //加好友
    function addFriend(friend_id) {

        var url = "http://${host}/weibo/friend?method=add.do";
        var description = "我是${login.name},我关注了你！";
        var alias = "";
        if (description === null) {
            return;
        }
        var request = JSON.stringify({
            user_id: "${login.id}",
            friend_id: friend_id,
            description: description,
            alias: alias
        });
        if (alias === null) {
            return;
        }
        ajaxJsonRequest(url, request, function (result) {
        })
    }

    //同意加好友
    function agreeAddFriend(friend_id) {
        if (confirm("是否确定同意好友申请？")) {
            console.log("同意加好友：friend_id " + friend_id);
            var url = "http://${host}/weibo/friend?method=add.do";
            var alias = prompt("请输入好友备注", "");
            if (alias == null) {
                return;
            }
            var request = JSON.stringify({
                user_id: "${login.id}",
                friend_id: friend_id,
                alias: alias
            });
            alert("正在同意好友申请，请稍后...");
            ajaxJsonRequest(url, request, function (result) {
            })
        } else {

        }
    }

    //退出群聊
    function quitChat(chat_id) {
        if (confirm("是否确定要退出该群聊？")) {
            var url = "http://${host}/weibo/chat?method=quit.do";
            var request = JSON.stringify({
                user_id: "${login.id}",
                chat_id: chat_id,
            });
            alert("正在退出群聊，请稍后...");
            ajaxJsonRequest(url, request, function (result) {
            })
        } else {

        }
    }

    //更新个人信息
    function updateUserInfo() {
        if (confirm("是否确定更新个人信息？")) {
            var jsonStr = JSON.stringify({
                id: "${login.id}",
                name: document.getElementById("name").innerText,
                signature: document.getElementById("signature").innerText,
                weibo_id: document.getElementById("weibo_id").innerText,
                gender: document.getElementById("gender").innerText,
                location: document.getElementById("location").innerText
            });
            //更新基本信息
            alert("正在更新个人信息，请稍后...");
            var url = "http://${host}/weibo/user?method=update.do";
            ajaxJsonRequest(url, jsonStr, function (result) {
                if ("SUCCESS" === result.status) {
                } else {
                }
            });
            //更新头像
            url = "http://${host}/weibo/upload?method=uploadphoto.do&id=${login.id}&table=user";
            uploadPhoto(url, "user-photo");
        } else {

        }
    }

    //更新聊天背景
    function updateBackground() {
        imgPreview(document.getElementById('background-upload-input'), 'background');
        var url = "http://${host}/weibo/upload?method=background.do&id=${login.id}";
        alert("正在更新聊天背景，请稍后...");
        uploadPhoto(url, 'background-upload');
    }

    //发布微博
    function postMoment() {
        var content = document.getElementById("tweet-content").value;
        if (!('' === content)) {
            //上传图片
            var url = "http://${host}/weibo/upload?method=uploadfile.do";
            var img = document.getElementById('tweet-photo-input').files;
            if (img.length > 0) {
                content += "</br>";
            }
            for (var i = 0; i < img.length; i++) {
                var formData = new FormData();
                formData.append('file', img[i]);
                uploadFile(url, formData, function (filename) {
                    var html = '<img src="${pageContext.request.contextPath}/upload/file/' + filename + '"' + 'style="height: 100%;width: 100%;max-height:200px;max-width:200px;">\n';
                    content += html;
                });
            }
            var select = document.getElementById("select-sort");
            var index = select.selectedIndex;
            var jsonStr = JSON.stringify({
                owner_id: "${login.id}",
                content: content,
                sort: select[index].value
            });
            url = "http://${host}/weibo/tweet?method=add.do";
            alert("正在发布微博，请稍后...");
            ajaxJsonRequest(url, jsonStr, function (result) {
            });
            document.getElementById("tweet-content").value = '';
        } else {
            alert("发送内容不能为空");

        }
    }


    //转发微博
    function shareTweet(tweet_id) {
        var content = prompt("请输入转发评论", "转发微博");
        var jsonStr = JSON.stringify({
            owner_id: "${login.id}",
            content: content,
            origin_id: tweet_id,
        });
        url = "http://${host}/weibo/tweet?method=add.do";
        ajaxJsonRequest(url, jsonStr, function (result) {
        });
    }


    //点赞微博
    function loveMoment(tweet_id, moment_love) {
        var url = 'http://${host}/weibo/tweet';
        var request = {
            method: "love.do",
            tweet_id: tweet_id,
            user_id:${login.id},
        };
        postRequest(url, request, function (result) {
            var islove = result.data;
            var love = parseInt(document.getElementById(tweet_id + "love").dataset.love);
            console.log("当前点赞数" + love);
            if (islove) {
                document.getElementById(tweet_id + "love").innerText = '点赞(' + (love + 1) + ')';
                document.getElementById(tweet_id + "love").dataset.love = love + 1;
            } else {
                document.getElementById(tweet_id + "love").innerText = '点赞(' + (love - 1) + ')';
                document.getElementById(tweet_id + "love").dataset.love = love - 1;
            }
        });
    }

    //评论微博//TODO
    function remarkMoment(tweet_id) {
        var content = prompt("请输入评论", '');
        if (content == null) {
            return;
        }
        var time = new Date().getTime();
        var url = "http://${host}/weibo/remark?method=add.do";
        var request = JSON.stringify({
            user_id: "${login.id}",
            tweet_id: tweet_id,
            time: time,
            content: content
        });
        if (!('' === content || content == null)) {
            if (confirm("是否确定要发布该评论？")) {
                alert("正在发布评论，请稍后...");
                ajaxJsonRequest(url, request, function (result) {
                    var remark = parseInt(document.getElementById(tweet_id + "remark").dataset.remark);
                    console.log("当前评论数" + remark);
                    document.getElementById(tweet_id + "remark").dataset.remark = remark + 1;
                    document.getElementById(tweet_id + "remark").innerText = '评论(' + (remark + 1) + ')';
                    addMomentDetailHtml(tweet_id);
                })
            } else {

            }
        } else {
            alert("评论内容不能为空");

        }
    }

    //回复一条评论
    function replyRemark(tweet_id, user_name) {
        var content = prompt("请输入回复", "");
        if (content == null) {
            return;
        }
        content = "@" + user_name + " " + content;
        var time = new Date().getTime();
        var url = "http://${host}/weibo/remark?method=add.do";
        var request = JSON.stringify({
            user_id: "${login.id}",
            tweet_id: tweet_id,
            time: time,
            content: content
        });
        if (!('' === content)) {
            if (confirm("是否确定要发布该回复？")) {
                alert("正在发布回复，请稍后...");
                ajaxJsonRequest(url, request, function (result) {
                    var remark = parseInt(document.getElementById(tweet_id + "remark").dataset.remark);
                    document.getElementById(tweet_id + "remark").dataset.remark = remark + 1;
                    document.getElementById(tweet_id + "remark").innerText = '评论(' + (remark + 1) + ')';
                    addMomentDetailHtml(tweet_id);

                })
            } else {

            }
        } else {
            alert("回复内容不能为空");

        }
    }

    //发送图片
    function send_img(fileDom, file_id, preview, chat_id) {
        //判断是否支持FileReader
        if (window.FileReader) {
            var reader = new FileReader();
        } else {
            alert("您的设备不支持文件预览功能，如需该功能请升级您的设备！");
        }
        //获取文件
        var file = fileDom.files[0];
        //文件大小
        var size = (file.size / 1024) / 1024;
        console.log("size" + size);
        var imageType = /^image\//;
        //是否是图片
        if (!imageType.test(file.type)) {
            alert("该文件不是图片或者已经损坏，请重新选择！");
            return;
        }
        if (size > 5) {
            alert("图片大小不能大于5m！");
            file.value = "";
            return;
        } else if (size <= 0) {
            alert("文件大小不能为0M！");
            file.value = "";
            return;
        }
        //读取完成
        reader.onload = function () {
        };
        reader.readAsDataURL(file);
        if (confirm("是否确定要立即发送图片：" + file.name)) {
            //upload-file
            var formData = new FormData();
            var url = "http://${host}/weibo/upload?method=uploadfile.do";
            formData.append('file', document.getElementById(file_id).files[0]);
            uploadFile(url, formData, function (filename) {
                var html = '<img src="${pageContext.request.contextPath}/upload/file/' + filename + '"\n' +
                    '         style="height: 100%;width: 100%;max-height:200px;max-width:200px;">\n';
                document.getElementById(preview).value += html;
                sendMessage(chat_id, "img");

            })
        } else {
            return;
        }
    }

    //上传图片
    function uploadPhoto(url, photo_id) {
        var formElement = document.getElementById(photo_id);
        var formData = new FormData(formElement);
        ajax({
            url: url,
            type: 'POST',
            data: formData,
            success: function (data) {
                var result = eval("(" + data + ")");
                if (result.message != null && result.message !== '') {
                    alert("系统提示：" + result.message);
                }
                callback(result);
            },
            error: function (xhr, error, exception) {
                alert("请求发送失败，请刷新浏览器重试或检查网络");
                alert(exception.toString());
            }
        });
    }

    //上传文件，返回文件名
    function uploadFile(url, formData, callback) {
        ajax({
            url: url,
            type: 'POST',
            data: formData,
            async: false,
            success: function (data) {
                var result = eval("(" + data + ")");
                if (result.message != null && result.message !== '') {
                    alert("系统提示：" + result.message);
                }
                callback(result.data);
            },
            error: function (xhr, error, exception) {
                alert("请求发送失败，请刷新浏览器重试或检查网络");
                alert(exception.toString());
            }
        });
    }

    //加载聊天列表
    function loadChatListOnMenu(chat) {
        var chat_html = '<button class="user-list-block-href"  onmouseover="this.style.backgroundColor=\'#3A3F45\';" ' +
            'onmouseout="this.style.backgroundColor=\'#2e3238\';"' +
            'onclick="showChatBox(\'' + chat.id + '\')"><div class="user-list-block">\n' +
            '                <div class="user-box" >\n' +
            '                    <div class="user-photo">\n' +
            '                        <img src="${pageContext.request.contextPath}/upload/photo/' + chat.photo + '" alt="用户头像" class="my-photo">\n' +
            '                    </div>\n' +
            '                    <div class="user-info">\n' +
            '                        <h3 class="my-name">' + chat.name + '</h3>\n' +
            '                        <p class="my-message" id="' + chat.id + 'new-message">没有新私信</p>\n' +
            '                    </div>\n' +
            '                </div>\n' +
            '            </div></button>';
        document.getElementById("chat-list").innerHTML += chat_html;
    }

    //加载通知列表
    function loadNotify(notify) {
        var html = '        <button class="user-list-block-href" onmouseover="this.style.backgroundColor=#3A3F45;"\n' +
            '                        onmouseout="this.style.backgroundColor=#2e3238;"\n' +
            '                        onclick="">\n' +
            '                    <div class="user-list-block">\n' +
            '                        <div class="user-box">\n' +
            '                            <div class="user-photo">\n' +
            '                                <img src="${pageContext.request.contextPath}/upload/photo/' + friend.photo + '  " alt="用户头像" class="my-photo">\n' +
            '                            </div>\n' +
            '                            <div class="user-info">\n' +
            '                                <h3 class="my-name"></h3>\n' +
            '                                <p class="my-message">' + friend.description + ' </p>\n' +
            '                            </div>\n' +
            '                        </div>\n' +
            '                    </div>\n' +
            '                    <button id="" onclick="postMoment()" style="float: right;\n' +
            '                    background-color:#1AAD19;border: solid 1px;width: 100px;margin-right: 50px"\n' +
            '                            contenteditable="false">发布\n' +
            '                    </button>\n' +
            '                </button>';
        document.getElementById("notify-list").innerHTML += chat_html;
    }

    //加载好友列表
    function loadFriendOnMenu(friend) {
        var chat_html = '<button class="user-list-block-href"  onmouseover="this.style.backgroundColor=\'#3A3F45\';" ' +
            'onmouseout="this.style.backgroundColor=\'#2e3238\';"' +
            '><div class="user-list-block">\n' +
            '                <div class="user-box" onclick="updateFriend(\'' + friend.id + '\')">\n' +
            '                    <div class="user-photo">\n' +
            '                        <img src="${pageContext.request.contextPath}/upload/photo/' + friend.photo + '" alt="用户头像" class="my-photo">\n' +
            '                    </div>\n' +
            '                    <div class="user-info">\n' +
            '                        <h3 class="my-name">' + friend.alias + '</h3>\n' +
            '                        <p class="my-message">' + friend.description + '</p>\n' +
            '                    </div>\n' +
            '                </div>\n' +
            '            </div>  ' +
            '<div class="menu-option-item">\n' +
            '                <div id="chat" onclick="showChatBox(\'' + friend.chat_id + '\')" class="menu-option-button">发私信</div>\n' +
            '            </div>          ' +
            '<div class="menu-option-item">\n' +
            '                <div id="chat"  onclick="deleteFriend(\'' + friend.friend_id + '\')" class="menu-option-button" style="float: right">取消关注</div>\n' +
            '            </div></button>';
        document.getElementById("friend-list").innerHTML += chat_html;
    }

    //加载好友通知
    function loadAddFriendOnMenu(message) {
        var chat_html = '<button class="user-list-block-href"  onmouseover="this.style.backgroundColor=\'#3A3F45\';" ' +
            'onmouseout="this.style.backgroundColor=\'#2e3238\';"' +
            '><div class="user-list-block">\n' +
            '                <div class="user-box" >\n' +
            '                    <div class="user-photo">\n' +
            '                        <img src="${pageContext.request.contextPath}/upload/photo/' + message.sender_photo + '" alt="用户头像" class="my-photo">\n' +
            '                    </div>\n' +
            '                    <div class="user-info">\n' +
            '                        <h3 class="my-name">' + message.sender_name + '</h3>\n' +
            '                        <p class="my-message">' + message.content + '</p>\n' +
            '                    </div>\n' +
            '                </div>\n' +
            '            </div>  ' +
            '<div class="menu-option-item">\n' +
            '                <div id="chat" onclick="agreeAddFriend(\'' + message.sender_id + '\')" class="menu-option-button">同意</div>\n' +
            '            </div>          ';
        document.getElementById("friend-list").innerHTML += chat_html;
    }

    //加载搜索结果页面，并显示
    function loadSearchResult() {
        document.getElementById("search-result-box").innerHTML =
            '            <div class="info-box-head">          \n' +
            '                <div class="info-box-title">                  \n' +
            '                    <div class="info-box-title-box"><a class="info-box-title-text">用户列表</a></div>\n' +
            '                </div>\n' +
            '            </div>\n' +
            '            <div class="info-detail-box">                  \n' +
            '                <div id="content" class="info-detail">           \n' +
            '                    <div></div>\n' +
            '                </div>\n' +
            '            </div>\n';

        showWindowOnRight("search-result-box");
    }

    //加载群聊信息
    function loadChatInfoHead(chat_id) {
        document.getElementById("search-result-box").innerHTML =
            '                <div class="chat-box-title">       \n' +
            '                        <a class="chat-box-title-text">聊天成员列表</a>       \n' +
            '                </div>\n' +
            '            <div class="info-detail-box">                  \n' +
            '                <div id="content" class="info-detail">           \n' +
            '                    <div></div>\n' +
            '                </div>\n' +
            '            </div>\n';

        showWindowOnRight("search-result-box");
    }

    //加载关注信息
    function loadFollow() {
        document.getElementById("search-result-box").innerHTML =
            '                <div class="chat-box-title">       \n' +
            '                        <a class="chat-box-title-text">我的关注</a>       \n' +
            '                </div>\n' +
            '            <div class="info-detail-box">                  \n' +
            '                <div id="content" class="info-detail">           \n' +
            '                    <div></div>\n' +
            '                </div>\n' +
            '            </div>\n';

        showWindowOnRight("search-result-box");
    }

    //加载粉丝
    function loadFans() {
        document.getElementById("search-result-box").innerHTML =
            '                <div class="chat-box-title">       \n' +
            '                        <a class="chat-box-title-text">我的粉丝</a>       \n' +
            '                </div>\n' +
            '            <div class="info-detail-box">                  \n' +
            '                <div id="content" class="info-detail">           \n' +
            '                    <div></div>\n' +
            '                </div>\n' +
            '            </div>\n';

        showWindowOnRight("search-result-box");
    }

    //让该id对应的窗口显示出来，并把之前的隐藏起来
    function showWindowOnRight(window_id) {
        var current_window = document.getElementById("right-page").dataset.window;
        console.log("隐藏窗口id : " + current_window);
        document.getElementById(current_window).style.display = "none";
        document.getElementById(window_id).style.display = "";
        document.getElementById("right-page").dataset.window = window_id;
        console.log("当前窗口id : " + document.getElementById("right-page").dataset.window);
    }

    //让该id对应的窗口显示出来，并把之前的隐藏起来
    function showWindowOnLeft(window_id) {
        var current_window = document.getElementById("menu-body").dataset.window;
        console.log("隐藏窗口id : " + current_window);
        document.getElementById(current_window).style.display = "none";
        document.getElementById(window_id).style.display = "";
        document.getElementById("menu-body").dataset.window = window_id;
        console.log("当前窗口id : " + document.getElementById("menu-body").dataset.window);
    }

    //加载图片
    function imgPreview(fileDom, preview) {
        //判断是否支持FileReader
        if (window.FileReader) {
            var reader = new FileReader();
        } else {
            alert("您的设备不支持图片预览功能，如需该功能请升级您的设备！");
        }
        //获取文件
        var file = fileDom.files[0];
        var imageType = /^image\//;
        //是否是图片
        if (!imageType.test(file.type)) {
            alert("该文件不是图片或者已经损坏，请重新选择！");
            return;
        }
        //图片大小
        var size = (file.size / 1024) / 1024;
        console.log("size" + size);
        if (size > 5) {
            alert("图片大小不能大于5m！");
            file.value = "";
            return;
        } else if (size <= 0) {
            alert("文件大小不能为0M！");
            file.value = "";
            return;
        }

        //读取完成
        reader.onload = function (e) {
            //获取图片dom
            var img = document.getElementById(preview);
            //图片路径设置为读取的图片
            img.src = e.target.result;
        };
        reader.readAsDataURL(file);

    }

    //动态加载聊天窗口，不显示loadAllMessage(page, chat_id)
    function loadChatBox(chat) {
        var html =
            '<div id="' + chat.id + '" class="chat-box" style="display: none;background: transparent;">\n' +
            '            <div class="chat-box-title">\n' +
            '                    <button onclick="quitChat(\'' + chat.id + '\')"\n' +
            '                            class="button" contenteditable="false">退出聊天\n' +
            '                    </button>\n' +
            '         <button \n' +
            '                            onclick="deleteChatMessage(\'' + chat.id + '\')"\n' +
            '                            class="button" contenteditable="false">清除聊天记录\n' +
            '                    </button>' +
            '         <button \n' +
            '                            onclick="showChatMember(\'' + chat.id + '\')"\n' +
            '                            class="button" contenteditable="false">聊天信息\n' +
            '                    </button>' +
            '         <button \n' +
            '                            onclick="loadAllMessage(\'1\',\'' + chat.id + '\')"\n' +
            '                            class="button" contenteditable="false">加载已读私信\n' +
            '                    </button>' +
            '                    <p class="chat-box-title-text">\n' +
            '                        ' + chat.name + '\n' +
            '                    </p>\n' +

            '            </div>\n' +
            '<div class="chat-box-head">\n' +
            '        </div>\n' +
            '        <div id="' + chat.id + 'accept-message" class="chat-output-box" style="background: transparent;">\n' +
            '        </div>\n' +
            '        <div class="chat-input-box" style="background-color:#eee;" >\n' +
            '            <button id="' + chat.id + 'send-button" onclick="sendMessage(\'' + chat.id + '\',\'user\')"  style="float: left" class="button">发送</button>\n' +


            '      <input type="file" name="file" id="' + chat.id + 'send-file"\n' +
            '                               oninput="send_file(document.getElementById(\'' + chat.id + 'send-file\'),\'' + chat.id + 'send-file\',\'' + chat.id + 'send-message\',\'' + chat.id + '\')"\n' +
            '                               style="display: none">' +
            '            <button onclick="document.getElementById(\'' + chat.id + 'send-file\').click()" style="float: left" class="' +
            'button">文件</button>\n' +

            '      <input type="file" name="file" id="' + chat.id + 'send-img"\n' +
            '                               oninput="send_img(document.getElementById(\'' + chat.id + 'send-img\'),\'' + chat.id + 'send-img\',\'' + chat.id + 'send-message\',\'' + chat.id + '\')"\n' +
            '                               style="display: none">' +
            '            <button  onclick="document.getElementById(\'' + chat.id + 'send-img\').click()" style="float: left" class="button">图片</button>\n' +

            '            <textarea id="' + chat.id + 'send-message" class="text-area" autofocus="autofocus" cols="100"\n' +
            '                      required="required" maxlength="300"  oninput="enterClick(\'' + chat.id + 'send-button\')"></textarea>\n' +
            '        </div></div>';
        document.getElementById("right-page").innerHTML += html;
    }

    //发送私信
    function sendMessage(chat_id, type) {
        if (websocket === null) {
            alert("正在初始化websocket连接，第一次连接需要加载数据，请稍后...");
            return;
        }
        if (websocket === '') {
            alert("您已断开与服务器的连接，可能您的账号已在别处登陆，请刷新浏览器重新连接服务器");
            return;
        }
        var content = document.getElementById(chat_id + 'send-message').value;
        if (!('' === content)) {
            var user_id = "${login.id}";
            var time = new Date().getTime();
            websocket.send(JSON.stringify({
                sender_id: user_id,
                chat_id: chat_id,
                content: content,
                type: type,
                time: time
            }));
            //发送完之后将私信清空
            document.getElementById(chat_id + 'send-message').value = '';
        } else {
            alert("发送内容不能为空");

        }
    }

    //发送文件
    function send_file(fileDom, file_id, preview, chat_id) {
        //判断是否支持FileReader
        if (window.FileReader) {
            var reader = new FileReader();
        } else {
            alert("您的设备不支持文件预览功能，如需该功能请升级您的设备！");
        }
        //获取文件
        var file = fileDom.files[0];
        //文件大小
        var size = (file.size / 1024) / 1024;
        console.log("size" + size);
        if (size > 20) {
            alert("文件大小不能大于20m！");
            file.value = "";
            return;
        } else if (size <= 0) {
            alert("文件大小不能为0M！");
            file.value = "";
            return;
        }
        if (confirm("是否确定要立即发送文件：" + file.name)) {
            //upload-file
            var formData = new FormData();
            var url = "http://${host}/weibo/upload?method=uploadfile.do";
            formData.append('file', document.getElementById(file_id).files[0]);
            ajax({
                url: url,
                type: 'POST',
                cache: false,
                data: formData,
                success: function (data) {
                    var result = eval("(" + data + ")");
                    if (result.message != null && result.message !== '') {
                        alert("系统提示：" + result.message);
                    }
                    if ("SUCCESS" === result.status) {
                        var html = '<a href="http://${host}/upload/file/' + result.data + '" download="' + file.name + '">下载</a>';
                        document.getElementById(preview).value += '[文件：' + file.name + ']' + html;
                        sendMessage(chat_id, "file");
                    }
                },
                error: function (xhr, error, exception) {
                    alert(exception.toString());
                }
            });
        } else {

        }
    }


    //移除一个成员
    function removeMember(member_id, chat_id) {
        if (confirm("是否确定要移除该成员？")) {
            var url = 'http://${host}/weibo/chat';
            var request = {
                method: "remove.do",
                member_id: member_id,
            };
            alert("正在移除该成员，请稍后...");
            postRequest(url, request, function (result) {
                if ('SUCCESS' === result.status) {
                    showChatMember(chat_id);
                }
            });
        } else {

        }
    }

    //插入一个搜索用户的结果
    function addSearchUserResultHtml(user) {
        var html = '<div class="info-detail-block" style="  width: 95%;min-width:300px;">               \n' +
            ' <div class="user-photo" style="margin: 20px">\n' +
            ' <img src="${pageContext.request.contextPath}/upload/photo/' + user.photo + '" alt="用户头像" class="my-photo" onclick="showHome(' + user.id + ')">\n' +
            '    </div>\n' +
            '   <div class="user-info">\n' +
            '   <h3 class="my-name" style="color: #333;width: fit-content;">' + user.name + '</h3>\n' +
            '        <button onclick="addFriend(\'' + user.id + '\')" class="button"\n' +
            '   contenteditable="false">加关注\n' +
            '        </button>\n' +
            '         </div>\n' +
            '                                <p class="my-message" style="margin-top:-25px;width: 70%;">' + user.signature + '</p>\n' +
            '                    </div>';
        document.getElementById("content").innerHTML += html;
    }


    //插入一个关注用户
    function addFollowHtml(friend) {
        var html = '<div class="info-detail-block" style="  width: 95%;min-width:300px;">               \n' +
            ' <div class="user-photo" style="margin: 20px">\n' +
            ' <img src="${pageContext.request.contextPath}/upload/photo/' + friend.photo + '" alt="用户头像" class="my-photo" onclick="showHome(' + friend.id + ')">\n' +
            '    </div>\n' +
            '   <div class="user-info">\n' +
            '   <h3 class="my-name" style="color: #333;width: fit-content;">' + friend.alias + '</h3>\n' +
            '        <button onclick="deleteFriend(\'' + friend.friend_id + '\')" class="button"\n' +
            '   contenteditable="false">取消关注\n' +
            '        </button>\n' +
            '         </div>\n' +
            '                                <p class="my-message" style="margin-top:-25px;width: 70%;"></p>\n' +
            '                    </div>';
        document.getElementById("content").innerHTML += html;
    }

    //插入一个粉丝用户
    function addFansHtml(user) {
        var html = '<div class="info-detail-block" style="  width: 95%;min-width:300px;">               \n' +
            ' <div class="user-photo" style="margin: 20px">\n' +
            ' <img src="${pageContext.request.contextPath}/upload/photo/' + user.photo + '" alt="用户头像" class="my-photo" onclick="showHome(' + user.id + ')">\n' +
            '    </div>\n' +
            '   <div class="user-info">\n' +
            '   <h3 class="my-name" style="color: #333;width: fit-content;">' + user.name + '</h3>\n' +
            '        <button onclick="addFriend(\'' + user.id + '\')" class="button"\n' +
            '   contenteditable="false">加关注\n' +
            '        </button>\n' +
            '         </div>\n' +
            '                                <p class="my-message" style="margin-top:-25px;width: 70%;"></p>\n' +
            '                    </div>';
        document.getElementById("content").innerHTML += html;
    }

    //插入一个群成员的信息
    function addMemberHtml(member) {
        var html = '  <div class="info-detail-block" style="  width: 95%;min-width:300px;">               \n' +
            // '   <div class="user-box" style="border-top: 1px solid;margin: 20px;">\n' +
            ' <div class="user-photo" style="margin: 20px">\n' +
            ' <img src="${pageContext.request.contextPath}/upload/photo/' + member.photo + '" alt="用户头像" class="my-photo">\n' +
            ' </div>\n' +
            ' <div class="user-info">\n' +
            ' <h3 class="my-name" style="color: #333;width: fit-content;">' + member.name + '</h3>\n' +
            ' <button onclick="removeMember(\'' + member.id + '\',\'' + member.chat_id + '\')" class="button"\n' +
            ' contenteditable="false">移出该群\n' +
            ' </button>\n' +
            ' <button onclick="addFriend(\'' + member.user_id + '\')" class="button"\n' +
            ' contenteditable="false">加好友\n' +
            ' </button>\n' +
            ' </div>\n' +
            ' <p class="my-message" style="margin-top:-25px;width: 60%;">' + member.signature + '</p>\n' +
            // '</div>\n' +
            ' </div>';
        document.getElementById("content").innerHTML += html;
    }


    //显示微博详情
    function addMomentDetailHtml(tweet_id) {
        var html = '           <div id="' + tweet_id + '" class="info-detail-block" style="margin-left: 20px">\n' +
            document.getElementById(tweet_id).innerHTML +
            '                    </div>';
        document.getElementById("news-detail-box-content").innerHTML = html;
        loadRemark(tweet_id, 1);
        showWindowOnRight('news-detail-box');
    }

    //加载评论
    function loadRemark(tweet_id, page) {
        var url = "http://${host}/weibo/remark";
        var request = {
            method: "list.do",
            tweet_id: tweet_id,
            page: page
        };
        alert("正在加载评论，请稍侯...");
        postRequest(url, request, function (result) {
            var remarks = result.data;
            for (var i = 0; i < remarks.length; i++) {
                addRemarkBlockHtml(remarks[i]);
            }
        });
    }

    //展示用户主页
    function showHome(user_id) {
        var url = "http://${host}/weibo/user?method=home.do&user_id=" + user_id;
        window.location.href = url;
    }


    //插入一条用户的微博评论
    function addRemarkBlockHtml(remark) {
        var time = new Date(remark.time).toLocaleString();
        var html = '           <div id="' + remark.id + '" class="info-detail-block" style="margin-left: 20px;margin-bottom: -26px">\n' +
            '                        <label for="tweet-content">\n' +
            '                            <div class="info-detail-block" style="margin-bottom: -5px;">               \n' +
            '                                <div class="user-box" style="width: 95%;border-bottom: 1px solid #ccc;    margin-left: 70px;">\n' +
            '                                    <div class="user-photo">\n' +
            '                                        <img src="${pageContext.request.contextPath}/upload/photo/' + remark.user_photo + '" alt="用户头像" class="my-photo">\n' +
            '                                    </div>\n' +
            '                                    <div onclick="addMomentDetailHtml(\'' + remark.id + '\')" class="user-info" style="height: fit-content;margin-bottom: 11px;">\n' +
            '                                        <h3 class="my-name" style="color: #333">' + remark.user_name + ' 发布于 ' + time + '</h3>\n' +
            '                                        <div style="word-break: break-all;white-space: normal;max-width: 600px;">' + remark.content + '</div>\n' +
            '                                    </div>\n' +
            '                                    <button id="' + remark.id + 'love" data-love="' + remark.love + '" onclick="dev()" style="float: left"\n' +
            '                                            contenteditable="false" class="button">点赞\(' + remark.love + '\)\n' +
            '                                    </button>\n' +
            '                                    <button id="' + remark.id + 'remark" data-reply="' + remark.reply + '" onclick="replyRemark(\'' + remark.tweet_id + '\',\'' + remark.user_name + '\')" style="float: left"\n' +
            '                                            contenteditable="false" class="button">回复' +
            '                                    </button>\n';
        var visitorArea =
            '                                </div>\n' +
            '                            </div>\n' +
            '                        </label>\n' +
            '                    </div>';
        var ownerArea =
            '                                    <button onclick="deleteRemark(\'' + remark.id + '\',\'' + remark.tweet_id + '\')" style="float: right" \n' +
            '                                            contenteditable="false" class="button">删除\n' +
            '                                    </button>\n' +
            '                                </div>\n' +
            '                            </div>\n' +
            '                        </label>\n' +
            '                    </div>';
        if (remark.user_id ===${login.id}) {
            document.getElementById("news-detail-box-content").innerHTML += html + ownerArea;
        } else {
            document.getElementById("news-detail-box-content").innerHTML += html + visitorArea;
        }
    }

    //插入一条微博动态
    function addNewsBlockHtml(tweet) {
        document.getElementById("news-box-content").innerHTML += getWeiboHtml(tweet);
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
            '                                        <img onclick="showHome(' + tweet.owner_id + ')" src="${pageContext.request.contextPath}/upload/photo/' + tweet.user_photo + '" alt=w"用户头像" class="my-photo">\n' +
            '                                    </div>\n' +
            '                                    <div  class="user-info" style="height: fit-content;margin-bottom: 11px;">\n' +
            '                                        <h3 class="my-name" style="color: #333">' + tweet.user_name + ' 发布于 ' + time + ' [分类：' + tweet.sort + ']' +
            '</h3><h3 onclick="addFriend(' + tweet.owner_id + ')">[+关注]</h3><h3 onclick="freezeUser(' + tweet.owner_id + ')">[冻结用户]</h3>\n' +
            '                                        <div onclick="addMomentDetailHtml(\'' + tweet.id + '\')" style="word-break: break-all;white-space: normal;    max-width: 70%">' + tweet.content + '</div>\n' +
            '                                    </div>\n' +
            '                                    <button id="' + tweet.id + 'love" data-love="' + tweet.love + '" ' +
            '                                       onclick="loveMoment(\'' + tweet.id + '\',' + tweet.love + ')" style="float: left;height: 30px;"  class="button" \n' +
            '                                            contenteditable="false">点赞\(' + tweet.love + '\)\n' +
            '                                    </button>\n' +
            '                                    <button id="' + tweet.id + 'remark" data-remark="' + tweet.remark + '" ' +
            '                                       onclick="remarkMoment(\'' + tweet.id + '\',' + tweet.remark + ')" style="float: left;height: 30px;"  class="button" \n' +
            '                                            contenteditable="false">评论\(' + tweet.remark + '\)\n' +
            '                                    </button>\n' +
            '                                    <button onclick="shareTweet(\'' + tweet.id + '\')" style="float: left;height: 30px;"  class="button" \n' +
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
        if (tweet.owner_id ===${login.id}) {
            return html + ownerArea;
        } else {
            return html + visitorArea;
        }
    }


    //插入微博照片
    function addPhotoHtml(photo) {
        var html = '<img src="' + photo + '" style="height: 100%;width: 100%;max-height:200px;max-width:200px;position: relative;">\n';
        document.getElementById("photo-box-content").innerHTML += html;
    }

    //将私信显示在私信对应的聊天窗口上,并在聊天列表对应位置显示
    function addMessageToChat(message) {
        var right_bubble_html = '<div class="chat-output-content-right">\n' +
            '    <img src="${pageContext.request.contextPath}/upload/photo/' + message.sender_photo + '" alt="头像" class="chat-output-head-photo-right">\n' +
            '    <div class="chat-output-bubble-right">\n' +
            '        <div class="chat-output-bubble-inner">\n' +
            '            <pre class="chat-output-bubble-pre-right">' + message.content + '</pre></div></div></div>';
        var left_bubble_html = '<div class="chat-output-content-left">\n' +
            '    <img src="${pageContext.request.contextPath}/upload/photo/' + message.sender_photo + '" alt="头像" class="chat-output-head-photo-left">\n' +
            '    <h4 class="chat-output-meta-left">' + message.sender_name + '</h4>\n' +
            '    <div class="chat-output-bubble-left">\n' +
            '        <div class="chat-output-bubble-inner">\n' +
            '            <pre class="chat-output-bubble-pre-left">' + message.content + '</pre></div></div></div>';
        if (message.sender_id ===${login.id}) {
            document.getElementById(message.chat_id + "accept-message").innerHTML += '<br/>' + right_bubble_html;
        } else {
            document.getElementById(message.chat_id + "accept-message").innerHTML += '<br/>' + left_bubble_html;
        }
        document.getElementById(message.chat_id + "accept-message").scrollTop = document.getElementById(message.chat_id + "accept-message").scrollHeight;
        //显示在列表上
        if ("file" === message.type) {
            document.getElementById(message.chat_id + "new-message").innerText = "你收到一个文件";
        } else if ("img" === message.type) {
            document.getElementById(message.chat_id + "new-message").innerText = "你收到一个图片";
        } else {
            document.getElementById(message.chat_id + "new-message").innerText = message.content;
        }
    }

    //显示私信
    function showMessage(message) {
        if (message.type === "system") {
            alert(message.content);
            return;
        }
        if (message.type === "user" || message.type === "file" || message.type === "img") {
            console.log("显示用户私信");
            addMessageToChat(message);
        }
        if (message.type === "friend") {
            alert("收到好友申请");
            console.log("显示加好友通知");
            loadAddFriendOnMenu(message);
            addMessageToChat(message);
        }
    }

    //功能不可用
    function dev() {
        alert("该功能正在开发中，暂时不可用");
    }


    function lastWeiboPage() {
        if (document.getElementById('news-box').dataset.page === "1") {

        } else {
            document.getElementById('news-box').dataset.page--;
        }
    }

    function nextWeiboPage() {
        document.getElementById('news-box').dataset.page++;
    }
</script>
<!--END——程序执行脚本-->
<!--BEGIN——websocket脚本-->
<script type="text/javascript">
    var websocket = null;
    var url = "ws://${host}/server/chat/${login.id}";

    function connectWebsocket() {

        //判断当前浏览器是否支持WebSocket
        if ('WebSocket' in window) {
            websocket = new WebSocket(url);
        } else {
            alert('当前浏览器不支持 websocket,无法进行实时聊天')
        }

        //连接发生错误的回调方法
        websocket.onerror = function () {
            alert("WebSocket连接发生错误,请刷新浏览器重新连接");
            websocket = '';
        };

        //连接成功建立的回调方法
        websocket.onopen = function () {
        };

        //接收到私信的回调方法
        websocket.onmessage = function (event) {
            // alert("收到服务器的新私信" + event.data);
            var message = eval("(" + event.data + ")");
            showMessage(message);
        };
        //连接关闭的回调方法
        websocket.onclose = function () {
            alert("WebSocket连接已关闭，请刷新浏览器重新连接");
            websocket = '';
        };

        //监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
        window.onbeforeunload = function () {
            closeWebSocket();
        }

    }

    //关闭WebSocket连接
    function closeWebSocket() {
        websocket.close();
    }
</script>
<!--END——websocket脚本-->
<!--BEGIN——预加载脚本-->

<script>
    //请求聊天列表
    <c:if test="${param.method!='home.do'}">
    loadChatListAndBox();
    loadFriendList();
    connectWebsocket();
    loadSelectWeibo();
    </c:if>
    <c:if test="${param.method=='home.do'}">
    loadMyTweet(1);
    </c:if>
</script>
<!--END——预加载脚本-->
</body>
</html>


