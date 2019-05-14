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
		String idStudent =  apexpages.currentpage().getparameters().get('id');
		this.getStudentDetails(idStudent);
	}

	private void getStudentDetails(String idStudent){
		Student__c s = 			[SELECT 
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
		    					WHERE id =: idStudent];

		this.lastNameDetails = s.Namel__c;
		this.firstNameDetails = s.Namef__c;
		if(s.Gender__c){
			this.genderDetails = 'Female';
		}else{
			this.genderDetails = 'Male';
		}
		this.birthdayDetails = s.Birthday__c.format();
		this.score1Details = s.Score1__c;
		this.score2Details = s.Score2__c;
		this.score3Details = s.Score3__c;
		this.averageScoreDetails = s.AverageScore__c;
		this.stateDetails = s.State__c;
	}

	public PageReference goBack(){
		PageReference pg = new PageReference('/apex/MainPage');
	    pg.setRedirect(true);
	    return pg;
	}
	public PageReference goUpdate(){
		String idStudent =  apexpages.currentpage().getparameters().get('id');
		PageReference pg = new PageReference('/apex/UpdateStudent?id='+idStudent);
	    pg.setRedirect(true);
	    return pg;
	}
	public void actionDeleteStudent(){
		try{
			String idStudent =  apexpages.currentpage().getparameters().get('id');
			Student__c s = [SELECT id 
							FROM Student__c 
							WHERE id =: idStudent];
			delete s;
		} catch(Exception ex){
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
		}
		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'delete success'));
	}
}