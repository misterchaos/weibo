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

package com.hyc.www.test;

import com.hyc.www.model.po.Message;
import com.hyc.www.model.po.Tweet;
import com.hyc.www.service.MessageService;
import com.hyc.www.service.TweetService;
import com.hyc.www.service.UserService;
import com.hyc.www.service.impl.MessageServiceImpl;
import com.hyc.www.service.impl.TweetServiceImpl;
import com.hyc.www.service.impl.UserServiceImpl;

import java.math.BigInteger;
import java.sql.Timestamp;
import java.util.List;

/**
 * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
 * @description 测试服务层
 * @date 2019-05-06 06:43
 */
public class TestService {
    public static void main(String[] args) {
        UserService userService = new UserServiceImpl();
        List list = (List) userService.listUserLikeName("昵称").getData();
        System.out.println("查询到："+list.size());

        MessageService messageService = new MessageServiceImpl();
        Message message = new Message();
        message.setChatId(BigInteger.valueOf(44));
        message.setSenderId(BigInteger.valueOf(0));
        message.setContent("测试");
        Timestamp timestamp = new Timestamp(1234);
        message.setTime(new Timestamp(1111111111));
        messageService.insertMessage(message);
        messageService.listAllMessage(0,40,1);
        messageService.listUnreadMessage(0,40,1);
        messageService.setAlreadyRead(0,40);

        TweetService tweetService = new TweetServiceImpl();
        Tweet tweet =new Tweet();
        tweet.setOwnerId(BigInteger.valueOf(0));
        tweet.setContent("第一条朋友圈");
        tweetService.insertMoment(tweet);
        tweetService.removeMoment(BigInteger.valueOf(8));
        tweetService.listMyMoment(BigInteger.valueOf(0),1);
        tweetService.listNews(BigInteger.valueOf(184),1);

    }
}
