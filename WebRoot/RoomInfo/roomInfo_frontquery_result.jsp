<%@ page language="java" import="java.util.*"  contentType="text/html;charset=UTF-8"%> 
<%@ page import="com.chengxusheji.po.RoomInfo" %>
<%@ page import="com.chengxusheji.po.BuildingInfo" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
    List<RoomInfo> roomInfoList = (List<RoomInfo>)request.getAttribute("roomInfoList");
    //获取所有的buildingObj信息
    List<BuildingInfo> buildingInfoList = (List<BuildingInfo>)request.getAttribute("buildingInfoList");
    int currentPage =  (Integer)request.getAttribute("currentPage"); //当前页
    int totalPage =   (Integer)request.getAttribute("totalPage");  //一共多少页
    int recordNumber =   (Integer)request.getAttribute("recordNumber");  //一共多少记录
    BuildingInfo buildingObj = (BuildingInfo)request.getAttribute("buildingObj");
    String roomName = (String)request.getAttribute("roomName"); //房间名称查询关键字
    String roomTypeName = (String)request.getAttribute("roomTypeName"); //房间类型查询关键字
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1 , user-scalable=no">
<title>房间信息查询</title>
<link href="<%=basePath %>plugins/bootstrap.css" rel="stylesheet">
<link href="<%=basePath %>plugins/bootstrap-dashen.css" rel="stylesheet">
<link href="<%=basePath %>plugins/font-awesome.css" rel="stylesheet">
<link href="<%=basePath %>plugins/animate.css" rel="stylesheet">
<link href="<%=basePath %>plugins/bootstrap-datetimepicker.min.css" rel="stylesheet" media="screen">
</head>
<body style="margin-top:70px;">
<div class="container">
<jsp:include page="../header.jsp"></jsp:include>
	<div class="row"> 
		<div class="col-md-9 wow fadeInDown" data-wow-duration="0.5s">
			<div>
				<!-- Nav tabs -->
				<ul class="nav nav-tabs" role="tablist">
			    	<li><a href="<%=basePath %>index.jsp">首页</a></li>
			    	<li role="presentation" class="active"><a href="#roomInfoListPanel" aria-controls="roomInfoListPanel" role="tab" data-toggle="tab">房间信息列表</a></li>
			    	<li role="presentation" ><a href="<%=basePath %>RoomInfo/roomInfo_frontAdd.jsp" style="display:none;">添加房间信息</a></li>
				</ul>
			  	<!-- Tab panes -->
			  	<div class="tab-content">
				    <div role="tabpanel" class="tab-pane active" id="roomInfoListPanel">
				    		<div class="row">
				    			<div class="col-md-12 top5">
				    				<div class="table-responsive">
				    				<table class="table table-condensed table-hover">
				    					<tr class="success bold"><td>序号</td><td>记录编号</td><td>所在宿舍</td><td>房间名称</td><td>房间类型</td><td>房间价格(元/月)</td><td>总床位</td><td>剩余床位</td><td>寝室电话</td><td>操作</td></tr>
				    					<% 
				    						/*计算起始序号*/
				    	            		int startIndex = (currentPage -1) * 5;
				    	            		/*遍历记录*/
				    	            		for(int i=0;i<roomInfoList.size();i++) {
					    	            		int currentIndex = startIndex + i + 1; //当前记录的序号
					    	            		RoomInfo roomInfo = roomInfoList.get(i); //获取到房间信息对象
 										%>
 										<tr>
 											<td><%=currentIndex %></td>
 											<td><%=roomInfo.getRoomId() %></td>
 											<td><%=roomInfo.getBuildingObj().getBuildingName() %></td>
 											<td><%=roomInfo.getRoomName() %></td>
 											<td><%=roomInfo.getRoomTypeName() %></td>
 											<td><%=roomInfo.getRoomPrice() %></td>
 											<td><%=roomInfo.getTotalBedNumber() %></td>
 											<td><%=roomInfo.getLeftBedNum() %></td>
 											<td><%=roomInfo.getRoomTelephone() %></td>
 											<td>
 												<a href="<%=basePath  %>RoomInfo/<%=roomInfo.getRoomId() %>/frontshow"><i class="fa fa-info"></i>&nbsp;查看</a>&nbsp;
 												<a href="#" onclick="roomInfoEdit('<%=roomInfo.getRoomId() %>');" style="display:none;"><i class="fa fa-pencil fa-fw"></i>编辑</a>&nbsp;
 												<a href="#" onclick="roomInfoDelete('<%=roomInfo.getRoomId() %>');" style="display:none;"><i class="fa fa-trash-o fa-fw"></i>删除</a>
 											</td> 
 										</tr>
 										<%}%>
				    				</table>
				    				</div>
				    			</div>
				    		</div>

				    		<div class="row">
					            <div class="col-md-12">
						            <nav class="pull-left">
						                <ul class="pagination">
						                    <li><a href="#" onclick="GoToPage(<%=currentPage-1 %>,<%=totalPage %>);" aria-label="Previous"><span aria-hidden="true">&laquo;</span></a></li>
						                     <%
						                    	int startPage = currentPage - 5;
						                    	int endPage = currentPage + 5;
						                    	if(startPage < 1) startPage=1;
						                    	if(endPage > totalPage) endPage = totalPage;
						                    	for(int i=startPage;i<=endPage;i++) {
						                    %>
						                    <li class="<%= currentPage==i?"active":"" %>"><a href="#"  onclick="GoToPage(<%=i %>,<%=totalPage %>);"><%=i %></a></li>
						                    <%  } %> 
						                    <li><a href="#" onclick="GoToPage(<%=currentPage+1 %>,<%=totalPage %>);"><span aria-hidden="true">&raquo;</span></a></li>
						                </ul>
						            </nav>
						            <div class="pull-right" style="line-height:75px;" >共有<%=recordNumber %>条记录，当前第 <%=currentPage %>/<%=totalPage %> 页</div>
					            </div>
				            </div> 
				    </div>
				</div>
			</div>
		</div>
	<div class="col-md-3 wow fadeInRight">
		<div class="page-header">
    		<h1>房间信息查询</h1>
		</div>
		<form name="roomInfoQueryForm" id="roomInfoQueryForm" action="<%=basePath %>RoomInfo/frontlist" class="mar_t15" method="post">
            <div class="form-group">
            	<label for="buildingObj_buildingId">所在宿舍：</label>
                <select id="buildingObj_buildingId" name="buildingObj.buildingId" class="form-control">
                	<option value="0">不限制</option>
	 				<%
	 				for(BuildingInfo buildingInfoTemp:buildingInfoList) {
	 					String selected = "";
 					if(buildingObj!=null && buildingObj.getBuildingId()!=null && buildingObj.getBuildingId().intValue()==buildingInfoTemp.getBuildingId().intValue())
 						selected = "selected";
	 				%>
 				 <option value="<%=buildingInfoTemp.getBuildingId() %>" <%=selected %>><%=buildingInfoTemp.getBuildingName() %></option>
	 				<%
	 				}
	 				%>
 			</select>
            </div>
			<div class="form-group">
				<label for="roomName">房间名称:</label>
				<input type="text" id="roomName" name="roomName" value="<%=roomName %>" class="form-control" placeholder="请输入房间名称">
			</div>






			<div class="form-group">
				<label for="roomTypeName">房间类型:</label>
				<input type="text" id="roomTypeName" name="roomTypeName" value="<%=roomTypeName %>" class="form-control" placeholder="请输入房间类型">
			</div>






            <input type=hidden name=currentPage value="<%=currentPage %>" />
            <button type="submit" class="btn btn-primary">查询</button>
        </form>
	</div>

		</div>
	</div> 
