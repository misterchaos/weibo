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

package com.hyc.www.service;

import com.hyc.www.model.dto.ServiceResult;
import com.hyc.www.model.po.Tweet;
import com.hyc.www.service.annotation.Freeze;

import java.math.BigInteger;

/**
 * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
 * @description 负责提供微博相关的服务
 * @date 2019-05-07 13:13
 */
public interface TweetService {

    /**
     * 插入一条微博
     *
     * @param tweet 微博
     * @name insertTweet
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/7
     */
    @Freeze
    ServiceResult insertTweet(BigInteger userId,Tweet tweet);


    /**
     * 删除一条微博
     *
     * @param tweetId 微博id
     * @name removeTweet
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/7
     */
    ServiceResult removeTweet(BigInteger tweetId);

    /**
     * 更新一条微博
     *
     * @param tweet 要更新的微博
     * @name updateTweet
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/7
     */
    ServiceResult updateTweet(Tweet tweet);

    /**
     * 查询一个用户所发的所有微博
     *
     * @param page   页数
     * @param userId 用户id
     * @name listNews
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/7
     */
    ServiceResult listMyTweet(BigInteger userId, int page);


    /**
     * 查询一个用户可见的所有微博，包括自己的和朋友的
     *
     * @param userId 用户id
     * @param page   页数
     * @param sort   分类
     * @name listTweet
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/7
     */
    public ServiceResult listTweet(BigInteger userId, String sort, int page);

    /**
     * 更新一个用户对一条微博的点赞状态
     *
     * @param userId   用户id
     * @param momentId 微博id
     * @name love
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/8
     */
    ServiceResult love(BigInteger userId, BigInteger momentId);

    /**
     * 查询一个用户微博中的所有图片
     *
     * @param userId 用户id
     * @param page   页数
     * @name loadPhoto
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/10
     */
    ServiceResult listPhoto(BigInteger userId, int page);


}
