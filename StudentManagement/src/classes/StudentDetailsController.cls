public with sharing class StudentDetailsController {
	public String lastNameDetails {get; set;}
	public String firstNameDetails {get; set;}
	public String genderDetails {get; set;}
	public String birthdayDetails {get; set;}
	public Double score1Details {get; set;}
	public Double score2Details {get; set;}
	public Double score3Details {get; set;}
	public Double averageScoreDetails {get; set;}
	public String stateDetails {get; set;}

	public StudentDetailsController() {
		String studentId =  apexpages.currentpage().getparameters().get('id');
		this.getStudentDetails(studentId);
	}

	private void getStudentDetails(String studentId){
		Student__c student = 	[SELECT 
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

		this.lastNameDetails = student.Namel__c;
		this.firstNameDetails = student.Namef__c;
		if(student.Gender__c){
			this.genderDetails = 'Female';
		}else{
			this.genderDetails = 'Male';
		}
		this.birthdayDetails = student.Birthday__c.format();
		this.score1Details = student.Score1__c;
		this.score2Details = student.Score2__c;
		this.score3Details = student.Score3__c;
		this.averageScoreDetails = student.AverageScore__c;
		this.stateDetails = student.State__c;
	}

	public PageReference goBack(){
		PageReference pg = new PageReference('/apex/MainPage');
	    pg.setRedirect(true);
	    return pg;
	}
	
	public PageReference goUpdate(){
		String studentId =  apexpages.currentpage().getparameters().get('id');
		PageReference pg = new PageReference('/apex/UpdateStudent?id='+studentId);
	    pg.setRedirect(true);
	    return pg;
	}

	public void actionDeleteStudent(){
		try{
			String studentId =  apexpages.currentpage().getparameters().get('id');
			Student__c student = [SELECT id 
								FROM Student__c 
								WHERE id =: studentId];
			delete student;
		} catch(Exception ex){
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
		}
		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'delete success'));
	}
}