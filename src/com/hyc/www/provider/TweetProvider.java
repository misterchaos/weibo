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

import com.hyc.www.model.po.User;
import com.hyc.www.provider.constant.RequestMethod;
import com.hyc.www.factory.ServiceProxyFactory;
import com.hyc.www.model.dto.ServiceResult;
import com.hyc.www.model.po.Tweet;
import com.hyc.www.provider.annotation.Action;
import com.hyc.www.provider.annotation.ActionProvider;
import com.hyc.www.service.TweetService;
import com.hyc.www.service.impl.TweetServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigInteger;

import static com.hyc.www.util.BeanUtils.jsonToJavaObject;
import static com.hyc.www.util.ControllerUtils.returnJsonObject;

/**
 * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
 * @description 负责微博相关流程
 * @date 2019-05-07 21:33
 */
@ActionProvider(path = "/tweet")
public class TweetProvider extends BaseProvider {
    private final TweetService tweetService = (TweetService) new ServiceProxyFactory().getProxyInstance(new TweetServiceImpl());

    /**
     * 提供发布微博的业务流程
     *
     * @name postTweet
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/9
     */
    @Action(method = RequestMethod.ADD_DO)
    public void postTweet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Tweet tweet = (Tweet) jsonToJavaObject(req.getInputStream(), Tweet.class);
        User user = (User) req.getSession().getAttribute("login");
        ServiceResult result;
        result = tweetService.insertTweet(user.getId(),tweet);
        returnJsonObject(resp, result);
    }

    /**
     * 提供删除微博的业务流程
     *
     * @name deleteTweet
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/9
     */
    @Action(method = RequestMethod.DELETE_DO)
    public void deleteTweet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String momentId = req.getParameter("tweet_id");
        ServiceResult result;
        result = tweetService.removeTweet(new BigInteger(momentId));
        returnJsonObject(resp, result);
    }

    /**
     * 提供更新微博的业务流程
     *
     * @name updateTweet
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/9
     */
    @Action(method = RequestMethod.UPDATE_DO)
    public void updateTweet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Tweet tweet = (Tweet) jsonToJavaObject(req.getInputStream(), Tweet.class);
        ServiceResult result;
        result = tweetService.updateTweet(tweet);
        returnJsonObject(resp, result);
    }

    /**
     * 提供获取自己所发的微博的业务流程
     *
     * @name listTweet
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/9
     */
    @Action(method = RequestMethod.TWEET_DO)
    public void listMyTweet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String userId = req.getParameter("user_id");
        String page = req.getParameter("page");
        ServiceResult result;
        result = tweetService.listMyTweet(new BigInteger(userId), new Integer(page));
        returnJsonObject(resp, result);
    }

    /**
     * 提供获取微博动态的业务流程
     *
     * @name listNews
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/9
     */
    @Action(method = RequestMethod.LIST_DO)
    public void list(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String userId = req.getParameter("user_id");
        String sort = req.getParameter("sort");
        String page = req.getParameter("page");
        ServiceResult result;
        result = tweetService.listTweet(new BigInteger(userId), sort, new Integer(page));
        returnJsonObject(resp, result);
    }


    /**
     * 提供获取微博照片的业务流程
     *
     * @name loadPhoto
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/10
     */
    @Action(method = RequestMethod.PHOTO_DO)
    public void listPhoto(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String userId = req.getParameter("user_id");
        String page = req.getParameter("page");
        ServiceResult result;
        result = tweetService.listPhoto(new BigInteger(userId), new Integer(page));
        returnJsonObject(resp, result);
    }

    /**
     * 提供微博点赞的服务
     *
     * @name love
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/9
     */
    @Action(method = RequestMethod.LOVE_DO)
    public void love(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String userId = req.getParameter("user_id");
        String tweetId = req.getParameter("tweet_id");
        ServiceResult result;
        result = tweetService.love(new BigInteger(userId), new BigInteger(tweetId));
        returnJsonObject(resp, result);
    }



}
