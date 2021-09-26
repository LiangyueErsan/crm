package com.javaEE.crm.workbench.web.controller;

import com.javaEE.crm.settings.domain.User;
import com.javaEE.crm.settings.service.UserService;
import com.javaEE.crm.settings.service.impl.UserServiceImpl;
import com.javaEE.crm.utils.*;
import com.javaEE.crm.vo.PaginationVO;
import com.javaEE.crm.workbench.domain.Activity;
import com.javaEE.crm.workbench.domain.ActivityRemark;
import com.javaEE.crm.workbench.service.ActivityService;
import com.javaEE.crm.workbench.service.impl.ActivityServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;


/*
* @Controller创建处理器对象，放在springMvc容器中
* @requestMapping放在类上面用来声明处理请求地址的公共部分
*/
//@Controller
public class ActivityController extends HttpServlet {

    //@RequestMapping(value = "/settings/user/login.do", method = RequestMethod.POST)
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        System.out.println("进入到市场活动控制器");

        String path = request.getServletPath();
        System.out.println(path);

        if("/workbench/activity/getUserList.do".equals(path)){

            getUserList(request, response);

        }else if("/workbench/activity/saveActivity.do".equals(path)){

            saveActivity(request,response);

        }else if("/workbench/activity/pageList.do".equals(path)){

            pageList(request,response);

        }else if ("/workbench/activity/delete.do".equals(path)){
            deleteActivity(request,response);
        }else if ("/workbench/activity/getUserListAndActivity.do".equals(path)){
            editActivity(request,response);
        }else if ("/workbench/activity/updateActivity.do".equals(path)){
            updateActivity(request,response);
        }else if ("/workbench/activity/detail.do".equals(path)){
            detail(request,response);
        }else if ("/workbench/activity/getNote.do".equals(path)){
            getNote(request,response);
        }

    }

    private void getNote(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入获取备注信息页面123！");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        //获取前端传值id
        String id = request.getParameter("activityId");
        List<ActivityRemark> activityRemarks = activityService.getNote(id);

        PrintJson.printJsonObj(response,activityRemarks);

    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入活动详情页！");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        //获取id
        String id = request.getParameter("id");

        Activity activity = activityService.getDetail(id);
        //此处需要将获取到的活动对象存储起来，因此使用请求转发
        //拿到id后使用请求转发，跳转到活动详情页面
        request.setAttribute("activity",activity);
        request.getRequestDispatcher("/workbench/activity/detail.jsp").forward(request,response);

    }

    private void updateActivity(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("update活动！");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        //获取前端数据
        String id = request.getParameter("id");
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String cost = request.getParameter("cost");
        String description = request.getParameter("description");
        //修改时间为当前系统时间,修改人为当前用户
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("user")).getName();

        Activity activity = new Activity();
        activity.setCost(cost);
        activity.setEditBy(editBy);
        activity.setEditTime(editTime);
        activity.setDescription(description);
        activity.setId(id);
        activity.setStartDate(startDate);
        activity.setEndDate(endDate);
        activity.setName(name);
        activity.setOwner(owner);
        //调用activityService的对应方法得到success返回值
        Boolean success = activityService.updateActivity(activity);


        //调用PrintJson工具类直接将得到的success值返回给前端
        PrintJson.printJsonFlag(response, success);
    }

    private void editActivity(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("修改活动！");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        //获取前端传过来的id
        String id = request.getParameter("id");
        //调用业务层,返回数据格式？？？
        /*
        * 返回数据格式：{"uList":userList,"activity":activity}
        * */
        Map<String,Object> map = activityService.editActivity(id);
        PrintJson.printJsonObj(response, map);
    }

    private void deleteActivity(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("删除活动并且刷新列表！！");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        //获取数据:同一个id多个value值用数组
        String ids[] = request.getParameterValues("id");

        //调用service层
        Boolean success = activityService.deleteActivity(ids);
        PrintJson.printJsonFlag(response, success);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("刷新列表展现活动信息(条件查询+分页查询)");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        //获取前端数据
        String pageNoStr = request.getParameter("pageNo");
        String pageSizeStr = request.getParameter("pageSize");
        String name = request.getParameter("name");
        String owner = request.getParameter("owner");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        //计算略过的记录数
        int pageNo = Integer.valueOf(pageNoStr);
        int pageSize = Integer.valueOf(pageSizeStr);
        int skipCount = (pageNo - 1) * pageSize;

        //将数据打包成map传到业务层，调用dao查询
        Map<String,Object> map = new HashMap<>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        //调用业务层
        /*
        * 这里可以使用map或者vo(里层向前端展现数据用vo)，vo在这里可以在其他模块中分页查询时使用，因此选用一个泛型为<T>的通用VO类
        * */
        PaginationVO<Activity> paginationVO = activityService.pageList(map);
        PrintJson.printJsonObj(response, paginationVO);
    }

    private void saveActivity(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("保存新建活动信息");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        //获取前端数据
        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String cost = request.getParameter("cost");
        String description = request.getParameter("description");
        //创建时间为当前系统时间,创建人为当前用户
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();

        Activity activity = new Activity();
        activity.setCost(cost);
        activity.setCreateBy(createBy);
        activity.setCreateTime(createTime);
        activity.setDescription(description);
        activity.setId(id);
        activity.setStartDate(startDate);
        activity.setEndDate(endDate);
        activity.setName(name);
        activity.setOwner(owner);
        //调用activityService的对应方法得到success返回值
        Boolean success = activityService.saveActivity(activity);


        //调用PrintJson工具类直接将得到的success值返回给前端
        PrintJson.printJsonFlag(response, success);
    }




    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("取得用户信息列表");

        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());

        List<User> userList = userService.getUserList();

        //调用PrintJson工具类直接将得到的userList返回给前端
        PrintJson.printJsonObj(response, userList);
    }
}
