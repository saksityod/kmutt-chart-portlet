<%@ include file="/WEB-INF/jsp/include.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Filter</title>
<c:set var="ns"><portlet:namespace/></c:set>
<portlet:resourceURL var="selectedFilter" id="selectedFilter"></portlet:resourceURL>  
<portlet:actionURL var="formActionSubmit">
        <portlet:param name="action" value="doSubmit"/>
</portlet:actionURL>
<script type="text/javascript" src="<c:url value="/resources/js/jquery-1.11.2.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/resources/fusioncharts/js/fusioncharts.js" />"></script>
<script type="text/javascript" src="<c:url value="/resources/fusioncharts/js/themes/fusioncharts.theme.fint.js"/>"></script>
<script src="<c:url value="/resources/bootstrap/js/bootstrap.min.js"/>"></script>

<!-- include  start -->
<link rel="stylesheet" href="<c:url value="/resources/mloading/jquery.mloading.css"/>">
<script src="<c:url value="/resources/mloading/jquery.mloading.js"/>"></script>
<script src="<c:url value="/resources/data-table/jquery.dataTables.min.js"/>"></script>
<link rel="stylesheet" href="<c:url value="/resources/data-table/jquery.dataTables.min.css"/>">
<!-- include  end -->


<style type="text/css">
	#web_${ns} .filter_content label{ color:red; }
	#web_${ns} .filter_name select{ }
	#web_${ns} .filter_param select{ height:250px;width:280px;overflow-x:scroll}
	.filter_param>div{ display:inline-block;}
	.errorMessage{ color:red;}
	#filterF label{ display:inline-block; min-width:160px; vertical-align:top; font-weight:bold;	}
	
	.portlet-content {
    background: rgba(0, 0, 0, 0) linear-gradient(to top, #fff 0px, #f6f6f6 47%, #ededed 100%) repeat scroll 0 0;
    border-radius: 0;
    margin-bottom: 0;
	}
	
	.formFilter{
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
	
	
	.aui .portlet-content, .aui .portlet-minimized .portlet-content-container{
		padding: 15px 15px 15px 15px;
	}
	
	.aui .btn {
		font-size: 14px;
	 	padding: 4px 12px; 
		width: auto;
		margin-top: 0px;
		display: inline;
	}
	
		/* Large desktop Start#####################################*/
 @media (min-width: 1200px) { 
 
	.modal.large {
		    width: 90%;
		    margin-left:-45%;  
		    top:0px;
		}
		
	.modal.medium {
		    width: 70%;
		    margin-left:-35%;  
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
		    width: 70%;
		    margin-left:-35%;  
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
		    width: 70%;
		    margin-left:-35%;  
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
			console.log("Duplicate");
			dataReturn= false;
		}
	});
	return dataReturn;
	
}

