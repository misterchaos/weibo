/*
 * Copyright (c) 2019.  黄钰朝
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.hyc.www.provider;

import com.hyc.www.factory.ServiceProxyFactory;
import com.hyc.www.model.dto.ServiceResult;
import com.hyc.www.model.po.Friend;
import com.hyc.www.model.po.User;
import com.hyc.www.provider.annotation.Action;
import com.hyc.www.provider.annotation.ActionProvider;
import com.hyc.www.provider.constant.RequestMethod;
import com.hyc.www.provider.constant.WebPage;
import com.hyc.www.service.ChatService;
import com.hyc.www.service.FriendService;
import com.hyc.www.service.TweetService;
import com.hyc.www.service.UserService;
import com.hyc.www.service.constants.ServiceMessage;
import com.hyc.www.service.constants.Status;
import com.hyc.www.service.impl.ChatServiceImpl;
import com.hyc.www.service.impl.FriendServiceImpl;
import com.hyc.www.service.impl.TweetServiceImpl;
import com.hyc.www.service.impl.UserServiceImpl;
import com.hyc.www.util.BeanUtils;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigInteger;

import static com.hyc.www.util.BeanUtils.jsonToJavaObject;
import static com.hyc.www.util.ControllerUtils.returnJsonObject;

/**
 * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
 * @description 用于处理用户相关业务流程
 * @date 2019-05-02 10:07
 */
@ActionProvider(path = "/user")
public class UserProvider extends BaseProvider {

    /**
     * 自动登陆有效时间
     */
    private final int AUTO_LOGIN_AGE = 60 * 60 * 24 * 30;
    private final UserService userService = (UserService) new ServiceProxyFactory().getProxyInstance(new UserServiceImpl());
    private final ChatService chatService = (ChatService) new ServiceProxyFactory().getProxyInstance(new ChatServiceImpl());
    private final FriendService friendService = (FriendService) new ServiceProxyFactory().getProxyInstance(new FriendServiceImpl());
    private final TweetService tweetService = (TweetService) new ServiceProxyFactory().getProxyInstance(new TweetServiceImpl());

    /**
     * 提供用户注册的业务流程
     *
     * @name register
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/9
     */
    @Action(method = RequestMethod.REGISTER_DO)
    public void register(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        User user = (User) BeanUtils.toObject(req.getParameterMap(), User.class);
        ServiceResult result;
        //检查用户注册信息
        result = userService.checkRegister(user);
        if (Status.ERROR.equals(result.getStatus())) {
            req.setAttribute("message", result.getMessage());
            req.setAttribute("data", result.getData());
            req.getRequestDispatcher(WebPage.REGISTER_JSP.toString()).forward(req, resp);
            return;
        }
        //插入用户
        result = userService.insertUser(user);
        if (Status.ERROR.equals(result.getStatus())) {
            req.setAttribute("message", result.getMessage());
            req.setAttribute("data", result.getData());
            req.getRequestDispatcher(WebPage.REGISTER_JSP.toString()).forward(req, resp);
        } else {
            user = (User) result.getData();
            //与系统账号加好友
            addToSystemChat(user);
            req.setAttribute("message", result.getMessage());
            req.setAttribute("data", result.getData());
            req.getRequestDispatcher(WebPage.LOGIN_JSP.toString()).forward(req, resp);
        }
    }


