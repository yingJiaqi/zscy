<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>eHealthRep</title>
<!-- 导入jquery核心类库 -->
<script type="text/javascript" src="${pageContext.request.contextPath }/static/js/jquery-1.11.3.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath }/static/js/json2.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath }/static/js/utils.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath }/static/js/easyui/jquery.easyui.min.js"></script>
<script
	src="${pageContext.request.contextPath }/static/js/easyui/locale/easyui-lang-zh_CN.js"
	type="text/javascript"></script>
	<link id="easyuiTheme" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/static/js/easyui/themes/default/easyui.css">
  <script type="text/javascript" charset="utf-8" src="${pageContext.request.contextPath }/static/js/ueditor/ueditor.config.js"></script>
    <script type="text/javascript" charset="utf-8" src="${pageContext.request.contextPath }/static/js/ueditor/ueditor.all.js"> </script>
    <script type="text/javascript" charset="utf-8" src="${pageContext.request.contextPath }/static/js/ueditor/lang/zh-cn/zh-cn.js"></script>

<script type="text/javascript">
//编辑器实体
//商品描述编辑器
var descEditor =  null;
//商品编辑器
var commodityImage = null;


$(function(){
	// 先将body隐藏，再显示，不会出现页面刷新效果
	$("body").css({visibility:"visible"});
	//  点击保存 提交表单!
	$("#saveCommodity").click(function() {
		
		if ($("#addCommodityForm").form("validate")) {
			var usedTypes = "";
			var data = $("#addCommodityForm").serialize();
			//遍历参数，重新生成usedType数据格式 
			//alert(data)
			var arrs = data.split("&");
			for(var i=0;i<arrs.length;i++){
				if(arrs[i].indexOf("usedType")==0){
					//alert(arrs[i])
					var childs = arrs[i].split("=");
					usedTypes = usedTypes + childs[1]+",";
				}
			}
			//alert(usedTypes)
			var category = $('#category').combobox('getText');
			var aa = UE.getEditor('editor').getContent();
			var imageUrls = UE.getEditor('imageEditor').getContent();
			//必须转换，要不后台拿不到数据 
			aa = aa.replace(/=/g, "|f|");
			imageUrls = imageUrls.replace(/=/g, "|f|");
			//alert(data)
		/* 	var arr = data.split("&");
			var datas = '';
			for(var i=0;i<arr.length;i++){
					datas += arr[i]+"&";
			}  */
			datas = data + "&commodityDesc="+aa+"&"+"category_id="+category+"&"+"imageUrls="+imageUrls+"&usedTypes="+usedTypes.substring(0,usedTypes.length-1);
			//alert(datas)
			$.ajax({
				type : 'post',
				url : "${pageContext.request.contextPath }/Commodity/addCommodity",
				data : JSON.stringify(conveterParamsToJson(datas)),
				dataType : 'json',
				contentType : "application/json; charset=utf-8",
				success : function(data) {
					if (data.flag) {
						$("#addCommodityForm")[0].reset();
						descEditor.execCommand("cleardoc");
						commodityImage.execCommand("cleardoc");
						$.messager.alert('更新成功',data.msg,"info");
					} else {
						$.messager.alert('更新失败',data.msg,"error");
					}
				}
			});
			} else {
				return;
			}
	});
	setInterval(isFocus,500);
});
//添加类目时，相应添加规格描述
function addSpecification(rec){
	var dataVo = {id:rec.id};
	$.ajax({
		type : 'post',
		url : "${pageContext.request.contextPath }/category/getAssociatedListById",
		data : JSON.stringify(dataVo),
		dataType : 'json',
		contentType : "application/json; charset=utf-8",
		success : function(data) {
			if (data.success == "true") {
				$("#specificationLocation").css("display","block");
				var optionHtmlh = "<div><hr/>规格参数配置<br/><h3 style='color:green'>"+data.docList[0].categoryName+"</h3></div>";
				$("#specificationLocation").append(optionHtmlh);
				for(var i = 0; i< data.docList.length ;i++){
					var optionHtml = "<div style='height:30px; overflow:auto;' title='"+data.docList[0].categoryName+"'>"+data.docList[i].cateforySpecificationName+"<input type='text' name='"+data.docList[0].categoryName+"_"+data.docList[i].cateforySpecificationName+"'/></div>"
					$("#specificationLocation").append(optionHtml);
				}
				$("#specificationLocation").append("<hr/>");
			} else {
				$.messager.alert('失败',"类目参数获取失败");
			}
		}
	});
}
//减少类目时，相应去除规格描述
function delSpecification(re){
	//alert($("h3:contains('"+re.text+"')").html());
	$("h3:contains('"+re.text+"')").parent().remove();
	$("div[title='"+re.text+"']").remove();
}
</script>
<style type="text/css">
</style>
</head>
<body  class="easyui-layout" style="visibility:hidden;" >
		<div region="north" style="height: 31px; overflow: hidden;" split="false" border="false">
			<div class="datagrid-toolbar">
				<a id="saveCommodity" icon="icon-save" href="#" class="easyui-linkbutton" plain="true" style="color: green; font-size: 15px">&nbsp;<b>提交</b></a>
			</div>
		</div>
		<div region="center" style="overflow: auto; padding: 10px;" border="false">
			<form id="addCommodityForm" action="#">
				<table class="table-edit" width="90%" align="center">
					<tr>
						<th style="width:100px;">商品类目:</th>
						<th>
							<input class="easyui-combobox" id="category"  multiple="true" data-options="valueField:'id',textField:'text',url:'${pageContext.request.contextPath }/category/getCategoryListWithCommodity',editable:false,onSelect: function(rec){addSpecification(rec);},onUnselect: function(re){delSpecification(re);}" />
	            			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	            			<input type="checkbox" name="hotCommodity" value="1"/>热门商品
	            		</th>
					</tr>
					<tr>
						<th style="height: 40px">商品标题:</th>
						<th><input type="text" name="title" class="easyui-validatebox" data-options="required:true,validType:'multiple[\'length[3,100]\',\'RegeMatch\']'"  invalidMessage="字符最少3个，最多100个或存在非法字符" /></th>
					</tr>
					<tr>
						<th style="height: 40px">商品卖点:</th>
						<th><input type="text" name="sellPoint" class="easyui-validatebox" data-options="required:true,validType:'multiple[\'length[3,100]\',\'RegeMatch\']'"  invalidMessage="字符最少3个，最多100个或存在非法字符"/></th>
					</tr>
					<tr>
						<th style="height: 40px">商品价格:</th>
						<th><input type="text" name="priceView" class="easyui-numberbox" data-options="min:1,max:99999999,precision:2,required:true" /></th>
					</tr>
					<tr>
						<th style="height: 40px">库存数量:</th>
						<th><input type="text"  class="easyui-numberbox"  name="num" data-options="min:1,max:99999999,precision:0,required:true"/></th>
					</tr>
					<tr>
						<th style="height: 40px">商品用途:</th>
						<th>
							<input type="checkbox" name="usedType" value="五金类"/>五金类
							<input type="checkbox" name="usedType" value="电机类"/>电机类
							<input type="checkbox" name="usedType" value="皮套类"/>皮套类
							<input type="checkbox" name="usedType" value="喇叭磁铁"/>喇叭磁铁
							<input type="checkbox" name="usedType" value="玩具类"/>玩具类
							<input type="checkbox" name="usedType" value="真空膜机类"/>真空膜机类
							<input type="checkbox" name="usedType" value="LED磁铁"/>LED磁铁
							<input type="checkbox" name="usedType" value="其它"/>其它
						</th>
					</tr>
					
				</table>
				<div id="specificationLocation" style="display:none;margin-left:50px"></div>
			</form>
			<table class="table-edit" width="90%" align="center">
				<tr>
						<th style="height: 40px">商品图片:</th>
						<th> 
							<!-- <a href="javascript:void(0)" onclick="upImage();">上传图片</a>
	                 		<input type="hidden" name="image"/> -->
	                 		<div style="width:900px">
								<script  type="text/plain" name="image" id="imageEditor"></script>
							</div>
	                 	</th>
					</tr>
					<tr>
						<th style="height: 40px">商品描述:</th>
						<td>
							<div style="width:900px">
								<script  type="text/plain" name="commodityDesc" id="editor"></script>
							</div>
	            		</td>
					</tr>
			</table>
			
		</div>
<script type="text/javascript">
descEditor =UE.getEditor('editor',{
	 //默认的编辑区域高度  
   initialFrameHeight:500 ,
   emotionLocalization:true,
   //禁用浮动
   autoFloatEnabled: false,
   autoClearEmptyNode:true,
});

commodityImage= UE.getEditor('imageEditor',{  
    //这里可以选择自己需要的工具按钮名称,此处仅选择如下五个  
    toolbars:[['insertimage', 'Undo', 'Redo']],  
    //focus时自动清空初始化时的内容  
    autoClearinitialContent:true,  
    //关闭字数统计  
    wordCount:false, 
    //禁用浮动
    autoFloatEnabled: false,
    //不可以编辑
  	//readonly:true,
    //关闭elementPath
    elementPathEnabled:false,
    autoClearEmptyNode:true,
    //是否可以拉伸长高，默认true(当开启时，自动长高失效)
    scaleEnabled :true,
    //默认的编辑区域高度  
    initialFrameHeight:260  
    //更多其他参数，请参考ueditor.config.js中的配置项  
});  
function isFocus(){    
    if(commodityImage.isFocus()){
    	commodityImage.blur();
    }
}
</script>

</body>
</html>