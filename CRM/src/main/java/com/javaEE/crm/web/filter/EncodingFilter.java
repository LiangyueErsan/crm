package com.javaEE.crm.web.filter;

import javax.servlet.*;
import java.io.IOException;

public class EncodingFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {

        System.out.println("进入字符过滤器");
        //post请求乱码
        req.setCharacterEncoding("UTF-8");
        //响应流响应中文乱码
        resp.setContentType("text/html;charset=utf-8");

        //请求放行
        chain.doFilter(req, resp);

    }

    @Override
    public void destroy() {

    }

}
