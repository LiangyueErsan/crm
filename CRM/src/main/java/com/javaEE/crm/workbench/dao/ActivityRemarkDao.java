package com.javaEE.crm.workbench.dao;

import com.javaEE.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {

    int getCountByIds(String[] ids);

    int deleteByIds(String[] ids);

    List<ActivityRemark> getNoteById(String id);
}
