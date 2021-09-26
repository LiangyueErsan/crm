package com.javaEE.crm.settings.web.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.javaEE.crm.settings.domain.User;
import com.javaEE.crm.settings.service.UserService;
import com.javaEE.crm.settings.service.impl.UserServiceImpl;
import com.javaEE.crm.utils.MD5Util;
import com.javaEE.crm.utils.PrintJson;
import com.javaEE.crm.utils.ServiceFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;


/*
* @Controller创建处理器对象，放在springMvc容器中
* @requestMapping放在类上面用来声明处理请求地址的公共部分
*/
//@Controller
public class UserController extends HttpServlet {

    //@RequestMapping(value = "/settings/user/login.do", method = RequestMethod.POST)
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws IOException {

        System.out.println("进入到用户控制器");

        String path = request.getServletPath();
        System.out.println(path);

        if("/settings/user/login.do".equals(path)){

            login(request,response);

        }else if("/settings/user/xxx.do".equals(path)){

            //xxx(request,response);

        }

    }

    //@Resource
    //private UserService userService;

    //登录操作
    //@ResponseBody
    private void login(HttpServletRequest request, HttpServletResponse response) throws IOException {

        //String json = "";
        System.out.println("进入到验证登录操作！");
        String loginAct = request.getParameter("loginAct");
        String loginPwd = request.getParameter("loginPwd");
        System.out.println("loginAct=====" + loginAct + "||" + "loginPwd====" + loginPwd);
        //将密码的明文形式转换为MD5的密文形式
        loginPwd = MD5Util.getMD5(loginPwd);
        //接收浏览器端的IP地址，从request中获取，熟悉方法名称
        String ip = request.getRemoteAddr();
        System.out.println("ip=============" + ip);

        //未来业务层开发，统一使用代理类形态的接口对象，因为要涉及到事务，使用代理处类才可以，记住获取代理类的方法！！！！！！！！！！！
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
       /* ObjectMapper om = new ObjectMapper();
        response.setContentType("application/json;charset=utf-8");
        PrintWriter pw = response.getWriter();*/

        //使用自定义异常，来处理登录异常信息
        try {
            User user = userService.login(loginAct,loginPwd,ip);
            //user保存在session域中，而不是请求作用于，是因为request作用域登录成功后就销毁了，但是用户信息还需要在页面中展示
            //session.setAttribute("user", user);
            //暂时先不使用ssm框架
          /*  json = om.writeValueAsString(true);
            pw.println(json);
            pw.flush();
            pw.close();*/

            //使用传统写法
            //如果程序执行到此处，说明业务层没有为controller抛出任何的异常
            //表示登录成功
            /*
                {"success":true}
             */
            request.getSession().setAttribute("user", user);
            //使用json返回数据
            PrintJson.printJsonFlag(response, true);

        }catch(Exception e){
            e.printStackTrace();
            //一旦程序执行了catch块的信息，说明业务层为我们验证登录失败，为controller抛出了异常
            //表示登录失败
            /*
                {"success":false,"msg":?}
             */
            //错误消息从业务层取
            String msg = e.getMessage();
            /*
                我们现在作为Controller，需要为ajax请求提供多项信息
                可以有两种手段来处理：
                    （1）将多项信息打包成为map，将map解析为json串
                    （2）创建一个Vo
                            private boolean success;
                            private String msg;
                    如果对于展现的信息将来还会大量的使用，我们创建一个vo类，使用方便
                    如果对于展现的信息只有在这个需求中能够使用，我们使用map就可以了
             */
            Map<String,Object> map = new HashMap<String,Object>();
            map.put("success", false);
            map.put("msg", msg);
            /*json = om.writeValueAsString(map);
            pw.println(json);
            pw.flush();
            pw.close();*/
            //传统写法
            PrintJson.printJsonObj(response, map);
        }
    }
}
