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
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>


<script type="text/javascript">


	$(function(){

		//为更新按钮绑定事件
		$("#updateBtn").click(function (){

			//ajax请求
			$.ajax({
				url: "workbench/activity/updateActivity.do",
				data: {
					"id": $.trim($("#edit-id").val()),
					"owner": $.trim($("#edit-owner").val()),
					"name": $.trim($("#edit-name").val()),
					"startDate": $.trim($("#edit-startDate").val()),
					"endDate": $.trim($("#edit-endDate").val()),
					"cost": $.trim($("#edit-cost").val()),
					"description": $.trim($("#edit-description").val())
				},
				/*添加修改删除，和涉及密码的操作用post，查询用get*/
				type: "post",
				dataType: "json",
				success: function (data) {
					/*后台返回添加成功或者失败就可以，即
					* success:true/false
					* */
					if (data.success){

						//成功后刷新活动信息列表，局部刷新，并且 关闭模态窗口
						//pageList(1,2);两个参数，当前页，维持设置不变
						pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
								,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
						//关闭模态窗口
						$("#editActivityModal").modal("hide");
					}
					else{
						alert("修改失败！");
					}
				}
			})

		})
		//页面加载完成后局部刷新调用一个函数，刷新列表

		//为修改按钮绑定事件
		$("#editBtn").click(function () {

			//引入日历控件
			$(".time").datetimepicker({
				minView:"month",
				language:"zh-CN",
				format:"yyyy-mm-dd",
				autoclose:true,
				todayBtn:true,
				pickerPosition:"bottom-left"
			});

			//获取选中的数据
			var $xz = $("input[name=xz]:checked");
			if ($xz.length==0){
				alert("请选中需要修改的活动");
			}else if ($xz.length>1){
				alert("单次只能修改一条活动");
			}else {
				//拿到选中对象的id
				var id = $xz.val();
				//走后台先获取后台数据，查询已选中的活动详情
				$.ajax({
					url:"workbench/activity/getUserListAndActivity.do",
					data:{
						"id":id
						},
					type:"get",
					dataType:"json",
					success:function (data) {
						/*
                        * 需要的数据是一个activity对象和用户列表
                        * {"userList":[{user1},{user2}],"activity":{activity对象}}
                        * */
						//取数据：userList
						var html = "";
						$.each(data.userList,function (i,n) {
							html += "<option value='"+n.id+"'>"+n.name+"</option>";
						})
						//将得到的html字符串赋值给下拉列表（select标签对）
						$("#edit-owner").html(html);
						//取数据，activity
						$("#edit-id").val(data.activity.id);
						$("#edit-name").val(data.activity.name);
						$("#edit-startDate").val(data.activity.startDate);
						$("#edit-endDate").val(data.activity.endDate);
						$("#edit-owner").val(data.activity.owner);
						$("#edit-description").val(data.activity.description);
						$("#edit-cost").val(data.activity.cost);

						//打开模态窗口
						$("#editActivityModal").modal("show");
					}


				})
			}
	})



		$("#addBtn").click(function (){

			//引入日历控件
			$(".time").datetimepicker({
				minView:"month",
				language:"zh-CN",
				format:"yyyy-mm-dd",
				autoclose:true,
				todayBtn:true,
				pickerPosition:"bottom-left"
			});

			//走后台先获取后台数据，为下拉列表取值，局部刷新ajax
			$.ajax({
				url:"workbench/activity/getUserList.do",
				//这里查询所有，因此不需要从前台给后端传递数据
				type:"get",
				dataType:"json",
				success:function (data) {
					/*
					* 将用户列表List解析成需要的数据
					* */
					//定义一个字符串
					var html = "";
					//循环遍历data中的user数据
					$.each(data, function (i, n) {

						html += "<option value='"+n.id+"'>"+n.name+"</option>";

					})
					//将得到的html字符串赋值给下拉列表（select标签对）
					$("#create-owner").html(html);
					//设置当前登录对象为下拉框默认选项

					//js中使用el表达式需要写在字符串中！！！！！
					var id = "${user.id}";
					$("#create-owner").val(id);

					/*
					* 操作模态窗口的方式：操作模态窗口的jquery对象，调用modal方法，传递参数：show或hide
					* */
					$("#createActivityModal").modal("show");
				}
			})
		})

		//为保存按钮绑定添加操作事件
		$("#saveBtn").click(function (){

			//ajax请求
			$.ajax({
				url: "workbench/activity/saveActivity.do",
				data: {
					"owner": $.trim($("#create-owner").val()),
					"name": $.trim($("#create-name").val()),
					"startDate": $.trim($("#create-startDate").val()),
					"endDate": $.trim($("#create-endDate").val()),
					"cost": $.trim($("#create-cost").val()),
					"description": $.trim($("#create-description").val())
				},
				/*添加修改删除，和涉及密码的操作用post，查询用get*/
				type: "post",
				dataType: "json",
				success: function (data) {
					/*后台返回添加成功或者失败就可以，即
					* success:true/false
					* */
					if (data.success){

						//清空已经输入的内容,重置form表单,但是jquery没有提供reset方法，智能使用原生js的方法，因此需要将jquery对象转为原生js的dom对象
						//jq-->dom:jqueryObi[index]===========dom-->jq:$(domObj)
						$("#activityAddForm")[0].reset();

						//成功后刷新活动信息列表，局部刷新，并且 关闭模态窗口
						//pageList(1,2);
						pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

						//关闭模态窗口
						$("#createActivityModal").modal("hide");
					}
					else{
						alert("添加失败！");
					}
				}
			})

		})
		//页面加载完成后局部刷新调用一个函数，刷新列表
		pageList(1,2);


		//为查询按钮绑定单击事件,出发pageList方法
		$("#search-button").click(function () {

			/*
			* 点击查询时，应该将搜索框中的信息保存起来，放在隐藏域中
			* */

			$("#hidden-name").val($.trim($("#search-name").val()));
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-startDate").val($.trim($("#search-startDate").val()));
			$("#hidden-endDate").val($.trim($("#search-endDate").val()));

			pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
		})

		//为全选复选框绑定事件，触发全选操作
		$("#selectAll").click(function () {

			$("input[name=xz]").prop("checked",this.checked);

		})
		//上述操作的反向操作，注意事项
		/*
		* 'xz'是动态生成的元素，不能以普通绑定事件的方法来操作
		* 因此需要用到on方法的形式来触发
		* 语法：
		* $(需要绑定的元素的有效的外层元素).on(绑定事件的方法，需要绑定元素的jquery对象，回调函数)
		* 这里因为<tr><td>均为动态生成的，因此需要使用最外层的<tbody>标签来选择
		* */
		$("#activityBody").on("click",$("input[name=xz]"),function () {
			//这里判定方法：判断勾选的数量和总数量是否一致，一致则全选，不一致则取消全选

			$("#selectAll").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length);

		})

		/*
		* 执行删除操作
		* */
		$("#deleteBtn").click(function () {
			//取出所有选中的记录
			var $xz = $("input[name=xz]:checked");

			if ($xz.length==0){
				alert("请选中需要删除的数据！");
			}else{

				//加一个确定按钮
				if (confirm("是否删除所选数据？")){
					//拼接需要传到后台的数据
					var param = "";
					//循环遍历将$xz对象中的每一个对象取出其value值，再用&分隔
					for (var i=0; i<$xz.length; i++){
						param += "id="+$($xz[i]).val();

						if (i<$xz.length-1){
							param += "&";
						}
					}
					//alert(param);


					$.ajax({
						url :"workbench/activity/delete.do",
						data :param,
						type :"post",
						dataType :"json",
						success :function (data) {
							//这里需求返回成功还是失败即可
							if (data.success){
								//调用pageList函数进行刷新，并且全选框取消
								pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
							}else{
								alert("删除失败！");
							}
						}
					})
				}
			}

		})
	});

	/**
	 * 所有关系型数据库做分页操作，前端基础组件都是用下面两个参数
	 * @param pageNo：页码
	 * @param pageSize：每页展现的条数
	 */
	function pageList(pageNo, pageSize) {

		/*
		* 每次调用函数均刷新全选框*/
		$("#selectAll").prop("checked",false);

		/*
		* 查询前，将隐藏域中的信息取出来，重新赋值到搜索框中
		* 学习隐藏域的用法！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
		* */
		$("#search-name").val($.trim($("#hidden-name").val()));
		$("#search-owner").val($.trim($("#hidden-owner").val()));
		$("#search-startDate").val($.trim($("#hidden-startDate").val()));
		$("#search-endDate").val($.trim($("#hidden-endDate").val()));

		$.ajax({
			url :"workbench/activity/pageList.do",
			data :{
				"pageNo": pageNo,
				"pageSize": pageSize,
				"name": $.trim($("#search-name").val()),
				"owner": $.trim($("#search-owner").val()),
				"startDate": $.trim($("#search-startDate").val()),
				"endDate": $.trim($("#search-endDate").val()),
			},
			type :"get",
			dataType :"json",
			success : function (data) {
				/*
				* 分析这里需要的数{"total":int,"aList":[{a1},{a2},{a3}]}
				* */
				//将数据展示在页面中!!!!!!!!!!!!!!!!!!!!!!!
				//掌握如何展示数据，如何遍历拿数据！！！！！！！！！！！！！！！！！！！！！！！

				var html = "";

				/*遍历得到的data数据*/
				$.each(data.dataList, function (i,n) {

					html += '<tr class="active">';
					html += '<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
					html += '<td><a style="text-decoration: none;cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id='+n.id+'\';">'+n.name+'</a></td>';
					html += '<td>'+n.owner+'</td>';
					html += '<td>'+n.startDate+'</td>';
					html += '<td>'+n.endDate+'</td>';
					html += '</tr>';

				})
				$("#activityBody").html(html);

				//计算总页数
				var totalPages = data.total%pageSize==0 ? data.total/pageSize : parseInt(data.total/pageSize)+1;

				//数据处理完成结合分页插件，对前端进行分页展示
				$("#activityPage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数
					totalRows: data.total, // 总记录条数

					visiblePageLinks: 3, // 显示几个卡片

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,

					//该回调函数在分页组件点击的时候触发，但是函数是自己写的，参数是前端模板定的
					onChangePage : function(event, data){
						pageList(data.currentPage , data.rowsPerPage);
					}
				});



			}
		})
	}
	
