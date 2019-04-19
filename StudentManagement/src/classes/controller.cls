public with sharing class Controller {
	public List<Student__c> studentList {get;set;}
	public String userinput {get; set;}
	public String userselect {get; set;}
	public String sumstudents {get;set;}
	public String idStudent {get;set;}
	public Boolean isColumnChecked {get; set;}

	public void deleteAllStudents(){
		if(isColumnChecked){
			//for(Student__c s : this.studentList){
			//	delete s;
			//} 
		}
		//this.actionSearch();
	}


	public List<SelectOption> getItems(){
		List<SelectOption> options = new List<SelectOption>();
		List<Class__c> data = [SELECT className__C from Class__c];
		for (Class__c c : data){
			options.add(new SelectOption((String)c.get('className__c'),(String)c.get('className__c')));
		}

		return options;
	}
	private List<Student__c> getStudent(){
		String selectName = '%'+ userinput + '%';
		String selectClass = '%' + userselect + '%';
		List<Student__c> studentGetList = [SELECT Namef__c
												,Namel__c
												,Birthday__c
												,Gender__c
												,Score1__c
												,Score2__c
												,Score3__c
												,AverageScore__c
												,State__c
												,StudentId__c	 
										FROM Student__c
										WHERE Name LIKE: selectName OR Class__r.Name LIKE: selectClass];
		return studentGetList;
	}
	public PageReference actionDeleteStudent(){
		String idStudentGet = ApexPages.CurrentPage().getParameters().get('idStudent');
		for(Student__c s : this.studentList){
			if(idStudentGet.equalsIgnoreCase(s.StudentId__c)){
				delete s;
			}
		} 
		this.actionSearch();

		return null;
	}
	public void actionSearch() {
		try {
			if(String.isBlank(this.userinput)){
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'input from user can not be empty'));
				return;
			}
			this.studentList = this.getStudent();
			sumstudents =  'Total Students : '+ this.studentList.size();
		} catch(Exception ex) {
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
		}
	}
}
//https://developer.salesforce.com/docs/atlas.en-us.pages.meta/pages/pages_compref_actionFunction.htm
// use acctionfunction