<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.* " %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<!DOCTYPE html>
<html lang="en">
  <head>
	<!--移动设置优先 -->
    <meta name="viewport" content="width=device-width, initial-scale=1,user-scalable=no">

    <title>智晟磁业</title>
    <meta name="description" content="Source code generated using layoutit.com">
    <meta name="author" content="LayoutIt!">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,Chrome=1" />
	<!-- 新 Bootstrap 核心 CSS 文件 -->
	<link rel="stylesheet" href="http://cdn.bootcss.com/bootstrap/3.3.0/css/bootstrap.min.css">
	
	<!-- 可选的Bootstrap主题文件（一般不用引入） -->
	<link rel="stylesheet" href="http://cdn.bootcss.com/bootstrap/3.3.0/css/bootstrap-theme.min.css">
	
	<!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
	<script src="http://cdn.bootcss.com/jquery/1.11.1/jquery.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath }/static/js/picHandle.js"></script>
	<!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
	<script src="http://cdn.bootcss.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
      <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="http://cdn.bootcss.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="http://cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
	<style type="text/css">
	#ownClassfication li{
		margin-bottom:2.5px
	}
	</style>
	<script type="text/javascript">
	<%  
	Properties pro = new Properties();   
	 String realpath = request.getRealPath("/WEB-INF/classes");   
	 try{    
	     //读取配置文件  
	     FileInputStream in = new FileInputStream(realpath+"/program.properties");   
	     pro.load(in);   
	 }catch(FileNotFoundException e){   
	     out.println(e);   
	 }catch(IOException e){out.println(e);}   
	
	//通过key获取配置文件  
	String path = "'"+pro.getProperty("hostIpAddress")+"'";  
	%>  
	//主机IP地址
	var hostIpAddress =<%=path%>;
	$(function () {
		$('#myTab li:eq(0) a').tab('show');
		//获取头条推荐数据
		$("#hotMsg").empty();
		$("#newsMsg").empty();
		$.ajax({
	    	 type:'post',
	    	 url:'${pageContext.request.contextPath}/PreWebContentManager/getHeadlinePromoteData',
	    	 dataType : 'json',
	    	 contentType : "application/json;charset=utf-8",
	    	 success : function (data){
	    		if (data.success == "true") {
	    		
	    			//新信息
	    			if(data.newsMsgData != null){
	    				for(var i = 0; i< data.newsMsgData.length ;i++){
							var optionHtml = "<div style='padding:3px;font-size:1.1em;'><a href='javascript:void(0);' onclick='toNewsCenter(this)'>"+data.newsMsgData[i].sourceTitle+"</a></div>";
							$("#newsMsg").append(optionHtml);
						}
	    			}else{
	    				var optionHtml = "<div style='width:100px;height:50px;margin:5px 10px;padding:3px 3px 3px 15px;font-size:1.1em;line-height:1.3'>暂无数据</div>";
	    					$("#newsMsg").append(optionHtml);
	    			}
	    			//热门信息
	    			if(data.hotMsgData != null){
		    			for(var i = 0; i< data.hotMsgData.length ;i++){
							var optionHtml = "<div style='padding:3px;font-size:1.1em;'><a href='javascript:void(0);' onclick='toNewsCenter(this)'>"+data.hotMsgData[i].sourceTitle+"</a></div>";
							$("#hotMsg").append(optionHtml);
						}
	    			}else{
	    				var optionHtml = "<div style='width:100px;height:50px;margin:5px 10px;padding:3px 3px 3px 15px;font-size:1.1em;line-height:1.3'>暂无数据</div>";
	    					$("#hotMsg").append(optionHtml);
	    			}
	    			var optionHtml = "<div style='padding:3px 3px 2px 10px'>&gt;&gt;&gt;&nbsp;&nbsp;<a href='${pageContext.request.contextPath }/PreWebContentManager/Pre_NewsCentor'>查看更多</a></div>";
	    			$("#newsMsg").append(optionHtml);
					$("#hotMsg").append(optionHtml);
				} else {
					var optionHtml = "<div style='width:100px;height:50px;margin:5px 10px;padding:3px 3px 3px 15px;font-size:1.1em;line-height:1.3'>暂无数据</div>"
					$("#newsMsg").append(optionHtml);
					$("#hotMsg").append(optionHtml);
				}
	    	 }
	     });
		//页面加载时获取产品中心方形磁铁数据
		var categoryNames = $("#myTab .active").text();
		//alert(categoryNames);
		$.ajax({
	    	 type:'post',
	    	 url:'${pageContext.request.contextPath}/PreWebContentManager/getProductCentorData',
	    	 data:JSON.stringify({categoryName : categoryNames, parentModule:"产品中心"}),
	    	 dataType : 'json',
	    	 contentType : "application/json;charset=utf-8",
	    	 success : function (data){
	    		if (data.success == "true") {
	    			if(data.datas.length > 0){
		    			if(categoryNames =="方形磁铁"){
		    				$("#fxctPanel").empty();
		    				for(var i=0;i<data.datas.length;i++){
		    					var initialData = data.datas[i].image;
		    					var initialArray = initialData.split("?");
		    					var secArray = initialArray[1].split("&");
		    					var latestData = initialArray[0]+"/"+secArray[0];
		    					//alert(latestData)
				    			var optionHtml = "<div class='col-md-3'><div class='thumbnail' sourceId = '"+data.datas[i].id+"'  onclick='commodityDetail(this)' style='cursor:pointer'><img alt='方形磁铁图片' src='"+hostIpAddress+latestData+"'>"+
									"<div class='caption'><p><span class='label label-danger'>"+data.datas[i].title+"</span></p></div></div></div>";
			    				$("#fxctPanel").append(optionHtml);
		    				}
		    			}
		    			if(categoryNames =="圆形磁铁"){
		    				$("#yxctPanel").empty();
		    				for(var i=0;i<data.datas.length;i++){
		    					var initialData = data.datas[i].image;
		    					var initialArray = initialData.split("?");
		    					var secArray = initialArray[1].split("&");
		    					var latestData = initialArray[0]+"/"+secArray[0];
				    			var optionHtml = "<div class='col-md-3'><div class='thumbnail'  sourceId = '"+data.datas[i].id+"'  onclick='commodityDetail(this)' style='cursor:pointer'><img alt='圆形磁铁图片' src='"+hostIpAddress+latestData+"'>"+
									"<div class='caption'><p><span class='label label-danger'>"+data.datas[i].title+"</span></p></div></div></div>";
			    				$("#yxctPanel").append(optionHtml);
		    				}
		    			}
		    			if(categoryNames =="异形磁铁"){
		    				$("#yixingctPanel").empty();
		    				for(var i=0;i<data.datas.length;i++){
		    					var initialData = data.datas[i].image;
		    					var initialArray = initialData.split("?");
		    					var secArray = initialArray[1].split("&");
		    					var latestData = initialArray[0]+"/"+secArray[0];
				    			var optionHtml = "<div class='col-md-3'><div class='thumbnail'  sourceId = '"+data.datas[i].id+"'  onclick='commodityDetail(this)' style='cursor:pointer'><img alt='异形磁铁图片' src='"+hostIpAddress+latestData+"'>"+
									"<div class='caption'><p><span class='label label-danger'>"+data.datas[i].title+"</span></p></div></div></div>";
			    				$("#yixingctPanel").append(optionHtml);
		    				}
		    			}
		    			if(categoryNames =="功用磁铁"){
		    				$("#cxzpPanel").empty();
		    				for(var i=0;i<data.datas.length;i++){
		    					var initialData = data.datas[i].image;
		    					var initialArray = initialData.split("?");
		    					var secArray = initialArray[1].split("&");
		    					var latestData = initialArray[0]+"/"+secArray[0];
				    			var optionHtml = "<div class='col-md-3'><div class='thumbnail'  sourceId = '"+data.datas[i].id+"'  onclick='commodityDetail(this)' style='cursor:pointer'><img alt='功用磁铁' src='"+hostIpAddress+latestData+"'>"+
									"<div class='caption'><p><span class='label label-danger'>"+data.datas[i].title+"</span></p></div></div></div>";
			    				$("#cxzpPanel").append(optionHtml);
		    				}
		    			}
	    				
	    			}else{
	    				$("#fxctPanel").empty();
						$("#yxctPanel").empty();
						$("#yixingctPanel").empty();
						$("#cxzpPanel").empty();
						var htmls = "<div><h2>暂无数据</h2></div>" ;
						$("#fxctPanel").append(htmls);
						$("#yxctPanel").append(htmls);
						$("#yixingctPanel").append(htmls);
						$("#cxzpPanel").append(htmls);
	    			}
	    			
				} else {
				
				}
	    	 }
	     });
		//页面加载时获取我们的优势数据
		$.ajax({
	    	 type:'post',
	    	 url:'${pageContext.request.contextPath}/PreWebContentManager/getOurAdviceData',
	    	 dataType : 'json',
	    	 contentType : "application/json;charset=utf-8",
	    	 success : function (data){
	    		if (data.success == "true") {
	    			if(data.datas.length >0){
	    				for(var i=0;i< data.datas.length;i++){
	    					//alert(data.datas[i].picture.sourceUrl);
		    				var optionHtml = "<div class='col-md-6'><div  class='row'> <div class='col-md-6'><div class='thumbnail'>"+
										"<img alt='Bootstrap Thumbnail First' src='http://localhost:8080/"+data.datas[i].picture.sourceUrl+"'>"+
									"</div>	</div><div class='col-md-6'><div class='caption'><h3>"+data.datas[i].artical.sourceTitle+"</h3><p>"+data.datas[i].artical.sourceContent+
									"</p></div></div></div></div>";
	    					if(i>1){
	    						$("#ourAdviceOne").append(optionHtml);
	    					}else{
	    						$("#ourAdviceTwo").append(optionHtml);
	    					}
	    				}
	    			}
				} else {
					var optionHtml = "<div style='width:100px;height:50px;margin:5px 10px;padding:3px 3px 3px 15px;font-size:1.1em;line-height:1.3'>暂无数据</div>"
					$("#ourAdviceOne").append(optionHtml);
					$("#ourAdviceTwo").append(optionHtml);
				}
	    	 }
	     });
	});
	function toNewsCenter(obj){
		alert($(obj).html())
		//$(obj).html();
	}
	function productGetData(obj){
		var categoryNames = $(obj).text();
		$.ajax({
	    	 type:'post',
	    	 url:'${pageContext.request.contextPath}/PreWebContentManager/getProductCentorData',
	    	 data:JSON.stringify({categoryName : categoryNames, parentModule:"产品中心"}),
	    	 dataType : 'json',
	    	 contentType : "application/json;charset=utf-8",
	    	 success : function (data){
	    		if (data.success == "true") {
	    			if(data.datas.length > 0){
	    				if(categoryNames =="方形磁铁"){
		    				$("#fxctPanel").empty();
		    				for(var i=0;i<data.datas.length;i++){
		    					var initialData = data.datas[i].image;
		    					var initialArray = initialData.split("?");
		    					var secArray = initialArray[1].split("&");
		    					var latestData = initialArray[0]+"/"+secArray[0];
		    					//alert(latestData)
				    			var optionHtml = "<div class='col-md-3'><div class='thumbnail'  sourceId = '"+data.datas[i].id+"'  onclick='commodityDetail(this)' style='cursor:pointer'><img alt='方形磁铁图片' src='"+hostIpAddress+latestData+"'>"+
									"<div class='caption'><p><span class='label label-danger'>"+data.datas[i].title+"</span></p></div></div></div>";
			    				$("#fxctPanel").append(optionHtml);
		    				}
		    			}
		    			if(categoryNames =="圆形磁铁"){
		    				$("#yxctPanel").empty();
		    				for(var i=0;i<data.datas.length;i++){
		    					var initialData = data.datas[i].image;
		    					var initialArray = initialData.split("?");
		    					var secArray = initialArray[1].split("&");
		    					var latestData = initialArray[0]+"/"+secArray[0];
				    			var optionHtml = "<div class='col-md-3'><div class='thumbnail'  sourceId = '"+data.datas[i].id+"'  onclick='commodityDetail(this)' style='cursor:pointer'><img alt='圆形磁铁图片' src='"+hostIpAddress+latestData+"'>"+
									"<div class='caption'><p><span class='label label-danger'>"+data.datas[i].title+"</span></p></div></div></div>";
			    				$("#yxctPanel").append(optionHtml);
		    				}
		    			}
		    			if(categoryNames =="异形磁铁"){
		    				$("#yixingctPanel").empty();
		    				for(var i=0;i<data.datas.length;i++){
		    					var initialData = data.datas[i].image;
		    					var initialArray = initialData.split("?");
		    					var secArray = initialArray[1].split("&");
		    					var latestData = initialArray[0]+"/"+secArray[0];
				    			var optionHtml = "<div class='col-md-3'><div class='thumbnail'  sourceId = '"+data.datas[i].id+"'  onclick='commodityDetail(this)' style='cursor:pointer'><img alt='异形磁铁图片' src='"+hostIpAddress+latestData+"'>"+
									"<div class='caption'><p><span class='label label-danger'>"+data.datas[i].title+"</span></p></div></div></div>";
			    				$("#yixingctPanel").append(optionHtml);
		    				}
		    			}
		    			if(categoryNames =="功用磁铁"){
		    				$("#cxzpPanel").empty();
		    				for(var i=0;i<data.datas.length;i++){
		    					var initialData = data.datas[i].image;
		    					var initialArray = initialData.split("?");
		    					var secArray = initialArray[1].split("&");
		    					var latestData = initialArray[0]+"/"+secArray[0];
				    			var optionHtml = "<div class='col-md-3'><div class='thumbnail'  sourceId = '"+data.datas[i].id+"'  onclick='commodityDetail(this)' style='cursor:pointer'><img alt='功用磁铁' src='"+hostIpAddress+latestData+"'>"+
									"<div class='caption'><p><span class='label label-danger'>"+data.datas[i].title+"</span></p></div></div></div>";
			    				$("#cxzpPanel").append(optionHtml);
		    				}
		    			}
	    				
	    			}else{
	    				$("#fxctPanel").empty();
						$("#yxctPanel").empty();
						$("#yixingctPanel").empty();
						$("#cxzpPanel").empty();
						var htmls = "<div><h2>暂无数据</h2></div>" ;
						$("#fxctPanel").append(htmls);
						$("#yxctPanel").append(htmls);
						$("#yixingctPanel").append(htmls);
						$("#cxzpPanel").append(htmls);
	    			}
	    			
				} else {
				
				}
	    	 }
	     });
	}
	function commodityDetail(obj){
		$("#alertPanel").remove();//必需移除要不会出现异常
		//根据ID查找资源
		var dataVo = {id:$(obj).attr("sourceId")};
		$.ajax({
	    	 type:'post',
	    	 url:'${pageContext.request.contextPath}/PreWebContentManager/getCommodityDetailByID',
	    	 data:JSON.stringify(dataVo),
	    	 dataType : 'json',
	    	 contentType : "application/json;charset=utf-8",
	    	 success : function (data){
	    		 if(data.success == "true"){
	    			 var initialArray = data.commodityMain.image.split("?");
 					var secArray = initialArray[1].split("&");
 					//var latestData = initialArray[0]+"/"+secArray[0];
 					var picArr = [];
 					for(var j=0;j<secArray.length-1;j++){
 						picArr[j] = hostIpAddress + initialArray[0]+"/"+secArray[j];
 					}
		    		 var windowPanel = "<div id='alertPanel' style='background:white;width:100%;height:100%;z-index:999;position:fixed;top:0;left:0;overflow:auto;'>"+
			    			"<p><button class='btn' style='float:right;margin:10px 30px 20px 10px' onclick='closedWindowPanel(this)'>关闭</button></p>"+
			    			"<br/><br/><br/><br/><br/>"+
			    			"<div class='row'>"+
			    				"<div class='col-md-2'></div>"+
			    				"<div class='col-md-8'>"+
			    					"<div class='row' height:500px'>"+
			    						"<div class='col-md-6' id='picsShowPanels' >"+
			    						"</div>"+
			    						"<div class='col-md-6'  id='basicInfos'></div>"+
			    					"</div><br/><br/><hr/>"+
			    					"<div class='row'  id='specification'>"+
			    					"<h3>规格参数</h3><br/></div><br/><br/><hr/>"+
			    					"<div class='row'  id='commodityDesc'>"+
			    					"<h3>产品详情</h3><br/></div>"+
			    				"</div>"+
			    				"<div class='col-md-2'></div>"+
			    			"</div>"+
			    		"</div>";
		    		 $(document.body).append(windowPanel);
		    		 //调用方法，显示图片
		    		 picDisplayCommodity(picArr,$("#picsShowPanels"));
		    		 //显示产品基本信息
		    		 $("#basicInfos").empty();
				    var basicInfo = "<table class='table'>"+
				    		  "<thead>"+
				    		    "<tr>"+
				    		      "<th>"+data.commodityMain.title+"</th>"+
				    		    "</tr>"+
				    		  "</thead>"+
				    		  "<tbody>"+
				    		   "<tr>"+
				    		      "<td>卖点:&nbsp;&nbsp;"+data.commodityMain.sellPoint+"</td>"+
				    		    "</tr>"+
				    		    "<tr>"+
				    		   	   "<td>价格:&nbsp;&nbsp;"+data.commodityMain.price+"&nbsp;<b style='color:red'>元</b></td>"+
				    		    "</tr>"+
				    		    "<tr>"+
				    		   	   "<td>数量:&nbsp;&nbsp;"+data.commodityMain.num+"</td>"+
				    		    "</tr>"+
				    		    "<tr>"+
				    		   	   "<td>可作用途:&nbsp;&nbsp;"+data.commodityMain.usedType+"</td>"+
				    		    "</tr>"+
				    		    "<tr>"+
				    		   	   "<td>所属分类:&nbsp;&nbsp;"+data.commodityMain.categoryName+"</td>"+
				    		    "</tr>"+
				    		  "</tbody>"+
				    		"</table>";
				    	$("#basicInfos").append(basicInfo);
				    	var specificationHtml = "";
				    	for(var k=0;k< data.commoditySpec.length;k++){
				    		var kk = "<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+data.commoditySpec[k].specificationName+"：</span>"+
			    		      "<span style='margin-right:90px'>&nbsp;&nbsp;"+data.commoditySpec[k].specificationContent+"</span>";
				    		specificationHtml += kk;
				    	} 
				    	$("#specification").append(specificationHtml);
				    	$("#commodityDesc").append(data.commodityDesc.content);
	    		 }else{
	    			 var windowPanel = "<div style='background:white;width:100%;height:100%;z-index:999;position:fixed;top:0;left:0;overflow:auto;'>"+
		    			"<p><button class='btn' style='float:right;margin:10px 30px 20px 10px' onclick='closedWindowPanel(this)'>关闭</button></p>"+
		    			"<br/><br/><br/><br/><br/><h1 style='padding:10% 15% 15% 32%'>获取产品失败，请联系管理员</h1>"+
		    		"</div>";
	    			 $(document.body).append(windowPanel);
	    		 }
	    	 }
		})
	    
	}
	function closedWindowPanel(target){
		$("#mask").hide();
		$(target).parent().parent().hide();
	}
	function contactUs(){
		/* $("#mask").show();
		var optionHtml = "<div style='padding:10px;height:300px;width:500px;position:absolute;top:200px;left:30%;z-index:9999;background-color:white'><p><button class='btn' style='float:right;margin:10px 30px 20px 10px' onclick='closedWindowPanel(this)'>关闭</button></p>"+
		"<h2 style='margin-left:90px'>微信扫码，联系我们</h2><br/><img src='${pageContext.request.contextPath }/static/image/zm_logo.png'/></div>";
		$(document.body).append(optionHtml); */
	}
	</script>
