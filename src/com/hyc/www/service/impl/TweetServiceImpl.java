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

package com.hyc.www.service.impl;

import com.hyc.www.dao.FriendDao;
import com.hyc.www.dao.NewsDao;
import com.hyc.www.dao.TweetDao;
import com.hyc.www.dao.UserDao;
import com.hyc.www.exception.DaoException;
import com.hyc.www.exception.ServiceException;
import com.hyc.www.factory.DaoProxyFactory;
import com.hyc.www.model.builder.TweetVOBuilder;
import com.hyc.www.model.dto.ServiceResult;
import com.hyc.www.model.po.Friend;
import com.hyc.www.model.po.News;
import com.hyc.www.model.po.Tweet;
import com.hyc.www.model.po.User;
import com.hyc.www.model.vo.TweetVO;
import com.hyc.www.service.TweetService;
import com.hyc.www.service.constants.ServiceMessage;
import com.hyc.www.service.constants.Status;

import java.math.BigInteger;
import java.util.LinkedList;
import java.util.List;

import static com.hyc.www.util.StringUtils.toLegalText;
import static com.hyc.www.util.StringUtils.toLegalTextIgnoreTag;

/**
 * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
 * @description 负责提供微博相关的服务
 * @date 2019-05-07 19:19
 */
public class TweetServiceImpl implements TweetService {

    private final TweetDao tweetDao = (TweetDao) DaoProxyFactory.getInstance().getProxyInstance(TweetDao.class);
    private final NewsDao newsDao = (NewsDao) DaoProxyFactory.getInstance().getProxyInstance(NewsDao.class);
    private final UserDao userDao = (UserDao) DaoProxyFactory.getInstance().getProxyInstance(UserDao.class);
    private final FriendDao friendDao = (FriendDao) DaoProxyFactory.getInstance().getProxyInstance(FriendDao.class);

    /**
     * 插入一条微博
     *
     * @param tweet 微博
     * @name insertTweet
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/7
     */
    @Override
    public ServiceResult insertTweet(Tweet tweet) {
        StringBuilder message = new StringBuilder();
        try {
            //判空
            if (tweet == null) {
                throw new ServiceException(ServiceMessage.NOT_NULL.message);
            }
            //检查长度
            if (tweet.getContent().trim().length() > 2000) {
                return new ServiceResult(Status.ERROR, ServiceMessage.CONTENT_TOO_LONG.message, tweet);
            }
            //检查内容
            if (!isValidContent(tweet.getContent())) {
                message.append(ServiceMessage.CONTENT_ILLEGAL.message);
            }
            //过滤非法字符
            tweet.setContent(toLegalTextIgnoreTag(tweet.getContent()));
            //插入数据库
            if (tweetDao.insert(tweet) != 1) {
                return new ServiceResult(Status.ERROR, ServiceMessage.PLEASE_REDO.message, tweet);
            }
        } catch (DaoException e) {
            e.printStackTrace();
            return new ServiceResult(Status.ERROR, ServiceMessage.DATABASE_ERROR.message, tweet);
        }
        return new ServiceResult(Status.SUCCESS, message.append(ServiceMessage.POST_MOMENT_SUCCESS.message).toString(), tweet);
    }

    /**
     * 给好友双方初始化微博，互相添加动态
     *
     * @param friend 好友
     * @return
     * @name initNews
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/18
     */
    @Override
    public ServiceResult initNews(Friend friend) {
        if (friend == null || friend.getFriendId() == null || friend.getUserId() == null) {
            return new ServiceResult(Status.ERROR, ServiceMessage.PARAMETER_NOT_ENOUGHT.message, null);
        }
        try {
            List<Tweet> tweetList = tweetDao.listMyTweetByOwnerIdDesc(friend.getUserId(), 1000, 0);
            for (Tweet tweet : tweetList) {
                News news = new News();
                news.setTweetId(tweet.getId());
                news.setUserId(friend.getFriendId());
                newsDao.insert(news);
            }
            tweetList = tweetDao.listMyTweetByOwnerIdDesc(friend.getFriendId(), 1000, 0);
            for (Tweet tweet : tweetList) {
                News news = new News();
                news.setTweetId(tweet.getId());
                news.setUserId(friend.getUserId());
                newsDao.insert(news);
            }
        } catch (DaoException e) {
            e.printStackTrace();
            return new ServiceResult(Status.ERROR, ServiceMessage.DATABASE_ERROR.message, null);
        }
        return new ServiceResult(Status.SUCCESS, null, null);
    }

