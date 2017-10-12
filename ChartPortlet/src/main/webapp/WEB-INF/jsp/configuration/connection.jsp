<%@ include file="/WEB-INF/jsp/include.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Connection</title>
<c:set var="ns"><portlet:namespace/></c:set>
<portlet:resourceURL var="getConnection" id="getConnection"></portlet:resourceURL>  
<portlet:actionURL var="formActionSave">
        <portlet:param name="action" value="doSave"/>
</portlet:actionURL>
<script type="text/javascript" src="<c:url value="/resources/js/jquery-1.11.2.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/resources/fusioncharts/js/fusioncharts.js" />"></script>
<script type="text/javascript" src="<c:url value="/resources/fusioncharts/js/themes/fusioncharts.theme.fint.js"/>"></script>
<script src="<c:url value="/resources/bootstrap/js/bootstrap.min.js"/>"></script>

<link rel="stylesheet" href="<c:url value="/resources/mloading/jquery.mloading.css"/>">
<script src="<c:url value="/resources/mloading/jquery.mloading.js"/>"></script>

<!-- include data table start -->
<script src="<c:url value="/resources/data-table/jquery.dataTables.min.js"/>"></script>
<link rel="stylesheet" href="<c:url value="/resources/data-table/jquery.dataTables.min.css"/>">
<!-- include data table end -->

