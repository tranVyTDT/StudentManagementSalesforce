public with sharing class Controller {
	public List<Output> OutputList {get;set;}
	public KeySearchDTO objKeySearch {get; set;}
	public String userinput {get; set;}
	public String userselect {get; set;}
	public String userselectSecondpage {get; set;}
	public String sumstudents {get;set;}
	public String idStudent {get;set;}
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
		public Output(){}
	}
	public PageReference doDetails(){
	    String idStudentGet = ApexPages.CurrentPage().getParameters().get('idStudent');
	    PageReference pr =  new PageReference('/apex/StudentDetails?id=' + idStudentGet);
	    return pr;
	}

	public PageReference goUpdateStudent(){
		String idStudentGet = ApexPages.CurrentPage().getParameters().get('idStudent');
		System.debug(idStudentGet);
		PageReference pr =  new PageReference('/apex/UpdateStudent?id=' + idStudentGet);
	    return pr;
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
										AND Student__c.Birthday__c < :this.objKeySearch.objStudentTo.Birthday__c) ];
		List<Output> result = new List<Output>();
		for(Student__c s : studentGetList){
			result.add(new Output(s));
		}
		return this.sort(result, this.objKeySearch.increasing);
		 
	}
	private List<Output> sort(List<Output> l, Boolean increasing){
		List<Output> result = new List<Output>();
		if(increasing){
			while(!l.isEmpty()){
				String max = l.get(0).student.Namef__c;
				Output maxObj = l.get(0);
				for(Output o :l){
					if(o.student.Namef__c.compareTo(max) > 0){
						max = o.student.Namef__c;
						maxObj = o;
					}
				}
				result.add(new Output(maxObj.student));
				l.remove(l.indexOf(maxObj));
			}
		}else{
			while(!l.isEmpty()){
				String min = l.get(0).student.Namef__c;
				Output minObj = l.get(0);
				for(Output o :l){
					if(o.student.Namef__c.compareTo(min) < 0){
						min = o.student.Namef__c;
						minObj = o;
					}
				}
				result.add(new Output(minObj.student));
				l.remove(l.indexOf(minObj));
			}
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
		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'add new student success'));
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
			if(idStudentGet.equalsIgnoreCase(s.student.id)){
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