    /**
     * 提供用户登陆的业务流程
     *
     * @name login
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/9
     */
    @Action(method = RequestMethod.LOGIN_DO)
    public void login(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) BeanUtils.toObject(req.getParameterMap(), User.class);
        ServiceResult result;
        if (user == null) {
            result = new ServiceResult(Status.ERROR, ServiceMessage.PARAMETER_NOT_ENOUGHT.message, null);
            req.setAttribute("message", result.getMessage());
            req.setAttribute("data", result.getData());
            req.getRequestDispatcher(WebPage.LOGIN_JSP.toString()).forward(req, resp);
            return;
        }
        HttpSession session = req.getSession(false);
        //检查用户是否已经建立会话并且已经具有登陆信息
        if (session == null || session.getAttribute("login") == null) {
            //检查是不是游客登陆，游客登陆的话先创建个游客账号然后登陆
            if ("visitor".equals(user.getEmail())) {
                result = userService.visitorLogin();
                if (Status.ERROR.equals(result.getStatus())) {
                    req.setAttribute("message", result.getMessage());
                    req.setAttribute("data", result.getData());
                    req.getRequestDispatcher(WebPage.LOGIN_JSP.toString()).forward(req, resp);
                    return;
                }
                User visitor = (User) result.getData();
                //与系统账号加好友
                addToSystemChat(visitor);
            } else {
                //如果是用户登陆，校验密码是否正确
                result = userService.checkPassword(user);
                if (Status.ERROR.equals(result.getStatus())) {
                    req.setAttribute("message", result.getMessage());
                    req.setAttribute("data", result.getData());
                    req.getRequestDispatcher(WebPage.LOGIN_JSP.toString()).forward(req, resp);
                    return;
                } else {
                    //校验密码成功时，给会话中添加用户信息
                    result = userService.getUser(user.getId());
                    user = (User) result.getData();
                    //如果设置自动登陆，则添加cookie
                    if (req.getParameter("auto_login") != null) {
                        setAutoLoginCookie(resp, req, String.valueOf(user.getId()));
                    }

                }
            }

        } else {
            //先从session获取用户信息，再更新用户信息到会话中
            user = (User) session.getAttribute("login");
            result = userService.getUser(user.getId());
        }
        req.getSession(true).setAttribute("login", result.getData());
        req.getRequestDispatcher(WebPage.INDEX_JSP.toString()).forward(req, resp);
    }

    /**
     * 提供获取用户个人信息的业务流程
     *
     * @name get
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/9
     */
    @Action(method = RequestMethod.GET_DO)
    public void get(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) BeanUtils.toObject(req.getParameterMap(), User.class);
        ServiceResult result;
        //获取用户数据
        result = userService.getUser(user.getId());
        if (Status.ERROR.equals(result.getStatus())) {
            returnJsonObject(resp, result);
        } else {
            //获取数据成功时的处理
            resp.getWriter().write(result.getMessage());
        }
    }


    /**
     * 提供获取用户个人信息的业务流程
     *
     * @name logout
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/9
     */
    @Action(method = RequestMethod.LOGOUT_DO)
    public void logout(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        if (session != null) {
            session.invalidate();
        }
        returnJsonObject(resp, new ServiceResult(Status.SUCCESS, ServiceMessage.LOGOUT_SUCCESS.message, null));
    }


    /**
     * 提供用户更新个人信息的业务流程
     *
     * @name update
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/9
     */
    @Action(method = RequestMethod.UPDATE_DO)
    public void update(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = (User) jsonToJavaObject(req.getInputStream(), User.class);
        ServiceResult result;
        if (user != null && user.getWeiboId() != null) {
            User oldUser = (User) userService.getUser(user.getId()).getData();
            if (!oldUser.getWeiboId().equals(user.getWeiboId())) {
                //如果请求要求修改微博账号，先检查用户名（微博账号）是否合法
                result = userService.checkWeiboId(user.getWeiboId());
                if (Status.ERROR.equals(result.getStatus())) {
                    returnJsonObject(resp, result);
                    return;
                }
            }
        }
        //更新用户数据
        result = userService.updateUser(user);
        returnJsonObject(resp, result);
    }

    /**
     * 提供用户更新密码的业务流程
     *
     * @name updatePwd
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/9
     */
    @Action(method = RequestMethod.UPDATEPASSWORD_DO)
    public void updatePwd(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String oldPwd = req.getParameter("old_password");
        String newPwd = req.getParameter("new_password");
        String userId = req.getParameter("user_id");
        ServiceResult result;
        //更新用户数据
        result = userService.updatePwd(oldPwd, newPwd, new BigInteger(userId));
        returnJsonObject(resp, result);
    }


    /**
     * 提供搜索用户的服务
     *
     * @name list
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/9
     */
    @Action(method = RequestMethod.LIST_DO)
    public void list(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = (User) BeanUtils.toObject(req.getParameterMap(), User.class);
        ServiceResult result;
        result = userService.listUserLikeName(user.getName());
        if (Status.ERROR.equals(result.getStatus())) {
            returnJsonObject(resp, result);
            return;
        }
        returnJsonObject(resp, result);
    }

    /**
     * 用于提供跳转到个人主页的业务流程
     *
     * @name home
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/28
     */
    @Action(method = RequestMethod.HOME_DO)
    public void home(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String userId = req.getParameter("user_id");
        ServiceResult result = userService.getUser(new BigInteger(userId));
        if (Status.ERROR.equals(result.getStatus())) {
            returnJsonObject(resp, result);
            return;
        }
        req.setAttribute("login", result.getData());
        req.getRequestDispatcher(WebPage.INDEX_JSP.toString()).forward(req, resp);
    }


    /**
     * 用于提供冻结用户的业务流程
     *
     * @name freeze
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/30
     */
    @Action(method = RequestMethod.FREEZE_DO)
    public void freeze(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String userId = req.getParameter("user_id");
        User operator = (User) req.getSession().getAttribute("login");
        ServiceResult result = userService.freezeUser(operator.getId(), new BigInteger(userId));
        returnJsonObject(resp, result);
    }

    /**
     * 提供自动登陆的服务
     *
     * @name list
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/9
     */
    public void autoLogin(HttpServletRequest req) {
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("user_id".equalsIgnoreCase(cookie.getName())) {
                    ServiceResult result = userService.getUser(new BigInteger(cookie.getValue()));
                    if (Status.SUCCESS.equals(result.getStatus())) {
                        //如果获取用户信息成功则设置‘login’属性
                        req.setAttribute("login", result.getData());
                        HttpSession session = req.getSession();
                        session.setAttribute("login", result.getData());
                        return;
                    }
                }
            }
        }
    }


    /**
     * 设置用于自动登陆的cookie
     *
     * @param userId 用户id
     * @name setAutoLoginCookie
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/9
     */
    private void setAutoLoginCookie(HttpServletResponse resp, HttpServletRequest req, String userId) {
        Cookie cookie = new Cookie("user_id", userId);
        cookie.setMaxAge(AUTO_LOGIN_AGE);
        cookie.setPath(req.getContextPath());
        resp.addCookie(cookie);
    }


    /**
     * 将一个用户添加到与系统的会话中
     *
     * @param user 用户
     * @name addToSystemChat
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/9
     */
    private void addToSystemChat(User user) {
        Friend friend = new Friend();
        //系统添加用户账号为好友
        friend.setUserId(UserServiceImpl.SYSTEM_ID);
        friend.setFriendId(user.getId());
        friendService.addFriend(friend);
        //用户添加系统账号为好友
        friend.setAlias(null);
        friend.setUserId(user.getId());
        friend.setFriendId(UserServiceImpl.SYSTEM_ID);
        friendService.addFriend(friend);
        //将用户和系统账号（id=0）添加到同一个聊天中
        chatService.createFriendChat(friend);
    }

}
