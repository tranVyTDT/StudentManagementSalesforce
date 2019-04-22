public with sharing class Controller {
	public Date fDate { get; set; }
	public List<Output> OutputList {get;set;}
	public StudentSelection studentSelection {get; set;}
	public String userinput {get; set;}
	public String userselect {get; set;}
	public String userselectSecondpage {get; set;}
	public String sumstudents {get;set;}
	public String idStudent {get;set;}
	public Boolean isColumnChecked {get; set;}
	public String namef {get; set;}
	public String namel {get; set;}
	public Boolean gender {get; set;}
	public Date birthday {get; set;}
	public Decimal score1 {get; set;}
	public Decimal score2 {get; set;}
	public Decimal score3 {get; set;}
	public class StudentSelection{
		public Boolean increasing {get; set;}
		public String name {get; set;}
		public String className {get; set;}
		public Date dateFrom {get; set;}
		public Date dateTo {get; set;}
		public List<Output> outputList;
		public StudentSelection(){}
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
		List<Output> result = new List<Output>();
		for(Student__c s : studentGetList){
			result.add(new Output(s));
		}
		return result;
	}
	public PageReference doInsert(){
		PageReference ref = null;
		try{
			Class__c  c = [SELECT id
					FROM Class__c
					WHERE Name =: this.userselectSecondpage];

			Student__c student = new Student__c();
			student.Namef__c = this.namef;
			student.Namel__c = this.namel;
			student.Gender__c = this.gender;
			student.Birthday__c = this.birthday;
			student.Score1__c = this.score1;
			student.Score2__c = this.score2;
			student.Score3__c = this.score3;
			student.Name = this.namef + this.namel;
			student.Class__c = c.id;
			insert student;
			ref = new PageReference('/apex/AddNewStudent');
			ref.setRedirect(true);
		} catch(Exception ex){
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
		}

		return ref;
	}
	public PageReference actionDeleteStudentBeSelected(){
		for(Output s : this.OutputList){
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
		System.System.debug('*** object: ' );
		try {
			if(String.isBlank(this.userinput)){
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'input from user can not be empty'));
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
// use acctionfunction
// apex inputflied show table date
