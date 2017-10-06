package th.ac.kmutt.chart.portlet;


import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.support.ByteArrayMultipartFileEditor;
import org.springframework.web.portlet.bind.PortletRequestDataBinder;
import org.springframework.web.portlet.bind.annotation.ActionMapping;
import org.springframework.web.portlet.bind.annotation.ResourceMapping;

import th.ac.kmutt.chart.constant.DefaultConstant;
import th.ac.kmutt.chart.form.GlobalFilterForm;
import th.ac.kmutt.chart.model.CommentM;
import th.ac.kmutt.chart.model.FilterInstanceM;
import th.ac.kmutt.chart.model.FilterM;
import th.ac.kmutt.chart.model.FilterValueM;
import th.ac.kmutt.chart.service.ChartService;

import javax.portlet.ActionResponse;
import javax.portlet.PortletPreferences;
import javax.portlet.PortletRequest;
import javax.portlet.PortletSession;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;
import javax.print.attribute.HashAttributeSet;
import javax.servlet.http.HttpServletRequest;
import javax.xml.namespace.QName;

import java.io.IOException;
import java.util.*;

@Controller("globalFilterController")
@RequestMapping("VIEW")
@SessionAttributes({"globalFilterForm"})
public class GlobalFilterController {

    private static final Logger logger = Logger.getLogger(GlobalFilterController.class);

    @Autowired
    @Qualifier("chartServiceWSImpl")
    private ChartService chartService;
    @InitBinder
    public void initBinder(PortletRequestDataBinder binder, PortletPreferences preferences) {
        logger.debug("initBinder");
        binder.registerCustomEditor(byte[].class, new ByteArrayMultipartFileEditor());
        //String a[] = new String[]{"ntcfaq.nfaqName"};
        final String[] ALLOWED_FIELDS = {"researchGroupM.researchGroupId", "researchGroupM.createdBy", "researchGroupM.createdDate",
                "researchGroupM.groupCode", "researchGroupM.permissions", "researchGroupM.updatedBy",
                "researchGroupM.updatedDate", "researchGroupM.groupTh", "researchGroupM.groupEng", "mode",
                "command", "keySearch", "pageNo", "paging.pageSize", "ids", "tab", "filter","instanceId","filterGlobals","aoe_global"};

        binder.setAllowedFields(ALLOWED_FIELDS);
    }

    @RequestMapping("VIEW") 
    public String showFilter(PortletRequest request, Model model) {
    	ThemeDisplay themeDisplay = (ThemeDisplay) request
                .getAttribute(WebKeys.THEME_DISPLAY);
        String instanceId=themeDisplay.getPortletDisplay().getInstanceId();
        PortletSession portletSession = request.getPortletSession();  
        portletSession.setAttribute("instanceId" , instanceId,PortletSession.PORTLET_SCOPE);
        GlobalFilterForm filterForm = null;
        if (model.containsAttribute("globalFilterForm")) {
        	filterForm = (GlobalFilterForm) model.asMap().get("globalFilterForm");
        	if(filterForm.getMode()!=null ){
        		if(filterForm.getMode().equalsIgnoreCase("NEW")){ // from setting mode
	        	
	            	filterForm = new GlobalFilterForm();
	            	FilterInstanceM fim = new FilterInstanceM();
	            	fim.setInstanceId(instanceId);
	            	List<FilterInstanceM>  fins = chartService.getFilterInstanceWithItem(fim);
	            	if(fins!=null && fins.get(0)!=null & fins.get(0).getFilterList()!=null){
	            		filterForm.setFilterList(fins.get(0).getFilterList());
	            	}
        		}
        	}// handle 
        } else {
            filterForm = new GlobalFilterForm();
        	FilterInstanceM fim = new FilterInstanceM();
        	fim.setInstanceId(instanceId);
        	List<FilterInstanceM>  fins = chartService.getFilterInstanceWithItem(fim);
        	if(fins!=null && fins.get(0)!=null & fins.get(0).getFilterList()!=null){
        		filterForm.setFilterList(fins.get(0).getFilterList());
        	}
        }
        //
        CommentM commentM = chartService.findCommentById(instanceId);
        if(commentM!=null)
        filterForm.setComment(commentM.getComment());
        
        // retrive submit global filter value
//        List<FilterM> globalFilter = new ArrayList<FilterM>();
//        if (model.containsAttribute("FilterMList")) {
//        	globalFilter = (ArrayList<FilterM>) model.asMap().get("FilterMList");
//        }
//        else{ // visit first  No submit action
//        	FilterInstanceM fim = new FilterInstanceM();
//        	fim.setInstanceId(instanceId);
//        	List<FilterInstanceM>  fins = chartService.getFilterInstanceWithItem(fim);
//        	if(fins!=null){
//	        	for(FilterInstanceM fin : fins){
//	        		globalFilter.add(fin.getFilterM());
//	        	}
//        	} // have fins
//        }
        
        model.addAttribute("globalFilterForm",filterForm);
        model.addAttribute("textType",DefaultConstant.filterTypeList.get(0)); // input text
        model.addAttribute("selectType",DefaultConstant.filterTypeList.get(1)); // select
        model.addAttribute("multipleType",DefaultConstant.filterTypeList.get(2)); // multiple
        return "filter/showFilter";
    }

