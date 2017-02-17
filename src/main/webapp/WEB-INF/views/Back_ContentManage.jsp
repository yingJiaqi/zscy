<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>zmcy</title>
<!-- 导入jquery核心类库 -->
<script type="text/javascript" src="${pageContext.request.contextPath }/static/js/jquery-1.8.3.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath }/static/js/json2.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath }/static/js/utils.js"></script>
<!-- 导入easyui类库 -->
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/static/js/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/static/js/easyui/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/static/js/easyui/ext/portal.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/static/css/default.css">
<script type="text/javascript" src="${pageContext.request.contextPath }/static/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath }/static/js/easyui/ext/jquery.portal.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath }/static/js/easyui/ext/jquery.cookie.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath }/static/js/easyui/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/datajs/WdatePicker.js"></script>
<link rel="stylesheet" type="text/css" 	href="${pageContext.request.contextPath }/static/js/uploadify/uploadify.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/uploadify/jquery.uploadify.min.js"></script>  
<script type="text/javascript">
/* 用于保存之前的节点 */
var preNode = null;
//用于存放关联文件的id,在删除关联时使用
var docIds = new Array();


/* 资源列表初始化加载 列配置*/
var columns = [
		[{
			field : 'index',
			checkbox : true,
		},{
			field: 'id',
			title: 'ID',
			width: 150,
			align: 'left',
		}, {
			field: 'sourceType',
			title: '资源类型',
			width: 80,
			align: 'center',
		}, {
			field: 'sourceTitle',
			title: '资源标题',
			width: 260,
			align: 'center',
		}, {
			field: 'createTime',
			title: '创建时间',
			width: 132,
			align: 'center'
		}, {
			field: 'updateTime',
			title: '更新时间',
			width: 132,
			align: 'center'
		}, {
			field: 'status',
			title: '操作',
			width: 100,
			align: 'center',
			formatter: function(data, row, index) {
				if(data == 1) {
					var opHtml_recovery = "<a href=\"javascript:void(0);\"  style=\"text-decoration:none;font-size:12px;height:100%;width:50%;color:green\"><b>已关联</b></a>"+
					"<a href=\"javascript:void(0);\" onclick=\"edit('" + row.id + "'," +index +
					")\" class=\"easyui-linkbutton\"  plain=\"true\" style=\"text-decoration:none;font-size:12px;height:100%;width:50%\"><b>更新</b></a>"
					return opHtml_recovery;
				} else if(data ==2){
					var opHtml = "<a href=\"javascript:void(0);\" onclick=\"edit('" + row.id + "'," +index +
						")\" class=\"easyui-linkbutton\"  plain=\"true\" style=\"text-decoration:none;font-size:12px;height:100%;width:50%\"><b>更新</b></a>" +
						"&nbsp;&nbsp;&nbsp;&nbsp;<a href=\"javascript:void(0);\" onclick=\"deleteIndexFrequency('" +
						row.id +
						"'," +
						index +
						")\" class=\"easyui-linkbutton deleteNewsNotic\" plain=\"true\"  style=\"text-decoration:none;font-size:13px;height:100%;width:50%\"><b>删除</b></a>";
					return opHtml;
				}
			},
		}]
	];
	$(function() {
		// 先将body隐藏，再显示，不会出现页面刷新效果
		$("body").css({
			visibility: "visible"
		});
		/* 左侧菜单前台模块数据初始化加载 */
		$('#tree').tree({
	          url:'${pageContext.request.contextPath }/webContentManager/getModuleList',
	          animate:true,
	          onClick:function(node){
	        	  //获取该节点所有父节点
        		  var parentAll = node.text;
        		  var flag = ">>";
        		  parentAll = flag.concat(parentAll);
   	        	  var parent = $('#tree').tree('getParent', node.target);
   	        	  if(parent != null  && parentOne != ''){
   	        			parentAll = (parent.text).concat(parentAll);
   	        		  	var parentOne = $('#tree').tree('getParent', parent.target);
   	        		  	if(parentOne != null && parentOne != ''){
   	        				parentAll = flag.concat(parentAll);
   	        		  		parentAll = (parentOne.text).concat(parentAll);
   	        				var parentTwo = $('#tree').tree('getParent', parentOne.target)
   	        			 	if(parentTwo != null  && parentTwo != ''){
   	        		 			parentAll = flag.concat(parentAll);
   	        			 		parentAll = (parentTwo.text).concat(parentAll);
   	        			 	}
   	        		  	}
   	        	  }
                  $(".path").text(parentAll+"");
	        	  
	        	  var leaf = $('#tree').tree('isLeaf', node.target);
	        	  //防止重复提交
	        	  var currentNode = node.id;
	        	 
	        	  if(!leaf){
	        		  //将该节点的大于等于第二层子节点的状态改为关闭
	        		  var nodeName = node.text;
	        		  if(nodeName == '根'){
	        			  $('#tree').tree('collapseAll');
	        		  }
	        	  	$(this).tree('toggle', node.target);
	        	  	$("#sourceListButton").removeClass("commonNode").addClass("chooseNode");
	    			$("#associatedButton").removeClass("chooseNode").addClass("commonNode");
	    			$("#associatedList").css("display","none");
	    			$("#sourceList").css("display","block");
	        		 preNode = currentNode;
	        		 return;
	        	  }else{
	        		  //用于控制重复点击叶子节点
	        		  if(currentNode != preNode){
		        		  //用于控制对应关联库的显示
		        		  var dataVo = {id : node.id};
		          			 $.ajax({
		          					type : 'post',
		          					url : '${pageContext.request.contextPath}/webContentManager/getAssociatedListById',
		          					data : JSON.stringify(dataVo),
		          					dataType : 'json',
		          					contentType : "application/json; charset=utf-8",
		          					success : function(data) {
		        						if (data.success == "true") {
		        							$("#showAssociatedList").empty();
		        							if(data.pmcl != null && data.pmcl != ""){
		        								$("#showTip").css("display","none");
		        								$("#showAssociatedList").css("display","block");
			        							for(var i = 0; i< data.pmcl.length ;i++){
			        								docIds[i] = String(data.pmcl[i].id);
			        								var optionHtml = "<li title='"+data.pmcl[i].sourceTitle+"' style='width:100px;height:50px;float:left;border:1px solid green;list-style-type:none;margin:5px 10px;padding:3px 3px 3px 15px;font-size:10px;line-height:1.3;position:relative'><div style='height:50px; overflow:auto;letter-spacing:6px;'>"+data.pmcl[i].sourceTitle+"</div><a onclick='deleteAssociated("+i+");' href='javascript:void(0);' style='position:absolute;top:0px;left:0px;text-decoration:none;font-size:1.2em'><b>删</b></a>"+
			        								"<span style='position:absolute;top:-10px;left:90px;background-color:#7F99BE;padding:2px;font-size:0.9em'>"+data.pmcl[i].sourceType+"</span></li>"
			        								$("#showAssociatedList").append(optionHtml);
			        							}
		        							}else{
		        								$("#showTip").css("display","block");
		        								$("#showAssociatedList").empty();
		        							}
		        						} else {
		        							$.messager.alert('更新失败',data.msg,"error");
		        						}
		        					}
		          				});
		          			$("#associatedButton").removeClass("commonNode").addClass("chooseNode");
		        			$("#sourceListButton").removeClass("chooseNode").addClass("commonNode");
		        			$("#sourceList").css("display","none");
		        			$("#associatedList").css("display","block");
	        		  }
	        		  preNode = currentNode;
	        		  return;
	        	  }
	          } 
	        });
		/* 资源列表   添加资源窗口参数配置*/
		$("#addWindow").window({
			width: 390,
			height: 280,
			modal: true
		});
		/* 资源列表   添加资源窗口关闭前执行*/
		 $("#addWindow").window({
		       onBeforeClose:function(){
		    	   $("#chooseType").css("display","block");
		    	   if($("#addVideo").css("display") == "block"){
		    		   $("#addVideo").css("display","none");
		    	   }
		    	   if($("#addArtical").css("display") == "block"){
		    		   $("#addArtical").css("display","none");
		    	   }
		       }
		   });
		/* 资源列表初始化加载 */
		$('#sourceGrid').datagrid({
			fit: true,
			border: false,
			rownumbers: true,
			animate: true,
			striped: true,
			pageList: [10, 20, 50],
			pagination: true,
			url : "${pageContext.request.contextPath}/webContentManager/getDataList",
			columns : columns,
			loadMsg:'数据加载中...',
			onUncheck : function(rowIndex,rowData){
				//judgeAssociated("uncheck");
			},
			onCheck : function(rowIndex,rowData){
				//judgeAssociated("check");
			},
			onLoadSuccess: function (data) {
	           if (data.total == 0) {
	            	$("#centerShow").css("display","none");
	            	$("#showInfo").css("display","block")
	            } else {
	            	//对应相应目录，使之勾选上
	            	$.each(data.rows, function(index, item){
	            		if(item.checked){
	            			$('#sourceGrid').datagrid('checkRow', index);
	            		}
	            	});
	            	$("#showInfo").css("display","none")
	            	$("#centerShow").css("display","block");
	            }
	            $(".datagrid-header-check").html("");
			}
		});
		/**
		*资源列表上传文件，视频，图片
		*/
		 $("#uploadify").uploadify({  
			 'swf' : "${pageContext.request.contextPath}/static/js/uploadify/uploadify.swf",
			  'uploader'  : '${pageContext.request.contextPath}/webContentManager/uploadFile',
			  'queueId' : "fileQueue",
			  'queueSizeLimit' : 100,//限制上传文件的数量
			  'auto'  : false,
			  'removeCompleted':true,
			  "removeTimeout": 0,
			  'fileSizeLimit':24307200,//上传文件大小
			  'multi'  : true,//是否允许多文件上传
			  'method'   :'post',
			  'width'     : '65',  //按钮宽度    
	          'height'    : '18',  //按钮高度  
			  'simUploadLimit': 1,//同时运行上传的进程数量
			  'buttonText': "选择数据",
			  'fileObjName' : 'uploadFile',
			  'onFallback':function(){      
	                $.messager.alert("警告","您未安装FLASH控件，无法上传图片！请安装FLASH控件后再试。");      
	            },  
	            'onUploadStart' : function(file) {
	            	//$("#uploadify").uploadify("settings", "formData", {'id' : $("#updateDocId").val(),"docTitle":choosedDocTitle() ,"docTag":choosedDocTags(),"imgNum":imgs,"isPush":isPush,"jsessionid":$("#sessionId").val()});   
	            },
	            'onQueueComplete' : function (queueData){
	            	
            		//关闭对话框
            		closeFileUploadWindow();
            		//刷新数据,带参数刷新资源列表
        			var node = $('#tree').tree('getSelected');
        			if(node != null && node != ""){
               	   		flashSourceList(node.id);
        			}
					/* //调用队列上传成功后的方法
					uploadSuccess();
					//清空缓存中后台传的错误信息
					errorMsg = "";
					//清空缓存中后台传的成功信息
					successMsg = "";
					//上传文件总数赋初值
					imgs=0; */
	            },
	            'onUploadSuccess' : function(file, data, response){
	            	/* if(data.indexOf("flag") >= 0){
	            		  uploadComplete++;
          			  }
          			  if(data.indexOf("msg") >= 0 && data.indexOf("flag") < 0){
        				  errorMsg += "错误文件名:"+file.name +",错误信息:"+ data.substring(data.indexOf("msg")+4,data.length-1)+";";
        			  } */
	            },
	            'onSelect':function(file){
	            	//每选择一个文件就会触发 
	            	//imgs++;
	            },
	           'onCancel':function(file){
	        	   //imgs--;
	           },
		 }); 
		
		//点击已关联按钮
		$("#associatedButton").click(function(){
			//var flag = myFrame.window.dataHandle();
			var node = $('#tree').tree('getSelected');
			if(node != null && node != ""){
				var leaf = $('#tree').tree('isLeaf', node.target);
				if(leaf){
					$(this).removeClass("commonNode").addClass("chooseNode");
					$("#sourceListButton").removeClass("chooseNode").addClass("commonNode");
					$("#sourceList").css("display","none");
					$("#associatedList").css("display","block");
				}else{
					$.messager.alert("警告","请先选择叶子节点","warn");
				}
			}else{
				$.messager.alert("警告","请先选择叶子节点","warn");
			}
			
			
		});
		//点击资源列表
		$("#sourceListButton").click(function(){
			 //带参数刷新资源列表
			var node = $('#tree').tree('getSelected');
			if(node != null && node != ""){
       	   		flashSourceList(node.id);
			}
			$(this).removeClass("commonNode").addClass("chooseNode");
			$("#associatedButton").removeClass("chooseNode").addClass("commonNode");
			$("#associatedList").css("display","none");
			$("#sourceList").css("display","block");
		});
	})
	/* 资源列表   判断是否修改关联 */
	function judgeAssociated(checkOrUncheck){
		alert(checkOrUncheck)
	}
	/* 资源列表   打开添加资源窗口*/
	function addData(){
		$("#addWindow").window("open");
	}
	/* 资源列表   刷新列表*/
	function flashSourceList(obj){
	 	$('#sourceGrid').datagrid({
		  queryParams: {
			  nodeID: obj
		  }  
		});
	}
	/* 资源列表   搜索*/
	function doSearch(){
		alert("search")
	}
	/* 资源列表   保存关联*/
	function doAssociated(){
		alert("saveAssociated")
	}
	/* 资源列表   改变按钮样式 */
	function changeToCommon(obj){
		$(obj).removeClass('chooseNode').addClass('commonNode');
	}
	/* 资源列表   改变按钮样式 */
	function changeToChoosed(obj){
		$(obj).removeClass('commonNode').addClass('chooseNode');
	}
	/* 资源列表   添加资源*/
	function addSource(param){
/* 		$("#chooseType").css("display","none");
		if(param == "video"){
			$("#addVideo").css("display","block");
		}else if(param == "artical"){
			$("#addArtical").css("display","block");
		} */
		$('#addWindow').window("close");
		fileUpload(param);
	}
	/* 关联列表，删除关联 */
	 function deleteAssociated(i){
    	 var docId = docIds[i];
    	 var node = $('#tree').tree('getSelected');
	     var dataVo = { sourceAssociatedID : docId, moduleID : node.id};
	     $.ajax({
	    	 type:'post',
	    	 url:'${pageContext.request.contextPath}/webContentManager/delAssociated',
	    	 data:JSON.stringify(dataVo),
	    	 dataType : 'json',
	    	 contentType : "application/json;charset=utf-8",
	    	 success : function (data){
	    		if (data.success == "true") { 
	    			$("#showAssociatedList li").remove("li[title ='"+data.sourceTitle+"']");
					$.messager.alert("成功",data.msg,'info');
					if ( $("#showAssociatedList li").length == 0 ) { 
						$("#showTip").css("display","block");
						$("#showAssociatedList").empty();
						}else{
							$("#showTip").css("display","none");
						}  
				} else {
					$.messager.alert('失败', data.msg,'error');
				}
	    	 }
	     });
     }
