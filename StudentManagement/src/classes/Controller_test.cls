@isTest
private class Controller_test
{
	@testSetup static void setup() {
        // Create common test classes and students
        List<Class__c> testClass = new List<Class__c>();
        testClass.add(new Class__c(className__c = 'English'));
        testClass.add(new Class__c(className__c = 'Math'));
        testClass.add(new Class__c(className__c = 'Physics'));
        testClass.add(new Class__c(className__c = 'Chemistry'));
        insert testClass;
        Class__c classMath = [SELECT id FROM Class__c Where className__c = 'Chemistry'];
        List<Student__c> testStudent= new List<Student__c>();
        System.debug(testClass.get(1).id);
        testStudent.add(new Student__c(Name = 'truong vy 1'
        							, Namef__c = 'vy 1' 
						        	, Namel__c = 'truong' 
						        	, Gender__c = true 
						        	, Birthday__c = Date.newInstance(2011, 3, 21)
						        	, Score1__c = 4
						        	, Score2__c = 7
						        	, Score3__c = 9
						        	, Class__c = classMath.id));

		testStudent.add(new Student__c(Name = 'truong vy 2'
									, Namef__c = 'vy 2' 
						        	, Namel__c = 'truong' 
						        	, Gender__c = true 
						        	, Birthday__c = Date.newInstance(2011, 3, 21)
						        	, Score1__c = 4
						        	, Score2__c = 7
						        	, Score3__c = 9
						        	, Class__c = classMath.id)); 

		testStudent.add(new Student__c(Name = 'truong vy 3'
									, Namef__c = 'vy 3' 
						        	, Namel__c = 'truong' 
						        	, Gender__c = true 
						        	, Birthday__c = Date.newInstance(2011, 3, 21)
						        	, Score1__c = 4
						        	, Score2__c = 7
						        	, Score3__c = 9
						        	, Class__c = classMath.id)); 

		testStudent.add(new Student__c(Name = 'truong vy 4'
									, Namef__c = 'vy 4' 
						        	, Namel__c = 'truong' 
						        	, Gender__c = true 
						        	, Birthday__c = Date.newInstance(2011, 3, 21)
						        	, Score1__c = 4
						        	, Score2__c = 7
						        	, Score3__c = 0
						        	, Class__c = classMath.id));   

		testStudent.add(new Student__c(Name = 'truong vy 5'
									, Namef__c = 'vy 5' 
						        	, Namel__c = 'truong' 
						        	, Gender__c = true 
						        	, Birthday__c = Date.newInstance(2011, 3, 21)
						        	, Score1__c = 4
						        	, Score2__c = 0
						        	, Score3__c = 9
						        	, Class__c = classMath.id));
		insert testStudent;
    }

	@isTest
	static void testGetItems()
	{
		Controller controller = new Controller();
		List<SelectOption> optionsComparison = new List<SelectOption>();
		List<SelectOption> optionsQuery = new List<SelectOption>();
		optionsComparison.add(new SelectOption('English','English'));
		optionsComparison.add(new SelectOption('Math','Math'));
		optionsComparison.add(new SelectOption('Physics','Physics'));
		optionsComparison.add(new SelectOption('Chemistry','Chemistry'));

		Test.startTest();
		optionsQuery = controller.getItems();
		Test.stopTest();
		
		System.assertEquals(optionsComparison, optionsQuery);
	}

	@isTest
	static void testGetStudent()
	{
		Controller controller = new Controller();
		List<controller.StudentDTO> studentComparison = new list<controller.StudentDTO>();
		List<controller.StudentDTO> studentQuery = new list<controller.StudentDTO>();
		//setup conditions for searching students
		controller.objKeySearch.increasing = true;
		controller.objKeySearch.studentName = new Student__c(Name = 'zzz');
		controller.objKeySearch.className = 'Chemistry';
		controller.objKeySearch.objStudentTo = new Student__c(Birthday__c = Date.newInstance(2000, 1, 1));
		controller.objKeySearch.objStudentFrom = new Student__c(Birthday__c = Date.newInstance(2000, 1, 1));
		
		Test.startTest();
		controller.actionSearch();
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
										FROM Student__c];
		Test.stopTest();

		//setup studentComparison
		for(Student__c s : studentGetList)
		{
			studentComparison.add(new controller.StudentDTO(s));
		}
		
		Controller_test a = new Controller_test();
		System.assertEquals(a.sort(studentComparison, true) , controller.objStudentList );
		
	}

	private List<controller.StudentDTO> sort(List<controller.StudentDTO> l, Boolean increasing){
		List<controller.StudentDTO> result = new List<controller.StudentDTO>();
		if(increasing){
			while(!l.isEmpty()){
				String max = l.get(0).student.Namef__c;
				controller.StudentDTO maxObj = l.get(0);
				for(controller.StudentDTO o :l){
					if(o.student.Namef__c.compareTo(max) > 0){
						max = o.student.Namef__c;
						maxObj = o;
					}
				}
				result.add(new controller.StudentDTO(maxObj.student));
				l.remove(l.indexOf(maxObj));
			}
		}else{
			while(!l.isEmpty()){
				String min = l.get(0).student.Namef__c;
				controller.StudentDTO minObj = l.get(0);
				for(controller.StudentDTO o :l){
					if(o.student.Namef__c.compareTo(min) < 0){
						min = o.student.Namef__c;
						minObj = o;
					}
				}
				result.add(new controller.StudentDTO(minObj.student));
				l.remove(l.indexOf(minObj));
			}
		}
		return result;
	}
}
// expected exist class id
// but in fact it do not need to contain class id