    @RequestMapping(params = "action=doSubmit") // action phase
    public void doSubmit(javax.portlet.ActionRequest request, javax.portlet.ActionResponse response,
                             @ModelAttribute("globalFilterForm") GlobalFilterForm filterForm,
                             BindingResult result, Model model) {

       // get initial filter instance for compare
       //FilterInstanceM fim = new FilterInstanceM();
       PortletSession session = request.getPortletSession();
       String instanceId = (String) session.getAttribute("instanceId",PortletSession.PORTLET_SCOPE);
      // psession.getAttribute(key, PortletSession.APPLICATION_SCOPE);
       
       //fim.setInstanceId(instanceId);
   	   //List<FilterInstanceM>  fins = chartService.getFilterInstanceWithItem(fim);
       //List<FilterM> gFilters = new ArrayList<FilterM>(); // new for return & send to common
       //for(FilterInstanceM fin : filter){ 
       for(FilterM f : filterForm.getFilterList()){

           logger.info(" global " + f.getValueType());
       	   //FilterM f = fin.getFilterM();
    	   String val = null;
    	   //   connId , filterId ,  value = g_filter_${connId}_${filterId}
    	   if( f.getValueType().equals(DefaultConstant.filterTypeList.get(0) ) ){
        	    val = request.getParameter("g_filter_"+f.getConnId()+"_"+f.getFilterId());
        	   f.setSelectedValue(val);
        	
    	   }else if( f.getValueType().equals(DefaultConstant.filterTypeList.get(1) ) ){
        	    val = request.getParameter("g_filter_"+f.getConnId()+"_"+f.getFilterId());
        	   f.setSelectedValue(val);
           	
    	   }else if ( f.getValueType().equals(DefaultConstant.filterTypeList.get(2) ) ){
    		   String[] vals = request.getParameterValues("g_filter_"+f.getConnId()+"_"+f.getFilterId());
		       logger.info(" global v raw:"+vals);

    		   val = StringUtils.join(vals, ",");

    		       logger.info(" global v:"+val);
    		   f.setSelectedValue(val);
    	   }
    	   //gFilters.add(f);
       }
       
       /*
       for(int i = 0 ; i<gFilters.size();i++){
    	   // map  name select in view showfilter.jsp  format  g_filter_+filterM.filterId
    	   String val = request.getParameter("g_filter_"+gFilters.get(i).getFilterId());
    	   if(val!=null ){
    		   if(!val.trim().equals("")){
    			   gFilters.get(i).setSelectedValue(val);
    		   		reRenFilters.add(gFilters.get(i));
    		   }
    	   }
       	}*/
       // portlet to portlet  require configuration  portlet.xml
        FilterInstanceM globalFilterIns = new FilterInstanceM();
        globalFilterIns.setFilterList(filterForm.getFilterList());
       	QName qname = new QName("http://liferay.com/events","paramOverride","x");
       	response.setEvent(qname, globalFilterIns); 
        
        //re show 
       //model.addAttribute("FilterMList", gFilters);
    }
    @ResourceMapping(value="cascadeGlobalFilter")
	@ResponseBody 
	public void cascadeGlobalFilter(ResourceRequest request,ResourceResponse response) throws IOException{
    	//for cascade parameter
    	JSONObject json = JSONFactoryUtil.createJSONObject();
    	JSONObject header = JSONFactoryUtil.createJSONObject();
    	JSONArray content = JSONFactoryUtil.createJSONArray();
       	String message = "พบปัญหาที่ ";
       	header.put("status","success");
    	
    	ThemeDisplay themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
    	String instanceId=themeDisplay.getPortletDisplay().getInstanceId();
    	
    	HttpServletRequest httpReq = PortalUtil.getHttpServletRequest(request);
		HttpServletRequest normalRequest	=	PortalUtil.getOriginalServletRequest(httpReq);
    	String causeFilterId = normalRequest.getParameter("filterId");
    	String factorString = normalRequest.getParameter("factor");
    	// format factorStrung  =  "filterId::filterValue||filterId::filterValue"
    	FilterInstanceM fin = new FilterInstanceM();  
    	fin.setInstanceId(instanceId);
    	fin.setFilterList( decriptCascadeString(factorString,causeFilterId) );
    	List<FilterM> filters = chartService.cascadeFilterItems(fin); //
    	for(FilterM filter : filters){
    		if(!filter.getFilterId().equals(causeFilterId)){  //  insert only rerender element 
	    		JSONObject fo = JSONFactoryUtil.createJSONObject();
	    		fo.put("connId",filter.getConnId());
	    		fo.put("id", filter.getFilterId());
	    		fo.put("value", filter.getSelectedValue());
	    		JSONArray foItem = JSONFactoryUtil.createJSONArray();
	    		if(filter.getFilterValues()!=null){
		    		for(FilterValueM fv : filter.getFilterValues()){
		    			JSONObject fov = JSONFactoryUtil.createJSONObject();
		    			fov.put("key",fv.getKeyMapping());
		    			fov.put("desc", fv.getValueMapping());
		    			foItem.put(fov);
		    		}
		    		fo.put("item", foItem);
		        	content.put(fo);
	    		}else{ // fv  == null
	    			message = message +" "+filter.getFilterName();
	    			header.put("status","error");
	    		}
    		}
    	}
    	json.put("content", content);
    	header.put("message",message);
    	json.put("header",header);
		response.getWriter().write(json.toString());
		// ** important **  map filter to session attr 
        PortletSession portletSession = request.getPortletSession();  
        GlobalFilterForm form = (GlobalFilterForm) portletSession.getAttribute("globalFilterForm" ,PortletSession.PORTLET_SCOPE);
		if(form!=null && form.getFilterList()!=null){
			for(FilterM formFilter : form.getFilterList()){
		        for(FilterM filter : filters){
		        	 if(formFilter.getFilterId().equals(filter.getFilterId())){
						 formFilter.setFilterValues(filter.getFilterValues());
						 formFilter.setSelectedValue(filter.getSelectedValue());
					 }
				}
			}
	        portletSession.setAttribute("globalFilterForm" ,form,PortletSession.PORTLET_SCOPE);
		}
    }
    private List<FilterM> decriptCascadeString(String cascadeString,String causeFilterId){
    	 List<FilterM> filters = new ArrayList<FilterM>();
    	 // example string =  "filterId::filterValue||filterId::filterValue"
    	String filterLimit = ":#:";
     	String seperate = ":&:";
     	
     	String[] gs = cascadeString.split(filterLimit);
     	for( String g : gs){
 	    		String[] gkv = g.split(seperate);  // [0] = connId  ,[1]=filter id , [2] = value
 	    			FilterM gm = new FilterM();
 	    			gm.setConnId( Integer.valueOf( gkv[0] ) );
	 	    		gm.setFilterId( Integer.parseInt( (String)gkv[1] ) );
	 	    		gm.setSelectedValue( (String)gkv[2] );
	 	    		gm.setActiveFlag("1");
	 	    		if( ((String)gkv[1].toString()).equals(causeFilterId)){
	 	    			gm.setActiveFlag("0"); // important !! mark* cause filter  
	 	    		}
	 	    		filters.add(gm);
     	} // end loop
    	 return filters;
    }
}
