public with sharing class CommandButtonParamController {
	// an instance varaible for the standard controller
	private ApexPages.StandardController controller {get; set;}
	 // the object being referenced via url
	private Student__c student {get;set;}
	// the variable being set from the commandbutton
	public String idStudent {
		get;
		// *** setter is NOT being called ***
		set {
			idStudent = value;
			System.debug('value: '+value);
		}
	}
	public CommandButtonParamController(ApexPages.StandardController controller) {
		//initialize the stanrdard controller
	    this.controller = controller;
	    // load the current record
	    this.student = (Student__c)controller.getRecord();
	}
	public PageReference processButtonClick() {
		System.debug('nickName: '+idStudent);
		// now process the variable by doing something...
		return null;
}
}