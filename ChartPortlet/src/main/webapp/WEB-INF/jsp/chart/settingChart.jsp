<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ include file="/WEB-INF/jsp/include.jsp"%>
<c:set var="ns">
	<portlet:namespace />
</c:set>
<portlet:actionURL var="formAction">
	<portlet:param name="action" value="doSubmit" />
</portlet:actionURL>
<portlet:resourceURL var="loadChartProp" id="loadChartProp"></portlet:resourceURL>
<portlet:resourceURL var="regetDatasource" id="regetDatasource"></portlet:resourceURL> 
<portlet:resourceURL var="findChartById" id="findChartById"></portlet:resourceURL>
<portlet:resourceURL var="loadServiceFilter" id="loadServiceFilter"></portlet:resourceURL>

<html>
<head>
<title></title>
<script type="text/javascript" src="<c:url value="/resources/js/jquery-1.11.2.min.js"/>"></script>
<script src="//cdn.ckeditor.com/4.5.4/basic/ckeditor.js"></script>
<style>
.border_chart_setting {
	border-style: solid;
	border-width: 1px;
	border-color: #1993BF;
	padding: 10px;
}

.aui select {
	width: auto !important;
	max-width: 98%;
}
</style>
</head>


<body>
	<form:form id="${ns}chartSettingForm" modelAttribute="chartSettingForm"
		method="post" name="chartSettingFormm" action="${formAction}"
		enctype="multipart/form-data">
		<b>Chart Type :</b>
		<form:select path="chartType" id="${ns}chartType"
			onchange="${ns}changeChartEvent()">
			<form:options items="${chartList}" itemValue="chartType"
				itemLabel="chartName" />
		</form:select>
		
		<form:hidden path="chartInstance"></form:hidden>
		<br />
		<b>Data Source</b>
		<br />
		<div class="border_chart_setting">
			&nbsp;&nbsp;
			<form:radiobutton name="dataSourceType" path="dataSourceType"
				value="1" />
			<b>Services: </b>
			<form:select path="dataSource" id="${ns}dataSource">
				<form:options items="${serviceList}" itemValue="serviceId"
					itemLabel="serviceName" />
			</form:select>

			<span style="padding-left: 10px"><button
					class="btn btn-default" id="${ns}loadServiceBtn" type="button"
					onclick="${ns}loadServiceFilter()">Load Filter</button></span><br />
			<br /> &nbsp;&nbsp;
			<form:radiobutton name="dataSourceType" path="dataSourceType"
				value="2" />
			<b>Ad hoc Data </b>&nbsp;&nbsp;
			<button class="btn btn-default" onclick="${ns}findChartById('1')"
				type="button">Load Default</button>
			<br />
			<form:textarea path="dataAdhoc" id="${ns}dataAdhoc"
				cssStyle="width: 451px; height: 91px;"></form:textarea>
		</div>
		<br />
		
		&nbsp;&nbsp;<form:checkbox path="showFilter" value="1" />&nbsp;<b>Show
			Filter on Front Page</b>
		<br />
		<br />
		<b id="${ns}filter_element">Filters for this chart </b>
		<br />
		<c:if test="${not empty  chartFilterInstance}">
			<div id="${ns}filterMapping_element" class="border_chart_setting">
		</c:if>
		<c:if test="${empty  chartFilterInstance}">
			<div id="${ns}filterMapping_element">
		</c:if>
		<div>
		<span id="${ns}filter_section"> <c:if
				test="${not empty  chartFilterInstance}">
				<table>
					<c:forEach items="${chartFilterInstance}" var="filter"
						varStatus="loop">
						<tr>
							<td><c:choose>
									<c:when test="${filter.filterM.activeFlag==1}">
										<input id="filter_active_${filter.filterM.filterId}"
											name="filter_active_${filter.filterM.filterId}"
											type="checkbox" value="1" checked /> &nbsp;${filter.filterM.title}&nbsp;&nbsp;&nbsp;
					</c:when>
									<c:otherwise>
										<input id="filter_active_${filter.filterM.filterId}"
											name="filter_active_${filter.filterM.filterId}"
											type="checkbox" value="1" /> &nbsp;${filter.filterM.title}&nbsp;&nbsp;&nbsp;
					</c:otherwise>
								</c:choose> <!-- select filter item --> <select
								id="filter_selection_${filter.filterM.filterId}"
								name="filter_selection_${filter.filterM.filterId}">
									<c:forEach items="${filter.filterM.filterValues}" var="item"
										varStatus="loop2">
										<c:choose>
											<c:when
												test="${filter.filterM.selectedValue.equals(item.keyMapping)}">
												<option value="${item.keyMapping}" selected>${item.valueMapping}</option>
											</c:when>
											<c:otherwise>
												<option value="${item.keyMapping}">${item.valueMapping}</option>
											</c:otherwise>
										</c:choose>
									</c:forEach>
							</select> &nbsp;&nbsp;${filter.filterM.filterName}</td>
							<td></td>
						</tr>
					</c:forEach>
				</table>
			</c:if>
		</span>
		</div>
		<br />
		<br />
		<div style="display: none">
			&nbsp;&nbsp;
			<form:checkbox path="filterRole" value="1" />
			&nbsp;<b>Enable Role Filter</b><br />
		</div>
		<%--
		<form:input path="filterRole"  cssStyle="width: 451px;"/>

		<br/>
		--%>
		<br />
		<br />
		<b>Chart</b>
		<br />
		<div class="border_chart_setting">
			&nbsp;&nbsp; Title:
			<form:input path="chartTitle" />
			&nbsp;&nbsp;
			<form:checkbox path="titleFromFilter" value="1" />
			&nbsp;Use From Filter<br /> &nbsp;&nbsp; Sub Title:
			<form:input path="chartSubTitle" />
			&nbsp;&nbsp;
			<form:checkbox path="subFromFilter" value="1" />
			&nbsp;Use From Filter<br /> &nbsp;&nbsp; Height:
			<form:input path="chartHeight" cssStyle="width:100px" />
		</div>
		<br />
		<br />
		<b>Override Property</b> 
			&nbsp;&nbsp;<button class="btn btn-default"
			onclick="${ns}changeChartEvent()" type="button">Load Default</button>
		<br />
		<div class="border_chart_setting">
			<form:textarea path="chartJson" id="${ns}chartJson"
				cssStyle="height: 107px; width: 451px;"></form:textarea>
			<br />
		</div>
		<br />
		<b>Comment: </b>
		<br />
		<form:textarea path="comment" id="${ns}comment"
			cssStyle="width: 451px; height: 52px;"></form:textarea>
		<br />
		<script>
			// Replace the <textarea id="editor1"> with a CKEditor
			// instance, using default configuration.
			CKEDITOR.replace( '${ns}comment' );
		</script>
		<br />
		<b>Link to: </b>
		<br />
		<form:input path="linkTo" cssStyle="width: 451px;"></form:input>
		<br />
		<button class="btn btn-primary" type="submit">Submit</button>
	</form:form>

	<script>
		function ${ns}changeChartEvent(){
			${ns}_loadDatasourceByChartType();
			${ns}_loadChartProp();
		}
		
		
		function ${ns}_loadDatasourceByChartType(){
			var chartType=$('#${ns}chartType').val();
			$("select#${ns}dataSource").empty();
			$.ajax({
				dataType: "json",
				url:"<%=regetDatasource%>",
				data: { chartType : chartType  },
				success:function(data){
					if(data["header"]["success"]>0){
						for(var ixs=0;ixs<data["content"]["data"].length;ixs++){
							var opt = $("<option></option>").html(data["content"]["data"][ixs]["desc"]);
							opt.attr("value",data["content"]["data"][ixs]["value"]);
							$("select#${ns}dataSource").append(opt);
						}
					}
				}
			});
		}
		
		
		function ${ns}_loadChartProp(){ 
			var chartType=$('#${ns}chartType').val();
			$("#${ns}chartJson").val("");
			$.ajax({
				dataType: "json",
				url:"<%=loadChartProp%>",
				data: { chartType : chartType  },
				success:function(data){
					if(data["header"]["success"]>0){
						 $("#${ns}chartJson").val(data["content"]);
					}
				} 
			});
		}
		
		
		function ${ns}loadServiceFilter(){
			var serviceId=$('#${ns}dataSource').val();
			var containerName = "${ns}filter_section";
			$("#"+containerName).empty();
			$.ajax({
				dataType: "json",
				url:"<%=loadServiceFilter%>",
				data: { serviceId : serviceId },
				success:function(data){
					if(data["header"]["success"]>0){
						$("#${ns}filterMapping_element").addClass("border_chart_setting")
						var table = $('<table></table>');
						for(i = 0 ; i< data["data"].length ;i++){
							var input = $('<input type="checkbox" value="1" />');
							input.attr("id","filter_active_"+data["data"][i]["id"]);
							input.attr("name","filter_active_"+data["data"][i]["id"]);
							var tr = $('<tr></tr>');
							var td = $('<td></td>');
							td.append(input);
							td.append(" "+data["data"][i]["name"]+"  ");
							tr.append(td);
							var td2 = $('<td></td>');
							var select = $('<select></select>');
							for(var j = 0 ; j<data["data"][i]["item"].length ;j++){
								var opt = $('<option></option>');
								opt.attr("value",data["data"][i]["item"][j].value);
								opt.html(data["data"][i]["item"][j]["display"]);
								select.append(opt);
							}
							td2.append(select);
							tr.append(td2);
							table.append(tr);
						}
						$("#"+containerName).append(table);
					}else{
						$("#${ns}filterMapping_element").removeClass("border_chart_setting");
					}
				} 
			});
		}
		
		
		function ${ns}findChartById(type){
			var chartType=$('#${ns}chartType').val();			
			$.ajax({
				dataType: "json",
				url:"<%=findChartById%>",
				data: { chartType : chartType  },
				success:function(data){
					console.log(data);
					if(data["header"]["success"]>0){
						 $("#${ns}dataAdhoc").text(data["content"]["data"][0]["dataJson"]);
						 
					}
				}
			});
		}

		
		$(document).ready(function(){
			//interface event handle 
			$( '#${ns}chartSettingForm input[name="dataSourceType"]' ).change(function(){
				if(this.value==2){  /// adhoc
					$("#${ns}loadServiceBtn").prop( "disabled", true );
				}else{
					$("#${ns}loadServiceBtn").prop( "disabled", false );
				}
			});
		});
	</script>
</body>
</html>