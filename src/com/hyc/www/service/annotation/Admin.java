package com.hyc.www.service.annotation;

import java.lang.annotation.*;

/**
 * @author <a href="mailto:kobe524348@gmail.com">黄钰朝</a>
 * @description 负责注解需要检查用户是否是管理员的方法
 * @date 2019-05-30 17:24
 */
@Documented
@Target(value = ElementType.METHOD)
@Retention(value= RetentionPolicy.RUNTIME)
public @interface Admin {
}
