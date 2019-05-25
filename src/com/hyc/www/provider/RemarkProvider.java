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
import com.hyc.www.model.po.Remark;
import com.hyc.www.provider.annotation.Action;
import com.hyc.www.provider.annotation.ActionProvider;
import com.hyc.www.service.RemarkService;
import com.hyc.www.service.impl.RemarkServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigInteger;

import static com.hyc.www.util.BeanUtils.jsonToJavaObject;
import static com.hyc.www.util.ControllerUtils.returnJsonObject;

/**
 * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
 * @description 负责评论的业务流程
 * @date 2019-05-14 01:38
 */
@ActionProvider(path = "/remark")
public class RemarkProvider extends BaseProvider {

    private final RemarkService remarkService = (RemarkService) new ServiceProxyFactory().getProxyInstance(new RemarkServiceImpl());
    /**
     * 提供发布评论的业务流程
     *
     * @name postRemark
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/14
     */
    @Action(method = RequestMethod.ADD_DO)
    public void postRemark(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Remark remark = (Remark) jsonToJavaObject(req.getInputStream(), Remark.class);
        ServiceResult result;
        result = remarkService.addRemark(remark);
        returnJsonObject(resp, result);
    }

    /**
     * 提供获取评论的业务流程
     *
     * @name listRemark
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/14
     */
    @Action(method = RequestMethod.LIST_DO)
    public void listRemark(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String momentId = req.getParameter("tweet_id");
        String page = req.getParameter("page");
        ServiceResult result;
        result = remarkService.listRemark(new BigInteger(momentId), Integer.parseInt(page));
        returnJsonObject(resp, result);
    }

    /**
     * 提供删除评论的业务流程
     *
     * @name deleteRemark
     * @notice none
     * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
     * @date 2019/5/14
     */
    @Action(method = RequestMethod.DELETE_DO)
    public void delete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String remarkId = req.getParameter("remark_id");
        ServiceResult result;
        result = remarkService.removeRemark(new BigInteger(remarkId));
        returnJsonObject(resp, result);
    }
}
