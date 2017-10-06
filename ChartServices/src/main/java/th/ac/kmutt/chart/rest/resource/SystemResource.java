package th.ac.kmutt.chart.rest.resource;

import org.apache.log4j.Logger;
import org.hibernate.exception.ConstraintViolationException;
import org.restlet.Request;
import org.restlet.data.Form;
import org.restlet.data.MediaType;
import org.restlet.data.Method;
import org.restlet.data.Reference;
import org.restlet.data.Status;
import org.restlet.engine.resource.MethodAnnotationInfo;
import org.restlet.representation.Representation;
import org.restlet.representation.StringRepresentation;
import org.restlet.representation.Variant;
import org.restlet.resource.Get;
import org.restlet.resource.ResourceException;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.thoughtworks.xstream.io.StreamException;

import th.ac.kmutt.chart.model.SystemM;
import th.ac.kmutt.chart.rest.application.SystemSetting;
import th.ac.kmutt.chart.service.impl.DatasourceService;
import th.ac.kmutt.chart.xstream.common.ImakeResultMessage;

import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

import javax.annotation.PostConstruct;

public class SystemResource  extends BaseResource {
    //private static final Logger logger = Logger.getLogger(ServiceConstant.LOG_APPENDER);
    @Autowired
    @Qualifier("datasourceService")
    private DatasourceService dataService;

    @Autowired
    private com.thoughtworks.xstream.XStream xstream;
    @Autowired
    private com.thoughtworks.xstream.XStream jsonXstream;

    public SystemResource() {
        super();
        logger.debug("SystemResource constructor");
    }

    @Override
    protected void doInit() throws ResourceException {
        super.doInit();
        logger.debug("SystemResource  doInit");
    }
    @Get("v1")
    public void login(){
    	
    }
    @Override
    protected Representation get() {
    	// 
    	return null;
    }
    @Override
    protected Representation post(Representation entity, Variant variant)
            throws ResourceException {
        logger.debug("SystemResource  Post  ");
        ImakeResultMessage resMes = new ImakeResultMessage();
        InputStream in = null;
        SystemM xsource = null;
        try {      
            Form form = new Form(entity);
            logger.debug("get serviceName="+form.getFirstValue("sname"));
            if(form.getFirstValue("sname")==null){
            	return null;
            }
            xsource = new SystemM();
            //map params
            xsource.setServiceName(form.getFirstValue("sname"));
            if(form.getFirstValue("conn")!=null ){
            	xsource.setConName(form.getFirstValue("conn"));
            }
            
            // all handle 
            if(xsource.getServiceName().equals(SystemSetting.serviceNewConns)){
            	dataService.createEm();
            	return getRepresentation(entity,resMes,xstream);
            }
            else if(xsource.getServiceName().equals(SystemSetting.serviceStatConns)){
            	String msg = dataService.statEm();
            	return new StringRepresentation("Return sname: "+xsource.getServiceName()+"  messge: "+msg+"\r\n");
            	//return getRepresentation(entity,resMes,xs\tream);
            }
            else if(xsource.getServiceName().equals(SystemSetting.serviceDeleteConns)){
            	dataService.deleteEm(xsource.getConName());
            	System.out.println(" del success");
            	return getRepresentation(entity,resMes,xstream);
            }
            else if(xsource.getServiceName().equals(SystemSetting.serviceGetConns)){
            	
            	// implement here
            	
            	return getRepresentation(entity,resMes,xstream);
            }
            else if(xsource.getServiceName().equals(SystemSetting.serviceLoadConns)){
            	String loadMsg = dataService.loadEm();
            	// implement here
            	return new StringRepresentation("Return sname: "+xsource.getServiceName()+"  message: "+loadMsg+"\r\n");
            }
            else if(xsource.getServiceName().equals(SystemSetting.serviceCloseConns)){
            	
            	String msg = dataService.closeEm();
            	return new StringRepresentation("Return sname: "+xsource.getServiceName()+"  message: "+msg+"\r\n");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }   
   

        return null;
    }
}