<div id="roomInfoEditDialog" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title"><i class="fa fa-edit"></i>&nbsp;房间信息信息编辑</h4>
      </div>
      <div class="modal-body" style="height:450px; overflow: scroll;">
      	<form class="form-horizontal" name="roomInfoEditForm" id="roomInfoEditForm" enctype="multipart/form-data" method="post"  class="mar_t15">
		  <div class="form-group">
			 <label for="roomInfo_roomId_edit" class="col-md-3 text-right">记录编号:</label>
			 <div class="col-md-9"> 
			 	<input type="text" id="roomInfo_roomId_edit" name="roomInfo.roomId" class="form-control" placeholder="请输入记录编号" readOnly>
			 </div>
		  </div> 
		  <div class="form-group">
		  	 <label for="roomInfo_buildingObj_buildingId_edit" class="col-md-3 text-right">所在宿舍:</label>
		  	 <div class="col-md-9">
			    <select id="roomInfo_buildingObj_buildingId_edit" name="roomInfo.buildingObj.buildingId" class="form-control">
			    </select>
		  	 </div>
		  </div>
		  <div class="form-group">
		  	 <label for="roomInfo_roomName_edit" class="col-md-3 text-right">房间名称:</label>
		  	 <div class="col-md-9">
			    <input type="text" id="roomInfo_roomName_edit" name="roomInfo.roomName" class="form-control" placeholder="请输入房间名称">
			 </div>
		  </div>
		  <div class="form-group">
		  	 <label for="roomInfo_roomTypeName_edit" class="col-md-3 text-right">房间类型:</label>
		  	 <div class="col-md-9">
			    <input type="text" id="roomInfo_roomTypeName_edit" name="roomInfo.roomTypeName" class="form-control" placeholder="请输入房间类型">
			 </div>
		  </div>
		  <div class="form-group">
		  	 <label for="roomInfo_roomPrice_edit" class="col-md-3 text-right">房间价格(元/月):</label>
		  	 <div class="col-md-9">
			    <input type="text" id="roomInfo_roomPrice_edit" name="roomInfo.roomPrice" class="form-control" placeholder="请输入房间价格(元/月)">
			 </div>
		  </div>
		  <div class="form-group">
		  	 <label for="roomInfo_totalBedNumber_edit" class="col-md-3 text-right">总床位:</label>
		  	 <div class="col-md-9">
			    <input type="text" id="roomInfo_totalBedNumber_edit" name="roomInfo.totalBedNumber" class="form-control" placeholder="请输入总床位">
			 </div>
		  </div>
		  <div class="form-group">
		  	 <label for="roomInfo_leftBedNum_edit" class="col-md-3 text-right">剩余床位:</label>
		  	 <div class="col-md-9">
			    <input type="text" id="roomInfo_leftBedNum_edit" name="roomInfo.leftBedNum" class="form-control" placeholder="请输入剩余床位">
			 </div>
		  </div>
		  <div class="form-group">
		  	 <label for="roomInfo_roomTelephone_edit" class="col-md-3 text-right">寝室电话:</label>
		  	 <div class="col-md-9">
			    <input type="text" id="roomInfo_roomTelephone_edit" name="roomInfo.roomTelephone" class="form-control" placeholder="请输入寝室电话">
			 </div>
		  </div>
		  <div class="form-group">
		  	 <label for="roomInfo_roomMemo_edit" class="col-md-3 text-right">附加信息:</label>
		  	 <div class="col-md-9">
			    <input type="text" id="roomInfo_roomMemo_edit" name="roomInfo.roomMemo" class="form-control" placeholder="请输入附加信息">
			 </div>
		  </div>
		</form> 
	    <style>#roomInfoEditForm .form-group {margin-bottom:5px;}  </style>
      </div>
      <div class="modal-footer"> 
      	<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
      	<button type="button" class="btn btn-primary" onclick="ajaxRoomInfoModify();">提交</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->
