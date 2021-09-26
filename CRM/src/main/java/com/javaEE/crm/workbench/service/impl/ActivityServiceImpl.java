package com.javaEE.crm.workbench.service.impl;

import com.javaEE.crm.settings.dao.UserDao;
import com.javaEE.crm.settings.domain.User;
import com.javaEE.crm.utils.SqlSessionUtil;
import com.javaEE.crm.vo.PaginationVO;
import com.javaEE.crm.workbench.dao.ActivityDao;
import com.javaEE.crm.workbench.dao.ActivityRemarkDao;
import com.javaEE.crm.workbench.domain.Activity;
import com.javaEE.crm.workbench.domain.ActivityRemark;
import com.javaEE.crm.workbench.service.ActivityService;
import com.sun.org.apache.xpath.internal.operations.Bool;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityServiceImpl implements ActivityService {

    //通过SqlSessionUtil工具获取dao
    private ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
    private ActivityRemarkDao activityRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);


    @Override
    public Boolean saveActivity(Activity activity) {

        int count = activityDao.saveActivity(activity);
        if (count != 1){
            return false;
        }
        return true;
    }

    @Override
    public PaginationVO<Activity> pageList(Map<String, Object> map) {

        //取得total
        int total = activityDao.getTotal(map);

        //取得pageList
        List<Activity> dataList = activityDao.getPageList(map);

        //将上述封装到VO中
        PaginationVO<Activity> vo = new PaginationVO<Activity>();
        vo.setTotal(total);
        vo.setDataList(dataList);

        return vo;
    }

    @Override
    public Boolean deleteActivity(String[] ids) {
        Boolean flag = true;
        /*
        * 分析业务需求，删两张表，先根据id查询出活动备注表中需要删除的信息
        * */
        //查询数量，保证业务完成后删除数量是正确的
        int count1 = activityRemarkDao.getCountByIds(ids);
        int count2 = activityRemarkDao.deleteByIds(ids);
        if (count1 != count2){
            flag = false;
        }

        //删除活动表中的数据
        int count3 = activityDao.deleteByIds(ids);
        if (count3 != ids.length){
            flag = false;
        }

        return flag;
    }

    @Override
    public Map<String, Object> editActivity(String id) {
        /*
        * 分析业务需求，1：查询用户列表，返回list；2：根据id查询activity，返回activity对象
        * */
        //获取用户列表
        List<User> userList = userDao.selectAll();
        //获取activity对象
        Activity activity = activityDao.getActivity(id);

        //封装到map中
        Map<String, Object> map = new HashMap<>();
        map.put("userList",userList);
        map.put("activity",activity);
        return map;
    }

    @Override
    public Boolean updateActivity(Activity activity) {
        int count = activityDao.updateActivity(activity);
        if (count != 1){
            return false;
        }
        return true;
    }

    @Override
    public Activity getDetail(String id) {
        return activityDao.getDetail(id);
    }

    @Override
    public List<ActivityRemark> getNote(String id) {
        return activityRemarkDao.getNoteById(id);
    }
}