</script>
<style type="text/css">
.chooseNode{
	cursor:pointer;
	background-color:#7F99BE;
	border:1px solid #D3D3D3;
	padding:6px 10px;
	color:white;
	font-weight:bold;
	margin-right:30px;
}
.commonNode{
	cursor:pointer;
	background-color:#F0F0F0;
	border:1px solid #D3D3D3;
	padding:6px 10px;
	margin-right:30px;
}
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
<body class="easyui-layout" style="visibility:hidden;">
	<div style="display:none;color:red;position:absolute;top:50%;left:40%;font-size:2em" id="showInfo"><b>没有查到相关数据</b></div>
	<!-- 左侧前台页面功能显示区域   start -->
    <div data-options="region:'west',title:'前台页面模块',split:true" style="width:200px;">
		<ul id="tree" style="margin:16px"></ul>
    </div>
    <!-- 左侧前台页面功能显示区域   end -->
    
   	<!-- 右侧资源区域，包含两个部分(与前台页面关联部分，资源列表)   start -->
    <div class="easyui-layout" data-options="region:'center',title:'资源管理'" style="padding:5px;background:#eee;">
    	<div data-options="region:'north',split:true" style="height:50px;">
    		<div style="margin:5px 0px 5px 30px">
    			<br/>
    			<span id="associatedButton" class="commonNode">已关联</span>
    			<span id="sourceListButton" class="chooseNode">资源列表</span>
				<span class="commonNode" onclick="addData();" style="float:right;margin-right:20px;margin-top:-7px">添加资源</span>
			</div>
    	</div>
	    	<!-- 资源列表  start -->
			<div data-options="region:'center'"  class="easyui-layout"   id="sourceList" >
				<div data-options="region:'north',split:true" style="height:80px;">
					<br>
					<span style="font-size:12px;font-weight:bold;">&nbsp;&nbsp;&nbsp;当前节点:&nbsp;<b class="path"></b></span>
					<br><br>
					&nbsp;&nbsp;&nbsp;类型:<select name="type" id="type">
							<option selected  value="">请选择</option>
							<option value="产品">产品</option>
							<option value="视频">视频</option>
							<option value="文档">文档</option>
						</select>&nbsp;
					标题关键字:<input type="text" name="titleKey" style="width:80px;"/>
					排序:<select name="order" id="order">
							<option selected  value="">请选择</option>
							<option value="1">更新时间由早到晚</option>
							<option value="2">更新时间由晚到早</option>
						</select>&nbsp;&nbsp;&nbsp;
					<span  onclick="doSearch()" class="commonNode">搜索</span>
					<span onclick="doAssociated();" class="commonNode" style="float:right;">保存关联</span>
					<br/><br/>
				</div>
				<div data-options="region:'center'" style="padding: 6px; background: #eee;" id="centerShow">
					<table id="sourceGrid" ></table>
				</div>
			</div>
			<!-- 资源列表  end -->
			
			<!-- 关联列表  start -->
			<div  id="associatedList" style="display:none;" >
				<span style="font-size:12px;font-weight:bold;">当前节点:&nbsp;<b class="path"></b></span>
			    <div id="showTip">
			    	<br><br><br><br><br><br><br><br><br><br><br><br><br><br>
			    		<div style="text-align:center;">
			    			<font size="4" color="gray">
			    				<b>没有发现任何关联资料，<br>可以从文件库里添加关联
			    					<a onclick="toSourceList()"><input type="button" value="添加" /></a>
			    				</b>
			    			</font>
			    		</div>
			    </div>
			    <div >
			    	<ul id="showAssociatedList" style="margin:40px 10px 15px 10px"></ul>
			    </div>
			</div>
			<!-- 关联列表  end -->
    </div>
    <!-- 右侧资源区域，包含两个部分(与前台页面关联部分，资源列表)   end -->
    
    <!-- 资源添加窗口   start -->
    <div class="easyui-window" title="添加资源" id="addWindow"  closed="true" draggable="false" style="top: 100px; left: 390px">
    	<div id="chooseType" style="margin-top:100px;margin-left:110px">
	    	<span class="commonNode" onmouseover="changeToChoosed(this);" onmouseout="changeToCommon(this);" onclick="addSource('video');">添加视频</span>
	    	<span class="commonNode" onmouseover="changeToChoosed(this);" onmouseout="changeToCommon(this);" onclick="addSource('artical');">添加文档</span>
    	</div>
    	<div id="addVideo" style="display:none">添加视频</div>
    	<div id="addArtical" style="display:none">添加文档</div>
	</div>
	
	<!-- 上传开始 -->
	<div  id="fileUpload" style=" display: none; position: absolute; left: 30%; top: 20%;width:450px;border:3px solid #98999D;padding:12px;border-radius:10px;z-index:10;background-color:white">
		<br>
			<div style="min-height:200px;max-height:300px;overflow-y:scroll">
			<div style="padding:1px 0px 20px 5px">
				 <span>文件标题</span>&nbsp;&nbsp;<input style="width:280px" type="text" id="sourceTitle_FileUpload"/><br/><br/>
				 <span>文件类型</span>&nbsp;&nbsp;<input style="width:285px" class="easyui-combobox" id="sourceType_FileUpload" multiple="true" data-options="valueField:'id',textField:'text',url:'${pageContext.request.contextPath }/document/getDocumentTagList',editable:false" /><br/>
			</div>
			 <input id="uploadify" type="file" name="uploadify" style="height:auto"/>
			 <input type="hidden" name="id" id="updateDocId"/>
			 <input id="sessionId" type="hidden" value="${pageContext.session.id}"/>
			 <span onclick="closeFileUploadWindow()" style="position:absolute;left:390px;top:10px" class="commonNode">关闭</span>
		</div>
		<div style="height:30px;padding-top:10px">
          	 <a href="javascript:$('#uploadify').uploadify('upload','*')"  class="commonNode">开始上传</a>    
   			<a href="javascript:$('#uploadify').uploadify('cancel','*')" class="commonNode">取消上传</a>    
		</div>
	</div>
	<div id="mask" style="display:none"></div>
	<!-- 资源添加窗口   end -->
	<script type="text/javascript">
		/* 转到资源列表 */
		function toSourceList(){
			$("#sourceListButton").removeClass("commonNode").addClass("chooseNode");
			$("#associatedButton").removeClass("chooseNode").addClass("commonNode");
			$("#associatedList").css("display","none");
			$("#sourceList").css("display","block");
		}
		//转到关联列表
		function toAssociatedList(){
			var node = $('#tree').tree('getSelected');
			var dataVo = {id : node.id};
 			 $.ajax({
 					type : 'post',
 					url : '${pageContext.request.contextPath}/webContentManager/getAssociatedListById',
 					data : JSON.stringify(dataVo),
 					dataType : 'json',
 					contentType : "application/json; charset=utf-8",
 					success : function(data) {
						if (data.success == "true") {
							$("#showAssociatedList").empty();
							if(data.pmcl != null && data.pmcl != ""){
								$("#showTip").css("display","none");
								$("#showAssociatedList").css("display","block");
	   							for(var i = 0; i< data.pmcl.length ;i++){
	   								docIds[i] = String(data.pmcl[i].id);
	   								var optionHtml = "<li title='"+data.pmcl[i].sourceTitle+"' style='width:100px;height:50px;float:left;border:1px solid green;list-style-type:none;margin:5px 10px;padding:3px 3px 3px 15px;font-size:10px;line-height:1.3;position:relative'><div style='height:50px; overflow:auto;letter-spacing:6px;'>"+data.pmcl[i].sourceTitle+"</div><a onclick='deleteAssociated("+i+");' href='javascript:void(0);' style='position:absolute;top:0px;left:0px;text-decoration:none;font-size:1.2em'><b>删</b></a>"+
									"<span style='position:absolute;top:-10px;left:90px;background-color:#7F99BE;padding:2px;font-size:0.9em'>"+data.pmcl[i].sourceType+"</span></li>"
									$("#showAssociatedList").append(optionHtml);
	   							}
							}else{
								$("#showTip").css("display","block");
								$("#showAssociatedList").empty();
							}
						} else {
							$.messager.alert('关联失败',data.msg,"error");
						}
					}
 				});
			$("#associatedButton").removeClass("commonNode").addClass("chooseNode");
			$("#sourceListButton").removeClass("chooseNode").addClass("commonNode");
			$("#sourceList").css("display","none");
			$("#associatedList").css("display","block");
		}
		/* 保存关联 */
		function doAssociated(){
			var sourceDataList = $('#sourceGrid').datagrid('getChecked');
			var node = $('#tree').tree('getSelected');
			if(node == null || node == ""){
				$.messager.alert("警告","请先选择左侧模块子节点");
				return;
			}else{
				var leaf = $('#tree').tree('isLeaf', node.target);
				if(!leaf){
					$.messager.alert("警告","请选择左侧模块子节点,而不是父节点");
					return;
				}
			};
			var arr = new Array();
			if(sourceDataList.length <=0){
				$.messager.alert("警告","请选择需要关联的资源数据");
				return;
			}
    		for(var i =0; i< sourceDataList.length;i++){
    			//必须设置它为局部变量，否则会出现多条重复数据
    			var map = {};
    			map["id"]=sourceDataList[i].id;
    			map["title"]=sourceDataList[i].sourceTitle;
    			map["sourceType"]=sourceDataList[i].sourceType;
    			arr[i] = map;
    		};
    		var dataVo = {
				nodeName : node.text,
				nodeId : node.id,
				dataList : arr
			};
    		$.ajax({
				type : 'post',
				url : "${pageContext.request.contextPath }/webContentManager/addAssociated",
				data : JSON.stringify(dataVo),
				dataType : 'json',
				contentType : "application/json; charset=utf-8",
				success : function(data) {
					if (data.success == "true") {
						//转到关联列表
						toAssociatedList();
						//$("#sourceGrid").datagrid('reload');
					} else {
						$.messager.alert('关联失败',data.msg,"error");
						//$('#sourceGrid').datagrid('reload');
					}
				}
			});
		}
		/**
		*关闭上传窗口
		*/
		function closeFileUploadWindow(){
			$("#mask").hide();
			$("#fileUpload").css("display","none");
			$('#uploadify').uploadify('cancel','*');
			$("#docTitle").val("");
			$("#docTag").combobox("setValue","");
			
		}
		/**
		*打开文件上传窗口
		*/
		function fileUpload(obj){
			$('#sourceType_FileUpload').combobox('clear');//清除逗号
			$("#mask").show();
		/* 	if(document.getElementById("updateNoFiles") != null){
				document.getElementById("updateNoFiles").style.display = 'none';
			} */
			//更新时使用
/* 			if(id != null && id != ""){
				//数据回显
				$.ajax({
					type : 'post',
					url : '${pageContext.request.contextPath}/document/getDocumentDataById',
					data : JSON.stringify({id:id}),
					dataType : 'json',
					contentType : "application/json; charset=utf-8",
					success : function(data) {
						//赋值
						$("#docTitle").val(data.docTitle);
						//$('#docTag').combobox("setValue",data.docTag);
						var taglist = data.docTag.split(",");
						for(var x =0;x<taglist.length;x++){
							//alert(taglist[x])
							var temp = taglist[x];
							//$("#docTag").combobox("select",taglist[i]);
									var data = $("#docTag").combobox('getData');
								    if (data.length > 0) {
								    	//alert(data)
								    	if(temp != null && temp != ""){
								        	for(var i =0 ;i<data.length;i++){
								        		//alert(data[i].text +"=="+temp)
								            	if(data[i].text==temp){
								        		//alert(data[i].id);
								        		$("#docTag").combobox('select', data[i].id);
								            	}
								            }
								         }
								     }
						}
					}
				});
				//无文件上传
				if(document.getElementById("updateNoFiles") == null || document.getElementById("updateNoFiles") == "" ){
					var htmls = "<button id='updateNoFiles' onclick='updateNoFile()'>无文件更新</button>";
					$("#fileUpload").append(htmls);
				}else{
					document.getElementById("updateNoFiles").style.display = 'block';
				}
			} */
			
			$("#fileUpload").css("display","block");
			//$("#updateDocId").val(id);
		}
	</script>
</body>

</html>