<jsp:include page="../footer.jsp"></jsp:include> 
<script src="<%=basePath %>plugins/jquery.min.js"></script>
<script src="<%=basePath %>plugins/bootstrap.js"></script>
<script src="<%=basePath %>plugins/wow.min.js"></script>
<script src="<%=basePath %>plugins/bootstrap-datetimepicker.min.js"></script>
<script src="<%=basePath %>plugins/locales/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="<%=basePath %>js/jsdate.js"></script>
<script>
var basePath = "<%=basePath%>";
/*跳转到查询结果的某页*/
function GoToPage(currentPage,totalPage) {
    if(currentPage==0) return;
    if(currentPage>totalPage) return;
    document.roomInfoQueryForm.currentPage.value = currentPage;
    document.roomInfoQueryForm.submit();
}

/*可以直接跳转到某页*/
function changepage(totalPage)
{
    var pageValue=document.roomInfoQueryForm.pageValue.value;
    if(pageValue>totalPage) {
        alert('你输入的页码超出了总页数!');
        return ;
    }
    document.roomInfoQueryForm.currentPage.value = pageValue;
    documentroomInfoQueryForm.submit();
}

/*弹出修改房间信息界面并初始化数据*/
function roomInfoEdit(roomId) {
	$.ajax({
		url :  basePath + "RoomInfo/" + roomId + "/update",
		type : "get",
		dataType: "json",
		success : function (roomInfo, response, status) {
			if (roomInfo) {
				$("#roomInfo_roomId_edit").val(roomInfo.roomId);
				$.ajax({
					url: basePath + "BuildingInfo/listAll",
					type: "get",
					success: function(buildingInfos,response,status) { 
						$("#roomInfo_buildingObj_buildingId_edit").empty();
						var html="";
		        		$(buildingInfos).each(function(i,buildingInfo){
		        			html += "<option value='" + buildingInfo.buildingId + "'>" + buildingInfo.buildingName + "</option>";
		        		});
		        		$("#roomInfo_buildingObj_buildingId_edit").html(html);
		        		$("#roomInfo_buildingObj_buildingId_edit").val(roomInfo.buildingObjPri);
					}
				});
				$("#roomInfo_roomName_edit").val(roomInfo.roomName);
				$("#roomInfo_roomTypeName_edit").val(roomInfo.roomTypeName);
				$("#roomInfo_roomPrice_edit").val(roomInfo.roomPrice);
				$("#roomInfo_totalBedNumber_edit").val(roomInfo.totalBedNumber);
				$("#roomInfo_leftBedNum_edit").val(roomInfo.leftBedNum);
				$("#roomInfo_roomTelephone_edit").val(roomInfo.roomTelephone);
				$("#roomInfo_roomMemo_edit").val(roomInfo.roomMemo);
				$('#roomInfoEditDialog').modal('show');
			} else {
				alert("获取信息失败！");
			}
		}
	});
}

