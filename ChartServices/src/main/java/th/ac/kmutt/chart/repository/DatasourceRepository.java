package th.ac.kmutt.chart.repository;

import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.transaction.Transactional;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.hibernate.exception.SQLGrammarException;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.google.gson.Gson;

import th.ac.kmutt.chart.constant.DefaultConstant;
import th.ac.kmutt.chart.constant.ServiceConstant;
import th.ac.kmutt.chart.domain.DatasourceConnectionEntity;
import th.ac.kmutt.chart.domain.FilterEntity;
import th.ac.kmutt.chart.domain.ServiceEntity;
import th.ac.kmutt.chart.exception.DsException;
import th.ac.kmutt.chart.model.FilterM;
import th.ac.kmutt.chart.model.FilterParamM;
import th.ac.kmutt.chart.model.FilterValueM;
import th.ac.kmutt.chart.rest.application.SystemSetting;


@Repository("datasourceRepository")
@Transactional
public class DatasourceRepository {
    private static final Logger logger = Logger.getLogger(ServiceConstant.LOG_APPENDER);
    
    @Autowired
    @PersistenceContext(unitName = "HibernatePersistenceUnit")
    private EntityManager entityManager;
    
    public EntityManager connectDS(Integer dsid) throws Exception{
   	try{
    		if(!SystemSetting.existConnects()){
    			logger.info("load connection. . .");	
    			System.out.println("load connection. . .");
    			loadEm();
    		}
    		EntityManager em = SystemSetting.getConnects(dsid.toString());
    		return em;
    	}catch(Exception e){
    		logger.error(" Exception datasourceRepo.connectDS  not found dsConfig at id [" +dsid+ "] reason="+e.getCause());
    		throw new DsException("  DS error" );
    	}
    }
    public void loadEm(){
        	try {
    			List<DatasourceConnectionEntity> dsConfigList = listConnection();
    			if(dsConfigList!=null){
    				for(DatasourceConnectionEntity dsConfig : dsConfigList){
    					try{
    						createEm(dsConfig);
    						logger.debug(" success loaded  "+dsConfig.getConnId());
    					}catch(Exception e){
    						logger.error(" fail to load dataSource at con:"+dsConfig.getConnId());
    					}
    				}
    			}
    		} catch (Exception e) {
    			logger.error(" exception at load entity manager dwh reason="+e.getStackTrace());
    		}// end
    }

	public List<DatasourceConnectionEntity> listConnection() throws Exception{
		String sql = "select s from DatasourceConnectionEntity s";
		Query q = entityManager.createQuery(sql, DatasourceConnectionEntity.class);
		return q.getResultList();
	}
    public void createEm(DatasourceConnectionEntity dsConfig){
    	String conName = dsConfig.getConnId().toString();
    	Map<String, String> properties = new HashMap<String, String>();
    	properties.put("hibernate.connection.driver_class",dsConfig.getDriverClass());
    	properties.put("hibernate.connection.url",dsConfig.getConnString());
    	properties.put("hibernate.connection.username", dsConfig.getUsername());
    	properties.put("hibernate.connection.password", dsConfig.getPassword());
    	properties.put("hibernate.dialect", dsConfig.getDialect());
    	properties.put("hibernate.show-sql", "true");
    	
    	EntityManagerFactory emf = Persistence.createEntityManagerFactory("HibernatePersistenceUnitDwh",properties);
    	EntityManager em = emf.createEntityManager();
    	System.out.println(" create persistence manager success at con:"+conName);
    	logger.debug(" create persistence manager success at con:"+conName);
    	SystemSetting.addConnects(conName, em);
    	System.out.println(" store persistence manager success at con:"+conName);
    	logger.debug(" store persistence manager success at con:"+conName);
    }
    
    @SuppressWarnings("unchecked")
	public List<Object[]> fetchChartResultSet(DatasourceConnectionEntity dsCon,ServiceEntity seSetting,List<FilterM> filters) throws Exception{
		logger.info("chart result set =>  fetch "+dsCon.getConnId()+":"+dsCon.getConnName()+" "+seSetting.getServiceId()+":"+seSetting.getServiceName()+" filter total "+filters.size());
		List<Object[]>  results  = new ArrayList<Object[]>();
		StringBuffer sb = new StringBuffer();
		try{
			String sql = seSetting.getSqlString();
			EntityManager em = connectDS(seSetting.getConnId());
			Query query = em.createNativeQuery(sql);
			for( FilterM filter : filters ){
				System.out.println(">filter " +filter.getFilterId()+ " "+filter.getFilterName() + " "+filter.getValueType()+ " "+filter.getSelectedValue());
				
				Object value = transformSelectedValueToObject(filter.getValueType(),filter.getSelectedValue());
			//	System.out.println("fetch Chart Param:"+filter.getFilterName()+":"+filter.getSelectedValue());
				if(  sql.contains(":"+filter.getFilterName()) || sql.contains(":"+filter.getFilterName()+"\r\n") || sql.contains(":"+filter.getFilterName()+")")   ){ // check param syntax in sqlQuery		
					query.setParameter(filter.getFilterName(),value);
					sb.append(" replace "+filter.getFilterName() +" value "+ value + "    ");
				}
			}
			results = query.getResultList();
			logger.debug("return result chart "+seSetting.getServiceId());
		}catch(DsException ex){
			logger.error(" datasource exception at conId "+seSetting.getConnId()+" service "+seSetting.getServiceId()+" "+seSetting.getServiceName()+" msg "+ex.getMessage());
		}catch(SQLGrammarException e){
			logger.error(" Sql query exception at conId "+seSetting.getConnId()+" service "+seSetting.getServiceId()+" "+seSetting.getServiceName()+" msg "+e.getMessage()+" \r\n additional "+sb.toString());	
		}catch(Exception ex){
			logger.error("chart result set => exception at conId "+seSetting.getConnId()+" Service "+seSetting.getServiceId()+":"+ seSetting.getServiceName()+"  reason="+ex.getMessage()+" \r\n additional "+sb.toString()  );
			//ex.printStackTrace();
		}finally{
			sb.delete(0,sb.length());
		}
		return results;
	}
	
