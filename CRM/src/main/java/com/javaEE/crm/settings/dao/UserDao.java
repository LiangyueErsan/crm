package com.javaEE.crm.settings.dao;

import com.javaEE.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserDao {
    List<User> selectAll();

    User login(Map<String, String> map);
}
