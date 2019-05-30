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
import com.hyc.www.model.po.Remark;
import com.hyc.www.service.annotation.Freeze;

import java.math.BigInteger;

/**
 * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
 * @description 负责评论服务
 * @date 2019-05-14 01:14
 */
public interface RemarkService {
    /**添加一条评论
     * @name addRemark
     * @param remark 评论
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/14
     */
    @Freeze
    ServiceResult addRemark(BigInteger userId,Remark remark);
    /**
     * 查询一条评论
     *
     * @param momentId 朋友圈id
     * @param page   页数
     * @name listRemark
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/14
     */
    ServiceResult listRemark(BigInteger momentId, int page);

    /**
     * 删除一条评论
     *
     * @param remarkId 评论id
     * @name removeRemark
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/14
     */
    ServiceResult removeRemark(BigInteger remarkId);


}