<style type="text/css">
#mask{
	width: 100%;
	height: 200%;
	position: absolute;
	background-color: #000;
	left: 0;
	opacity:0.5;
	top: 0;
	z-index: 2;
}
</style>
  </head>
  <body>

    <div class="container-fluid">
			<div class="row">
				<div class="col-md-12" style="height:5px;background-color:#0066cc">
				</div>
			</div>
		<nav class="navbar navbar-default">
				<div class="row">
					<div class="col-md-2"></div>
					<div class="col-md-8 col-xs-12">
						<!-- logo -->
						<div class="navbar-header" style="margin-top:10px"> 
							<img alt="logo Preview" src="${pageContext.request.contextPath }/static/image/zm_logo.png" width="90%" height="90%"  class="img-responsive">
						</div>
						<div class="collapse  navbar-collapse " style="margin-top:23px;margin-left:10px">
								<ul class="nav nav-pills">
								  <li class="active"><a href="#">首页</a></li>
								  <li><a href="${pageContext.request.contextPath }/productVideo/toProductJsp">生产视频</a></li>
								 <!--  <li><a href="#">强力磁铁</a></li> -->
								  <li><a href="${pageContext.request.contextPath }/MagnetClassification/getList">磁性制品</a></li>
								  <li><a href="${pageContext.request.contextPath }/PreWebContentManager/Pre_buyPrice">采购报价</a></li>
								  <li><a href="${pageContext.request.contextPath }/MessageInfo/newsCentor">新闻中心</a></li>
								  <li><a href="${pageContext.request.contextPath }/MessageInfo/aboutUs">关于我们</a></li>
								</ul>
						</div>
							
					</div>
					<div class="col-md-2"></div>
				</div>	
			<div class="row">
				<div class="col-md-12">
					<img alt="Image Preview" src="${pageContext.request.contextPath }/static/image/zs_bigImg.png" width="100%" height="100%">
						<div style="position:absolute;top:250px;left:46%"><span class="btn" onclick="contactUs();" style="color:white;border:3px solid white;border-radius:12px;font-size:18px;padding:6px 26px;"><a style="color:white;" href="tencent://message/?uin=969112711">立即咨询</a></span>
						</div>
				</div>
			</div>
	</nav>
	
	<div class="row">
		<div class="col-md-2">
		</div>
		<div class="col-md-8">
				<h3>磁铁分类</h3>
					<div class="row" style="margin-top:-10px;padding-left:15px">
						<div class="pull-left" style="width:12%">
							<h5>Classification</h5>
						</div>
						<div  class="pull-left"  style="width:88%">
							<hr style="height:3px;border:none;border-top:1px solid #555555"/>
						</div>
					</div>
			<div class="row">
				<div class="col-md-3">
					<div class="thumbnail">
						<img alt="圆形磁铁图片" src="${pageContext.request.contextPath }/static/image/zs_ctfl_yxImg.png">
						<div class="caption">
							<p><span class="label label-danger">圆形磁铁分类</span></p>
							<p><a href="${pageContext.request.contextPath }/PreWebContentManager/Pre_magnetClassification?cate='圆片磁铁'">圆片磁铁</a></p>
							<p><a href="${pageContext.request.contextPath }/PreWebContentManager/Pre_magnetClassification?cate='圆环磁铁'">圆环磁铁</a></p>
							<p><a href="${pageContext.request.contextPath }/PreWebContentManager/Pre_magnetClassification?cate='圆柱磁铁'">圆柱磁铁</a></p>
							<p><a href="${pageContext.request.contextPath }/PreWebContentManager/Pre_magnetClassification?cate='圆形沉头孔磁铁'">圆形沉头孔磁铁</a></p>
						</div>
					</div>
				</div>
				<div class="col-md-3">
					<div class="thumbnail">
						<img alt="圆形磁铁图片" src="${pageContext.request.contextPath }/static/image/zs_ctfl_fxImg.png">
						<div class="caption">
							<p><span class="label label-danger">方形磁铁分类</span></p>
							<p><a href="${pageContext.request.contextPath }/PreWebContentManager/Pre_magnetClassification?cate='方形磁铁'">方形磁铁</a></p>
							<p><a href="${pageContext.request.contextPath }/PreWebContentManager/Pre_magnetClassification?cate='长方形磁铁'">长方形磁铁</a></p>
							<p><a href="${pageContext.request.contextPath }/PreWebContentManager/Pre_magnetClassification?cate='方形沉头孔磁铁'">方形沉头孔磁铁</a></p>
							<p><a href="${pageContext.request.contextPath }/PreWebContentManager/Pre_magnetClassification?cate='other'" style="visibility:hidden">other</a></p>
						</div>
					</div>
				</div>
				<div class="col-md-3">
					<div class="thumbnail">
						<img alt="圆形磁铁图片" src="${pageContext.request.contextPath }/static/image/zs_ctfl_yixImg.png">
						<div class="caption">
							<p><span class="label label-danger">异形磁铁分类</span></p>
							<p><a href="${pageContext.request.contextPath }/PreWebContentManager/Pre_magnetClassification?cate='异型磁铁'">异形磁铁</a></p>
							<p><a href="${pageContext.request.contextPath }/PreWebContentManager/Pre_magnetClassification?cate='梯形磁铁'">梯形磁铁</a></p>
							<p><a href="${pageContext.request.contextPath }/PreWebContentManager/Pre_magnetClassification?cate='瓦形磁铁'">瓦形磁铁</a></p>
							<p><a href="${pageContext.request.contextPath }/PreWebContentManager/Pre_magnetClassification?cate='大小头磁铁'">大小头磁铁</a></p>
						</div>
					</div>
				</div>
				<div class="col-md-3">
					<div class="thumbnail">
						<img alt="圆形磁铁图片" src="${pageContext.request.contextPath }/static/image/zs_ctfl_other.png">
						<div class="caption">
							<p><span class="label label-danger">按用途分类</span></p>
							<ul class="list-inline" id="ownClassfication">
							  <li><a href="${pageContext.request.contextPath }/PreWebContentManager/Pre_magnetClassification?cate='五金类'"  class="label label-primary">五金类</a></li>
							  <li><a href="${pageContext.request.contextPath }/PreWebContentManager/Pre_magnetClassification?cate='电机类'"  class="label label-primary">电机类</a></li>
							  <li><a href="${pageContext.request.contextPath }/PreWebContentManager/Pre_magnetClassification?cate='皮套类'"  class="label label-primary">皮套类</a></li>
							  <li><a href="${pageContext.request.contextPath }/PreWebContentManager/Pre_magnetClassification?cate='喇叭磁铁'"  class="label label-primary">喇叭磁铁</a></li>
							   <li><a href="${pageContext.request.contextPath }/PreWebContentManager/Pre_magnetClassification?cate='玩具类'"  class="label label-primary">玩具类</a></li>
							  <li><a href="${pageContext.request.contextPath }/PreWebContentManager/Pre_magnetClassification?cate='真空模机类'"  class="label label-primary">真空模机类</a></li>
							  <li><a href="${pageContext.request.contextPath }/PreWebContentManager/Pre_magnetClassification?cate='LED磁铁'"  class="label label-primary">LED磁铁</a></li>
							  <li><a href="${pageContext.request.contextPath }/PreWebContentManager/Pre_magnetClassification?cate='other'" class="label label-primary">其它</a></li>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="col-md-2">
		</div>
	</div>
	<div class="row">
				<div class="col-md-2">
				</div>
				<div class="col-md-8">
					<h3>
						头条推荐
					</h3>
					<div class="row" style="margin-top:-10px;padding-left:15px">
						<div class="pull-left" style="width:15%">
							<h5>Recommendation</h5>
						</div>
						<div  class="pull-left"  style="width:85%">
							<hr style="height:3px;border:none;border-top:1px solid #555555"/>
						</div>
					</div>
					</div>
				</div>
				<div class="col-md-2">
				</div>
			</div>
	<div class="row" style="background-color:#d8d8d8;padding:30px">
		<div class="col-md-12">
			<div class="row">
				<div class="col-md-2">
					
				</div>
				<div class="col-md-8">
					<div class="row">
						<div class="col-md-6">
							<img alt="img"  src="${pageContext.request.contextPath }/static/image/zs_tttj_pic.png"  width="376px" height="273px" >
						</div>
						<div class="col-md-3">
							<p><span class="label label-danger">热门信息</span></p>
							<div id="hotMsg" style="overflow:hidden"></div>
						</div>
						<div class="col-md-3">
							<p><span class="label btn-info">最新信息</span></p>
							<div id="newsMsg" style="overflow:hidden"></div>
						</div>
					</div>
				</div>
				<div class="col-md-2">
					
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-md-2">
		</div>
		<div class="col-md-8">
			<h3>
				产品中心
			</h3>
			<div class="row" style="margin-top:-10px">
				<div class="col-md-1">
					<h5>Products</h5>
				</div>
				<div class="col-md-11">
					<hr style="height:1px;border:none;border-top:1px solid #555555;"/>
				</div>
			</div>
			<ul id="myTab" class="nav nav-tabs">
			<li class="active"><a href="#fxct" onclick="productGetData(this)"  data-toggle="tab">方形磁铁</a></li>
			<li><a href="#yxct" onclick="productGetData(this)" data-toggle="tab">圆形磁铁</a></li>
			<li><a href="#yixingct" onclick="productGetData(this)"  data-toggle="tab">异形磁铁</a></li>
			<li><a href="#cxzp" onclick="productGetData(this)"  data-toggle="tab">功用磁铁</a></li>
			</ul>
		</div>
		<div class="col-md-2">
		</div>
	</div>
	<div id="myTabContent" class="tab-content">
		<div class="tab-pane fade in active" id="fxct">
			<div class="row">
				<div class="col-md-2">
				</div>
				<div class="col-md-8">
					<div class="row" id="fxctPanel">
						<%-- <div class="col-md-3">
							<div class="thumbnail">
								<img alt="圆形磁铁图片" src="${pageContext.request.contextPath }/static/image/zs_ctfl_yxImg.png">
								<div class="caption">
									<p><span class="label label-danger">圆形磁铁分类</span></p>
									<p><a href="#">圆片磁铁</a></p>
									<p><a href="#">圆环磁铁</a></p>
									<p><a href="#">圆柱磁铁</a></p>
									<p><a href="#">圆形沉头孔磁铁</a></p>
								</div>
							</div>
						</div> --%>
					</div>
				</div>
				<div class="col-md-2">
				</div>
			</div>
		</div>
		<div class="tab-pane fade" id="yxct">
			<div class="row">
				<div class="col-md-2">
				</div>
				<div class="col-md-8">
					<div class="row" id="yxctPanel">
