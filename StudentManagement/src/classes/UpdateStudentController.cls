public with sharing class UpdateStudentController {

	public Student__c student {get; set;}

	public UpdateStudentController() {
		String studentId =  apexpages.currentpage().getparameters().get('id');
		this.student = [SELECT 
		    			AverageScore__c
		    			,Birthday__c
		    			,Namef__c
		    			,Namel__c
		    			,Score1__c
		    			,Score2__c
		    			,Score3__c
		    			,State__c
		    			,Gender__c
		    			FROM Student__c
		    			WHERE id =: studentId];
	}
	public void updateStudent(){
		try{
			update this.student;
		}catch(Exception ex){
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
		}
		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'delete success'));	
	}

	public PageReference goBack(){
		PageReference pg = new PageReference('/apex/MainPage');
		pg.setRedirect(true);
	   	return pg;
	}
}