</script>
</head>
<body>
	<%--创建保存域，来存放search在未执行时，text中存放的内容--%>
	<input type="hidden" id="hidden-name"/>
	<input type="hidden" id="hidden-owner"/>
	<input type="hidden" id="hidden-startDate"/>
	<input type="hidden" id="hidden-endDate"/>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="activityAddForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
										<%--这里展现option内的数据--%>
								</select>
							</div>
                            <label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-name">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startDate" readonly>
							</div>
							<label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endDate" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">

						<%--创建一个隐藏域，用来放不需要让用户看到的id--%>
						<input type="hidden" id="edit-id" />
					
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
								</select>
							</div>
                            <label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-name" value="发传单">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startDate" readonly>
							</div>
							<label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endDate" readonly>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<%--关于textarea
									1、标签要以标签对呈现
									2、该标签对属于表单元素范畴，取值和赋值同form相同，使用val()，不用html()
								--%>
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<%--
					data-dismiss="modal":关闭模态窗口
					--%>
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表777</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="search-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="search-endDate">
				    </div>
				  </div>
				  
				  <button id="search-button" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
					<%--这里点击按钮的操作不能写死，因此去掉data-toggle="modal"和 data-target="#createActivityModal"两个参数，加上id后使用js代码来控制按钮单击事件--%>
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除777</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="selectAll" /></td>
							<td>名称123</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityBody">
						<%--修改代码实现动态展示查询结果--%>
						<%--<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
                            <td>2020-10-10</td>
                            <td>2020-10-20</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="activityPage"></div>
				<%--<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
				</div>
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
					<div class="btn-group">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							10
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#">20</a></li>
							<li><a href="#">30</a></li>
						</ul>
					</div>
					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
				</div>
				<div style="position: relative;top: -88px; left: 285px;">
					<nav>
						<ul class="pagination">
							<li class="disabled"><a href="#">首页</a></li>
							<li class="disabled"><a href="#">上一页</a></li>
							<li class="active"><a href="#">1</a></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">下一页</a></li>
							<li class="disabled"><a href="#">末页</a></li>
						</ul>
					</nav>
				</div>--%>
			</div>
			
		</div>
		
	</div>
</body>
</html>