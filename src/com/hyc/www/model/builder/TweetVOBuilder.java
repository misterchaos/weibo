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

package com.hyc.www.model.builder;

import com.hyc.www.model.vo.TweetVO;

import java.math.BigInteger;
import java.sql.Timestamp;

/**
 * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
 * @description 负责朋友圈视图层对象的建造
 * @date 2019-05-07 20:32
 */
public class TweetVOBuilder {
    private TweetVO tweetVO;

    public TweetVOBuilder() {
        this.tweetVO = new TweetVO();
    }

    public TweetVO build() {
        return this.tweetVO;
    }


    public TweetVOBuilder setTime(Timestamp time){
        this.tweetVO.setTime(time);
        return this;
    }

    public TweetVOBuilder setUserPhoto(String userPhoto){
        this.tweetVO.setUserPhoto(userPhoto);
        return this;
    }



    public TweetVOBuilder setUserName(String userName){
        this.tweetVO.setUserName(userName);
        return this;
    }

    public TweetVOBuilder setId(BigInteger id) {
        this.tweetVO.setId(id);
        return this;
    }

    public TweetVOBuilder setUserId(BigInteger userId) {
        this.tweetVO.setOwnerId(userId);
        return this;
    }

    public TweetVOBuilder setContent(String content) {
        this.tweetVO.setContent(content);
        return this;
    }

    public TweetVOBuilder setShare(Long share) {
        this.tweetVO.setShare(share);
        return this;
    }

    public TweetVOBuilder setLove(Long love) {
        this.tweetVO.setLove(love);
        return this;
    }
    public TweetVOBuilder setRemark(Long remark) {
        this.tweetVO.setRemark(remark);
        return this;
    }

    public TweetVOBuilder setView(Long view) {
        this.tweetVO.setView(view);
        return this;
    }

    public TweetVOBuilder setSort(String sort){
        this.tweetVO.setSort(sort);
        return this;
    }



}
