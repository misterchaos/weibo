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

package com.hyc.www.dao;

import com.hyc.www.dao.annotation.Query;
import com.hyc.www.dao.annotation.Result;
import com.hyc.www.dao.annotation.ResultType;
import com.hyc.www.model.po.Tweet;

import java.util.List;

/**
 * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
 * @description 负责朋友圈的CRUD
 * @date 2019-05-07 11:55
 */
public interface TweetDao extends BaseDao {
    String TABLE = "tweet";
    String ALL_FIELD = "owner_id,content,time,love,remark,share,view," + BASE_FIELD;

    /**
     * 通过朋友圈id查询一个朋友圈
     *
     * @param id 朋友圈id
     * @name geTweetById
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/2
     */
    @Result(entity = Tweet.class, returns = ResultType.OBJECT)
    @Query(value = "select " + ALL_FIELD + " from " + TABLE + " where id = ? ")
    Tweet getTweetById(Object id);

    /**
     * 通过用户id和状态查询一个朋友圈
     *
     * @param ownerId 用户id
     * @param stauts 状态
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/8
     */
    @Result(entity = Tweet.class, returns = ResultType.OBJECT)
    @Query(value = "select " + ALL_FIELD + " from " + TABLE + " where owner_id = ? and status = ? ")
    Tweet getTweetByOwnerIdAndStatus(Object ownerId, Object stauts);


    /**
     * 通过用户id逆序查询所有自己发布的朋友圈
     *
     * @param ownerId 用户id
     * @param limit  每页查询记录数
     * @param offset 起始记录数
     * @name listMyTweetByOwnerIdDesc
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/7
     */
    @Result(entity = Tweet.class, returns = ResultType.LIST)
    @Query("select " + ALL_FIELD + " from " + TABLE + " where owner_id = ?  order by time desc limit ? offset ?  ")
    List<Tweet> listMyTweetByOwnerIdDesc(Object ownerId, int limit, int offset);





    /**
     * 通过用户id查询所有自己发布的朋友圈
     *
     * @param ownerId 用户id
     * @param limit  每页查询记录数
     * @param offset 起始记录数
     * @name listMyTweetByOwnerId
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/7
     */
    @Result(entity = Tweet.class, returns = ResultType.LIST)
    @Query("select " + ALL_FIELD + " from " + TABLE + " where owner_id = ?  order by time limit ? offset ?  ")
    List<Tweet> listMyTweetByOwnerId(Object ownerId, int limit, int offset);



    /**
     * 通过分类逆序查询某个分类的微博
     *
     * @param sort 分类
     * @param limit  每页查询记录数
     * @param offset 起始记录数
     * @name listTweetBySortDesc
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/7
     */
    @Result(entity = Tweet.class, returns = ResultType.LIST)
    @Query("select " + ALL_FIELD + " from " + TABLE + " where sort = ?  order by time desc limit ? offset ?  ")
    List<Tweet> listTweetBySortDesc(Object sort, int limit, int offset);


    /**
     * 查询全部微博
     *
     * @param limit  每页查询记录数
     * @param offset 起始记录数
     * @name listTweetDesc
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/7
     */
    @Result(entity = Tweet.class, returns = ResultType.LIST)
    @Query("select " + ALL_FIELD + " from " + TABLE + " order by time desc limit ? offset ?  ")
    List<Tweet> listTweetDesc(int limit, int offset);

    /**
     * 通过用户id查询所有自己发布的朋友圈中的图片
     *
     * @param ownerId 用户id
     * @param limit  每页查询记录数
     * @param offset 起始记录数
     * @name loadPhoto
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/10
     */
    @Result(entity = Tweet.class, returns = ResultType.LIST)
    @Query("select photo from " + TABLE + " where owner_id = ?  order by time desc limit ? offset ?  ")
    List<Tweet> listPhoto(Object ownerId, int limit, int offset);
}
