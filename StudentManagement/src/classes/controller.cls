public with sharing class Controller {
	public List<Output> OutputList {get;set;}
	public KeySearchDTO objKeySearch {get; set;}
	public String userinput {get; set;}
	public String userselect {get; set;}
	public String userselectSecondpage {get; set;}
	public String sumstudents {get;set;}
	public String idStudent {get;set;}
	public Boolean isColumnChecked {get; set;}
	public Student__c student {get; set;}
	public Controller(){
		this.student = new Student__c();
		this.objKeySearch = new KeySearchDTO();
	}

	public class KeySearchDTO{
		public Boolean increasing {get; set;}
		public Student__c studentName {get; set;}
		public String className {get; set;}
		public Student__c objStudentTo {get; set;}
		public Student__c objStudentFrom {get; set;}

		public KeySearchDTO() {
			this.objStudentFrom = new Student__c();
			this.objStudentTo = new Student__c();
			this.increasing = false;
			this.studentName = new Student__c();
			this.className = '';
		}
	}

	public class Output{
		public Student__c student {get; set;}
		public Boolean isSelected {get; set;}
		public Output(Student__c s){
			this.student = s;
			this.isSelected = false;
		}
	}
	
	public PageReference dosubmit(){
	    PageReference pr = new PageReference('/apex/AddNewStudent');
	    pr.setRedirect(true);
	    return pr;
	}

	public PageReference goBack(){
		PageReference pg = new PageReference('/apex/MainPage');
	    pg.setRedirect(true);
	    return pg;
	}

	public List<SelectOption> getItems(){
		List<SelectOption> options = new List<SelectOption>();
		List<Class__c> data = [SELECT className__C from Class__c];
		for (Class__c c : data){
			options.add(new SelectOption((String)c.get('className__c'),(String)c.get('className__c')));
		}

		return options;
	}

	private List<Output> getStudent(){
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
										WHERE Name LIKE: this.objKeySearch.studentName.Name
										OR Class__r.Name LIKE: this.objKeySearch.className
										OR (Student__c.Birthday__c > :this.objKeySearch.objStudentFrom.Birthday__c
										AND Student__c.Birthday__c < :this.objKeySearch.objStudentFrom.Birthday__c) ];
		List<Output> result = new List<Output>();
		for(Student__c s : studentGetList){
			result.add(new Output(s));
		}
		if(this.objKeySearch.increasing){
			result.sort();
		}
		return result;
	}

	public PageReference doInsert(){
		PageReference ref = null;
		try{

			Class__c  c = [SELECT id
					FROM Class__c
					WHERE className__c =: this.userselectSecondpage];
			this.student.Class__c = c.id;
			insert this.student;
			ref = new PageReference('/apex/AddNewStudent');
			ref.setRedirect(true);
		} catch(Exception ex){
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
		}

		return ref;
	}

	public PageReference actionDeleteStudentBeSelected(){
		System.debug('delete');
		for(Output s : this.OutputList){
			System.debug(s.isSelected + ' result selected');
			if(s.isSelected == true){
				delete s.student;
			}
		}
		this.actionSearch();
		return null;
	}

	public PageReference actionDeleteStudent(){
		String idStudentGet = ApexPages.CurrentPage().getParameters().get('idStudent');
		for(Output s : this.OutputList){
			if(idStudentGet.equalsIgnoreCase(s.student.StudentId__c)){
				delete s.student;
			}
		}
		this.actionSearch();

		return null;
	}

	public void actionSearch() {
		try {
			if(String.isBlank(this.objKeySearch.studentName.Name)){
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'name can not be empty'));
				return;
			}
			this.OutputList = this.getStudent();
			sumstudents =  'Total Students : '+ this.OutputList.size();
		} catch(Exception ex) {
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
		}
	}
}
//https://developer.salesforce.com/docs/atlas.en-us.pages.meta/pages/pages_compref_actionFunction.htm
// use acctionfunction for any button
// https://developer.salesforce.com/forums/?id=906F0000000BKD1IAO