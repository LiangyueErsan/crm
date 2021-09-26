package com.javaEE.crm.settings.service.impl;

import com.javaEE.crm.exception.LoginException;
import com.javaEE.crm.settings.dao.UserDao;
import com.javaEE.crm.settings.domain.User;
import com.javaEE.crm.settings.service.UserService;
import com.javaEE.crm.utils.DateTimeUtil;
import com.javaEE.crm.utils.SqlSessionUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserServiceImpl implements UserService {

    //调用dao层，以成员变量形式 
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

    @Override
    public User login(String loginAct, String loginPwd, String ip) throws LoginException {
        Map<String, String> map = new HashMap<String, String>();
        map.put("loginAct", loginAct);
        map.put("loginPwd", loginPwd);
        User user = userDao.login(map);

        if (user == null){
            throw new LoginException("账号密码错误！");
        }

        //程序继续向下执行，说明已经拿到正确的账号密码，开始验证剩余三项
        //验证时效时间
        String expireTime = user.getExpireTime();
        String currentTime = DateTimeUtil.getSysTime();
        if (expireTime.compareTo(currentTime) < 0){
            throw new LoginException("账号已失效");
        }
        //判断锁定状态
        String lockState = user.getLockState();
        if ("0".equals(lockState)){
            throw new LoginException("账号已锁定");
        }

        //判断ip
        String allowIps = user.getAllowIps();
        if (!allowIps.contains(ip)){
            throw new LoginException("ip地址受限，请咨询管理员");
        }

        return user;
    }

    @Override
    public List<User> getUserList() {
        List<User> userList = userDao.selectAll();
        return userList;
    }
}
