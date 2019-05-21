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
import com.hyc.www.dao.TweetDao;
import com.hyc.www.dao.NewsDao;
import com.hyc.www.dao.UserDao;
import com.hyc.www.exception.DaoException;
import com.hyc.www.exception.ServiceException;
import com.hyc.www.factory.DaoProxyFactory;
import com.hyc.www.model.builder.MomentVOBuilder;
import com.hyc.www.model.dto.ServiceResult;
import com.hyc.www.model.po.Friend;
import com.hyc.www.model.po.Tweet;
import com.hyc.www.model.po.News;
import com.hyc.www.model.po.User;
import com.hyc.www.model.vo.TweetVO;
import com.hyc.www.service.TweetService;
import com.hyc.www.service.constants.ServiceMessage;
import com.hyc.www.service.constants.Status;

import java.math.BigInteger;
import java.util.LinkedList;
import java.util.List;

import static com.hyc.www.util.StringUtils.toLegalText;

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
     * @name insertMoment
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/7
     */
    @Override
    public ServiceResult insertMoment(Tweet tweet) {
        StringBuilder message = new StringBuilder();
        try {
            //判空
            if (tweet == null) {
                throw new ServiceException(ServiceMessage.NOT_NULL.message);
            }
            //检查长度
            if(tweet.getContent().length()>800){
                return new ServiceResult(Status.ERROR, ServiceMessage.CONTENT_TOO_LONG.message, tweet);
            }
            //检查内容
            if (!isValidContent(tweet.getContent())) {
                message.append(ServiceMessage.CONTENT_ILLEGAL.message);
            }

            //过滤非法字符
            tweet.setContent(toLegalText(tweet.getContent()));
            //插入数据库
            //先把状态值设置为1，插入后查出状态为1的，返回给前端，并且对News表插入动态记录之后，再更新状态为0
            tweet.setStatus(1);
            if (tweetDao.insert(tweet) != 1) {
                return new ServiceResult(Status.ERROR, ServiceMessage.PLEASE_REDO.message, tweet);
            }
            //获取微博记录，返回id值,
            tweet = tweetDao.getMomentByOwnerIdAndStatus(tweet.getOwnerId(), 1);
            //查找用户的所有朋友，给他们插入news记录
            List<Friend> friendList = friendDao.listByUserId(tweet.getOwnerId());
            for (Friend friend : friendList) {
                News news = new News();
                news.setMomentId(tweet.getId());
                news.setUserId(friend.getFriendId());
                newsDao.insert(news);
            }
            //给用户自己插入news记录
            News news = new News();
            news.setMomentId(tweet.getId());
            news.setUserId(tweet.getOwnerId());
            newsDao.insert(news);
            //创建一个新对象用于更新状态为0，表示该微博处理完毕
            Tweet updateStatus = new Tweet();
            updateStatus.setId(tweet.getId());
            updateStatus.setStatus(0);
            tweetDao.update(updateStatus);
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
        if(friend==null|friend.getFriendId()==null||friend.getUserId()==null){
            return new ServiceResult(Status.ERROR, ServiceMessage.PARAMETER_NOT_ENOUGHT.message, null);
        }
        try{
        List<Tweet> tweetList = tweetDao.listMyMomentByOwnerIdDesc(friend.getUserId(), 1000, 0);
        for (Tweet tweet : tweetList) {
            News news = new News();
            news.setMomentId(tweet.getId());
            news.setUserId(friend.getFriendId());
            newsDao.insert(news);
        }
        tweetList = tweetDao.listMyMomentByOwnerIdDesc(friend.getFriendId(), 1000, 0);
        for (Tweet tweet : tweetList) {
            News news = new News();
            news.setMomentId(tweet.getId());
            news.setUserId(friend.getUserId());
            newsDao.insert(news);
        }}catch (DaoException e){
            e.printStackTrace();
            return new ServiceResult(Status.ERROR, ServiceMessage.DATABASE_ERROR.message, null);
        }
        return new ServiceResult(Status.SUCCESS,null,null);
    }

    /**
     * 删除一条微博
     *
     * @param momentId 微博id
     * @name removeMoment
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/7
     */
    @Override
    public ServiceResult removeMoment(BigInteger momentId) {
        try {
            //判空
            if (momentId == null) {
                throw new ServiceException(ServiceMessage.NOT_NULL.message);
            }
            //检查是否存在
            if (tweetDao.getMomentById(momentId) == null) {
                return new ServiceResult(Status.ERROR, ServiceMessage.NOT_FOUND.message, momentId);
            }
            //删除
            Tweet tweet = new Tweet();
            tweet.setId(momentId);
            if (tweetDao.delete(tweet) != 1) {
                return new ServiceResult(Status.ERROR, ServiceMessage.PLEASE_REDO.message, tweet);
            }
        } catch (DaoException e) {
            e.printStackTrace();
            return new ServiceResult(Status.ERROR, ServiceMessage.DATABASE_ERROR.message, momentId);
        }
        return new ServiceResult(Status.SUCCESS, ServiceMessage.OPERATE_SUCCESS.message, momentId);
    }

    /**
     * 更新一条微博
     *
     * @param tweet 要更新的微博
     * @name updateMoment
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/7
     */
    @Override
    public ServiceResult updateMoment(Tweet tweet) {
        try {
            //判空
            if (tweet == null) {
                throw new ServiceException(ServiceMessage.NOT_NULL.message);
            }
            //检查是否存在
            if (tweetDao.getMomentById(tweet.getId()) == null) {
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
    public ServiceResult listMyMoment(BigInteger userId, int page) {
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
            List<Tweet> tweetList = tweetDao.listMyMomentByOwnerIdDesc(userId, limit, offset);
            if (tweetList == null || tweetList.size() == 0) {
                return new ServiceResult(Status.SUCCESS, ServiceMessage.NO_MOMENT.message, tweetList);
            }
            User user = userDao.getUserById(userId);
            //将微博和用户信息转化成微博视图层对象
            for (Tweet tweet : tweetList) {
                News news = null;
                try {
                    news = newsDao.getNewsByMomentIdAndUserId(tweet.getId(), userId);
                } catch (DaoException e) {
                    e.printStackTrace();
                }
                if (news == null) {
                    return new ServiceResult(Status.ERROR, ServiceMessage.DATABASE_ERROR.message, null);
                }
                toMomentVOObject(momentVOList, news, tweet, user);
            }
        } catch (DaoException e) {
            e.printStackTrace();
        }
        return new ServiceResult(Status.SUCCESS,null, momentVOList);
    }

    /**
     * 查询一个用户可见的所有微博，包括自己的和朋友的
     *
     * @param userId 用户id
     * @param page   页数
     * @name listNews
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/7
     */
    @Override
    public ServiceResult listNews(BigInteger userId, int page) {
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
        List<TweetVO> momentVOList = new LinkedList<>();
        try {
            List<News> newsList;
            newsList = newsDao.listNewsByUserId(userId, limit, offset);
            //查找微博动态
            if (newsList == null || newsList.size() == 0) {
                if(page==1){
                    return new ServiceResult(Status.SUCCESS, ServiceMessage.NO_NEWS.message, momentVOList);
                }
                return new ServiceResult(Status.SUCCESS, ServiceMessage.NO_MORE.message, momentVOList);
            }
            //根据动态中的微博id获取微博数据
            for (News news : newsList) {
                Tweet tweet = tweetDao.getMomentById(news.getMomentId());
                //获取微博的发布者的用户信息
                User user = userDao.getUserById(tweet.getOwnerId());
                if(user==null){
                    return new ServiceResult(Status.ERROR, ServiceMessage.DATABASE_ERROR.message, momentVOList);
                }
                //将微博和动态信息转化成微博视图层对象
                toMomentVOObject(momentVOList, news, tweet, user);
                //统计浏览量
                if(!news.getViewed()){
                    tweet.setView(tweet.getView()+1L);
                    tweetDao.update(tweet);
                    news.setViewed(true);
                    newsDao.update(news);
                }
            }
        } catch (DaoException e) {
            e.printStackTrace();
            return new ServiceResult(Status.ERROR, ServiceMessage.DATABASE_ERROR.message, momentVOList);
        }
        return new ServiceResult(Status.SUCCESS,null, momentVOList);
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
    synchronized  public ServiceResult love(BigInteger userId, BigInteger momentId) {
        if (userId == null || momentId == null) {
            throw new ServiceException(ServiceMessage.NOT_NULL.message);
        }
        News news;
        try {
            news = newsDao.getNewsByMomentIdAndUserId(momentId, userId);
            //检查news是否存在
            if (news == null) {
                return new ServiceResult(Status.ERROR, ServiceMessage.DATABASE_ERROR.message, null);
            }
            Tweet tweet = tweetDao.getMomentById(news.getMomentId());
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
        return new ServiceResult(Status.SUCCESS,null, news.getLoved());
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
                List<Tweet> tweetList = tweetDao.listPhoto(userId,limit,offset);
                if(tweetList ==null|| tweetList.size()==0){
                    return new ServiceResult(Status.ERROR, ServiceMessage.NO_MOMENT.message, null);
                }
            for (Tweet tweet : tweetList) {
                photoList.add(tweet.getPhoto());
            }
        } catch (DaoException e) {
            e.printStackTrace();
            return new ServiceResult(Status.ERROR, ServiceMessage.DATABASE_ERROR.message, photoList);
        }
        return new ServiceResult(Status.SUCCESS, null, photoList);
    }

    /**
     * 建造一个微博试图层对象集合，需要一个持久化对象集合，和一条动态记录，和该用户的信息
     *
     * @param momentVOList 试图层对象集合
     * @param news         动态记录
     * @param tweet       微博
     * @param user         该用户的信息
     * @name toMomentVOObject
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/8
     */
    private void toMomentVOObject(List<TweetVO> momentVOList, News news, Tweet tweet, User user) {
        TweetVO momentVO = new MomentVOBuilder().setContent(tweet.getContent()).setUserId(tweet.getOwnerId())
                .setId(tweet.getId()).setRemark(tweet.getRemark()).setShare(tweet.getShare()).setUserName(user.getName())
                .setView(tweet.getView()).setCollect(tweet.getCollect()).setLove(tweet.getLove()).setUserPhoto(user.getPhoto())
                .setShared(news.getShared()).setViewed(news.getViewed()).setCollected(news.getCollected()).setPhoto(tweet.getPhoto())
                .setLoved(news.getLoved()).setTime(tweet.getTime()).build();
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
        String legalText = toLegalText(content);
        if (content.equals(legalText)) {
            return true;
        }
        return false;
    }


}
