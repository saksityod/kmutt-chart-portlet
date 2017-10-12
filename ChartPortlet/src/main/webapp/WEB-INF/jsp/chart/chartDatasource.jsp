<%@ include file="/WEB-INF/jsp/include.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Chart Datasource</title>
<c:set var="ns"><portlet:namespace/></c:set>
<portlet:actionURL var="formAction">
        <portlet:param name="action" value="doSubmit"/>
</portlet:actionURL>
<portlet:actionURL var="formActionNew">
        <portlet:param name="action" value="doNew"/>
</portlet:actionURL>
<portlet:actionURL var="formActionUpdate">
        <portlet:param name="action" value="doUpdate"/>
</portlet:actionURL>
<portlet:actionURL var="formActionDelete">
        <portlet:param name="action" value="doDelete"/>
</portlet:actionURL>
<portlet:resourceURL var="selectedDatasource" id="selectedDatasource" ></portlet:resourceURL>

<script type="text/javascript" src="<c:url value="/resources/js/jquery-1.11.2.min.js"/>"></script>
<!--
 <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
 <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
-->

<link rel="stylesheet" href="<c:url value="/resources/jqueryui/jquery-ui.css"/>">
  
  
<script type="text/javascript" src="<c:url value="/resources/fusioncharts/js/fusioncharts.js" />"></script>
<script type="text/javascript" src="<c:url value="/resources/fusioncharts/js/themes/fusioncharts.theme.fint.js"/>"></script>


  
  
<script src="<c:url value="/resources/bootstrap/js/bootstrap.min.js"/>"></script>
<link rel="stylesheet" href="<c:url value="/resources/bootstrap/css/bootstrap.min.css"/>">
<script src="<c:url value="/resources/jqueryui/jquery-ui.js"/>"></script>

<link rel="stylesheet" href="<c:url value="/resources/mloading/jquery.mloading.css"/>">
<script src="<c:url value="/resources/mloading/jquery.mloading.js"/>"></script>


<!-- include data table start -->

<script src="<c:url value="/resources/data-table/jquery.dataTables.min.js"/>"></script>
<link rel="stylesheet" href="<c:url value="/resources/data-table/jquery.dataTables.min.css"/>">
 
 <!-- 
<script src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
<link rel="stylesheet" href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css">
 -->
  
<!-- include data table end -->

<!-- 
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
 -->
