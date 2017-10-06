package th.ac.kmutt.chart.service.impl;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.persistence.EntityManager;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import th.ac.kmutt.chart.constant.ServiceConstant;
import th.ac.kmutt.chart.domain.DatasourceConnectionEntity;
import th.ac.kmutt.chart.repository.ChartRepository;
import th.ac.kmutt.chart.repository.DatasourceRepository;
import th.ac.kmutt.chart.rest.application.SystemSetting;


@Service("datasourceService")
public class DatasourceService {

    @Autowired
    @Qualifier("chartRepository")
    private ChartRepository chartRepository;
	
    @Autowired
    @Qualifier("datasourceRepository")
    private DatasourceRepository datasourceRepository;

    /*
     * Service Provider 
     * limit only local access
     */
    private static final Logger logger = Logger.getLogger(ServiceConstant.LOG_APPENDER);

    public void createEm(){
    }
    
    public void deleteEm(String name){
    	try{
	    	EntityManager em = SystemSetting.getConnects(name);
	    	if(em!=null){
	    		//em.clear();
	    		em.close();
	    		SystemSetting.deleteConnects(name);
	    	}//  end check exist
    	}catch(Exception e){
    		// null point ignore
    	}
    }
    public String statEm(){
    	return SystemSetting.statConnects();
    }
    public String loadEm(){
    	try {
    		StringBuffer allMsg = new StringBuffer();
			List<DatasourceConnectionEntity> dsConfigList = chartRepository.listConnection();
			if(dsConfigList!=null){
				for(DatasourceConnectionEntity dsConfig : dsConfigList){
					try{
						datasourceRepository.createEm(dsConfig);
//						logger.info("loaded "+dsConfig.getConnId());
						allMsg.append(" put "+dsConfig.getConnId()+" "+dsConfig.getConnName()+" success \r\n");
					}catch(Exception e){
						allMsg.append(" put "+dsConfig.getConnId()+" "+dsConfig.getConnName()+" fail \r\n");
						logger.error(" fail to load dataSource at con:"+dsConfig.getConnId());
					}
				}
			}
			return allMsg.toString();
		} catch (Exception e) {
			logger.error(" exception at load entity manager dwh reason="+e.getStackTrace());
			return "";
		}// end
    }
    public String closeEm(){
    	StringBuffer allMsg = new StringBuffer();
    	List<String> key = new ArrayList<String>();
    	try {

    		allMsg.append(" close connections \r\n");
    		Map<String,EntityManager> connects =  SystemSetting.connects;
    		Iterator<Entry<String,EntityManager>> iterator = connects.entrySet().iterator();
    		String emName="";
    
	    	while (iterator.hasNext()) {
	    			try{
		    			Map.Entry<String,EntityManager> entry = (Map.Entry<String,EntityManager>) iterator.next();
		    			emName = entry.getKey();
		    			EntityManager em = entry.getValue();
		    		//	em.clear();
		    			em.close();
		    		//	connects.remove(emName);
		    			allMsg.append(" closed key "+emName + " \r\n");
		    			key.add(emName);
	        		}catch(Exception e){
	        			e.printStackTrace();
	        			allMsg.append("  exception at key "+emName +" \r\n");
	        		}
	    	}
	    	//delete in map
	    	for(String name : key){
	    		SystemSetting.deleteConnects(name);
	    	}
    		allMsg.append(" complete ");
			return allMsg.toString();
		} catch (Exception e) {
			logger.error(" close connection exception  print trace "+e.getStackTrace());
			return allMsg.append(" close connection exception reason ").toString();
		}// end
    }

}
