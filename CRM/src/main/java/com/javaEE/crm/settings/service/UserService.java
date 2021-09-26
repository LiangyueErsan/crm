package com.javaEE.crm.settings.service;

import com.javaEE.crm.exception.LoginException;
import com.javaEE.crm.settings.domain.User;

import java.util.List;

public interface UserService {
    User login(String loginAct, String loginPwd, String ip) throws LoginException;

    List<User> getUserList();
}
