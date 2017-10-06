package th.ac.kmutt.chart.form;

import java.io.Serializable;
import java.util.List;

import th.ac.kmutt.chart.model.FilterM;

public class ChartCommonForm extends CommonForm implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -195522688103034094L;
	
	private String instanceId;
	private List<FilterM> filterService;
	private List<FilterM> filterGlobal;
	private List<FilterM> filterInternal;
	public String getInstanceId() {
		return instanceId;
	}
	public void setInstanceId(String instanceId) {
		this.instanceId = instanceId;
	}
	public List<FilterM> getFilterService() {
		return filterService;
	}
	public void setFilterService(List<FilterM> filterService) {
		this.filterService = filterService;
	}
	public List<FilterM> getFilterGlobal() {
		return filterGlobal;
	}
	public void setFilterGlobal(List<FilterM> filterGlobal) {
		this.filterGlobal = filterGlobal;
	}
	public List<FilterM> getFilterInternal() {
		return filterInternal;
	}
	public void setFilterInternal(List<FilterM> filterInternal) {
		this.filterInternal = filterInternal;
	}
}
