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

import com.hyc.www.controller.constant.RequestMethod;
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
 * @description 负责朋友圈相关流程
 * @date 2019-05-07 21:33
 */
@ActionProvider(path = "/moment")
public class TweetProvider extends BaseProvider {
    private final TweetService tweetService = (TweetService) new ServiceProxyFactory().getProxyInstance(new TweetServiceImpl());

    /**
     * 提供发布朋友圈的业务流程
     *
     * @name postMoment
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/9
     */
    @Action(method = RequestMethod.ADD_DO)
    public void postMoment(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Tweet tweet = (Tweet) jsonToJavaObject(req.getInputStream(), Tweet.class);
        ServiceResult result;
        result = tweetService.insertMoment(tweet);
        returnJsonObject(resp, result);
    }

    /**
     * 提供删除朋友圈的业务流程
     *
     * @name deleteMoment
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/9
     */
    @Action(method = RequestMethod.DELETE_DO)
    public void deleteMoment(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String momentId = req.getParameter("moment_id");
        ServiceResult result;
        result = tweetService.removeMoment(new BigInteger(momentId));
        returnJsonObject(resp, result);
    }

    /**
     * 提供更新朋友圈的业务流程
     *
     * @name updateMoment
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/9
     */
    @Action(method = RequestMethod.UPDATE_DO)
    public void updateMoment(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Tweet tweet = (Tweet) jsonToJavaObject(req.getInputStream(), Tweet.class);
        ServiceResult result;
        result = tweetService.updateMoment(tweet);
        returnJsonObject(resp, result);
    }

    /**
     * 提供获取个人朋友圈的业务流程
     *
     * @name listMoment
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/9
     */
    @Action(method = RequestMethod.MOMENT_DO)
    public void listMoment(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String userId = req.getParameter("user_id");
        String page = req.getParameter("page");
        ServiceResult result;
        result = tweetService.listMyMoment(new BigInteger(userId), new Integer(page));
        returnJsonObject(resp, result);
    }

    /**
     * 提供获取朋友圈动态的业务流程
     *
     * @name listNews
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/9
     */
    @Action(method = RequestMethod.NEWS_DO)
    public void listNews(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String userId = req.getParameter("user_id");
        String page = req.getParameter("page");
        ServiceResult result;
        result = tweetService.listNews(new BigInteger(userId), new Integer(page));
        returnJsonObject(resp, result);
    }


    /**
     * 提供获取朋友圈照片的业务流程
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
     * 提供朋友圈点赞的服务
     *
     * @name love
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/9
     */
    @Action(method = RequestMethod.LOVE_DO)
    public void love(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String userId = req.getParameter("user_id");
        String momentId = req.getParameter("moment_id");
        ServiceResult result;
        result = tweetService.love(new BigInteger(userId), new BigInteger(momentId));
        returnJsonObject(resp, result);
    }
}