<!-- 					<p>圆形磁铁</p> -->
					</div>
				</div>
				<div class="col-md-2">
				</div>
			</div>
		</div>
		<div class="tab-pane fade" id="yixingct">
			<div class="row">
				<div class="col-md-2">
				</div>
				<div class="col-md-8">
					<div class="row" id="yixingctPanel">
					<!-- <p>异型磁铁</p> -->
					</div>
				</div>
				<div class="col-md-2">
				</div>
			</div>
		</div>
		<div class="tab-pane fade" id="cxzp">
			<div class="row">
				<div class="col-md-2">
				</div>
				<div class="col-md-8">
					<div class="row" id="cxzpPanel">
					<!-- <p>磁性制品</p> -->
					</div>
				</div>
				<div class="col-md-2">
				</div>
			</div>
		</div>
	</div>
	<div class="row"  style="background-color:#d8d8d8;padding:15px 0px">
		<div class="col-md-12">
			<div class="row">
				<div class="col-md-2">
				</div>
				<div class="col-md-8">
					<h3>
						我们的优势
					</h3>
					<div class="row" style="margin-top:-10px">
						<div class="col-md-1">
							<h5>Advantage</h5>
						</div>
						<div class="col-md-11">
							<hr style="height:1px;border:none;border-top:1px solid #555555;"/>
						</div>
					</div>
					<div class="row" id="ourAdviceOne">
						<!-- <div class="col-md-6">
							
								<div  class="row">
									<div class="col-md-6">
										<div class="thumbnail">
											<img alt="Bootstrap Thumbnail First" src="http://lorempixel.com/output/people-q-c-600-200-1.jpg">
										</div>
									</div>
									<div class="col-md-6">
										<div class="caption">
											<h3>
												Thumbnail label
											</h3>
											<p>
												Cras justo odio, dapibus ac facilisis in, egestas eget quam. Donec id elit non mi porta gravida at eget metus. Nullam id dolor id nibh ultricies vehicula ut id elit.
											</p>
										</div>
									</div>
								</div>
						</div>
						<div class="col-md-6">
							
								<div  class="row">
									<div class="col-md-6">
										<div class="thumbnail">
											<img alt="Bootstrap Thumbnail First" src="http://lorempixel.com/output/people-q-c-600-200-1.jpg">
										</div>
									</div>
									<div class="col-md-6">
										<div class="caption">
											<h3>
												Thumbnail label
											</h3>
											<p>
												Cras justo odio, dapibus ac facilisis in, egestas eget quam. Donec id elit non mi porta gravida at eget metus. Nullam id dolor id nibh ultricies vehicula ut id elit.
											</p>
										</div>
									</div>
								</div>
						</div> -->
					</div>
					<div class="row" id="ourAdviceTwo">
					</div>
				</div>
				<div class="col-md-2">
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-md-12" style="background-color:#302d27;color:white;padding:30px 20px">
			<div class="row">
				<div class="col-md-2">
				</div>
				<div class="col-md-8">
					<div class="row">
						<div class="col-md-8">
							<div class="row">
								<div class="col-md-7">
									<h3>网站地图</h3>
									<ol class="list-unstyled" style="color:white;font-size:13px;margin-top:20px">
										<li style="margin-bottom:10px">
											<a href="#">网站首页</a>
										</li>
										<li style="margin-bottom:10px">
											<a href="${pageContext.request.contextPath }/MessageInfo/aboutUs">关于我们</a>
										</li>
										<li style="margin-bottom:10px">
											专家顾问
										</li>
										<li style="margin-bottom:10px">
											政策解读
										</li>
										<li style="margin-bottom:10px">
											加入我们
										</li>
									</ol>
								</div>
								<div class="col-md-5">
									<h3>联系我们</h3>
									<ol class="list-unstyled" style="color:white;font-size:15px;margin-top:20px">
										<li style="margin-bottom:10px">
											电话: 0516-83898529
										</li>
										<li style="margin-bottom:10px">
											传真: 0516-83898529
										</li>
										<li style="margin-bottom:10px">
											Email: HR@86516.com
										</li>
										<li style="margin-bottom:10px">
											网址: http://www.###.com
										</li>
										<li style="margin-bottom:10px">
											地址: 徐州市泉山区黄河南路
										</li>
									</ol>
								</div>
							</div>
						</div>
						<div class="col-md-4">
						</div>
					</div>
				</div>
				<div class="col-md-2">
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-md-12" style="background-color:#26231c;color:white;">
			<div class="row">
				<div class="col-md-2">
				</div>
				<div class="col-md-8">
					<br/>
					<span style="margin-right:280px"></span>
					徐州智晟磁业科技有限公司&nbsp;&nbsp;&copy;copyright&nbsp;版权所有&nbsp;&nbsp;ICP证:alw
					<br/><br/>
				</div>
				<div class="col-md-2">
				</div>
			</div>
		</div>
	</div>
  <div id="mask" style="display:none"></div>
  </body>
</html>