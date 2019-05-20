public with sharing class Controller {
	public List<StudentDTO> objStudentList {get;set;}
	public KeySearchDTO objKeySearch {get; set;}
	public String userinput {get; set;}
	public String userselect {get; set;}
	public String classNameInserting {get; set;}
	public String sumStudents {get;set;}
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

	public class StudentDTO{
		public Student__c student {get; set;}
		public Boolean isSelected {get; set;}
		public StudentDTO(Student__c s){
			this.student = s;
			this.isSelected = false;
		}
		public StudentDTO(){}
	}
	public PageReference doDetails(){
	    String idStudentGetting = ApexPages.CurrentPage().getParameters().get('idStudent');
	    PageReference pr =  new PageReference('/apex/StudentDetails?id=' + idStudentGetting);
	    return pr;
	}

	public PageReference goUpdateStudent(){
		String idStudentGetting = ApexPages.CurrentPage().getParameters().get('idStudent');
		PageReference pr =  new PageReference('/apex/UpdateStudent?id=' + idStudentGetting);
	    return pr;
	}

	public PageReference doSubmit(){
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
		List<Class__c> classList = [SELECT className__C 
								FROM Class__c];
		for (Class__c c : classList){
			options.add(new SelectOption((String)c.get('className__c'),(String)c.get('className__c')));
		}
		return options;
	}

	private List<StudentDTO> getStudent(){
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
		List<StudentDTO> result = new List<StudentDTO>();
		for(Student__c s : studentGetList){
			result.add(new StudentDTO(s));
		}
		return this.sort(result, this.objKeySearch.increasing);
		 
	}
	private List<StudentDTO> sort(List<StudentDTO> l, Boolean increasing){
		List<StudentDTO> result = new List<StudentDTO>();
		if(increasing){
			while(!l.isEmpty()){
				String max = l.get(0).student.Namef__c;
				StudentDTO maxObj = l.get(0);
				for(StudentDTO o :l){
					if(o.student.Namef__c.compareTo(max) > 0){
						max = o.student.Namef__c;
						maxObj = o;
					}
				}
				result.add(new StudentDTO(maxObj.student));
				l.remove(l.indexOf(maxObj));
			}
		}else{
			while(!l.isEmpty()){
				String min = l.get(0).student.Namef__c;
				StudentDTO minObj = l.get(0);
				for(StudentDTO o :l){
					if(o.student.Namef__c.compareTo(min) < 0){
						min = o.student.Namef__c;
						minObj = o;
					}
				}
				result.add(new StudentDTO(minObj.student));
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
					WHERE className__c =: this.classNameInserting];
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
		for(StudentDTO s : this.objStudentList){
			if(s.isSelected == true){
				delete s.student;
			}
		}
		this.actionSearch();
		return null;
	}

	public PageReference actionDeleteStudent(){
		String idStudentGetting = ApexPages.CurrentPage().getParameters().get('idStudent');
		for(StudentDTO s : this.objStudentList){
			if(idStudentGetting.equalsIgnoreCase(s.student.id)){
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
			this.objStudentList = this.getStudent();
			this.sumStudents =  'Total Students : '+ this.objStudentList.size();
		} catch(Exception ex) {
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));
		}
	}
}
//https://developer.salesforce.com/docs/atlas.en-us.pages.meta/pages/pages_compref_actionFunction.htm
// use acctionfunction for any button
// https://developer.salesforce.com/forums/?id=906F0000000BKD1IAO