<style type="text/css">
	.errorMessage{ color:red;}
	
	.aui .form-horizontal .control-group{
		margin-bottom: 0;
	}
	.portlet-content {
    background: rgba(0, 0, 0, 0) linear-gradient(to bottom, #fff 0px, #f6f6f6 47%, #ededed 100%) repeat scroll 0 0;
    border-radius: 0;
    margin-bottom: 0;
	}
	.aui .form-horizontal .control-label{
	 width: 140px;
	 text-align: left;
	 font-weight:bold;
	}
	
	
	.aui .form-horizontal .controls {
	    margin-left: 143px;
	}
	.aui .portlet-content, .aui .portlet-minimized .portlet-content-container{
		padding: 15px 15px 15px 15px;
	}
	
	.labelConnection{
		width:160px;
		float:left;
		padding-top:5px;
		font-weight:bold;
	}
	
	.inputFormConnection{
		/*width:300px;*/
		float:left;
		padding-top:5px;
	}
	
	.aui label {
    font-weight:bold;
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
 
	
	.areaBtn{
		padding-left:160px;
	}
	 
  }
  /* Large desktop End######################################*/
  
  /*  desktop Start#########################################*/
 @media (min-width: 980px) and (max-width: 1199px) {
 
 	.labelConnection{
		width:100%;
	}
	.areaBtn{
		padding-left:0px;
	}
 	
  }
 /*  desktop End############################################*/
 
 /* Portrait tablet to landscape and desktop Start##########*/
 @media (min-width: 768px) and (max-width: 979px) {
 
	.labelConnection{
		width:100%;
	}

  }
 /* Portrait tablet to landscape and desktop End############*/ 
 
 /* Landscape phone to portrait tablet Start################*/
 @media (max-width: 767px) { 
 	
 	.labelConnection{
		width:100%;
	}
 
  }
 /* Landscape phone to portrait tablet End##################*/ 
 
 /* Landscape phones and down Start#########################*/
 @media (max-width: 480px) { 
 	
 	.labelConnection{
		width:100%;
	}
 

  }
  /* Landscape phones and down End##########################*/
	
</style>
<script type="text/javascript">
	
$( document ).ajaxStart(function() {
	$("body").mLoading();
});
$( document ).ajaxStop(function() {
	$("body").mLoading('hide');
});

	function connNew(){
		//console.log(checkDataDuplicateFn($("#web_${ns} #connId option").get(),$("#web_${ns} #connName").val()));
		if(checkDataDuplicateFn($("#web_${ns} #connId option").get(),$("#web_${ns} #connName").val())){
			$("#web_${ns} #mode").val("add");
			var result = confirm("Do you want to save as this connection ?");
			if (!result) {
			    return false;
			}
			connFormSubmit();
		}else{
			alert("Connection Name is Duplicate.");
		}
	}
	function connUpdate(){
		$("#web_${ns} #mode").val("edit");
		var result = confirm("Do you want to update this connection ?");
		if (!result) {
		    return false;
		}
		connFormSubmit();
	}
	function connDelete(){
		$("#web_${ns} #mode").val("delete");
		var result = confirm("Do you want to delete this connection ");
		if (!result) {
		    return false;
		}
		connFormSubmit();
	}
	function connFormSubmit(){
		$("#web_${ns} #submitMessage").html(""); //reset
		var invalid = [];
		$("#web_${ns} .detail").each(function(){
			if(this.value ==""){
				invalid.push($(this).prev("label").html());
			}	
		});
		if(invalid.length<=0){
			$("#connectionForm").submit();
		}else{
			var message = "Require following fields:<br><font color='red'> ["+invalid.join(",")+"]</font>";
			$("#web_${ns} #submitMessage").html(message);
		}
	}
	
	function recallConnection(connId){
		$("#web_${ns} .detail").val("");
		$.ajax({
   	 		dataType: "json",
   	 		url:"<%=getConnection%>",
   	 		data: { connId: connId },
   	 		async:false,
   	 		success:function(data){
   	 			console.log(data);
   	 			if(data["header"]["success"]>0){
   	 				renderConnDetail(data["content"]);
   	 			}
   	 			else{
   	 				$("#web_${ns} #sqlMessage").html("retrive connection detail not complete");
   	 			}
   	 		},fail:function(data){
   	 			$("#web_${ns} #sqlMessage").html("retrive connection detail error");
   	 		} 
   	 	});
	}
	
	function renderConnDetail(data){
		$("#web_${ns} #connName").val(data["connName"]);
		$("#web_${ns} #connString").val(data["connString"]);
		$("#web_${ns} #driverClass").val(data["driverClass"]);
		$("#web_${ns} #dialect").val(data["dialect"]);
		$("#web_${ns} #username").val(data["username"]);
		$("#web_${ns} #password").val(data["password"]);
		
	}
	
	
	
	var clearConnectionFormFn = function(){
		
		$("#web_${ns} #connName").val("");
		$("#web_${ns} #connString").val("");
		$("#web_${ns} #driverClass").val("");
		$("#web_${ns} #dialect").val("");
		$("#web_${ns} #username").val("");
		$("#web_${ns} #password").val("");
		$("#web_${ns} #submitMessage").html("");
		
    	$("#web_${ns} #actionTitle").html("<b>Add</b>");
    	
    	
         
}
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
	
	var listDataTableFn = function(){
		
		   
		var dataSourceListObject = $("#web_${ns} #connId option").get();
		var dataSourceHTML="";
		
		$.each(dataSourceListObject,function(index,indexEntry){
			if($(indexEntry).val()!=0){
			dataSourceHTML+="<tr>";
				//dataSourceHTML+="<td>"+$(indexEntry).val()+"</td>";
				dataSourceHTML+="<td>"+$(indexEntry).text()+"</td>";
				dataSourceHTML+="<td style='text-align:center;'>";
				dataSourceHTML+="<a id=\"edit-"+$(indexEntry).val()+"\" class=\"btn btn-mini edit\" href=\"#\"><i class=\"icon-pencil\"></i> </a>";
				dataSourceHTML+="<a id=\"del-"+$(indexEntry).val()+"\" style=\"margin-left:3px;\" class=\"btn btn-mini del\" href=\"#\"><i class=\"icon-trash\"></i> </a>";
				dataSourceHTML+="</td>";
			dataSourceHTML+="</tr>";
			}
		});
		
		
		$("#web_${ns} #listDataConnection").html(dataSourceHTML);
		
		$("#web_${ns} .edit").click(function(){
			clearConnectionFormFn();
			var id = this.id.split("-");
			id=id[1];
			var text=$(this).parent().prev().text();
			
			
			 $("#web_${ns} .empbedParamConnection").empty();
             $("#web_${ns} .empbedParamConnection").append("<input type='hidden' id='connectionID' name='connectionID' value='"+id+"'>");
             $("#web_${ns} .empbedParamConnection").append("<input type='hidden' id='connectionName' name='connectionName' value='"+text+"'>");
             $("#web_${ns} #connId").val(id);
             recallConnection(id);
             $("#web_${ns} #actionTitle").html("<b>Edit</b>");
             $("#web_${ns} #btnSaveActionArea").hide();
             $("#web_${ns} #btnEditActionArea").show();
             
             
			$("#web_${ns} #connectionModal").modal();
			
			
			return false;
		});
		
		$("#web_${ns} .del").click(function(){
			clearConnectionFormFn();
			var id = this.id.split("-");
			id=id[1];
			var text=$(this).parent().prev().text();
			
			 $("#web_${ns} .empbedParamConnection").empty();
             $("#web_${ns} .empbedParamConnection").append("<input type='hidden' id='connectionID' name='connectionID' value='"+id+"'>");
             $("#web_${ns} .empbedParamConnection").append("<input type='hidden' id='connectionName' name='connectionName' value='"+text+"'>");
             $("#web_${ns} #connId").val(id);
             recallConnection(id);
          	/*   
             $("#web_${ns} #actionName").html("<b>Edit</b>");
             $("#web_${ns} #btnSaveActionArea").hide();
             $("#web_${ns} #btnEditActionArea").show();
			 $("#web_${ns} #connectionModal").modal();
			*/
			// formSubmit('delete');
			connDelete();
			
			
			
			
			
			return false;
		});
		

	}
	
	
	
	$(document).ready(function(){
		var controlMessage = "${connectionForm.message}";
		if(controlMessage.length>1){
			alert(controlMessage);
		}
		
		
		//list data table start
		listDataTableFn();
		
		 //add data source
	    $("#web_${ns} #btnAddConnection").click(function(){
	    	clearConnectionFormFn();
	    	$("#web_${ns} #connectionModal").modal('show');
	    	$("#web_${ns} #btnSaveActionArea").show();
            $("#web_${ns} #btnEditActionArea").hide();
	    });
	    $("#web_${ns} #btnClear").click(function(){
	    	clearConnectionFormFn();
	    	return false;
	    })
		
	});
</script>
</head>
<body >
<div class='row-fluid'>
	
	<div class='span6 offset3'>
		<div id="web_${ns}" style='display:block;'>
		
		<!-- Modal Confirm Start -->

<div aria-hidden="true" role="dialog" tabindex="-1" id="connectionModal" class="modal inmodal in large" style="display: none;">
    <div class="modal-dialog modal-lg">
    <div class="modal-content animated bounceInRight">
            <div class="modal-header ">
                <button data-dismiss="modal" class="close" type="button"><span aria-hidden="true">×</span><span class="sr-only"></span></button>
                <h5 class="modal-title"><span id='actionTitle'></span> Connection</h5>
            </div>
            <form:form id="connectionForm" modelAttribute="connectionForm" method="post"  name="connectionForm" action="${formActionSave}" enctype="multipart/form-data">
            <div class="modal-body formChartDataSource">

	                 		<!-- Main Content Start -->
							<form:hidden id="mode" path="mode"/>
							<label style='display:none;' class='labelConnection'>Connection List</label>
							<form:select  id="connId" path="model.connId"  class='span12 inputFormConnection'  onchange="recallConnection(this)" style="width:337px; display:none;" >
								<form:option value="" label=""/>
					   			<form:options items="${connectionForm.conns}" itemValue="connId" itemLabel="connName"/>
							</form:select>
							
							<label class='labelConnection'><font color="red" style='font-size:16px; font-weight:bold;'>*</font> Connection Name</label><form:input id="connName" class="detail inputFormConnection" type="text" path="model.connName" style="width:320px;" /><br/>
							<label class='labelConnection'><font color="red" style='font-size:16px; font-weight:bold;'>*</font> Connection string</label><form:input id="connString" type="text" class="detail inputFormConnection" path="model.connString" style="width:320px;" /><br/>
							<label class='labelConnection'><font color="red" style='font-size:16px; font-weight:bold;'>*</font> Driver class</label><form:input id="driverClass" type="text" class="detail inputFormConnection" path="model.driverClass" style="width:320px;" /><br/>
							<label class='labelConnection'><font color="red" style='font-size:16px; font-weight:bold;'>*</font> Hibernate Dialect</label><form:input id="dialect" type="text" class="detail inputFormConnection" path="model.dialect" style="width:320px;" /><br/>
							<label class='labelConnection'><font color="red" style='font-size:16px; font-weight:bold;'>*</font> User</label><form:input id="username" type="text" class="detail inputFormConnection" path="model.username" style="width:320px;" /><br/>
							<label class='labelConnection'><font color="red" style='font-size:16px; font-weight:bold;'>*</font> Password</label><form:input id="password" type="password" class="detail inputFormConnection" path="model.password" style="width:320px;"/><br/>
							<p id="submitMessage"></p>
							<br style='clear:both'/>
							<!-- 
							<div class='areaBtn'>
							<input type="button" class="btn btn-primary" onclick="connNew()" value="Save as"/>
							<input type="button" class="btn btn-primary" onclick="connUpdate()" value="Update"/>
							<input type="button" class="btn btn-primary" onclick="connDelete()" value="Delete"/> 
							</div>
							 -->		
	                 		<!-- Main Content End -->
	                 		
	                 		<div  class='information'></div>
	                 	
	         
                <!-- content end -->
            </div>
            <div class="modal-footer">
            	<div id='btnSaveActionArea'>
	                <input type="button" id='btnNewSubmit'  class="btn btn-primary"  onclick="connNew()" value="Save"/>
	                <button class="btn btn-default" id="btnClear" type="button"><i class="fa fa-check-circle"></i> Cancel</button>
            	</div>
            	<div id='btnEditActionArea'>
	                <input type="button"  class="btn btn-primary"  onclick="connUpdate()" value="Update"/>
	                <input type="button" id='btnNewSubmit'  class="btn btn-primary"  onclick="connNew()" value="Save as"/>
            	</div>
            </div>
            </form:form>
            
        </div>
    </div>
</div>

<!-- Modal Confirm End -->
		
		
		
		
		<div class='empbedParamConnection'></div>
	
		<div class="row-fluid ">
			<div class='span12' style='text-align:right;margin-bottom:5px;'>
				<button class='btn  btn-primary' id='btnAddConnection'><i class='icon-plus'></i> Add</button>
			</div>
		</div>
		<div class="row-fluid ">
		
				<table id='tableConnection' class="table table-striped table-bordered" width="100%" cellspacing="0">
					<thead>
						<tr>
							<!-- <th width="7%"><b>ID</b></th> -->
							<th width="80%"><b>Connection Name</b></th>
							<th width="20%" style='text-align:center;'><b >Manage</b></th>
							
						</tr>
					</thead>
					<tbody id="listDataConnection">
						
					</tbody>
				</table>
			</div>
		
			<br style='clear:both'>
		
		
		</div>
	</div>
	
	
</div>
<!-- new design end --> 
</body>
</html>