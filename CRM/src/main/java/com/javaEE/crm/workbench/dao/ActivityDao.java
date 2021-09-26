package com.javaEE.crm.workbench.dao;

import com.javaEE.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityDao {
    int saveActivity(Activity activity);

    int getTotal(Map<String, Object> map);

    List<Activity> getPageList(Map<String, Object> map);

    int deleteByIds(String[] ids);

    Activity getActivity(String id);

    int updateActivity(Activity activity);

    Activity getDetail(String id);
}