/*删除房间信息信息*/
function roomInfoDelete(roomId) {
	if(confirm("确认删除这个记录")) {
		$.ajax({
			type : "POST",
			url : basePath + "RoomInfo/deletes",
			data : {
				roomIds : roomId,
			},
			success : function (obj) {
				if (obj.success) {
					alert("删除成功");
					$("#roomInfoQueryForm").submit();
					//location.href= basePath + "RoomInfo/frontlist";
				}
				else 
					alert(obj.message);
			},
		});
	}
}

/*ajax方式提交房间信息信息表单给服务器端修改*/
function ajaxRoomInfoModify() {
	$.ajax({
		url :  basePath + "RoomInfo/" + $("#roomInfo_roomId_edit").val() + "/update",
		type : "post",
		dataType: "json",
		data: new FormData($("#roomInfoEditForm")[0]),
		success : function (obj, response, status) {
            if(obj.success){
                alert("信息修改成功！");
                $("#roomInfoQueryForm").submit();
            }else{
                alert(obj.message);
            } 
		},
		processData: false,
		contentType: false,
	});
}

$(function(){
	/*小屏幕导航点击关闭菜单*/
    $('.navbar-collapse a').click(function(){
        $('.navbar-collapse').collapse('hide');
    });
    new WOW().init();

})
</script>
</body>
</html>