	public Object transformSelectedValueToObject(String type,String valueString){
		if(valueString!=null && type!=null){
			if( type.equals(DefaultConstant.filterTypeList.get(0).toString() ) ){
				//Manual Input
				return valueString;
			}else if( type.equals(DefaultConstant.filterTypeList.get(1).toString()) ){
				// select
				return valueString;
			}else if ( type.equals(DefaultConstant.filterTypeList.get(2).toString()) ){
				// multi select
					String[] vs = valueString.split(",");
					List<String>  arrayList = Arrays.asList(vs);
					return arrayList;
			}else{
				return valueString;
			}
		}else{
			return valueString;
		}
	}
	
	public String transformSelectedValue(String type,String valueString){
		if(valueString!=null && type!=null){
		
			if( type.equals(DefaultConstant.filterTypeList.get(0).toString() ) ){
				//Manual Input
			}else if( type.equals(DefaultConstant.filterTypeList.get(1).toString()) ){
				// select
			}else if ( type.equals(DefaultConstant.filterTypeList.get(2).toString()) ){
				// multi select
					String[] vs = valueString.split(",");
					valueString = StringUtils.join(vs,",");
			}
		
		}else{
		}
		return valueString;
	}
	
	
	public List<FilterValueM> fetchFilterValueCascade(FilterEntity fe,List<FilterM> filters)  {
		try{
			// normal filter
			//logger.info("fetch filter value cascade "+fe.getFilterId()+":"+fe.getFilterName());
		 	EntityManager em = connectDS(fe.getConnId()); 
			Query query = em.createNativeQuery(fe.getSqlQuery());
			for( FilterM filter : filters ){
				
				// Get parameter values
				Object value = transformSelectedValueToObject(filter.getValueType(),filter.getSelectedValue());
				
				if(  fe.getSqlQuery().contains(":"+filter.getFilterName()) && !filter.getFilterId().equals(fe.getFilterId()) ){ 
					query.setParameter(filter.getFilterName(),value);
				}
				
			}
			List<Object[]> results = query.getResultList();
			List<FilterValueM> fvs = new ArrayList<FilterValueM>();
			
			for(Object[] result : results){
				fvs.add(buildFilterItems(result));
			}
			//em.clear();
			//logger.info("return result filter value cascade "+fe.getFilterId()+":"+fe.getFilterName());			
			return fvs;
			//return null;
	  }catch(Exception ex){
		  System.out.println(" break "+fe.getFilterId());
			logger.error(" Break filterValue cascade : Exception  at filter id="+fe.getFilterId()+ "  reason="+ex);
			//return  new ArrayList<FilterValueM>();
			ex.printStackTrace();
			return null;
	  }
	}
	
	
	@SuppressWarnings("unchecked")
	public List<FilterM> fetchFilterValueCascade_v2(List<FilterParamM> paramMs) {
		logger.info(":: Msg --Start--> Fetch filter value cascade v2");
		List<FilterM> filters = new ArrayList<FilterM>();
		
		try{
			for (FilterParamM paramM : paramMs) {
				// Model Mapping (FilterParamM : FilterM)
				FilterM filter = new FilterM();				
				EntityManager em = connectDS(paramM.getConnId());
				Object value = transformSelectedValueToObject(paramM.getParamValueType(),paramM.getParamSelectedValue());
				Query query = em.createNativeQuery(paramM.getSqlQuery());
				
				if (paramM.getParamFilterId() != null) {
					query.setParameter(paramM.getParamFilterName(), value);
				}
				
				List<Object[]> results = query.getResultList();
				List<FilterValueM> fvs = new ArrayList<FilterValueM>();
				
				for(Object[] result : results){
					fvs.add(buildFilterItems(result));
				}
				
				BeanUtils.copyProperties(paramM, filter);
				
				filter.setFilterValues(fvs);
				
				filters.add(filter);
			}
			
			logger.info(":: Msg --Finish--> Fetch filter value cascade v2");
			return filters;
		}catch(Exception ex){
			logger.error(" Break filterValue reason="+ex);
			//return  new ArrayList<FilterValueM>();
			ex.printStackTrace();
			return null;
		}
	}

	
	public FilterValueM buildFilterItems(Object[] rf){
		FilterValueM fv = new FilterValueM();
		if(rf.length==1){
			// Can't be. Always return List<Object[]>
			//fv.setKeyMapping((String)rf[0]);
			//fv.setValueMapping((String)rf[0]);
		}else if(rf.length==2){
			fv.setKeyMapping((String)rf[0].toString());  
			fv.setValueMapping((String)rf[1].toString());
		}else{
		}
		return fv;
	}
}