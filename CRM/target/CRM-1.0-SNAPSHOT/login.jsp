<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" +
request.getServerName() + ":" + request.getServerPort() +
request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

	<script>
		$(function () {
			//如果当前窗口不是顶层窗口，则将当前窗口设置为顶层窗口
			if (window.top!=window){
				window.top.location=window.location;
			}


			//清空用户文本框内容，保证每次刷新时账号框内内容为空，val()表示取值，val("")表示赋值
			$("#loginAct").val("");
			//页面加载完成后用户名文本框自动获得焦点
			$("#loginAct").focus();
			//登录按钮绑定操作，执行登录操作
			$("#submitBtn").click(function () {
				login();
			})
			//为当前窗口绑定敲键盘事件，，，event可以用来获取敲的键，，13为回车键
			$(window).keydown(function (event) {
				if(event.keyCode==13){
					login();
				}
			})
		})
		//自定义function方法要写在$(function()){}的外面
		function login() {
			//验证账号密码不能为空，同时去掉文本中的前后空格
			var loginAct = $.trim($("#loginAct").val());
			var loginPwd = $.trim($("#loginPwd").val());

			if(loginAct=="" || loginPwd==""){
				//往span中添加内容
				$("#msg").html("账号密码不能为空！");
				//为空的话终止该函数，不需要执行下面的局部刷新，终止方法
				return false;
			}
			//均不为空的话，提交局部刷新ajax请求给后台，ajax做局部刷新
			$.ajax({
				//前面不加/
				url:"settings/user/login.do",
				data:{
					"loginAct":loginAct,
					"loginPwd":loginPwd
				},
				//查询操作，但是参数涉及密码，因此需要用post请求
				type:"post",
				dataType:"json",
				success:function (data) {
					//alert(data);
					//分析此处前端需要的数据
					/*
					data：{"success":true/false,msg:"有各种错误原因，需要从后台提供准确的错误信息"}
					*/
					if (data.success){
						//直接跳转到工作台初始页面，form表单初始欢迎页<form action="workbench/index.jsp">
						window.location.href = "workbench/index.jsp";
					}else{
						//失败需要展示错误信息
						$("#msg").html(data.msg);
					}
				}
			})
		}
	</script>
</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2017&nbsp;动力节点</span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="workbench/index.jsp" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input id="loginAct" class="form-control" type="text" placeholder="用户名">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input id="loginPwd" class="form-control" type="password" placeholder="密码">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						
							<span id="msg" style="color: firebrick"></span>
						
					</div>
					<%--在form表单中，按钮的默认行为是提交表单，将按钮的type设置为button（原为submit）后，按钮触发行为手写js代码实现--%>
					<button id="submitBtn" type="button" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>