<style type="text/css">
	#web_${ns} .chart_ds_content label{ color:red; }
	#web_${ns} .chart_ds_name select{ }
	#web_${ns} .chart_ds_param select{ height:250px;width:457px;overflow-x:scroll}
	#web_${ns} .userAuthority select{ height:250px;width:457px;overflow-x:scroll}
	#web_${ns} .chart_param select{ height:250px;width:457px;overflow-x:scroll}
	.selection_div>div{ display:inline-block;}
	.errorMessage{ color:red;}
	.portlet-content {
    background: rgba(0, 0, 0, 0) linear-gradient(to top, #fff 0px, #f6f6f6 47%, #ededed 100%) repeat scroll 0 0;
    border-radius: 0;
    margin-bottom: 0;
	}
	.formChartDataSource{
	 background: rgba(0, 0, 0, 0) linear-gradient(to top, #fff 0px, #f6f6f6 47%, #ededed 100%) repeat scroll 0 0;
	 border-radius: 0;
	 margin-bottom: 0;
	}
	.modal-header{
		background-color: #f5f5f5;
	    border-radius: 0 0 6px 6px;
	    border-top: 1px solid #ddd;
	    box-shadow: 0 1px 0 white inset;
	   
	}
	.labelChartDataSource{
		width:160px;
		float:left;
		padding-top:5px;
		font-weight:bold;
	}
	
	.inputFormChartDataSource{
		/*width:300px;*/
		float:left;
		padding-top:5px;
	}
	.aui .portlet-content, .aui .portlet-minimized .portlet-content-container{
		padding: 15px 15px 15px 15px;
	}
	.aui label{
		font-weight:bold;
	}
	
	.aui .btn {
		font-size: 14px;
	 	padding: 4px 12px; 
		width: auto;
		margin-top: 0px;
		display: inline;
	}
	
	.aui .tableDataSource_wrapper select{
		width: 60px;
	}
	
	
	
	/* Large desktop Start#####################################*/
 @media (min-width: 1200px) { 
 
	.modal.large {
		    width: 90%;
		    margin-left:-45%;  
		    top:0px;
		}
		
	.modal.medium {
		    width: 50%;
		    margin-left:-25%;  
		    top:0px;
		}

	 
  }
  /* Large desktop End######################################*/
  
  /*  desktop Start#########################################*/
 @media (min-width: 980px) and (max-width: 1199px) {
 
 	.modal.large {
		    width: 90%;
		    margin-left:-45%;  
		    top:0px;
		}
		
		.modal.medium {
		    width: 50%;
		    margin-left:-25%;  
		    top:0px;
		}
 	
  }
 /*  desktop End############################################*/
 
 /* Portrait tablet to landscape and desktop Start##########*/
 @media (min-width: 768px) and (max-width: 979px) {
 .modal.large {
		    width: 90%;
		    margin-left:-45%;  
		    top:0px;
		}
	.modal.medium {
		    width: 50%;
		    margin-left:-25%;  
		    top:0px;
		}
		

  }
 /* Portrait tablet to landscape and desktop End############*/ 
 
 /* Landscape phone to portrait tablet Start################*/
 @media (max-width: 767px) { 
 	
 .modal.large {
 	
	    width: '';
	    top:0px;    
	}
	
	.modal.medium {
		   width: '';
	   	   top:0px;  
		}

 
  }
 /* Landscape phone to portrait tablet End##################*/ 
 
 /* Landscape phones and down Start#########################*/
 @media (max-width: 480px) { 
 	
 
 

  }
  /* Landscape phones and down End##########################*/
	
	
</style>
<script type="text/javascript">
	
	
var checkDataDuplicateFn = function(object,keyCheck){
	var dataReturn=true;
	$.each(object,function(index,indexEntry){
		
	
		if($(indexEntry).text()==keyCheck && $(indexEntry).text()!=""){
			//console.log("Duplicate");
			dataReturn= false;
		}
	});
	return dataReturn;
	
}
var checkValidateFormFn = function(){
	var validate="";
	//alert("check");
	//datasourceName
	//sqlString
	//chartUsedList

	if(!checkDataDuplicateFn($("#web_${ns} #datasourceId option").get(),$("#web_${ns} #datasourceName").val())){
		validate+="Datasource Name must be unique.\n";
	}
	if($("#web_${ns} #datasourceName").val()==""){
		validate+="Datasource name is required. \n";
	}
	if($("#web_${ns} #sqlString").val()==""){
		validate+="SQL String is required. \n";
	}
	if($("#web_${ns} #chartUsedList").val()==""){
		validate+="Chart Used List required. \n";
	}
	
	
	if(validate!=""){
		return validate;
		//return false;
	}else{
		return "";
	}
	
}

	function selectedChart(current){
		var selectedElement=$("#web_${ns} select#chartInitList option:selected");
		var selected = [];
		selectedElement.each(function(){
			 selected.push(  [$(this).val(),$(this).html()]  );
			 $(this).hide();
			 $(this).prop("selected",false);
		});
		var renderSelectedElement=$("#web_${ns} select#chartUsedList");
		for(var i=0;i<selected.length;i++){
			var newOpt = $("<option/>");
			newOpt.html( selected[i][1] );
			newOpt.attr("value",selected[i][0]);
			renderSelectedElement.append(newOpt);
		}//end for
	}
	function deselectedChart(current){
		var selectedElement=$("#web_${ns} select#chartUsedList option:selected");
		var selected = [];
		selectedElement.each(function(){
			 selected.push(  [$(this).val(),$(this).html()]  );
		     $(this).remove();
		});
		for(var i=0;i<selected.length;i++){
			var inx = selected[i][0];
			var opt = $("#web_${ns}  select#chartInitList option[value='"+inx+"']");
			opt.show();
			opt.prop("selected",true);
		}//end for
	}
	// control action
	function selectedFilter(current){
		var selectedElement=$("#web_${ns} .chart_ds_param .chart_ds_param_avaliable select option:selected");
		var selected = [];
		selectedElement.each(function(){
			 selected.push(  [$(this).val(),$(this).html()]  );
			 $(this).hide();
			 $(this).prop("selected",false);
		});
		var renderSelectedElement=$("#web_${ns} .chart_ds_param .chart_ds_param_used select");
		for(var i=0;i<selected.length;i++){
			var newOpt = $("<option/>");
			newOpt.html( selected[i][1] );
			newOpt.attr("value",selected[i][0]);
			renderSelectedElement.append(newOpt);
		}//end for
	}
	function deselectedFilter(current){
		var selectedElement=$("#web_${ns} .chart_ds_param .chart_ds_param_used select option:selected");
		var selected = [];
		selectedElement.each(function(){
			 selected.push(  [$(this).val(),$(this).html()]  );
		     $(this).remove();
		});
		for(var i=0;i<selected.length;i++){
			var inx = selected[i][0];
			var opt = $("#web_${ns} .chart_ds_param .chart_ds_param_avaliable select option[value='"+inx+"']");
			opt.show();
			opt.prop("selected",true);
		}//end for
	}
	
	// for user selection
	function selectedUser(current){
		//var selectedElement=$("#web_${ns} .chart_param .chart_param_avaliable select option:selected");
		var selectedElement=$("#web_${ns} select#userInitList option:selected");
		var selected = [];
		selectedElement.each(function(){
			 selected.push(  [$(this).val(),$(this).html()]  );
			 $(this).hide();
			 $(this).prop("selected",false);
		});
		var renderSelectedElement=$("#web_${ns} select#userUsedList");
		for(var i=0;i<selected.length;i++){
			var newOpt = $("<option/>");
			newOpt.html( selected[i][1] );
			newOpt.attr("value",selected[i][0]);
			renderSelectedElement.append(newOpt);
		}//end for
	}
	function deselectedUser(current){
		var selectedElement=$("#web_${ns} select#userUsedList option:selected");
		var selected = [];
		selectedElement.each(function(){
			 selected.push(  [$(this).val(),$(this).html()]  );
		     $(this).remove();
		});
		for(var i=0;i<selected.length;i++){
			var inx = selected[i][0];
			var opt = $("#web_${ns} select#userInitList option[value='"+inx+"']");
			opt.show();
			opt.prop("selected",true);
		}//end for
	}
	//page function
	function formSubmit(actionName){
		/*
		var id = $("web_${ns} select#datasourceId").val();
		var text = $("web_${ns} select#datasourceId").find('option:selected').text();
		*/
		var id = $("#web_${ns} #dataSourceID").val();
		var text = $("#web_${ns} #dataSourceName").val();
		//alert(id);
		//alert(text);
		
		
		if(id==0){
			return false;
		}
		var actionMessage = "";
		if(actionName=="new"){
			actionMessage = "Do you want to save as this service ?";
		}else if(actionName=="update"){
			actionMessage = "Do you want to update service ?";
		}else if(actionName=="delete"){
			actionMessage = "Do you want to delete service ?";
		}else{
			actionMessage = actionName+"?";
		}
		
		if(actionName=="new"){

			if(checkValidateFormFn()!=""){
				alert(checkValidateFormFn());
				return false;
			}else{
				var result = confirm(actionMessage);
				if (!result) {
				    return false;
				}else{
				$("#web_${ns} form#chartDatasource").attr("action","<%=formActionNew%>");
				}
			}
		}else if(actionName=="update"){
			
			if(checkValidateFormFn()!=""){
				alert(checkValidateFormFn());
				return false;
			}else{
				var result = confirm(actionMessage);
				if (!result) {
				    return false;
				}else{
					$("#web_${ns} form#chartDatasource").attr("action","<%=formActionUpdate%>");
				}
			}
			
			
		}else if(actionName=="delete"){
			
			var result = confirm(actionMessage);
			if (!result) {
			    return false;
			}else{
				$("#web_${ns} form#chartDatasource").attr("action","<%=formActionDelete%>");
			}
			
		}else{
			return false;
		}
		//reset message
		$("#web_${ns} #sqlMessage").html(""); 
		var errorMessage = checkValidSqlFilter();
		if(errorMessage==null){
			var selectedFilter=$("#web_${ns} .chart_ds_param .chart_ds_param_used select option");
			selectedFilter.each(function(){
				$(this).prop("selected",true);
			});
			//chart
			$("#web_${ns} select#chartUsedList option").each(function(){
				$(this).prop("selected",true);
			});
			//user
			$("#web_${ns} select#userUsedList option").each(function(){
				$(this).prop("selected",true);
			});
			// do submit case
			$("#web_${ns} form#chartDatasource").submit();
		}else{
			$("#web_${ns} #sqlMessage").html(errorMessage);
		}
	}
	function checkValidSqlFilter(){
		var message = null;
		var invalidParam = [];
		var sql = $("#web_${ns} #sqlString").val();
		var usedParamName = [];
		var selectedFilter=$("#web_${ns} .chart_ds_param .chart_ds_param_used select option");
		selectedFilter.each(function(){
			usedParamName.push($(this).html());  //  display text here
		}); // end get ParamName from list
		for(var i=0;i<usedParamName.length;i++){
			var rx = new RegExp(':'+usedParamName[i]+'(?!:)');
			if( sql.search(rx) > -1 ){}
			else{ invalidParam.push(usedParamName[i]);	}
		}//end loop
		if(invalidParam.length>0)
			return "Param: ["+invalidParam.join(",")+"] not exists";
		else return null;
	}
	function setDatasource(current){
		requestDatasourceDetail(current.value);
	}
	function requestDatasourceDetail(selectId){
		$("#web_${ns} #sqlMessage").html("waiting");
		var datasourceId = selectId;
		$.ajax({
   	 		dataType: "json",
   	 		url:"<%=selectedDatasource%>",
   	 		data: { datasourceId: datasourceId },
   	 		success:function(data){
   	 				$("#web_${ns} #sqlMessage").empty();
   	 				
   	 				renderDsDetail(data["content"]["datasource"]);
   	 				renderFilter(data["content"]["filter"]);
   	 				renderChart(data["content"]["chart"]);
   	 				renderUser(data["content"]["user"]);
   	 		},error:function(data){
				$("#web_${ns} #sqlMessage").html("Datasource detail error");
   	 		} 
   	 	});
	}
	function renderDsDetail(obj){
		$("#web_${ns} #datasourceName").val(obj["sname"]);
		$("#web_${ns} #sqlString").val(obj["sql"]);
		$("#web_${ns} #selectedConnId").val(obj["conn"]);
	}
	function renderFilter(obj){
		
		$("#web_${ns} select#filterInitList option").each(function(){
			$(this).prop("selected",false);
			$(this).show();
		});
		$("#web_${ns} select#filterUsedList").empty();
		
		for(var i=0;i<obj["fusedlist"].length;i++){
			var opt =  $("<option />");
			var value = obj["fusedlist"][i]["fid"];
			opt.attr("value",value);
			opt.html(obj["fusedlist"][i]["fname"]);
			$("#web_${ns} select#filterUsedList").append(opt);
			//disable
			var target = $("#web_${ns} select#filterInitList").find("option[value="+value+"]");
			target.prop("selected",false);
			target.hide();
		}
	}
	function renderChart(obj){
		$("#web_${ns} select#chartInitList option").each(function(){
			$(this).prop("selected",false);
			$(this).show();
		});
		$("#web_${ns} select#chartUsedList").empty();
		
		for(var i=0;i<obj["cusedlist"].length;i++){
			var opt =  $("<option />");
			var value = obj["cusedlist"][i]["cid"];
			opt.attr("value",value);
			opt.html(obj["cusedlist"][i]["cname"]);
			$("#web_${ns} select#chartUsedList").append(opt);
			//disable
			var target = $("#web_${ns} select#chartInitList").find("option[value="+value+"]");
			target.prop("selected",false);
			target.hide();
		}
	}
	function renderUser(obj){
		$("#web_${ns} select#userInitList option").each(function(){
			$(this).prop("selected",false);
			$(this).show();
		});
		$("#web_${ns} select#userUsedList").empty();
		
		for(var i=0;i<obj["userUsedlist"].length;i++){
			var opt =  $("<option />");
			var value = obj["userUsedlist"][i]["uid"];
			opt.attr("value",value);
			opt.html(obj["userUsedlist"][i]["uname"]);
			$("#web_${ns} select#userUsedList").append(opt);
			//disable
			var target = $("#web_${ns} select#userInitList").find("option[value="+value+"]");
			target.prop("selected",false);
			target.hide();
		}
	}
	var getObjectDatasourceListFn = function(){
		
	   
		var dataSourceListObject = $("#web_${ns} #datasourceId option").get();
		var dataSourceList="";
		var dataSourceListArray="";
		dataSourceListArray+="[";
		$.each(dataSourceListObject,function(index,indexEntry){
				if(index==0){
					
					dataSourceListArray+="\""+$(indexEntry).val()+"-"+$(indexEntry).text()+"\"";
					
				}else{
					
					dataSourceListArray+=",\""+$(indexEntry).val()+"-"+$(indexEntry).text()+"\"";
					
				}
		});
		 dataSourceListArray+="]";
		return eval("("+dataSourceListArray+")");
	}
	
	var clearDataSourceFormFn = function(){
			$("#web_${ns} select#filterUsedList").empty();
	    	$("#web_${ns} select#chartUsedList").empty();
	    	$("#web_${ns} select#userUsedList").empty();
	    	
	    	$("#web_${ns} input#datasourceName").val("");
	    	$("#web_${ns} #selectedConnI option:first").attr('selected','selected');
	    	$("#web_${ns} textarea#sqlString").val("");
	    	$("#web_${ns} #actionName").html("<b>Add</b>");
	    	
	    	
             
	}
	var listDataTableFn = function(){
		
		   
		var dataSourceListObject = $("#web_${ns} #datasourceId option").get();
		var dataSourceHTML="";
		
		$.each(dataSourceListObject,function(index,indexEntry){
			if($(indexEntry).val()!=0){
			dataSourceHTML+="<tr>";
				dataSourceHTML+="<td>"+$(indexEntry).val()+"</td>";
				dataSourceHTML+="<td>"+$(indexEntry).text()+"</td>";
				dataSourceHTML+="<td style='text-align:center;'>";
				dataSourceHTML+="<a id=\"edit-"+$(indexEntry).val()+"\" class=\"btn btn-mini edit\" href=\"#\"><i class=\"icon-pencil\"></i> </a>";
				dataSourceHTML+="<a id=\"del-"+$(indexEntry).val()+"\" style=\"margin-left:3px;\" class=\"btn btn-mini del\" href=\"#\"><i class=\"icon-trash\"></i> </a>";
				dataSourceHTML+="</td>";
			dataSourceHTML+="</tr>";
			}
		});
		
		
		$("#web_${ns} #listDataSource").html(dataSourceHTML);
		
		$("#web_${ns} .edit").click(function(){
			clearDataSourceFormFn();
			var id = this.id.split("-");
			id=id[1];
			var text=$(this).parent().prev().text();
			
			
			 $("#web_${ns} .empbedParamChartDataSource").empty();
             $("#web_${ns} .empbedParamChartDataSource").append("<input type='hidden' id='dataSourceID' name='dataSourceID' value='"+id+"'>");
             $("#web_${ns} .empbedParamChartDataSource").append("<input type='hidden' id='dataSourceName' name='dataSourceName' value='"+text+"'>");
             $("#web_${ns} #datasourceId").val(id);
             requestDatasourceDetail(id);
             $("#web_${ns} #actionName").html("<b>Edit</b>");
             $("#web_${ns} #btnSaveActionArea").hide();
             $("#web_${ns} #btnEditActionArea").show();
             
             
			$("#web_${ns} #dataSourceModal").modal();
			
			
			return false;
		});
		
		$("#web_${ns} .del").click(function(){
			clearDataSourceFormFn();
			var id = this.id.split("-");
			id=id[1];
			var text=$(this).parent().prev().text();
			
			 $("#web_${ns} .empbedParamChartDataSource").empty();
             $("#web_${ns} .empbedParamChartDataSource").append("<input type='hidden' id='dataSourceID' name='dataSourceID' value='"+id+"'>");
             $("#web_${ns} .empbedParamChartDataSource").append("<input type='hidden' id='dataSourceName' name='dataSourceName' value='"+text+"'>");
             $("#web_${ns} #datasourceId").val(id);
             requestDatasourceDetail(id);
          	/*   
             $("#web_${ns} #actionName").html("<b>Edit</b>");
             $("#web_${ns} #btnSaveActionArea").hide();
             $("#web_${ns} #btnEditActionArea").show();
			 $("#web_${ns} #dataSourceModal").modal();
			*/
			 formSubmit('delete');
			
			
			
			
			return false;
		});
		

	}
	
	var sortingOptionByNameFn = function(slectName){
		var options = $(slectName);
		//alert(options);
	    var arr = options.map(function(_, o) {
	        return {
	            t: $(o).text(),
	            v: o.value
	        };
	    }).get();
	   /*
	    arr.sort(function(o1, o2) {
	        return o1.t > o2.t ? 1 : o1.t < o2.t ? -1 : 0;
	    });
	    */
	    
	    arr.sort(function(o1, o2) {
	    	  var t1 = o1.t.toLowerCase(), t2 = o2.t.toLowerCase();

	    	  return t1 > t2 ? 1 : t1 < t2 ? -1 : 0;
	    	});
	    
	    options.each(function(i, o) {
	        //console.log(i);
	        o.value = arr[i].v;
	        $(o).text(arr[i].t);
	    });
	    //alert("sorting ok");
	}
	
	
	
	
	$(document).ready(function(){
		
		$( document ).ajaxStart(function() {
			$("body").mLoading();
		});
		$( document ).ajaxStop(function() {
			$("body").mLoading('hide');
		});

		
		var controlMessage = "${chartDatasourceForm.message}";
		if(controlMessage.length>1){
			alert(controlMessage);
			//window.location="./chart-datasource";
		}
		
	
	
/*
		$("#web_${ns} #datasourceId2").autocomplete({
               source: getObjectDatasourceListFn(),
               select: function (a, b) {
           		var dataSourceID="";
           		var dataSourceName="";
           		var dataSourceArray=[];
           		dataSourceArray=b.item.value.split("-");
           		dataSourceID=dataSourceArray[0];
           		dataSourceName=dataSourceArray[1];
                   
                   $("#web_${ns} .empbedParamChartDataSource").empty();
                   $("#web_${ns} .empbedParamChartDataSource").append("<input type='hidden' id='dataSourceID' name='dataSourceID' value='"+dataSourceID+"'>");
                   $("#web_${ns} .empbedParamChartDataSource").append("<input type='hidden' id='dataSourceName' name='dataSourceName' value='"+dataSourceName+"'>");
                 
                   $("#web_${ns} #datasourceId").val(dataSourceID);
                   requestDatasourceDetail(dataSourceID);
                  
               }
           });
 		
	    //Action Add
	    $("#web_${ns} #btnAdd").click(function(){
	    	//alert("btn add");
	    	//location.reload(); 
	    	//$("#web_${ns} form#chartDatasource").reset();
	    	$("#web_${ns} #datasourceListArea").hide();
	    	
	    	$("#web_${ns} select#filterUsedList").empty();
	    	$("#web_${ns} select#chartUsedList").empty();
	    	$("#web_${ns} select#userUsedList").empty();
	    	
	    	$("#web_${ns} #btnNewSubmit").val("Save");
	    	
	    });
	    
	    
	    //Action Edit
 		$("#web_${ns} #btnEdit").click(function(){
	    	$("#web_${ns} #datasourceListArea").show();
	    	$("#web_${ns} #btnNewSubmit").val("Save as");
	    	return false;
	    });
 		*/   
 		
	    
	    //get data source for list data table
	    listDataTableFn();
	    //binding data table start
	 	
	    $('#web_${ns} #tableDataSource').DataTable();
	    $("#web_${ns} select[name='tableDataSource_length']").css({"width":"60px","margin-bottom":"0px"});
	    $("#web_${ns} input[type='search']").css({"width":"300px","margin-bottom":"0px"});
	    

	    //binding data table end
	    
	    //add data source
	    $("#web_${ns} #btnAddDataSource").click(function(){
	    	 clearDataSourceFormFn();
	    	 $("#web_${ns} #dataSourceModal").modal('show');
	    	 $("#web_${ns} #btnSaveActionArea").show();
             $("#web_${ns} #btnEditActionArea").hide();
	    	
	    });
	    //clear
	    $("#web_${ns} #btnClear").click(function(){
	    	clearDataSourceFormFn();
	    	return false;
	    })
	    
	    
	
   		 //sorting option start
		 sortingOptionByNameFn("#web_${ns} select#filterInitList option");
		 sortingOptionByNameFn("#web_${ns} select#chartInitList option");
		 sortingOptionByNameFn("#web_${ns} select#userInitList option");
		 //sorting option end   
	    
	});

</script>
</head>
<body>
	
	<div id="web_${ns}" class="chart_ds_content">
	
	
<!-- Modal Confirm Start -->

<div aria-hidden="true" role="dialog" tabindex="-1" id="dataSourceModal" class="modal inmodal in large" style="display: none;">
    <div class="modal-dialog modal-lg">
    <div class="modal-content animated bounceInRight">
            <div class="modal-header ">
                <button data-dismiss="modal" class="close" type="button"><span aria-hidden="true">×</span><span class="sr-only"></span></button>
                <h5 class="modal-title"><span id='actionName'></span> Data Source</h5>
            </div>
            <form:form id="chartDatasource" modelAttribute="chartDatasourceForm" method="post" name="chartDatasourceForm" action="${formAction}" enctype="multipart/form-data">
            <div class="modal-body formChartDataSource">

	                 		<!-- Main Content Start -->
							                 		
							
								
								<form:hidden id="mode" path="mode"/>
								
								
								<div class="row-fluid " style='display:none;'>
									<div class="span12 alert" style="text-align:center; padding:5px;">
										<input type="reset" id="btnAdd" class="btn btn-primary" >
										<button id="btnEdit" class="btn btn-primary">Edit Action</button>
									</div>
								</div>
								
								
								
							
							
							
							
								<div class="chart_ds_name ">
								<div class='' id='datasourceListArea' style='display:none;'>
									<label class='labelChartDataSource'>Datasource List</label>
									<input type='text' name='datasourceId2' id="datasourceId2" class='inputFormChartDataSource' style="min-width:70%; " >
									<form:select style="min-width:70%; display:none;" id="datasourceId"  class='inputFormChartDataSource' path="datasourceId" onchange="setDatasource(this)">
										<!--<form:option value="0" label=""/>-->
										<form:options items="${chartDatasourceForm.datasources}" itemValue="serviceId" itemLabel="serviceName" />
									</form:select> 
									<br style='clear:both'/>
								</div>	 
									 
									
									 
									 
									
									<label class='labelChartDataSource'>Datasource Name</label>
									<form:input class='inputFormChartDataSource' id="datasourceName" style="min-width:70%" path="datasourceName"/>
									<br style='clear:both'/>
								</div>
								<div class="chart_ds_data">
									<label class='labelChartDataSource'>Database Connection</label>
									<form:select id="selectedConnId" class='inputFormChartDataSource' path="selectedConnId" items="${chartDatasourceForm.connections}" itemValue="connId" itemLabel="connName" multiple="false"></form:select>
									<br style='clear:both'/>
									<label class='labelChartDataSource'>Sql Query</label>
									<form:textarea id="sqlString" class='inputFormChartDataSource' style="min-width:80%;max-width:90%;" path="sqlString" rows="10" />
									<br style='clear:both'/>
									<p id="sqlMessage" class="errorMessage"></p>
								</div>
								<div>
									<span class='labelChartDataSource'>Parameter</span>
									<div class="chart_ds_param selection_div inputFormChartDataSource">
										<div class="chart_ds_param_avaliable">
											<form:select id="filterInitList" path="initialFilterList" items="${chartDatasourceForm.filterList}" itemValue="filterId" itemLabel="filterName" multiple="true"/>
										</div>
										<div class="chart_ds_param_control">
											<input type="button" onclick="selectedFilter(this)" value=">>"/>
											<br/>
											<input type="button" onclick="deselectedFilter(this)" value="<<"/>
										</div>
										<div class="chart_ds_param_used">
											<form:select id="filterUsedList" path="filterUsedList" multiple="true">
												<form:options items="${chartDatasourceForm.filterUsedList}" itemValue="filterId" itemLabel="filterName"/>
											</form:select>
										</div>
									</div>
									<br style='clear:both'>
									
									<span class='labelChartDataSource'>Chart Authority</span>
									<div class="chart_param selection_div inputFormChartDataSource">
										<div class="chart_param_avaliable">
											<form:select id="chartInitList" path="chartInitList" items="${chartDatasourceForm.chartList}" itemValue="chartId" itemLabel="chartName" multiple="true"/>
										</div>
										<div class="chart_param_control">
											<input type="button" onclick="selectedChart(this)" value=">>"/>
											<br/>
											<input type="button" onclick="deselectedChart(this)" value="<<"/>
										</div>
										<div class="chart_param_used">
											<form:select id="chartUsedList" path="chartUsedList" multiple="true">
												<form:options items="${chartDatasourceForm.chartUsedList}" itemValue="chartId" itemLabel="chartName"/>
											</form:select>
										</div>
									</div>
									<br style='clear:both'>
								</div>
								<span class='labelChartDataSource'>User Authority</span>
								<div class="userAuthority selection_div inputFormChartDataSource">
									<div class="user_avaliable">
										<form:select id="userInitList" path="userInitList" items="${chartDatasourceForm.userList}" itemValue="userId" itemLabel="username" multiple="true"/>
									</div>
									<div class="user_control">
										<input type="button" onclick="selectedUser(this)" value=">>"/>
										<br/>
										<input type="button" onclick="deselectedUser(this)" value="<<"/>
									</div>
									<div class="user_used">
										<form:select id="userUsedList" path="userUsedList" multiple="true">
											<form:options items="${chartDatasourceForm.userUsedList}" itemValue="userId" itemLabel="username"/>
										</form:select>
									</div>
								</div>
								<br style='clear:both'>
								<!-- 
								<div class="chart_ds_foolter" style="text-align:center;">
									<br/>
									<input type="button" id='btnNewSubmit'  class="btn btn-primary"  onclick="formSubmit('new')" value="Save"/>
									&nbsp;
									<input type="button"  class="btn btn-primary"  onclick="formSubmit('update')" value="Update"/>
									&nbsp;
									<input type="button"  class="btn btn-primary"  onclick="formSubmit('delete')" value="Delete"/>
									<br/>
								</div>
								 -->
							
	                 		<!-- Main Content End -->
	                 		
	                 		<div  class='information'></div>
	                 	
	         
                <!-- content end -->
            </div>
            <div class="modal-footer">
            	<div id='btnSaveActionArea'>
	                <input type="button" id='btnNewSubmit'  class="btn btn-primary"  onclick="formSubmit('new')" value="Save"/>
	                <button class="btn btn-default" id="btnClear" type="button"><i class="fa fa-check-circle"></i> Cancel</button>
	                <!-- 
	                <button data-dismiss="modal" class="btn btn-default" type="button"><i class="fa fa-times-circle"></i> Close</button>
	                 -->
            	</div>
            	<div id='btnEditActionArea'>
	                <input type="button"  class="btn btn-primary"  onclick="formSubmit('update')" value="Update"/>
	                <input type="button" id='btnNewSubmit'  class="btn btn-primary"  onclick="formSubmit('new')" value="Save as"/>
	                <!-- 
	                <button class="btn btn-default" id="btnClear" type="button"><i class="fa fa-check-circle"></i> Clear</button>
	                 -->
            	</div>
            </div>
            </form:form>
            
        </div>
    </div>
</div>

<!-- Modal Confirm End -->

	
	<div class='empbedParamChartDataSource'></div>
	
	<div class="row-fluid ">
		<div class='span12' style='text-align:right;margin-bottom:5px;'>
			<button class='btn  btn-primary' id='btnAddDataSource'><i class='icon-plus'></i> Add</button>
		</div>
	</div>
	<div class="row-fluid ">
	
			<table id='tableDataSource' class="table table-striped table-bordered" width="100%" cellspacing="0">
				<thead>
					<tr>
						<th width="7%"><b>ID</b></th>
						<th width="70%"><b>Data Source Name</b></th>
						<th width="20%" style='text-align:center;'><b >Manage</b></th>
						
					</tr>
				</thead>
				<tbody id="listDataSource">
					
				</tbody>
			</table>
		</div>
		
		<br style='clear:both'>
		

	
	</div>
</body>
</html>