    /**
     * 删除一条微博
     *
     * @param tweetId 微博id
     * @name removeTweet
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/7
     */
    @Override
    public ServiceResult removeTweet(BigInteger tweetId) {
        try {
            //判空
            if (tweetId == null) {
                throw new ServiceException(ServiceMessage.NOT_NULL.message);
            }
            //检查是否存在
            if (tweetDao.getTweetById(tweetId) == null) {
                return new ServiceResult(Status.ERROR, ServiceMessage.NOT_FOUND.message, tweetId);
            }
            //删除
            Tweet tweet = new Tweet();
            tweet.setId(tweetId);
            if (tweetDao.delete(tweet) != 1) {
                return new ServiceResult(Status.ERROR, ServiceMessage.PLEASE_REDO.message, tweet);
            }
        } catch (DaoException e) {
            e.printStackTrace();
            return new ServiceResult(Status.ERROR, ServiceMessage.DATABASE_ERROR.message, tweetId);
        }
        return new ServiceResult(Status.SUCCESS, ServiceMessage.OPERATE_SUCCESS.message, tweetId);
    }

    /**
     * 更新一条微博
     *
     * @param tweet 要更新的微博
     * @name updateTweet
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/7
     */
    @Override
    public ServiceResult updateTweet(Tweet tweet) {
        try {
            //判空
            if (tweet == null) {
                throw new ServiceException(ServiceMessage.NOT_NULL.message);
            }
            //检查是否存在
            if (tweetDao.getTweetById(tweet.getId()) == null) {
                return new ServiceResult(Status.ERROR, ServiceMessage.NOT_FOUND.message, tweet);
            }
            //删除
            if (tweetDao.update(tweet) != 1) {
                return new ServiceResult(Status.ERROR, ServiceMessage.PLEASE_REDO.message, tweet);
            }
        } catch (DaoException e) {
            e.printStackTrace();
            return new ServiceResult(Status.ERROR, ServiceMessage.DATABASE_ERROR.message, tweet);
        }
        return new ServiceResult(Status.SUCCESS, ServiceMessage.OPERATE_SUCCESS.message, tweet);
    }

