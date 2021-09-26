package com.javaEE.crm.workbench.service;

import com.javaEE.crm.vo.PaginationVO;
import com.javaEE.crm.workbench.domain.Activity;
import com.javaEE.crm.workbench.domain.ActivityRemark;

import java.util.List;
import java.util.Map;

public interface ActivityService {

    Boolean saveActivity(Activity activity);

    PaginationVO<Activity> pageList(Map<String, Object> map);

    Boolean deleteActivity(String[] ids);

    Map<String, Object> editActivity(String id);

    Boolean updateActivity(Activity activity);

    Activity getDetail(String id);

    List<ActivityRemark> getNote(String id);
}
