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

package com.hyc.www.factory;

import com.hyc.www.dao.UserDao;
import com.hyc.www.model.dto.ServiceResult;
import com.hyc.www.model.po.User;
import com.hyc.www.service.annotation.Admin;
import com.hyc.www.service.annotation.Freeze;
import com.hyc.www.service.constants.ServiceMessage;
import com.hyc.www.service.constants.Status;
import com.hyc.www.service.constants.UserType;
import org.apache.log4j.Logger;

import java.lang.annotation.Annotation;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;


/**
 * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
 * @description 生产服务代理
 * @date 2019-05-01 11:01
 */
public class ServiceProxyFactory implements InvocationHandler {

    private Object target;

    private final UserDao userDao = (UserDao) DaoProxyFactory.getInstance().getProxyInstance(UserDao.class);

    public Object getProxyInstance(Object target) {
        this.target =target;
        return Proxy.newProxyInstance(target.getClass().getClassLoader(), target.getClass().getInterfaces(), this);
    }


    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        Annotation freeze = method.getAnnotation(Freeze.class);
        if(freeze!=null){
            //获取用户
            User user = userDao.getUserById(args[0]);
            if(user.getStatus()==1){
                return new ServiceResult(Status.ERROR, ServiceMessage.HAVE_BEEN_FROST.message,null);
            }
        }
        Annotation admin = method.getAnnotation(Admin.class);
        if(admin!=null){
            //获取用户
            User user = userDao.getUserById(args[0]);
            if(!user.getType().equalsIgnoreCase(UserType.ADMIN.toString())){
                return new ServiceResult(Status.ERROR, ServiceMessage.NOT_ADMIN.message,null);
            }
            //打印日志
            Logger logger = Logger.getLogger(method.getClass());
            logger.info("管理员["+user.getName()+"][id:"+user.getId()+"]进行了["+method.getName()+"]操作");
        }
        return method.invoke(target, args);
    }

    public Object getTarget() {
        return target;
    }

    public void setTarget(Object target) {
        this.target = target;
    }
}