    /**
     * 查询一个用户所发的所有微博
     *
     * @param userId 用户id
     * @param page   页数
     * @name listNews
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/7
     */
    @Override
    public ServiceResult listMyTweet(BigInteger userId, int page) {
        //判空
        if (userId == null) {
            throw new ServiceException(ServiceMessage.NOT_NULL.message);
        }

        List<TweetVO> momentVOList = new LinkedList<>();
        //根据页数信息生成查询参数
        int limit = 10;
        int offset = (page - 1) * limit;
        if (offset < 0) {
            return new ServiceResult(Status.ERROR, ServiceMessage.PAGE_INVALID.message, null);
        }
        try {
            List<Tweet> tweetList = tweetDao.listMyTweetByOwnerIdDesc(userId, limit, offset);
            if (tweetList == null || tweetList.size() == 0) {
                return new ServiceResult(Status.SUCCESS, ServiceMessage.NO_MOMENT.message, tweetList);
            }
            User user = userDao.getUserById(userId);
            //将微博和用户信息转化成微博视图层对象
            for (Tweet tweet : tweetList) {
                toTweetVOObject(momentVOList, tweet, user);
            }
        } catch (DaoException e) {
            e.printStackTrace();
        }
        return new ServiceResult(Status.SUCCESS, null, momentVOList);
    }

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
    @Override
    public ServiceResult listTweet(BigInteger userId, String sort, int page) {
        //判空
        if (userId == null) {
            throw new ServiceException(ServiceMessage.NOT_NULL.message);
        }
        //根据页数信息生成查询参数
        int limit = 10;
        int offset = (page - 1) * limit;
        if (offset < 0) {
            return new ServiceResult(Status.ERROR, ServiceMessage.PAGE_INVALID.message, null);
        }
        List<TweetVO> tweetVOList = new LinkedList<>();
        try {
            List<Tweet> tweetList;
            //sort为空则查询所有微博
            if (sort == null||sort.trim().isEmpty()) {
                tweetList = tweetDao.listTweetDesc(limit, offset);
            } else {
                tweetList = tweetDao.listTweetBySortDesc(sort, limit, offset);
            }
            //根据动态中的微博id获取微博数据
            for (Tweet tweet : tweetList) {
                //获取微博的发布者的用户信息
                User user = userDao.getUserById(tweet.getOwnerId());
                if (user == null) {
                    return new ServiceResult(Status.ERROR, ServiceMessage.DATABASE_ERROR.message, tweetVOList);
                }
                //将微博和动态信息转化成微博视图层对象
                toTweetVOObject(tweetVOList, tweet, user);
                //统计浏览量
                tweet.setView(tweet.getView() + 1L);
                tweetDao.update(tweet);
            }
        } catch (DaoException e) {
            e.printStackTrace();
            return new ServiceResult(Status.ERROR, ServiceMessage.DATABASE_ERROR.message, tweetVOList);
        }
        return new ServiceResult(Status.SUCCESS, null, tweetVOList);
    }

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
    @Override
    synchronized public ServiceResult love(BigInteger userId, BigInteger momentId) {
        if (userId == null || momentId == null) {
            throw new ServiceException(ServiceMessage.NOT_NULL.message);
        }
        News news;
        try {
            news = newsDao.getNewsByTweetIdAndUserId(momentId, userId);
            //检查news是否存在
            if (news == null) {
                return new ServiceResult(Status.ERROR, ServiceMessage.DATABASE_ERROR.message, null);
            }
            Tweet tweet = tweetDao.getTweetById(news.getTweetId());
            if (tweet == null) {
                return new ServiceResult(Status.ERROR, ServiceMessage.DATABASE_ERROR.message, null);
            }
            //从非点赞到点赞状态，该微博点赞数加一,否则减一
            tweet.setLove(!news.getLoved() ? tweet.getLove() + 1 : tweet.getLove() - 1);
            tweetDao.update(tweet);
            //修改状态,如果是ture则改为false,是false则改为ture
            news.setLoved(!news.getLoved());
            newsDao.update(news);
        } catch (DaoException e) {
            return new ServiceResult(Status.ERROR, ServiceMessage.DATABASE_ERROR.message, null);
        }
        return new ServiceResult(Status.SUCCESS, null, news.getLoved());
    }

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
    @Override
    public ServiceResult listPhoto(BigInteger userId, int page) {

        //根据页数信息生成查询参数
        int limit = 10;
        int offset = (page - 1) * limit;
        if (offset < 0) {
            return new ServiceResult(Status.ERROR, ServiceMessage.PAGE_INVALID.message, null);
        }
        //判空
        if (userId == null) {
            throw new ServiceException(ServiceMessage.NOT_NULL.message);
        }
        List<String> photoList = new LinkedList<>();
        try {
            List<Tweet> tweetList = tweetDao.listPhoto(userId, limit, offset);
            if (tweetList == null || tweetList.size() == 0) {
                return new ServiceResult(Status.ERROR, ServiceMessage.NO_MOMENT.message, null);
            }
            for (Tweet tweet : tweetList) {
                String content = tweet.getContent();
                String imgRegex = "\"<(img|IMG)(.*?)(/>|></img>|>)\"";
                
                //TODO 微博相册
//                photoList.add(tweet.getPhoto());
            }
        } catch (DaoException e) {
            e.printStackTrace();
            return new ServiceResult(Status.ERROR, ServiceMessage.DATABASE_ERROR.message, photoList);
        }
        return new ServiceResult(Status.SUCCESS, null, photoList);
    }

    /**
     * 建造一个微博试图层对象集合，需要一个持久化对象集合，和该用户的信息
     *
     * @param momentVOList 试图层对象集合
     * @param tweet        微博
     * @param user         该用户的信息
     * @name toTweetVOObject
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/8
     */
    private void toTweetVOObject(List<TweetVO> momentVOList, Tweet tweet, User user) {
        TweetVO momentVO = new TweetVOBuilder().setContent(tweet.getContent()).setUserId(tweet.getOwnerId())
                .setId(tweet.getId()).setRemark(tweet.getRemark()).setShare(tweet.getShare()).setUserName(user.getName())
                .setView(tweet.getView()).setLove(tweet.getLove()).setUserPhoto(user.getPhoto()).setSort(tweet.getSort())
                .setTime(tweet.getTime()).build();
        momentVOList.add(momentVO);
    }

    /**
     * 检查一段内容是否合法
     *
     * @param content 微博内容
     */
    private boolean isValidContent(String content) {
        if (content == null || content.trim().isEmpty()) {
            return false;
        }
        //如果内容经过过滤后与原来不一样，说明含有非法内容
        String legalText = toLegalTextIgnoreTag(content);
        if (content.equals(legalText)) {
            return true;
        }
        return false;
    }


}