var checkValidateFormFn = function(){
	var validate="";
	
	//filterName
	//label
	//global
	//sqlString
	//Require following fields:
//[* Connection Name,* Connection string,* Driver class,* Hibernate Dialect,* User,* Password]
	if(!checkDataDuplicateFn($("#web_${ns} #filterId option").get(),$("#web_${ns} #filterName").val())){
		validate+="Filter Name must be unique.\n";
	}
	if($("#web_${ns} #filterName").val()==""){
		validate+="Filter name is required. \n";
	}
	if($("#web_${ns} #label").val()==""){
		validate+="Label is required. \n";
	}
	if($("#web_${ns} #global").val()==""){
		validate+="Global is required. \n";
	}
	if($("#web_${ns} #sqlString").val()==""){
		validate+="SQL String is required. \n";
	}
	
	if(validate!=""){
		alert(validate);
		return false;
	}else{
		return true;
	}
	
}

	function getSelectValues(select) {
	  var result = [];
	  var options = select && select.options;
	  var opt;
	  for (var i=0, iLen=options.length; i<iLen; i++) {
	    opt = options[i];
	    if (opt.selected) {
	      result.push(opt.value || opt.text);
	    }
	  }
	  return result;
	}
	function doSelectParam(){
		var main = $("#web_${ns}>chart_ds_name>select");
		getSelectValues(main.get(0));
	}
	// control action
	function setName(current){
		requestFilterDetail(current.value);
	}
	function requestFilterDetail(filterId){
		$.ajax({
   	 		dataType: "json",
   	 		url:"<%=selectedFilter%>",
   	 		data: { filterId: filterId },
   	 		success:function(data){
   	 			console.log(data);
   	 			if(data["header"]["success"]>0){
   	 				//resetStateFilterList();
   	 				renderFilterDetail(data["content"]);
   	 			}
   	 			else{
   	 				$("#web_${ns} #sqlMessage").html("retrive filter detail error");
   	 			}
   	 		} 
   	 	});
	}
	function renderFilterDetail(data){
		//param_used
		var p_use_cnt = $("#web_${ns} .filter_param .filter_param_used select");
		p_use_cnt.empty();  //reset
		
		$("#web_${ns} #filterId").val(data.fid);
		
		$("#web_${ns} #filterName").val(data.fname);
		$("#web_${ns} #sqlString").val(data.sql);  
		$("#web_${ns} #type").val(data.valueType);
		var g =  data.global==1 ? true : false;
		$("#web_${ns} #global").prop("checked",g);
		var s = data.system==1? true : false;
		$("#web_${ns} #system").prop("checked",s);
		var auv = data.auto==1? true : false;
		$("#web_${ns} #autoFill").prop("checked",auv);
		
		$("#web_${ns} #defaultValue").val(data.defaultValue);
		$("#web_${ns} #label").val(data.label);
		$("#web_${ns} #connId").val(data.connId);
		// disable list by have used
		for(var i=0;i< data.fusedlist.length ; i++){
			var idx = data.fusedlist[i].fid;
			var opt = $("#web_${ns} .filter_param .filter_param_avaliable select option[value='"+idx+"']");
			opt.hide();
			var newopt = $("<option/>");
			newopt.attr("value",data.fusedlist[i].fid);
			newopt.html(data.fusedlist[i].fname);
			p_use_cnt.append(newopt);
		};
		
	}
	function selectedFilter(current){
		var selectedElement=$("#web_${ns} .filter_param .filter_param_avaliable select option:selected");
		var selected = [];
		selectedElement.each(function(){
			 selected.push(  [$(this).val(),$(this).html()]  );
			 $(this).hide();
			 $(this).prop("selected",false);
		});
		var renderSelectedElement=$("#web_${ns} .filter_param .filter_param_used select");
		for(var i=0;i<selected.length;i++){
			var newOpt = $("<option/>");
			newOpt.html( selected[i][1] );
			newOpt.attr("value",selected[i][0]);
			renderSelectedElement.append(newOpt);
		}//end for
	}
	function deselectedFilter(current){
		var selectedElement=$("#web_${ns} .filter_param .filter_param_used select option:selected");
		var selected = [];
		selectedElement.each(function(){
			 selected.push(  [$(this).val(),$(this).html()]  );
		     $(this).remove();
		});
		for(var i=0;i<selected.length;i++){
			var inx = selected[i][0];
			var opt = $("#web_${ns} .filter_param .filter_param_avaliable select option[value='"+inx+"']");
			opt.show();
			opt.prop("selected",true);
		}//end for
	}
	function checkValidSqlFilter(){
		var message = null;
		var invalidParam = [];
		var sql = $("#web_${ns} #sqlString").val();
		var usedParamName = [];
		var selectedFilter=$("#web_${ns} .filter_param .filter_param_used select option");
		selectedFilter.each(function(){
			usedParamName.push(this.innerHTML);
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
	function filterNewData(){
		if(checkValidateFormFn()==true){
		//if(checkDataDuplicateFn($("#web_${ns} #filterId option").get(),$("#web_${ns} #filterName").val())){
			var result = confirm("Do you want to save as this service ?");
			if (!result) {
			    return false;
			}
			//set id none
			$("#web_${ns} #filterId").val("");
			$("#web_${ns} #mode").val("add");
			
			$("#web_${ns} #sqlMessage").html(""); 
			var errorMessage = checkValidSqlFilter();
			if(errorMessage==null){
				var selectedFilter=$("#web_${ns} .filter_param .filter_param_used select option");
				selectedFilter.each(function(){
					$(this).prop("selected",true);
				});
				$("#web_${ns} form#filterF").submit();
			}else{
				
				alert("Selected none");
			}
		}
		/*	
		}else{
			alert("Filter Name is Duplicate.");
		}
		*/
	}
	function filterEditData(){
		var result = confirm("Do you want to update service ?");
		if (!result) {
		    return false;
		}
		if($("#web_${ns} #filterId").val()!=null && $("#web_${ns} #filterId").val()!="none" ){
			$("#web_${ns} #mode").val("edit");
			$("#web_${ns} #sqlMessage").html(""); 
			var errorMessage = checkValidSqlFilter();
			if(errorMessage==null){
				var selectedFilter=$("#web_${ns} .filter_param .filter_param_used select option");
				selectedFilter.each(function(){
					$(this).prop("selected",true);
				});
				$("#web_${ns} form#filterF").submit();
			}else{
				$("#web_${ns} #sqlMessage").html(errorMessage);
			}
		}else{
			alert("Selected none");
		}
	}
	function filterDelete(){
		var result = confirm("Do you want to delete service ?");
		if (!result) {
		    return false;
		}
		if($("#web_${ns} #filterId").val()!=null && $("#web_${ns} #filterId").val()!="none" ){
			$("#web_${ns} #mode").val("delete");
			$("#web_${ns} #sqlMessage").html(""); 
			var errorMessage = checkValidSqlFilter();
			if(errorMessage==null){
				$("#web_${ns} form#filterF").submit();
			}else{
				$("#web_${ns} #sqlMessage").html(errorMessage);
			}
		}else{
			alert("Selected none");
		}
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
	
	var clearFilterFormFn = function(){
		$("#web_${ns} select#filterUsedList").empty();
    	$("#web_${ns} input#filterName").val("");
    	$("#web_${ns} input#label").val("");
    	
    	$("#web_${ns} #type option:first").prop("selected",true);
    	$("#web_${ns} #defaultValue").val("");
    	$("#web_${ns} #global").prop("checked",false);
    	$("#web_${ns} #system").prop("checked",false);
    	$("#web_${ns} #autoFill").prop("checked",false);
    	$("#web_${ns} #connId option:first").prop("selected",true);
    	$("#web_${ns} textarea#sqlString").val("");
    	$("#web_${ns} #actionTitle").html("<b>Add</b>");  
}
	
	var listDataTableFn = function(){
		
		   
		var dataSourceListObject = $("#web_${ns} #filterId option").get();
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
		
		
		$("#web_${ns} #listDataFilter").html(dataSourceHTML);
		
		$("#web_${ns} .edit").click(function(){
			clearFilterFormFn();
			var id = this.id.split("-");
			id=id[1];
			var text=$(this).parent().prev().text();
			
			
			 $("#web_${ns} .empbedParamFilter").empty();
             $("#web_${ns} .empbedParamFilter").append("<input type='hidden' id='filterId' name='filterId' value='"+id+"'>");
             $("#web_${ns} .empbedParamFilter").append("<input type='hidden' id='filterName' name='filterName' value='"+text+"'>");
             $("#web_${ns} #filterId").val(id);
             requestFilterDetail(id);
             $("#web_${ns} #actionTitle").html("<b>Edit</b>");
             $("#web_${ns} #btnSaveActionArea").hide();
             $("#web_${ns} #btnEditActionArea").show();
             
             
			$("#web_${ns} #filterModal").modal();
			
			
			return false;
		});
		
		$("#web_${ns} .del").click(function(){
			clearFilterFormFn();
			var id = this.id.split("-");
			id=id[1];
			var text=$(this).parent().prev().text();
			
			 $("#web_${ns} .empbedParamFilter").empty();
             $("#web_${ns} .empbedParamFilter").append("<input type='hidden' id='filterId' name='filterId' value='"+id+"'>");
             $("#web_${ns} .empbedParamFilter").append("<input type='hidden' id='filterName' name='filterName' value='"+text+"'>");
             $("#web_${ns} #filterId").val(id);
             requestFilterDetail(id);
          	/*   
             $("#web_${ns} #actionTitle").html("<b>Edit</b>");
             $("#web_${ns} #btnSaveActionArea").hide();
             $("#web_${ns} #btnEditActionArea").show();
			 $("#web_${ns} #filterModal").modal();
			*/
			filterDelete();
			
			
			
			
			return false;
		});

	}
	
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
	
	
	$(document).ready(function(){
		
		$( document ).ajaxStart(function() {
			$("body").mLoading();
		});
		$( document ).ajaxStop(function() {
			$("body").mLoading('hide');
		});
		
		
		var controlMessage = "${filterForm.message}";
		if(controlMessage.length>1){
			alert(controlMessage);
		}
		listDataTableFn();
		
		//binding data table start
	    $('#web_${ns} #tableFilter').DataTable();
	    $("#web_${ns} select[name='tableFilter_length']").css({"width":"60px","margin-bottom":"0px"});
	    $("#web_${ns} input[type='search']").css({"width":"300px","margin-bottom":"0px"});
	    //binding data table end
	    //add data source
	    $("#web_${ns} #btnAddFilter").click(function(){
	    	 clearFilterFormFn();
	    	 $("#web_${ns} #filterModal").modal('show');
	    	 $("#web_${ns} #btnSaveActionArea").show();
             $("#web_${ns} #btnEditActionArea").hide();
	    	
	    });
	    //clear
	    $("#web_${ns} #btnClear").click(function(){
	    	clearFilterFormFn();
	    	return false;
	    })
		
	    //sorting option start
		sortingOptionByNameFn("#web_${ns} select#initialFilterList option");
	});
</script>
</head>
<body>
	<div id="web_${ns}" class="filter_content">
	
	
	
	
	
<!-- Modal Confirm Start -->
<div aria-hidden="true" role="dialog" tabindex="-1" id="filterModal" class="modal inmodal in medium" style="display: none;">
    <div class="modal-dialog modal-lg">
    <div class="modal-content animated bounceInRight">
            <div class="modal-header ">
                <button data-dismiss="modal" class="close" type="button"><span aria-hidden="true">×</span><span class="sr-only"></span></button>
                <h5 class="modal-title"><span id='actionTitle'></span> Filter</h5>
            </div>
            <form:form id="filterF" modelAttribute="filterForm" method="post" name="filterForm" action="${formActionSubmit}" enctype="multipart/form-data">
            <div class="modal-body formFilter">

	                 		<!-- Main Content Start -->
							                 		
							
								<form:hidden id="mode" path="mode" />
								<div class="filter_name">
									<label style='display:none;'>FilterList</label>
									<form:select style="min-width:45%;display:none;" id="filterId" path="filterId" onchange="setName(this)">
										<!--<form:option value="0" label=""/>-->
										<form:options items="${filterForm.filters}" itemValue="filterId" itemLabel="filterName"/>
									</form:select>
									
									<label><font color="red" style='font-size:16px; font-weight:bold;'>*</font> FilterName</label>
									<form:input style="width:22%" id="filterName" path="filterName"/>
									<br/>
									<label><font color="red" style='font-size:16px; font-weight:bold;'>*</font> Label</label>
									<form:input style="width:22%" id="label" path="label"/>
								</div>
								<div class="filter_properties" style="padding-bottom:15px;">
									<label style='margin-right:4px'> &nbsp;&nbsp;Input Type</label><form:select path="type" items="${filterForm.types}" style="160px;margin-right:80px;"></form:select>
									<label style='text-align:left;padding-top:5px;min-width:56px'>Default </label> <form:input style="width:158px" id="defaultValue" path="defaultValue"/>
									<br/><label><font color="red" style='font-size:16px; font-weight:bold;'>*</font> Advance</label>
									&nbsp;<form:checkbox id="global" path="global" />&nbsp;global&nbsp;
									&nbsp;<form:checkbox id="system" path="system" />&nbsp;system&nbsp;
									&nbsp;<form:checkbox id="autoFill" path="autoFill" />&nbsp;auto fill&nbsp; 
								</div>
								<div class="filter_data">
									<label>&nbsp;&nbsp; Database Connection</label>
									<form:select id="connId" path="selectedConnection" items="${filterForm.connections}" itemValue="connId" itemLabel="connName" style="160px;"  multiple="false"></form:select>
									<br/><label><font color="red" style='font-size:16px; font-weight:bold;'>*</font> Sql Query</label>
									<form:textarea id="sqlString"  style="min-width:630px;vertical-align:text-top;" path="sqlString" rows="5" />
									<p id="sqlMessage" class="errorMessage"></p>
								</div>
								<div class="filter_param">
									<label>&nbsp;&nbsp; Parameter</label>
									<div class="filter_param_avaliable">
										<form:select path="initialFilterList" items="${filterForm.filterList}" itemValue="filterId" itemLabel="filterName" multiple="true"/>
									</div>
									<div class="filter_param_control">
										<input type="button" onclick="selectedFilter(this)" value="Select"/>
										<br/>
										<input type="button" onclick="deselectedFilter(this)" value="Deselect"/>
									</div>
									<div class="filter_param_used">
										<form:select id="filterUsedList" path="filterUsedList" multiple="true">
											<form:options items="${filterForm.filterUsedList}" itemValue="filterId" itemLabel="filterName"/>
										</form:select>
									</div>
								</div>
								
								
								<div class="filter_footer" style='text-align:center;'>
									<br/>
									<p id="submitMessage"></p>
									<!-- 
									<input type="button"  class="btn btn-primary"  onclick="filterNewData()" value="Save as"/>
									<input type="button"  class="btn btn-primary"  onclick="filterEditData()" value="Update"/>
									<input type="button"  class="btn btn-primary"  onclick="filterDelete()" value="Delete"/>
									<br/>
									 -->
								</div>
								
							
	                 		<!-- Main Content End -->
	                 		
	                 		<div  class='information'></div>
	                 	
	         
                <!-- content end -->
            </div>
            <div class="modal-footer">
            	<div id='btnSaveActionArea'>
	                <input type="button" id='btnNewSubmit'  class="btn btn-primary"  onclick="filterNewData()" value="Save"/>
	                <button class="btn btn-default" id="btnClear" type="button"><i class="fa fa-check-circle"></i> Cancel</button>
            	</div>
            	<div id='btnEditActionArea'>
	                <input type="button"  class="btn btn-primary"  onclick="filterEditData()" value="Update"/>
	                <input type="button" id='btnNewSubmit'  class="btn btn-primary"  onclick="filterNewData()" value="Save as"/>
            	</div>
            </div>
            </form:form>
            
        </div>
    </div>
</div>

<!-- Modal Confirm End -->

	
	
	
	
	<!-- table area -->
	<div class='empbedParamFilter'></div>
	
	<div class="row-fluid ">
		<div class='span12' style='text-align:right;margin-bottom:5px;'>
			<button class='btn  btn-primary' id='btnAddFilter'><i class='icon-plus'></i> Add</button>
		</div>
	</div>
	<div class="row-fluid ">
		<table id='tableFilter' class="table table-striped table-bordered" width="100%" cellspacing="0">
			<thead>
				<tr>
					<th width="7%"><b>ID</b></th>
					<th width="70%"><b>Filter Name</b></th>
					<th width="20%" style='text-align:center;'><b >Manage</b></th>
					
				</tr>
			</thead>
			<tbody id="listDataFilter">
				
			</tbody>
		</table>
	</div>
		
	<br style='clear:both'>
	<!-- table area -->	
		
	</div>
</body>
</html>