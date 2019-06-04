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
        testClass = [SELECT id FROM Class__c];
        List<Student__c> testStudent= new List<Student__c>();
        testStudent.add(new Student__c(Name = 'truong vy 1'
        							, Namef__c = 'vy 1' 
						        	, Namel__c = 'truong' 
						        	, Gender__c = true 
						        	, Birthday__c = Date.newInstance(2011, 3, 21)
						        	, Score1__c = 4
						        	, Score2__c = 7
						        	, Score3__c = 9
						        	, Class__c = testClass.get(1).id));

		testStudent.add(new Student__c(Name = 'truong vy 2'
									, Namef__c = 'vy 2' 
						        	, Namel__c = 'truong' 
						        	, Gender__c = true 
						        	, Birthday__c = Date.newInstance(2011, 3, 21)
						        	, Score1__c = 4
						        	, Score2__c = 7
						        	, Score3__c = 9
						        	, Class__c = testClass.get(1).id)); 

		testStudent.add(new Student__c(Name = 'truong vy 3'
									, Namef__c = 'vy 3' 
						        	, Namel__c = 'truong' 
						        	, Gender__c = true 
						        	, Birthday__c = Date.newInstance(2011, 3, 21)
						        	, Score1__c = 4
						        	, Score2__c = 7
						        	, Score3__c = 9
						        	, Class__c = testClass.get(1).id)); 

		testStudent.add(new Student__c(Name = 'truong vy 4'
									, Namef__c = 'vy 4' 
						        	, Namel__c = 'truong' 
						        	, Gender__c = true 
						        	, Birthday__c = Date.newInstance(2011, 3, 21)
						        	, Score1__c = 4
						        	, Score2__c = 7
						        	, Score3__c = 0
						        	, Class__c = testClass.get(1).id));   

		testStudent.add(new Student__c(Name = 'truong vy 5'
									, Namef__c = 'vy 5' 
						        	, Namel__c = 'truong' 
						        	, Gender__c = true 
						        	, Birthday__c = Date.newInstance(2011, 3, 21)
						        	, Score1__c = 4
						        	, Score2__c = 0
						        	, Score3__c = 9
						        	, Class__c = testClass.get(0).id));
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
		optionsComparison.add(new SelectOption('Physics','physics'));
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
		controller.objKeySearch.className = 'Math';
		controller.objKeySearch.objStudentTo = new Student__c(Birthday__c = Date.newInstance(2000, 1, 1));
		controller.objKeySearch.objStudentFrom = new Student__c(Birthday__c = Date.newInstance(2000, 1, 1));
		
		Test.startTest();
		controller.actionSearch();
		List<Class__c> testClass = [SELECT id FROM Class__c];
		Test.stopTest();

		//setup studentComparison
		studentComparison.add(new controller.StudentDTO(new Student__c(Name = 'truong vy 5'
									, Namef__c = 'vy 5' 
						        	, Namel__c = 'truong' 
						        	, Gender__c = true 
						        	, Birthday__c = Date.newInstance(2011, 3, 21)
						        	, Score1__c = 4
						        	, Score2__c = 0
						        	, Score3__c = 9
						        	, Class__c = testClass.get(0).id)));
		studentComparison.add(new controller.StudentDTO(new Student__c(Name = 'truong vy 4'
									, Namef__c = 'vy 4' 
						        	, Namel__c = 'truong' 
						        	, Gender__c = true 
						        	, Birthday__c = Date.newInstance(2011, 3, 21)
						        	, Score1__c = 4
						        	, Score2__c = 7
						        	, Score3__c = 0
						        	, Class__c = testClass.get(1).id)));
		studentComparison.add(new controller.StudentDTO(new Student__c(Name = 'truong vy 3'
									, Namef__c = 'vy 3' 
						        	, Namel__c = 'truong' 
						        	, Gender__c = true 
						        	, Birthday__c = Date.newInstance(2011, 3, 21)
						        	, Score1__c = 4
						        	, Score2__c = 7
						        	, Score3__c = 9
						        	, Class__c = testClass.get(1).id)));
		studentComparison.add(new controller.StudentDTO(new Student__c(Name = 'truong vy 2'
									, Namef__c = 'vy 2' 
						        	, Namel__c = 'truong' 
						        	, Gender__c = true 
						        	, Birthday__c = Date.newInstance(2011, 3, 21)
						        	, Score1__c = 4
						        	, Score2__c = 7
						        	, Score3__c = 9
						        	, Class__c = testClass.get(1).id)));
		studentComparison.add(new controller.StudentDTO(new Student__c(Name = 'truong vy 1'
        							, Namef__c = 'vy 1' 
						        	, Namel__c = 'truong' 
						        	, Gender__c = true 
						        	, Birthday__c = Date.newInstance(2011, 3, 21)
						        	, Score1__c = 4
						        	, Score2__c = 7
						        	, Score3__c = 9
						        	, Class__c = testClass.get(1).id)));

		System.assertEquals(studentComparison , controller.objStudentList);
	}
}