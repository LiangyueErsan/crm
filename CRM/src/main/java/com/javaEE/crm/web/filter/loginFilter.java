package com.javaEE.crm.web.filter;

import com.javaEE.crm.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class loginFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {
        System.out.println("进入到一个验证是否登录的过滤器");
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        String path = request.getServletPath();
        if ("/login.jsp".equals(path) || "/settings/user/login.do".equals(path)){
            chain.doFilter(req, resp);
        }else{
            if(user != null){
                //到此处说明用户已经登录了,直接放行
                chain.doFilter(req, resp);
            }else{
                //重定向到登录页面
                /**
                 * 两个问题：a:重定向路径：使用绝对路径：转发使用内部路径，不加“/项目名”，重定向必须以“/项目名”开头
                 * b:为什么不选择转发？answer：转发后浏览器地址栏不会更新，而重定向会更新为当前页面的地址；
                 */
                //这里项目名称用request获取，不要写死！！！！！！！！！
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            }
        }
    }

    @Override
    public void destroy() {

    }
}
